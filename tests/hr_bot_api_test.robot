*** Settings ***
Library     JSONLibrary
Resource    ../resources/ai_keywords.robot

*** Variables ***
${JSON_FILE_PATH}      data/hr_testdata.json
@{TESTATTAVAT_MALLIT}    gemma3:270m    gemma3:latest

*** Test Cases ***
Vertaile Mallien Hallusinaation Estoa
    [Documentation]    Testataan, miten eri mallit selviävät ansakysymyksestä.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[hallusinaation_esto][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[hallusinaation_esto][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[hallusinaation_esto][kriteerit]
    
    FOR    ${malli}    IN    @{TESTATTAVAT_MALLIT}
        Log    --- VUOROSSA MALLI: ${malli} ---
        ${botin_vastaus}=    Kysy HR-Botilta Paikallisesti    ${malli}    ${kysymys}    ${lahdeaineisto}
        Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}
    END

Testaa HR-Botin Lomavastaus
    [Documentation]    Haetaan vastaus testattavalta mallilta ja arvioidaan vastaus tuomarimallilla.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[loma_kysely][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[loma_kysely][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[loma_kysely][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Hallusinaation Esto
    [Documentation]    Testataan testattavan mallin hallusinaation esto ja arvioidaan se tuomarimallilla.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[hallusinaation_esto][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[hallusinaation_esto][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[hallusinaation_esto][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Sairauspoissaolon Ilmoittaminen
    [Documentation]    Testaa botin empatiakykyä ja oikeaa toimintaohjetta (esihenkilölle ilmoitus).
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[sairauspoissaolo][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[sairauspoissaolo][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[sairauspoissaolo][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Palkkatietojen Tietoturva
    [Documentation]    Varmistaa, ettei botti vuoda toisten työntekijöiden tietoja.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[palkkatieto_tietoturva][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[palkkatieto_tietoturva][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[palkkatieto_tietoturva][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Etätyöbudjetin Ehdot
    [Documentation]    Testaa, osaako botti kertoa tarkan summan ja kuittivaatimuksen.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[etatyobudjetti][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[etatyobudjetti][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[etatyobudjetti][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Häirinnän Nollatoleranssi
    [Documentation]    Varmistaa botin asianmukaisen ja vakavan käytöksen vakavassa asiassa.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[hairinta_nollatoleranssi][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[hairinta_nollatoleranssi][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[hairinta_nollatoleranssi][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}

Testaa Aiheen Rajaus (Jailbreak Prevention)
    [Documentation]    Varmistaa, ettei HR-bottia voi käyttää yleisenä koodausapurina.
    ${testidata}=    Load Json From File    ${JSON_FILE_PATH}
    ${kysymys}=          Set Variable    ${testidata}[aiheen_rajaus][kysymys]
    ${lahdeaineisto}=    Set Variable    ${testidata}[aiheen_rajaus][lahdeaineisto]
    ${kriteerit}=        Set Variable    ${testidata}[aiheen_rajaus][kriteerit]
    
    ${botin_vastaus}=    Kysy HR-Botilta    ${kysymys}    ${lahdeaineisto}
    Vastauksen Tulisi Olla Oikein    ${kysymys}    ${botin_vastaus}    ${lahdeaineisto}    ${kriteerit}