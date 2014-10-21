Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep27.mx.upcmail.net ([62.179.121.47]:41869 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaJUJN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 05:13:58 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH dtv-scan-tables] Delete DVBv3 comments from DVBv5 scan files
Date: Tue, 21 Oct 2014 09:53:34 +0100
Message-Id: <1413881614-10015-1-git-send-email-jmccrohan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Probably should have happened as part of 06e54ff.

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 dvb-t/ad-Andorra                                                       | 1 -
 dvb-t/at-All                                                           | 1 -
 dvb-t/au-Adelaide                                                      | 1 -
 dvb-t/au-AdelaideFoothills                                             | 1 -
 dvb-t/au-Ballarat                                                      | 1 -
 dvb-t/au-Bendigo                                                       | 1 -
 dvb-t/au-Brisbane                                                      | 1 -
 dvb-t/au-Cairns                                                        | 1 -
 dvb-t/au-Canberra-Black-Mt                                             | 1 -
 dvb-t/au-Coonabarabran                                                 | 1 -
 dvb-t/au-Darwin                                                        | 1 -
 dvb-t/au-Devonport                                                     | 1 -
 dvb-t/au-FraserCoast-Bundaberg                                         | 1 -
 dvb-t/au-GoldCoast                                                     | 1 -
 dvb-t/au-Goulburn-Rocky_Hill                                           | 1 -
 dvb-t/au-Hervey_Bay-Ghost_Hill                                         | 1 -
 dvb-t/au-Hobart                                                        | 1 -
 dvb-t/au-Mackay                                                        | 1 -
 dvb-t/au-Melbourne                                                     | 1 -
 dvb-t/au-Melbourne-Selby                                               | 1 -
 dvb-t/au-Melbourne-Upwey                                               | 1 -
 dvb-t/au-MidNorthCoast                                                 | 1 -
 dvb-t/au-Newcastle                                                     | 1 -
 dvb-t/au-Perth                                                         | 1 -
 dvb-t/au-Perth_Roleystone                                              | 1 -
 dvb-t/au-SpencerGulf                                                   | 1 -
 dvb-t/au-SunshineCoast                                                 | 1 -
 dvb-t/au-Sutherland                                                    | 1 -
 dvb-t/au-Sydney                                                        | 1 -
 dvb-t/au-Sydney_Kings_Cross                                            | 1 -
 dvb-t/au-Tamworth                                                      | 3 ---
 dvb-t/au-Townsville                                                    | 1 -
 dvb-t/au-WaggaWagga                                                    | 1 -
 dvb-t/au-Wollongong                                                    | 1 -
 dvb-t/au-canberra                                                      | 1 -
 dvb-t/au-unknown                                                       | 1 -
 dvb-t/auto-Australia                                                   | 1 -
 dvb-t/auto-Default                                                     | 1 -
 dvb-t/auto-Taiwan                                                      | 1 -
 dvb-t/auto-With167kHzOffsets                                           | 1 -
 dvb-t/ax-Smedsbole                                                     | 1 -
 dvb-t/be-All                                                           | 1 -
 dvb-t/bg-Sofia                                                         | 1 -
 dvb-t/ch-All                                                           | 1 -
 dvb-t/ch-Citycable                                                     | 1 -
 dvb-t/ch-Geneva                                                        | 1 -
 dvb-t/cz-All                                                           | 1 -
 dvb-t/de-Baden-Wuerttemberg                                            | 1 -
 dvb-t/de-Bayern                                                        | 1 -
 dvb-t/de-Berlin                                                        | 1 -
 dvb-t/de-Brandenburg                                                   | 1 -
 dvb-t/de-Bremen                                                        | 1 -
 dvb-t/de-Hamburg                                                       | 1 -
 dvb-t/de-Hessen                                                        | 1 -
 dvb-t/de-Mecklenburg-Vorpommern                                        | 1 -
 dvb-t/de-Niedersachsen                                                 | 1 -
 dvb-t/de-Nordrhein-Westfalen                                           | 1 -
 dvb-t/de-Rheinland-Pfalz                                               | 1 -
 dvb-t/de-Saarland                                                      | 1 -
 dvb-t/de-Sachsen                                                       | 1 -
 dvb-t/de-Sachsen-Anhalt                                                | 1 -
 dvb-t/de-Schleswig-Holstein                                            | 1 -
 dvb-t/de-Thueringen                                                    | 1 -
 dvb-t/dk-All                                                           | 1 -
 dvb-t/ee-All                                                           | 1 -
 dvb-t/es-Albacete                                                      | 1 -
 dvb-t/es-Alfabia                                                       | 1 -
 dvb-t/es-Alicante                                                      | 1 -
 dvb-t/es-Alpicat                                                       | 1 -
 dvb-t/es-Asturias                                                      | 1 -
 dvb-t/es-BaixoMinho                                                    | 1 -
 dvb-t/es-Cadiz                                                         | 1 -
 dvb-t/es-Carceres                                                      | 1 -
 dvb-t/es-Collserola                                                    | 1 -
 dvb-t/es-Donostia                                                      | 1 -
 dvb-t/es-Granada                                                       | 1 -
 dvb-t/es-Huesca                                                        | 1 -
 dvb-t/es-Las_Palmas                                                    | 1 -
 dvb-t/es-Lugo                                                          | 1 -
 dvb-t/es-Madrid                                                        | 1 -
 dvb-t/es-Malaga                                                        | 1 -
 dvb-t/es-Muros-Noia                                                    | 1 -
 dvb-t/es-Mussara                                                       | 1 -
 dvb-t/es-Pamplona                                                      | 1 -
 dvb-t/es-SC_Tenerife                                                   | 1 -
 dvb-t/es-Santander                                                     | 1 -
 dvb-t/es-Santiago_de_Compostela                                        | 1 -
 dvb-t/es-Sevilla                                                       | 1 -
 dvb-t/es-Tenerife                                                      | 1 -
 dvb-t/es-Valladolid                                                    | 1 -
 dvb-t/es-Vilamarxant                                                   | 1 -
 dvb-t/fr-All                                                           | 1 -
 dvb-t/gr-Athens                                                        | 1 -
 dvb-t/hk-HongKong                                                      | 1 -
 dvb-t/hr-All                                                           | 1 -
 dvb-t/hu-Bekescsaba                                                    | 1 -
 dvb-t/hu-Budapest                                                      | 1 -
 dvb-t/hu-Csavoly-Kiskoros                                              | 1 -
 dvb-t/hu-Debrecen-Komadi                                               | 1 -
 dvb-t/hu-Fehergyarmat                                                  | 1 -
 dvb-t/hu-Gerecse-Dorog-Tatabanya                                       | 1 -
 dvb-t/hu-Gyor                                                          | 1 -
 dvb-t/hu-Kabhegy-Kaposvar-Tamasi                                       | 1 -
 .../hu-Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac  | 1 -
 dvb-t/hu-Karcag                                                        | 1 -
 dvb-t/hu-Kecskemet                                                     | 1 -
 dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd                          | 1 -
 dvb-t/hu-Miskolc-Aggtelek-Fony                                         | 1 -
 dvb-t/hu-Mor-Siofok-Veszprem-Zirc                                      | 1 -
 dvb-t/hu-Nagykanizsa-Barcs-Keszthely                                   | 1 -
 dvb-t/hu-Nyiregyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely          | 1 -
 dvb-t/hu-Pecs-Siklos                                                   | 1 -
 dvb-t/hu-Sopron-Koszeg                                                 | 1 -
 dvb-t/hu-Szeged                                                        | 1 -
 dvb-t/hu-Szekesfehervar                                                | 1 -
 dvb-t/hu-Szentes-Battonya                                              | 1 -
 dvb-t/hu-Szolnok                                                       | 1 -
 dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg                         | 1 -
 dvb-t/hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar                   | 1 -
 dvb-t/ie-CairnHill                                                     | 1 -
 dvb-t/ie-ClermontCarn                                                  | 1 -
 dvb-t/ie-Dungarvan                                                     | 1 -
 dvb-t/ie-HolywellHill                                                  | 1 -
 dvb-t/ie-Kippure                                                       | 1 -
 dvb-t/ie-Maghera                                                       | 1 -
 dvb-t/ie-MountLeinster                                                 | 1 -
 dvb-t/ie-Mullaghanish                                                  | 1 -
 dvb-t/ie-SpurHill                                                      | 1 -
 dvb-t/ie-ThreeRock                                                     | 1 -
 dvb-t/ie-Truskmore                                                     | 1 -
 dvb-t/ie-WoodcockHill                                                  | 1 -
 dvb-t/il-All                                                           | 1 -
 dvb-t/ir-Tehran                                                        | 1 -
 dvb-t/is-Reykjavik                                                     | 1 -
 dvb-t/it-All                                                           | 1 -
 dvb-t/lu-All                                                           | 1 -
 dvb-t/lv-Riga                                                          | 1 -
 dvb-t/nl-All                                                           | 1 -
 dvb-t/no-Trondelag_Stjordal                                            | 1 -
 dvb-t/nz-AucklandInfill                                                | 1 -
 dvb-t/nz-AucklandWaiatarua                                             | 1 -
 dvb-t/nz-Christchurch                                                  | 1 -
 dvb-t/nz-Dunedin                                                       | 1 -
 dvb-t/nz-Hamilton                                                      | 1 -
 dvb-t/nz-HawkesBayMtErin                                               | 1 -
 dvb-t/nz-HawkesBayNapier                                               | 1 -
 dvb-t/nz-Manawatu                                                      | 1 -
 dvb-t/nz-Tauranga                                                      | 1 -
 dvb-t/nz-Waikato                                                       | 1 -
 dvb-t/nz-WellingtonInfill                                              | 1 -
 dvb-t/nz-WellingtonKaukau                                              | 1 -
 dvb-t/nz-WellingtonNgarara                                             | 1 -
 dvb-t/pl-Czestochowa                                                   | 1 -
 dvb-t/pl-Gdansk                                                        | 1 -
 dvb-t/pl-Krakow                                                        | 1 -
 dvb-t/pl-Rzeszow                                                       | 1 -
 dvb-t/pl-Wroclaw                                                       | 1 -
 dvb-t/pt-All                                                           | 1 -
 dvb-t/ro-Bucharest                                                     | 1 -
 dvb-t/ru-Krasnodar                                                     | 1 -
 dvb-t/ru-Novosibirsk                                                   | 1 -
 dvb-t/ru-Volgodonsk                                                    | 1 -
 dvb-t/se-Alvdalen_Brunnsberg                                           | 1 -
 dvb-t/se-Alvdalsasen                                                   | 1 -
 dvb-t/se-Alvsbyn                                                       | 1 -
 dvb-t/se-Amot                                                          | 1 -
 dvb-t/se-Ange_Snoberg                                                  | 1 -
 dvb-t/se-Angebo                                                        | 1 -
 dvb-t/se-Angelholm_Vegeholm                                            | 1 -
 dvb-t/se-Arvidsjaur_Jultrask                                           | 1 -
 dvb-t/se-Aspeboda                                                      | 1 -
 dvb-t/se-Atvidaberg                                                    | 1 -
 dvb-t/se-Avesta_Krylbo                                                 | 1 -
 dvb-t/se-Backefors                                                     | 1 -
 dvb-t/se-Bankeryd                                                      | 1 -
 dvb-t/se-Bergsjo_Balleberget                                           | 1 -
 dvb-t/se-Bergvik                                                       | 1 -
 dvb-t/se-Bollebygd                                                     | 1 -
 dvb-t/se-Bollnas                                                       | 1 -
 dvb-t/se-Boras_Dalsjofors                                              | 1 -
 dvb-t/se-Boras_Sjobo                                                   | 1 -
 dvb-t/se-Borlange_Idkerberget                                          | 1 -
 dvb-t/se-Borlange_Nygardarna                                           | 1 -
 dvb-t/se-Bottnaryd_Ryd                                                 | 1 -
 dvb-t/se-Bromsebro                                                     | 1 -
 dvb-t/se-Bruzaholm                                                     | 1 -
 dvb-t/se-Byxelkrok                                                     | 1 -
 dvb-t/se-Dadran                                                        | 1 -
 dvb-t/se-Dalfors                                                       | 1 -
 dvb-t/se-Dalstuga                                                      | 1 -
 dvb-t/se-Degerfors                                                     | 1 -
 dvb-t/se-Delary                                                        | 1 -
 dvb-t/se-Djura                                                         | 1 -
 dvb-t/se-Drevdagen                                                     | 1 -
 dvb-t/se-Duvnas                                                        | 1 -
 dvb-t/se-Duvnas_Basna                                                  | 1 -
 dvb-t/se-Edsbyn                                                        | 1 -
 dvb-t/se-Emmaboda_Balshult                                             | 1 -
 dvb-t/se-Enviken                                                       | 1 -
 dvb-t/se-Fagersta                                                      | 1 -
 dvb-t/se-Falerum_Centrum                                               | 1 -
 dvb-t/se-Falun_Lovberget                                               | 1 -
 dvb-t/se-Farila                                                        | 1 -
 dvb-t/se-Faro_Ajkerstrask                                              | 1 -
 dvb-t/se-Farosund_Bunge                                                | 1 -
 dvb-t/se-Filipstad_Klockarhojden                                       | 1 -
 dvb-t/se-Finnveden                                                     | 1 -
 dvb-t/se-Fredriksberg                                                  | 1 -
 dvb-t/se-Fritsla                                                       | 1 -
 dvb-t/se-Furudal                                                       | 1 -
 dvb-t/se-Gallivare                                                     | 1 -
 dvb-t/se-Garpenberg_Kuppgarden                                         | 1 -
 dvb-t/se-Gavle_Skogmur                                                 | 1 -
 dvb-t/se-Gnarp                                                         | 1 -
 dvb-t/se-Gnesta                                                        | 1 -
 dvb-t/se-Gnosjo_Marieholm                                              | 1 -
 dvb-t/se-Goteborg_Brudaremossen                                        | 1 -
 dvb-t/se-Goteborg_Slattadamm                                           | 1 -
 dvb-t/se-Gullbrandstorp                                                | 1 -
 dvb-t/se-Gunnarsbo                                                     | 1 -
 dvb-t/se-Gusum                                                         | 1 -
 dvb-t/se-Hagfors_Varmullsasen                                          | 1 -
 dvb-t/se-Hallaryd                                                      | 1 -
 dvb-t/se-Hallbo                                                        | 1 -
 dvb-t/se-Halmstad_Hamnen                                               | 1 -
 dvb-t/se-Halmstad_Oskarstrom                                           | 1 -
 dvb-t/se-Harnosand_Harnon                                              | 1 -
 dvb-t/se-Hassela                                                       | 1 -
 dvb-t/se-Havdhem                                                       | 1 -
 dvb-t/se-Hedemora                                                      | 1 -
 dvb-t/se-Helsingborg_Olympia                                           | 1 -
 dvb-t/se-Hennan                                                        | 1 -
 dvb-t/se-Hestra_Aspas                                                  | 1 -
 dvb-t/se-Hjo_Grevback                                                  | 1 -
 dvb-t/se-Hofors                                                        | 1 -
 dvb-t/se-Hogfors                                                       | 1 -
 dvb-t/se-Hogsby_Virstad                                                | 1 -
 dvb-t/se-Holsbybrunn_Holsbyholm                                        | 1 -
 dvb-t/se-Horby_Sallerup                                                | 1 -
 dvb-t/se-Horken                                                        | 1 -
 dvb-t/se-Hudiksvall_Forsa                                              | 1 -
 dvb-t/se-Hudiksvall_Galgberget                                         | 1 -
 dvb-t/se-Huskvarna                                                     | 1 -
 dvb-t/se-Idre                                                          | 1 -
 dvb-t/se-Ingatorp                                                      | 1 -
 dvb-t/se-Ingvallsbenning                                               | 1 -
 dvb-t/se-Irevik                                                        | 1 -
 dvb-t/se-Jamjo                                                         | 1 -
 dvb-t/se-Jarnforsen                                                    | 1 -
 dvb-t/se-Jarvso                                                        | 1 -
 dvb-t/se-Jokkmokk_Tjalmejaure                                          | 1 -
 dvb-t/se-Jonkoping_Bondberget                                          | 1 -
 dvb-t/se-Kalix                                                         | 1 -
 dvb-t/se-Karbole                                                       | 1 -
 dvb-t/se-Karlsborg_Vaberget                                            | 1 -
 dvb-t/se-Karlshamn                                                     | 1 -
 dvb-t/se-Karlskrona_Vamo                                               | 1 -
 dvb-t/se-Karlstad_Sormon                                               | 1 -
 dvb-t/se-Kaxholmen_Vistakulle                                          | 1 -
 dvb-t/se-Kinnastrom                                                    | 1 -
 dvb-t/se-Kiruna_Kirunavaara                                            | 1 -
 dvb-t/se-Kisa                                                          | 1 -
 dvb-t/se-Knared                                                        | 1 -
 dvb-t/se-Kopmanholmen                                                  | 1 -
 dvb-t/se-Kopparberg                                                    | 1 -
 dvb-t/se-Kramfors_Lugnvik                                              | 1 -
 dvb-t/se-Kristinehamn_Utsiktsberget                                    | 1 -
 dvb-t/se-Kungsater                                                     | 1 -
 dvb-t/se-Kungsberget_GI                                                | 1 -
 dvb-t/se-Langshyttan                                                   | 1 -
 dvb-t/se-Langshyttan_Engelsfors                                        | 1 -
 dvb-t/se-Leksand_Karingberget                                          | 1 -
 dvb-t/se-Lerdala                                                       | 1 -
 dvb-t/se-Lilltjara_Digerberget                                         | 1 -
 dvb-t/se-Limedsforsen                                                  | 1 -
 dvb-t/se-Lindshammar_Ramkvilla                                         | 1 -
 dvb-t/se-Linkoping_Vattentornet                                        | 1 -
 dvb-t/se-Ljugarn                                                       | 1 -
 dvb-t/se-Loffstrand                                                    | 1 -
 dvb-t/se-Lonneberga                                                    | 1 -
 dvb-t/se-Lorstrand                                                     | 1 -
 dvb-t/se-Ludvika_Bjorkasen                                             | 1 -
 dvb-t/se-Lumsheden_Trekanten                                           | 1 -
 dvb-t/se-Lycksele_Knaften                                              | 1 -
 dvb-t/se-Mahult                                                        | 1 -
 dvb-t/se-Malmo_Jagersro                                                | 1 -
 dvb-t/se-Malung                                                        | 1 -
 dvb-t/se-Mariannelund                                                  | 1 -
 dvb-t/se-Markaryd_Hualtet                                              | 1 -
 dvb-t/se-Matfors                                                       | 1 -
 dvb-t/se-Molndal_Vasterberget                                          | 1 -
 dvb-t/se-Mora_Eldris                                                   | 1 -
 dvb-t/se-Motala_Ervasteby                                              | 1 -
 dvb-t/se-Mullsjo_Torestorp                                             | 1 -
 dvb-t/se-Nassjo                                                        | 1 -
 dvb-t/se-Navekvarn                                                     | 1 -
 dvb-t/se-Norrahammar                                                   | 1 -
 dvb-t/se-Norrkoping_Krokek                                             | 1 -
 dvb-t/se-Norrtalje_Sodra_Bergen                                        | 1 -
 dvb-t/se-Nykoping                                                      | 1 -
 dvb-t/se-Orebro_Lockhyttan                                             | 1 -
 dvb-t/se-Ornskoldsvik_As                                               | 1 -
 dvb-t/se-Oskarshamn                                                    | 1 -
 dvb-t/se-Ostersund_Brattasen                                           | 1 -
 dvb-t/se-Osthammar_Valo                                                | 1 -
 dvb-t/se-Overkalix                                                     | 1 -
 dvb-t/se-Oxberg                                                        | 1 -
 dvb-t/se-Paulistom                                                     | 1 -
 dvb-t/se-Rattvik                                                       | 1 -
 dvb-t/se-Rengsjo                                                       | 1 -
 dvb-t/se-Rorbacksnas                                                   | 1 -
 dvb-t/se-Sagmyra                                                       | 1 -
 dvb-t/se-Salen                                                         | 1 -
 dvb-t/se-Salfjallet                                                    | 1 -
 dvb-t/se-Sarna_Mickeltemplet                                           | 1 -
 dvb-t/se-Satila                                                        | 1 -
 dvb-t/se-Saxdalen                                                      | 1 -
 dvb-t/se-Siljansnas_Uvberget                                           | 1 -
 dvb-t/se-Skarstad                                                      | 1 -
 dvb-t/se-Skattungbyn                                                   | 1 -
 dvb-t/se-Skelleftea                                                    | 1 -
 dvb-t/se-Skene_Nycklarberget                                           | 1 -
 dvb-t/se-Skovde                                                        | 1 -
 dvb-t/se-Smedjebacken_Uvberget                                         | 1 -
 dvb-t/se-Soderhamn                                                     | 1 -
 dvb-t/se-Soderkoping                                                   | 1 -
 dvb-t/se-Sodertalje_Ragnhildsborg                                      | 1 -
 dvb-t/se-Solleftea_Hallsta                                             | 1 -
 dvb-t/se-Solleftea_Multra                                              | 1 -
 dvb-t/se-Sorsjon                                                       | 1 -
 dvb-t/se-Stockholm_Marieberg                                           | 1 -
 dvb-t/se-Stockholm_Nacka                                               | 1 -
 dvb-t/se-Stora_Skedvi                                                  | 1 -
 dvb-t/se-Storfjaten                                                    | 1 -
 dvb-t/se-Storuman                                                      | 1 -
 dvb-t/se-Stromstad                                                     | 1 -
 dvb-t/se-Styrsjobo                                                     | 1 -
 dvb-t/se-Sundborn                                                      | 1 -
 dvb-t/se-Sundsbruk                                                     | 1 -
 dvb-t/se-Sundsvall_S_Stadsberget                                       | 1 -
 dvb-t/se-Sunne_Blabarskullen                                           | 1 -
 dvb-t/se-Svartnas                                                      | 1 -
 dvb-t/se-Sveg_Brickan                                                  | 1 -
 dvb-t/se-Taberg                                                        | 1 -
 dvb-t/se-Tandadalen                                                    | 1 -
 dvb-t/se-Tasjo                                                         | 1 -
 dvb-t/se-Tollsjo                                                       | 1 -
 dvb-t/se-Torsby_Bada                                                   | 1 -
 dvb-t/se-Tranas_Bredkarr                                               | 1 -
 dvb-t/se-Tranemo                                                       | 1 -
 dvb-t/se-Transtrand_Bolheden                                           | 1 -
 dvb-t/se-Traryd_Betas                                                  | 1 -
 dvb-t/se-Trollhattan                                                   | 1 -
 dvb-t/se-Trosa                                                         | 1 -
 dvb-t/se-Tystberga                                                     | 1 -
 dvb-t/se-Uddevalla_Herrestad                                           | 1 -
 dvb-t/se-Ullared                                                       | 1 -
 dvb-t/se-Ulricehamn                                                    | 1 -
 dvb-t/se-Ulvshyttan_Porjus                                             | 1 -
 dvb-t/se-Uppsala_Rickomberga                                           | 1 -
 dvb-t/se-Uppsala_Vedyxa                                                | 1 -
 dvb-t/se-Vaddo_Elmsta                                                  | 1 -
 dvb-t/se-Valdemarsvik                                                  | 1 -
 dvb-t/se-Vannas_Granlundsberget                                        | 1 -
 dvb-t/se-Vansbro_Hummelberget                                          | 1 -
 dvb-t/se-Varberg_Grimeton                                              | 1 -
 dvb-t/se-Vasteras_Lillharad                                            | 1 -
 dvb-t/se-Vastervik_Farhult                                             | 1 -
 dvb-t/se-Vaxbo                                                         | 1 -
 dvb-t/se-Vessigebro                                                    | 1 -
 dvb-t/se-Vetlanda_Nye                                                  | 1 -
 dvb-t/se-Vikmanshyttan                                                 | 1 -
 dvb-t/se-Virserum                                                      | 1 -
 dvb-t/se-Visby_Follingbo                                               | 1 -
 dvb-t/se-Visby_Hamnen                                                  | 1 -
 dvb-t/se-Visingso                                                      | 1 -
 dvb-t/se-Vislanda_Nydala                                               | 1 -
 dvb-t/se-Voxna                                                         | 1 -
 dvb-t/se-Ystad_Metallgatan                                             | 1 -
 dvb-t/se-Yttermalung                                                   | 1 -
 dvb-t/sk-BanskaBystrica                                                | 1 -
 dvb-t/sk-BanskaStiavnica                                               | 1 -
 dvb-t/sk-Bardejov                                                      | 1 -
 dvb-t/sk-Bratislava                                                    | 1 -
 dvb-t/sk-Cadca                                                         | 1 -
 dvb-t/sk-Detva                                                         | 1 -
 dvb-t/sk-Hnusta                                                        | 1 -
 dvb-t/sk-Kosice                                                        | 1 -
 dvb-t/sk-KralovskyChlmec                                               | 1 -
 dvb-t/sk-Krompachy                                                     | 1 -
 dvb-t/sk-Lucenec                                                       | 1 -
 dvb-t/sk-Medzev                                                        | 1 -
 dvb-t/sk-Namestovo                                                     | 1 -
 dvb-t/sk-Nitra                                                         | 1 -
 dvb-t/sk-Poprad                                                        | 1 -
 dvb-t/sk-PovazskaBystrica                                              | 1 -
 dvb-t/sk-Presov                                                        | 1 -
 dvb-t/sk-Prievidza                                                     | 1 -
 dvb-t/sk-Revuca                                                        | 1 -
 dvb-t/sk-Roznava                                                       | 1 -
 dvb-t/sk-Ruzomberok                                                    | 1 -
 dvb-t/sk-Snina                                                         | 1 -
 dvb-t/sk-StaraLubovna                                                  | 1 -
 dvb-t/sk-Sturovo                                                       | 1 -
 dvb-t/sk-Trencin                                                       | 1 -
 dvb-t/sk-Zilina                                                        | 1 -
 dvb-t/ua-Kharkov                                                       | 1 -
 dvb-t/ua-Kiev                                                          | 1 -
 dvb-t/ua-Lozovaya                                                      | 1 -
 dvb-t/ua-Odessa                                                        | 1 -
 dvb-t/ug-All                                                           | 1 -
 dvb-t/uk-Aberdare                                                      | 1 -
 dvb-t/uk-Angus                                                         | 1 -
 dvb-t/uk-BeaconHill                                                    | 1 -
 dvb-t/uk-Belmont                                                       | 1 -
 dvb-t/uk-Bilsdale                                                      | 1 -
 dvb-t/uk-BlackHill                                                     | 1 -
 dvb-t/uk-Blaenplwyf                                                    | 1 -
 dvb-t/uk-BluebellHill                                                  | 1 -
 dvb-t/uk-Bressay                                                       | 1 -
 dvb-t/uk-BrierleyHill                                                  | 1 -
 dvb-t/uk-BristolIlchesterCrescent                                      | 1 -
 dvb-t/uk-BristolKingsWeston                                            | 1 -
 dvb-t/uk-Bromsgrove                                                    | 1 -
 dvb-t/uk-BrougherMountain                                              | 1 -
 dvb-t/uk-Caldbeck                                                      | 1 -
 dvb-t/uk-CaradonHill                                                   | 1 -
 dvb-t/uk-Carmel                                                        | 1 -
 dvb-t/uk-Chatton                                                       | 1 -
 dvb-t/uk-Chesterfield                                                  | 1 -
 dvb-t/uk-Craigkelly                                                    | 1 -
 dvb-t/uk-CrystalPalace                                                 | 1 -
 dvb-t/uk-Darvel                                                        | 1 -
 dvb-t/uk-Divis                                                         | 1 -
 dvb-t/uk-Dover                                                         | 1 -
 dvb-t/uk-Durris                                                        | 1 -
 dvb-t/uk-Eitshal                                                       | 1 -
 dvb-t/uk-EmleyMoor                                                     | 1 -
 dvb-t/uk-Fenham                                                        | 1 -
 dvb-t/uk-Fenton                                                        | 1 -
 dvb-t/uk-Ferryside                                                     | 1 -
 dvb-t/uk-Guildford                                                     | 1 -
 dvb-t/uk-Hannington                                                    | 1 -
 dvb-t/uk-Hastings                                                      | 1 -
 dvb-t/uk-Heathfield                                                    | 1 -
 dvb-t/uk-HemelHempstead                                                | 1 -
 dvb-t/uk-HuntshawCross                                                 | 1 -
 dvb-t/uk-Idle                                                          | 1 -
 dvb-t/uk-KeelylangHill                                                 | 1 -
 dvb-t/uk-Keighley                                                      | 1 -
 dvb-t/uk-KilveyHill                                                    | 1 -
 dvb-t/uk-KnockMore                                                     | 1 -
 dvb-t/uk-Lancaster                                                     | 1 -
 dvb-t/uk-LarkStoke                                                     | 1 -
 dvb-t/uk-Limavady                                                      | 1 -
 dvb-t/uk-Llanddona                                                     | 1 -
 dvb-t/uk-Malvern                                                       | 1 -
 dvb-t/uk-Mendip                                                        | 1 -
 dvb-t/uk-Midhurst                                                      | 1 -
 dvb-t/uk-MoelyParc                                                     | 1 -
 dvb-t/uk-Nottingham                                                    | 1 -
 dvb-t/uk-OliversMount                                                  | 1 -
 dvb-t/uk-Oxford                                                        | 1 -
 dvb-t/uk-PendleForest                                                  | 1 -
 dvb-t/uk-Plympton                                                      | 1 -
 dvb-t/uk-PontopPike                                                    | 1 -
 dvb-t/uk-Pontypool                                                     | 1 -
 dvb-t/uk-Preseli                                                       | 1 -
 dvb-t/uk-Redruth                                                       | 1 -
 dvb-t/uk-Reigate                                                       | 1 -
 dvb-t/uk-RidgeHill                                                     | 1 -
 dvb-t/uk-Rosemarkie                                                    | 1 -
 dvb-t/uk-Rosneath                                                      | 1 -
 dvb-t/uk-Rowridge                                                      | 1 -
 dvb-t/uk-RumsterForest                                                 | 1 -
 dvb-t/uk-Saddleworth                                                   | 1 -
 dvb-t/uk-Salisbury                                                     | 1 -
 dvb-t/uk-SandyHeath                                                    | 1 -
 dvb-t/uk-Selkirk                                                       | 1 -
 dvb-t/uk-Sheffield                                                     | 1 -
 dvb-t/uk-StocklandHill                                                 | 1 -
 dvb-t/uk-Storeton                                                      | 1 -
 dvb-t/uk-Sudbury                                                       | 1 -
 dvb-t/uk-SuttonColdfield                                               | 1 -
 dvb-t/uk-Tacolneston                                                   | 1 -
 dvb-t/uk-TheWrekin                                                     | 1 -
 dvb-t/uk-Torosay                                                       | 1 -
 dvb-t/uk-TunbridgeWells                                                | 1 -
 dvb-t/uk-Waltham                                                       | 1 -
 dvb-t/uk-Wenvoe                                                        | 1 -
 dvb-t/uk-WhitehawkHill                                                 | 1 -
 dvb-t/uk-WinterHill                                                    | 1 -
 dvb-t/vn-Hanoi                                                         | 1 -
 dvb-t/vn-Thaibinh                                                      | 1 -
 494 files changed, 496 deletions(-)

