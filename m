Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56436 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaDRATB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 20:19:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olliver Schinagl <oliver@schinagl.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] add dvbv5 DVB-T/T2 scan files for Digita Finland
Date: Fri, 18 Apr 2014 03:18:37 +0300
Message-Id: <1397780317-19593-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 dvbv5_dvb-t/fi-Aanekoski               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Aanekoski_Konginkangas  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Ahtari                  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Alajarvi                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Anjalankoski_Ruotila    | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Enontekio_Ahovaara      | 13 +++++++++++++
 dvbv5_dvb-t/fi-Enontekio_Hetta         | 13 +++++++++++++
 dvbv5_dvb-t/fi-Enontekio_Kuttanen      | 13 +++++++++++++
 dvbv5_dvb-t/fi-Espoo                   | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Eurajoki                | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Fiskars                 | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Haapavesi               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Hameenlinna_Painokangas | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Hanko                   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Hartola                 | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Heinavesi               | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Heinola                 | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Hyrynsalmi              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara  | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka     | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Hyvinkaa                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Ii_Raiskio              | 13 +++++++++++++
 dvbv5_dvb-t/fi-Iisalmi                 | 13 +++++++++++++
 dvbv5_dvb-t/fi-Ikaalinen               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Ikaalinen_Riitiala      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Inari                   | 13 +++++++++++++
 dvbv5_dvb-t/fi-Inari_Janispaa          | 13 +++++++++++++
 dvbv5_dvb-t/fi-Inari_Naatamo           | 13 +++++++++++++
 dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara | 13 +++++++++++++
 dvbv5_dvb-t/fi-Jalasjarvi              | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jamsa_Halli             | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jamsa_Kaipola           | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jamsa_Matkosvuori       | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jamsa_Ouninpohja        | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Jamsankoski             | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Joensuu_Vestinkallio    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Joroinen_Puukkola       | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Joutsa_Lankia           | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Joutseno                | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Juupajoki_Kopsamo       | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Juva                    | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jyvaskyla               | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kaavi_Sivakkavaara      | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kajaani_Pollyvaara      | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kalajoki                | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kangaslampi             | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kankaanpaa              | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Karigasniemi            | 13 +++++++++++++
 dvbv5_dvb-t/fi-Karkkila                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Karstula                | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Karvia                  | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kaunispaa               | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kerimaki                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Keuruu                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Keuruu_Haapamaki        | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kihnio                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kiihtelysvaara          | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kilpisjarvi             | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kittila_Levitunturi     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kolari_Vuolittaja       | 13 +++++++++++++
 dvbv5_dvb-t/fi-Koli                    | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Korppoo                 | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kruunupyy               | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmo_Haukela           | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmo_Lentiira          | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmo_Niva              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmoinen               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Kuopio                  | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kurikka_Kesti           | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kustavi_Viherlahti      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Kuusamo_Hamppulampi     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho     | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Lahti                   | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Lapua                   | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Laukaa                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Laukaa_Vihtavuori       | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Lavia                   | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Lohja                   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Loimaa                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Luhanka                 | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Luopioinen              | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Mantta                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Mantyharju              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Mikkeli                 | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Muonio_Olostunturi      | 13 +++++++++++++
 dvbv5_dvb-t/fi-Nilsia                  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Nilsia_Pisa             | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Nokia                   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Nokia_Siuro             | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola    | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Nuorgam_Njallavaara     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Nuorgam_raja            | 13 +++++++++++++
 dvbv5_dvb-t/fi-Nurmes_Konnanvaara      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Nurmes_Kortevaara       | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Orivesi_Talviainen      | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Oulu                    | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Padasjoki               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Padasjoki_Arrakoski     | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Paltamo_Kivesvaara      | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Parainen_Houtskari      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Parikkala               | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Parkano_Sopukallio      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Pello                   | 13 +++++++++++++
 dvbv5_dvb-t/fi-Pello_Ratasvaara        | 13 +++++++++++++
 dvbv5_dvb-t/fi-Perho                   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Pernaja                 | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu   | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Pihtipudas              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Porvoo_Suomenkyla       | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Posio                   | 13 +++++++++++++
 dvbv5_dvb-t/fi-Pudasjarvi              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Puolanka                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Pyhatunturi             | 13 +++++++++++++
 dvbv5_dvb-t/fi-Pyhavuori               | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Raahe_Mestauskallio     | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Raahe_Piehinki          | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Ranua_Haasionmaa        | 13 +++++++++++++
 dvbv5_dvb-t/fi-Ranua_Leppiaho          | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rautavaara_Angervikko   | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Rautjarvi_Simpele       | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Ristijarvi              | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi               | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara    | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Rantalaki     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Sonka         | 13 +++++++++++++
 dvbv5_dvb-t/fi-Rovaniemi_Sorviselka    | 13 +++++++++++++
 dvbv5_dvb-t/fi-Ruka                    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Ruovesi_Storminiemi     | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Saarijarvi              | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Saarijarvi_Kalmari      | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Saarijarvi_Mahlu        | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Salla_Hirvasvaara       | 13 +++++++++++++
 dvbv5_dvb-t/fi-Salla_Ihistysjanka      | 13 +++++++++++++
 dvbv5_dvb-t/fi-Salla_Naruska           | 13 +++++++++++++
 dvbv5_dvb-t/fi-Salla_Sallatunturi      | 13 +++++++++++++
 dvbv5_dvb-t/fi-Salla_Sarivaara         | 13 +++++++++++++
 dvbv5_dvb-t/fi-Salo_Isokyla            | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Savukoski_Martti        | 13 +++++++++++++
 dvbv5_dvb-t/fi-Savukoski_Tanhua        | 13 +++++++++++++
 dvbv5_dvb-t/fi-Siilinjarvi             | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Simo_Viantie            | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Sipoo_Norrkulla         | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Sodankyla_Pittiovaara   | 13 +++++++++++++
 dvbv5_dvb-t/fi-Sodankyla_Vuotso        | 13 +++++++++++++
 dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Suomussalmi_Ammansaari  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Suomussalmi_Juntusranta | 13 +++++++++++++
 dvbv5_dvb-t/fi-Suomussalmi_Myllylahti  | 13 +++++++++++++
 dvbv5_dvb-t/fi-Sysma_Liikola           | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Taivalkoski             | 13 +++++++++++++
 dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara | 13 +++++++++++++
 dvbv5_dvb-t/fi-Tammela                 | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Tammisaari              | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Tampere                 | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Tampere_Pyynikki        | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Tervola                 | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Turku                   | 28 ++++++++++++++++++++++++++++
 dvbv5_dvb-t/fi-Utsjoki                 | 13 +++++++++++++
 dvbv5_dvb-t/fi-Utsjoki_Nuvvus          | 13 +++++++++++++
 dvbv5_dvb-t/fi-Utsjoki_Outakoski       | 13 +++++++++++++
 dvbv5_dvb-t/fi-Utsjoki_Polvarniemi     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto     | 13 +++++++++++++
 dvbv5_dvb-t/fi-Utsjoki_Tenola          | 13 +++++++++++++
 dvbv5_dvb-t/fi-Uusikaupunki_Orivo      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Vaala                   | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Vaasa                   | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Valtimo                 | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Vammala_Jyranvuori      | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Vammala_Roismala        | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Vammala_Savi            | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Vantaa_Hakunila         | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki  | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Virrat_Lappavuori       | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Vuokatti                | 23 +++++++++++++++++++++++
 dvbv5_dvb-t/fi-Ylitornio_Ainiovaara    | 18 ++++++++++++++++++
 dvbv5_dvb-t/fi-Ylitornio_Raanujarvi    | 13 +++++++++++++
 dvbv5_dvb-t/fi-Yllas                   | 13 +++++++++++++
 dvbv5_dvb-t/fi-Yllasjarvi              | 13 +++++++++++++
 192 files changed, 3651 insertions(+)
 create mode 100644 dvbv5_dvb-t/fi-Aanekoski
 create mode 100644 dvbv5_dvb-t/fi-Aanekoski_Konginkangas
 create mode 100644 dvbv5_dvb-t/fi-Ahtari
 create mode 100644 dvbv5_dvb-t/fi-Alajarvi
 create mode 100644 dvbv5_dvb-t/fi-Anjalankoski_Ruotila
 create mode 100644 dvbv5_dvb-t/fi-Enontekio_Ahovaara
 create mode 100644 dvbv5_dvb-t/fi-Enontekio_Hetta
 create mode 100644 dvbv5_dvb-t/fi-Enontekio_Kuttanen
 create mode 100644 dvbv5_dvb-t/fi-Espoo
 create mode 100644 dvbv5_dvb-t/fi-Eurajoki
 create mode 100644 dvbv5_dvb-t/fi-Fiskars
 create mode 100644 dvbv5_dvb-t/fi-Haapavesi
 create mode 100644 dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski
 create mode 100644 dvbv5_dvb-t/fi-Hameenlinna_Painokangas
 create mode 100644 dvbv5_dvb-t/fi-Hanko
 create mode 100644 dvbv5_dvb-t/fi-Hartola
 create mode 100644 dvbv5_dvb-t/fi-Heinavesi
 create mode 100644 dvbv5_dvb-t/fi-Heinola
 create mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi
 create mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara
 create mode 100644 dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka
 create mode 100644 dvbv5_dvb-t/fi-Hyvinkaa
 create mode 100644 dvbv5_dvb-t/fi-Ii_Raiskio
 create mode 100644 dvbv5_dvb-t/fi-Iisalmi
 create mode 100644 dvbv5_dvb-t/fi-Ikaalinen
 create mode 100644 dvbv5_dvb-t/fi-Ikaalinen_Riitiala
 create mode 100644 dvbv5_dvb-t/fi-Inari
 create mode 100644 dvbv5_dvb-t/fi-Inari_Janispaa
 create mode 100644 dvbv5_dvb-t/fi-Inari_Naatamo
 create mode 100644 dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara
 create mode 100644 dvbv5_dvb-t/fi-Jalasjarvi
 create mode 100644 dvbv5_dvb-t/fi-Jamsa_Halli
 create mode 100644 dvbv5_dvb-t/fi-Jamsa_Kaipola
 create mode 100644 dvbv5_dvb-t/fi-Jamsa_Matkosvuori
 create mode 100644 dvbv5_dvb-t/fi-Jamsa_Ouninpohja
 create mode 100644 dvbv5_dvb-t/fi-Jamsankoski
 create mode 100644 dvbv5_dvb-t/fi-Joensuu_Vestinkallio
 create mode 100644 dvbv5_dvb-t/fi-Joroinen_Puukkola
 create mode 100644 dvbv5_dvb-t/fi-Joutsa_Lankia
 create mode 100644 dvbv5_dvb-t/fi-Joutseno
 create mode 100644 dvbv5_dvb-t/fi-Juupajoki_Kopsamo
 create mode 100644 dvbv5_dvb-t/fi-Juva
 create mode 100644 dvbv5_dvb-t/fi-Jyvaskyla
 create mode 100644 dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski
 create mode 100644 dvbv5_dvb-t/fi-Kaavi_Sivakkavaara
 create mode 100644 dvbv5_dvb-t/fi-Kajaani_Pollyvaara
 create mode 100644 dvbv5_dvb-t/fi-Kalajoki
 create mode 100644 dvbv5_dvb-t/fi-Kangaslampi
 create mode 100644 dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki
 create mode 100644 dvbv5_dvb-t/fi-Kankaanpaa
 create mode 100644 dvbv5_dvb-t/fi-Karigasniemi
 create mode 100644 dvbv5_dvb-t/fi-Karkkila
 create mode 100644 dvbv5_dvb-t/fi-Karstula
 create mode 100644 dvbv5_dvb-t/fi-Karvia
 create mode 100644 dvbv5_dvb-t/fi-Kaunispaa
 create mode 100644 dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi
 create mode 100644 dvbv5_dvb-t/fi-Kerimaki
 create mode 100644 dvbv5_dvb-t/fi-Keuruu
 create mode 100644 dvbv5_dvb-t/fi-Keuruu_Haapamaki
 create mode 100644 dvbv5_dvb-t/fi-Kihnio
 create mode 100644 dvbv5_dvb-t/fi-Kiihtelysvaara
 create mode 100644 dvbv5_dvb-t/fi-Kilpisjarvi
 create mode 100644 dvbv5_dvb-t/fi-Kittila_Levitunturi
 create mode 100644 dvbv5_dvb-t/fi-Kolari_Vuolittaja
 create mode 100644 dvbv5_dvb-t/fi-Koli
 create mode 100644 dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori
 create mode 100644 dvbv5_dvb-t/fi-Korppoo
 create mode 100644 dvbv5_dvb-t/fi-Kruunupyy
 create mode 100644 dvbv5_dvb-t/fi-Kuhmo_Haukela
 create mode 100644 dvbv5_dvb-t/fi-Kuhmo_Lentiira
 create mode 100644 dvbv5_dvb-t/fi-Kuhmo_Niva
 create mode 100644 dvbv5_dvb-t/fi-Kuhmoinen
 create mode 100644 dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi
 create mode 100644 dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen
 create mode 100644 dvbv5_dvb-t/fi-Kuopio
 create mode 100644 dvbv5_dvb-t/fi-Kurikka_Kesti
 create mode 100644 dvbv5_dvb-t/fi-Kustavi_Viherlahti
 create mode 100644 dvbv5_dvb-t/fi-Kuusamo_Hamppulampi
 create mode 100644 dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho
 create mode 100644 dvbv5_dvb-t/fi-Lahti
 create mode 100644 dvbv5_dvb-t/fi-Lapua
 create mode 100644 dvbv5_dvb-t/fi-Laukaa
 create mode 100644 dvbv5_dvb-t/fi-Laukaa_Vihtavuori
 create mode 100644 dvbv5_dvb-t/fi-Lavia
 create mode 100644 dvbv5_dvb-t/fi-Lohja
 create mode 100644 dvbv5_dvb-t/fi-Loimaa
 create mode 100644 dvbv5_dvb-t/fi-Luhanka
 create mode 100644 dvbv5_dvb-t/fi-Luopioinen
 create mode 100644 dvbv5_dvb-t/fi-Mantta
 create mode 100644 dvbv5_dvb-t/fi-Mantyharju
 create mode 100644 dvbv5_dvb-t/fi-Mikkeli
 create mode 100644 dvbv5_dvb-t/fi-Muonio_Olostunturi
 create mode 100644 dvbv5_dvb-t/fi-Nilsia
 create mode 100644 dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi
 create mode 100644 dvbv5_dvb-t/fi-Nilsia_Pisa
 create mode 100644 dvbv5_dvb-t/fi-Nokia
 create mode 100644 dvbv5_dvb-t/fi-Nokia_Siuro
 create mode 100644 dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola
 create mode 100644 dvbv5_dvb-t/fi-Nuorgam_Njallavaara
 create mode 100644 dvbv5_dvb-t/fi-Nuorgam_raja
 create mode 100644 dvbv5_dvb-t/fi-Nurmes_Konnanvaara
 create mode 100644 dvbv5_dvb-t/fi-Nurmes_Kortevaara
 create mode 100644 dvbv5_dvb-t/fi-Orivesi_Talviainen
 create mode 100644 dvbv5_dvb-t/fi-Oulu
 create mode 100644 dvbv5_dvb-t/fi-Padasjoki
 create mode 100644 dvbv5_dvb-t/fi-Padasjoki_Arrakoski
 create mode 100644 dvbv5_dvb-t/fi-Paltamo_Kivesvaara
 create mode 100644 dvbv5_dvb-t/fi-Parainen_Houtskari
 create mode 100644 dvbv5_dvb-t/fi-Parikkala
 create mode 100644 dvbv5_dvb-t/fi-Parkano_Sopukallio
 create mode 100644 dvbv5_dvb-t/fi-Pello
 create mode 100644 dvbv5_dvb-t/fi-Pello_Ratasvaara
 create mode 100644 dvbv5_dvb-t/fi-Perho
 create mode 100644 dvbv5_dvb-t/fi-Pernaja
 create mode 100644 dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu
 create mode 100644 dvbv5_dvb-t/fi-Pihtipudas
 create mode 100644 dvbv5_dvb-t/fi-Porvoo_Suomenkyla
 create mode 100644 dvbv5_dvb-t/fi-Posio
 create mode 100644 dvbv5_dvb-t/fi-Pudasjarvi
 create mode 100644 dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote
 create mode 100644 dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara
 create mode 100644 dvbv5_dvb-t/fi-Puolanka
 create mode 100644 dvbv5_dvb-t/fi-Pyhatunturi
 create mode 100644 dvbv5_dvb-t/fi-Pyhavuori
 create mode 100644 dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi
 create mode 100644 dvbv5_dvb-t/fi-Raahe_Mestauskallio
 create mode 100644 dvbv5_dvb-t/fi-Raahe_Piehinki
 create mode 100644 dvbv5_dvb-t/fi-Ranua_Haasionmaa
 create mode 100644 dvbv5_dvb-t/fi-Ranua_Leppiaho
 create mode 100644 dvbv5_dvb-t/fi-Rautavaara_Angervikko
 create mode 100644 dvbv5_dvb-t/fi-Rautjarvi_Simpele
 create mode 100644 dvbv5_dvb-t/fi-Ristijarvi
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Rantalaki
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Sonka
 create mode 100644 dvbv5_dvb-t/fi-Rovaniemi_Sorviselka
 create mode 100644 dvbv5_dvb-t/fi-Ruka
 create mode 100644 dvbv5_dvb-t/fi-Ruovesi_Storminiemi
 create mode 100644 dvbv5_dvb-t/fi-Saarijarvi
 create mode 100644 dvbv5_dvb-t/fi-Saarijarvi_Kalmari
 create mode 100644 dvbv5_dvb-t/fi-Saarijarvi_Mahlu
 create mode 100644 dvbv5_dvb-t/fi-Salla_Hirvasvaara
 create mode 100644 dvbv5_dvb-t/fi-Salla_Ihistysjanka
 create mode 100644 dvbv5_dvb-t/fi-Salla_Naruska
 create mode 100644 dvbv5_dvb-t/fi-Salla_Sallatunturi
 create mode 100644 dvbv5_dvb-t/fi-Salla_Sarivaara
 create mode 100644 dvbv5_dvb-t/fi-Salo_Isokyla
 create mode 100644 dvbv5_dvb-t/fi-Savukoski_Martti
 create mode 100644 dvbv5_dvb-t/fi-Savukoski_Tanhua
 create mode 100644 dvbv5_dvb-t/fi-Siilinjarvi
 create mode 100644 dvbv5_dvb-t/fi-Simo_Viantie
 create mode 100644 dvbv5_dvb-t/fi-Sipoo_Norrkulla
 create mode 100644 dvbv5_dvb-t/fi-Sodankyla_Pittiovaara
 create mode 100644 dvbv5_dvb-t/fi-Sodankyla_Vuotso
 create mode 100644 dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki
 create mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki
 create mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Ammansaari
 create mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Juntusranta
 create mode 100644 dvbv5_dvb-t/fi-Suomussalmi_Myllylahti
 create mode 100644 dvbv5_dvb-t/fi-Sysma_Liikola
 create mode 100644 dvbv5_dvb-t/fi-Taivalkoski
 create mode 100644 dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara
 create mode 100644 dvbv5_dvb-t/fi-Tammela
 create mode 100644 dvbv5_dvb-t/fi-Tammisaari
 create mode 100644 dvbv5_dvb-t/fi-Tampere
 create mode 100644 dvbv5_dvb-t/fi-Tampere_Pyynikki
 create mode 100644 dvbv5_dvb-t/fi-Tervola
 create mode 100644 dvbv5_dvb-t/fi-Turku
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki_Nuvvus
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki_Outakoski
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki_Polvarniemi
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto
 create mode 100644 dvbv5_dvb-t/fi-Utsjoki_Tenola
 create mode 100644 dvbv5_dvb-t/fi-Uusikaupunki_Orivo
 create mode 100644 dvbv5_dvb-t/fi-Vaala
 create mode 100644 dvbv5_dvb-t/fi-Vaasa
 create mode 100644 dvbv5_dvb-t/fi-Valtimo
 create mode 100644 dvbv5_dvb-t/fi-Vammala_Jyranvuori
 create mode 100644 dvbv5_dvb-t/fi-Vammala_Roismala
 create mode 100644 dvbv5_dvb-t/fi-Vammala_Savi
 create mode 100644 dvbv5_dvb-t/fi-Vantaa_Hakunila
 create mode 100644 dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki
 create mode 100644 dvbv5_dvb-t/fi-Virrat_Lappavuori
 create mode 100644 dvbv5_dvb-t/fi-Vuokatti
 create mode 100644 dvbv5_dvb-t/fi-Ylitornio_Ainiovaara
 create mode 100644 dvbv5_dvb-t/fi-Ylitornio_Raanujarvi
 create mode 100644 dvbv5_dvb-t/fi-Yllas
 create mode 100644 dvbv5_dvb-t/fi-Yllasjarvi

