Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35405 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIETbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 15:31:34 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBG004CQ0WKRG40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Sep 2014 15:31:32 -0400 (EDT)
Date: Fri, 05 Sep 2014 16:31:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>, linux-media@vger.kernel.org,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [GIT PULL dtv-scan-tables] conversion to DVBv5 format
Message-id: <20140905163126.465ad690.m.chehab@samsung.com>
In-reply-to: <20140904235603.31973b7f.m.chehab@samsung.com>
References: <20140904235603.31973b7f.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Sep 2014 23:56:03 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Hi Oliver,

...

> As those parameters don't exist at DVBv5 API, nor at libdvbv5,
> a conversion on those files will lose them.

I actually implemented support for libdvbv5 to be able to optionally
read and write the pls_code and pls_mode. With that, the file generated 
on DVBv5 can generate back the same files found at DVBv3.

So, I did one step further, converting all the files to DVBv5 format,
and changing the Makefile to produce DVBv3 files.

IMHO, distros should now use this source to generate two separate
table packages, one for DVBv3 and another one for DVBv5.

I also added a README file explaining how to deal with the format
conversions.

I had to do some changes at libdvbv5 to deal with the corner cases.
We're planning to soon release version 1.4.0 of v4l-utils, with all
those improvements, plus the library stable version. So, the README
points to this newcoming version.

Please pull from:
  git://linuxtv.org/mchehab/dtv-scan-tables.git master

To get it. Unfortunately, this is too big to send via the mailing list.

Thanks and regards,
Mauro

-

The following changes since commit fc24b788b5b27f15a87bd47c29a54b2330d1b074:

  Add Brazil's remaining states tables (2014-09-02 20:57:32 +0200)

are available in the git repository at:

  git://linuxtv.org/mchehab/dtv-scan-tables.git master

for you to fetch changes up to 4aad3134beb551c820d3bfb5e26f8829e109aca2:

  Add a README file to explain how to generate the dvbv3 files (2014-09-05 16:19:56 -0300)

----------------------------------------------------------------
Jonathan McCrohan (1):
      Add Makefile to convert DVBv3 files to DVBv5