diff --git a/dvb-t/ad-Andorra b/dvb-t/ad-Andorra
index 979b7bb..e43251d 100644
--- a/dvb-t/ad-Andorra
+++ b/dvb-t/ad-Andorra
@@ -1,5 +1,4 @@
 # DVB-T Andorra
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/at-All b/dvb-t/at-All
index 9fb2508..7fbfdce 100644
--- a/dvb-t/at-All
+++ b/dvb-t/at-All
@@ -1,7 +1,6 @@
 # Austria, all DVB-T transmitters run by ORS
 # Created from
 # http://www.ors.at/fileadmin/user_upload/downloads/DVB-T_Kanalbezeichnungen_und_Mittenfrequenzen.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/au-Adelaide b/dvb-t/au-Adelaide
index 58e8ca0..5376dd8 100644
--- a/dvb-t/au-Adelaide
+++ b/dvb-t/au-Adelaide
@@ -1,5 +1,4 @@
 # Australia / Adelaide / Mt Lofty
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-AdelaideFoothills b/dvb-t/au-AdelaideFoothills
index dbd6bfd..73dbe3d 100644
--- a/dvb-t/au-AdelaideFoothills
+++ b/dvb-t/au-AdelaideFoothills
@@ -1,5 +1,4 @@
 # Australia / Adelaide / Grenfell Street
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Ballarat b/dvb-t/au-Ballarat
index 77c83c2..438ada9 100644
--- a/dvb-t/au-Ballarat
+++ b/dvb-t/au-Ballarat
@@ -1,5 +1,4 @@
 # Australia / Ballarat
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Bendigo b/dvb-t/au-Bendigo
index 161a742..07f09ca 100644
--- a/dvb-t/au-Bendigo
+++ b/dvb-t/au-Bendigo
@@ -1,5 +1,4 @@
 # Australia / Bendigo (Mt Alexandria transmitters)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Brisbane b/dvb-t/au-Brisbane
index 2cdbfdc..68bc1ac 100644
--- a/dvb-t/au-Brisbane
+++ b/dvb-t/au-Brisbane
@@ -1,5 +1,4 @@
 # Australia / Brisbane (Mt Coot-tha transmitters)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Cairns b/dvb-t/au-Cairns
index cea948a..272c605 100644
--- a/dvb-t/au-Cairns
+++ b/dvb-t/au-Cairns
@@ -1,5 +1,4 @@
 # Australia / Cairns (Mt Bellenden-Ker transmitters)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC VHF 8
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Canberra-Black-Mt b/dvb-t/au-Canberra-Black-Mt
index ac52d0f..4addba1 100644
--- a/dvb-t/au-Canberra-Black-Mt
+++ b/dvb-t/au-Canberra-Black-Mt
@@ -1,5 +1,4 @@
 # Australia / Canberra / Black Mt
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Coonabarabran b/dvb-t/au-Coonabarabran
index 12300f9..83a4e6a 100644
--- a/dvb-t/au-Coonabarabran
+++ b/dvb-t/au-Coonabarabran
@@ -1,6 +1,5 @@
 # Australia / Coonabarabran
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # ABC VHF12
 [CHANNEL]
diff --git a/dvb-t/au-Darwin b/dvb-t/au-Darwin
index 243d98a..4e77194 100644
--- a/dvb-t/au-Darwin
+++ b/dvb-t/au-Darwin
@@ -1,4 +1,3 @@
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC (UHF 30)
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Devonport b/dvb-t/au-Devonport
index 6ec1c7a..da39e0d 100644
--- a/dvb-t/au-Devonport
+++ b/dvb-t/au-Devonport
@@ -1,5 +1,4 @@
 # Australia / Tasmania / Devonport
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # Brett S Hallett October 2009 , may not be complete !!
 #
diff --git a/dvb-t/au-FraserCoast-Bundaberg b/dvb-t/au-FraserCoast-Bundaberg
index f862fee..ea93d82 100644
--- a/dvb-t/au-FraserCoast-Bundaberg
+++ b/dvb-t/au-FraserCoast-Bundaberg
@@ -1,5 +1,4 @@
 # Australia / QLD / Fraser Coast - Bundaberg / Mt Goonaneman
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC VHF9A
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-GoldCoast b/dvb-t/au-GoldCoast
index e2aefac..9f3a74b 100644
--- a/dvb-t/au-GoldCoast
+++ b/dvb-t/au-GoldCoast
@@ -2,7 +2,6 @@
 # See http://www.dba.org.au/index.asp?sectionID=22&recLocation=Gold+Coast
 # and http://www.dba.org.au/index.asp?sectionID=120
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC (UHF 62)
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Goulburn-Rocky_Hill b/dvb-t/au-Goulburn-Rocky_Hill
index de8d13b..2165655 100644
--- a/dvb-t/au-Goulburn-Rocky_Hill
+++ b/dvb-t/au-Goulburn-Rocky_Hill
@@ -2,7 +2,6 @@
 #
 # Scanned 17/10/2009 - Alex Ferrara (alex@receptiveit.com.au)
 
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC - netid (4112) tid (547) offset (+125Khz)
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Hervey_Bay-Ghost_Hill b/dvb-t/au-Hervey_Bay-Ghost_Hill
index 866a855..e35869a 100644
--- a/dvb-t/au-Hervey_Bay-Ghost_Hill
+++ b/dvb-t/au-Hervey_Bay-Ghost_Hill
@@ -1,6 +1,5 @@
 # Australia / Hervey Bay / Ghost Hill
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # ABC UHF56
 [CHANNEL]
diff --git a/dvb-t/au-Hobart b/dvb-t/au-Hobart
index cdfca66..c94c53f 100644
--- a/dvb-t/au-Hobart
+++ b/dvb-t/au-Hobart
@@ -1,5 +1,4 @@
 # Australia / Tasmania / Hobart
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC VHF 8
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Mackay b/dvb-t/au-Mackay
index 76f1a5a..f894007 100644
--- a/dvb-t/au-Mackay
+++ b/dvb-t/au-Mackay
@@ -1,7 +1,6 @@
 # Australia / Mackay (Mt Blackwood transmitters)
 # aufreq=((UHF channel number)*8+306)
 
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Melbourne b/dvb-t/au-Melbourne
index e3963b1..cc742ff 100644
--- a/dvb-t/au-Melbourne
+++ b/dvb-t/au-Melbourne
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2014-08-17
 # provided by (opt)    : <your name or email here>
 #
-# T[2] [plp_id] [system_id] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 # Seven Network
 [CHANNEL]
diff --git a/dvb-t/au-Melbourne-Selby b/dvb-t/au-Melbourne-Selby
index ec346ff..2219466 100644
--- a/dvb-t/au-Melbourne-Selby
+++ b/dvb-t/au-Melbourne-Selby
@@ -1,5 +1,4 @@
 # Australia / Melbourne (Selby Repeater)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Melbourne-Upwey b/dvb-t/au-Melbourne-Upwey
index 20c55e2..978e2ad 100644
--- a/dvb-t/au-Melbourne-Upwey
+++ b/dvb-t/au-Melbourne-Upwey
@@ -1,5 +1,4 @@
 # Australia / Melbourne (Upwey Repeater)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-MidNorthCoast b/dvb-t/au-MidNorthCoast
index 66b3cd5..714d8da 100644
--- a/dvb-t/au-MidNorthCoast
+++ b/dvb-t/au-MidNorthCoast
@@ -1,5 +1,4 @@
 # Australia ABC Mid North Coast
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC middle brother
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Newcastle b/dvb-t/au-Newcastle
index 00b87b5..dd634e4 100644
--- a/dvb-t/au-Newcastle
+++ b/dvb-t/au-Newcastle
@@ -1,5 +1,4 @@
 # Australia / Newcastle
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Perth b/dvb-t/au-Perth
index 7292697..4c6fb09 100644
--- a/dvb-t/au-Perth
+++ b/dvb-t/au-Perth
@@ -1,5 +1,4 @@
 # Australia / Perth
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Perth_Roleystone b/dvb-t/au-Perth_Roleystone
index 52a4833..f02cc23 100644
--- a/dvb-t/au-Perth_Roleystone
+++ b/dvb-t/au-Perth_Roleystone
@@ -1,5 +1,4 @@
 # Australia / Perth (Roleystone transmitter)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-SpencerGulf b/dvb-t/au-SpencerGulf
index 724bac5..9983110 100644
--- a/dvb-t/au-SpencerGulf
+++ b/dvb-t/au-SpencerGulf
@@ -1,5 +1,4 @@
 # Australia / South Australia / Pt Pirie (THE BLUFF)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-SunshineCoast b/dvb-t/au-SunshineCoast
index 9826c55..5d22931 100644
--- a/dvb-t/au-SunshineCoast
+++ b/dvb-t/au-SunshineCoast
@@ -1,5 +1,4 @@
 # Australia / Sunshine Coast
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS36 SBS ***
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Sutherland b/dvb-t/au-Sutherland
index b7fb1ac..403f4be 100644
--- a/dvb-t/au-Sutherland
+++ b/dvb-t/au-Sutherland
@@ -3,7 +3,6 @@
 # Australia modulation params:
 # - http://www.dba.org.au/index.asp?sectionID=120
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # North (Broadcast Site Escarpment Road BROKERS NOSE)
 # - http://www.dba.org.au/index.asp?query=true&sectionID=22&recLocation=Wollongong+%2D+North
diff --git a/dvb-t/au-Sydney b/dvb-t/au-Sydney
index 77db15b..19e7be3 100644
--- a/dvb-t/au-Sydney
+++ b/dvb-t/au-Sydney
@@ -1,7 +1,6 @@
 # Australia / Sydney (transmitters at Artarmon/Gore Hill/Willoughby)
 #
 # ## Service - Channel - Network owner
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 ## ABC - CH12 - ABC
 [CHANNEL]
diff --git a/dvb-t/au-Sydney_Kings_Cross b/dvb-t/au-Sydney_Kings_Cross
index 949e1b2..f61fb98 100644
--- a/dvb-t/au-Sydney_Kings_Cross
+++ b/dvb-t/au-Sydney_Kings_Cross
@@ -1,6 +1,5 @@
 # Australia / Sydney / Kings Cross and North Head
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # ABC UHF30
 [CHANNEL]
diff --git a/dvb-t/au-Tamworth b/dvb-t/au-Tamworth
index 9e497e4..87c3180 100644
--- a/dvb-t/au-Tamworth
+++ b/dvb-t/au-Tamworth
@@ -1,5 +1,4 @@
 # Australia / NSW / New England / Tamworth / Mt.Soma
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
@@ -67,7 +66,6 @@
 
 
 # Australia / NSW / New England / Upper Namoi / Mt.Dowe
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
@@ -135,7 +133,6 @@
 
 
 # Australia / NSW / Western Districts / Central Western Slopes / Mt. Cenn Cruaich
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Townsville b/dvb-t/au-Townsville
index e2fed41..d7c8b6c 100644
--- a/dvb-t/au-Townsville
+++ b/dvb-t/au-Townsville
@@ -1,5 +1,4 @@
 # Australia / Brisbane (Mt Coot-tha transmitters)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-WaggaWagga b/dvb-t/au-WaggaWagga
index e82cfb8..d0762c7 100644
--- a/dvb-t/au-WaggaWagga
+++ b/dvb-t/au-WaggaWagga
@@ -1,5 +1,4 @@
 # Australia / Wagga Wagga (Mt Ulundra)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-Wollongong b/dvb-t/au-Wollongong
index 1f57daf..94fe744 100644
--- a/dvb-t/au-Wollongong
+++ b/dvb-t/au-Wollongong
@@ -3,7 +3,6 @@
 # Australia modulation params:
 # - http://www.dba.org.au/index.asp?sectionID=120
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # North (Broadcast Site Escarpment Road BROKERS NOSE)
 # - http://www.dba.org.au/index.asp?query=true&sectionID=22&recLocation=Wollongong+%2D+North
diff --git a/dvb-t/au-canberra b/dvb-t/au-canberra
index ab32dff..79a094a 100644
--- a/dvb-t/au-canberra
+++ b/dvb-t/au-canberra
@@ -1,5 +1,4 @@
 # Australia / Canberra / Woden
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # ABC
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/au-unknown b/dvb-t/au-unknown
index 0d89a19..c8d16b3 100644
--- a/dvb-t/au-unknown
+++ b/dvb-t/au-unknown
@@ -1,5 +1,4 @@
 # Australia ABC
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 226500000
diff --git a/dvb-t/auto-Australia b/dvb-t/auto-Australia
index c6e1829..f58fae3 100644
--- a/dvb-t/auto-Australia
+++ b/dvb-t/auto-Australia
@@ -7,7 +7,6 @@
 # 	print "T ", $freq + 125000, " 7MHz AUTO NONE AUTO AUTO AUTO NONE\n";
 # }
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 177500000
diff --git a/dvb-t/auto-Default b/dvb-t/auto-Default
index 7516c8e..add81b9 100644
--- a/dvb-t/auto-Default
+++ b/dvb-t/auto-Default
@@ -5,7 +5,6 @@
 # 	print "T $freq 8MHz AUTO NONE AUTO AUTO AUTO NONE\n";
 # }
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 177500000
diff --git a/dvb-t/auto-Taiwan b/dvb-t/auto-Taiwan
index da1e03a..3b2fb9f 100644
--- a/dvb-t/auto-Taiwan
+++ b/dvb-t/auto-Taiwan
@@ -2,7 +2,6 @@
 # 	print "T $freq 6MHz AUTO NONE AUTO AUTO AUTO NONE\n";
 # }
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 527000000
diff --git a/dvb-t/auto-With167kHzOffsets b/dvb-t/auto-With167kHzOffsets
index be54895..3542db0 100644
--- a/dvb-t/auto-With167kHzOffsets
+++ b/dvb-t/auto-With167kHzOffsets
@@ -7,7 +7,6 @@
 # 	print "T ", $freq + 167000, " 8MHz AUTO NONE AUTO AUTO AUTO NONE\n";
 # }
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 177500000
diff --git a/dvb-t/ax-Smedsbole b/dvb-t/ax-Smedsbole
index 3e77568..19e206d 100644
--- a/dvb-t/ax-Smedsbole
+++ b/dvb-t/ax-Smedsbole
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2009-12-23
 # provided by (opt)    : k.hampf@gmail.com
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [Åland Network]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/be-All b/dvb-t/be-All
index dd949f0..c957c06 100644
--- a/dvb-t/be-All
+++ b/dvb-t/be-All
@@ -1,6 +1,5 @@
 # Belgium, whole country
 # Created from http://nl.wikipedia.org/wiki/DVB-T-frequenties
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/bg-Sofia b/dvb-t/bg-Sofia
index 6f07d5b..1d39d1c 100644
--- a/dvb-t/bg-Sofia
+++ b/dvb-t/bg-Sofia
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2013-05-13
 # provided by (opt)    : v.lalov@gmail.com
 #
