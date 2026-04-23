# Kuvitteellisen HR-Botin AI-testaus Robot Frameworkilla

Automaattinen testausprojekti kuvitteellisen HR-chatbotin testaamiseen Robot Framework -kehyksellä ja AI-malleilla. Projekti vertailee eri kielimallien kykyä vastata HR-aiheisiin kysymyksiin ja arvioi vastausten laatua tuomarimallilla.

## Projektikuvaus

Tämä projekti automatisoi HR-chatbotin testaamisen seuraavasti:

1. **Testattava malli**: Lähettää HR-kysymyksiä paikalliseen tai cloud-pohjaiseen kielimalliin (esim. Gemma3)
2. **Tuomarimalli**: Arvioi botinvastauksia määritelltyjen kriteerien mukaisesti (esim. Mistral)
3. **Testiskenaariot**: Testaa kriittisiä HR-aiheita kuten lomapolitiikka, etätyö, tietoturva ja empatia

## Projektirakenteen

```
robotfw-ai-testing/
├── README.md                    # Tämä tiedosto
├── requirements.txt             # Python-riippuvuudet
├── data/
│   └── hr_testdata.json        # Testiskenaariot ja kriteerit
├── resources/
│   └── ai_keywords.robot       # Mukautetut Robot Framework -asiasanat
├── libraries/                   # Mukautetut Python-kirjastot (tyhjä)
├── tests/
│   └── hr_bot_api_test.robot   # Päätestitapaukset
└── results/                     # Testitulosten säilytys
```

## Edellytykseet

- **Python 3.8+**
- **Robot Framework**: Testien ajamiseen
- **Ollama**: Paikallisten kielimallien ajaamiseen
- **API-avain**: Pilvipalveluihin (Ollama API)

## Asennus

### 1. Virtuaaliympäristön luominen

```bash
python -m venv venv
.\venv\Scripts\Activate  # Windows
source venv/bin/activate  # Linux/Mac
```

### 2. Riippuvuuksien asennus

```bash
pip install -r requirements.txt
```

### 3. Ollama-asennnus

Lataa ja asenna [Ollama](https://ollama.ai):
- Windows/Mac: Asennusohjelma
- Linux: `curl -fsSL https://ollama.ai/install.sh | sh`

### 4. Mallien lataaminen

```bash
# Lataa Gemma3 -testattava malli (paikallinen)
ollama pull gemma3:270m
ollama pull gemma3:latest

# Lataa Mistral tuomarimallille (pilvi)
# Vaatii API-avaimen
```

### 5. Ympäristömuuttujien konfigurointi

Luo `.env`-tiedosto tai aseta ympäristömuuttujat:

```bash
set OLLAMA_API_KEY=your_api_key_here  # Windows
export OLLAMA_API_KEY=your_api_key_here  # Linux/Mac
```

## Käyttö

### Testien ajaminen

```bash
robot tests/hr_bot_api_test.robot
```

### Spesifisen testiskenaarion ajaminen

```bash
robot --test "Testaa HR-Botin Lomavastaus" tests/hr_bot_api_test.robot
```

### Raporttien näyttäminen

Testien jälkeen luodaan raportit:
- `report.html` - Testitulosten yhteenveto
- `log.html` - Yksityiskohtaiset lokitiedot
- `output.xml` - Koneluettava tulos

Avaa `report.html` selaimessa tulosten näkemiseksi.

## Testiskenaariot

Projektissa testataan seuraavat HR-aiheet:

| Skenaario | Kuvaus | Testattava taito |
|-----------|--------|-----------------|
| **Loma-kysely** | Vuosiloman määrä ensimmäisen vuoden jälkeen | Oikean tiedon hakeminen |
| **Etätyösopimus** | Ulkomailla työskentelyn sääntöjä | Tiedon tarkkuus |
| **Hallusinaation esto** | Vastaus tuntemattomiin kysymyksiin | Epävarmuuden ilmaisu |
| **Sairauspoissaolo** | Kuumeen kanssa työstä poissaolo | Empatia ja ohjaus |
| **Palkkatietojen tietoturva** | Salassa pidettävät palkkatiedot | Tietoturva |
| **Etätyöbudjetti** | Ergonomisen kaluston rahoitus | Täsmällinen tieto |

## Konfiguraatio

### Mallien valinta

Muokkaa `resources/ai_keywords.robot` -tiedostoa:

```robot
${BOT_MODEL}          gemma3:latest        # Testattava malli
${JUDGE_MODEL}        mistral-large-3:675b-cloud    # Tuomarimalli
```

### Testattavien mallien vertailu

Muokkaa `tests/hr_bot_api_test.robot` -tiedostoa:

```robot
@{TESTATTAVAT_MALLIT}    gemma3:270m    gemma3:latest
```

### API-päätepisteet

- **Paikallinen**: `http://localhost:11434/api/generate`
- **Pilvi**: `https://ollama.com/api/generate`

## Testidatan muokkaaminen

Lisää tai muokkaa testiskenaarioita tiedostossa `data/hr_testdata.json`:

```json
{
  "uusi_skenaario": {
    "kysymys": "Kysymyksen teksti",
    "lahdeaineisto": "Lähdeteksti",
    "kriteerit": "Millä perusteilla vastaus arvioidaan"
  }
}
```

Lisää sitten uusi testitapaus `tests/hr_bot_api_test.robot` -tiedostoon.

## Tulosten tulkinta

### Onnistuneet testit
- ✅ **PASS**: Tuomarimalli hyväksyi vastauksen (vastasi "KYLLÄ")
- Vastaus on lähdeaineiston mukainen ja täyttää kriteerit

### Epäonnistuneet testit
- ❌ **FAIL**: Tuomarimalli hylkäsi vastauksen (vastasi "EI")
- Vastaus ei täyttänyt määriteltyjä kriteerejä

### Hallusinaation esto
Erityisen tärkeä on hallusinaation esto -skenaario, jossa botti testataan kysymyksellä, johon vastaus ei löydy lähdeaineistosta. Botti ei saa keksiä tietoa.

## Vianetsintä

### Ollama-yhteyden ongelmat
```bash
# Tarkista, että Ollama on käynnissä
ollama serve

# Testaa yhteys
curl http://localhost:11434/api/tags
```

### Mallin lataamisen ongelmat
```bash
# Näytä ladatut mallit
ollama list

# Lataa malli uudelleen
ollama pull gemma3:latest
```

### API-avainvirheet
- Tarkista ympäristömuuttujan `OLLAMA_API_KEY` asetus
- Varmista, että avain on voimassa

## Kehitys

### Uusien testiskenaarioiden lisääminen

1. Lisää testiskenaario `data/hr_testdata.json` -tiedostoon
2. Lisää testifunktio `tests/hr_bot_api_test.robot` -tiedostoon
3. Käytä olemassa olevia asiasanoja tai luo uusia `resources/ai_keywords.robot` -tiedostoon
4. Aja testit

### Uusien asiasanojen luominen

Lisää uudet mukautetut asiasanat `resources/ai_keywords.robot` -tiedostoon:

```robot
Uusi Asiasana
    [Arguments]    ${argumentti}
    # Toteutus
    RETURN    ${tulos}
```