Mauro Carvalho Chehab (11):
      Remove zeros on the left for channel frequencies
      The ca-AB-Calgary file has an invalid line. Fix it.
      Fix FEC on dvb-t/sk-Bratislava
      fix dvb-t/ug-All DVB-T2 format
      Fix the DVB-S channel on dvb-s/Astra-31.5E
      Makefile: Add support to convert from DVBv5 to DVBv3
      Convert existing tables to DVBv5 format
      Move the contents of dvbv5_dvb-t into dvb-t
      Fix the Makefile to do the right thing after the conversion
      Remove duplicated dvb-t/br-Brazil and fix ar-Argentina
      Add a README file to explain how to generate the dvbv3 files

 Makefile                                           |   39 +
 README                                             |   38 +
 atsc/ca-AB-Calgary                                 |   28 +-
 atsc/us-ATSC-center-frequencies-8VSB               |  476 ++++-
 atsc/us-CA-SF-Bay-Area                             |   91 +-
 atsc/us-CO-Denver                                  |  133 +-
 .../us-Cable-EIA-542-HRC-center-frequencies-QAM256 |  875 +++++++--
 .../us-Cable-EIA-542-IRC-center_frequencies-QAM256 |  875 +++++++--
 atsc/us-Cable-HRC-center-frequencies-QAM256        |  875 +++++++--
 atsc/us-Cable-IRC-center-frequencies-QAM256        |  875 +++++++--
 atsc/us-Cable-Standard-center-frequencies-QAM256   | 1099 +++++++++--
 atsc/us-ID-Boise                                   |   42 +-
 atsc/us-MA-Boston                                  |   77 +-
 atsc/us-MI-Lansing                                 |   35 +-
 atsc/us-NTSC-center-frequencies-8VSB               |  476 ++++-
 atsc/us-PA-Philadelphia                            |   56 +-
 dvb-c/at-Innsbruck                                 |   54 +-
 dvb-c/at-Kabel-Braunau                             |  216 ++-
 dvb-c/at-Kabelsignal                               |  324 +++-
 dvb-c/at-KarrerNet                                 |  207 +-
 dvb-c/at-Liwest                                    |  252 ++-
 dvb-c/at-SalzburgAG                                |   54 +-
 dvb-c/at-Vienna                                    |    9 +-
 dvb-c/be-IN.DI-Integan                             |  126 +-
 dvb-c/br-Net-Digital                               |    9 +-
 dvb-c/ch-Bern-upc-cablecom                         |    9 +-
 dvb-c/ch-GGA-Pratteln                              |  315 ++-
 dvb-c/ch-Rega-Sense                                |  227 ++-
 dvb-c/ch-Video2000                                 |    9 +-
 dvb-c/ch-Zuerich-upc-cablecom                      |    9 +-
 dvb-c/ch-interGGA                                  |  243 ++-
 dvb-c/cz-Moravianet                                |  108 +-
 dvb-c/de-Berlin                                    |   27 +-
 dvb-c/de-Brandenburg-Havel                         |  252 ++-
 dvb-c/de-Kabel_BW                                  |    9 +-
 dvb-c/de-Kabel_Deutschland-Hannover                |  243 ++-
 dvb-c/de-Muenchen                                  |  189 +-
 dvb-c/de-NetAachen                                 |  315 ++-
 dvb-c/de-Primacom                                  |  270 ++-
 dvb-c/de-Unitymedia                                |  288 ++-
 dvb-c/de-iesy                                      |  162 +-
 dvb-c/de-komro-Rosenheim                           |  252 ++-
 dvb-c/de-neftv                                     |  261 ++-
 dvb-c/dk-Aarhus-Antenneforening                    |    9 +-
 dvb-c/dk-Copenhagen-AFDK                           |   72 +-
 dvb-c/dk-Odense                                    |   72 +-
 dvb-c/es-Euskaltel                                 |  126 +-
 dvb-c/fi-HTV                                       |  324 +++-
 dvb-c/fi-Joensuu-Tikka                             |   99 +-
 dvb-c/fi-TTV                                       |   18 +-
 dvb-c/fi-Turku                                     |  189 +-
 dvb-c/fi-dna                                       |  261 ++-
 dvb-c/fi-jkl                                       |   72 +-
 dvb-c/fi-sonera                                    |  216 ++-
 dvb-c/fi-vaasa-oncable                             |   99 +-
 dvb-c/fr-noos-numericable                          |  351 +++-
 dvb-c/hu-Digikabel                                 |  153 +-
 dvb-c/lu-Ettelbruck-ACE                            |  144 +-
 dvb-c/nl-Delta                                     |    9 +-
 dvb-c/nl-REKAM-CAIW_Gouda                          |   18 +-
 dvb-c/nl-Ziggo                                     |   36 +-
 dvb-c/nl-upc                                       |    9 +-
 dvb-c/no-Oslo-CanalDigital                         |  108 +-
 dvb-c/no-Oslo-Get                                  |  189 +-
 dvb-c/ro-DigiTV                                    |  225 ++-
 dvb-c/se-Gothnet                                   |  126 +-
 dvb-c/se-comhem                                    |  207 +-
 dvb-s/ABS1-75.0E                                   |   72 +-
 dvb-s/AMC1-103w                                    |   18 +-
 dvb-s/AMC16-85.0W                                  |   27 +-
 dvb-s/AMC4-101w                                    |   63 +-
 dvb-s/AMC5-79w                                     |   18 +-
 dvb-s/AMC6-72w                                     |  369 +++-
 dvb-s/AMC9-83.0W                                   |  135 +-
 dvb-s/Agila2_C-146.0E                              |  162 +-
 dvb-s/Amazonas-61.0W                               |  459 ++++-
 dvb-s/Amos-4w                                      |  414 +++-
 dvb-s/Anik-F1-107.3W                               |   36 +-
 dvb-s/Apstar6_C-134.0E                             |   27 +-
 dvb-s/AsiaSat2_C-100.5E                            |  135 +-
 dvb-s/AsiaSat3S_C-105.5E                           |  288 ++-
 dvb-s/Asiasat4_C-122.2E                            |   63 +-
 dvb-s/Astra-19.2E                                  |    9 +-
 dvb-s/Astra-23.5E                                  |  480 ++++-
 dvb-s/Astra-28.2E                                  |  792 +++++++-
 dvb-s/Astra-31.5E                                  |   57 +-
 dvb-s/Atlantic-Bird-1-12.5W                        |  300 ++-
 dvb-s/Atlantic-Bird-3-5.0W                         |  392 +++-
 dvb-s/BrasilSat-B1-75.0W                           |   72 +-
 dvb-s/BrasilSat-B2-65.0W                           |  279 ++-
 dvb-s/BrasilSat-B4-70.0W                           |  324 +++-
 dvb-s/BrasilsatB4-84.0W                            |  738 ++++++-
 dvb-s/ChinaSat5A-87.5E                             |   27 +-
 dvb-s/Estrela-do-Sul-63.0W                         |  216 ++-
 dvb-s/Eurobird1-28.5E                              |   27 +-
 dvb-s/Eutelsat9-9.0E                               |  126 +-
 dvb-s/EutelsatW2-16E                               |  504 ++++-
 dvb-s/Express-3A-11.0W                             |    9 +-
 dvb-s/ExpressAM1-40.0E                             |   27 +-
 dvb-s/ExpressAM2-80.0E                             |  171 +-
 dvb-s/ExpressAM22-53.0E                            |   54 +-
 dvb-s/Galaxy10R-123w                               |   63 +-
 dvb-s/Galaxy17-91.0W                               |  414 +++-
 dvb-s/Galaxy19-97.0W                               |  144 +-
 dvb-s/Galaxy25-93.0W                               |  531 +++++-
 dvb-s/Galaxy27-129w                                |    9 +-
 dvb-s/Galaxy28-89.0W                               |  351 +++-
 dvb-s/Galaxy3C-95.0W                               |    9 +-
 dvb-s/Hispasat-30.0W                               |  360 +++-
 dvb-s/Hotbird-13.0E                                |  880 ++++++++-
 dvb-s/IA7-129w                                     |    9 +-
 dvb-s/Insat2E_C-83.0E                              |  261 ++-
 dvb-s/Insat3A_C-93.5E                              |  180 +-
 dvb-s/Insat4A_C-83.0E                              |  261 ++-
 dvb-s/Insat4B_C-93.5E                              |  135 +-
 dvb-s/Intel4-72.0E                                 |   36 +-
 dvb-s/Intel904-60.0E                               |   99 +-
 dvb-s/Intelsat-1002-1.0W                           |  162 +-
 dvb-s/Intelsat-11-43.0W                            |    9 +-
 dvb-s/Intelsat-12-45.0E                            |  114 +-
 dvb-s/Intelsat-1R-45.0W                            |  369 +++-
 dvb-s/Intelsat-3R-43.0W                            |  288 ++-
 dvb-s/Intelsat-6B-43.0W                            |  126 +-
 dvb-s/Intelsat-705-50.0W                           |   36 +-
 dvb-s/Intelsat-707-53.0W                           |   18 +-
 dvb-s/Intelsat-805-55.5W                           |  576 +++++-
 dvb-s/Intelsat-9-58.0W                             |  495 ++++-
 dvb-s/Intelsat-903-34.5W                           |   36 +-
 dvb-s/Intelsat-905-24.5W                           |   54 +-
 dvb-s/Intelsat-907-27.5W                           |   54 +-
 dvb-s/Intelsat8_C-166.0E                           |   99 +-
 dvb-s/JCSat3A_C-128.0E                             |   36 +-
 dvb-s/Measat3_C-91.5E                              |  144 +-
 dvb-s/NSS-10-37.5W                                 |   81 +-
 dvb-s/NSS-7-22.0W                                  |  198 +-
 dvb-s/NSS-806-40.5W                                |  945 ++++++++-
 dvb-s/Nahuel-1-71.8W                               |   72 +-
 dvb-s/Nilesat101+102-7.0W                          |  351 +++-
 dvb-s/OptusC1-156E                                 |  162 +-
 dvb-s/OptusD1-160.0E                               |   18 +-
 dvb-s/PAS-43.0W                                    |   36 +-
 dvb-s/PalapaC2_C-113.0E                            |   99 +-
 dvb-s/SBS6-74w                                     |    9 +-
 dvb-s/SES2-87.0W                                   |   63 +-
 dvb-s/ST1_C-80.0E                                  |   63 +-
 dvb-s/Satmex-5-116.8W                              |  621 +++++-
 dvb-s/Satmex-6-113.0W                              |  144 +-
 dvb-s/Sirius-5.0E                                  |  540 +++++-
 dvb-s/Telecom2-8.0W                                |  135 +-
 dvb-s/Telkom1_C-108.0E                             |  126 +-
 dvb-s/Telstar10_C-76.5E                            |  171 +-
 dvb-s/Telstar12-15.0W                              |  216 ++-
 dvb-s/Telstar18_C-138.0E                           |   36 +-
 dvb-s/Thaicom1A_C-120.0E                           |   54 +-
 dvb-s/Thaicom2_C-78.5E                             |   81 +-
 dvb-s/Thaicom5_C-78.5E                             |  189 +-
 dvb-s/Thor-1.0W                                    |  567 +++++-
 dvb-s/Turksat-42.0E                                |  918 ++++++++-
 dvb-s/Vinasat1_C-132.0E                            |   18 +-
 dvb-s/Yamal201-90.0E                               |  207 +-
 dvb-t/ad-Andorra                                   |   52 +-
 dvb-t/ar-Argentina                                 |   63 -
 dvb-t/at-All                                       |  637 ++++++-
 dvb-t/au-Adelaide                                  |   78 +-
 dvb-t/au-AdelaideFoothills                         |   65 +-
 dvb-t/au-Ballarat                                  |   65 +-
 dvb-t/au-Bendigo                                   |  340 +++-
 dvb-t/au-Brisbane                                  |   78 +-
 dvb-t/au-Cairns                                    |   65 +-
 dvb-t/au-Canberra-Black-Mt                         |   65 +-
 dvb-t/au-Coonabarabran                             |   54 +-
 dvb-t/au-Darwin                                    |   65 +-
 dvb-t/au-Devonport                                 |   91 +-
 dvb-t/au-FraserCoast-Bundaberg                     |   65 +-
 dvb-t/au-GoldCoast                                 |  104 +-
 dvb-t/au-Goulburn-Rocky_Hill                       |   65 +-
 dvb-t/au-Hervey_Bay-Ghost_Hill                     |   78 +-
 dvb-t/au-Hobart                                    |   65 +-
 dvb-t/au-Mackay                                    |   65 +-
 dvb-t/au-Melbourne                                 |   78 +-
 dvb-t/au-Melbourne-Selby                           |   64 +-
 dvb-t/au-Melbourne-Upwey                           |   65 +-
 dvb-t/au-MidNorthCoast                             |  130 +-
 dvb-t/au-Newcastle                                 |   65 +-
 dvb-t/au-Perth                                     |   65 +-
 dvb-t/au-Perth_Roleystone                          |   65 +-
 dvb-t/au-SpencerGulf                               |   39 +-
 dvb-t/au-SunshineCoast                             |   65 +-
 dvb-t/au-Sutherland                                |   52 +-
 dvb-t/au-Sydney                                    |   78 +-
 dvb-t/au-Sydney_Kings_Cross                        |   65 +-
 dvb-t/au-Tamworth                                  |  195 +-
 dvb-t/au-Townsville                                |   65 +-
 dvb-t/au-WaggaWagga                                |   65 +-
 dvb-t/au-Wollongong                                |  130 +-
 dvb-t/au-canberra                                  |   65 +-
 dvb-t/au-unknown                                   |   13 +-
 dvb-t/auto-Australia                               | 1300 ++++++++++++-
 dvb-t/auto-Default                                 |  741 ++++++-
 dvb-t/auto-Taiwan                                  |  169 +-
 dvb-t/auto-With167kHzOffsets                       | 2015 ++++++++++++++++++--
 dvb-t/ax-Smedsbole                                 |   26 +-
 dvb-t/be-All                                       |   65 +-
 dvb-t/bg-Sofia                                     |   53 +-
 dvb-t/br-Brazil                                    |   63 -
 dvb-t/ca-AB-Calgary                                |   45 +-
 dvb-t/ch-All                                       |  364 +++-
 dvb-t/ch-Citycable                                 |  351 +++-
 dvb-t/ch-Geneva                                    |  156 +-
 dvb-t/cz-All                                       |  520 ++++-
 dvb-t/de-Baden-Wuerttemberg                        |  208 +-
 dvb-t/de-Bayern                                    |  247 ++-
 dvb-t/de-Berlin                                    |  117 +-
 dvb-t/de-Brandenburg                               |   52 +-
 dvb-t/de-Bremen                                    |   78 +-
 dvb-t/de-Hamburg                                   |  104 +-
 dvb-t/de-Hessen                                    |  208 +-
 dvb-t/de-Mecklenburg-Vorpommern                    |  117 +-
 dvb-t/de-Niedersachsen                             |  286 ++-
 dvb-t/de-Nordrhein-Westfalen                       |  247 ++-
 dvb-t/de-Rheinland-Pfalz                           |  104 +-
 dvb-t/de-Saarland                                  |   52 +-
 dvb-t/de-Sachsen                                   |  143 +-
 dvb-t/de-Sachsen-Anhalt                            |  130 +-
 dvb-t/de-Schleswig-Holstein                        |  195 +-
 dvb-t/de-Thueringen                                |   91 +-
 dvb-t/dk-All                                       |  247 ++-
 dvb-t/ee-All                                       |  421 +++-
 dvb-t/es-Albacete                                  |  156 +-
 dvb-t/es-Alfabia                                   |  156 +-
 dvb-t/es-Alicante                                  |   91 +-
 dvb-t/es-Alpicat                                   |   78 +-
 dvb-t/es-Asturias                                  |   78 +-
 dvb-t/es-BaixoMinho                                |   78 +-
 dvb-t/es-Bilbao                                    |   78 +-
 dvb-t/es-Cadiz                                     |  312 ++-
 dvb-t/es-Carceres                                  |  117 +-
 dvb-t/es-Collserola                                |  130 +-
 dvb-t/es-Donostia                                  |  130 +-
 dvb-t/es-Granada                                   |   78 +-
 dvb-t/es-Huesca                                    |  130 +-
 dvb-t/es-Las_Palmas                                |  156 +-
 dvb-t/es-Lugo                                      |   78 +-
 dvb-t/es-Madrid                                    |  143 +-
 dvb-t/es-Malaga                                    |   79 +-
 dvb-t/es-Muros-Noia                                |   91 +-
 dvb-t/es-Mussara                                   |   78 +-
 dvb-t/es-Pamplona                                  |   91 +-
 dvb-t/es-Rocacorba                                 |    6 -
 dvb-t/es-SC_Tenerife                               |  156 +-
 dvb-t/es-Santander                                 |   52 +-
 dvb-t/es-Santiago_de_Compostela                    |   91 +-
 dvb-t/es-Sevilla                                   |  247 ++-
 dvb-t/es-Tenerife                                  |  156 +-
 dvb-t/es-Valencia                                  |  104 +-
 dvb-t/es-Valladolid                                |   65 +-
 dvb-t/es-Vilamarxant                               |   26 +-
 dvb-t/es-Vitoria-Gasteiz                           |   78 +-
 dvb-t/es-Zaragoza                                  |   65 +-
 dvb-t/fi-Aanekoski                                 |   25 +-
 dvb-t/fi-Aanekoski_Konginkangas                    |   25 +-
 dvb-t/fi-Ahtari                                    |   13 +-
 dvb-t/fi-Alajarvi                                  |   25 +-
 dvb-t/fi-Anjalankoski_Ruotila                      |   31 +-
 dvb-t/fi-DNA-Espoo                                 |   39 +-
 dvb-t/fi-DNA-Eurajoki                              |   39 +-
 dvb-t/fi-DNA-Hameenlinna                           |   39 +-
 dvb-t/fi-DNA-Hamina                                |   39 +-
 dvb-t/fi-DNA-Hausjarvi                             |   39 +-
 dvb-t/fi-DNA-Helsinki                              |   39 +-
 dvb-t/fi-DNA-Jokioinen                             |   39 +-
 dvb-t/fi-DNA-Jyvaskyla                             |   39 +-
 dvb-t/fi-DNA-Kaarina                               |   39 +-
 dvb-t/fi-DNA-Kajaani                               |   39 +-
 dvb-t/fi-DNA-Kangasala                             |   39 +-
 dvb-t/fi-DNA-Karkkila                              |   39 +-
 dvb-t/fi-DNA-Kiiminki                              |   39 +-
 dvb-t/fi-DNA-Kokkola                               |   39 +-
 dvb-t/fi-DNA-Kontiolahti                           |   39 +-
 dvb-t/fi-DNA-Kouvola                               |   39 +-
 dvb-t/fi-DNA-Kuopio                                |   39 +-
 dvb-t/fi-DNA-Lahti                                 |   39 +-
 dvb-t/fi-DNA-Lappeenranta                          |   39 +-
 dvb-t/fi-DNA-Lohja                                 |   39 +-
 dvb-t/fi-DNA-Loviisa                               |   39 +-
 dvb-t/fi-DNA-Mikkeli                               |   39 +-
 dvb-t/fi-DNA-Nousiainen                            |   39 +-
 dvb-t/fi-DNA-Nurmijarvi                            |   39 +-
 dvb-t/fi-DNA-Porvoo                                |   39 +-
 dvb-t/fi-DNA-Salo                                  |   39 +-
 dvb-t/fi-DNA-Savonlinna                            |   39 +-
 dvb-t/fi-DNA-Seinajoki                             |   39 +-
 dvb-t/fi-DNA-Tyrnava                               |   39 +-
 dvb-t/fi-DNA-Ulvila                                |   39 +-
 dvb-t/fi-DNA-Vaasa                                 |   39 +-
 dvb-t/fi-DNA-Valkeakoski                           |   39 +-
 dvb-t/fi-DNA-Vesilahti                             |   39 +-
 dvb-t/fi-DNA-Ylivieska                             |   39 +-
 dvb-t/fi-Enontekio_Ahovaara                        |   13 +-
 dvb-t/fi-Enontekio_Hetta                           |   13 +-
 dvb-t/fi-Enontekio_Kuttanen                        |   13 +-
 dvb-t/fi-Espoo                                     |   35 +-
 dvb-t/fi-Eurajoki                                  |   31 +-
 dvb-t/fi-Fiskars                                   |   25 +-
 dvb-t/fi-Haapavesi                                 |   25 +-
 dvb-t/fi-Hameenkyro_Kyroskoski                     |   25 +-
 dvb-t/fi-Hameenlinna_Painokangas                   |   19 +-
 dvb-t/fi-Hanko                                     |   25 +-
 dvb-t/fi-Hartola                                   |   19 +-
 dvb-t/fi-Heinavesi                                 |   19 +-
 dvb-t/fi-Heinola                                   |   25 +-
 dvb-t/fi-Hyrynsalmi                                |   19 +-
 dvb-t/fi-Hyrynsalmi_Kyparavaara                    |   19 +-
 dvb-t/fi-Hyrynsalmi_Paljakka                       |   19 +-
 dvb-t/fi-Hyvinkaa                                  |   25 +-
 dvb-t/fi-Ii_Raiskio                                |   13 +-
 dvb-t/fi-Iisalmi                                   |   13 +-
 dvb-t/fi-Ikaalinen                                 |   25 +-
 dvb-t/fi-Ikaalinen_Riitiala                        |   25 +-
 dvb-t/fi-Inari                                     |   13 +-
 dvb-t/fi-Inari_Janispaa                            |   13 +-
 dvb-t/fi-Inari_Naatamo                             |   13 +-
 dvb-t/fi-Ivalo_Saarineitamovaara                   |   13 +-
 dvb-t/fi-Jalasjarvi                                |   25 +-
 dvb-t/fi-Jamsa_Halli                               |   25 +-
 dvb-t/fi-Jamsa_Kaipola                             |   25 +-
 dvb-t/fi-Jamsa_Matkosvuori                         |   25 +-
 dvb-t/fi-Jamsa_Ouninpohja                          |   19 +-
 dvb-t/fi-Jamsankoski                               |   25 +-
 dvb-t/fi-Joensuu_Vestinkallio                      |   19 +-
 dvb-t/fi-Joroinen_Puukkola                         |   19 +-
 dvb-t/fi-Joutsa_Lankia                             |   25 +-
 dvb-t/fi-Joutseno                                  |   31 +-
 dvb-t/fi-Juupajoki_Kopsamo                         |   19 +-
 dvb-t/fi-Juva                                      |   25 +-
 dvb-t/fi-Jyvaskyla                                 |   37 +-
 dvb-t/fi-Jyvaskyla_Vaajakoski                      |   19 +-
 dvb-t/fi-Kaavi_Sivakkavaara                        |   19 +-
 dvb-t/fi-Kajaani_Pollyvaara                        |   19 +-
 dvb-t/fi-Kalajoki                                  |   19 +-
 dvb-t/fi-Kangaslampi                               |   25 +-
 dvb-t/fi-Kangasniemi_Turkinmaki                    |   25 +-
 dvb-t/fi-Kankaanpaa                                |   25 +-
 dvb-t/fi-Karigasniemi                              |   13 +-
 dvb-t/fi-Karkkila                                  |   25 +-
 dvb-t/fi-Karstula                                  |   19 +-
 dvb-t/fi-Karvia                                    |   19 +-
 dvb-t/fi-Kaunispaa                                 |   13 +-
 dvb-t/fi-Kemijarvi_Suomutunturi                    |   13 +-
 dvb-t/fi-Kerimaki                                  |   25 +-
 dvb-t/fi-Keuruu                                    |   25 +-
 dvb-t/fi-Keuruu_Haapamaki                          |   25 +-
 dvb-t/fi-Kihnio                                    |   25 +-
 dvb-t/fi-Kiihtelysvaara                            |   13 +-
 dvb-t/fi-Kilpisjarvi                               |   13 +-
 dvb-t/fi-Kittila_Levitunturi                       |   13 +-
 dvb-t/fi-Kolari_Vuolittaja                         |   13 +-
 dvb-t/fi-Koli                                      |   25 +-
 dvb-t/fi-Korpilahti_Vaarunvuori                    |   25 +-
 dvb-t/fi-Korppoo                                   |   25 +-
 dvb-t/fi-Kruunupyy                                 |   31 +-
 dvb-t/fi-Kuhmo_Haukela                             |   19 +-
 dvb-t/fi-Kuhmo_Lentiira                            |   19 +-
 dvb-t/fi-Kuhmo_Niva                                |   19 +-
 dvb-t/fi-Kuhmoinen                                 |   25 +-
 dvb-t/fi-Kuhmoinen_Harjunsalmi                     |   25 +-
 dvb-t/fi-Kuhmoinen_Puukkoinen                      |   19 +-
 dvb-t/fi-Kuopio                                    |   31 +-
 dvb-t/fi-Kurikka_Kesti                             |   25 +-
 dvb-t/fi-Kustavi_Viherlahti                        |   25 +-
 dvb-t/fi-Kuusamo_Hamppulampi                       |   13 +-
 dvb-t/fi-Kyyjarvi_Noposenaho                       |   19 +-
 dvb-t/fi-Lahti                                     |   37 +-
 dvb-t/fi-Lapua                                     |   31 +-
 dvb-t/fi-Laukaa                                    |   25 +-
 dvb-t/fi-Laukaa_Vihtavuori                         |   25 +-
 dvb-t/fi-Lavia                                     |   19 +-
 dvb-t/fi-Lohja                                     |   25 +-
 dvb-t/fi-Loimaa                                    |   25 +-
 dvb-t/fi-Luhanka                                   |   25 +-
 dvb-t/fi-Luopioinen                                |   25 +-
 dvb-t/fi-Mantta                                    |   25 +-
 dvb-t/fi-Mantyharju                                |   19 +-
 dvb-t/fi-Mikkeli                                   |   25 +-
 dvb-t/fi-Muonio_Olostunturi                        |   13 +-
 dvb-t/fi-Nilsia                                    |   25 +-
 dvb-t/fi-Nilsia_Keski-Siikajarvi                   |   19 +-
 dvb-t/fi-Nilsia_Pisa                               |   19 +-
 dvb-t/fi-Nokia                                     |   25 +-
 dvb-t/fi-Nokia_Siuro                               |   25 +-
 dvb-t/fi-Nummi-Pusula_Hyonola                      |   25 +-
 dvb-t/fi-Nuorgam_Njallavaara                       |   13 +-
 dvb-t/fi-Nuorgam_raja                              |   13 +-
 dvb-t/fi-Nurmes_Konnanvaara                        |   25 +-
 dvb-t/fi-Nurmes_Kortevaara                         |   19 +-
 dvb-t/fi-Orivesi_Talviainen                        |   19 +-
 dvb-t/fi-Oulu                                      |   37 +-
 dvb-t/fi-Padasjoki                                 |   25 +-
 dvb-t/fi-Padasjoki_Arrakoski                       |   25 +-
 dvb-t/fi-Paltamo_Kivesvaara                        |   19 +-
 dvb-t/fi-Parainen_Houtskari                        |   25 +-
 dvb-t/fi-Parikkala                                 |   25 +-
 dvb-t/fi-Parkano_Sopukallio                        |   25 +-
 dvb-t/fi-Pello                                     |   13 +-
 dvb-t/fi-Pello_Ratasvaara                          |   13 +-
 dvb-t/fi-Perho                                     |   25 +-
 dvb-t/fi-Pernaja                                   |   19 +-
 dvb-t/fi-Pieksamaki_Halkokumpu                     |   19 +-
 dvb-t/fi-Pihtipudas                                |   19 +-
 dvb-t/fi-Porvoo_Suomenkyla                         |   25 +-
 dvb-t/fi-Posio                                     |   13 +-
 dvb-t/fi-Pudasjarvi                                |   19 +-
 dvb-t/fi-Pudasjarvi_Iso-Syote                      |   19 +-
 dvb-t/fi-Pudasjarvi_Kangasvaara                    |   13 +-
 dvb-t/fi-Puolanka                                  |   25 +-
 dvb-t/fi-Pyhatunturi                               |   13 +-
 dvb-t/fi-Pyhavuori                                 |   19 +-
 dvb-t/fi-Pylkonmaki_Karankajarvi                   |   19 +-
 dvb-t/fi-Raahe_Mestauskallio                       |   25 +-
 dvb-t/fi-Raahe_Piehinki                            |   19 +-
 dvb-t/fi-Ranua_Haasionmaa                          |   13 +-
 dvb-t/fi-Ranua_Leppiaho                            |   13 +-
 dvb-t/fi-Rautavaara_Angervikko                     |   25 +-
 dvb-t/fi-Rautjarvi_Simpele                         |   19 +-
 dvb-t/fi-Ristijarvi                                |   19 +-
 dvb-t/fi-Rovaniemi                                 |   19 +-
 dvb-t/fi-Rovaniemi_Kaihuanvaara                    |   13 +-
 dvb-t/fi-Rovaniemi_Karhuvaara                      |   13 +-
 dvb-t/fi-Rovaniemi_Marasenkallio                   |   13 +-
 dvb-t/fi-Rovaniemi_Rantalaki                       |   13 +-
 dvb-t/fi-Rovaniemi_Sonka                           |   13 +-
 dvb-t/fi-Rovaniemi_Sorviselka                      |   13 +-
 dvb-t/fi-Ruka                                      |   19 +-
 dvb-t/fi-Ruovesi_Storminiemi                       |   25 +-
 dvb-t/fi-Saarijarvi                                |   25 +-
 dvb-t/fi-Saarijarvi_Kalmari                        |   19 +-
 dvb-t/fi-Saarijarvi_Mahlu                          |   19 +-
 dvb-t/fi-Salla_Hirvasvaara                         |   13 +-
 dvb-t/fi-Salla_Ihistysjanka                        |   13 +-
 dvb-t/fi-Salla_Naruska                             |   13 +-
 dvb-t/fi-Salla_Sallatunturi                        |   13 +-
 dvb-t/fi-Salla_Sarivaara                           |   13 +-
 dvb-t/fi-Salo_Isokyla                              |   25 +-
 dvb-t/fi-Savukoski_Martti                          |   13 +-
 dvb-t/fi-Savukoski_Tanhua                          |   13 +-
 dvb-t/fi-Siilinjarvi                               |   25 +-
 dvb-t/fi-Simo_Viantie                              |   19 +-
 dvb-t/fi-Sipoo_Norrkulla                           |   25 +-
 dvb-t/fi-Sodankyla_Pittiovaara                     |   13 +-
 dvb-t/fi-Sodankyla_Vuotso                          |   13 +-
 dvb-t/fi-Sulkava_Vaatalanmaki                      |   19 +-
 dvb-t/fi-Suomussalmi_Ala-Vuokki                    |   13 +-
 dvb-t/fi-Suomussalmi_Ammansaari                    |   13 +-
 dvb-t/fi-Suomussalmi_Juntusranta                   |   13 +-
 dvb-t/fi-Suomussalmi_Myllylahti                    |   13 +-
 dvb-t/fi-Sysma_Liikola                             |   25 +-
 dvb-t/fi-Taivalkoski                               |   13 +-
 dvb-t/fi-Taivalkoski_Taivalvaara                   |   13 +-
 dvb-t/fi-Tammela                                   |   31 +-
 dvb-t/fi-Tammisaari                                |   25 +-
 dvb-t/fi-Tampere                                   |   37 +-
 dvb-t/fi-Tampere_Pyynikki                          |   31 +-
 dvb-t/fi-Tervola                                   |   19 +-
 dvb-t/fi-Turku                                     |   37 +-
 dvb-t/fi-Utsjoki                                   |   13 +-
 dvb-t/fi-Utsjoki_Nuvvus                            |   13 +-
 dvb-t/fi-Utsjoki_Outakoski                         |   13 +-
 dvb-t/fi-Utsjoki_Polvarniemi                       |   13 +-
 dvb-t/fi-Utsjoki_Rovisuvanto                       |   13 +-
 dvb-t/fi-Utsjoki_Tenola                            |   13 +-
 dvb-t/fi-Uusikaupunki_Orivo                        |   25 +-
 dvb-t/fi-Vaala                                     |   19 +-
 dvb-t/fi-Vaasa                                     |   19 +-
 dvb-t/fi-Valtimo                                   |   19 +-
 dvb-t/fi-Vammala_Jyranvuori                        |   25 +-
 dvb-t/fi-Vammala_Roismala                          |   19 +-
 dvb-t/fi-Vammala_Savi                              |   19 +-
 dvb-t/fi-Vantaa_Hakunila                           |   25 +-
 dvb-t/fi-Varpaisjarvi_Honkamaki                    |   25 +-
 dvb-t/fi-Virrat_Lappavuori                         |   25 +-
 dvb-t/fi-Vuokatti                                  |   25 +-
 dvb-t/fi-Ylitornio_Ainiovaara                      |   19 +-
 dvb-t/fi-Ylitornio_Raanujarvi                      |   13 +-
 dvb-t/fi-Yllas                                     |   13 +-
 dvb-t/fi-Yllasjarvi                                |   13 +-
 dvb-t/fr-All                                       |  520 ++++-
 dvb-t/gr-Athens                                    |   39 +-
 dvb-t/hk-HongKong                                  |   91 +-
 dvb-t/hr-All                                       |  338 +++-
 dvb-t/hu-Bekescsaba                                |   39 +-
 dvb-t/hu-Budapest                                  |   39 +-
 dvb-t/hu-Csavoly-Kiskoros                          |   26 +-
 dvb-t/hu-Debrecen-Komadi                           |   39 +-
 dvb-t/hu-Fehergyarmat                              |   26 +-
 dvb-t/hu-Gerecse-Dorog-Tatabanya                   |   39 +-
 dvb-t/hu-Gyor                                      |   39 +-
 dvb-t/hu-Kabhegy-Kaposvar-Tamasi                   |   26 +-
 ...deg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac |   39 +-
 dvb-t/hu-Karcag                                    |   39 +-
 dvb-t/hu-Kecskemet                                 |   39 +-
 dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd      |   39 +-
 dvb-t/hu-Miskolc-Aggtelek-Fony                     |   39 +-
 dvb-t/hu-Mor-Siofok-Veszprem-Zirc                  |   39 +-
 dvb-t/hu-Nagykanizsa-Barcs-Keszthely               |   39 +-
 ...gyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely |   39 +-
 dvb-t/hu-Pecs-Siklos                               |   26 +-
 dvb-t/hu-Sopron-Koszeg                             |   39 +-
 dvb-t/hu-Szeged                                    |   39 +-
 dvb-t/hu-Szekesfehervar                            |   39 +-
 dvb-t/hu-Szentes-Battonya                          |   26 +-
 dvb-t/hu-Szolnok                                   |   39 +-
 dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg     |   39 +-
 .../hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar |   39 +-
 dvb-t/ie-CairnHill                                 |   26 +-
 dvb-t/ie-ClermontCarn                              |   26 +-
 dvb-t/ie-Dungarvan                                 |   26 +-
 dvb-t/ie-HolywellHill                              |   26 +-
 dvb-t/ie-Kippure                                   |   26 +-
 dvb-t/ie-Maghera                                   |   26 +-
 dvb-t/ie-MountLeinster                             |   26 +-
 dvb-t/ie-Mullaghanish                              |   26 +-
 dvb-t/ie-SpurHill                                  |   26 +-
 dvb-t/ie-ThreeRock                                 |   26 +-
 dvb-t/ie-Truskmore                                 |   26 +-
 dvb-t/ie-WoodcockHill                              |   26 +-
 dvb-t/il-All                                       |   26 +-
 dvb-t/ir-Tehran                                    |   26 +-
 dvb-t/is-Reykjavik                                 |  234 ++-
 dvb-t/it-All                                       |  741 ++++++-
 dvb-t/lt-All                                       |  313 ++-
 dvb-t/lu-All                                       |   52 +-
 dvb-t/lv-Riga                                      |   94 +-
 dvb-t/nl-All                                       |  522 ++++-
 dvb-t/no-Trondelag_Stjordal                        |   39 +-
 dvb-t/nz-AucklandInfill                            |   39 +-
 dvb-t/nz-AucklandWaiatarua                         |   39 +-
 dvb-t/nz-Christchurch                              |   39 +-
 dvb-t/nz-Dunedin                                   |   39 +-
 dvb-t/nz-Hamilton                                  |   39 +-
 dvb-t/nz-HawkesBayMtErin                           |   39 +-
 dvb-t/nz-HawkesBayNapier                           |   39 +-
 dvb-t/nz-Manawatu                                  |   39 +-
 dvb-t/nz-Tauranga                                  |   39 +-
 dvb-t/nz-Waikato                                   |   39 +-
 dvb-t/nz-WellingtonInfill                          |   39 +-
 dvb-t/nz-WellingtonKaukau                          |   39 +-
 dvb-t/nz-WellingtonNgarara                         |   39 +-
 dvb-t/pl-Czestochowa                               |   39 +-
 dvb-t/pl-Gdansk                                    |   26 +-
 dvb-t/pl-Krakow                                    |   78 +-
 dvb-t/pl-Rzeszow                                   |   13 +-
 dvb-t/pl-Warszawa                                  |   10 -
 dvb-t/pl-Wroclaw                                   |   13 +-
 dvb-t/pt-All                                       |   91 +-
 dvb-t/ro-Bucharest                                 |   39 +-
 dvb-t/ru-Krasnodar                                 |   56 +-
 dvb-t/ru-Novosibirsk                               |   56 +-
 dvb-t/ru-Volgodonsk                                |   56 +-
 dvb-t/se-Alvdalen_Brunnsberg                       |   13 +-
 dvb-t/se-Alvdalsasen                               |   13 +-
 dvb-t/se-Alvsbyn                                   |   65 +-
 dvb-t/se-Amot                                      |   13 +-
 dvb-t/se-Ange_Snoberg                              |   52 +-
 dvb-t/se-Angebo                                    |   13 +-
 dvb-t/se-Angelholm_Vegeholm                        |   65 +-
 dvb-t/se-Arvidsjaur_Jultrask                       |   52 +-
 dvb-t/se-Aspeboda                                  |   13 +-
 dvb-t/se-Atvidaberg                                |   26 +-
 dvb-t/se-Avesta_Krylbo                             |   26 +-
 dvb-t/se-Backefors                                 |   65 +-
 dvb-t/se-Bankeryd                                  |   26 +-
 dvb-t/se-Bergsjo_Balleberget                       |   13 +-
 dvb-t/se-Bergvik                                   |   13 +-
 dvb-t/se-Bollebygd                                 |   26 +-
 dvb-t/se-Bollnas                                   |   52 +-
 dvb-t/se-Boras_Dalsjofors                          |   65 +-
 dvb-t/se-Boras_Sjobo                               |   26 +-
 dvb-t/se-Borlange_Idkerberget                      |   52 +-
 dvb-t/se-Borlange_Nygardarna                       |   26 +-
 dvb-t/se-Bottnaryd_Ryd                             |   13 +-
 dvb-t/se-Bromsebro                                 |   26 +-
 dvb-t/se-Bruzaholm                                 |   13 +-
 dvb-t/se-Byxelkrok                                 |   26 +-
 dvb-t/se-Dadran                                    |   13 +-
 dvb-t/se-Dalfors                                   |   13 +-
 dvb-t/se-Dalstuga                                  |   13 +-
 dvb-t/se-Degerfors                                 |   52 +-
 dvb-t/se-Delary                                    |   13 +-
 dvb-t/se-Djura                                     |   13 +-
 dvb-t/se-Drevdagen                                 |   13 +-
 dvb-t/se-Duvnas                                    |   13 +-
 dvb-t/se-Duvnas_Basna                              |   13 +-
 dvb-t/se-Edsbyn                                    |   13 +-
 dvb-t/se-Emmaboda_Balshult                         |   52 +-
 dvb-t/se-Enviken                                   |   26 +-
 dvb-t/se-Fagersta                                  |   26 +-
 dvb-t/se-Falerum_Centrum                           |   13 +-
 dvb-t/se-Falun_Lovberget                           |   52 +-
 dvb-t/se-Farila                                    |   13 +-
 dvb-t/se-Faro_Ajkerstrask                          |   26 +-
 dvb-t/se-Farosund_Bunge                            |   65 +-
 dvb-t/se-Filipstad_Klockarhojden                   |   52 +-
 dvb-t/se-Finnveden                                 |   52 +-
 dvb-t/se-Fredriksberg                              |   13 +-
 dvb-t/se-Fritsla                                   |   13 +-
 dvb-t/se-Furudal                                   |   13 +-
 dvb-t/se-Gallivare                                 |   52 +-
 dvb-t/se-Garpenberg_Kuppgarden                     |   13 +-
 dvb-t/se-Gavle_Skogmur                             |   52 +-
 dvb-t/se-Gnarp                                     |   13 +-
 dvb-t/se-Gnesta                                    |   26 +-
 dvb-t/se-Gnosjo_Marieholm                          |   13 +-
 dvb-t/se-Goteborg_Brudaremossen                    |   65 +-
 dvb-t/se-Goteborg_Slattadamm                       |   65 +-
 dvb-t/se-Gullbrandstorp                            |   13 +-
 dvb-t/se-Gunnarsbo                                 |   13 +-
 dvb-t/se-Gusum                                     |   13 +-
 dvb-t/se-Hagfors_Varmullsasen                      |   52 +-
 dvb-t/se-Hallaryd                                  |   13 +-
 dvb-t/se-Hallbo                                    |   13 +-
 dvb-t/se-Halmstad_Hamnen                           |   26 +-
 dvb-t/se-Halmstad_Oskarstrom                       |   52 +-
 dvb-t/se-Harnosand_Harnon                          |   52 +-
 dvb-t/se-Hassela                                   |   13 +-
 dvb-t/se-Havdhem                                   |   65 +-
 dvb-t/se-Hedemora                                  |   13 +-
 dvb-t/se-Helsingborg_Olympia                       |   65 +-
 dvb-t/se-Hennan                                    |   13 +-
 dvb-t/se-Hestra_Aspas                              |   13 +-
 dvb-t/se-Hjo_Grevback                              |   13 +-
 dvb-t/se-Hofors                                    |   52 +-
 dvb-t/se-Hogfors                                   |   13 +-
 dvb-t/se-Hogsby_Virstad                            |   26 +-
 dvb-t/se-Holsbybrunn_Holsbyholm                    |   13 +-
 dvb-t/se-Horby_Sallerup                            |   91 +-
 dvb-t/se-Horken                                    |   13 +-
 dvb-t/se-Hudiksvall_Forsa                          |   52 +-
 dvb-t/se-Hudiksvall_Galgberget                     |   26 +-
 dvb-t/se-Huskvarna                                 |   13 +-
 dvb-t/se-Idre                                      |   13 +-
 dvb-t/se-Ingatorp                                  |   13 +-
 dvb-t/se-Ingvallsbenning                           |   13 +-
 dvb-t/se-Irevik                                    |   26 +-
 dvb-t/se-Jamjo                                     |   26 +-
 dvb-t/se-Jarnforsen                                |   13 +-
 dvb-t/se-Jarvso                                    |   13 +-
 dvb-t/se-Jokkmokk_Tjalmejaure                      |   52 +-
 dvb-t/se-Jonkoping_Bondberget                      |   52 +-
 dvb-t/se-Kalix                                     |   52 +-
 dvb-t/se-Karbole                                   |   13 +-
 dvb-t/se-Karlsborg_Vaberget                        |   13 +-
 dvb-t/se-Karlshamn                                 |   52 +-
 dvb-t/se-Karlskrona_Vamo                           |   52 +-
 dvb-t/se-Karlstad_Sormon                           |   39 +-
 dvb-t/se-Kaxholmen_Vistakulle                      |   13 +-
 dvb-t/se-Kinnastrom                                |   13 +-
 dvb-t/se-Kiruna_Kirunavaara                        |   52 +-
 dvb-t/se-Kisa                                      |   65 +-
 dvb-t/se-Knared                                    |   13 +-
 dvb-t/se-Kopmanholmen                              |   52 +-
 dvb-t/se-Kopparberg                                |   26 +-
 dvb-t/se-Kramfors_Lugnvik                          |   52 +-
 dvb-t/se-Kristinehamn_Utsiktsberget                |   52 +-
 dvb-t/se-Kungsater                                 |   13 +-
 dvb-t/se-Kungsberget_GI                            |   13 +-
 dvb-t/se-Langshyttan                               |   13 +-
 dvb-t/se-Langshyttan_Engelsfors                    |   13 +-
 dvb-t/se-Leksand_Karingberget                      |   13 +-
 dvb-t/se-Lerdala                                   |   13 +-
 dvb-t/se-Lilltjara_Digerberget                     |   13 +-
 dvb-t/se-Limedsforsen                              |   13 +-
 dvb-t/se-Lindshammar_Ramkvilla                     |   13 +-
 dvb-t/se-Linkoping_Vattentornet                    |   65 +-
 dvb-t/se-Ljugarn                                   |   26 +-
 dvb-t/se-Loffstrand                                |   52 +-
 dvb-t/se-Lonneberga                                |   26 +-
 dvb-t/se-Lorstrand                                 |   13 +-
 dvb-t/se-Ludvika_Bjorkasen                         |   26 +-
 dvb-t/se-Lumsheden_Trekanten                       |   13 +-
 dvb-t/se-Lycksele_Knaften                          |   52 +-
 dvb-t/se-Mahult                                    |   13 +-
 dvb-t/se-Malmo_Jagersro                            |   65 +-
 dvb-t/se-Malung                                    |   26 +-
 dvb-t/se-Mariannelund                              |   13 +-
 dvb-t/se-Markaryd_Hualtet                          |   26 +-
 dvb-t/se-Matfors                                   |   52 +-
 dvb-t/se-Molndal_Vasterberget                      |   65 +-
 dvb-t/se-Mora_Eldris                               |   52 +-
 dvb-t/se-Motala_Ervasteby                          |   65 +-
 dvb-t/se-Mullsjo_Torestorp                         |   26 +-
 dvb-t/se-Nassjo                                    |   52 +-
 dvb-t/se-Navekvarn                                 |   13 +-
 dvb-t/se-Norrahammar                               |   13 +-
 dvb-t/se-Norrkoping_Krokek                         |   65 +-
 dvb-t/se-Norrtalje_Sodra_Bergen                    |   65 +-
 dvb-t/se-Nykoping                                  |   13 +-
 dvb-t/se-Orebro_Lockhyttan                         |   65 +-
 dvb-t/se-Ornskoldsvik_As                           |   65 +-
 dvb-t/se-Oskarshamn                                |   52 +-
 dvb-t/se-Ostersund_Brattasen                       |   65 +-
 dvb-t/se-Osthammar_Valo                            |   65 +-
 dvb-t/se-Overkalix                                 |   52 +-
 dvb-t/se-Oxberg                                    |   13 +-
 dvb-t/se-Pajala                                    |    6 -
 dvb-t/se-Paulistom                                 |   13 +-
 dvb-t/se-Rattvik                                   |   13 +-
 dvb-t/se-Rengsjo                                   |   13 +-
 dvb-t/se-Rorbacksnas                               |   13 +-
 dvb-t/se-Sagmyra                                   |   13 +-
 dvb-t/se-Salen                                     |   13 +-
 dvb-t/se-Salfjallet                                |   13 +-
 dvb-t/se-Sarna_Mickeltemplet                       |   13 +-
 dvb-t/se-Satila                                    |   13 +-
 dvb-t/se-Saxdalen                                  |   13 +-
 dvb-t/se-Siljansnas_Uvberget                       |   13 +-
 dvb-t/se-Skarstad                                  |   13 +-
 dvb-t/se-Skattungbyn                               |   13 +-
 dvb-t/se-Skelleftea                                |   65 +-
 dvb-t/se-Skene_Nycklarberget                       |   13 +-
 dvb-t/se-Skovde                                    |   65 +-
 dvb-t/se-Smedjebacken_Uvberget                     |   52 +-
 dvb-t/se-Soderhamn                                 |   26 +-
 dvb-t/se-Soderkoping                               |   26 +-
 dvb-t/se-Sodertalje_Ragnhildsborg                  |   78 +-
 dvb-t/se-Solleftea_Hallsta                         |   52 +-
 dvb-t/se-Solleftea_Multra                          |   52 +-
 dvb-t/se-Sorsjon                                   |   13 +-
 dvb-t/se-Stockholm_Marieberg                       |   65 +-
 dvb-t/se-Stockholm_Nacka                           |   78 +-
 dvb-t/se-Stora_Skedvi                              |   13 +-
 dvb-t/se-Storfjaten                                |   13 +-
 dvb-t/se-Storuman                                  |   52 +-
 dvb-t/se-Stromstad                                 |   65 +-
 dvb-t/se-Styrsjobo                                 |   13 +-
 dvb-t/se-Sundborn                                  |   13 +-
 dvb-t/se-Sundsbruk                                 |   52 +-
 dvb-t/se-Sundsvall_S_Stadsberget                   |   65 +-
 dvb-t/se-Sunne_Blabarskullen                       |   52 +-
 dvb-t/se-Svartnas                                  |   13 +-
 dvb-t/se-Sveg_Brickan                              |   52 +-
 dvb-t/se-Taberg                                    |   13 +-
 dvb-t/se-Tandadalen                                |   13 +-
 dvb-t/se-Tasjo                                     |   52 +-
 dvb-t/se-Tollsjo                                   |   13 +-
 dvb-t/se-Torsby_Bada                               |   52 +-
 dvb-t/se-Tranas_Bredkarr                           |   26 +-
 dvb-t/se-Tranemo                                   |   13 +-
 dvb-t/se-Transtrand_Bolheden                       |   26 +-
 dvb-t/se-Traryd_Betas                              |   26 +-
 dvb-t/se-Trollhattan                               |   65 +-
 dvb-t/se-Trosa                                     |   26 +-
 dvb-t/se-Tystberga                                 |   13 +-
 dvb-t/se-Uddevalla_Herrestad                       |   65 +-
 dvb-t/se-Ullared                                   |   13 +-
 dvb-t/se-Ulricehamn                                |   26 +-
 dvb-t/se-Ulvshyttan_Porjus                         |   13 +-
 dvb-t/se-Uppsala_Rickomberga                       |   13 +-
 dvb-t/se-Uppsala_Vedyxa                            |   65 +-
 dvb-t/se-Vaddo_Elmsta                              |   26 +-
 dvb-t/se-Valdemarsvik                              |   26 +-
 dvb-t/se-Vannas_Granlundsberget                    |   52 +-
 dvb-t/se-Vansbro_Hummelberget                      |   13 +-
 dvb-t/se-Varberg_Grimeton                          |   52 +-
 dvb-t/se-Vasteras_Lillharad                        |   65 +-
 dvb-t/se-Vastervik_Farhult                         |   52 +-
 dvb-t/se-Vaxbo                                     |   13 +-
 dvb-t/se-Vessigebro                                |   13 +-
 dvb-t/se-Vetlanda_Nye                              |   13 +-
 dvb-t/se-Vikmanshyttan                             |   13 +-
 dvb-t/se-Virserum                                  |   52 +-
 dvb-t/se-Visby_Follingbo                           |   65 +-
 dvb-t/se-Visby_Hamnen                              |   65 +-
 dvb-t/se-Visingso                                  |   13 +-
 dvb-t/se-Vislanda_Nydala                           |   52 +-
 dvb-t/se-Voxna                                     |   13 +-
 dvb-t/se-Ystad_Metallgatan                         |   65 +-
 dvb-t/se-Yttermalung                               |   13 +-
 dvb-t/si-Ljubljana                                 |   26 +-
 dvb-t/sk-BanskaBystrica                            |   26 +-
 dvb-t/sk-BanskaStiavnica                           |   26 +-
 dvb-t/sk-Bardejov                                  |   26 +-
 dvb-t/sk-Bratislava                                |   39 +-
 dvb-t/sk-Cadca                                     |   26 +-
 dvb-t/sk-Detva                                     |   26 +-
 dvb-t/sk-Hnusta                                    |   26 +-
 dvb-t/sk-Kosice                                    |   26 +-
 dvb-t/sk-KralovskyChlmec                           |   26 +-
 dvb-t/sk-Krompachy                                 |   26 +-
 dvb-t/sk-Lucenec                                   |   26 +-
 dvb-t/sk-Medzev                                    |   26 +-
 dvb-t/sk-Namestovo                                 |   26 +-
 dvb-t/sk-Nitra                                     |   26 +-
 dvb-t/sk-Poprad                                    |   39 +-
 dvb-t/sk-PovazskaBystrica                          |   26 +-
 dvb-t/sk-Presov                                    |   26 +-
 dvb-t/sk-Prievidza                                 |   26 +-
 dvb-t/sk-Revuca                                    |   26 +-
 dvb-t/sk-Roznava                                   |   26 +-
 dvb-t/sk-Ruzomberok                                |   26 +-
 dvb-t/sk-Snina                                     |   26 +-
 dvb-t/sk-StaraLubovna                              |   26 +-
 dvb-t/sk-Sturovo                                   |   26 +-
 dvb-t/sk-Trencin                                   |   26 +-
 dvb-t/sk-Zilina                                    |   26 +-
 dvb-t/tw-All                                       |  143 +-
 dvb-t/ua-Kharkov                                   |   56 +-
 dvb-t/ua-Kiev                                      |   56 +-
 dvb-t/ua-Lozovaya                                  |   56 +-
 dvb-t/ua-Odessa                                    |   56 +-
 dvb-t/ug-All                                       |   48 +-
 dvb-t/uk-Aberdare                                  |   79 +-
 dvb-t/uk-Angus                                     |   79 +-
 dvb-t/uk-BeaconHill                                |   79 +-
 dvb-t/uk-Belmont                                   |   93 +-
 dvb-t/uk-Bilsdale                                  |   93 +-
 dvb-t/uk-BlackHill                                 |  106 +-
 dvb-t/uk-Blaenplwyf                                |   79 +-
 dvb-t/uk-BluebellHill                              |   79 +-
 dvb-t/uk-Bressay                                   |   79 +-
 dvb-t/uk-BrierleyHill                              |   92 +-
 dvb-t/uk-BristolIlchesterCrescent                  |   92 +-
 dvb-t/uk-BristolKingsWeston                        |   92 +-
 dvb-t/uk-Bromsgrove                                |   79 +-
 dvb-t/uk-BrougherMountain                          |   93 +-
 dvb-t/uk-Caldbeck                                  |   79 +-
 dvb-t/uk-CaradonHill                               |   79 +-
 dvb-t/uk-Carmel                                    |   79 +-
 dvb-t/uk-Chatton                                   |   79 +-
 dvb-t/uk-Chesterfield                              |   79 +-
 dvb-t/uk-Craigkelly                                |  106 +-
 dvb-t/uk-CrystalPalace                             |   93 +-
 dvb-t/uk-Darvel                                    |   79 +-
 dvb-t/uk-Divis                                     |   93 +-
 dvb-t/uk-Dover                                     |   79 +-
 dvb-t/uk-Durris                                    |   79 +-
 dvb-t/uk-Eitshal                                   |   79 +-
 dvb-t/uk-EmleyMoor                                 |  106 +-
 dvb-t/uk-Fenham                                    |   79 +-
 dvb-t/uk-Fenton                                    |   79 +-
 dvb-t/uk-Ferryside                                 |   53 +-
 dvb-t/uk-Guildford                                 |   79 +-
 dvb-t/uk-Hannington                                |   93 +-
 dvb-t/uk-Hastings                                  |   79 +-
 dvb-t/uk-Heathfield                                |   79 +-
 dvb-t/uk-HemelHempstead                            |   79 +-
 dvb-t/uk-HuntshawCross                             |   79 +-
 dvb-t/uk-Idle                                      |   79 +-
 dvb-t/uk-KeelylangHill                             |   79 +-
 dvb-t/uk-Keighley                                  |   79 +-
 dvb-t/uk-KilveyHill                                |   79 +-
 dvb-t/uk-KnockMore                                 |   79 +-
 dvb-t/uk-Lancaster                                 |   79 +-
 dvb-t/uk-LarkStoke                                 |   79 +-
 dvb-t/uk-Limavady                                  |   79 +-
 dvb-t/uk-Llanddona                                 |   79 +-
 dvb-t/uk-Malvern                                   |   79 +-
 dvb-t/uk-Mendip                                    |   79 +-
 dvb-t/uk-Midhurst                                  |   79 +-
 dvb-t/uk-MoelyParc                                 |   79 +-
 dvb-t/uk-Nottingham                                |   92 +-
 dvb-t/uk-OliversMount                              |   79 +-
 dvb-t/uk-Oxford                                    |   79 +-
 dvb-t/uk-PendleForest                              |   79 +-
 dvb-t/uk-Plympton                                  |   79 +-
 dvb-t/uk-PontopPike                                |  106 +-
 dvb-t/uk-Pontypool                                 |   79 +-
 dvb-t/uk-Preseli                                   |   79 +-
 dvb-t/uk-Redruth                                   |   79 +-
 dvb-t/uk-Reigate                                   |   79 +-
 dvb-t/uk-RidgeHill                                 |   79 +-
 dvb-t/uk-Rosemarkie                                |   79 +-
 dvb-t/uk-Rosneath                                  |   79 +-
 dvb-t/uk-Rowridge                                  |  106 +-
 dvb-t/uk-RumsterForest                             |   79 +-
 dvb-t/uk-Saddleworth                               |   79 +-
 dvb-t/uk-Salisbury                                 |   79 +-
 dvb-t/uk-SandyHeath                                |   93 +-
 dvb-t/uk-Selkirk                                   |   79 +-
 dvb-t/uk-Sheffield                                 |   79 +-
 dvb-t/uk-StocklandHill                             |   79 +-
 dvb-t/uk-Storeton                                  |   92 +-
 dvb-t/uk-Sudbury                                   |   79 +-
 dvb-t/uk-SuttonColdfield                           |  106 +-
 dvb-t/uk-Tacolneston                               |   79 +-
 dvb-t/uk-TheWrekin                                 |   79 +-
 dvb-t/uk-Torosay                                   |   79 +-
 dvb-t/uk-TunbridgeWells                            |   79 +-
 dvb-t/uk-Waltham                                   |  106 +-
 dvb-t/uk-Wenvoe                                    |  106 +-
 dvb-t/uk-WhitehawkHill                             |   79 +-
 dvb-t/uk-WinterHill                                |   93 +-
 dvb-t/vn-Hanoi                                     |   26 +-
 dvb-t/vn-Thaibinh                                  |   26 +-
 dvbv5_dvb-t/fi-Aanekoski                           |   23 -
 dvbv5_dvb-t/fi-Aanekoski_Konginkangas              |   23 -
 dvbv5_dvb-t/fi-Ahtari                              |   13 -
 dvbv5_dvb-t/fi-Alajarvi                            |   23 -
 dvbv5_dvb-t/fi-Anjalankoski_Ruotila                |   28 -
 dvbv5_dvb-t/fi-Enontekio_Ahovaara                  |   13 -
 dvbv5_dvb-t/fi-Enontekio_Hetta                     |   13 -
 dvbv5_dvb-t/fi-Enontekio_Kuttanen                  |   13 -
 dvbv5_dvb-t/fi-Espoo                               |   28 -
 dvbv5_dvb-t/fi-Eurajoki                            |   28 -
 dvbv5_dvb-t/fi-Fiskars                             |   23 -
 dvbv5_dvb-t/fi-Haapavesi                           |   23 -
 dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski               |   23 -
 dvbv5_dvb-t/fi-Hameenlinna_Painokangas             |   18 -
 dvbv5_dvb-t/fi-Hanko                               |   23 -
 dvbv5_dvb-t/fi-Hartola                             |   18 -
 dvbv5_dvb-t/fi-Heinavesi                           |   18 -
 dvbv5_dvb-t/fi-Heinola                             |   23 -
 dvbv5_dvb-t/fi-Hyrynsalmi                          |   18 -
 dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara              |   18 -
 dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka                 |   18 -
 dvbv5_dvb-t/fi-Hyvinkaa                            |   23 -
 dvbv5_dvb-t/fi-Ii_Raiskio                          |   13 -
 dvbv5_dvb-t/fi-Iisalmi                             |   13 -
 dvbv5_dvb-t/fi-Ikaalinen                           |   23 -
 dvbv5_dvb-t/fi-Ikaalinen_Riitiala                  |   23 -
 dvbv5_dvb-t/fi-Inari                               |   13 -
 dvbv5_dvb-t/fi-Inari_Janispaa                      |   13 -
 dvbv5_dvb-t/fi-Inari_Naatamo                       |   13 -
 dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara             |   13 -
 dvbv5_dvb-t/fi-Jalasjarvi                          |   23 -
 dvbv5_dvb-t/fi-Jamsa_Halli                         |   23 -
 dvbv5_dvb-t/fi-Jamsa_Kaipola                       |   23 -
 dvbv5_dvb-t/fi-Jamsa_Matkosvuori                   |   23 -
 dvbv5_dvb-t/fi-Jamsa_Ouninpohja                    |   18 -
 dvbv5_dvb-t/fi-Jamsankoski                         |   23 -
 dvbv5_dvb-t/fi-Joensuu_Vestinkallio                |   18 -
 dvbv5_dvb-t/fi-Joroinen_Puukkola                   |   18 -
 dvbv5_dvb-t/fi-Joutsa_Lankia                       |   23 -
 dvbv5_dvb-t/fi-Joutseno                            |   28 -
 dvbv5_dvb-t/fi-Juupajoki_Kopsamo                   |   18 -
 dvbv5_dvb-t/fi-Juva                                |   23 -
 dvbv5_dvb-t/fi-Jyvaskyla                           |   28 -
 dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski                |   18 -
 dvbv5_dvb-t/fi-Kaavi_Sivakkavaara                  |   18 -
 dvbv5_dvb-t/fi-Kajaani_Pollyvaara                  |   18 -
 dvbv5_dvb-t/fi-Kalajoki                            |   18 -
 dvbv5_dvb-t/fi-Kangaslampi                         |   23 -
 dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki              |   23 -
 dvbv5_dvb-t/fi-Kankaanpaa                          |   23 -
 dvbv5_dvb-t/fi-Karigasniemi                        |   13 -
 dvbv5_dvb-t/fi-Karkkila                            |   23 -
 dvbv5_dvb-t/fi-Karstula                            |   18 -
 dvbv5_dvb-t/fi-Karvia                              |   18 -
 dvbv5_dvb-t/fi-Kaunispaa                           |   13 -
 dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi              |   13 -
 dvbv5_dvb-t/fi-Kerimaki                            |   23 -
 dvbv5_dvb-t/fi-Keuruu                              |   23 -
 dvbv5_dvb-t/fi-Keuruu_Haapamaki                    |   23 -
 dvbv5_dvb-t/fi-Kihnio                              |   23 -
 dvbv5_dvb-t/fi-Kiihtelysvaara                      |   13 -
 dvbv5_dvb-t/fi-Kilpisjarvi                         |   13 -
 dvbv5_dvb-t/fi-Kittila_Levitunturi                 |   13 -
 dvbv5_dvb-t/fi-Kolari_Vuolittaja                   |   13 -
 dvbv5_dvb-t/fi-Koli                                |   23 -
 dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori              |   23 -
 dvbv5_dvb-t/fi-Korppoo                             |   23 -
 dvbv5_dvb-t/fi-Kruunupyy                           |   28 -
 dvbv5_dvb-t/fi-Kuhmo_Haukela                       |   18 -
 dvbv5_dvb-t/fi-Kuhmo_Lentiira                      |   18 -
 dvbv5_dvb-t/fi-Kuhmo_Niva                          |   18 -
 dvbv5_dvb-t/fi-Kuhmoinen                           |   23 -
 dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi               |   23 -
 dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen                |   18 -
 dvbv5_dvb-t/fi-Kuopio                              |   28 -
 dvbv5_dvb-t/fi-Kurikka_Kesti                       |   23 -
 dvbv5_dvb-t/fi-Kustavi_Viherlahti                  |   23 -
 dvbv5_dvb-t/fi-Kuusamo_Hamppulampi                 |   13 -
 dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho                 |   18 -
 dvbv5_dvb-t/fi-Lahti                               |   28 -
 dvbv5_dvb-t/fi-Lapua                               |   28 -
 dvbv5_dvb-t/fi-Laukaa                              |   23 -
 dvbv5_dvb-t/fi-Laukaa_Vihtavuori                   |   23 -
 dvbv5_dvb-t/fi-Lavia                               |   18 -
 dvbv5_dvb-t/fi-Lohja                               |   23 -
 dvbv5_dvb-t/fi-Loimaa                              |   23 -
 dvbv5_dvb-t/fi-Luhanka                             |   23 -
 dvbv5_dvb-t/fi-Luopioinen                          |   23 -
 dvbv5_dvb-t/fi-Mantta                              |   23 -
 dvbv5_dvb-t/fi-Mantyharju                          |   18 -
 dvbv5_dvb-t/fi-Mikkeli                             |   23 -
 dvbv5_dvb-t/fi-Muonio_Olostunturi                  |   13 -
 dvbv5_dvb-t/fi-Nilsia                              |   23 -
 dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi             |   18 -
 dvbv5_dvb-t/fi-Nilsia_Pisa                         |   18 -
 dvbv5_dvb-t/fi-Nokia                               |   23 -
 dvbv5_dvb-t/fi-Nokia_Siuro                         |   23 -
 dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola                |   23 -
 dvbv5_dvb-t/fi-Nuorgam_Njallavaara                 |   13 -
 dvbv5_dvb-t/fi-Nuorgam_raja                        |   13 -
 dvbv5_dvb-t/fi-Nurmes_Konnanvaara                  |   23 -
 dvbv5_dvb-t/fi-Nurmes_Kortevaara                   |   18 -
 dvbv5_dvb-t/fi-Orivesi_Talviainen                  |   18 -
 dvbv5_dvb-t/fi-Oulu                                |   28 -
 dvbv5_dvb-t/fi-Padasjoki                           |   23 -
 dvbv5_dvb-t/fi-Padasjoki_Arrakoski                 |   23 -
 dvbv5_dvb-t/fi-Paltamo_Kivesvaara                  |   18 -
 dvbv5_dvb-t/fi-Parainen_Houtskari                  |   23 -
 dvbv5_dvb-t/fi-Parikkala                           |   23 -
 dvbv5_dvb-t/fi-Parkano_Sopukallio                  |   23 -
 dvbv5_dvb-t/fi-Pello                               |   13 -
 dvbv5_dvb-t/fi-Pello_Ratasvaara                    |   13 -
 dvbv5_dvb-t/fi-Perho                               |   23 -
 dvbv5_dvb-t/fi-Pernaja                             |   18 -
 dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu               |   18 -
 dvbv5_dvb-t/fi-Pihtipudas                          |   18 -
 dvbv5_dvb-t/fi-Porvoo_Suomenkyla                   |   23 -
 dvbv5_dvb-t/fi-Posio                               |   13 -
 dvbv5_dvb-t/fi-Pudasjarvi                          |   18 -
 dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote                |   18 -
 dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara              |   13 -
 dvbv5_dvb-t/fi-Puolanka                            |   23 -
 dvbv5_dvb-t/fi-Pyhatunturi                         |   13 -
 dvbv5_dvb-t/fi-Pyhavuori                           |   18 -
 dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi             |   18 -
 dvbv5_dvb-t/fi-Raahe_Mestauskallio                 |   23 -
 dvbv5_dvb-t/fi-Raahe_Piehinki                      |   18 -
 dvbv5_dvb-t/fi-Ranua_Haasionmaa                    |   13 -
 dvbv5_dvb-t/fi-Ranua_Leppiaho                      |   13 -
 dvbv5_dvb-t/fi-Rautavaara_Angervikko               |   23 -
 dvbv5_dvb-t/fi-Rautjarvi_Simpele                   |   18 -
 dvbv5_dvb-t/fi-Ristijarvi                          |   18 -
 dvbv5_dvb-t/fi-Rovaniemi                           |   18 -
 dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara              |   13 -
 dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara                |   13 -
 dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio             |   13 -
 dvbv5_dvb-t/fi-Rovaniemi_Rantalaki                 |   13 -
 dvbv5_dvb-t/fi-Rovaniemi_Sonka                     |   13 -
 dvbv5_dvb-t/fi-Rovaniemi_Sorviselka                |   13 -
 dvbv5_dvb-t/fi-Ruka                                |   18 -
 dvbv5_dvb-t/fi-Ruovesi_Storminiemi                 |   23 -
 dvbv5_dvb-t/fi-Saarijarvi                          |   23 -
 dvbv5_dvb-t/fi-Saarijarvi_Kalmari                  |   18 -
 dvbv5_dvb-t/fi-Saarijarvi_Mahlu                    |   18 -
 dvbv5_dvb-t/fi-Salla_Hirvasvaara                   |   13 -
 dvbv5_dvb-t/fi-Salla_Ihistysjanka                  |   13 -
 dvbv5_dvb-t/fi-Salla_Naruska                       |   13 -
 dvbv5_dvb-t/fi-Salla_Sallatunturi                  |   13 -
 dvbv5_dvb-t/fi-Salla_Sarivaara                     |   13 -
 dvbv5_dvb-t/fi-Salo_Isokyla                        |   23 -
 dvbv5_dvb-t/fi-Savukoski_Martti                    |   13 -
 dvbv5_dvb-t/fi-Savukoski_Tanhua                    |   13 -
 dvbv5_dvb-t/fi-Siilinjarvi                         |   23 -
 dvbv5_dvb-t/fi-Simo_Viantie                        |   18 -
 dvbv5_dvb-t/fi-Sipoo_Norrkulla                     |   23 -
 dvbv5_dvb-t/fi-Sodankyla_Pittiovaara               |   13 -
 dvbv5_dvb-t/fi-Sodankyla_Vuotso                    |   13 -
 dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki                |   18 -
 dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki              |   13 -
 dvbv5_dvb-t/fi-Suomussalmi_Ammansaari              |   13 -
 dvbv5_dvb-t/fi-Suomussalmi_Juntusranta             |   13 -
 dvbv5_dvb-t/fi-Suomussalmi_Myllylahti              |   13 -
 dvbv5_dvb-t/fi-Sysma_Liikola                       |   23 -
 dvbv5_dvb-t/fi-Taivalkoski                         |   13 -
 dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara             |   13 -
 dvbv5_dvb-t/fi-Tammela                             |   28 -
 dvbv5_dvb-t/fi-Tammisaari                          |   23 -
 dvbv5_dvb-t/fi-Tampere                             |   28 -
 dvbv5_dvb-t/fi-Tampere_Pyynikki                    |   28 -
 dvbv5_dvb-t/fi-Tervola                             |   18 -
 dvbv5_dvb-t/fi-Turku                               |   28 -
 dvbv5_dvb-t/fi-Utsjoki                             |   13 -
 dvbv5_dvb-t/fi-Utsjoki_Nuvvus                      |   13 -
 dvbv5_dvb-t/fi-Utsjoki_Outakoski                   |   13 -
 dvbv5_dvb-t/fi-Utsjoki_Polvarniemi                 |   13 -
 dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto                 |   13 -
 dvbv5_dvb-t/fi-Utsjoki_Tenola                      |   13 -
 dvbv5_dvb-t/fi-Uusikaupunki_Orivo                  |   23 -
 dvbv5_dvb-t/fi-Vaala                               |   18 -
 dvbv5_dvb-t/fi-Vaasa                               |   18 -
 dvbv5_dvb-t/fi-Valtimo                             |   18 -
 dvbv5_dvb-t/fi-Vammala_Jyranvuori                  |   23 -
 dvbv5_dvb-t/fi-Vammala_Roismala                    |   18 -
 dvbv5_dvb-t/fi-Vammala_Savi                        |   18 -
 dvbv5_dvb-t/fi-Vantaa_Hakunila                     |   23 -
 dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki              |   23 -
 dvbv5_dvb-t/fi-Virrat_Lappavuori                   |   23 -
 dvbv5_dvb-t/fi-Vuokatti                            |   23 -
 dvbv5_dvb-t/fi-Ylitornio_Ainiovaara                |   18 -
 dvbv5_dvb-t/fi-Ylitornio_Raanujarvi                |   13 -
 dvbv5_dvb-t/fi-Yllas                               |   13 -
 dvbv5_dvb-t/fi-Yllasjarvi                          |   13 -
 isdb-t/ar-Argentina                                | 1447 ++++++++++++++
 {dvbv5_isdb-t => isdb-t}/br-Brazil                 |    0
 {dvbv5_isdb-t => isdb-t}/br-ac-Bujari              |    0
 {dvbv5_isdb-t => isdb-t}/br-ac-PortoAcre           |    0
 {dvbv5_isdb-t => isdb-t}/br-ac-RioBranco           |    0
 {dvbv5_isdb-t => isdb-t}/br-ac-SenadorGuiomard     |    0
 {dvbv5_isdb-t => isdb-t}/br-al-Arapiraca           |    0
 {dvbv5_isdb-t => isdb-t}/br-al-Craibas             |    0
 {dvbv5_isdb-t => isdb-t}/br-al-Maceio              |    0
 {dvbv5_isdb-t => isdb-t}/br-al-Piranhas            |    0
 {dvbv5_isdb-t => isdb-t}/br-al-RioLargo            |    0
 {dvbv5_isdb-t => isdb-t}/br-al-SaoMiguelDosCampos  |    0
 {dvbv5_isdb-t => isdb-t}/br-am-CareiroDaVarzea     |    0
 {dvbv5_isdb-t => isdb-t}/br-am-Iranduba            |    0
 {dvbv5_isdb-t => isdb-t}/br-am-Manaquiri           |    0
 {dvbv5_isdb-t => isdb-t}/br-am-Manaus              |    0
 {dvbv5_isdb-t => isdb-t}/br-am-Parintins           |    0
 {dvbv5_isdb-t => isdb-t}/br-ap-Macapa              |    0
 {dvbv5_isdb-t => isdb-t}/br-ap-Santana             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Alagoinhas          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Alcobaca            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Amargosa            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-AmeliaRodrigues     |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Anguera             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-AntonioCardoso      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Aracatu             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Barra               |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-BarraDoChoca        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Barreiras           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-BeloCampo           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Biritinga           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-BomJesusDaLapa      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Brumado             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Caetite             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Camacari            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-CampoFormoso        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Candeal             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Candeias            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-CandidoSales        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Caraibas            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-ConceicaoDaFeira    |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-ConceicaoDoJacuipe  |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-CoracaoDeMaria      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-CruzDasAlmas        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-DiasDAvila          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-EntreRios           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Eunapolis           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-FeiraDeSantana      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Guanambi            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Ichu                |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Ilheus              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Inhambupe           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Ipecaeta            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Irara               |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Irece               |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Itabuna             |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Itamaraju           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Itambe              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Itaparica           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Itapetinga          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Jacobina            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Jaguaquara          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Jaguaripe           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Jequie              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Juazeiro            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-LauroDeFreitas      |    0
 .../br-ba-LuisEduardoMagalhaes                     |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-MadreDeDeus         |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Maragogipe          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-MataDeSaoJoao       |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Nazare              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-PauloAfonso         |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Piripa              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Planalto            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Pocoes              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Pojuca              |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-PortoSeguro         |    0
 .../br-ba-PresidenteJanioQuadros                   |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-RafaelJambeiro      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SalinasDaMargarida  |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Salvador            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantaBarbara        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantaCruzCabralia   |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantaMariaDaVitoria |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Santanopolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantoAmaro          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantoAntonioDeJesus |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SantoEstevao        |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SaoFranciscoDoConde |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SaoGoncaloDosCampos |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SaoSebastiaoDoPasse |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SenhorDoBonfim      |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SerraPreta          |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Serrinha            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-SimoesFilho         |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Tanquinho           |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-TeixeiraDeFreitas   |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Teofilandia         |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Tremedal            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-VeraCruz            |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-VitoriaDaConquista  |    0
 {dvbv5_isdb-t => isdb-t}/br-ba-Xiquexique          |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Acarape             |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Aquiraz             |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Aurora              |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Caninde             |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Fortaleza           |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Horizonte           |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Maracanau           |    0
 .../br-ce-MaranguapeItapebussu                     |    0
 {dvbv5_isdb-t => isdb-t}/br-ce-Pacajus             |    0
 {dvbv5_isdb-t => isdb-t}/br-df-Brasilia            |    0
 {dvbv5_isdb-t => isdb-t}/br-df-BrasiliaGama        |    0
 .../br-es-CachoeiroDoItapemirim                    |    0
 {dvbv5_isdb-t => isdb-t}/br-es-Colatina            |    0
 {dvbv5_isdb-t => isdb-t}/br-es-Guarapari           |    0
 {dvbv5_isdb-t => isdb-t}/br-es-Linhares            |    0
 {dvbv5_isdb-t => isdb-t}/br-es-SaoMateus           |    0
 {dvbv5_isdb-t => isdb-t}/br-es-Vitoria             |    0
 {dvbv5_isdb-t => isdb-t}/br-go-AguasLindasDeGoias  |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Alexania            |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Anapolis            |    0
 {dvbv5_isdb-t => isdb-t}/br-go-AparecidaDeGoiania  |    0
 {dvbv5_isdb-t => isdb-t}/br-go-CaldasNovas         |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Catalao             |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Cristalina          |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Formosa             |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Goianesia           |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Goiania             |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Guapo               |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Inhumas             |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Itumbiara           |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Jatai               |    0
 {dvbv5_isdb-t => isdb-t}/br-go-Luziania            |    0
 {dvbv5_isdb-t => isdb-t}/br-go-PlanaltinaDeGoias   |    0
 {dvbv5_isdb-t => isdb-t}/br-go-RioVerde            |    0
 {dvbv5_isdb-t => isdb-t}/br-go-SantaHelenaDeGoias  |    0
 .../br-go-SantoAntonioDoDescoberto                 |    0
 .../br-go-SaoLuisDeMontesBelos                     |    0
 {dvbv5_isdb-t => isdb-t}/br-go-SenadorCanedo       |    0
 {dvbv5_isdb-t => isdb-t}/br-go-ValparaisoDeGoias   |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Alcantara           |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Axixa               |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-CachoeiraGrande     |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Caxias              |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-HumbertoDeCampos    |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Imperatriz          |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Morros              |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-PacoDoLumiar        |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-PresidenteJuscelino |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-PrimeiraCruz        |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Raposa              |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Rosario             |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-SaoJoseDeRibamar    |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-SaoLuis             |    0
 {dvbv5_isdb-t => isdb-t}/br-ma-Timon               |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-AguaComprida        |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Alfenas             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Almenara            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Andradas            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Araguari            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Arapora             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Araxa               |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Arinos              |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Barbacena           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Barroso             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-BeloHorizonte       |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Betim               |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-BordaDaMata         |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Campanha            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Caratinga           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Cataguases          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Claraval            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-CoronelFabriciano   |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Curvelo             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Diamantina          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Divinopolis         |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Fronteira           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Frutal              |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-GovernadorValadares |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Guanhaes            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Guaxupe             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Ibirite             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Ipatinga            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Itabira             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Itajuba             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Itapagipe           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Ituiutaba           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Janauba             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Januaria            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-JuizDeFora          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Manhuacu            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Mariana             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-MonteSiao           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-MontesClaros        |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Muriae              |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Oliveira            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-OuroFino            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Paracatu            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Passos              |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-PatosDeMinas        |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Periquito           |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Pirapora            |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Planura             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-PocosDeCaldas       |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-PousoAlegre         |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-SantaRitaDoSapucai  |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-SaoJoaoDelRei       |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-SaoLourenco         |    0
 .../br-mg-SaoSebastiaoDoParaiso                    |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-SeteLagoas          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-TeofiloOtoni        |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Timoteo             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-TresCoracoes        |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-TresPontas          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Uberaba             |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Uberlandia          |    0
 {dvbv5_isdb-t => isdb-t}/br-mg-Varginha            |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Anastacio           |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Aquidauana          |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-CampoGrande         |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Corumba             |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Dourados            |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Ladario             |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-NovaAndradina       |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Paranaiba           |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-PontaPora           |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Rochedo             |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-Sidrolandia         |    0
 {dvbv5_isdb-t => isdb-t}/br-ms-TresLagoas          |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-AltaFloresta        |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-Cuiaba              |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-Rondonopolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-Sinop               |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-Sorriso             |    0
 {dvbv5_isdb-t => isdb-t}/br-mt-TangaraDaSerra      |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Abaetetuba          |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Afua                |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Barcarena           |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Belem               |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Belterra            |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Castanhal           |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Maraba              |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Moju                |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-PontaDePedras       |    0
 {dvbv5_isdb-t => isdb-t}/br-pa-Santarem            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-AlagoaGrande        |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Alagoinha           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Aparecida           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Bayeux              |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-BomJesus            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Cabedelo            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-CachoeiraDosIndios  |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-CacimbaDeDentro     |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Cajazeiras          |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-CaldasBrandao       |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-CampinaGrande       |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Catingueira         |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Condado             |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Cuitegi             |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Desterro            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Guarabira           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Gurinhem            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Imaculada           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Itabaiana           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Jacarau             |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-JoaoPessoa          |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Juripiranga         |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-LagoaSeca           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Lucena              |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-MaeDAgua            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Mamanguape          |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Marizopolis         |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Massaranduba        |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Matinhas            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Matureia            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Mulungu             |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-OlhoDAgua           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Patos               |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Pilar               |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Piloezinhos         |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Puxinana            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-RioTinto            |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-SantaRita           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-SantaTeresinha      |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-SaoFrancisco        |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-SaoJoseDePiranhas   |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-SaoMamede           |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Sape                |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Sousa               |    0
 {dvbv5_isdb-t => isdb-t}/br-pb-Teixeira            |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Agrestina           |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Altinho             |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Bezerros            |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Camaragibe          |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Caruaru             |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Garanhuns           |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Jupi                |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Limoeiro            |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Petrolina           |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-Recife              |    0
 {dvbv5_isdb-t => isdb-t}/br-pe-SaoLourencoDaMata   |    0
 {dvbv5_isdb-t => isdb-t}/br-pi-Teresina            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-AltoParana          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-AltoPiquiri         |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Antonina            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Apucarana           |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Arapongas           |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-AssisChateaubriand  |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-BoaVistaDaAparecida |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Cafelandia          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Cambe               |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-CampoLargo          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-CampoMourao         |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Carambei            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Cascavel            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-CeuAzul             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Cianorte            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Colombo             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Corbelia            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-CornelioProcopio    |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Curitiba            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Florestopolis       |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-FozDoIguacu         |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-FranciscoBeltrao    |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Guaraniacu          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Guarapuava          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Guaratuba           |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-HonorioSerpa        |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Ibema               |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Ibipora             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Imbituva            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Irati               |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Ivaipora            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Jacarezinho         |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Japira              |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Jataizinho          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Lapa                |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Londrina            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Maringa             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Matinhos            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-MoreiraSales        |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-NovaAurora          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Paranagua           |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Paranavai           |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-PatoBranco          |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Perola              |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-PontaGrossa         |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-PontalDoParana      |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Porecatu            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-PrimeiroDeMaio      |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-RioNegro            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Rolandia            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Sarandi             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Sertanopolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-TeixeiraSoares      |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-TelemacoBorba       |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Toledo              |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-TresBarrasDoParana  |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Tupassi             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Ubirata             |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Umuarama            |    0
 {dvbv5_isdb-t => isdb-t}/br-pr-Vere                |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-AngraDosReis        |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Araruama            |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-ArraialDoCabo       |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-BarraMansa          |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-CaboFrio            |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-CamposDosGoytacazes |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-DuqueDeCaxias       |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Itaguai             |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Itaperuna           |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Itatiaia            |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Macae               |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Marica              |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-NovaFriburgo        |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-NovaIguacu          |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Queimados           |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Quissama            |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Resende             |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-RioBonito           |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-RioDasOstras        |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-RioDeJaneiro        |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-SaoGoncalo          |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-SaoJoaoDaBarra      |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-SaoJoaoDeMeriti     |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-SaoPedroDaAldeia    |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-Saquarema           |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-SilvaJardim         |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-TrajanoDeMorais     |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-TresRios            |    0
 {dvbv5_isdb-t => isdb-t}/br-rj-VoltaRedonda        |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-Extremoz            |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-Macaiba             |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-Mossoro             |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-Natal               |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-SaoJoseDeMipibu     |    0
 {dvbv5_isdb-t => isdb-t}/br-rn-SenadorEloiDeSousa  |    0
 {dvbv5_isdb-t => isdb-t}/br-ro-Ariquemes           |    0
 {dvbv5_isdb-t => isdb-t}/br-ro-Cacoal              |    0
 {dvbv5_isdb-t => isdb-t}/br-ro-Jiparana            |    0
 {dvbv5_isdb-t => isdb-t}/br-ro-PimentaBueno        |    0
 {dvbv5_isdb-t => isdb-t}/br-ro-PortoVelho          |    0
 {dvbv5_isdb-t => isdb-t}/br-rr-BoaVista            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Alegrete            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-ArroioDoSal         |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Bage                |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-BentoGoncalves      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CachoeiraDoSul      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Camaqua             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CampoBom            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Candelaria          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Canela              |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Cangucu             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CapaoDaCanoa        |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CapaoDoLeao         |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Carazinho           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CarlosBarbosa       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CaxiasDoSul         |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Cidreira            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-CruzAlta            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-DomPedroDeAlcantara |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Erechim             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Estrela             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Farroupilha         |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Feliz               |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-FloresDaCunha       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Gramado             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Ijui                |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Lajeado             |    0
 .../br-rs-MonteAlegreDosCampos                     |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Montenegro          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-MorroRedondo        |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-NovaPetropolis      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-NovaSantaRita       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-NovoHamburgo        |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Osorio              |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-PalmaresDoSul       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-ParaisoDoSul        |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-PassoFundo          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Pelotas             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-PicadaCafe          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-PortoAlegre         |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-RioGrande           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-RioGrandeCassino    |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SalvadorDoSul       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Sananduva           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SantaCruzDoSul      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SantaMaria          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SantaRosa           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SantanaDoLivramento |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SantoAngelo         |    0
 .../br-rs-SantoAntonioDaPatrulha                   |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SaoBorja            |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SaoGabriel          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SaoJoseDoNorte      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-SaoSepe             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Sapiranga           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Sertao              |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Taquara             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-TerraDeAreia        |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Torres              |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Tramandai           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-TresCachoeiras      |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-TresCoroas          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-TresDeMaio          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Triunfo             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Tucunduva           |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Uruguaiana          |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Vacaria             |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-VenancioAires       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-VilaNovaDoSul       |    0
 {dvbv5_isdb-t => isdb-t}/br-rs-Xangrila            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Agronomica          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-AguasMornas         |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-AntonioCarlos       |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Ararangua           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Aurora              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-BalnearioCamboriu   |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-BarraVelha          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Blumenau            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Brusque             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Cacador             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Canoinhas           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-CapaoAlto           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-CapivariDeBaixo     |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Chapeco             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Concordia           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-CorreiaPinto        |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Corupa              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Criciuma            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Florianopolis       |    0
 .../br-sc-FlorianopolisCanasvieiras                |    0
 .../br-sc-FlorianopolisIngleses                    |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Garopaba            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Garuva              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Gaspar              |    0
 .../br-sc-GovernadorCelsoRamos                     |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Guabiruba           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Guaramirim          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-HervalDOeste        |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Icara               |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Itajai              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Itapema             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Itapoa              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-JaraguaDoSul        |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Joacaba             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Joinville           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Lages               |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Laguna              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Laurentino          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Lontras             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Mafra               |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Massaranduba        |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Navegantes          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-NovaVeneza          |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Painel              |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-PassoDeTorres       |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Penha               |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Picarras            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-RioDoSul            |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-RioNegrinho         |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-SantaRosaDoSul      |    0
 .../br-sc-SantoAmaroDaImperatriz                   |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-SaoBentoDoSul       |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Schroeder           |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Sombrio             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Tijucas             |    0
 {dvbv5_isdb-t => isdb-t}/br-sc-Tubarao             |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Aquidaba            |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Aracaju             |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Araua               |    0
 {dvbv5_isdb-t => isdb-t}/br-se-AreiaBranca         |    0
 {dvbv5_isdb-t => isdb-t}/br-se-BarraDosCoqueiros   |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Boquim              |    0
 {dvbv5_isdb-t => isdb-t}/br-se-CampoDoBrito        |    0
 .../br-se-CanindeDeSaoFrancisco                    |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Capela              |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Carira              |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Carmopolis          |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Cristinapolis       |    0
 {dvbv5_isdb-t => isdb-t}/br-se-DivinaPastora       |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Estancia            |    0
 {dvbv5_isdb-t => isdb-t}/br-se-FeiraNova           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-FreiPaulo           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Gararu              |    0
 {dvbv5_isdb-t => isdb-t}/br-se-GeneralMaynard      |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Itabaiana           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Itabaianinha        |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Itabi               |    0
 {dvbv5_isdb-t => isdb-t}/br-se-ItaporangaDAjuda    |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Japaratuba          |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Lagarto             |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Laranjeiras         |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Macambira           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Malhador            |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Maruim              |    0
 {dvbv5_isdb-t => isdb-t}/br-se-MoitaBonita         |    0
 .../br-se-MonteAlegreDeSergipe                     |    0
 .../br-se-NossaSenhoraAparecida                    |    0
 .../br-se-NossaSenhoraDaGloria                     |    0
 .../br-se-NossaSenhoraDoSocorro                    |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Pedrinhas           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-PocoRedondo         |    0
 {dvbv5_isdb-t => isdb-t}/br-se-RiachaoDoDantas     |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Riachuelo           |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Ribeiropolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-se-RosarioDoCatete     |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Salgado             |    0
 {dvbv5_isdb-t => isdb-t}/br-se-SantaLuziaDoIntanhy |    0
 {dvbv5_isdb-t => isdb-t}/br-se-SantoAmaroDasBrotas |    0
 {dvbv5_isdb-t => isdb-t}/br-se-SaoCristovao        |    0
 {dvbv5_isdb-t => isdb-t}/br-se-SaoDomingos         |    0
 {dvbv5_isdb-t => isdb-t}/br-se-SaoMiguelDoAleixo   |    0
 {dvbv5_isdb-t => isdb-t}/br-se-TomarDoGeru         |    0
 {dvbv5_isdb-t => isdb-t}/br-se-Umbauba             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Aguai               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-AguasDeLindoia      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-AguasDeSaoPedro     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Agudos              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Americana           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-AmericoBrasiliense  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Amparo              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Andradina           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Aparecida           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-AparecidaDOeste     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Apiai               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Aracatuba           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Araraquara          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Araras              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Arealva             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Assis               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Atibaia             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Auriflama           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-BarraBonita         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Barretos            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Batatais            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Bauru               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Bebedouro           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Bertioga            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Birigui             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Boituva             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Botucatu            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-BragancaPaulista    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Brodowski           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-CachoeiraPaulista   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cajamar             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cajati              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cajobi              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Campinas            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-CampoLimpoPaulista  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-CamposDoJordao      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Capivari            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Caraguatatuba       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Carapicuiba         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-CassiaDosCoqueiros  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Catanduva           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Colina              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Colombia            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cravinhos           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-CristaisPaulista    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cruzeiro            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Cubatao             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Diadema             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Dracena             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Dumont              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Eldorado            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-EmbuDasArtes        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-EstivaGerbi         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-EstrelaDOeste       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Fernandopolis       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-FerrazDeVasconcelos |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Franca              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-FrancoDaRocha       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Garca               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Guapiacu            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-GuaraniDOeste       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Guaratingueta       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Guaruja             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Guarulhos           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Guzolandia          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Hortolandia         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Iacanga             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ibate               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ibitinga            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ibiuna              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-IgaracuDoTiete      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Iguape              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-IlhaComprida        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-IlhaSolteira        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ilhabela            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Indaiatuba          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ipero               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itanhaem            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itapetininga        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itapeva             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itapevi             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itapolis            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itaquaquecetuba     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Itu                 |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jaborandi           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jaboticabal         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jacarei             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jaci                |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jacupiranga         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jaguariuna          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jales               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jandira             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jardinopolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jau                 |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jeriquara           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-JoseBonifacio       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Jundiai             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Leme                |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-LencoisPaulista     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Limeira             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Lins                |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Lorena              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-LuizAntonio         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Macatuba            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-MarabaPaulista      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Marilia             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Matao               |    0
 .../br-sp-MiranteDoParanapanema                    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Mirassol            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Mococa              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-MogiDasCruzes       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Mogiguacu           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Mongagua            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-MonteAzulPaulista   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-NevesPaulista       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-NovoHorizonte       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Nuporanga           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Orlandia            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ourinhos            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Paraibuna           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PariqueraAcu        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Paulinia            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pederneiras         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pedregulho          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Penapolis           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Peruibe             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Piedade             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pindamonhangaba     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Piquete             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Piracicaba          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pirangi             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pirassununga        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pitangueiras        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Poa                 |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Pontal              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PortoFeliz          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PortoFerreira       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PraiaGrande         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PresidenteBernardes |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PresidentePrudente  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-PresidenteVenceslau |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-RedencaoDaSerra     |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Reginopolis         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Registro            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Restinga            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-RibeiraoCorrente    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-RibeiraoPreto       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-RioClaro            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Roseira             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SalesOliveira       |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Salto               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantaBarbaraDOeste  |    0
 .../br-sp-SantaCruzDaConceicao                     |    0
 .../br-sp-SantaCruzDaEsperanca                     |    0
 .../br-sp-SantaCruzDasPalmeiras                    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantaGertrudes      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantaLucia          |    0
 .../br-sp-SantaRitaDoPassaQuatro                   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantaRosaDeViterbo  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantoAnastacio      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SantoAndre          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Santos              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoCarlos           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoaoDaBoaVista   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDaBelaVista  |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDoRioPardo   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDoRioPreto   |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDosCampos    |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoPaulo            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoPedro            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoRoque            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoSebastiao        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoSimao            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SaoVicente          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SerraAzul           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Serrana             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Sertaozinho         |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-SeteBarras          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Sorocaba            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Sumare              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Suzano              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Taiacu              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Taiuva              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Tambau              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Tanabi              |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Taquaritinga        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Tatui               |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Taubate             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-TerraRoxa           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Tupa                |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-TupiPaulista        |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Ubatuba             |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Valinhos            |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-VarzeaPaulista      |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Viradouro           |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Votorantim          |    0
 {dvbv5_isdb-t => isdb-t}/br-sp-Votuporanga         |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Aragominas          |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Araguaina           |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Babaculandia        |    0
 {dvbv5_isdb-t => isdb-t}/br-to-BrejinhoDeNazare    |    0
 {dvbv5_isdb-t => isdb-t}/br-to-ChapadaDeAreia      |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Darcinopolis        |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Fatima              |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Filadelfia          |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Gurupi              |    0
 {dvbv5_isdb-t => isdb-t}/br-to-MiracemaDoTocantins |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Miranorte           |    0
 .../br-to-MonteSantoDoTocantins                    |    0
 {dvbv5_isdb-t => isdb-t}/br-to-OliveiraDeFatima    |    0
 {dvbv5_isdb-t => isdb-t}/br-to-Palmas              |    0
 {dvbv5_isdb-t => isdb-t}/br-to-ParaisoDoTocantins  |    0
 {dvbv5_isdb-t => isdb-t}/br-to-PortoNacional       |    0
 1874 files changed, 68175 insertions(+), 11131 deletions(-)
 create mode 100644 Makefile
 create mode 100644 README
 delete mode 100644 dvb-t/ar-Argentina
 delete mode 100644 dvb-t/br-Brazil
 delete mode 100644 dvb-t/es-Rocacorba
 delete mode 100644 dvb-t/pl-Warszawa
 delete mode 100644 dvb-t/se-Pajala
 delete mode 100644 dvbv5_dvb-t/fi-Aanekoski
 delete mode 100644 dvbv5_dvb-t/fi-Aanekoski_Konginkangas
 delete mode 100644 dvbv5_dvb-t/fi-Ahtari
 delete mode 100644 dvbv5_dvb-t/fi-Alajarvi
 delete mode 100644 dvbv5_dvb-t/fi-Anjalankoski_Ruotila
 delete mode 100644 dvbv5_dvb-t/fi-Enontekio_Ahovaara
 delete mode 100644 dvbv5_dvb-t/fi-Enontekio_Hetta
 delete mode 100644 dvbv5_dvb-t/fi-Enontekio_Kuttanen
 delete mode 100644 dvbv5_dvb-t/fi-Espoo
 delete mode 100644 dvbv5_dvb-t/fi-Eurajoki
 delete mode 100644 dvbv5_dvb-t/fi-Fiskars
 delete mode 100644 dvbv5_dvb-t/fi-Haapavesi
 delete mode 100644 dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski
 delete mode 100644 dvbv5_dvb-t/fi-Hameenlinna_Painokangas
 delete mode 100644 dvbv5_dvb-t/fi-Hanko
 delete mode 100644 dvbv5_dvb-t/fi-Hartola
 delete mode 100644 dvbv5_dvb-t/fi-Heinavesi
 delete mode 100644 dvbv5_dvb-t/fi-Heinola
 delete mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi
 delete mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara
 delete mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka
 delete mode 100644 dvbv5_dvb-t/fi-Hyvinkaa
 delete mode 100644 dvbv5_dvb-t/fi-Ii_Raiskio
 delete mode 100644 dvbv5_dvb-t/fi-Iisalmi
 delete mode 100644 dvbv5_dvb-t/fi-Ikaalinen
 delete mode 100644 dvbv5_dvb-t/fi-Ikaalinen_Riitiala
 delete mode 100644 dvbv5_dvb-t/fi-Inari
 delete mode 100644 dvbv5_dvb-t/fi-Inari_Janispaa
 delete mode 100644 dvbv5_dvb-t/fi-Inari_Naatamo
 delete mode 100644 dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara
 delete mode 100644 dvbv5_dvb-t/fi-Jalasjarvi
 delete mode 100644 dvbv5_dvb-t/fi-Jamsa_Halli
 delete mode 100644 dvbv5_dvb-t/fi-Jamsa_Kaipola
 delete mode 100644 dvbv5_dvb-t/fi-Jamsa_Matkosvuori
 delete mode 100644 dvbv5_dvb-t/fi-Jamsa_Ouninpohja
 delete mode 100644 dvbv5_dvb-t/fi-Jamsankoski
 delete mode 100644 dvbv5_dvb-t/fi-Joensuu_Vestinkallio
 delete mode 100644 dvbv5_dvb-t/fi-Joroinen_Puukkola
 delete mode 100644 dvbv5_dvb-t/fi-Joutsa_Lankia
 delete mode 100644 dvbv5_dvb-t/fi-Joutseno
 delete mode 100644 dvbv5_dvb-t/fi-Juupajoki_Kopsamo
 delete mode 100644 dvbv5_dvb-t/fi-Juva
 delete mode 100644 dvbv5_dvb-t/fi-Jyvaskyla
 delete mode 100644 dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski
 delete mode 100644 dvbv5_dvb-t/fi-Kaavi_Sivakkavaara
 delete mode 100644 dvbv5_dvb-t/fi-Kajaani_Pollyvaara
 delete mode 100644 dvbv5_dvb-t/fi-Kalajoki
 delete mode 100644 dvbv5_dvb-t/fi-Kangaslampi
 delete mode 100644 dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki
 delete mode 100644 dvbv5_dvb-t/fi-Kankaanpaa
 delete mode 100644 dvbv5_dvb-t/fi-Karigasniemi
 delete mode 100644 dvbv5_dvb-t/fi-Karkkila
 delete mode 100644 dvbv5_dvb-t/fi-Karstula
 delete mode 100644 dvbv5_dvb-t/fi-Karvia
 delete mode 100644 dvbv5_dvb-t/fi-Kaunispaa
 delete mode 100644 dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi
 delete mode 100644 dvbv5_dvb-t/fi-Kerimaki
 delete mode 100644 dvbv5_dvb-t/fi-Keuruu
 delete mode 100644 dvbv5_dvb-t/fi-Keuruu_Haapamaki
 delete mode 100644 dvbv5_dvb-t/fi-Kihnio
 delete mode 100644 dvbv5_dvb-t/fi-Kiihtelysvaara
 delete mode 100644 dvbv5_dvb-t/fi-Kilpisjarvi
 delete mode 100644 dvbv5_dvb-t/fi-Kittila_Levitunturi
 delete mode 100644 dvbv5_dvb-t/fi-Kolari_Vuolittaja
 delete mode 100644 dvbv5_dvb-t/fi-Koli
 delete mode 100644 dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori
 delete mode 100644 dvbv5_dvb-t/fi-Korppoo
 delete mode 100644 dvbv5_dvb-t/fi-Kruunupyy
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmo_Haukela
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmo_Lentiira
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmo_Niva
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmoinen
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi
 delete mode 100644 dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen
 delete mode 100644 dvbv5_dvb-t/fi-Kuopio
 delete mode 100644 dvbv5_dvb-t/fi-Kurikka_Kesti
 delete mode 100644 dvbv5_dvb-t/fi-Kustavi_Viherlahti
 delete mode 100644 dvbv5_dvb-t/fi-Kuusamo_Hamppulampi
 delete mode 100644 dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho
 delete mode 100644 dvbv5_dvb-t/fi-Lahti
 delete mode 100644 dvbv5_dvb-t/fi-Lapua
 delete mode 100644 dvbv5_dvb-t/fi-Laukaa
 delete mode 100644 dvbv5_dvb-t/fi-Laukaa_Vihtavuori
 delete mode 100644 dvbv5_dvb-t/fi-Lavia
 delete mode 100644 dvbv5_dvb-t/fi-Lohja
 delete mode 100644 dvbv5_dvb-t/fi-Loimaa
 delete mode 100644 dvbv5_dvb-t/fi-Luhanka
 delete mode 100644 dvbv5_dvb-t/fi-Luopioinen
 delete mode 100644 dvbv5_dvb-t/fi-Mantta
 delete mode 100644 dvbv5_dvb-t/fi-Mantyharju
 delete mode 100644 dvbv5_dvb-t/fi-Mikkeli
 delete mode 100644 dvbv5_dvb-t/fi-Muonio_Olostunturi
 delete mode 100644 dvbv5_dvb-t/fi-Nilsia
 delete mode 100644 dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi
 delete mode 100644 dvbv5_dvb-t/fi-Nilsia_Pisa
 delete mode 100644 dvbv5_dvb-t/fi-Nokia
 delete mode 100644 dvbv5_dvb-t/fi-Nokia_Siuro
 delete mode 100644 dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola
 delete mode 100644 dvbv5_dvb-t/fi-Nuorgam_Njallavaara
 delete mode 100644 dvbv5_dvb-t/fi-Nuorgam_raja
 delete mode 100644 dvbv5_dvb-t/fi-Nurmes_Konnanvaara
 delete mode 100644 dvbv5_dvb-t/fi-Nurmes_Kortevaara
 delete mode 100644 dvbv5_dvb-t/fi-Orivesi_Talviainen
 delete mode 100644 dvbv5_dvb-t/fi-Oulu
 delete mode 100644 dvbv5_dvb-t/fi-Padasjoki
 delete mode 100644 dvbv5_dvb-t/fi-Padasjoki_Arrakoski
 delete mode 100644 dvbv5_dvb-t/fi-Paltamo_Kivesvaara
 delete mode 100644 dvbv5_dvb-t/fi-Parainen_Houtskari
 delete mode 100644 dvbv5_dvb-t/fi-Parikkala
 delete mode 100644 dvbv5_dvb-t/fi-Parkano_Sopukallio
 delete mode 100644 dvbv5_dvb-t/fi-Pello
 delete mode 100644 dvbv5_dvb-t/fi-Pello_Ratasvaara
 delete mode 100644 dvbv5_dvb-t/fi-Perho
 delete mode 100644 dvbv5_dvb-t/fi-Pernaja
 delete mode 100644 dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu
 delete mode 100644 dvbv5_dvb-t/fi-Pihtipudas
 delete mode 100644 dvbv5_dvb-t/fi-Porvoo_Suomenkyla
 delete mode 100644 dvbv5_dvb-t/fi-Posio
 delete mode 100644 dvbv5_dvb-t/fi-Pudasjarvi
 delete mode 100644 dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote
 delete mode 100644 dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara
 delete mode 100644 dvbv5_dvb-t/fi-Puolanka
 delete mode 100644 dvbv5_dvb-t/fi-Pyhatunturi
 delete mode 100644 dvbv5_dvb-t/fi-Pyhavuori
 delete mode 100644 dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi
 delete mode 100644 dvbv5_dvb-t/fi-Raahe_Mestauskallio
 delete mode 100644 dvbv5_dvb-t/fi-Raahe_Piehinki
 delete mode 100644 dvbv5_dvb-t/fi-Ranua_Haasionmaa
 delete mode 100644 dvbv5_dvb-t/fi-Ranua_Leppiaho
 delete mode 100644 dvbv5_dvb-t/fi-Rautavaara_Angervikko
 delete mode 100644 dvbv5_dvb-t/fi-Rautjarvi_Simpele
 delete mode 100644 dvbv5_dvb-t/fi-Ristijarvi
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Rantalaki
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Sonka
 delete mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Sorviselka
 delete mode 100644 dvbv5_dvb-t/fi-Ruka
 delete mode 100644 dvbv5_dvb-t/fi-Ruovesi_Storminiemi
 delete mode 100644 dvbv5_dvb-t/fi-Saarijarvi
 delete mode 100644 dvbv5_dvb-t/fi-Saarijarvi_Kalmari
 delete mode 100644 dvbv5_dvb-t/fi-Saarijarvi_Mahlu
 delete mode 100644 dvbv5_dvb-t/fi-Salla_Hirvasvaara
 delete mode 100644 dvbv5_dvb-t/fi-Salla_Ihistysjanka
 delete mode 100644 dvbv5_dvb-t/fi-Salla_Naruska
 delete mode 100644 dvbv5_dvb-t/fi-Salla_Sallatunturi
 delete mode 100644 dvbv5_dvb-t/fi-Salla_Sarivaara
 delete mode 100644 dvbv5_dvb-t/fi-Salo_Isokyla
 delete mode 100644 dvbv5_dvb-t/fi-Savukoski_Martti
 delete mode 100644 dvbv5_dvb-t/fi-Savukoski_Tanhua
 delete mode 100644 dvbv5_dvb-t/fi-Siilinjarvi
 delete mode 100644 dvbv5_dvb-t/fi-Simo_Viantie
 delete mode 100644 dvbv5_dvb-t/fi-Sipoo_Norrkulla
 delete mode 100644 dvbv5_dvb-t/fi-Sodankyla_Pittiovaara
 delete mode 100644 dvbv5_dvb-t/fi-Sodankyla_Vuotso
 delete mode 100644 dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki
 delete mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki
 delete mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Ammansaari
 delete mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Juntusranta
 delete mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Myllylahti
 delete mode 100644 dvbv5_dvb-t/fi-Sysma_Liikola
 delete mode 100644 dvbv5_dvb-t/fi-Taivalkoski
 delete mode 100644 dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara
 delete mode 100644 dvbv5_dvb-t/fi-Tammela
 delete mode 100644 dvbv5_dvb-t/fi-Tammisaari
 delete mode 100644 dvbv5_dvb-t/fi-Tampere
 delete mode 100644 dvbv5_dvb-t/fi-Tampere_Pyynikki
 delete mode 100644 dvbv5_dvb-t/fi-Tervola
 delete mode 100644 dvbv5_dvb-t/fi-Turku
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki_Nuvvus
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki_Outakoski
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki_Polvarniemi
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto
 delete mode 100644 dvbv5_dvb-t/fi-Utsjoki_Tenola
 delete mode 100644 dvbv5_dvb-t/fi-Uusikaupunki_Orivo
 delete mode 100644 dvbv5_dvb-t/fi-Vaala
 delete mode 100644 dvbv5_dvb-t/fi-Vaasa
 delete mode 100644 dvbv5_dvb-t/fi-Valtimo
 delete mode 100644 dvbv5_dvb-t/fi-Vammala_Jyranvuori
 delete mode 100644 dvbv5_dvb-t/fi-Vammala_Roismala
 delete mode 100644 dvbv5_dvb-t/fi-Vammala_Savi
 delete mode 100644 dvbv5_dvb-t/fi-Vantaa_Hakunila
 delete mode 100644 dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki
 delete mode 100644 dvbv5_dvb-t/fi-Virrat_Lappavuori
 delete mode 100644 dvbv5_dvb-t/fi-Vuokatti
 delete mode 100644 dvbv5_dvb-t/fi-Ylitornio_Ainiovaara
 delete mode 100644 dvbv5_dvb-t/fi-Ylitornio_Raanujarvi
 delete mode 100644 dvbv5_dvb-t/fi-Yllas
 delete mode 100644 dvbv5_dvb-t/fi-Yllasjarvi
 create mode 100644 isdb-t/ar-Argentina
 rename {dvbv5_isdb-t => isdb-t}/br-Brazil (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ac-Bujari (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ac-PortoAcre (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ac-RioBranco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ac-SenadorGuiomard (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-Arapiraca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-Craibas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-Maceio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-Piranhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-RioLargo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-al-SaoMiguelDosCampos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-am-CareiroDaVarzea (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-am-Iranduba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-am-Manaquiri (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-am-Manaus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-am-Parintins (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ap-Macapa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ap-Santana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Alagoinhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Alcobaca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Amargosa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-AmeliaRodrigues (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Anguera (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-AntonioCardoso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Aracatu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Barra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-BarraDoChoca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Barreiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-BeloCampo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Biritinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-BomJesusDaLapa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Brumado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Caetite (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Camacari (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-CampoFormoso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Candeal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Candeias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-CandidoSales (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Caraibas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-ConceicaoDaFeira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-ConceicaoDoJacuipe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-CoracaoDeMaria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-CruzDasAlmas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-DiasDAvila (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-EntreRios (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Eunapolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-FeiraDeSantana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Guanambi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Ichu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Ilheus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Inhambupe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Ipecaeta (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Irara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Irece (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Itabuna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Itamaraju (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Itambe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Itaparica (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Itapetinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Jacobina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Jaguaquara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Jaguaripe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Jequie (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Juazeiro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-LauroDeFreitas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-LuisEduardoMagalhaes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-MadreDeDeus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Maragogipe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-MataDeSaoJoao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Nazare (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-PauloAfonso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Piripa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Planalto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Pocoes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Pojuca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-PortoSeguro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-PresidenteJanioQuadros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-RafaelJambeiro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SalinasDaMargarida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Salvador (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantaBarbara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantaCruzCabralia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantaMariaDaVitoria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Santanopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantoAmaro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantoAntonioDeJesus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SantoEstevao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SaoFranciscoDoConde (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SaoGoncaloDosCampos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SaoSebastiaoDoPasse (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SenhorDoBonfim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SerraPreta (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Serrinha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-SimoesFilho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Tanquinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-TeixeiraDeFreitas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Teofilandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Tremedal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-VeraCruz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-VitoriaDaConquista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ba-Xiquexique (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Acarape (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Aquiraz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Aurora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Caninde (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Fortaleza (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Horizonte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Maracanau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-MaranguapeItapebussu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ce-Pacajus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-df-Brasilia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-df-BrasiliaGama (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-CachoeiroDoItapemirim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-Colatina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-Guarapari (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-Linhares (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-SaoMateus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-es-Vitoria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-AguasLindasDeGoias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Alexania (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Anapolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-AparecidaDeGoiania (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-CaldasNovas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Catalao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Cristalina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Formosa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Goianesia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Goiania (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Guapo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Inhumas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Itumbiara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Jatai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-Luziania (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-PlanaltinaDeGoias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-RioVerde (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-SantaHelenaDeGoias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-SantoAntonioDoDescoberto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-SaoLuisDeMontesBelos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-SenadorCanedo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-go-ValparaisoDeGoias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Alcantara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Axixa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-CachoeiraGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Caxias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-HumbertoDeCampos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Imperatriz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Morros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-PacoDoLumiar (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-PresidenteJuscelino (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-PrimeiraCruz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Raposa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Rosario (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-SaoJoseDeRibamar (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-SaoLuis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ma-Timon (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-AguaComprida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Alfenas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Almenara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Andradas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Araguari (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Arapora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Araxa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Arinos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Barbacena (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Barroso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-BeloHorizonte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Betim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-BordaDaMata (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Campanha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Caratinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Cataguases (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Claraval (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-CoronelFabriciano (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Curvelo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Diamantina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Divinopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Fronteira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Frutal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-GovernadorValadares (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Guanhaes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Guaxupe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Ibirite (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Ipatinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Itabira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Itajuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Itapagipe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Ituiutaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Janauba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Januaria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-JuizDeFora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Manhuacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Mariana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-MonteSiao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-MontesClaros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Muriae (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Oliveira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-OuroFino (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Paracatu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Passos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-PatosDeMinas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Periquito (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Pirapora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Planura (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-PocosDeCaldas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-PousoAlegre (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-SantaRitaDoSapucai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-SaoJoaoDelRei (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-SaoLourenco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-SaoSebastiaoDoParaiso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-SeteLagoas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-TeofiloOtoni (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Timoteo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-TresCoracoes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-TresPontas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Uberaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Uberlandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mg-Varginha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Anastacio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Aquidauana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-CampoGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Corumba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Dourados (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Ladario (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-NovaAndradina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Paranaiba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-PontaPora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Rochedo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-Sidrolandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ms-TresLagoas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-AltaFloresta (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-Cuiaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-Rondonopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-Sinop (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-Sorriso (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-mt-TangaraDaSerra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Abaetetuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Afua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Barcarena (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Belem (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Belterra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Castanhal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Maraba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Moju (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-PontaDePedras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pa-Santarem (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-AlagoaGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Alagoinha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Aparecida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Bayeux (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-BomJesus (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Cabedelo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-CachoeiraDosIndios (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-CacimbaDeDentro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Cajazeiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-CaldasBrandao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-CampinaGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Catingueira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Condado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Cuitegi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Desterro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Guarabira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Gurinhem (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Imaculada (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Itabaiana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Jacarau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-JoaoPessoa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Juripiranga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-LagoaSeca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Lucena (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-MaeDAgua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Mamanguape (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Marizopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Massaranduba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Matinhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Matureia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Mulungu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-OlhoDAgua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Patos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Pilar (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Piloezinhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Puxinana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-RioTinto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-SantaRita (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-SantaTeresinha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-SaoFrancisco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-SaoJoseDePiranhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-SaoMamede (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Sape (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Sousa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pb-Teixeira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Agrestina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Altinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Bezerros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Camaragibe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Caruaru (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Garanhuns (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Jupi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Limoeiro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Petrolina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-Recife (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pe-SaoLourencoDaMata (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pi-Teresina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-AltoParana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-AltoPiquiri (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Antonina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Apucarana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Arapongas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-AssisChateaubriand (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-BoaVistaDaAparecida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Cafelandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Cambe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-CampoLargo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-CampoMourao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Carambei (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Cascavel (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-CeuAzul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Cianorte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Colombo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Corbelia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-CornelioProcopio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Curitiba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Florestopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-FozDoIguacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-FranciscoBeltrao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Guaraniacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Guarapuava (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Guaratuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-HonorioSerpa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Ibema (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Ibipora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Imbituva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Irati (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Ivaipora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Jacarezinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Japira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Jataizinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Lapa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Londrina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Maringa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Matinhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-MoreiraSales (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-NovaAurora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Paranagua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Paranavai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-PatoBranco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Perola (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-PontaGrossa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-PontalDoParana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Porecatu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-PrimeiroDeMaio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-RioNegro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Rolandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Sarandi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Sertanopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-TeixeiraSoares (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-TelemacoBorba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Toledo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-TresBarrasDoParana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Tupassi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Ubirata (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Umuarama (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-pr-Vere (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-AngraDosReis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Araruama (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-ArraialDoCabo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-BarraMansa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-CaboFrio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-CamposDosGoytacazes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-DuqueDeCaxias (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Itaguai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Itaperuna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Itatiaia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Macae (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Marica (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-NovaFriburgo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-NovaIguacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Queimados (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Quissama (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Resende (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-RioBonito (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-RioDasOstras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-RioDeJaneiro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-SaoGoncalo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-SaoJoaoDaBarra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-SaoJoaoDeMeriti (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-SaoPedroDaAldeia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-Saquarema (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-SilvaJardim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-TrajanoDeMorais (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-TresRios (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rj-VoltaRedonda (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-Extremoz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-Macaiba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-Mossoro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-Natal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-SaoJoseDeMipibu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rn-SenadorEloiDeSousa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ro-Ariquemes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ro-Cacoal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ro-Jiparana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ro-PimentaBueno (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-ro-PortoVelho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rr-BoaVista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Alegrete (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-ArroioDoSal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Bage (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-BentoGoncalves (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CachoeiraDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Camaqua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CampoBom (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Candelaria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Canela (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Cangucu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CapaoDaCanoa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CapaoDoLeao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Carazinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CarlosBarbosa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CaxiasDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Cidreira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-CruzAlta (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-DomPedroDeAlcantara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Erechim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Estrela (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Farroupilha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Feliz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-FloresDaCunha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Gramado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Ijui (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Lajeado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-MonteAlegreDosCampos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Montenegro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-MorroRedondo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-NovaPetropolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-NovaSantaRita (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-NovoHamburgo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Osorio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-PalmaresDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-ParaisoDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-PassoFundo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Pelotas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-PicadaCafe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-PortoAlegre (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-RioGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-RioGrandeCassino (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SalvadorDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Sananduva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantaCruzDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantaMaria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantaRosa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantanaDoLivramento (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantoAngelo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SantoAntonioDaPatrulha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SaoBorja (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SaoGabriel (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SaoJoseDoNorte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-SaoSepe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Sapiranga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Sertao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Taquara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-TerraDeAreia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Torres (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Tramandai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-TresCachoeiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-TresCoroas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-TresDeMaio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Triunfo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Tucunduva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Uruguaiana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Vacaria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-VenancioAires (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-VilaNovaDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-rs-Xangrila (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Agronomica (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-AguasMornas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-AntonioCarlos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Ararangua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Aurora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-BalnearioCamboriu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-BarraVelha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Blumenau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Brusque (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Cacador (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Canoinhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-CapaoAlto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-CapivariDeBaixo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Chapeco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Concordia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-CorreiaPinto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Corupa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Criciuma (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Florianopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-FlorianopolisCanasvieiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-FlorianopolisIngleses (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Garopaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Garuva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Gaspar (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-GovernadorCelsoRamos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Guabiruba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Guaramirim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-HervalDOeste (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Icara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Itajai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Itapema (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Itapoa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-JaraguaDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Joacaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Joinville (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Lages (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Laguna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Laurentino (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Lontras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Mafra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Massaranduba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Navegantes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-NovaVeneza (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Painel (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-PassoDeTorres (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Penha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Picarras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-RioDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-RioNegrinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-SantaRosaDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-SantoAmaroDaImperatriz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-SaoBentoDoSul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Schroeder (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Sombrio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Tijucas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sc-Tubarao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Aquidaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Aracaju (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Araua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-AreiaBranca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-BarraDosCoqueiros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Boquim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-CampoDoBrito (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-CanindeDeSaoFrancisco (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Capela (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Carira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Carmopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Cristinapolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-DivinaPastora (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Estancia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-FeiraNova (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-FreiPaulo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Gararu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-GeneralMaynard (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Itabaiana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Itabaianinha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Itabi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-ItaporangaDAjuda (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Japaratuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Lagarto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Laranjeiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Macambira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Malhador (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Maruim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-MoitaBonita (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-MonteAlegreDeSergipe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-NossaSenhoraAparecida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-NossaSenhoraDaGloria (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-NossaSenhoraDoSocorro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Pedrinhas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-PocoRedondo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-RiachaoDoDantas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Riachuelo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Ribeiropolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-RosarioDoCatete (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Salgado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-SantaLuziaDoIntanhy (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-SantoAmaroDasBrotas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-SaoCristovao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-SaoDomingos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-SaoMiguelDoAleixo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-TomarDoGeru (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-se-Umbauba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Aguai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-AguasDeLindoia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-AguasDeSaoPedro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Agudos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Americana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-AmericoBrasiliense (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Amparo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Andradina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Aparecida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-AparecidaDOeste (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Apiai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Aracatuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Araraquara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Araras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Arealva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Assis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Atibaia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Auriflama (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-BarraBonita (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Barretos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Batatais (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Bauru (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Bebedouro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Bertioga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Birigui (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Boituva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Botucatu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-BragancaPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Brodowski (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-CachoeiraPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cajamar (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cajati (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cajobi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Campinas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-CampoLimpoPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-CamposDoJordao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Capivari (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Caraguatatuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Carapicuiba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-CassiaDosCoqueiros (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Catanduva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Colina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Colombia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cravinhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-CristaisPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cruzeiro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Cubatao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Diadema (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Dracena (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Dumont (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Eldorado (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-EmbuDasArtes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-EstivaGerbi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-EstrelaDOeste (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Fernandopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-FerrazDeVasconcelos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Franca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-FrancoDaRocha (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Garca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Guapiacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-GuaraniDOeste (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Guaratingueta (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Guaruja (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Guarulhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Guzolandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Hortolandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Iacanga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ibate (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ibitinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ibiuna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-IgaracuDoTiete (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Iguape (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-IlhaComprida (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-IlhaSolteira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ilhabela (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Indaiatuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ipero (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itanhaem (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itapetininga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itapeva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itapevi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itapolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itaquaquecetuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Itu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jaborandi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jaboticabal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jacarei (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jaci (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jacupiranga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jaguariuna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jales (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jandira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jardinopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jeriquara (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-JoseBonifacio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Jundiai (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Leme (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-LencoisPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Limeira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Lins (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Lorena (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-LuizAntonio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Macatuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-MarabaPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Marilia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Matao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-MiranteDoParanapanema (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Mirassol (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Mococa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-MogiDasCruzes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Mogiguacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Mongagua (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-MonteAzulPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-NevesPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-NovoHorizonte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Nuporanga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Orlandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ourinhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Paraibuna (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PariqueraAcu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Paulinia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pederneiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pedregulho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Penapolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Peruibe (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Piedade (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pindamonhangaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Piquete (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Piracicaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pirangi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pirassununga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pitangueiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Poa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Pontal (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PortoFeliz (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PortoFerreira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PraiaGrande (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PresidenteBernardes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PresidentePrudente (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-PresidenteVenceslau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-RedencaoDaSerra (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Reginopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Registro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Restinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-RibeiraoCorrente (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-RibeiraoPreto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-RioClaro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Roseira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SalesOliveira (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Salto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaBarbaraDOeste (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaCruzDaConceicao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaCruzDaEsperanca (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaCruzDasPalmeiras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaGertrudes (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaLucia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaRitaDoPassaQuatro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantaRosaDeViterbo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantoAnastacio (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SantoAndre (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Santos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoCarlos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoaoDaBoaVista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDaBelaVista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDoRioPardo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDoRioPreto (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoJoseDosCampos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoPaulo (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoPedro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoRoque (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoSebastiao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoSimao (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SaoVicente (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SerraAzul (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Serrana (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Sertaozinho (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-SeteBarras (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Sorocaba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Sumare (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Suzano (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Taiacu (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Taiuva (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Tambau (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Tanabi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Taquaritinga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Tatui (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Taubate (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-TerraRoxa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Tupa (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-TupiPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Ubatuba (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Valinhos (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-VarzeaPaulista (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Viradouro (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Votorantim (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-sp-Votuporanga (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Aragominas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Araguaina (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Babaculandia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-BrejinhoDeNazare (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-ChapadaDeAreia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Darcinopolis (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Fatima (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Filadelfia (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Gurupi (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-MiracemaDoTocantins (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Miranorte (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-MonteSantoDoTocantins (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-OliveiraDeFatima (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-Palmas (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-ParaisoDoTocantins (100%)
 rename {dvbv5_isdb-t => isdb-t}/br-to-PortoNacional (100%)