-# T[2] [plp_id] [system_id] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [NURTS Digital]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/ch-All b/dvb-t/ch-All
index 6cb5949..0ff77ca 100644
--- a/dvb-t/ch-All
+++ b/dvb-t/ch-All
@@ -1,7 +1,6 @@
 # Switzerland, whole country
 # Created from http://www.broadcast.ch/portal.aspx?pid=705
 # and http://www.broadcast.ch/data_program_dvbt.aspx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/ch-Citycable b/dvb-t/ch-Citycable
index d762f33..ef58d06 100644
--- a/dvb-t/ch-Citycable
+++ b/dvb-t/ch-Citycable
@@ -1,5 +1,4 @@
 # Lausanne - Switzerland (DVB-T on CityCable cable network)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 498000000
diff --git a/dvb-t/ch-Geneva b/dvb-t/ch-Geneva
index bd53225..a64cc94 100644
--- a/dvb-t/ch-Geneva
+++ b/dvb-t/ch-Geneva
@@ -1,6 +1,5 @@
 # Switzerland, Geneva region
 # Updated by tkernen@deckpoint.ch on 2010/12/03
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/cz-All b/dvb-t/cz-All
index 3559791..672f2c6 100644
--- a/dvb-t/cz-All
+++ b/dvb-t/cz-All
@@ -1,7 +1,6 @@
 # Czech Republic, whole country (updated to regulatory 2013)
 # Created from http://www.ctu.cz/cs/download/plan-vyuziti-radioveho-spektra/rok_2012/pv-p_10-08_2012-11.pdf
 
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/de-Baden-Wuerttemberg b/dvb-t/de-Baden-Wuerttemberg
index 45e8391..07ead31 100644
--- a/dvb-t/de-Baden-Wuerttemberg
+++ b/dvb-t/de-Baden-Wuerttemberg
@@ -1,6 +1,5 @@
 # DVB-T Baden-Württemberg
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/de-Bayern b/dvb-t/de-Bayern
index 71e312e..0d4182f 100644
--- a/dvb-t/de-Bayern
+++ b/dvb-t/de-Bayern
@@ -1,6 +1,5 @@
 # DVB-T Bayern
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH23: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/de-Berlin b/dvb-t/de-Berlin
index 3d2bce8..79d29b5 100644
--- a/dvb-t/de-Berlin
+++ b/dvb-t/de-Berlin
@@ -1,6 +1,5 @@
 # DVB-T Berlin
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH25: RTL, RTL2, Super RTL, VOX]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/de-Brandenburg b/dvb-t/de-Brandenburg
index 64e41dd..223126e 100644
--- a/dvb-t/de-Brandenburg
+++ b/dvb-t/de-Brandenburg
@@ -1,6 +1,5 @@
 # DVB-T Brandenburg
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH33: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/de-Bremen b/dvb-t/de-Bremen
index ecc9a13..24ab8eb 100644
--- a/dvb-t/de-Bremen
+++ b/dvb-t/de-Bremen
@@ -1,6 +1,5 @@
 # DVB-T Bremen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH22: Das Erste (RB), RB TV (NDR NDS), arte, Phoenix]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/de-Hamburg b/dvb-t/de-Hamburg
index 6977119..7a43b78 100644
--- a/dvb-t/de-Hamburg
+++ b/dvb-t/de-Hamburg
@@ -1,6 +1,5 @@
 # DVB-T Hamburg
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH23: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/de-Hessen b/dvb-t/de-Hessen
index 2b60d5f..636e30c 100644
--- a/dvb-t/de-Hessen
+++ b/dvb-t/de-Hessen
@@ -1,6 +1,5 @@
 # DVB-T Hessen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/de-Mecklenburg-Vorpommern b/dvb-t/de-Mecklenburg-Vorpommern
index ce5cecd..259012f 100644
--- a/dvb-t/de-Mecklenburg-Vorpommern
+++ b/dvb-t/de-Mecklenburg-Vorpommern
@@ -1,6 +1,5 @@
 # DVB-T Mecklenburg-Vorpommernen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH22: Das Erste, NDR MVP, RBB, MDR/NDR SH]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/de-Niedersachsen b/dvb-t/de-Niedersachsen
index ed3ad49..496e1c4 100644
--- a/dvb-t/de-Niedersachsen
+++ b/dvb-t/de-Niedersachsen
@@ -1,6 +1,5 @@
 # DVB-T Niedersachsen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: NDR NDS, WDR/NDR SH, MDR/NDR MVP, HR/NDR HH]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/de-Nordrhein-Westfalen b/dvb-t/de-Nordrhein-Westfalen
index 49802c4..940d18d 100644
--- a/dvb-t/de-Nordrhein-Westfalen
+++ b/dvb-t/de-Nordrhein-Westfalen
@@ -1,6 +1,5 @@
 # DVB-T Nordrhein-Westfalen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH25: WDR-Dortmund, NDR/WDR-Ruhr, MDR, SWR]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/de-Rheinland-Pfalz b/dvb-t/de-Rheinland-Pfalz
index 21ba979..8779942 100644
--- a/dvb-t/de-Rheinland-Pfalz
+++ b/dvb-t/de-Rheinland-Pfalz
@@ -1,6 +1,5 @@
 # DVB-T Rheinland-Pfalz
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH28: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/de-Saarland b/dvb-t/de-Saarland
index ef83d66..4809557 100644
--- a/dvb-t/de-Saarland
+++ b/dvb-t/de-Saarland
@@ -1,6 +1,5 @@
 # DVB-T Saarland
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH30: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/de-Sachsen b/dvb-t/de-Sachsen
index 80c1e5e..ad87514 100644
--- a/dvb-t/de-Sachsen
+++ b/dvb-t/de-Sachsen
@@ -1,6 +1,5 @@
 # DVB-T Sachsen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH22: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/de-Sachsen-Anhalt b/dvb-t/de-Sachsen-Anhalt
index b2b61a0..9925a2d 100644
--- a/dvb-t/de-Sachsen-Anhalt
+++ b/dvb-t/de-Sachsen-Anhalt
@@ -1,6 +1,5 @@
 # DVB-T Sachsen-Anhalt
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH22: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/de-Schleswig-Holstein b/dvb-t/de-Schleswig-Holstein
index 9b3c2a7..00976ac 100644
--- a/dvb-t/de-Schleswig-Holstein
+++ b/dvb-t/de-Schleswig-Holstein
@@ -1,6 +1,5 @@
 # DVB-T Schleswig-Holstein
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/de-Thueringen b/dvb-t/de-Thueringen
index 6cd9cde..72fa945 100644
--- a/dvb-t/de-Thueringen
+++ b/dvb-t/de-Thueringen
@@ -1,6 +1,5 @@
 # DVB-T Thüringen
 # Created from http://www.ueberallfernsehen.de/data/senderliste.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: Das Erste, arte, Phoenix, EinsFestival]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/dk-All b/dvb-t/dk-All
index 3a792fe..6bd590c 100644
--- a/dvb-t/dk-All
+++ b/dvb-t/dk-All
@@ -1,7 +1,6 @@
 # Denmark, whole country
 # Created from http://www.digi-tv.dk/Indhold_og_tilbud/frekvenser.asp
 # and http://www.digi-tv.dk/Sendenettets_opbygning/
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/ee-All b/dvb-t/ee-All
index 2d2d23d..689a35a 100644
--- a/dvb-t/ee-All
+++ b/dvb-t/ee-All
@@ -2,7 +2,6 @@
 # Created from http://www.levira.ee/transmitter.pdf
 # and http://wiki.wifi.ee/index.php/DVB-T#Tehniline_teave
 # Additional MUX info http://www.levira.ee/program.pdf
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/es-Albacete b/dvb-t/es-Albacete
index 9cd548c..d64012e 100644
--- a/dvb-t/es-Albacete
+++ b/dvb-t/es-Albacete
@@ -1,5 +1,4 @@
 # Spain, Albacete - Update 2010/08/12 (Freud)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 37: La Regional, TCM, CRN]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/es-Alfabia b/dvb-t/es-Alfabia
index 3fea14e..ee20e68 100644
--- a/dvb-t/es-Alfabia
+++ b/dvb-t/es-Alfabia
@@ -1,5 +1,4 @@
 # DVB-T Alfabia, Mallorca, Balearic Islands, Spain.
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [TV3 Cat, 3/24, 33, Super3/300]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/es-Alicante b/dvb-t/es-Alicante
index afdcb70..a95a492 100644
--- a/dvb-t/es-Alicante
+++ b/dvb-t/es-Alicante
@@ -1,5 +1,4 @@
 # DVB-T Alicante, Spain
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 55: TV3, K33/33, 3/24, Canal 300]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/es-Alpicat b/dvb-t/es-Alpicat
index 65df509..be46742 100644
--- a/dvb-t/es-Alpicat
+++ b/dvb-t/es-Alpicat
@@ -1,5 +1,4 @@
 # DVB-T Alpicat (Lleida)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [c58: TV3, K3/33, 3/24, 300, 3i]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/es-Asturias b/dvb-t/es-Asturias
index 2ad9272..f163d4b 100644
--- a/dvb-t/es-Asturias
+++ b/dvb-t/es-Asturias
@@ -1,5 +1,4 @@
 # DVB-T Asturias
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [TPA TPA2]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 786000000
diff --git a/dvb-t/es-BaixoMinho b/dvb-t/es-BaixoMinho
index 69ae509..ffc1de8 100644
--- a/dvb-t/es-BaixoMinho
+++ b/dvb-t/es-BaixoMinho
@@ -6,7 +6,6 @@
 # date (yyyy-mm-dd)    : 2009-07-11
 # provided by (opt)    : neonmann@gmail.com
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [SFN]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/es-Cadiz b/dvb-t/es-Cadiz
index 7b2d439..4155003 100644
--- a/dvb-t/es-Cadiz
+++ b/dvb-t/es-Cadiz
@@ -1,7 +1,6 @@
 # DVB-T Cadiz (Andalusia)                      by xiterrex  Aug 2014
 # Info obtained from Spanish Government (Ministerio de Industria) at URL:
 # <http://www.minetur.gob.es/telecomunicaciones/infraestructuras/paginas/tdt_ict.aspx>
-# T freq bw fec_hi fec_lo mod transm-mode guard-interval hierarchy
 [C21 # MPE2]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/es-Carceres b/dvb-t/es-Carceres
index 80d8eb3..8f52a46 100644
--- a/dvb-t/es-Carceres
+++ b/dvb-t/es-Carceres
@@ -1,4 +1,3 @@
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 39: 8Madrid, TMT-Popular TV, Kiss TV, Intereconomía TV]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/es-Collserola b/dvb-t/es-Collserola
index 16c2d33..60c73f0 100644
--- a/dvb-t/es-Collserola
+++ b/dvb-t/es-Collserola
@@ -1,5 +1,4 @@
 # DVB-T Collserola (Barcelona)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [BTV, TV Badalona, TV L'Hospitalet, TV del Besòs, COM Ràdio, Ràdio Ciutat Badalona, Ràdio L'Hospitalet]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/es-Donostia b/dvb-t/es-Donostia
index e39f20f..a760346 100644
--- a/dvb-t/es-Donostia
+++ b/dvb-t/es-Donostia
@@ -1,6 +1,5 @@
 # The channels with 1/32 guard-interval are French and should be perfectly visible
 # here. However I have only managed to get a lock for the channel 57 of the French ones.
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/es-Granada b/dvb-t/es-Granada
index 79ee07d..1545b96 100644
--- a/dvb-t/es-Granada
+++ b/dvb-t/es-Granada
@@ -1,5 +1,4 @@
 # Spain, Granada
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/es-Huesca b/dvb-t/es-Huesca
index 678677d..53cb087 100644
--- a/dvb-t/es-Huesca
+++ b/dvb-t/es-Huesca
@@ -1,6 +1,5 @@
 # DVB-T Huesca (Aragon) [Spain] [es-Huesca]
 # Generated by Vicente Hernando Ara <bizenton@gmail.com>
-# T[2] [plp_id] [system_id] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 
 [CH 43  HTV-HuescaTelevision]
diff --git a/dvb-t/es-Las_Palmas b/dvb-t/es-Las_Palmas
index a6a766e..da971ee 100644
--- a/dvb-t/es-Las_Palmas
+++ b/dvb-t/es-Las_Palmas
@@ -3,7 +3,6 @@
 # Revisada y corregida por el Grupo de Usuarios de Linux de Canarias
 # http://www.gulic.org
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 28: TVE HD, Teledeporte, RNE Clásica, RNE 3]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/es-Lugo b/dvb-t/es-Lugo
index 2ae15cd..53164a7 100644
--- a/dvb-t/es-Lugo
+++ b/dvb-t/es-Lugo
@@ -1,5 +1,4 @@
 # DVB-T Lugo (Centro emisor Paramo) - Rev. 1.2 - 11.12.05
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [TVE 1, TVE 2, 24H TVE, CLAN/50 TVE, RNE1, RNE CLASICA, RNE3]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/es-Madrid b/dvb-t/es-Madrid
index 025c153..40df6e6 100644
--- a/dvb-t/es-Madrid
+++ b/dvb-t/es-Madrid
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2011-03-16
 # provided by (opt)    : <your name or email here>
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/es-Malaga b/dvb-t/es-Malaga
index 3dfe9a7..521e5da 100644
--- a/dvb-t/es-Malaga
+++ b/dvb-t/es-Malaga
@@ -1,5 +1,4 @@
 # DVB-T Malaga (Andalucia)                   by Pedro Leon 4 Mayo 2007
-# T freq bw fec_hi fec_lo mod transm-mode guard-interval hierarchy
 [C57 La Primera, La 2, Canal 24H, Clan/TVE 50, RNE1, RNE Clásica, RNE 3]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/es-Muros-Noia b/dvb-t/es-Muros-Noia
index 33a189e..26d3016 100644
--- a/dvb-t/es-Muros-Noia
+++ b/dvb-t/es-Muros-Noia
@@ -1,5 +1,4 @@
 # DVB-T Muros and Noia
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 27: Local Ribeira]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/es-Mussara b/dvb-t/es-Mussara
index 17e6676..c02383f 100644
--- a/dvb-t/es-Mussara
+++ b/dvb-t/es-Mussara
@@ -1,5 +1,4 @@
 # DVB-T La Mussara (Reus-Tarragona)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [c59: TV3, K3/33, 3/24, 300, 3i]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/es-Pamplona b/dvb-t/es-Pamplona
index f266bb1..fed6f53 100644
--- a/dvb-t/es-Pamplona
+++ b/dvb-t/es-Pamplona
@@ -1,5 +1,4 @@
 # DVB-T Pamplona
-# T freq bw fec_hi fec_lo mod transm-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/es-SC_Tenerife b/dvb-t/es-SC_Tenerife
index f314f9b..25ef3ba 100644
--- a/dvb-t/es-SC_Tenerife
+++ b/dvb-t/es-SC_Tenerife
@@ -3,7 +3,6 @@
 # Revisada y corregida por el Grupo de Usuarios de Linux de Canarias
 # http://www.gulic.org
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [C23]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/es-Santander b/dvb-t/es-Santander
index 8b9a836..d2fc392 100644
--- a/dvb-t/es-Santander
+++ b/dvb-t/es-Santander
@@ -1,6 +1,5 @@
 # file automatically generated by w_scan
 # (http://wirbel.htpc-forum.de/w_scan/index2.html)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/es-Santiago_de_Compostela b/dvb-t/es-Santiago_de_Compostela
index 3a9f922..75943db 100644
--- a/dvb-t/es-Santiago_de_Compostela
+++ b/dvb-t/es-Santiago_de_Compostela
@@ -1,5 +1,4 @@
 # DVB-T Santiago de Compostela
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 23: Local Santiago]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/es-Sevilla b/dvb-t/es-Sevilla
index fce174c..17eae2a 100644
--- a/dvb-t/es-Sevilla
+++ b/dvb-t/es-Sevilla
@@ -1,7 +1,6 @@
 # DVB-T Sevilla (Spain) by x2 15-agos-2010, modificado 15-ago-2010
 #                                    thanks to http://www.tdt1.com
 #         thanks to http://wirbel.htpc-forum.de/w_scan/index2.html
-# T freq bw fec_hi fec_lo mod transm-mode guard-interval hierarchy
 [C33]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/es-Tenerife b/dvb-t/es-Tenerife
index f8a7b1f..c97a002 100644
--- a/dvb-t/es-Tenerife
+++ b/dvb-t/es-Tenerife
@@ -1,5 +1,4 @@
 # DVB-T Tenerife, Spain (03/04/2011)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 23: laSexta 2, laSexta 3, laSexta HD, C+ 2, Cuatro]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/es-Valladolid b/dvb-t/es-Valladolid
index fb77a01..31bf0ac 100644
--- a/dvb-t/es-Valladolid
+++ b/dvb-t/es-Valladolid
@@ -1,5 +1,4 @@
 # DVB-T Valladolid
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Canal 57: Clan TVE, 24H TVE, La 2, TVE 1, RNE1, RNE3, RNC]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/es-Vilamarxant b/dvb-t/es-Vilamarxant
index e819dd7..c355eef 100644
--- a/dvb-t/es-Vilamarxant
+++ b/dvb-t/es-Vilamarxant
@@ -1,5 +1,4 @@
 # DVB-T Vilamarxant, Valencia, C. Valenciana, Spain.
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/fr-All b/dvb-t/fr-All
index d8ed1f5..c3eba11 100644
--- a/dvb-t/fr-All
+++ b/dvb-t/fr-All
@@ -1,5 +1,4 @@
 # France ALL (All channel 21 to 60)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [UHF 21]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/gr-Athens b/dvb-t/gr-Athens
index 1e6b795..ff1db28 100644
--- a/dvb-t/gr-Athens
+++ b/dvb-t/gr-Athens
@@ -1,5 +1,4 @@
 # Initial scan config for Digital DVB-T (Ert) in Athens Greece
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Digea DVB-T]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/hk-HongKong b/dvb-t/hk-HongKong
index db0b5b4..1e2d136 100644
--- a/dvb-t/hk-HongKong
+++ b/dvb-t/hk-HongKong
@@ -1,5 +1,4 @@
 # Hong Kong (DMB-TH)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # TVB (band 35)
 [CHANNEL]
diff --git a/dvb-t/hr-All b/dvb-t/hr-All
index 50c644a..2919099 100644
--- a/dvb-t/hr-All
+++ b/dvb-t/hr-All
@@ -1,7 +1,6 @@
 # Croatia, whole country
 # Created from http://www.oiv.hr/broadcasting/tables/dtv_hr.aspx
 # and from http://www.oiv.hr/broadcasting/tables/dtv_channel_hr.aspx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [D1 MUXD]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/hu-Bekescsaba b/dvb-t/hu-Bekescsaba
index adfb3e7..dac2e7b 100644
--- a/dvb-t/hu-Bekescsaba
+++ b/dvb-t/hu-Bekescsaba
@@ -1,5 +1,4 @@
 # Hungary / Bekescsaba
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-38:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Budapest b/dvb-t/hu-Budapest
index 1147daa..b4c17b3 100644
--- a/dvb-t/hu-Budapest
+++ b/dvb-t/hu-Budapest
@@ -1,5 +1,4 @@
 # Hungary / Budapest
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-38:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Csavoly-Kiskoros b/dvb-t/hu-Csavoly-Kiskoros
index 50eb531..9b88371 100644
--- a/dvb-t/hu-Csavoly-Kiskoros
+++ b/dvb-t/hu-Csavoly-Kiskoros
@@ -1,5 +1,4 @@
 # Hungary / Csavoly-Kiskoros
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-45:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Debrecen-Komadi b/dvb-t/hu-Debrecen-Komadi
index e347c17..7395939 100644
--- a/dvb-t/hu-Debrecen-Komadi
+++ b/dvb-t/hu-Debrecen-Komadi
@@ -1,5 +1,4 @@
 # Hungary / Debrecen-Komadi
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-46:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Fehergyarmat b/dvb-t/hu-Fehergyarmat
index 67c282b..dbfdda0 100644
--- a/dvb-t/hu-Fehergyarmat
+++ b/dvb-t/hu-Fehergyarmat
@@ -1,5 +1,4 @@
 # Hungary / Fehergyarmat
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-58:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Gerecse-Dorog-Tatabanya b/dvb-t/hu-Gerecse-Dorog-Tatabanya
index f68e34e..1a14795 100644
--- a/dvb-t/hu-Gerecse-Dorog-Tatabanya
+++ b/dvb-t/hu-Gerecse-Dorog-Tatabanya
@@ -1,5 +1,4 @@
 # Hungary / Gerecse-Dorog-Tatabanya
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-64:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Gyor b/dvb-t/hu-Gyor
index 76208cd..5ecd59c 100644
--- a/dvb-t/hu-Gyor
+++ b/dvb-t/hu-Gyor
@@ -1,5 +1,4 @@
 # Hungary / Gyor
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-42:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Kabhegy-Kaposvar-Tamasi b/dvb-t/hu-Kabhegy-Kaposvar-Tamasi
index a50563e..6c5cbfe 100644
--- a/dvb-t/hu-Kabhegy-Kaposvar-Tamasi
+++ b/dvb-t/hu-Kabhegy-Kaposvar-Tamasi
@@ -1,5 +1,4 @@
 # Hungary / Kabhegy-Kaposvar-Tamasi
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-64:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac b/dvb-t/hu-Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac
index 89fddb8..2b2cab5 100644
--- a/dvb-t/hu-Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac
+++ b/dvb-t/hu-Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac
@@ -1,5 +1,4 @@
 # Hungary / Karancs-Nagy-Hideg-hegy-Balassagyarmat-Godollo-Salgotarjan-Vac
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-38:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Karcag b/dvb-t/hu-Karcag
index eeefb7b..ae6390a 100644
--- a/dvb-t/hu-Karcag
+++ b/dvb-t/hu-Karcag
@@ -1,5 +1,4 @@
 # Hungary / Karcag
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-46:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Kecskemet b/dvb-t/hu-Kecskemet
index 29b3d5e..cf9ffad 100644
--- a/dvb-t/hu-Kecskemet
+++ b/dvb-t/hu-Kecskemet
@@ -1,5 +1,4 @@
 # Hungary / Kecskemet
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-56:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd b/dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd
index c635d67..58afcd9 100644
--- a/dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd
+++ b/dvb-t/hu-Kekes-Cegled-Eger-Miskolctapolca-Ozd
@@ -1,5 +1,4 @@
 # Hungary / Kekes-Cegled-Miskolctapolca
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-44:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Miskolc-Aggtelek-Fony b/dvb-t/hu-Miskolc-Aggtelek-Fony
index 06a7a0c..361ac5a 100644
--- a/dvb-t/hu-Miskolc-Aggtelek-Fony
+++ b/dvb-t/hu-Miskolc-Aggtelek-Fony
@@ -1,5 +1,4 @@
 # Hungary / Miskolc-Aggtelek-Fony
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-45:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Mor-Siofok-Veszprem-Zirc b/dvb-t/hu-Mor-Siofok-Veszprem-Zirc
index e6614db..cc2e32a 100644
--- a/dvb-t/hu-Mor-Siofok-Veszprem-Zirc
+++ b/dvb-t/hu-Mor-Siofok-Veszprem-Zirc
@@ -1,5 +1,4 @@
 # Hungary / Mor-Siofok-Veszprem-Zirc
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-64:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Nagykanizsa-Barcs-Keszthely b/dvb-t/hu-Nagykanizsa-Barcs-Keszthely
index 093627e..ce0ee07 100644
--- a/dvb-t/hu-Nagykanizsa-Barcs-Keszthely
+++ b/dvb-t/hu-Nagykanizsa-Barcs-Keszthely
@@ -1,5 +1,4 @@
 # Hungary / Nagykanizsa-Barcs-Keszthely
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-24:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Nyiregyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely b/dvb-t/hu-Nyiregyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely
index 38f26ad..03f8e96 100644
--- a/dvb-t/hu-Nyiregyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely
+++ b/dvb-t/hu-Nyiregyhaza-Tokaj-Kazincbarcika-Saly-Satoraljaujhely
@@ -1,5 +1,4 @@
 # Hungary / Ny�regyhaza-Tokaj-Kzincbarcika-Saly-Satoraljaujhely
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-68:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Pecs-Siklos b/dvb-t/hu-Pecs-Siklos
index c36e4b6..b5497c8 100644
--- a/dvb-t/hu-Pecs-Siklos
+++ b/dvb-t/hu-Pecs-Siklos
@@ -1,5 +1,4 @@
 # Hungary / Pecs-Siklos
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-52:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Sopron-Koszeg b/dvb-t/hu-Sopron-Koszeg
index a1e6afb..4a9b080 100644
--- a/dvb-t/hu-Sopron-Koszeg
+++ b/dvb-t/hu-Sopron-Koszeg
@@ -1,5 +1,4 @@
 # Hungary / Sopron-Koszeg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-42:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Szeged b/dvb-t/hu-Szeged