diff --git a/dvbv5_dvb-t/fi-Aanekoski b/dvbv5_dvb-t/fi-Aanekoski
new file mode 100644
index 0000000..7dda326
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Aanekoski
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Aanekoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Aanekoski_Konginkangas b/dvbv5_dvb-t/fi-Aanekoski_Konginkangas
new file mode 100644
index 0000000..ff13741
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Aanekoski_Konginkangas
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Aanekoski_Konginkangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski_Konginkangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski_Konginkangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Aanekoski_Konginkangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ahtari b/dvbv5_dvb-t/fi-Ahtari
new file mode 100644
index 0000000..aa90ea2
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ahtari
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ahtari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Ahtari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Alajarvi b/dvbv5_dvb-t/fi-Alajarvi
new file mode 100644
index 0000000..712483d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Alajarvi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Alajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Alajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Alajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
+[Alajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Anjalankoski_Ruotila b/dvbv5_dvb-t/fi-Anjalankoski_Ruotila
new file mode 100644
index 0000000..8ae1231
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Anjalankoski_Ruotila
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Anjalankoski_Ruotila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Anjalankoski_Ruotila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Anjalankoski_Ruotila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Anjalankoski_Ruotila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Anjalankoski_Ruotila]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Enontekio_Ahovaara b/dvbv5_dvb-t/fi-Enontekio_Ahovaara
new file mode 100644
index 0000000..21abdbc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Enontekio_Ahovaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Enontekio_Ahovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Enontekio_Ahovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Enontekio_Hetta b/dvbv5_dvb-t/fi-Enontekio_Hetta
new file mode 100644
index 0000000..6ff6b84
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Enontekio_Hetta
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Enontekio_Hetta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Enontekio_Hetta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Enontekio_Kuttanen b/dvbv5_dvb-t/fi-Enontekio_Kuttanen
new file mode 100644
index 0000000..f9a6af8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Enontekio_Kuttanen
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Enontekio_Kuttanen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Enontekio_Kuttanen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Espoo b/dvbv5_dvb-t/fi-Espoo
new file mode 100644
index 0000000..03296ae
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Espoo
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Espoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Espoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Espoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Espoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Espoo]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Eurajoki b/dvbv5_dvb-t/fi-Eurajoki
new file mode 100644
index 0000000..1d090a5
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Eurajoki
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Eurajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Eurajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Eurajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Eurajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Eurajoki]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Fiskars b/dvbv5_dvb-t/fi-Fiskars
new file mode 100644
index 0000000..0f84bb7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Fiskars
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Fiskars]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Fiskars]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Fiskars]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Fiskars]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Haapavesi b/dvbv5_dvb-t/fi-Haapavesi
new file mode 100644
index 0000000..8be1f62
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Haapavesi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Haapavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Haapavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Haapavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Haapavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski b/dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski
new file mode 100644
index 0000000..8a98791
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hameenkyro_Kyroskoski
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hameenkyro_Kyroskoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Hameenkyro_Kyroskoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Hameenkyro_Kyroskoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
+[Hameenkyro_Kyroskoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hameenlinna_Painokangas b/dvbv5_dvb-t/fi-Hameenlinna_Painokangas
new file mode 100644
index 0000000..9a56b2b
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hameenlinna_Painokangas
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hameenlinna_Painokangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Hameenlinna_Painokangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Hameenlinna_Painokangas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hanko b/dvbv5_dvb-t/fi-Hanko
new file mode 100644
index 0000000..ab08a14
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hanko
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hanko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Hanko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Hanko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Hanko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hartola b/dvbv5_dvb-t/fi-Hartola
new file mode 100644
index 0000000..d10df22
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hartola
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hartola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Hartola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Hartola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Heinavesi b/dvbv5_dvb-t/fi-Heinavesi
new file mode 100644
index 0000000..b33bb39
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Heinavesi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Heinavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Heinavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Heinavesi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Heinola b/dvbv5_dvb-t/fi-Heinola
new file mode 100644
index 0000000..7a6f234
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Heinola
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Heinola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Heinola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Heinola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Heinola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hyrynsalmi b/dvbv5_dvb-t/fi-Hyrynsalmi
new file mode 100644
index 0000000..e11f89a
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hyrynsalmi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hyrynsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara b/dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara
new file mode 100644
index 0000000..f402d8a
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hyrynsalmi_Kyparavaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hyrynsalmi_Kyparavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi_Kyparavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi_Kyparavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka b/dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka
new file mode 100644
index 0000000..806a3c0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hyrynsalmi_Paljakka
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hyrynsalmi_Paljakka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi_Paljakka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyrynsalmi_Paljakka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Hyvinkaa b/dvbv5_dvb-t/fi-Hyvinkaa
new file mode 100644
index 0000000..e711b16
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Hyvinkaa
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Hyvinkaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyvinkaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyvinkaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Hyvinkaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ii_Raiskio b/dvbv5_dvb-t/fi-Ii_Raiskio
new file mode 100644
index 0000000..c5fda67
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ii_Raiskio
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ii_Raiskio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Ii_Raiskio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Iisalmi b/dvbv5_dvb-t/fi-Iisalmi
new file mode 100644
index 0000000..d281825
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Iisalmi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Iisalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Iisalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ikaalinen b/dvbv5_dvb-t/fi-Ikaalinen
new file mode 100644
index 0000000..885d44b
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ikaalinen
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ikaalinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ikaalinen_Riitiala b/dvbv5_dvb-t/fi-Ikaalinen_Riitiala
new file mode 100644
index 0000000..55d8202
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ikaalinen_Riitiala
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ikaalinen_Riitiala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen_Riitiala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen_Riitiala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Ikaalinen_Riitiala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Inari b/dvbv5_dvb-t/fi-Inari
new file mode 100644
index 0000000..31deb21
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Inari
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Inari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Inari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Inari_Janispaa b/dvbv5_dvb-t/fi-Inari_Janispaa
new file mode 100644
index 0000000..37bd31e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Inari_Janispaa
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Inari_Janispaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Inari_Janispaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Inari_Naatamo b/dvbv5_dvb-t/fi-Inari_Naatamo
new file mode 100644
index 0000000..ba84360
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Inari_Naatamo
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Inari_Naatamo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Inari_Naatamo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara b/dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara
new file mode 100644
index 0000000..70181bb
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ivalo_Saarineitamovaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ivalo_Saarineitamovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Ivalo_Saarineitamovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jalasjarvi b/dvbv5_dvb-t/fi-Jalasjarvi
new file mode 100644
index 0000000..9bc7058
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jalasjarvi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jalasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Jalasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Jalasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Jalasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jamsa_Halli b/dvbv5_dvb-t/fi-Jamsa_Halli
new file mode 100644
index 0000000..5d06520
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jamsa_Halli
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jamsa_Halli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Halli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Halli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Halli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jamsa_Kaipola b/dvbv5_dvb-t/fi-Jamsa_Kaipola
new file mode 100644
index 0000000..ca8e563
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jamsa_Kaipola
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jamsa_Kaipola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Kaipola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Kaipola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Kaipola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jamsa_Matkosvuori b/dvbv5_dvb-t/fi-Jamsa_Matkosvuori
new file mode 100644
index 0000000..eacacff
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jamsa_Matkosvuori
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jamsa_Matkosvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Matkosvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Matkosvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Matkosvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jamsa_Ouninpohja b/dvbv5_dvb-t/fi-Jamsa_Ouninpohja
new file mode 100644
index 0000000..70eb8e1
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jamsa_Ouninpohja
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jamsa_Ouninpohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Ouninpohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsa_Ouninpohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jamsankoski b/dvbv5_dvb-t/fi-Jamsankoski
new file mode 100644
index 0000000..142be91
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jamsankoski
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jamsankoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsankoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsankoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Jamsankoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Joensuu_Vestinkallio b/dvbv5_dvb-t/fi-Joensuu_Vestinkallio
new file mode 100644
index 0000000..765ba1c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Joensuu_Vestinkallio
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Joensuu_Vestinkallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Joensuu_Vestinkallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Joensuu_Vestinkallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Joroinen_Puukkola b/dvbv5_dvb-t/fi-Joroinen_Puukkola
new file mode 100644
index 0000000..5fce8db
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Joroinen_Puukkola
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Joroinen_Puukkola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Joroinen_Puukkola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Joroinen_Puukkola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Joutsa_Lankia b/dvbv5_dvb-t/fi-Joutsa_Lankia
new file mode 100644
index 0000000..cc44c81
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Joutsa_Lankia
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Joutsa_Lankia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutsa_Lankia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutsa_Lankia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutsa_Lankia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Joutseno b/dvbv5_dvb-t/fi-Joutseno
new file mode 100644
index 0000000..80337fc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Joutseno
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Joutseno]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutseno]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutseno]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutseno]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Joutseno]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Juupajoki_Kopsamo b/dvbv5_dvb-t/fi-Juupajoki_Kopsamo
new file mode 100644
index 0000000..a99af77
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Juupajoki_Kopsamo
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Juupajoki_Kopsamo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Juupajoki_Kopsamo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Juupajoki_Kopsamo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Juva b/dvbv5_dvb-t/fi-Juva
new file mode 100644
index 0000000..ab8a15e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Juva
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Juva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Juva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Juva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Juva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jyvaskyla b/dvbv5_dvb-t/fi-Jyvaskyla
new file mode 100644
index 0000000..3e2c51f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jyvaskyla
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jyvaskyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski b/dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski
new file mode 100644
index 0000000..92b5ac9
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Jyvaskyla_Vaajakoski
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Jyvaskyla_Vaajakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla_Vaajakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Jyvaskyla_Vaajakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kaavi_Sivakkavaara b/dvbv5_dvb-t/fi-Kaavi_Sivakkavaara
new file mode 100644
index 0000000..7595a39
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kaavi_Sivakkavaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kaavi_Sivakkavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Kaavi_Sivakkavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Kaavi_Sivakkavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kajaani_Pollyvaara b/dvbv5_dvb-t/fi-Kajaani_Pollyvaara
new file mode 100644
index 0000000..3ea7b90
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kajaani_Pollyvaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kajaani_Pollyvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Kajaani_Pollyvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Kajaani_Pollyvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kalajoki b/dvbv5_dvb-t/fi-Kalajoki
new file mode 100644
index 0000000..cab796d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kalajoki
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kalajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Kalajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Kalajoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kangaslampi b/dvbv5_dvb-t/fi-Kangaslampi
new file mode 100644
index 0000000..d84b2a9
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kangaslampi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kangaslampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangaslampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangaslampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangaslampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki b/dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki
new file mode 100644
index 0000000..56476e6
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kangasniemi_Turkinmaki
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kangasniemi_Turkinmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangasniemi_Turkinmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangasniemi_Turkinmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Kangasniemi_Turkinmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kankaanpaa b/dvbv5_dvb-t/fi-Kankaanpaa
new file mode 100644
index 0000000..a3df7ba
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kankaanpaa
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kankaanpaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Kankaanpaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Kankaanpaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Kankaanpaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Karigasniemi b/dvbv5_dvb-t/fi-Karigasniemi
new file mode 100644
index 0000000..60548c7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Karigasniemi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Karigasniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Karigasniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Karkkila b/dvbv5_dvb-t/fi-Karkkila
new file mode 100644
index 0000000..d598f47
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Karkkila
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Karkkila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Karkkila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Karkkila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Karkkila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Karstula b/dvbv5_dvb-t/fi-Karstula
new file mode 100644
index 0000000..dfd3001
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Karstula
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Karstula]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Karstula]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Karstula]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Karvia b/dvbv5_dvb-t/fi-Karvia
new file mode 100644
index 0000000..51e89b7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Karvia
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Karvia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Karvia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Karvia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kaunispaa b/dvbv5_dvb-t/fi-Kaunispaa
new file mode 100644
index 0000000..e9fea9c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kaunispaa
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kaunispaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Kaunispaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi b/dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi
new file mode 100644
index 0000000..dac5d93
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kemijarvi_Suomutunturi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kemijarvi_Suomutunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Kemijarvi_Suomutunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kerimaki b/dvbv5_dvb-t/fi-Kerimaki
new file mode 100644
index 0000000..68f45d1
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kerimaki
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kerimaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Kerimaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Kerimaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Kerimaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Keuruu b/dvbv5_dvb-t/fi-Keuruu
new file mode 100644
index 0000000..dd49b5b
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Keuruu
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Keuruu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Keuruu_Haapamaki b/dvbv5_dvb-t/fi-Keuruu_Haapamaki
new file mode 100644
index 0000000..cfb9b0e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Keuruu_Haapamaki
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Keuruu_Haapamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu_Haapamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu_Haapamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Keuruu_Haapamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kihnio b/dvbv5_dvb-t/fi-Kihnio
new file mode 100644
index 0000000..7c5c992
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kihnio
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kihnio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Kihnio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Kihnio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Kihnio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kiihtelysvaara b/dvbv5_dvb-t/fi-Kiihtelysvaara
new file mode 100644
index 0000000..52e60b8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kiihtelysvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kiihtelysvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Kiihtelysvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kilpisjarvi b/dvbv5_dvb-t/fi-Kilpisjarvi
new file mode 100644
index 0000000..9d3435c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kilpisjarvi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kilpisjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Kilpisjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kittila_Levitunturi b/dvbv5_dvb-t/fi-Kittila_Levitunturi
new file mode 100644
index 0000000..ae4c1c9
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kittila_Levitunturi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kittila_Levitunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Kittila_Levitunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kolari_Vuolittaja b/dvbv5_dvb-t/fi-Kolari_Vuolittaja
new file mode 100644
index 0000000..f507750
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kolari_Vuolittaja
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kolari_Vuolittaja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Kolari_Vuolittaja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Koli b/dvbv5_dvb-t/fi-Koli
new file mode 100644
index 0000000..034bf2d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Koli
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Koli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Koli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Koli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Koli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori b/dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori
new file mode 100644
index 0000000..7fa3ed6
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Korpilahti_Vaarunvuori
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Korpilahti_Vaarunvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Korpilahti_Vaarunvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Korpilahti_Vaarunvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Korpilahti_Vaarunvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Korppoo b/dvbv5_dvb-t/fi-Korppoo
new file mode 100644
index 0000000..6c84241
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Korppoo
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Korppoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Korppoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Korppoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Korppoo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kruunupyy b/dvbv5_dvb-t/fi-Kruunupyy
new file mode 100644
index 0000000..65d86c4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kruunupyy
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kruunupyy]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Kruunupyy]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Kruunupyy]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Kruunupyy]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Kruunupyy]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmo_Haukela b/dvbv5_dvb-t/fi-Kuhmo_Haukela
new file mode 100644
index 0000000..c3a3bd8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmo_Haukela
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmo_Haukela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Haukela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Haukela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmo_Lentiira b/dvbv5_dvb-t/fi-Kuhmo_Lentiira
new file mode 100644
index 0000000..1127999
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmo_Lentiira
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmo_Lentiira]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Lentiira]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Lentiira]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmo_Niva b/dvbv5_dvb-t/fi-Kuhmo_Niva
new file mode 100644
index 0000000..6f7aa2c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmo_Niva
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmo_Niva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Niva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmo_Niva]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmoinen b/dvbv5_dvb-t/fi-Kuhmoinen
new file mode 100644
index 0000000..53d2de9
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmoinen
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi b/dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi
new file mode 100644
index 0000000..059df91
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmoinen_Harjunsalmi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmoinen_Harjunsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen_Harjunsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen_Harjunsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen_Harjunsalmi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen b/dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen
new file mode 100644
index 0000000..113e0f4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuhmoinen_Puukkoinen
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuhmoinen_Puukkoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen_Puukkoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuhmoinen_Puukkoinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuopio b/dvbv5_dvb-t/fi-Kuopio
new file mode 100644
index 0000000..eb39e5f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuopio
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuopio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuopio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuopio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuopio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuopio]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kurikka_Kesti b/dvbv5_dvb-t/fi-Kurikka_Kesti
new file mode 100644
index 0000000..c34cfe6
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kurikka_Kesti
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kurikka_Kesti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Kurikka_Kesti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Kurikka_Kesti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Kurikka_Kesti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kustavi_Viherlahti b/dvbv5_dvb-t/fi-Kustavi_Viherlahti
new file mode 100644
index 0000000..ecef74d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kustavi_Viherlahti
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kustavi_Viherlahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Kustavi_Viherlahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Kustavi_Viherlahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Kustavi_Viherlahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kuusamo_Hamppulampi b/dvbv5_dvb-t/fi-Kuusamo_Hamppulampi
new file mode 100644
index 0000000..6ce9243
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kuusamo_Hamppulampi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kuusamo_Hamppulampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Kuusamo_Hamppulampi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho b/dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho
new file mode 100644
index 0000000..d3deab8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Kyyjarvi_Noposenaho
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Kyyjarvi_Noposenaho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Kyyjarvi_Noposenaho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
+[Kyyjarvi_Noposenaho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Lahti b/dvbv5_dvb-t/fi-Lahti
new file mode 100644
index 0000000..d4bf403
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Lahti
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Lahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Lahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Lahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Lahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Lahti]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Lapua b/dvbv5_dvb-t/fi-Lapua
new file mode 100644
index 0000000..9084440
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Lapua
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Lapua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Lapua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Lapua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Lapua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Lapua]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Laukaa b/dvbv5_dvb-t/fi-Laukaa
new file mode 100644
index 0000000..3c484ae
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Laukaa
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Laukaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Laukaa_Vihtavuori b/dvbv5_dvb-t/fi-Laukaa_Vihtavuori
new file mode 100644
index 0000000..5bc93a7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Laukaa_Vihtavuori
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Laukaa_Vihtavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa_Vihtavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa_Vihtavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Laukaa_Vihtavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Lavia b/dvbv5_dvb-t/fi-Lavia
new file mode 100644
index 0000000..f2f1391
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Lavia
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Lavia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Lavia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Lavia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Lohja b/dvbv5_dvb-t/fi-Lohja
new file mode 100644
index 0000000..d040f9b
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Lohja
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Lohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Lohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Lohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Lohja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Loimaa b/dvbv5_dvb-t/fi-Loimaa
new file mode 100644
index 0000000..0b6aad8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Loimaa
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Loimaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Loimaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Loimaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Loimaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Luhanka b/dvbv5_dvb-t/fi-Luhanka
new file mode 100644
index 0000000..f6407ce
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Luhanka
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Luhanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Luhanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Luhanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Luhanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Luopioinen b/dvbv5_dvb-t/fi-Luopioinen
new file mode 100644
index 0000000..9ed4e3f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Luopioinen
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Luopioinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Luopioinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Luopioinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Luopioinen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Mantta b/dvbv5_dvb-t/fi-Mantta
new file mode 100644
index 0000000..e201405
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Mantta
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Mantta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Mantta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Mantta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Mantta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Mantyharju b/dvbv5_dvb-t/fi-Mantyharju
new file mode 100644
index 0000000..3b7f127
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Mantyharju
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Mantyharju]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Mantyharju]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Mantyharju]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Mikkeli b/dvbv5_dvb-t/fi-Mikkeli
new file mode 100644
index 0000000..f523878
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Mikkeli
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Mikkeli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
+[Mikkeli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Mikkeli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
+[Mikkeli]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Muonio_Olostunturi b/dvbv5_dvb-t/fi-Muonio_Olostunturi
new file mode 100644
index 0000000..bfdf0c7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Muonio_Olostunturi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Muonio_Olostunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Muonio_Olostunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nilsia b/dvbv5_dvb-t/fi-Nilsia
new file mode 100644
index 0000000..208d1c4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nilsia
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nilsia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi b/dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi
new file mode 100644
index 0000000..bfbc561
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nilsia_Keski-Siikajarvi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nilsia_Keski-Siikajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia_Keski-Siikajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia_Keski-Siikajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nilsia_Pisa b/dvbv5_dvb-t/fi-Nilsia_Pisa
new file mode 100644
index 0000000..8c8ee34
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nilsia_Pisa
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nilsia_Pisa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia_Pisa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Nilsia_Pisa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nokia b/dvbv5_dvb-t/fi-Nokia
new file mode 100644
index 0000000..2a2b380
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nokia
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nokia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nokia_Siuro b/dvbv5_dvb-t/fi-Nokia_Siuro
new file mode 100644
index 0000000..1ba3cca
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nokia_Siuro
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nokia_Siuro]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia_Siuro]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia_Siuro]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Nokia_Siuro]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola b/dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola
new file mode 100644
index 0000000..08840cc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nummi-Pusula_Hyonola
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nummi-Pusula_Hyonola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Nummi-Pusula_Hyonola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
+[Nummi-Pusula_Hyonola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Nummi-Pusula_Hyonola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nuorgam_Njallavaara b/dvbv5_dvb-t/fi-Nuorgam_Njallavaara
new file mode 100644
index 0000000..e1c1c3e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nuorgam_Njallavaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nuorgam_Njallavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Nuorgam_Njallavaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nuorgam_raja b/dvbv5_dvb-t/fi-Nuorgam_raja
new file mode 100644
index 0000000..2b2cb3c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nuorgam_raja
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nuorgam_raja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Nuorgam_raja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nurmes_Konnanvaara b/dvbv5_dvb-t/fi-Nurmes_Konnanvaara
new file mode 100644
index 0000000..7cd3d91
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nurmes_Konnanvaara
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nurmes_Konnanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Nurmes_Konnanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Nurmes_Konnanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Nurmes_Konnanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Nurmes_Kortevaara b/dvbv5_dvb-t/fi-Nurmes_Kortevaara
new file mode 100644
index 0000000..3e118ad
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Nurmes_Kortevaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Nurmes_Kortevaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Nurmes_Kortevaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Nurmes_Kortevaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Orivesi_Talviainen b/dvbv5_dvb-t/fi-Orivesi_Talviainen
new file mode 100644
index 0000000..149782e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Orivesi_Talviainen
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Orivesi_Talviainen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Orivesi_Talviainen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Orivesi_Talviainen]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Oulu b/dvbv5_dvb-t/fi-Oulu
new file mode 100644
index 0000000..6d10849
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Oulu
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Oulu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Oulu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Oulu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Oulu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Oulu]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Padasjoki b/dvbv5_dvb-t/fi-Padasjoki
new file mode 100644
index 0000000..47246b4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Padasjoki
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Padasjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Padasjoki_Arrakoski b/dvbv5_dvb-t/fi-Padasjoki_Arrakoski
new file mode 100644
index 0000000..c8c1b05
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Padasjoki_Arrakoski
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Padasjoki_Arrakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki_Arrakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki_Arrakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
+[Padasjoki_Arrakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 746000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Paltamo_Kivesvaara b/dvbv5_dvb-t/fi-Paltamo_Kivesvaara
new file mode 100644
index 0000000..56f8ba0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Paltamo_Kivesvaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Paltamo_Kivesvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Paltamo_Kivesvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Paltamo_Kivesvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Parainen_Houtskari b/dvbv5_dvb-t/fi-Parainen_Houtskari
new file mode 100644
index 0000000..e187814
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Parainen_Houtskari
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Parainen_Houtskari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Parainen_Houtskari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Parainen_Houtskari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Parainen_Houtskari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Parikkala b/dvbv5_dvb-t/fi-Parikkala
new file mode 100644
index 0000000..f0f52f7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Parikkala
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Parikkala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Parikkala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
+[Parikkala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
+[Parikkala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Parkano_Sopukallio b/dvbv5_dvb-t/fi-Parkano_Sopukallio
new file mode 100644
index 0000000..62e8507
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Parkano_Sopukallio
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Parkano_Sopukallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Parkano_Sopukallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Parkano_Sopukallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Parkano_Sopukallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pello b/dvbv5_dvb-t/fi-Pello
new file mode 100644
index 0000000..2cbd28e
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pello
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pello]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Pello]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pello_Ratasvaara b/dvbv5_dvb-t/fi-Pello_Ratasvaara
new file mode 100644
index 0000000..ff7f660
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pello_Ratasvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pello_Ratasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Pello_Ratasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Perho b/dvbv5_dvb-t/fi-Perho
new file mode 100644
index 0000000..0a7a2dc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Perho
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Perho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Perho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Perho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Perho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pernaja b/dvbv5_dvb-t/fi-Pernaja
new file mode 100644
index 0000000..5459e88
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pernaja
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pernaja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Pernaja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Pernaja]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu b/dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu
new file mode 100644
index 0000000..f03f9a0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pieksamaki_Halkokumpu
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pieksamaki_Halkokumpu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Pieksamaki_Halkokumpu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Pieksamaki_Halkokumpu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pihtipudas b/dvbv5_dvb-t/fi-Pihtipudas
new file mode 100644
index 0000000..42cdd29
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pihtipudas
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pihtipudas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Pihtipudas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Pihtipudas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Porvoo_Suomenkyla b/dvbv5_dvb-t/fi-Porvoo_Suomenkyla
new file mode 100644
index 0000000..7b5e79d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Porvoo_Suomenkyla
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Porvoo_Suomenkyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Porvoo_Suomenkyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Porvoo_Suomenkyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Porvoo_Suomenkyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Posio b/dvbv5_dvb-t/fi-Posio
new file mode 100644
index 0000000..0258647
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Posio
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Posio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Posio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pudasjarvi b/dvbv5_dvb-t/fi-Pudasjarvi
new file mode 100644
index 0000000..dc85d9a
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pudasjarvi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pudasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Pudasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Pudasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote b/dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote
new file mode 100644
index 0000000..24cebdd
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pudasjarvi_Iso-Syote
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pudasjarvi_Iso-Syote]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Pudasjarvi_Iso-Syote]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Pudasjarvi_Iso-Syote]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara b/dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara
new file mode 100644
index 0000000..cb91163
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pudasjarvi_Kangasvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pudasjarvi_Kangasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Pudasjarvi_Kangasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Puolanka b/dvbv5_dvb-t/fi-Puolanka
new file mode 100644
index 0000000..3370a9a
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Puolanka
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Puolanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Puolanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Puolanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Puolanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pyhatunturi b/dvbv5_dvb-t/fi-Pyhatunturi
new file mode 100644
index 0000000..c500576
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pyhatunturi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pyhatunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Pyhatunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pyhavuori b/dvbv5_dvb-t/fi-Pyhavuori
new file mode 100644
index 0000000..ad23265
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pyhavuori
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pyhavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Pyhavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Pyhavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi b/dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi
new file mode 100644
index 0000000..2d7ef17
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Pylkonmaki_Karankajarvi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Pylkonmaki_Karankajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Pylkonmaki_Karankajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Pylkonmaki_Karankajarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Raahe_Mestauskallio b/dvbv5_dvb-t/fi-Raahe_Mestauskallio
new file mode 100644
index 0000000..e4cc7b1
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Raahe_Mestauskallio
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Raahe_Mestauskallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Raahe_Mestauskallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Raahe_Mestauskallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Raahe_Mestauskallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Raahe_Piehinki b/dvbv5_dvb-t/fi-Raahe_Piehinki
new file mode 100644
index 0000000..1b3836d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Raahe_Piehinki
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Raahe_Piehinki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Raahe_Piehinki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Raahe_Piehinki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ranua_Haasionmaa b/dvbv5_dvb-t/fi-Ranua_Haasionmaa
new file mode 100644
index 0000000..837a10f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ranua_Haasionmaa
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ranua_Haasionmaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Ranua_Haasionmaa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ranua_Leppiaho b/dvbv5_dvb-t/fi-Ranua_Leppiaho
new file mode 100644
index 0000000..94d3eef
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ranua_Leppiaho
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ranua_Leppiaho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Ranua_Leppiaho]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rautavaara_Angervikko b/dvbv5_dvb-t/fi-Rautavaara_Angervikko
new file mode 100644
index 0000000..c89e4bf
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rautavaara_Angervikko
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rautavaara_Angervikko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Rautavaara_Angervikko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Rautavaara_Angervikko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Rautavaara_Angervikko]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rautjarvi_Simpele b/dvbv5_dvb-t/fi-Rautjarvi_Simpele
new file mode 100644
index 0000000..2d4c254
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rautjarvi_Simpele
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rautjarvi_Simpele]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Rautjarvi_Simpele]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Rautjarvi_Simpele]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ristijarvi b/dvbv5_dvb-t/fi-Ristijarvi
new file mode 100644
index 0000000..79a58c3
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ristijarvi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ristijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Ristijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Ristijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi b/dvbv5_dvb-t/fi-Rovaniemi
new file mode 100644
index 0000000..87a65b1
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara b/dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara
new file mode 100644
index 0000000..3808ebc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Kaihuanvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Kaihuanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Kaihuanvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara b/dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara
new file mode 100644
index 0000000..069ecb4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Karhuvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Karhuvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Karhuvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio b/dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio
new file mode 100644
index 0000000..6c8d542
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Marasenkallio
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Marasenkallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Marasenkallio]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Rantalaki b/dvbv5_dvb-t/fi-Rovaniemi_Rantalaki
new file mode 100644
index 0000000..fe3ea4c
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Rantalaki
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Rantalaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Rantalaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Sonka b/dvbv5_dvb-t/fi-Rovaniemi_Sonka
new file mode 100644
index 0000000..932b409
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Sonka
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Sonka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Sonka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Rovaniemi_Sorviselka b/dvbv5_dvb-t/fi-Rovaniemi_Sorviselka
new file mode 100644
index 0000000..feb3bcf
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Rovaniemi_Sorviselka
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Rovaniemi_Sorviselka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Rovaniemi_Sorviselka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ruka b/dvbv5_dvb-t/fi-Ruka
new file mode 100644
index 0000000..de41ddc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ruka
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ruka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Ruka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Ruka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ruovesi_Storminiemi b/dvbv5_dvb-t/fi-Ruovesi_Storminiemi
new file mode 100644
index 0000000..ac465cb
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ruovesi_Storminiemi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ruovesi_Storminiemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Ruovesi_Storminiemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Ruovesi_Storminiemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
+[Ruovesi_Storminiemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Saarijarvi b/dvbv5_dvb-t/fi-Saarijarvi
new file mode 100644
index 0000000..18c923f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Saarijarvi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Saarijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Saarijarvi_Kalmari b/dvbv5_dvb-t/fi-Saarijarvi_Kalmari
new file mode 100644
index 0000000..77d5ade
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Saarijarvi_Kalmari
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Saarijarvi_Kalmari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi_Kalmari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi_Kalmari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Saarijarvi_Mahlu b/dvbv5_dvb-t/fi-Saarijarvi_Mahlu
new file mode 100644
index 0000000..48324d0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Saarijarvi_Mahlu
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Saarijarvi_Mahlu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi_Mahlu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Saarijarvi_Mahlu]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salla_Hirvasvaara b/dvbv5_dvb-t/fi-Salla_Hirvasvaara
new file mode 100644
index 0000000..e1410a0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salla_Hirvasvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salla_Hirvasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Salla_Hirvasvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salla_Ihistysjanka b/dvbv5_dvb-t/fi-Salla_Ihistysjanka
new file mode 100644
index 0000000..0d857b5
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salla_Ihistysjanka
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salla_Ihistysjanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
+[Salla_Ihistysjanka]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salla_Naruska b/dvbv5_dvb-t/fi-Salla_Naruska
new file mode 100644
index 0000000..06bc1ba
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salla_Naruska
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salla_Naruska]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Salla_Naruska]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salla_Sallatunturi b/dvbv5_dvb-t/fi-Salla_Sallatunturi
new file mode 100644
index 0000000..54a5554
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salla_Sallatunturi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salla_Sallatunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Salla_Sallatunturi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salla_Sarivaara b/dvbv5_dvb-t/fi-Salla_Sarivaara
new file mode 100644
index 0000000..eb9bbc0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salla_Sarivaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salla_Sarivaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Salla_Sarivaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Salo_Isokyla b/dvbv5_dvb-t/fi-Salo_Isokyla
new file mode 100644
index 0000000..42df3b4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Salo_Isokyla
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Salo_Isokyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Salo_Isokyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
+[Salo_Isokyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Salo_Isokyla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Savukoski_Martti b/dvbv5_dvb-t/fi-Savukoski_Martti
new file mode 100644
index 0000000..aafbdcb
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Savukoski_Martti
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Savukoski_Martti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Savukoski_Martti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Savukoski_Tanhua b/dvbv5_dvb-t/fi-Savukoski_Tanhua
new file mode 100644
index 0000000..91f5fa7
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Savukoski_Tanhua
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Savukoski_Tanhua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Savukoski_Tanhua]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Siilinjarvi b/dvbv5_dvb-t/fi-Siilinjarvi
new file mode 100644
index 0000000..7fc1f47
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Siilinjarvi
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Siilinjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Siilinjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
+[Siilinjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Siilinjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Simo_Viantie b/dvbv5_dvb-t/fi-Simo_Viantie
new file mode 100644
index 0000000..580c7bd
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Simo_Viantie
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Simo_Viantie]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Simo_Viantie]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Simo_Viantie]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Sipoo_Norrkulla b/dvbv5_dvb-t/fi-Sipoo_Norrkulla
new file mode 100644
index 0000000..abfb413
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Sipoo_Norrkulla
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Sipoo_Norrkulla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Sipoo_Norrkulla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Sipoo_Norrkulla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Sipoo_Norrkulla]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Sodankyla_Pittiovaara b/dvbv5_dvb-t/fi-Sodankyla_Pittiovaara
new file mode 100644
index 0000000..a123f64
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Sodankyla_Pittiovaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Sodankyla_Pittiovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Sodankyla_Pittiovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Sodankyla_Vuotso b/dvbv5_dvb-t/fi-Sodankyla_Vuotso
new file mode 100644
index 0000000..9c60b77
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Sodankyla_Vuotso
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Sodankyla_Vuotso]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
+[Sodankyla_Vuotso]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki b/dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki
new file mode 100644
index 0000000..31bdd61
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Sulkava_Vaatalanmaki
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Sulkava_Vaatalanmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Sulkava_Vaatalanmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Sulkava_Vaatalanmaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki b/dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki
new file mode 100644
index 0000000..0878a88
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Suomussalmi_Ala-Vuokki
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Suomussalmi_Ala-Vuokki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Suomussalmi_Ala-Vuokki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Suomussalmi_Ammansaari b/dvbv5_dvb-t/fi-Suomussalmi_Ammansaari
new file mode 100644
index 0000000..9afceff
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Suomussalmi_Ammansaari
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Suomussalmi_Ammansaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Suomussalmi_Ammansaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Suomussalmi_Juntusranta b/dvbv5_dvb-t/fi-Suomussalmi_Juntusranta
new file mode 100644
index 0000000..66c4e5b
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Suomussalmi_Juntusranta
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Suomussalmi_Juntusranta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Suomussalmi_Juntusranta]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 666000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Suomussalmi_Myllylahti b/dvbv5_dvb-t/fi-Suomussalmi_Myllylahti
new file mode 100644
index 0000000..9630977
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Suomussalmi_Myllylahti
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Suomussalmi_Myllylahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Suomussalmi_Myllylahti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Sysma_Liikola b/dvbv5_dvb-t/fi-Sysma_Liikola
new file mode 100644
index 0000000..9db4424
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Sysma_Liikola
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Sysma_Liikola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Sysma_Liikola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Sysma_Liikola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Sysma_Liikola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Taivalkoski b/dvbv5_dvb-t/fi-Taivalkoski
new file mode 100644
index 0000000..c307ae4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Taivalkoski
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Taivalkoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Taivalkoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara b/dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara
new file mode 100644
index 0000000..ff81bf0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Taivalkoski_Taivalvaara
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Taivalkoski_Taivalvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Taivalkoski_Taivalvaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Tammela b/dvbv5_dvb-t/fi-Tammela
new file mode 100644
index 0000000..f537bef
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Tammela
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Tammela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammela]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammela]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Tammisaari b/dvbv5_dvb-t/fi-Tammisaari
new file mode 100644
index 0000000..5248fd2
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Tammisaari
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Tammisaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammisaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammisaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
+[Tammisaari]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Tampere b/dvbv5_dvb-t/fi-Tampere
new file mode 100644
index 0000000..1440032
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Tampere
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Tampere]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 490000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Tampere_Pyynikki b/dvbv5_dvb-t/fi-Tampere_Pyynikki
new file mode 100644
index 0000000..03e8ecc
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Tampere_Pyynikki
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Tampere_Pyynikki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere_Pyynikki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere_Pyynikki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 682000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere_Pyynikki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
+[Tampere_Pyynikki]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Tervola b/dvbv5_dvb-t/fi-Tervola
new file mode 100644
index 0000000..d2c2d94
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Tervola
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Tervola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
+[Tervola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 642000000
+	BANDWIDTH_HZ = 8000000
+
+[Tervola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Turku b/dvbv5_dvb-t/fi-Turku
new file mode 100644
index 0000000..281048d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Turku
@@ -0,0 +1,28 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Turku]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Turku]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 738000000
+	BANDWIDTH_HZ = 8000000
+
+[Turku]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Turku]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Turku]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 538000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki b/dvbv5_dvb-t/fi-Utsjoki
new file mode 100644
index 0000000..b884a17
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki_Nuvvus b/dvbv5_dvb-t/fi-Utsjoki_Nuvvus
new file mode 100644
index 0000000..66d35a3
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki_Nuvvus
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki_Nuvvus]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki_Nuvvus]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki_Outakoski b/dvbv5_dvb-t/fi-Utsjoki_Outakoski
new file mode 100644
index 0000000..53a75af
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki_Outakoski
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki_Outakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki_Outakoski]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki_Polvarniemi b/dvbv5_dvb-t/fi-Utsjoki_Polvarniemi
new file mode 100644
index 0000000..0ee4ceb
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki_Polvarniemi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki_Polvarniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki_Polvarniemi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto b/dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto
new file mode 100644
index 0000000..7459a8d
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki_Rovisuvanto
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki_Rovisuvanto]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki_Rovisuvanto]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 578000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Utsjoki_Tenola b/dvbv5_dvb-t/fi-Utsjoki_Tenola
new file mode 100644
index 0000000..9650439
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Utsjoki_Tenola
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Utsjoki_Tenola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Utsjoki_Tenola]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Uusikaupunki_Orivo b/dvbv5_dvb-t/fi-Uusikaupunki_Orivo
new file mode 100644
index 0000000..abe1f7f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Uusikaupunki_Orivo
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Uusikaupunki_Orivo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Uusikaupunki_Orivo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Uusikaupunki_Orivo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+
+[Uusikaupunki_Orivo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vaala b/dvbv5_dvb-t/fi-Vaala
new file mode 100644
index 0000000..86e8773
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vaala
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vaala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+
+[Vaala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Vaala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vaasa b/dvbv5_dvb-t/fi-Vaasa
new file mode 100644
index 0000000..7826313
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vaasa
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vaasa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Vaasa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Vaasa]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Valtimo b/dvbv5_dvb-t/fi-Valtimo
new file mode 100644
index 0000000..81e8245
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Valtimo
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Valtimo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
+[Valtimo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 610000000
+	BANDWIDTH_HZ = 8000000
+
+[Valtimo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vammala_Jyranvuori b/dvbv5_dvb-t/fi-Vammala_Jyranvuori
new file mode 100644
index 0000000..26582a8
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vammala_Jyranvuori
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vammala_Jyranvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 714000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Jyranvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Jyranvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 506000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Jyranvuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vammala_Roismala b/dvbv5_dvb-t/fi-Vammala_Roismala
new file mode 100644
index 0000000..53f3793
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vammala_Roismala
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vammala_Roismala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Roismala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Roismala]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vammala_Savi b/dvbv5_dvb-t/fi-Vammala_Savi
new file mode 100644
index 0000000..189afb4
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vammala_Savi
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vammala_Savi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Savi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
+[Vammala_Savi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 626000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vantaa_Hakunila b/dvbv5_dvb-t/fi-Vantaa_Hakunila
new file mode 100644
index 0000000..af493a1
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vantaa_Hakunila
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vantaa_Hakunila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 562000000
+	BANDWIDTH_HZ = 8000000
+
+[Vantaa_Hakunila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 658000000
+	BANDWIDTH_HZ = 8000000
+
+[Vantaa_Hakunila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
+[Vantaa_Hakunila]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 730000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki b/dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki
new file mode 100644
index 0000000..5bdf974
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Varpaisjarvi_Honkamaki
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Varpaisjarvi_Honkamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+
+[Varpaisjarvi_Honkamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+
+[Varpaisjarvi_Honkamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Varpaisjarvi_Honkamaki]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Virrat_Lappavuori b/dvbv5_dvb-t/fi-Virrat_Lappavuori
new file mode 100644
index 0000000..61f12b0
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Virrat_Lappavuori
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Virrat_Lappavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 522000000
+	BANDWIDTH_HZ = 8000000
+
+[Virrat_Lappavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
+[Virrat_Lappavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
+[Virrat_Lappavuori]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Vuokatti b/dvbv5_dvb-t/fi-Vuokatti
new file mode 100644
index 0000000..5a78cf3
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Vuokatti
@@ -0,0 +1,23 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Vuokatti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Vuokatti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 722000000
+	BANDWIDTH_HZ = 8000000
+
+[Vuokatti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 754000000
+	BANDWIDTH_HZ = 8000000
+
+[Vuokatti]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ylitornio_Ainiovaara b/dvbv5_dvb-t/fi-Ylitornio_Ainiovaara
new file mode 100644
index 0000000..ebd72b9
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ylitornio_Ainiovaara
@@ -0,0 +1,18 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ylitornio_Ainiovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Ylitornio_Ainiovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 602000000
+	BANDWIDTH_HZ = 8000000
+
+[Ylitornio_Ainiovaara]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 762000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Ylitornio_Raanujarvi b/dvbv5_dvb-t/fi-Ylitornio_Raanujarvi
new file mode 100644
index 0000000..885c18f
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Ylitornio_Raanujarvi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Ylitornio_Raanujarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
+[Ylitornio_Raanujarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 618000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Yllas b/dvbv5_dvb-t/fi-Yllas
new file mode 100644
index 0000000..0488cfb
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Yllas
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Yllas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 546000000
+	BANDWIDTH_HZ = 8000000
+
+[Yllas]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 594000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvbv5_dvb-t/fi-Yllasjarvi b/dvbv5_dvb-t/fi-Yllasjarvi
new file mode 100644
index 0000000..6790089
--- /dev/null
+++ b/dvbv5_dvb-t/fi-Yllasjarvi
@@ -0,0 +1,13 @@
+# 2014-04-18 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+
+[Yllasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 482000000
+	BANDWIDTH_HZ = 8000000
+
+[Yllasjarvi]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 530000000
+	BANDWIDTH_HZ = 8000000
+
-- 
1.9.0

