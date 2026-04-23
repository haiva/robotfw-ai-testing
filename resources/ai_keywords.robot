*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
# Rajapinnan asetukset
${OLLAMA_LOCAL_URL}    http://localhost:11434/api/generate
${OLLAMA_CLOUD_URL}    https://ollama.com/api/generate
${OLLAMA_API_KEY}      %{OLLAMA_API_KEY}

# Mallien valinta
# Testattava paikallinen malli
${BOT_MODEL}          gemma3:latest
# Testattava cloud-malli
# ${BOT_MODEL}           gemma4:31b-cloud
# Tuomarimalli
${JUDGE_MODEL}         mistral-large-3:675b-cloud

*** Keywords ***
Kysy HR-Botilta
    [Arguments]    ${kysymys}    ${lahdeaineisto}
    
    ${botin_ohje}=    Catenate
    ...    Olet yrityksen ystävällinen ja ammattitaitoinen HR-botti. Vastaa työntekijän kysymykseen, 
    ...    perustuen ainoastaan tähän lähdeaineistoon: ${lahdeaineisto}
    ...    Työntekijän kysymys: ${kysymys}
    
    &{headers}=    Create Dictionary    Authorization=Bearer ${OLLAMA_API_KEY}    Content-Type=application/json
    
    &{payload}=    Create Dictionary    model=${BOT_MODEL}    prompt=${botin_ohje}    stream=${False}
    
    ${api_vastaus}=    POST    url=${OLLAMA_LOCAL_URL}    json=${payload}    headers=${headers}
    ${botin_vastaus}=  Set Variable    ${api_vastaus.json()['response']}
    
    Log    HR-botti vastasi:\n${botin_vastaus}
    RETURN    ${botin_vastaus}

Vastauksen Tulisi Olla Oikein
    [Arguments]    ${kysymys}    ${botin_vastaus}    ${lähdeaineisto}    ${kriteerit}
    
    ${tuomarin_ohje}=    Catenate
    ...    Olet puolueeton laadunvarmistustuomari. Arvioi alla olevaa tekoälybotin vastausta.
    ...    Kysymys: ${kysymys}
    ...    Lähdeaineisto: ${lähdeaineisto}
    ...    Botin vastaus: ${botin_vastaus}
    ...    Arviointikriteeri: ${kriteerit}
    ...    SÄÄNTÖ: Tee arviointi. Palauta aivan lopuksi vain ja ainoastaan sana KYLLÄ tai EI.
    
    &{headers}=    Create Dictionary    Authorization=Bearer ${OLLAMA_API_KEY}    Content-Type=application/json
    
    &{payload}=    Create Dictionary    model=${JUDGE_MODEL}    prompt=${tuomarin_ohje}    stream=${False}
    
    ${api_vastaus}=    POST    url=${OLLAMA_CLOUD_URL}    json=${payload}    headers=${headers}
    ${tuomarin_päätös}=  Set Variable    ${api_vastaus.json()['response']}
    
    ${lopullinen_päätös}=    Fetch From Right    ${tuomarin_päätös}    </think>
    ${siistitty_päätös}=     Strip String        ${lopullinen_päätös}
    ${siistitty_päätös}=     Convert To Uppercase    ${siistitty_päätös}
    
    Log    Tuomari (${JUDGE_MODEL}) päätti: ${siistitty_päätös}
    
    # Jotta FOR-silmukka ei katkea ensimmäiseen hylkäykseen:
    Run Keyword And Continue On Failure    Should Be Equal    ${siistitty_päätös}    KYLLÄ

Kysy HR-Botilta Paikallisesti
    [Arguments]    ${testattava_malli}    ${kysymys}    ${lahdeaineisto}
    
    ${botin_ohje}=    Catenate
    ...    Olet yrityksen HR-botti. Vastaa työntekijän kysymykseen lyhyesti ja ytimekkäästi, 
    ...    perustuen ainoastaan tähän lähdeaineistoon: ${lahdeaineisto}
    ...    Työntekijän kysymys: ${kysymys}
    
    &{headers}=    Create Dictionary    Content-Type=application/json
    
    # MUUTOS: Käytetään 'prompt' -avainta 'messages' -listan sijaan
    &{payload}=    Create Dictionary    model=${testattava_malli}    prompt=${botin_ohje}    stream=${False}
    
    ${api_vastaus}=    POST    url=${OLLAMA_LOCAL_URL}    json=${payload}    headers=${headers}
    
    # MUUTOS: Luetaan suoraan 'response' -kenttä
    ${botin_vastaus}=  Set Variable    ${api_vastaus.json()['response']}
    
    Log    Malli (${testattava_malli}) vastasi:\n${botin_vastaus}
    RETURN    ${botin_vastaus}

Vastauksen Tulisi Olla Oikein Pilvituomarilla
    [Arguments]    ${kysymys}    ${botin_vastaus}    ${lähdeaineisto}    ${kriteerit}
    
    ${tuomarin_ohje}=    Catenate
    ...    Olet puolueeton tuomari. Arvioi alla olevaa vastausta.
    ...    Alkuperäinen kysymys: ${kysymys}
    ...    Lähdeaineisto: ${lähdeaineisto}
    ...    Testattavan botin vastaus: ${botin_vastaus}
    ...    Kriteeri: ${kriteerit}
    ...    SÄÄNTÖ: Tee arviointi. Palauta aivan lopuksi vain ja ainoastaan sana KYLLÄ tai EI.
    
    &{headers}=    Create Dictionary    Authorization=Bearer ${OLLAMA_API_KEY}    Content-Type=application/json
    
    # MUUTOS: Käytetään 'prompt' -avainta myös tuomarille
    &{payload}=    Create Dictionary    model=${JUDGE_MODEL}    prompt=${tuomarin_ohje}    stream=${False}
    
    ${api_vastaus}=    POST    url=${OLLAMA_CLOUD_URL}    json=${payload}    headers=${headers}
    
    # MUUTOS: Luetaan suoraan 'response' -kenttä
    ${tuomarin_päätös}=  Set Variable    ${api_vastaus.json()['response']}
    
    ${lopullinen_päätös}=    Fetch From Right    ${tuomarin_päätös}    </think>
    ${siistitty_päätös}=     Strip String    ${lopullinen_päätös}
    ${siistitty_päätös}=     Convert To Uppercase    ${siistitty_päätös}
    
    Log    Tuomari (${JUDGE_MODEL}) päätti: ${siistitty_päätös}
    
    # Jotta FOR-silmukka ei katkea ensimmäiseen hylkäykseen:
    Run Keyword And Continue On Failure    Should Be Equal    ${siistitty_päätös}    KYLLÄ