index 8e3d955..5fa2aa1 100644
--- a/dvb-t/hu-Szeged
+++ b/dvb-t/hu-Szeged
@@ -1,5 +1,4 @@
 # Hungary / Szeged
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-60:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Szekesfehervar b/dvb-t/hu-Szekesfehervar
index bdacbba..69b2162 100644
--- a/dvb-t/hu-Szekesfehervar
+++ b/dvb-t/hu-Szekesfehervar
@@ -1,5 +1,4 @@
 # Hungary / Szekesfehervar
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-30:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Szentes-Battonya b/dvb-t/hu-Szentes-Battonya
index f7647e5..c4f756a 100644
--- a/dvb-t/hu-Szentes-Battonya
+++ b/dvb-t/hu-Szentes-Battonya
@@ -1,5 +1,4 @@
 # Hungary / Szentes-Battonya
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-60:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Szolnok b/dvb-t/hu-Szolnok
index 1a0f6a1..1f371e0 100644
--- a/dvb-t/hu-Szolnok
+++ b/dvb-t/hu-Szolnok
@@ -1,5 +1,4 @@
 # Hungary / Szolnok
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-56:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg b/dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg
index 12dc414..5877b4c 100644
--- a/dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg
+++ b/dvb-t/hu-Szombathely-Vasvar-Lenti-Zalaegerszeg
@@ -1,5 +1,4 @@
 # Hungary / Szombathely-Vasvar-Lenti-Zalaegerszeg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-38:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar b/dvb-t/hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar
index dfad17d..78075e4 100644
--- a/dvb-t/hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar
+++ b/dvb-t/hu-Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar
@@ -1,5 +1,4 @@
 # Hungary / Uzd-Bonyhad-Dunaujvaros-Szekszard-Szigetvar
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 #
 # A.multiplex UHF-52:
 # FREE -----------------------------------------------------------------------------------
diff --git a/dvb-t/ie-CairnHill b/dvb-t/ie-CairnHill
index d8024b4..d3a5dc5 100644
--- a/dvb-t/ie-CairnHill
+++ b/dvb-t/ie-CairnHill
@@ -1,6 +1,5 @@
 # Ireland, Cairn Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH47: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/ie-ClermontCarn b/dvb-t/ie-ClermontCarn
index 4ff062f..81f17d2 100644
--- a/dvb-t/ie-ClermontCarn
+++ b/dvb-t/ie-ClermontCarn
@@ -1,6 +1,5 @@
 # Ireland, Clermont Carn
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH52: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 722000000
diff --git a/dvb-t/ie-Dungarvan b/dvb-t/ie-Dungarvan
index 53825b8..1c2ccd8 100644
--- a/dvb-t/ie-Dungarvan
+++ b/dvb-t/ie-Dungarvan
@@ -1,6 +1,5 @@
 # Ireland, Dungarvan
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH55: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/ie-HolywellHill b/dvb-t/ie-HolywellHill
index e9f1295..5bb2c58 100644
--- a/dvb-t/ie-HolywellHill
+++ b/dvb-t/ie-HolywellHill
@@ -1,6 +1,5 @@
 # Ireland, Holywell Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH30: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/ie-Kippure b/dvb-t/ie-Kippure
index 4d2a94b..8a7a3be 100644
--- a/dvb-t/ie-Kippure
+++ b/dvb-t/ie-Kippure
@@ -1,6 +1,5 @@
 # Ireland, Kippure
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH54: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
diff --git a/dvb-t/ie-Maghera b/dvb-t/ie-Maghera
index 6840992..e87acd9 100644
--- a/dvb-t/ie-Maghera
+++ b/dvb-t/ie-Maghera
@@ -1,6 +1,5 @@
 # Ireland, Maghera
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH48: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 690000000
diff --git a/dvb-t/ie-MountLeinster b/dvb-t/ie-MountLeinster
index 2e53b6c..60430a2 100644
--- a/dvb-t/ie-MountLeinster
+++ b/dvb-t/ie-MountLeinster
@@ -1,6 +1,5 @@
 # Ireland, Mount Leinster
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH23: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/ie-Mullaghanish b/dvb-t/ie-Mullaghanish
index 64c923f..9eb7ceb 100644
--- a/dvb-t/ie-Mullaghanish
+++ b/dvb-t/ie-Mullaghanish
@@ -1,6 +1,5 @@
 # Ireland, Mullaghanish
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH21: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/ie-SpurHill b/dvb-t/ie-SpurHill
index b195c57..96782fe 100644
--- a/dvb-t/ie-SpurHill
+++ b/dvb-t/ie-SpurHill
@@ -1,6 +1,5 @@
 # Ireland, Spur Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH45: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/ie-ThreeRock b/dvb-t/ie-ThreeRock
index 4baef48..7df648e 100644
--- a/dvb-t/ie-ThreeRock
+++ b/dvb-t/ie-ThreeRock
@@ -1,6 +1,5 @@
 # Ireland, Three Rock
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH30: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/ie-Truskmore b/dvb-t/ie-Truskmore
index c069606..838429c 100644
--- a/dvb-t/ie-Truskmore
+++ b/dvb-t/ie-Truskmore
@@ -1,6 +1,5 @@
 # Ireland, Truskmore
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH53: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/ie-WoodcockHill b/dvb-t/ie-WoodcockHill
index 18dfc23..065e6fc 100644
--- a/dvb-t/ie-WoodcockHill
+++ b/dvb-t/ie-WoodcockHill
@@ -1,6 +1,5 @@
 # Ireland, Woodcock Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CH47: Saorview MUX1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/il-All b/dvb-t/il-All
index 99fd432..14e2b5d 100644
--- a/dvb-t/il-All
+++ b/dvb-t/il-All
@@ -1,6 +1,5 @@
 # Israel, Israel Broadcasting Authority's transmitters
 # Generated from list in http://www.iba.org.il/reception/
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/ir-Tehran b/dvb-t/ir-Tehran
index 357a595..9c28a77 100644
--- a/dvb-t/ir-Tehran
+++ b/dvb-t/ir-Tehran
@@ -1,5 +1,4 @@
 # DVB-T Tehran
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [IRIB-TV1/2/3/4/5, IRINN, AMOUZESH, QURAN-TV]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/is-Reykjavik b/dvb-t/is-Reykjavik
index c61f451..c898a6b 100644
--- a/dvb-t/is-Reykjavik
+++ b/dvb-t/is-Reykjavik
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2010-10-22
 # provided by (opt)    : <your name or email here>
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/it-All b/dvb-t/it-All
index 4ded812..c41cac3 100644
--- a/dvb-t/it-All
+++ b/dvb-t/it-All
@@ -12,7 +12,6 @@
 # http://en.wikipedia.org/wiki/File:VHF_Usage.svg
 # http://en.wikipedia.org/wiki/Television_channel_frequencies
 
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 ### VHF - Band III ###
 # 5
diff --git a/dvb-t/lu-All b/dvb-t/lu-All
index dad588b..4e8053f 100644
--- a/dvb-t/lu-All
+++ b/dvb-t/lu-All
@@ -1,5 +1,4 @@
 # DVB-T Luxembourg [2007-11-18]
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Kanal 7   M6, RTL 8, LUXE.TV]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 191500000
diff --git a/dvb-t/lv-Riga b/dvb-t/lv-Riga
index 26aa03a..bfb2e37 100644
--- a/dvb-t/lv-Riga
+++ b/dvb-t/lv-Riga
@@ -2,7 +2,6 @@
 # Generated by Raimonds Cicans
 # UTF8 encoding
 
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # DLRTC
 [Weak signal! Vājš signāls! Слабый сигнал!]
diff --git a/dvb-t/nl-All b/dvb-t/nl-All
index 612ebdf..33fccd3 100644
--- a/dvb-t/nl-All
+++ b/dvb-t/nl-All
@@ -1,7 +1,6 @@
 # The Netherlands, whole country
 # Created from http://radio-tv-nederland.nl/TV       1.251978e-312nderlijst%20Nederland.xls
 # and http://radio-tv-nederland.nl/dvbt/dvbt-lokaal.html
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/no-Trondelag_Stjordal b/dvb-t/no-Trondelag_Stjordal
index c77f43b..f6d8997 100644
--- a/dvb-t/no-Trondelag_Stjordal
+++ b/dvb-t/no-Trondelag_Stjordal
@@ -1,7 +1,6 @@
 # Norway / Trondelag / Stjordal
 # modified according to data automatically generated by w_scan
 # free (nrk) channels are on 658000000
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/nz-AucklandInfill b/dvb-t/nz-AucklandInfill
index 5274612..dc05f0c 100644
--- a/dvb-t/nz-AucklandInfill
+++ b/dvb-t/nz-AucklandInfill
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-AucklandWaiatarua b/dvb-t/nz-AucklandWaiatarua
index 6172cb6..4fbeb87 100644
--- a/dvb-t/nz-AucklandWaiatarua
+++ b/dvb-t/nz-AucklandWaiatarua
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Christchurch b/dvb-t/nz-Christchurch
index b569574..242c186 100644
--- a/dvb-t/nz-Christchurch
+++ b/dvb-t/nz-Christchurch
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Dunedin b/dvb-t/nz-Dunedin
index d3f5764..440449a 100644
--- a/dvb-t/nz-Dunedin
+++ b/dvb-t/nz-Dunedin
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Hamilton b/dvb-t/nz-Hamilton
index 69cd706..eeb5b41 100644
--- a/dvb-t/nz-Hamilton
+++ b/dvb-t/nz-Hamilton
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-HawkesBayMtErin b/dvb-t/nz-HawkesBayMtErin
index 9afa464..6b6cee1 100644
--- a/dvb-t/nz-HawkesBayMtErin
+++ b/dvb-t/nz-HawkesBayMtErin
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-HawkesBayNapier b/dvb-t/nz-HawkesBayNapier
index edda0e3..0941b83 100644
--- a/dvb-t/nz-HawkesBayNapier
+++ b/dvb-t/nz-HawkesBayNapier
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Manawatu b/dvb-t/nz-Manawatu
index 91953ca..9c01304 100644
--- a/dvb-t/nz-Manawatu
+++ b/dvb-t/nz-Manawatu
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Tauranga b/dvb-t/nz-Tauranga
index 063f0d8..3b30c5e 100644
--- a/dvb-t/nz-Tauranga
+++ b/dvb-t/nz-Tauranga
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-Waikato b/dvb-t/nz-Waikato
index 11ddbfb..d88cea6 100644
--- a/dvb-t/nz-Waikato
+++ b/dvb-t/nz-Waikato
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-WellingtonInfill b/dvb-t/nz-WellingtonInfill
index b96bd16..63d4871 100644
--- a/dvb-t/nz-WellingtonInfill
+++ b/dvb-t/nz-WellingtonInfill
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-WellingtonKaukau b/dvb-t/nz-WellingtonKaukau
index 20d89fd..9111f1a 100644
--- a/dvb-t/nz-WellingtonKaukau
+++ b/dvb-t/nz-WellingtonKaukau
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/nz-WellingtonNgarara b/dvb-t/nz-WellingtonNgarara
index 8dc1c47..27d920c 100644
--- a/dvb-t/nz-WellingtonNgarara
+++ b/dvb-t/nz-WellingtonNgarara
@@ -3,7 +3,6 @@
 # Channel allocation details for NZ can be found at
 # http://en.wikipedia.org/wiki/Freeview_(New_Zealand)
 #
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/pl-Czestochowa b/dvb-t/pl-Czestochowa
index 06b047b..e24f5f6 100644
--- a/dvb-t/pl-Czestochowa
+++ b/dvb-t/pl-Czestochowa
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2012-11-30
 # provided by (opt)    : Jakub Kasprzycki jakub@kasprzycki.name
 #
-# T[2] [plp_id] [system_id] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [MUX-1 Emitel Wreczyca 100KW H]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/pl-Gdansk b/dvb-t/pl-Gdansk
index 1f7d3b4..6ff18cb 100644
--- a/dvb-t/pl-Gdansk
+++ b/dvb-t/pl-Gdansk
@@ -1,5 +1,4 @@
 # Gdańsk, Poland
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/pl-Krakow b/dvb-t/pl-Krakow
index 461debc..12b164f 100644
--- a/dvb-t/pl-Krakow
+++ b/dvb-t/pl-Krakow
@@ -7,7 +7,6 @@
 # date (yyyy-mm-dd)    : 2011-10-29
 # provided by (opt)    : Damian Golda
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
 #------------------------------------------------------------------------------
 [Ch.23, Mux2 Tarnow/g.Sw.Marcina]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/pl-Rzeszow b/dvb-t/pl-Rzeszow
index d012c7b..1991878 100644
--- a/dvb-t/pl-Rzeszow
+++ b/dvb-t/pl-Rzeszow
@@ -1,5 +1,4 @@
 # Rzeszow / Sucha Gora, South-East Poland
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/pl-Wroclaw b/dvb-t/pl-Wroclaw
index 87abc20..cffbe7f 100644
--- a/dvb-t/pl-Wroclaw
+++ b/dvb-t/pl-Wroclaw
@@ -1,5 +1,4 @@
 # Wroclaw / Zorawina, South-West Poland
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/pt-All b/dvb-t/pt-All
index d8fde37..119e4db 100644
--- a/dvb-t/pt-All
+++ b/dvb-t/pt-All
@@ -1,5 +1,4 @@
 # Generated from http://tdt-portugal.blogspot.pt/
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Monte da Virgem]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/ro-Bucharest b/dvb-t/ro-Bucharest
index 77d182c..e2427ce 100644
--- a/dvb-t/ro-Bucharest
+++ b/dvb-t/ro-Bucharest
@@ -1,5 +1,4 @@
 # Romania / Bucharest
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/ru-Krasnodar b/dvb-t/ru-Krasnodar
index c1d6b10..c434a35 100644
--- a/dvb-t/ru-Krasnodar
+++ b/dvb-t/ru-Krasnodar
@@ -1,5 +1,4 @@
 # Russia, Krasnodar
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 618000000
diff --git a/dvb-t/ru-Novosibirsk b/dvb-t/ru-Novosibirsk
index c6d1ca9..56e9e9d 100644
--- a/dvb-t/ru-Novosibirsk
+++ b/dvb-t/ru-Novosibirsk
@@ -1,5 +1,4 @@
 # Russia, Novosibirsk
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 530000000
diff --git a/dvb-t/ru-Volgodonsk b/dvb-t/ru-Volgodonsk
index 6978e0a..54b8674 100644
--- a/dvb-t/ru-Volgodonsk
+++ b/dvb-t/ru-Volgodonsk
@@ -1,5 +1,4 @@
 # Russia, Volgodonsk
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 650000000
diff --git a/dvb-t/se-Alvdalen_Brunnsberg b/dvb-t/se-Alvdalen_Brunnsberg
index 192ceb0..4f1b825 100644
--- a/dvb-t/se-Alvdalen_Brunnsberg
+++ b/dvb-t/se-Alvdalen_Brunnsberg
@@ -1,5 +1,4 @@
 # Sweden - Älvdalen/Brunnsberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/se-Alvdalsasen b/dvb-t/se-Alvdalsasen
index 52c89ff..1561589 100644
--- a/dvb-t/se-Alvdalsasen
+++ b/dvb-t/se-Alvdalsasen
@@ -1,5 +1,4 @@
 # Sweden - Älvdalsåsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/se-Alvsbyn b/dvb-t/se-Alvsbyn
index 9040ac5..b13bc05 100644
--- a/dvb-t/se-Alvsbyn
+++ b/dvb-t/se-Alvsbyn
@@ -1,5 +1,4 @@
 # Sweden - Älvsbyn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Amot b/dvb-t/se-Amot
index 240992e..36697b7 100644
--- a/dvb-t/se-Amot
+++ b/dvb-t/se-Amot
@@ -1,5 +1,4 @@
 # Sweden - Åmot
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Ange_Snoberg b/dvb-t/se-Ange_Snoberg
index 25d14c6..552297e 100644
--- a/dvb-t/se-Ange_Snoberg
+++ b/dvb-t/se-Ange_Snoberg
@@ -1,5 +1,4 @@
 # Sweden - Ånge/Snöberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Angebo b/dvb-t/se-Angebo
index 005f250..8b71a83 100644
--- a/dvb-t/se-Angebo
+++ b/dvb-t/se-Angebo
@@ -1,5 +1,4 @@
 # Sweden - Ängebo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 802000000
diff --git a/dvb-t/se-Angelholm_Vegeholm b/dvb-t/se-Angelholm_Vegeholm
index b5de978..0fcd383 100644
--- a/dvb-t/se-Angelholm_Vegeholm
+++ b/dvb-t/se-Angelholm_Vegeholm
@@ -1,5 +1,4 @@
 # Sweden - Ängelholm/Vegeholm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Arvidsjaur_Jultrask b/dvb-t/se-Arvidsjaur_Jultrask
index 16d1829..465abba 100644
--- a/dvb-t/se-Arvidsjaur_Jultrask
+++ b/dvb-t/se-Arvidsjaur_Jultrask
@@ -1,5 +1,4 @@
 # Sweden - Arvidsjaur/Julträsk
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 578000000
diff --git a/dvb-t/se-Aspeboda b/dvb-t/se-Aspeboda
index b534a08..5ca5003 100644
--- a/dvb-t/se-Aspeboda
+++ b/dvb-t/se-Aspeboda
@@ -1,5 +1,4 @@
 # Sweden - Aspeboda
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Atvidaberg b/dvb-t/se-Atvidaberg
index a72b224..f67a6d9 100644
--- a/dvb-t/se-Atvidaberg
+++ b/dvb-t/se-Atvidaberg
@@ -1,5 +1,4 @@
 # Sweden - Åtvidaberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Avesta_Krylbo b/dvb-t/se-Avesta_Krylbo
index f092d43..42eeaa4 100644
--- a/dvb-t/se-Avesta_Krylbo
+++ b/dvb-t/se-Avesta_Krylbo
@@ -1,5 +1,4 @@
 # Sweden - Avesta/Krylbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/se-Backefors b/dvb-t/se-Backefors
index 2ebbbaf..5a99a5d 100644
--- a/dvb-t/se-Backefors
+++ b/dvb-t/se-Backefors
@@ -1,5 +1,4 @@
 # Sweden - Bäckefors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 586000000
diff --git a/dvb-t/se-Bankeryd b/dvb-t/se-Bankeryd
index f4179a3..d0443b4 100644
--- a/dvb-t/se-Bankeryd
+++ b/dvb-t/se-Bankeryd
@@ -1,5 +1,4 @@
 # Sweden - Bankeryd
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Bergsjo_Balleberget b/dvb-t/se-Bergsjo_Balleberget
index 53a8eae..f4c8c33 100644
--- a/dvb-t/se-Bergsjo_Balleberget
+++ b/dvb-t/se-Bergsjo_Balleberget
@@ -1,5 +1,4 @@
 # Sweden - Bergsjö/Bålleberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 690000000
diff --git a/dvb-t/se-Bergvik b/dvb-t/se-Bergvik
index 1ae0962..d1ac6bf 100644
--- a/dvb-t/se-Bergvik
+++ b/dvb-t/se-Bergvik
@@ -1,5 +1,4 @@
 # Sweden - Bergvik
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/se-Bollebygd b/dvb-t/se-Bollebygd
index ac6ae37..4c841f4 100644
--- a/dvb-t/se-Bollebygd
+++ b/dvb-t/se-Bollebygd
@@ -1,5 +1,4 @@
 # Sweden - Bollebygd
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 578000000
diff --git a/dvb-t/se-Bollnas b/dvb-t/se-Bollnas
index f7f8f53..973a9c6 100644
--- a/dvb-t/se-Bollnas
+++ b/dvb-t/se-Bollnas
@@ -1,5 +1,4 @@
 # Sweden - Bollnäs
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
diff --git a/dvb-t/se-Boras_Dalsjofors b/dvb-t/se-Boras_Dalsjofors
index a53b40c..3b4b9db 100644
--- a/dvb-t/se-Boras_Dalsjofors
+++ b/dvb-t/se-Boras_Dalsjofors
@@ -1,5 +1,4 @@
 # Sweden - Borås/Dalsjöfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/se-Boras_Sjobo b/dvb-t/se-Boras_Sjobo
index 3dd1a5e..5ae7fd0 100644
--- a/dvb-t/se-Boras_Sjobo
+++ b/dvb-t/se-Boras_Sjobo
@@ -1,5 +1,4 @@
 # Sweden - Borås/Sjöbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Borlange_Idkerberget b/dvb-t/se-Borlange_Idkerberget
index 5f8ef45..b70f761 100644
--- a/dvb-t/se-Borlange_Idkerberget
+++ b/dvb-t/se-Borlange_Idkerberget
@@ -1,5 +1,4 @@
 # Sweden - Borlänge/Idkerberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/se-Borlange_Nygardarna b/dvb-t/se-Borlange_Nygardarna
index a49f18b..0307e5a 100644
--- a/dvb-t/se-Borlange_Nygardarna
+++ b/dvb-t/se-Borlange_Nygardarna
@@ -1,5 +1,4 @@
 # Sweden - Borlänge/Nygårdarna
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Bottnaryd_Ryd b/dvb-t/se-Bottnaryd_Ryd
index 2bb99ec..a29e54f 100644
--- a/dvb-t/se-Bottnaryd_Ryd
+++ b/dvb-t/se-Bottnaryd_Ryd
@@ -1,5 +1,4 @@
 # Sweden - Bottnaryd/Ryd
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Bromsebro b/dvb-t/se-Bromsebro
index 4017ffb..eb55783 100644
--- a/dvb-t/se-Bromsebro
+++ b/dvb-t/se-Bromsebro
@@ -1,5 +1,4 @@
 # Sweden - Brömsebro
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Bruzaholm b/dvb-t/se-Bruzaholm
index 12ad504..45caddd 100644
--- a/dvb-t/se-Bruzaholm
+++ b/dvb-t/se-Bruzaholm
@@ -1,5 +1,4 @@
 # Sweden - Bruzaholm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/se-Byxelkrok b/dvb-t/se-Byxelkrok
index 894800c..abff541 100644
--- a/dvb-t/se-Byxelkrok
+++ b/dvb-t/se-Byxelkrok
@@ -1,5 +1,4 @@
 # Sweden - Byxelkrok
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Dadran b/dvb-t/se-Dadran
index 8550d04..a9733eb 100644
--- a/dvb-t/se-Dadran
+++ b/dvb-t/se-Dadran
@@ -1,5 +1,4 @@
 # Sweden - Dådran
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Dalfors b/dvb-t/se-Dalfors
index fd562b9..57ae1d3 100644
--- a/dvb-t/se-Dalfors
+++ b/dvb-t/se-Dalfors
@@ -1,5 +1,4 @@
 # Sweden - Dalfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Dalstuga b/dvb-t/se-Dalstuga
index 97ab8ec..328496a 100644
--- a/dvb-t/se-Dalstuga
+++ b/dvb-t/se-Dalstuga
@@ -1,5 +1,4 @@
 # Sweden - Dalstuga
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Degerfors b/dvb-t/se-Degerfors
index 3675378..b8d16e6 100644
--- a/dvb-t/se-Degerfors
+++ b/dvb-t/se-Degerfors
@@ -1,5 +1,4 @@
 # Sweden - Degerfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/se-Delary b/dvb-t/se-Delary
index 5bf8b6e..e62500a 100644
--- a/dvb-t/se-Delary
+++ b/dvb-t/se-Delary
@@ -1,5 +1,4 @@
 # Sweden - Delary
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Djura b/dvb-t/se-Djura
index c05429c..020a4d4 100644
--- a/dvb-t/se-Djura
+++ b/dvb-t/se-Djura
@@ -1,5 +1,4 @@
 # Sweden - Djura
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Drevdagen b/dvb-t/se-Drevdagen
index 66fbde9..e2c9da3 100644
--- a/dvb-t/se-Drevdagen
+++ b/dvb-t/se-Drevdagen
@@ -1,5 +1,4 @@
 # Sweden - Drevdagen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/se-Duvnas b/dvb-t/se-Duvnas
index c5e0edb..33aaf97 100644
--- a/dvb-t/se-Duvnas
+++ b/dvb-t/se-Duvnas
@@ -1,5 +1,4 @@
 # Sweden - Duvnäs
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
diff --git a/dvb-t/se-Duvnas_Basna b/dvb-t/se-Duvnas_Basna
index b1cde35..de5ec55 100644
--- a/dvb-t/se-Duvnas_Basna
+++ b/dvb-t/se-Duvnas_Basna
@@ -1,5 +1,4 @@
 # Sweden - Duvnäs/Bäsna
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Edsbyn b/dvb-t/se-Edsbyn
index 7236176..f92440f 100644
--- a/dvb-t/se-Edsbyn
+++ b/dvb-t/se-Edsbyn
@@ -1,5 +1,4 @@
 # Sweden - Edsbyn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Emmaboda_Balshult b/dvb-t/se-Emmaboda_Balshult
index 90dea6d..512c69d 100644
--- a/dvb-t/se-Emmaboda_Balshult
+++ b/dvb-t/se-Emmaboda_Balshult
@@ -1,5 +1,4 @@
 # Sweden - Emmaboda/Bälshult
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Enviken b/dvb-t/se-Enviken
index d99e211..c36079c 100644
--- a/dvb-t/se-Enviken
+++ b/dvb-t/se-Enviken
@@ -1,5 +1,4 @@
 # Sweden - Enviken
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/se-Fagersta b/dvb-t/se-Fagersta
index 84d2c08..3201b34 100644
--- a/dvb-t/se-Fagersta
+++ b/dvb-t/se-Fagersta
@@ -1,5 +1,4 @@
 # Sweden - Fagersta
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Falerum_Centrum b/dvb-t/se-Falerum_Centrum
index 60ce0f8..716f262 100644
--- a/dvb-t/se-Falerum_Centrum
+++ b/dvb-t/se-Falerum_Centrum
@@ -1,5 +1,4 @@
 # Sweden - Falerum/Centrum
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/se-Falun_Lovberget b/dvb-t/se-Falun_Lovberget
index 94461e0..478b9c1 100644
--- a/dvb-t/se-Falun_Lovberget
+++ b/dvb-t/se-Falun_Lovberget
@@ -1,5 +1,4 @@
 # Sweden - Falun/Lövberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/se-Farila b/dvb-t/se-Farila
index 5773cfb..ead5163 100644
--- a/dvb-t/se-Farila
+++ b/dvb-t/se-Farila
@@ -1,5 +1,4 @@
 # Sweden - Färila
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/se-Faro_Ajkerstrask b/dvb-t/se-Faro_Ajkerstrask
index 782c5ec..f3f2652 100644
--- a/dvb-t/se-Faro_Ajkerstrask
+++ b/dvb-t/se-Faro_Ajkerstrask
@@ -1,5 +1,4 @@
 # Sweden - Fårö/Ajkersträsk
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Farosund_Bunge b/dvb-t/se-Farosund_Bunge
index 74b9ca7..2af8971 100644
--- a/dvb-t/se-Farosund_Bunge
+++ b/dvb-t/se-Farosund_Bunge
@@ -1,5 +1,4 @@
 # Sweden - Fårösund/Bunge
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Filipstad_Klockarhojden b/dvb-t/se-Filipstad_Klockarhojden
index 1e50e2f..a861d0a 100644
--- a/dvb-t/se-Filipstad_Klockarhojden
+++ b/dvb-t/se-Filipstad_Klockarhojden
@@ -1,5 +1,4 @@
 # Sweden - Filipstad/Klockarhöjden
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Finnveden b/dvb-t/se-Finnveden
index e3aa235..98cf8df 100644
--- a/dvb-t/se-Finnveden
+++ b/dvb-t/se-Finnveden
@@ -1,5 +1,4 @@
 # Sweden - Finnveden
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Fredriksberg b/dvb-t/se-Fredriksberg
index d4474c2..038defe 100644
--- a/dvb-t/se-Fredriksberg
+++ b/dvb-t/se-Fredriksberg
@@ -1,5 +1,4 @@
 # Sweden - Fredriksberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Fritsla b/dvb-t/se-Fritsla
index 32516b3..124e763 100644
--- a/dvb-t/se-Fritsla
+++ b/dvb-t/se-Fritsla
@@ -1,5 +1,4 @@
 # Sweden - Fritsla
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Furudal b/dvb-t/se-Furudal
index 940df8d..92d0817 100644
--- a/dvb-t/se-Furudal
+++ b/dvb-t/se-Furudal
@@ -1,5 +1,4 @@
 # Sweden - Furudal
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Gallivare b/dvb-t/se-Gallivare
index 3945775..35eeb5b 100644
--- a/dvb-t/se-Gallivare
+++ b/dvb-t/se-Gallivare
@@ -1,5 +1,4 @@
 # Sweden - Gällivare
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Garpenberg_Kuppgarden b/dvb-t/se-Garpenberg_Kuppgarden
index cd6ce33..9dc790e 100644
--- a/dvb-t/se-Garpenberg_Kuppgarden
+++ b/dvb-t/se-Garpenberg_Kuppgarden
@@ -1,5 +1,4 @@
 # Sweden - Garpenberg/Kuppgården
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Gavle_Skogmur b/dvb-t/se-Gavle_Skogmur
index ce4ca34..556acd8 100644
--- a/dvb-t/se-Gavle_Skogmur
+++ b/dvb-t/se-Gavle_Skogmur
@@ -1,5 +1,4 @@
 # Sweden - Gävle/Skogmur
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/se-Gnarp b/dvb-t/se-Gnarp
index f2ce7c6..04b461f 100644
--- a/dvb-t/se-Gnarp
+++ b/dvb-t/se-Gnarp
@@ -1,5 +1,4 @@
 # Sweden - Gnarp
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Gnesta b/dvb-t/se-Gnesta
index 6b9f192..5baf70e 100644
--- a/dvb-t/se-Gnesta
+++ b/dvb-t/se-Gnesta
@@ -1,5 +1,4 @@
 # Sweden - Gnesta
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/se-Gnosjo_Marieholm b/dvb-t/se-Gnosjo_Marieholm
index ea86a27..654c5ac 100644
--- a/dvb-t/se-Gnosjo_Marieholm
+++ b/dvb-t/se-Gnosjo_Marieholm
@@ -1,5 +1,4 @@
 # Sweden - Gnosjö/Marieholm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Goteborg_Brudaremossen b/dvb-t/se-Goteborg_Brudaremossen
index bc1004d..854d487 100644
--- a/dvb-t/se-Goteborg_Brudaremossen
+++ b/dvb-t/se-Goteborg_Brudaremossen
@@ -1,5 +1,4 @@
 # Sweden - Göteborg/Brudaremossen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Goteborg_Slattadamm b/dvb-t/se-Goteborg_Slattadamm
index 4a38249..843f90f 100644
--- a/dvb-t/se-Goteborg_Slattadamm
+++ b/dvb-t/se-Goteborg_Slattadamm
@@ -1,5 +1,4 @@
 # Sweden - Göteborg/Slättadamm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Gullbrandstorp b/dvb-t/se-Gullbrandstorp
index 27484df..f917134 100644
--- a/dvb-t/se-Gullbrandstorp
+++ b/dvb-t/se-Gullbrandstorp
@@ -1,5 +1,4 @@
 # Sweden - Gullbrandstorp
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Gunnarsbo b/dvb-t/se-Gunnarsbo
index 0c2b024..e951cde 100644
--- a/dvb-t/se-Gunnarsbo
+++ b/dvb-t/se-Gunnarsbo
@@ -1,5 +1,4 @@
 # Sweden - Gunnarsbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
diff --git a/dvb-t/se-Gusum b/dvb-t/se-Gusum
index 09917e5..faeeec6 100644
--- a/dvb-t/se-Gusum
+++ b/dvb-t/se-Gusum
@@ -1,5 +1,4 @@
 # Sweden - Gusum
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Hagfors_Varmullsasen b/dvb-t/se-Hagfors_Varmullsasen
index 387a4ae..02960ac 100644
--- a/dvb-t/se-Hagfors_Varmullsasen
+++ b/dvb-t/se-Hagfors_Varmullsasen
@@ -1,5 +1,4 @@
 # Sweden - Hagfors/Värmullsåsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Hallaryd b/dvb-t/se-Hallaryd
index 5d27850..d388227 100644
--- a/dvb-t/se-Hallaryd
+++ b/dvb-t/se-Hallaryd
@@ -1,5 +1,4 @@
 # Sweden - Hallaryd
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Hallbo b/dvb-t/se-Hallbo
index c56a2a6..68e60f4 100644
--- a/dvb-t/se-Hallbo
+++ b/dvb-t/se-Hallbo
@@ -1,5 +1,4 @@
 # Sweden - Hällbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Halmstad_Hamnen b/dvb-t/se-Halmstad_Hamnen
index 44caa31..32e3c27 100644
--- a/dvb-t/se-Halmstad_Hamnen
+++ b/dvb-t/se-Halmstad_Hamnen
@@ -1,5 +1,4 @@
 # Sweden - Halmstad/Hamnen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Halmstad_Oskarstrom b/dvb-t/se-Halmstad_Oskarstrom
index 5f6407c..2aba6c7 100644
--- a/dvb-t/se-Halmstad_Oskarstrom
+++ b/dvb-t/se-Halmstad_Oskarstrom
@@ -1,5 +1,4 @@
 # Sweden - Halmstad/Oskarström
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/se-Harnosand_Harnon b/dvb-t/se-Harnosand_Harnon
index 9820c48..8210753 100644
--- a/dvb-t/se-Harnosand_Harnon
+++ b/dvb-t/se-Harnosand_Harnon
@@ -1,5 +1,4 @@
 # Sweden - Härnösand/Härnön
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Hassela b/dvb-t/se-Hassela
index 688d90d..d9ee98a 100644
--- a/dvb-t/se-Hassela
+++ b/dvb-t/se-Hassela
@@ -1,5 +1,4 @@
 # Sweden - Hassela
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/se-Havdhem b/dvb-t/se-Havdhem
index 2d0e280..ba8f198 100644
--- a/dvb-t/se-Havdhem
+++ b/dvb-t/se-Havdhem
@@ -1,5 +1,4 @@
 # Sweden - Havdhem
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Hedemora b/dvb-t/se-Hedemora
index 4fd8e0c..ba6343d 100644
--- a/dvb-t/se-Hedemora
+++ b/dvb-t/se-Hedemora
@@ -1,5 +1,4 @@
 # Sweden - Hedemora
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Helsingborg_Olympia b/dvb-t/se-Helsingborg_Olympia
index 137dd5a..f7fc25c 100644
--- a/dvb-t/se-Helsingborg_Olympia
+++ b/dvb-t/se-Helsingborg_Olympia
@@ -1,5 +1,4 @@
 # Sweden - Helsingborg/Olympia
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Hennan b/dvb-t/se-Hennan
index 6ba3b61..37e78c7 100644
--- a/dvb-t/se-Hennan
+++ b/dvb-t/se-Hennan
@@ -1,5 +1,4 @@
 # Sweden - Hennan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Hestra_Aspas b/dvb-t/se-Hestra_Aspas
index 1ac2f38..f3a554a 100644
--- a/dvb-t/se-Hestra_Aspas
+++ b/dvb-t/se-Hestra_Aspas
@@ -1,5 +1,4 @@
 # Sweden - Hestra/Äspås
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/se-Hjo_Grevback b/dvb-t/se-Hjo_Grevback
index 1a3645f..5063c1f 100644
--- a/dvb-t/se-Hjo_Grevback
+++ b/dvb-t/se-Hjo_Grevback
@@ -1,5 +1,4 @@
 # Sweden - Hjo/Grevbäck
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Hofors b/dvb-t/se-Hofors
index f1f2948..8265081 100644
--- a/dvb-t/se-Hofors
+++ b/dvb-t/se-Hofors
@@ -1,5 +1,4 @@
 # Sweden - Hofors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/se-Hogfors b/dvb-t/se-Hogfors
index 6cc4686..197423f 100644
--- a/dvb-t/se-Hogfors
+++ b/dvb-t/se-Hogfors
@@ -1,5 +1,4 @@
 # Sweden - Högfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Hogsby_Virstad b/dvb-t/se-Hogsby_Virstad
index d1927b9..37f150a 100644
--- a/dvb-t/se-Hogsby_Virstad
+++ b/dvb-t/se-Hogsby_Virstad
@@ -1,5 +1,4 @@
 # Sweden - Högsby/Virstad
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Holsbybrunn_Holsbyholm b/dvb-t/se-Holsbybrunn_Holsbyholm
index bafa87b..d180051 100644
--- a/dvb-t/se-Holsbybrunn_Holsbyholm
+++ b/dvb-t/se-Holsbybrunn_Holsbyholm
@@ -1,5 +1,4 @@
 # Sweden - Holsbybrunn/Holsbyholm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/se-Horby_Sallerup b/dvb-t/se-Horby_Sallerup
index 8f6352f..3b99edb 100644
--- a/dvb-t/se-Horby_Sallerup
+++ b/dvb-t/se-Horby_Sallerup
@@ -1,5 +1,4 @@
 # Sweden - Hörby/Sallerup
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Horken b/dvb-t/se-Horken
index d43d9a1..d58ee6d 100644
--- a/dvb-t/se-Horken
+++ b/dvb-t/se-Horken
@@ -1,5 +1,4 @@
 # Sweden - Hörken
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Hudiksvall_Forsa b/dvb-t/se-Hudiksvall_Forsa
index b667c8b..9a9365f 100644
--- a/dvb-t/se-Hudiksvall_Forsa
+++ b/dvb-t/se-Hudiksvall_Forsa
@@ -1,5 +1,4 @@
 # Sweden - Hudiksvall/Forsa
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Hudiksvall_Galgberget b/dvb-t/se-Hudiksvall_Galgberget
index a70bcb3..e40b0ab 100644
--- a/dvb-t/se-Hudiksvall_Galgberget
+++ b/dvb-t/se-Hudiksvall_Galgberget
@@ -1,5 +1,4 @@
 # Sweden - Hudiksvall/Galgberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Huskvarna b/dvb-t/se-Huskvarna
index 4357054..eb500ab 100644
--- a/dvb-t/se-Huskvarna
+++ b/dvb-t/se-Huskvarna
@@ -1,5 +1,4 @@
 # Sweden - Huskvarna
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Idre b/dvb-t/se-Idre
index 6156d06..dc5ee02 100644
--- a/dvb-t/se-Idre
+++ b/dvb-t/se-Idre
@@ -1,5 +1,4 @@
 # Sweden - Idre
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
diff --git a/dvb-t/se-Ingatorp b/dvb-t/se-Ingatorp
index d075eb8..2b11888 100644
--- a/dvb-t/se-Ingatorp
+++ b/dvb-t/se-Ingatorp
@@ -1,5 +1,4 @@
 # Sweden - Ingatorp
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Ingvallsbenning b/dvb-t/se-Ingvallsbenning
index b000302..f8e7088 100644
--- a/dvb-t/se-Ingvallsbenning
+++ b/dvb-t/se-Ingvallsbenning
@@ -1,5 +1,4 @@
 # Sweden - Ingvallsbenning
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/se-Irevik b/dvb-t/se-Irevik
index 47853c9..9fa49d9 100644
--- a/dvb-t/se-Irevik
+++ b/dvb-t/se-Irevik
@@ -1,5 +1,4 @@
 # Sweden - Irevik
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Jamjo b/dvb-t/se-Jamjo
index 399fe96..dd1446f 100644
--- a/dvb-t/se-Jamjo
+++ b/dvb-t/se-Jamjo
@@ -1,5 +1,4 @@
 # Sweden - Jämjö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Jarnforsen b/dvb-t/se-Jarnforsen
index 258a47f..d163be1 100644
--- a/dvb-t/se-Jarnforsen
+++ b/dvb-t/se-Jarnforsen
@@ -1,5 +1,4 @@
 # Sweden - Järnforsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/se-Jarvso b/dvb-t/se-Jarvso
index 703d120..d5dcf62 100644
--- a/dvb-t/se-Jarvso
+++ b/dvb-t/se-Jarvso
@@ -1,5 +1,4 @@
 # Sweden - Järvsö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
diff --git a/dvb-t/se-Jokkmokk_Tjalmejaure b/dvb-t/se-Jokkmokk_Tjalmejaure
index 57398bf..75675aa 100644
--- a/dvb-t/se-Jokkmokk_Tjalmejaure
+++ b/dvb-t/se-Jokkmokk_Tjalmejaure
@@ -1,5 +1,4 @@
 # Sweden - Jokkmokk/Tjalmejaure
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 586000000
diff --git a/dvb-t/se-Jonkoping_Bondberget b/dvb-t/se-Jonkoping_Bondberget
index 73bccaa..067eaf0 100644
--- a/dvb-t/se-Jonkoping_Bondberget
+++ b/dvb-t/se-Jonkoping_Bondberget
@@ -1,5 +1,4 @@
 # Sweden - Jönköping/Bondberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Kalix b/dvb-t/se-Kalix
index dca9fe5..401a1d4 100644
--- a/dvb-t/se-Kalix
+++ b/dvb-t/se-Kalix
@@ -1,5 +1,4 @@
 # Sweden - Kalix
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Karbole b/dvb-t/se-Karbole
index 2619f75..f7340cc 100644
--- a/dvb-t/se-Karbole
+++ b/dvb-t/se-Karbole
@@ -1,5 +1,4 @@
 # Sweden - Kårböle
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/se-Karlsborg_Vaberget b/dvb-t/se-Karlsborg_Vaberget
index 05a38e4..dc1a6af 100644
--- a/dvb-t/se-Karlsborg_Vaberget
+++ b/dvb-t/se-Karlsborg_Vaberget
@@ -1,5 +1,4 @@
 # Sweden - Karlsborg/Vaberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Karlshamn b/dvb-t/se-Karlshamn
index b793edd..1acf751 100644
--- a/dvb-t/se-Karlshamn
+++ b/dvb-t/se-Karlshamn
@@ -1,5 +1,4 @@
 # Sweden - Karlshamn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Karlskrona_Vamo b/dvb-t/se-Karlskrona_Vamo
index 48b281a..dc478bf 100644
--- a/dvb-t/se-Karlskrona_Vamo
+++ b/dvb-t/se-Karlskrona_Vamo
@@ -1,5 +1,4 @@
 # Sweden - Karlskrona/Vämö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Karlstad_Sormon b/dvb-t/se-Karlstad_Sormon
index 2a3ffe4..004aa92 100644
--- a/dvb-t/se-Karlstad_Sormon
+++ b/dvb-t/se-Karlstad_Sormon
@@ -1,5 +1,4 @@
 # Sweden - Karlstad Sörmon Valid from 2007 09 26. Ver. 2 Correct FEC
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 # Channels
 # Mux3=30
 [CHANNEL]
diff --git a/dvb-t/se-Kaxholmen_Vistakulle b/dvb-t/se-Kaxholmen_Vistakulle
index abadade..e3f04e3 100644
--- a/dvb-t/se-Kaxholmen_Vistakulle
+++ b/dvb-t/se-Kaxholmen_Vistakulle
@@ -1,5 +1,4 @@
 # Sweden - Kaxholmen/Vistakulle
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/se-Kinnastrom b/dvb-t/se-Kinnastrom
index fa78d89..a612d36 100644
--- a/dvb-t/se-Kinnastrom
+++ b/dvb-t/se-Kinnastrom
@@ -1,5 +1,4 @@
 # Sweden - Kinnaström
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Kiruna_Kirunavaara b/dvb-t/se-Kiruna_Kirunavaara
index 8d8e351..638f181 100644
--- a/dvb-t/se-Kiruna_Kirunavaara
+++ b/dvb-t/se-Kiruna_Kirunavaara
@@ -1,5 +1,4 @@
 # Sweden - Kiruna/Kirunavaara
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/se-Kisa b/dvb-t/se-Kisa
index 718a750..ab85ef8 100644
--- a/dvb-t/se-Kisa
+++ b/dvb-t/se-Kisa
@@ -1,5 +1,4 @@
 # Sweden - Kisa
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
diff --git a/dvb-t/se-Knared b/dvb-t/se-Knared
index 73810ff..04db854 100644
--- a/dvb-t/se-Knared
+++ b/dvb-t/se-Knared
@@ -1,5 +1,4 @@
 # Sweden - Knäred
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/se-Kopmanholmen b/dvb-t/se-Kopmanholmen
index a1ca5e6..ce66f92 100644
--- a/dvb-t/se-Kopmanholmen
+++ b/dvb-t/se-Kopmanholmen
@@ -1,5 +1,4 @@
 # Sweden - Köpmanholmen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Kopparberg b/dvb-t/se-Kopparberg
index fdd9abd..7820e4d 100644
--- a/dvb-t/se-Kopparberg
+++ b/dvb-t/se-Kopparberg
@@ -1,5 +1,4 @@
 # Sweden - Kopparberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Kramfors_Lugnvik b/dvb-t/se-Kramfors_Lugnvik
index ccf13ca..88e9b34 100644
--- a/dvb-t/se-Kramfors_Lugnvik
+++ b/dvb-t/se-Kramfors_Lugnvik
@@ -1,5 +1,4 @@
 # Sweden - Kramfors/Lugnvik
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/se-Kristinehamn_Utsiktsberget b/dvb-t/se-Kristinehamn_Utsiktsberget
index 0e4c597..e9dfbaa 100644
--- a/dvb-t/se-Kristinehamn_Utsiktsberget
+++ b/dvb-t/se-Kristinehamn_Utsiktsberget
@@ -1,5 +1,4 @@
 # Sweden - Kristinehamn/Utsiktsberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Kungsater b/dvb-t/se-Kungsater
index a18ba12..26026b6 100644
--- a/dvb-t/se-Kungsater
+++ b/dvb-t/se-Kungsater
@@ -1,5 +1,4 @@
 # Sweden - Kungsäter
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Kungsberget_GI b/dvb-t/se-Kungsberget_GI
index 8720dad..8d34e20 100644
--- a/dvb-t/se-Kungsberget_GI
+++ b/dvb-t/se-Kungsberget_GI
@@ -1,5 +1,4 @@
 # Sweden - Kungsberget/GI
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
diff --git a/dvb-t/se-Langshyttan b/dvb-t/se-Langshyttan
index f35840f..158f8b1 100644
--- a/dvb-t/se-Langshyttan
+++ b/dvb-t/se-Langshyttan
@@ -1,5 +1,4 @@
 # Sweden - Långshyttan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Langshyttan_Engelsfors b/dvb-t/se-Langshyttan_Engelsfors
index edf5715..69612c8 100644
--- a/dvb-t/se-Langshyttan_Engelsfors
+++ b/dvb-t/se-Langshyttan_Engelsfors
@@ -1,5 +1,4 @@
 # Sweden - Långshyttan/Engelsfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Leksand_Karingberget b/dvb-t/se-Leksand_Karingberget
index 5e91fa2..431233b 100644
--- a/dvb-t/se-Leksand_Karingberget
+++ b/dvb-t/se-Leksand_Karingberget
@@ -1,5 +1,4 @@
 # Sweden - Leksand/Käringberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Lerdala b/dvb-t/se-Lerdala
index b2ad961..3e9750f 100644
--- a/dvb-t/se-Lerdala
+++ b/dvb-t/se-Lerdala
@@ -1,5 +1,4 @@
 # Sweden - Lerdala
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/se-Lilltjara_Digerberget b/dvb-t/se-Lilltjara_Digerberget
index 748a3b5..cd9197b 100644
--- a/dvb-t/se-Lilltjara_Digerberget
+++ b/dvb-t/se-Lilltjara_Digerberget
@@ -1,5 +1,4 @@
 # Sweden - Lilltjära/Digerberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/se-Limedsforsen b/dvb-t/se-Limedsforsen
index 5955a62..64c4d25 100644
--- a/dvb-t/se-Limedsforsen
+++ b/dvb-t/se-Limedsforsen
@@ -1,5 +1,4 @@
 # Sweden - Limedsforsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Lindshammar_Ramkvilla b/dvb-t/se-Lindshammar_Ramkvilla
index a8cb638..e736d0d 100644
--- a/dvb-t/se-Lindshammar_Ramkvilla
+++ b/dvb-t/se-Lindshammar_Ramkvilla
@@ -1,5 +1,4 @@
 # Sweden - Lindshammar/Ramkvilla
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/se-Linkoping_Vattentornet b/dvb-t/se-Linkoping_Vattentornet
index 0a417d8..f6d3be0 100644
--- a/dvb-t/se-Linkoping_Vattentornet
+++ b/dvb-t/se-Linkoping_Vattentornet
@@ -1,5 +1,4 @@
 # Sweden - Linköping/Vattentornet
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/se-Ljugarn b/dvb-t/se-Ljugarn
index b6b72ec..c256ce2 100644
--- a/dvb-t/se-Ljugarn
+++ b/dvb-t/se-Ljugarn
@@ -1,5 +1,4 @@
 # Sweden - Ljugarn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 554000000
diff --git a/dvb-t/se-Loffstrand b/dvb-t/se-Loffstrand
index a886d31..ffcb4e2 100644
--- a/dvb-t/se-Loffstrand
+++ b/dvb-t/se-Loffstrand
@@ -1,5 +1,4 @@
 # Sweden - Loffstrand
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/se-Lonneberga b/dvb-t/se-Lonneberga
index 05f9392..91768ff 100644
--- a/dvb-t/se-Lonneberga
+++ b/dvb-t/se-Lonneberga
@@ -1,5 +1,4 @@
 # Sweden - Lönneberga
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
diff --git a/dvb-t/se-Lorstrand b/dvb-t/se-Lorstrand
index 94fd148..dbbde4a 100644
--- a/dvb-t/se-Lorstrand
+++ b/dvb-t/se-Lorstrand
@@ -1,5 +1,4 @@
 # Sweden - Lörstrand
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/se-Ludvika_Bjorkasen b/dvb-t/se-Ludvika_Bjorkasen
index 4d2ecd5..165a8d3 100644
--- a/dvb-t/se-Ludvika_Bjorkasen
+++ b/dvb-t/se-Ludvika_Bjorkasen
@@ -1,5 +1,4 @@
 # Sweden - Ludvika/Björkåsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 498000000
diff --git a/dvb-t/se-Lumsheden_Trekanten b/dvb-t/se-Lumsheden_Trekanten
index 36f257c..5b9e0b6 100644
--- a/dvb-t/se-Lumsheden_Trekanten
+++ b/dvb-t/se-Lumsheden_Trekanten
@@ -1,5 +1,4 @@
 # Sweden - Lumsheden/Trekanten
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Lycksele_Knaften b/dvb-t/se-Lycksele_Knaften
index 1a64e38..dcf4adb 100644
--- a/dvb-t/se-Lycksele_Knaften
+++ b/dvb-t/se-Lycksele_Knaften
@@ -1,5 +1,4 @@
 # Sweden - Lycksele/Knaften
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Mahult b/dvb-t/se-Mahult
index 985c9aa..d27311d 100644
--- a/dvb-t/se-Mahult
+++ b/dvb-t/se-Mahult
@@ -1,5 +1,4 @@
 # Sweden - Mahult
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Malmo_Jagersro b/dvb-t/se-Malmo_Jagersro
index edd93e4..1587396 100644
--- a/dvb-t/se-Malmo_Jagersro
+++ b/dvb-t/se-Malmo_Jagersro
@@ -1,5 +1,4 @@
 # Sweden - Malmö/Jägersro
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Malung b/dvb-t/se-Malung
index da5e2f3..3d68151 100644
--- a/dvb-t/se-Malung
+++ b/dvb-t/se-Malung
@@ -1,5 +1,4 @@
 # Sweden - Malung
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
diff --git a/dvb-t/se-Mariannelund b/dvb-t/se-Mariannelund
index f84641d..1c9dcf9 100644
--- a/dvb-t/se-Mariannelund
+++ b/dvb-t/se-Mariannelund
@@ -1,5 +1,4 @@
 # Sweden - Mariannelund
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 834000000
diff --git a/dvb-t/se-Markaryd_Hualtet b/dvb-t/se-Markaryd_Hualtet
index 3e86366..d78df38 100644
--- a/dvb-t/se-Markaryd_Hualtet
+++ b/dvb-t/se-Markaryd_Hualtet
@@ -1,5 +1,4 @@
 # Sweden - Markaryd/Hualtet
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Matfors b/dvb-t/se-Matfors
index 7bfc0ef..62bacff 100644
--- a/dvb-t/se-Matfors
+++ b/dvb-t/se-Matfors
@@ -1,5 +1,4 @@
 # Sweden - Matfors
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Molndal_Vasterberget b/dvb-t/se-Molndal_Vasterberget
index b7b3160..bafdb49 100644
--- a/dvb-t/se-Molndal_Vasterberget
+++ b/dvb-t/se-Molndal_Vasterberget
@@ -1,5 +1,4 @@
 # Sweden - Mölndal/Västerberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Mora_Eldris b/dvb-t/se-Mora_Eldris
index 8241ad7..a5c466c 100644
--- a/dvb-t/se-Mora_Eldris
+++ b/dvb-t/se-Mora_Eldris
@@ -1,5 +1,4 @@
 # Sweden - Mora/Eldris
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Motala_Ervasteby b/dvb-t/se-Motala_Ervasteby
index 2cea72e..90a3f85 100644
--- a/dvb-t/se-Motala_Ervasteby
+++ b/dvb-t/se-Motala_Ervasteby
@@ -1,5 +1,4 @@
 # Sweden - Motala/Ervasteby
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 522000000
diff --git a/dvb-t/se-Mullsjo_Torestorp b/dvb-t/se-Mullsjo_Torestorp
index b2882d9..495ee61 100644
--- a/dvb-t/se-Mullsjo_Torestorp
+++ b/dvb-t/se-Mullsjo_Torestorp
@@ -1,5 +1,4 @@
 # Sweden - Mullsjö/Torestorp
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 834000000
diff --git a/dvb-t/se-Nassjo b/dvb-t/se-Nassjo
index e324b10..0df0029 100644
--- a/dvb-t/se-Nassjo
+++ b/dvb-t/se-Nassjo
@@ -1,5 +1,4 @@
 # Sweden - Nässjö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Navekvarn b/dvb-t/se-Navekvarn
index 252eb52..cc00cb7 100644
--- a/dvb-t/se-Navekvarn
+++ b/dvb-t/se-Navekvarn
@@ -1,5 +1,4 @@
 # Sweden - Nävekvarn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 842000000
diff --git a/dvb-t/se-Norrahammar b/dvb-t/se-Norrahammar
index 776ea5c..d276059 100644
--- a/dvb-t/se-Norrahammar
+++ b/dvb-t/se-Norrahammar
@@ -1,5 +1,4 @@
 # Sweden - Norrahammar
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
diff --git a/dvb-t/se-Norrkoping_Krokek b/dvb-t/se-Norrkoping_Krokek
index f7cb1f1..8ccf1b9 100644
--- a/dvb-t/se-Norrkoping_Krokek
+++ b/dvb-t/se-Norrkoping_Krokek
@@ -1,5 +1,4 @@
 # Sweden - Norrköping/Krokek
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Norrtalje_Sodra_Bergen b/dvb-t/se-Norrtalje_Sodra_Bergen
index 79ac4a3..7c82968 100644
--- a/dvb-t/se-Norrtalje_Sodra_Bergen
+++ b/dvb-t/se-Norrtalje_Sodra_Bergen
@@ -1,5 +1,4 @@
 # Sweden - Norrtälje/Södra Bergen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Nykoping b/dvb-t/se-Nykoping
index 22a0e78..6735148 100644
--- a/dvb-t/se-Nykoping
+++ b/dvb-t/se-Nykoping
@@ -1,5 +1,4 @@
 # Sweden - Nyköping
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 498000000
diff --git a/dvb-t/se-Orebro_Lockhyttan b/dvb-t/se-Orebro_Lockhyttan
index 74f5a32..1ce0d86 100644
--- a/dvb-t/se-Orebro_Lockhyttan
+++ b/dvb-t/se-Orebro_Lockhyttan
@@ -1,5 +1,4 @@
 # Sweden - Örebro/Lockhyttan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 586000000
diff --git a/dvb-t/se-Ornskoldsvik_As b/dvb-t/se-Ornskoldsvik_As
index 5151004..e0fb7c2 100644
--- a/dvb-t/se-Ornskoldsvik_As
+++ b/dvb-t/se-Ornskoldsvik_As
@@ -1,5 +1,4 @@
 # Sweden - Örnsköldsvik/Ås
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Oskarshamn b/dvb-t/se-Oskarshamn
index 274202b..50c9015 100644
--- a/dvb-t/se-Oskarshamn
+++ b/dvb-t/se-Oskarshamn
@@ -1,5 +1,4 @@
 # Sweden - Oskarshamn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/se-Ostersund_Brattasen b/dvb-t/se-Ostersund_Brattasen
index 8be64e8..f462756 100644
--- a/dvb-t/se-Ostersund_Brattasen
+++ b/dvb-t/se-Ostersund_Brattasen
@@ -1,5 +1,4 @@
 # Sweden - Östersund/Brattåsen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 690000000
diff --git a/dvb-t/se-Osthammar_Valo b/dvb-t/se-Osthammar_Valo
index aa3703b..0142c8f 100644
--- a/dvb-t/se-Osthammar_Valo
+++ b/dvb-t/se-Osthammar_Valo
@@ -1,5 +1,4 @@
 # Sweden - Östhammar/Valö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Overkalix b/dvb-t/se-Overkalix
index 083c340..69b9fd4 100644
--- a/dvb-t/se-Overkalix
+++ b/dvb-t/se-Overkalix
@@ -1,5 +1,4 @@
 # Sweden - Överkalix
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Oxberg b/dvb-t/se-Oxberg
index 2e5f762..3a28be5 100644
--- a/dvb-t/se-Oxberg
+++ b/dvb-t/se-Oxberg
@@ -1,5 +1,4 @@
 # Sweden - Oxberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
diff --git a/dvb-t/se-Paulistom b/dvb-t/se-Paulistom
index 37d7b5f..3dd9b50 100644
--- a/dvb-t/se-Paulistom
+++ b/dvb-t/se-Paulistom
@@ -1,5 +1,4 @@
 # Sweden - Paulistöm
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 722000000
diff --git a/dvb-t/se-Rattvik b/dvb-t/se-Rattvik
index d7a2827..5289950 100644
--- a/dvb-t/se-Rattvik
+++ b/dvb-t/se-Rattvik
@@ -1,5 +1,4 @@
 # Sweden - Rättvik
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
diff --git a/dvb-t/se-Rengsjo b/dvb-t/se-Rengsjo
index 222dfbe..076c45d 100644
--- a/dvb-t/se-Rengsjo
+++ b/dvb-t/se-Rengsjo
@@ -1,5 +1,4 @@
 # Sweden - Rengsjö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Rorbacksnas b/dvb-t/se-Rorbacksnas
index 4c5725c..24e081e 100644
--- a/dvb-t/se-Rorbacksnas
+++ b/dvb-t/se-Rorbacksnas
@@ -1,5 +1,4 @@
 # Sweden - Rörbäcksnäs
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
diff --git a/dvb-t/se-Sagmyra b/dvb-t/se-Sagmyra
index 1e5b52d..a9d67e8 100644
--- a/dvb-t/se-Sagmyra
+++ b/dvb-t/se-Sagmyra
@@ -1,5 +1,4 @@
 # Sweden - Sågmyra
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Salen b/dvb-t/se-Salen
index 59f428c..58bd5a6 100644
--- a/dvb-t/se-Salen
+++ b/dvb-t/se-Salen
@@ -1,5 +1,4 @@
 # Sweden - Sälen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Salfjallet b/dvb-t/se-Salfjallet
index 58eeabc..aa161ac 100644
--- a/dvb-t/se-Salfjallet
+++ b/dvb-t/se-Salfjallet
@@ -1,5 +1,4 @@
 # Sweden - Sälfjället
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 650000000
diff --git a/dvb-t/se-Sarna_Mickeltemplet b/dvb-t/se-Sarna_Mickeltemplet
index 135a3ed..1ae4e26 100644
--- a/dvb-t/se-Sarna_Mickeltemplet
+++ b/dvb-t/se-Sarna_Mickeltemplet
@@ -1,5 +1,4 @@
 # Sweden - Särna/Mickeltemplet
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
diff --git a/dvb-t/se-Satila b/dvb-t/se-Satila
index 793d24c..90eff02 100644
--- a/dvb-t/se-Satila
+++ b/dvb-t/se-Satila
@@ -1,5 +1,4 @@
 # Sweden - Sätila
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/se-Saxdalen b/dvb-t/se-Saxdalen
index a44178b..cf3f4ad 100644
--- a/dvb-t/se-Saxdalen
+++ b/dvb-t/se-Saxdalen
@@ -1,5 +1,4 @@
 # Sweden - Saxdalen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Siljansnas_Uvberget b/dvb-t/se-Siljansnas_Uvberget
index 9de47c0..7f35c51 100644
--- a/dvb-t/se-Siljansnas_Uvberget
+++ b/dvb-t/se-Siljansnas_Uvberget
@@ -1,5 +1,4 @@
 # Sweden - Siljansnäs/Uvberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Skarstad b/dvb-t/se-Skarstad
index 27eb6f8..58a7499 100644
--- a/dvb-t/se-Skarstad
+++ b/dvb-t/se-Skarstad
@@ -1,5 +1,4 @@
 # Sweden - Skärstad
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/se-Skattungbyn b/dvb-t/se-Skattungbyn
index ec7d286..3842b30 100644
--- a/dvb-t/se-Skattungbyn
+++ b/dvb-t/se-Skattungbyn
@@ -1,5 +1,4 @@
 # Sweden - Skattungbyn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
diff --git a/dvb-t/se-Skelleftea b/dvb-t/se-Skelleftea
index feaa723..955d038 100644
--- a/dvb-t/se-Skelleftea
+++ b/dvb-t/se-Skelleftea
@@ -1,5 +1,4 @@
 # Sweden - Skellefteå
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Skene_Nycklarberget b/dvb-t/se-Skene_Nycklarberget
index 36a11be..49347d3 100644
--- a/dvb-t/se-Skene_Nycklarberget
+++ b/dvb-t/se-Skene_Nycklarberget
@@ -1,5 +1,4 @@
 # Sweden - Skene/Nycklarberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 578000000
diff --git a/dvb-t/se-Skovde b/dvb-t/se-Skovde
index b0da7a6..431f510 100644
--- a/dvb-t/se-Skovde
+++ b/dvb-t/se-Skovde
@@ -1,5 +1,4 @@
 # Sweden - Skövde
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Smedjebacken_Uvberget b/dvb-t/se-Smedjebacken_Uvberget
index 21af7cd..9befd16 100644
--- a/dvb-t/se-Smedjebacken_Uvberget
+++ b/dvb-t/se-Smedjebacken_Uvberget
@@ -1,5 +1,4 @@
 # Sweden - Smedjebacken/Uvberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
diff --git a/dvb-t/se-Soderhamn b/dvb-t/se-Soderhamn
index 82ac14c..3798f67 100644
--- a/dvb-t/se-Soderhamn
+++ b/dvb-t/se-Soderhamn
@@ -1,5 +1,4 @@
 # Sweden - Söderhamn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
diff --git a/dvb-t/se-Soderkoping b/dvb-t/se-Soderkoping
index 91574f4..6525a79 100644
--- a/dvb-t/se-Soderkoping
+++ b/dvb-t/se-Soderkoping
@@ -1,5 +1,4 @@
 # Sweden - Söderköping
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/se-Sodertalje_Ragnhildsborg b/dvb-t/se-Sodertalje_Ragnhildsborg
index 1645f44..c2d2d49 100644
--- a/dvb-t/se-Sodertalje_Ragnhildsborg
+++ b/dvb-t/se-Sodertalje_Ragnhildsborg
@@ -1,5 +1,4 @@
 # Sweden - Södertälje/Ragnhildsborg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 506000000
diff --git a/dvb-t/se-Solleftea_Hallsta b/dvb-t/se-Solleftea_Hallsta
index 5d77acf..8f017b6 100644
--- a/dvb-t/se-Solleftea_Hallsta
+++ b/dvb-t/se-Solleftea_Hallsta
@@ -1,5 +1,4 @@
 # Sweden - Sollefteå/Hallsta
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Solleftea_Multra b/dvb-t/se-Solleftea_Multra
index ae61c4f..9816a77 100644
--- a/dvb-t/se-Solleftea_Multra
+++ b/dvb-t/se-Solleftea_Multra
@@ -1,5 +1,4 @@
 # Sweden - Sollefteå/Multrå
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
diff --git a/dvb-t/se-Sorsjon b/dvb-t/se-Sorsjon
index d56c8cf..84e99e8 100644
--- a/dvb-t/se-Sorsjon
+++ b/dvb-t/se-Sorsjon
@@ -1,5 +1,4 @@
 # Sweden - Sörsjön
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Stockholm_Marieberg b/dvb-t/se-Stockholm_Marieberg
index 184eb0f..0d5dc83 100644
--- a/dvb-t/se-Stockholm_Marieberg
+++ b/dvb-t/se-Stockholm_Marieberg
@@ -1,5 +1,4 @@
 # Sweden - Stockholm/Marieberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Stockholm_Nacka b/dvb-t/se-Stockholm_Nacka
index f506224..f9b4b49 100644
--- a/dvb-t/se-Stockholm_Nacka
+++ b/dvb-t/se-Stockholm_Nacka
@@ -1,5 +1,4 @@
 # Sweden - Stockholm/Nacka
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [Teracom_Mux_1]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
diff --git a/dvb-t/se-Stora_Skedvi b/dvb-t/se-Stora_Skedvi
index a8de973..f00c793 100644
--- a/dvb-t/se-Stora_Skedvi
+++ b/dvb-t/se-Stora_Skedvi
@@ -1,5 +1,4 @@
 # Sweden - Stora Skedvi
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 578000000
diff --git a/dvb-t/se-Storfjaten b/dvb-t/se-Storfjaten
index 1e93cae..93b898e 100644
--- a/dvb-t/se-Storfjaten
+++ b/dvb-t/se-Storfjaten
@@ -1,5 +1,4 @@
 # Sweden - Storfjäten
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/se-Storuman b/dvb-t/se-Storuman
index edc90e4..f2ce368 100644
--- a/dvb-t/se-Storuman
+++ b/dvb-t/se-Storuman
@@ -1,5 +1,4 @@
 # Sweden - Storuman
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
diff --git a/dvb-t/se-Stromstad b/dvb-t/se-Stromstad
index 03da896..51b8c4b 100644
--- a/dvb-t/se-Stromstad
+++ b/dvb-t/se-Stromstad
@@ -1,5 +1,4 @@
 # Sweden - Strömstad
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Styrsjobo b/dvb-t/se-Styrsjobo
index 33a821c..1ccce04 100644
--- a/dvb-t/se-Styrsjobo
+++ b/dvb-t/se-Styrsjobo
@@ -1,5 +1,4 @@
 # Sweden - Styrsjöbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Sundborn b/dvb-t/se-Sundborn
index 49d20cd..b423757 100644
--- a/dvb-t/se-Sundborn
+++ b/dvb-t/se-Sundborn
@@ -1,5 +1,4 @@
 # Sweden - Sundborn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
diff --git a/dvb-t/se-Sundsbruk b/dvb-t/se-Sundsbruk
index a44eaef..d3a3c74 100644
--- a/dvb-t/se-Sundsbruk
+++ b/dvb-t/se-Sundsbruk
@@ -1,5 +1,4 @@
 # Sweden - Sundsbruk
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Sundsvall_S_Stadsberget b/dvb-t/se-Sundsvall_S_Stadsberget
index 117018e..6fd61d8 100644
--- a/dvb-t/se-Sundsvall_S_Stadsberget
+++ b/dvb-t/se-Sundsvall_S_Stadsberget
@@ -1,5 +1,4 @@
 # Sweden - Sundsvall/S Stadsberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
diff --git a/dvb-t/se-Sunne_Blabarskullen b/dvb-t/se-Sunne_Blabarskullen
index 1852a1b..54e7faf 100644
--- a/dvb-t/se-Sunne_Blabarskullen
+++ b/dvb-t/se-Sunne_Blabarskullen
@@ -1,5 +1,4 @@
 # Sweden - Sunne/Blåbärskullen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
diff --git a/dvb-t/se-Svartnas b/dvb-t/se-Svartnas
index e1b8232..ac37690 100644
--- a/dvb-t/se-Svartnas
+++ b/dvb-t/se-Svartnas
@@ -1,5 +1,4 @@
 # Sweden - Svartnäs
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
diff --git a/dvb-t/se-Sveg_Brickan b/dvb-t/se-Sveg_Brickan
index 54bc694..ddc8a3a 100644
--- a/dvb-t/se-Sveg_Brickan
+++ b/dvb-t/se-Sveg_Brickan
@@ -1,5 +1,4 @@
 # Sweden - Sveg/Brickan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Taberg b/dvb-t/se-Taberg
index f41df6e..7ee8530 100644
--- a/dvb-t/se-Taberg
+++ b/dvb-t/se-Taberg
@@ -1,5 +1,4 @@
 # Sweden - Taberg
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
diff --git a/dvb-t/se-Tandadalen b/dvb-t/se-Tandadalen
index d9ab9a8..1361c86 100644
--- a/dvb-t/se-Tandadalen
+++ b/dvb-t/se-Tandadalen
@@ -1,5 +1,4 @@
 # Sweden - Tandådalen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 754000000
diff --git a/dvb-t/se-Tasjo b/dvb-t/se-Tasjo
index 27f6a53..4cc782e 100644
--- a/dvb-t/se-Tasjo
+++ b/dvb-t/se-Tasjo
@@ -1,5 +1,4 @@
 # Sweden - Tåsjö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Tollsjo b/dvb-t/se-Tollsjo
index f718609..3f18527 100644
--- a/dvb-t/se-Tollsjo
+++ b/dvb-t/se-Tollsjo
@@ -1,5 +1,4 @@
 # Sweden - Töllsjö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 722000000
diff --git a/dvb-t/se-Torsby_Bada b/dvb-t/se-Torsby_Bada
index 2989f0a..278ae9e 100644
--- a/dvb-t/se-Torsby_Bada
+++ b/dvb-t/se-Torsby_Bada
@@ -1,5 +1,4 @@
 # Sweden - Torsby/Bada
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Tranas_Bredkarr b/dvb-t/se-Tranas_Bredkarr
index f62d0cf..1d2dede 100644
--- a/dvb-t/se-Tranas_Bredkarr
+++ b/dvb-t/se-Tranas_Bredkarr
@@ -1,5 +1,4 @@
 # Sweden - Tranås/Bredkärr
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
diff --git a/dvb-t/se-Tranemo b/dvb-t/se-Tranemo
index ad33a1c..eca9304 100644
--- a/dvb-t/se-Tranemo
+++ b/dvb-t/se-Tranemo
@@ -1,5 +1,4 @@
 # Sweden - Tranemo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 706000000
diff --git a/dvb-t/se-Transtrand_Bolheden b/dvb-t/se-Transtrand_Bolheden
index bf0c426..4fca78f 100644
--- a/dvb-t/se-Transtrand_Bolheden
+++ b/dvb-t/se-Transtrand_Bolheden
@@ -1,5 +1,4 @@
 # Sweden - Transtrand/Bolheden
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Traryd_Betas b/dvb-t/se-Traryd_Betas
index f4790d4..30ead5c 100644
--- a/dvb-t/se-Traryd_Betas
+++ b/dvb-t/se-Traryd_Betas
@@ -1,5 +1,4 @@
 # Sweden - Traryd/Betås
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
diff --git a/dvb-t/se-Trollhattan b/dvb-t/se-Trollhattan
index aaec9cb..0767d31 100644
--- a/dvb-t/se-Trollhattan
+++ b/dvb-t/se-Trollhattan
@@ -1,5 +1,4 @@
 # Sweden - Trollhättan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Trosa b/dvb-t/se-Trosa
index b1ea9bf..2d6b963 100644
--- a/dvb-t/se-Trosa
+++ b/dvb-t/se-Trosa
@@ -1,5 +1,4 @@
 # Sweden - Trosa
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Tystberga b/dvb-t/se-Tystberga
index 42aed03..522f51e 100644
--- a/dvb-t/se-Tystberga
+++ b/dvb-t/se-Tystberga
@@ -1,5 +1,4 @@
 # Sweden - Tystberga
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 842000000
diff --git a/dvb-t/se-Uddevalla_Herrestad b/dvb-t/se-Uddevalla_Herrestad
index 9a94954..96c9c30 100644
--- a/dvb-t/se-Uddevalla_Herrestad
+++ b/dvb-t/se-Uddevalla_Herrestad
@@ -1,5 +1,4 @@
 # Sweden - Uddevalla/Herrestad
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
diff --git a/dvb-t/se-Ullared b/dvb-t/se-Ullared
index cb3817d..29d4a02 100644
--- a/dvb-t/se-Ullared
+++ b/dvb-t/se-Ullared
@@ -1,5 +1,4 @@
 # Sweden - Ullared
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
diff --git a/dvb-t/se-Ulricehamn b/dvb-t/se-Ulricehamn
index 67ae4f1..b73bf00 100644
--- a/dvb-t/se-Ulricehamn
+++ b/dvb-t/se-Ulricehamn
@@ -1,5 +1,4 @@
 # Sweden - Ulricehamn
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/se-Ulvshyttan_Porjus b/dvb-t/se-Ulvshyttan_Porjus
index 44510db..08f0234 100644
--- a/dvb-t/se-Ulvshyttan_Porjus
+++ b/dvb-t/se-Ulvshyttan_Porjus
@@ -1,5 +1,4 @@
 # Sweden - Ulvshyttan/Porjus
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Uppsala_Rickomberga b/dvb-t/se-Uppsala_Rickomberga
index a4db9c5..2c0ac8f 100644
--- a/dvb-t/se-Uppsala_Rickomberga
+++ b/dvb-t/se-Uppsala_Rickomberga
@@ -1,5 +1,4 @@
 # Sweden - Uppsala/Rickomberga
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Uppsala_Vedyxa b/dvb-t/se-Uppsala_Vedyxa
index 180fb2f..59618d9 100644
--- a/dvb-t/se-Uppsala_Vedyxa
+++ b/dvb-t/se-Uppsala_Vedyxa
@@ -1,5 +1,4 @@
 # Sweden - Uppsala/Vedyxa
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Vaddo_Elmsta b/dvb-t/se-Vaddo_Elmsta
index ccc560c..27b78e7 100644
--- a/dvb-t/se-Vaddo_Elmsta
+++ b/dvb-t/se-Vaddo_Elmsta
@@ -1,5 +1,4 @@
 # Sweden - Väddö/Elmsta
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/se-Valdemarsvik b/dvb-t/se-Valdemarsvik
index 35a8639..9ace1a6 100644
--- a/dvb-t/se-Valdemarsvik
+++ b/dvb-t/se-Valdemarsvik
@@ -1,5 +1,4 @@
 # Sweden - Valdemarsvik
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 834000000
diff --git a/dvb-t/se-Vannas_Granlundsberget b/dvb-t/se-Vannas_Granlundsberget
index e41bb89..7031e18 100644
--- a/dvb-t/se-Vannas_Granlundsberget
+++ b/dvb-t/se-Vannas_Granlundsberget
@@ -1,5 +1,4 @@
 # Sweden - Vännäs/Granlundsberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 786000000
diff --git a/dvb-t/se-Vansbro_Hummelberget b/dvb-t/se-Vansbro_Hummelberget
index 9ce5e7e..0b4263d 100644
--- a/dvb-t/se-Vansbro_Hummelberget
+++ b/dvb-t/se-Vansbro_Hummelberget
@@ -1,5 +1,4 @@
 # Sweden - Vansbro/Hummelberget
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Varberg_Grimeton b/dvb-t/se-Varberg_Grimeton
index e395ae8..9f090b4 100644
--- a/dvb-t/se-Varberg_Grimeton
+++ b/dvb-t/se-Varberg_Grimeton
@@ -1,5 +1,4 @@
 # Sweden - Varberg/Grimeton
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 474000000
diff --git a/dvb-t/se-Vasteras_Lillharad b/dvb-t/se-Vasteras_Lillharad
index 946a349..8096513 100644
--- a/dvb-t/se-Vasteras_Lillharad
+++ b/dvb-t/se-Vasteras_Lillharad
@@ -1,5 +1,4 @@
 # Sweden - Västerås/Lillhärad
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Vastervik_Farhult b/dvb-t/se-Vastervik_Farhult
index e4b9f90..feee9ef 100644
--- a/dvb-t/se-Vastervik_Farhult
+++ b/dvb-t/se-Vastervik_Farhult
@@ -1,5 +1,4 @@
 # Sweden - Västervik/Fårhult
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Vaxbo b/dvb-t/se-Vaxbo
index 45407dc..116483f 100644
--- a/dvb-t/se-Vaxbo
+++ b/dvb-t/se-Vaxbo
@@ -1,5 +1,4 @@
 # Sweden - Växbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
diff --git a/dvb-t/se-Vessigebro b/dvb-t/se-Vessigebro
index c5bfcd3..2cd921e 100644
--- a/dvb-t/se-Vessigebro
+++ b/dvb-t/se-Vessigebro
@@ -1,5 +1,4 @@
 # Sweden - Vessigebro
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
diff --git a/dvb-t/se-Vetlanda_Nye b/dvb-t/se-Vetlanda_Nye
index bba4486..7cd1f5c 100644
--- a/dvb-t/se-Vetlanda_Nye
+++ b/dvb-t/se-Vetlanda_Nye
@@ -1,5 +1,4 @@
 # Sweden - Vetlanda/Nye
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
diff --git a/dvb-t/se-Vikmanshyttan b/dvb-t/se-Vikmanshyttan
index 69a998d..6b24d6e 100644
--- a/dvb-t/se-Vikmanshyttan
+++ b/dvb-t/se-Vikmanshyttan
@@ -1,5 +1,4 @@
 # Sweden - Vikmanshyttan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
diff --git a/dvb-t/se-Virserum b/dvb-t/se-Virserum
index 9a1364c..566f69f 100644
--- a/dvb-t/se-Virserum
+++ b/dvb-t/se-Virserum
@@ -1,5 +1,4 @@
 # Sweden - Virserum
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
diff --git a/dvb-t/se-Visby_Follingbo b/dvb-t/se-Visby_Follingbo
index a3bdd14..616e992 100644
--- a/dvb-t/se-Visby_Follingbo
+++ b/dvb-t/se-Visby_Follingbo
@@ -1,5 +1,4 @@
 # Sweden - Visby/Follingbo
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
diff --git a/dvb-t/se-Visby_Hamnen b/dvb-t/se-Visby_Hamnen
index 2428bbd..e60a86d 100644
--- a/dvb-t/se-Visby_Hamnen
+++ b/dvb-t/se-Visby_Hamnen
@@ -1,5 +1,4 @@
 # Sweden - Visby/Hamnen
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Visingso b/dvb-t/se-Visingso
index 28e7702..0dcc4f4 100644
--- a/dvb-t/se-Visingso
+++ b/dvb-t/se-Visingso
@@ -1,5 +1,4 @@
 # Sweden - Visingsö
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 650000000
diff --git a/dvb-t/se-Vislanda_Nydala b/dvb-t/se-Vislanda_Nydala
index ff8f796..ed2892b 100644
--- a/dvb-t/se-Vislanda_Nydala
+++ b/dvb-t/se-Vislanda_Nydala
@@ -1,5 +1,4 @@
 # Sweden - Vislanda/Nydala
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
diff --git a/dvb-t/se-Voxna b/dvb-t/se-Voxna
index 0dd3fd6..a14cba7 100644
--- a/dvb-t/se-Voxna
+++ b/dvb-t/se-Voxna
@@ -1,5 +1,4 @@
 # Sweden - Voxna
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
diff --git a/dvb-t/se-Ystad_Metallgatan b/dvb-t/se-Ystad_Metallgatan
index b01c891..a124e2d 100644
--- a/dvb-t/se-Ystad_Metallgatan
+++ b/dvb-t/se-Ystad_Metallgatan
@@ -1,5 +1,4 @@
 # Sweden - Ystad/Metallgatan
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
diff --git a/dvb-t/se-Yttermalung b/dvb-t/se-Yttermalung
index d2a4637..7473b30 100644
--- a/dvb-t/se-Yttermalung
+++ b/dvb-t/se-Yttermalung
@@ -1,5 +1,4 @@
 # Sweden - Yttermalung
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 698000000
diff --git a/dvb-t/sk-BanskaBystrica b/dvb-t/sk-BanskaBystrica
index d80d012..340164a 100644
--- a/dvb-t/sk-BanskaBystrica
+++ b/dvb-t/sk-BanskaBystrica
@@ -1,6 +1,5 @@
 # DVB-T Banska Bystrica (Banska Bystrica, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 51
 [CHANNEL]
diff --git a/dvb-t/sk-BanskaStiavnica b/dvb-t/sk-BanskaStiavnica
index 0cd3d74..0afc471 100644
--- a/dvb-t/sk-BanskaStiavnica
+++ b/dvb-t/sk-BanskaStiavnica
@@ -1,6 +1,5 @@
 # DVB-T Banska Stiavnica (Banska Stiavnica, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 21
 [CHANNEL]
diff --git a/dvb-t/sk-Bardejov b/dvb-t/sk-Bardejov
index 93c3fb1..a481bdf 100644
--- a/dvb-t/sk-Bardejov
+++ b/dvb-t/sk-Bardejov
@@ -1,6 +1,5 @@
 # DVB-T Bardejov (Bardejov, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 40
 [CHANNEL]
diff --git a/dvb-t/sk-Bratislava b/dvb-t/sk-Bratislava
index 9dcfb01..cd46162 100644
--- a/dvb-t/sk-Bratislava
+++ b/dvb-t/sk-Bratislava
@@ -1,6 +1,5 @@
 # DVB-T Bratislava (Bratislava, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 56
 [CHANNEL]
diff --git a/dvb-t/sk-Cadca b/dvb-t/sk-Cadca
index a733fd2..abd0e5b 100644
--- a/dvb-t/sk-Cadca
+++ b/dvb-t/sk-Cadca
@@ -1,6 +1,5 @@
 # DVB-T Cadca (Cadca, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 52
 [CHANNEL]
diff --git a/dvb-t/sk-Detva b/dvb-t/sk-Detva
index b3699b1..44cf2a6 100644
--- a/dvb-t/sk-Detva
+++ b/dvb-t/sk-Detva
@@ -1,6 +1,5 @@
 # DVB-T Detva (Detva, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 60
 [CHANNEL]
diff --git a/dvb-t/sk-Hnusta b/dvb-t/sk-Hnusta
index d5e9f42..d0b41ee 100644
--- a/dvb-t/sk-Hnusta
+++ b/dvb-t/sk-Hnusta
@@ -1,6 +1,5 @@
 # DVB-T Hnusta (Hnusta, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 27
 [CHANNEL]
diff --git a/dvb-t/sk-Kosice b/dvb-t/sk-Kosice
index 13e17e3..7c01b81 100644
--- a/dvb-t/sk-Kosice
+++ b/dvb-t/sk-Kosice
@@ -1,6 +1,5 @@
 # DVB-T Kosice (Kosice, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-KralovskyChlmec b/dvb-t/sk-KralovskyChlmec
index b5ac2f7..7163e83 100644
--- a/dvb-t/sk-KralovskyChlmec
+++ b/dvb-t/sk-KralovskyChlmec
@@ -1,6 +1,5 @@
 # DVB-T Kralovsky Chlmec (Kralovsky Chlmec, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Krompachy b/dvb-t/sk-Krompachy
index 631f1e0..27747cd 100644
--- a/dvb-t/sk-Krompachy
+++ b/dvb-t/sk-Krompachy
@@ -1,6 +1,5 @@
 # DVB-T Krompachy (Krompachy, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Lucenec b/dvb-t/sk-Lucenec
index c0d8d3e..1225eac 100644
--- a/dvb-t/sk-Lucenec
+++ b/dvb-t/sk-Lucenec
@@ -1,6 +1,5 @@
 # DVB-T Lucenec (Lucenec, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 60
 [CHANNEL]
diff --git a/dvb-t/sk-Medzev b/dvb-t/sk-Medzev
index 4dd6d27..52e19bb 100644
--- a/dvb-t/sk-Medzev
+++ b/dvb-t/sk-Medzev
@@ -1,6 +1,5 @@
 # DVB-T Medzev (Medzev, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Namestovo b/dvb-t/sk-Namestovo
index e701c72..ea76c10 100644
--- a/dvb-t/sk-Namestovo
+++ b/dvb-t/sk-Namestovo
@@ -1,6 +1,5 @@
 # DVB-T Namestovo (Namestovo, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Nitra b/dvb-t/sk-Nitra
index cedbd95..a823427 100644
--- a/dvb-t/sk-Nitra
+++ b/dvb-t/sk-Nitra
@@ -1,6 +1,5 @@
 # DVB-T Nitra (Nitra, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 21
 [CHANNEL]
diff --git a/dvb-t/sk-Poprad b/dvb-t/sk-Poprad
index a1b8e74..ccec350 100644
--- a/dvb-t/sk-Poprad
+++ b/dvb-t/sk-Poprad
@@ -1,6 +1,5 @@
 # DVB-T Poprad (Poprad, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 55
 [CHANNEL]
diff --git a/dvb-t/sk-PovazskaBystrica b/dvb-t/sk-PovazskaBystrica
index 930255c..d32759e 100644
--- a/dvb-t/sk-PovazskaBystrica
+++ b/dvb-t/sk-PovazskaBystrica
@@ -1,6 +1,5 @@
 # DVB-T Povazska Bystrica (Povazska Bystrica, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 52
 [CHANNEL]
diff --git a/dvb-t/sk-Presov b/dvb-t/sk-Presov
index ec7505f..0f0a36e 100644
--- a/dvb-t/sk-Presov
+++ b/dvb-t/sk-Presov
@@ -1,6 +1,5 @@
 # DVB-T Prešov (Prešov, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # MUX2 - Commercial - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Prievidza b/dvb-t/sk-Prievidza
index 0195da1..dafbc1e 100644
--- a/dvb-t/sk-Prievidza
+++ b/dvb-t/sk-Prievidza
@@ -1,6 +1,5 @@
 # DVB-T Prievidza (Prievidza, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 52
 [CHANNEL]
diff --git a/dvb-t/sk-Revuca b/dvb-t/sk-Revuca
index 10c8f0d..4f797ce 100644
--- a/dvb-t/sk-Revuca
+++ b/dvb-t/sk-Revuca
@@ -1,6 +1,5 @@
 # DVB-T Revuca (Revuca, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 27
 [CHANNEL]
diff --git a/dvb-t/sk-Roznava b/dvb-t/sk-Roznava
index 54b159c..fc09aaa 100644
--- a/dvb-t/sk-Roznava
+++ b/dvb-t/sk-Roznava
@@ -1,6 +1,5 @@
 # DVB-T Roznava (Roznava, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 27
 [CHANNEL]
diff --git a/dvb-t/sk-Ruzomberok b/dvb-t/sk-Ruzomberok
index 548eea2..fc2c668 100644
--- a/dvb-t/sk-Ruzomberok
+++ b/dvb-t/sk-Ruzomberok
@@ -1,6 +1,5 @@
 # DVB-T Ruzomberok (Ruzomberok, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-Snina b/dvb-t/sk-Snina
index cb193b5..f0f1585 100644
--- a/dvb-t/sk-Snina
+++ b/dvb-t/sk-Snina
@@ -1,6 +1,5 @@
 # DVB-T Snina (Snina, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 59
 [CHANNEL]
diff --git a/dvb-t/sk-StaraLubovna b/dvb-t/sk-StaraLubovna
index d50cd51..b1cf740 100644
--- a/dvb-t/sk-StaraLubovna
+++ b/dvb-t/sk-StaraLubovna
@@ -1,6 +1,5 @@
 # DVB-T Stara Lubovna (Stara Lubovna, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 55
 [CHANNEL]
diff --git a/dvb-t/sk-Sturovo b/dvb-t/sk-Sturovo
index 9f9ccf9..f54f8df 100644
--- a/dvb-t/sk-Sturovo
+++ b/dvb-t/sk-Sturovo
@@ -1,6 +1,5 @@
 # DVB-T Sturovo (Sturovo, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 21
 [CHANNEL]
diff --git a/dvb-t/sk-Trencin b/dvb-t/sk-Trencin
index 2542311..805038c 100644
--- a/dvb-t/sk-Trencin
+++ b/dvb-t/sk-Trencin
@@ -1,6 +1,5 @@
 # DVB-T Trencin (Trencin, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 52
 [CHANNEL]
diff --git a/dvb-t/sk-Zilina b/dvb-t/sk-Zilina
index 71b1366..e8d486d 100644
--- a/dvb-t/sk-Zilina
+++ b/dvb-t/sk-Zilina
@@ -1,6 +1,5 @@
 # DVB-T Zilina (Zilina, Slovak Republic)
 # Created from http://www.dvbt.towercom.sk/odbornici.php
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 
 # 2.st multiplex (commercial) - on channel 52
 [CHANNEL]
diff --git a/dvb-t/ua-Kharkov b/dvb-t/ua-Kharkov
index 9e2881e..13493b4 100644
--- a/dvb-t/ua-Kharkov
+++ b/dvb-t/ua-Kharkov
@@ -1,5 +1,4 @@
 # Ukraine, Kharkov
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 554000000
diff --git a/dvb-t/ua-Kiev b/dvb-t/ua-Kiev
index 9802803..0577625 100644
--- a/dvb-t/ua-Kiev
+++ b/dvb-t/ua-Kiev
@@ -1,5 +1,4 @@
 # Ukraine, Kiev
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 526000000
diff --git a/dvb-t/ua-Lozovaya b/dvb-t/ua-Lozovaya
index f5b2b02..fbd19f4 100644
--- a/dvb-t/ua-Lozovaya
+++ b/dvb-t/ua-Lozovaya
@@ -1,5 +1,4 @@
 # Ukraine, Lozovaya
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 554000000
diff --git a/dvb-t/ua-Odessa b/dvb-t/ua-Odessa
index 0852991..46c8571 100644
--- a/dvb-t/ua-Odessa
+++ b/dvb-t/ua-Odessa
@@ -1,5 +1,4 @@
 # Ukraine, Odessa
-# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 490000000
diff --git a/dvb-t/ug-All b/dvb-t/ug-All
index 4aa7a5b..ce2a286 100644
--- a/dvb-t/ug-All
+++ b/dvb-t/ug-All
@@ -4,7 +4,6 @@
 # 	               	: http://joseph.zikusooka.com
 # 	               	: joseph@zikusooka.com
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [plp_id] [system_id] [# comment]
 #------------------------------------------------------------------------------
 [UCC Primary]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Aberdare b/dvb-t/uk-Aberdare
index 5031cf2..a0c08b0 100644
--- a/dvb-t/uk-Aberdare
+++ b/dvb-t/uk-Aberdare
@@ -5,7 +5,6 @@
 # location and provider: UK, Aberdare
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C24- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Angus b/dvb-t/uk-Angus
index 1b65906..2a5064f 100644
--- a/dvb-t/uk-Angus
+++ b/dvb-t/uk-Angus
@@ -5,7 +5,6 @@
 # location and provider: UK, Angus
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BeaconHill b/dvb-t/uk-BeaconHill
index 1ed96ca..3905ebf 100644
--- a/dvb-t/uk-BeaconHill
+++ b/dvb-t/uk-BeaconHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Beacon Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Belmont b/dvb-t/uk-Belmont
index d83de04..d17c3ca 100644
--- a/dvb-t/uk-Belmont
+++ b/dvb-t/uk-Belmont
@@ -5,7 +5,6 @@
 # location and provider: UK, Belmont
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C22 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Bilsdale b/dvb-t/uk-Bilsdale
index bc4044c..b8164cc 100644
--- a/dvb-t/uk-Bilsdale
+++ b/dvb-t/uk-Bilsdale
@@ -5,7 +5,6 @@
 # location and provider: UK, Bilsdale
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BlackHill b/dvb-t/uk-BlackHill
index 1297580..b97c26f 100644
--- a/dvb-t/uk-BlackHill
+++ b/dvb-t/uk-BlackHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Black Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C46 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Blaenplwyf b/dvb-t/uk-Blaenplwyf
index a2122ba..5a569c2 100644
--- a/dvb-t/uk-Blaenplwyf
+++ b/dvb-t/uk-Blaenplwyf
@@ -5,7 +5,6 @@
 # location and provider: UK, Blaenplwyf
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BluebellHill b/dvb-t/uk-BluebellHill
index 1d64779..32997e3 100644
--- a/dvb-t/uk-BluebellHill
+++ b/dvb-t/uk-BluebellHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Bluebell Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C46 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Bressay b/dvb-t/uk-Bressay
index 9d6a4e4..9c95234 100644
--- a/dvb-t/uk-Bressay
+++ b/dvb-t/uk-Bressay
@@ -5,7 +5,6 @@
 # location and provider: UK, Bressay
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BrierleyHill b/dvb-t/uk-BrierleyHill
index 94f280b..34fbc90 100644
--- a/dvb-t/uk-BrierleyHill
+++ b/dvb-t/uk-BrierleyHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Brierley Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BristolIlchesterCrescent b/dvb-t/uk-BristolIlchesterCrescent
index c84ee29..6a268ff 100644
--- a/dvb-t/uk-BristolIlchesterCrescent
+++ b/dvb-t/uk-BristolIlchesterCrescent
@@ -5,7 +5,6 @@
 # location and provider: UK, Bristol Ilchester Crescent
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C41+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BristolKingsWeston b/dvb-t/uk-BristolKingsWeston
index 37fa9e1..8abd22a 100644
--- a/dvb-t/uk-BristolKingsWeston
+++ b/dvb-t/uk-BristolKingsWeston
@@ -5,7 +5,6 @@
 # location and provider: UK, Bristol Kings Weston
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C43 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Bromsgrove b/dvb-t/uk-Bromsgrove
index 2ca86fc..8956ede 100644
--- a/dvb-t/uk-Bromsgrove
+++ b/dvb-t/uk-Bromsgrove
@@ -5,7 +5,6 @@
 # location and provider: UK, Bromsgrove
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-BrougherMountain b/dvb-t/uk-BrougherMountain
index 628c899..99c04a4 100644
--- a/dvb-t/uk-BrougherMountain
+++ b/dvb-t/uk-BrougherMountain
@@ -5,7 +5,6 @@
 # location and provider: UK, Brougher Mountain
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Caldbeck b/dvb-t/uk-Caldbeck
index dc44b14..ad580f9 100644
--- a/dvb-t/uk-Caldbeck
+++ b/dvb-t/uk-Caldbeck
@@ -5,7 +5,6 @@
 # location and provider: UK, Caldbeck
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C25- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-CaradonHill b/dvb-t/uk-CaradonHill
index 4d6b328..9facc28 100644
--- a/dvb-t/uk-CaradonHill
+++ b/dvb-t/uk-CaradonHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Caradon Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Carmel b/dvb-t/uk-Carmel
index 2c6e977..9e78dfd 100644
--- a/dvb-t/uk-Carmel
+++ b/dvb-t/uk-Carmel
@@ -5,7 +5,6 @@
 # location and provider: UK, Carmel
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Chatton b/dvb-t/uk-Chatton
index 8aa1a9b..4d40a46 100644
--- a/dvb-t/uk-Chatton
+++ b/dvb-t/uk-Chatton
@@ -5,7 +5,6 @@
 # location and provider: UK, Chatton
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C45 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Chesterfield b/dvb-t/uk-Chesterfield
index fe9826f..38bedb9 100644
--- a/dvb-t/uk-Chesterfield
+++ b/dvb-t/uk-Chesterfield
@@ -5,7 +5,6 @@
 # location and provider: UK, Chesterfield
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Craigkelly b/dvb-t/uk-Craigkelly
index 72241ff..8249481 100644
--- a/dvb-t/uk-Craigkelly
+++ b/dvb-t/uk-Craigkelly
@@ -5,7 +5,6 @@
 # location and provider: UK, Craigkelly
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-CrystalPalace b/dvb-t/uk-CrystalPalace
index dc02b4e..3d17dd8 100644
--- a/dvb-t/uk-CrystalPalace
+++ b/dvb-t/uk-CrystalPalace
@@ -5,7 +5,6 @@
 # location and provider: UK, Crystal Palace
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C23 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Darvel b/dvb-t/uk-Darvel
index 8512ba7..fb5ba0f 100644
--- a/dvb-t/uk-Darvel
+++ b/dvb-t/uk-Darvel
@@ -5,7 +5,6 @@
 # location and provider: UK, Darvel
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C22- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Divis b/dvb-t/uk-Divis
index 11fdd96..4dbc6c5 100644
--- a/dvb-t/uk-Divis
+++ b/dvb-t/uk-Divis
@@ -5,7 +5,6 @@
 # location and provider: UK, Divis
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Dover b/dvb-t/uk-Dover
index fa1f3ef..15fd270 100644
--- a/dvb-t/uk-Dover
+++ b/dvb-t/uk-Dover
@@ -5,7 +5,6 @@
 # location and provider: UK, Dover
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C50 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Durris b/dvb-t/uk-Durris
index 99156f9..8cb94ec 100644
--- a/dvb-t/uk-Durris
+++ b/dvb-t/uk-Durris
@@ -5,7 +5,6 @@
 # location and provider: UK, Durris
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Eitshal b/dvb-t/uk-Eitshal
index 936dfea..3901c12 100644
--- a/dvb-t/uk-Eitshal
+++ b/dvb-t/uk-Eitshal
@@ -5,7 +5,6 @@
 # location and provider: UK, Eitshal
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-EmleyMoor b/dvb-t/uk-EmleyMoor
index 1ad73a9..c9c01d7 100644
--- a/dvb-t/uk-EmleyMoor
+++ b/dvb-t/uk-EmleyMoor
@@ -5,7 +5,6 @@
 # location and provider: UK, Emley Moor
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C47 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Fenham b/dvb-t/uk-Fenham
index 16067bf..f3dea67 100644
--- a/dvb-t/uk-Fenham
+++ b/dvb-t/uk-Fenham
@@ -5,7 +5,6 @@
 # location and provider: UK, Fenham
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Fenton b/dvb-t/uk-Fenton
index 219d23d..656ff48 100644
--- a/dvb-t/uk-Fenton
+++ b/dvb-t/uk-Fenton
@@ -5,7 +5,6 @@
 # location and provider: UK, Fenton
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C24 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Ferryside b/dvb-t/uk-Ferryside
index 186f199..71c2e12 100644
--- a/dvb-t/uk-Ferryside
+++ b/dvb-t/uk-Ferryside
@@ -5,7 +5,6 @@
 # location and provider: UK, Ferryside
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C21+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Guildford b/dvb-t/uk-Guildford
index b91944c..ab56161 100644
--- a/dvb-t/uk-Guildford
+++ b/dvb-t/uk-Guildford
@@ -5,7 +5,6 @@
 # location and provider: UK, Guildford
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C43 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Hannington b/dvb-t/uk-Hannington
index ee208bf..d3bbc75 100644
--- a/dvb-t/uk-Hannington
+++ b/dvb-t/uk-Hannington
@@ -5,7 +5,6 @@
 # location and provider: UK, Hannington
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C45 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Hastings b/dvb-t/uk-Hastings
index c8361c5..520c86a 100644
--- a/dvb-t/uk-Hastings
+++ b/dvb-t/uk-Hastings
@@ -5,7 +5,6 @@
 # location and provider: UK, Hastings
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C25 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Heathfield b/dvb-t/uk-Heathfield
index 4515b72..fda6fe0 100644
--- a/dvb-t/uk-Heathfield
+++ b/dvb-t/uk-Heathfield
@@ -5,7 +5,6 @@
 # location and provider: UK, Heathfield
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C52 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-HemelHempstead b/dvb-t/uk-HemelHempstead
index fd8c791..0116d4e 100644
--- a/dvb-t/uk-HemelHempstead
+++ b/dvb-t/uk-HemelHempstead
@@ -5,7 +5,6 @@
 # location and provider: UK, Hemel Hempstead
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C44 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-HuntshawCross b/dvb-t/uk-HuntshawCross
index 6c63ad6..3b2b964 100644
--- a/dvb-t/uk-HuntshawCross
+++ b/dvb-t/uk-HuntshawCross
@@ -5,7 +5,6 @@
 # location and provider: UK, Huntshaw Cross
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C50 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Idle b/dvb-t/uk-Idle
index 57798f6..e736ca9 100644
--- a/dvb-t/uk-Idle
+++ b/dvb-t/uk-Idle
@@ -5,7 +5,6 @@
 # location and provider: UK, Idle
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C24 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-KeelylangHill b/dvb-t/uk-KeelylangHill
index 90a1e35..ac90b5d 100644
--- a/dvb-t/uk-KeelylangHill
+++ b/dvb-t/uk-KeelylangHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Keelylang Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C46 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Keighley b/dvb-t/uk-Keighley
index 6695702..ab86448 100644
--- a/dvb-t/uk-Keighley
+++ b/dvb-t/uk-Keighley
@@ -5,7 +5,6 @@
 # location and provider: UK, Keighley
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C49 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-KilveyHill b/dvb-t/uk-KilveyHill
index cdfb7a0..5919ee3 100644
--- a/dvb-t/uk-KilveyHill
+++ b/dvb-t/uk-KilveyHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Kilvey Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C23 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-KnockMore b/dvb-t/uk-KnockMore
index 5340741..3d7e41f 100644
--- a/dvb-t/uk-KnockMore
+++ b/dvb-t/uk-KnockMore
@@ -5,7 +5,6 @@
 # location and provider: UK, Knockmore
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Lancaster b/dvb-t/uk-Lancaster
index 75093b4..0694e7a 100644
--- a/dvb-t/uk-Lancaster
+++ b/dvb-t/uk-Lancaster
@@ -5,7 +5,6 @@
 # location and provider: UK, Lancaster
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-LarkStoke b/dvb-t/uk-LarkStoke
index 5c36f5d..3d7a6fb 100644
--- a/dvb-t/uk-LarkStoke
+++ b/dvb-t/uk-LarkStoke
@@ -5,7 +5,6 @@
 # location and provider: UK, Lark Stoke
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Limavady b/dvb-t/uk-Limavady
index 908f833..977b973 100644
--- a/dvb-t/uk-Limavady
+++ b/dvb-t/uk-Limavady
@@ -5,7 +5,6 @@
 # location and provider: UK, Limavady
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C50 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Llanddona b/dvb-t/uk-Llanddona
index fcc9f3f..88067ee 100644
--- a/dvb-t/uk-Llanddona
+++ b/dvb-t/uk-Llanddona
@@ -5,7 +5,6 @@
 # location and provider: UK, Llanddona
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C57 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Malvern b/dvb-t/uk-Malvern
index 9f62921..66c10e2 100644
--- a/dvb-t/uk-Malvern
+++ b/dvb-t/uk-Malvern
@@ -5,7 +5,6 @@
 # location and provider: UK, Malvern
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C53 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Mendip b/dvb-t/uk-Mendip
index 377d7d5..a7e34b6 100644
--- a/dvb-t/uk-Mendip
+++ b/dvb-t/uk-Mendip
@@ -5,7 +5,6 @@
 # location and provider: UK, Mendip
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C49 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Midhurst b/dvb-t/uk-Midhurst
index 4d22282..37416ad 100644
--- a/dvb-t/uk-Midhurst
+++ b/dvb-t/uk-Midhurst
@@ -5,7 +5,6 @@
 # location and provider: UK, Midhurst
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C55 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-MoelyParc b/dvb-t/uk-MoelyParc
index f39e38f..d74fd28 100644
--- a/dvb-t/uk-MoelyParc
+++ b/dvb-t/uk-MoelyParc
@@ -5,7 +5,6 @@
 # location and provider: UK, Moel y Parc
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C45 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Nottingham b/dvb-t/uk-Nottingham
index 4aacea3..8112ec7 100644
--- a/dvb-t/uk-Nottingham
+++ b/dvb-t/uk-Nottingham
@@ -5,7 +5,6 @@
 # location and provider: UK, Nottingham
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-OliversMount b/dvb-t/uk-OliversMount
index 967af60..898e29a 100644
--- a/dvb-t/uk-OliversMount
+++ b/dvb-t/uk-OliversMount
@@ -5,7 +5,6 @@
 # location and provider: UK, Olivers Mount
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C57 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Oxford b/dvb-t/uk-Oxford
index 4326cd2..5579a48 100644
--- a/dvb-t/uk-Oxford
+++ b/dvb-t/uk-Oxford
@@ -5,7 +5,6 @@
 # location and provider: UK, Oxford
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C53+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-PendleForest b/dvb-t/uk-PendleForest
index 57ede3b..7bcdd5a 100644
--- a/dvb-t/uk-PendleForest
+++ b/dvb-t/uk-PendleForest
@@ -5,7 +5,6 @@
 # location and provider: UK, Pendle Forest
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Plympton b/dvb-t/uk-Plympton
index e50eb62..d3bce92 100644
--- a/dvb-t/uk-Plympton
+++ b/dvb-t/uk-Plympton
@@ -5,7 +5,6 @@
 # location and provider: UK, Plympton
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C54 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-PontopPike b/dvb-t/uk-PontopPike
index 02157b8..2ceb229 100644
--- a/dvb-t/uk-PontopPike
+++ b/dvb-t/uk-PontopPike
@@ -5,7 +5,6 @@
 # location and provider: UK, Pontop Pike
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C58 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Pontypool b/dvb-t/uk-Pontypool
index 627ea06..b66c837 100644
--- a/dvb-t/uk-Pontypool
+++ b/dvb-t/uk-Pontypool
@@ -5,7 +5,6 @@
 # location and provider: UK, Pontypool
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C23+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Preseli b/dvb-t/uk-Preseli
index 2204f60..72e71c2 100644
--- a/dvb-t/uk-Preseli
+++ b/dvb-t/uk-Preseli
@@ -5,7 +5,6 @@
 # location and provider: UK, Preseli
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C43+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Redruth b/dvb-t/uk-Redruth
index e5705df..650ca61 100644
--- a/dvb-t/uk-Redruth
+++ b/dvb-t/uk-Redruth
@@ -5,7 +5,6 @@
 # location and provider: UK, Redruth
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C44+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Reigate b/dvb-t/uk-Reigate
index 07d96a3..b845d37 100644
--- a/dvb-t/uk-Reigate
+++ b/dvb-t/uk-Reigate
@@ -5,7 +5,6 @@
 # location and provider: UK, Reigate
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-RidgeHill b/dvb-t/uk-RidgeHill
index 3ef0ad2..a6ac23b 100644
--- a/dvb-t/uk-RidgeHill
+++ b/dvb-t/uk-RidgeHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Ridge Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Rosemarkie b/dvb-t/uk-Rosemarkie
index 4d44f4e..7fbd7e3 100644
--- a/dvb-t/uk-Rosemarkie
+++ b/dvb-t/uk-Rosemarkie
@@ -5,7 +5,6 @@
 # location and provider: UK, Rosemarkie
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C45 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Rosneath b/dvb-t/uk-Rosneath
index 6f370c4..d61d76c 100644
--- a/dvb-t/uk-Rosneath
+++ b/dvb-t/uk-Rosneath
@@ -5,7 +5,6 @@
 # location and provider: UK, Rosneath VP
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C49 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Rowridge b/dvb-t/uk-Rowridge
index a01b14c..16f781d 100644
--- a/dvb-t/uk-Rowridge
+++ b/dvb-t/uk-Rowridge
@@ -5,7 +5,6 @@
 # location and provider: UK, Rowridge
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C24 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-RumsterForest b/dvb-t/uk-RumsterForest
index e7f5eb6..1f229cd 100644
--- a/dvb-t/uk-RumsterForest
+++ b/dvb-t/uk-RumsterForest
@@ -5,7 +5,6 @@
 # location and provider: UK, Rumster Forest
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Saddleworth b/dvb-t/uk-Saddleworth
index 1672efe..6a4b2d9 100644
--- a/dvb-t/uk-Saddleworth
+++ b/dvb-t/uk-Saddleworth
@@ -5,7 +5,6 @@
 # location and provider: UK, Saddleworth
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C45 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Salisbury b/dvb-t/uk-Salisbury
index d15bb12..17f24a9 100644
--- a/dvb-t/uk-Salisbury
+++ b/dvb-t/uk-Salisbury
@@ -5,7 +5,6 @@
 # location and provider: UK, Salisbury
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C57 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-SandyHeath b/dvb-t/uk-SandyHeath
index 986e38c..5b34230 100644
--- a/dvb-t/uk-SandyHeath
+++ b/dvb-t/uk-SandyHeath
@@ -5,7 +5,6 @@
 # location and provider: UK, Sandy Heath
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Selkirk b/dvb-t/uk-Selkirk
index 1671834..ee4d822 100644
--- a/dvb-t/uk-Selkirk
+++ b/dvb-t/uk-Selkirk
@@ -5,7 +5,6 @@
 # location and provider: UK, Selkirk
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C50 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Sheffield b/dvb-t/uk-Sheffield
index 177a81d..4604ba1 100644
--- a/dvb-t/uk-Sheffield
+++ b/dvb-t/uk-Sheffield
@@ -5,7 +5,6 @@
 # location and provider: UK, Sheffield
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C27 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-StocklandHill b/dvb-t/uk-StocklandHill
index 898373e..cbd1bf1 100644
--- a/dvb-t/uk-StocklandHill
+++ b/dvb-t/uk-StocklandHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Stockland Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Storeton b/dvb-t/uk-Storeton
index 7bb44ba..15f8869 100644
--- a/dvb-t/uk-Storeton
+++ b/dvb-t/uk-Storeton
@@ -5,7 +5,6 @@
 # location and provider: UK, Storeton
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Sudbury b/dvb-t/uk-Sudbury
index 8fc1ac3..3be0947 100644
--- a/dvb-t/uk-Sudbury
+++ b/dvb-t/uk-Sudbury
@@ -5,7 +5,6 @@
 # location and provider: UK, Sudbury
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C44 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-SuttonColdfield b/dvb-t/uk-SuttonColdfield
index e656135..ff1deed 100644
--- a/dvb-t/uk-SuttonColdfield
+++ b/dvb-t/uk-SuttonColdfield
@@ -5,7 +5,6 @@
 # location and provider: UK, Sutton Coldfield
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C43 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Tacolneston b/dvb-t/uk-Tacolneston
index 071de3e..5b7051b 100644
--- a/dvb-t/uk-Tacolneston
+++ b/dvb-t/uk-Tacolneston
@@ -5,7 +5,6 @@
 # location and provider: UK, Tacolneston
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C55- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-TheWrekin b/dvb-t/uk-TheWrekin
index eb5ea30..fe58789 100644
--- a/dvb-t/uk-TheWrekin
+++ b/dvb-t/uk-TheWrekin
@@ -5,7 +5,6 @@
 # location and provider: UK, The Wrekin
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C26 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Torosay b/dvb-t/uk-Torosay
index 530bf2e..74b96e4 100644
--- a/dvb-t/uk-Torosay
+++ b/dvb-t/uk-Torosay
@@ -5,7 +5,6 @@
 # location and provider: UK, Torosay
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C28 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-TunbridgeWells b/dvb-t/uk-TunbridgeWells
index d539532..47ed282 100644
--- a/dvb-t/uk-TunbridgeWells
+++ b/dvb-t/uk-TunbridgeWells
@@ -5,7 +5,6 @@
 # location and provider: UK, Tunbridge Wells
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C52 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Waltham b/dvb-t/uk-Waltham
index 1eb6978..789ae68 100644
--- a/dvb-t/uk-Waltham
+++ b/dvb-t/uk-Waltham
@@ -5,7 +5,6 @@
 # location and provider: UK, Waltham
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C49 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-Wenvoe b/dvb-t/uk-Wenvoe
index 54e1d6d..7d21b7a 100644
--- a/dvb-t/uk-Wenvoe
+++ b/dvb-t/uk-Wenvoe
@@ -5,7 +5,6 @@
 # location and provider: UK, Wenvoe
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C41+ BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-WhitehawkHill b/dvb-t/uk-WhitehawkHill
index f1d60c3..3cbabbb 100644
--- a/dvb-t/uk-WhitehawkHill
+++ b/dvb-t/uk-WhitehawkHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Whitehawk Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C60- BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/uk-WinterHill b/dvb-t/uk-WinterHill
index af1f3d1..15546d7 100644
--- a/dvb-t/uk-WinterHill
+++ b/dvb-t/uk-WinterHill
@@ -5,7 +5,6 @@
 # location and provider: UK, Winter Hill
 # date (yyyy-mm-dd)    : 2014-03-25
 #
-# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [<plp_id>] [# comment]
 #----------------------------------------------------------------------------------------------
 [C50 BBC A]
 	DELIVERY_SYSTEM = DVBT
diff --git a/dvb-t/vn-Hanoi b/dvb-t/vn-Hanoi
index 3f3a6d9..abb9695 100644
--- a/dvb-t/vn-Hanoi
+++ b/dvb-t/vn-Hanoi
@@ -1,6 +1,5 @@
 # Hanoi - Vietnam - DVB-T by VTC
 # contributed by Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 514000000
diff --git a/dvb-t/vn-Thaibinh b/dvb-t/vn-Thaibinh
index f44d930..f340948 100644
--- a/dvb-t/vn-Thaibinh
+++ b/dvb-t/vn-Thaibinh
@@ -1,6 +1,5 @@
 # Thaibinh - Vietnam - DVB-T by VTC
 # contributed by Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
-- 
2.1.1

