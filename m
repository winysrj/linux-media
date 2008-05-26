Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K0eid-0006ZV-CM
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 17:34:42 +0200
Message-ID: <483AD86C.4030108@iki.fi>
Date: Mon, 26 May 2008 18:34:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
References: <4836F51E.7070403@iki.fi>
In-Reply-To: <4836F51E.7070403@iki.fi>
Content-Type: multipart/mixed; boundary="------------030807030000050601060000"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] update Finland initial DVB-T tuning files
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030807030000050601060000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hello Christoph,
there is new try. Earlier patch didn't remove obsolete files. This one 
does it. Use that updated patch instead the old one.

Files removed and the new one:
fi-Salla => fi-Salla_Sallatunturi
fi-SaloIsokyla => fi-Salo_Isokyla
fi-Uusikaupunki_Ruokola => fi-Uusikaupunki_Orivo

Antti

[crope@localhost dvb-apps]$ hg addremove
adding util/scan/dvb-t/fi-Enontekio_Ahovaara_Raattama
adding util/scan/dvb-t/fi-Hyrynsalmi
adding util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara
adding util/scan/dvb-t/fi-Hyrynsalmi_Paljakka
adding util/scan/dvb-t/fi-Ii_Raiskio
adding util/scan/dvb-t/fi-Jamsa_Ouninpohja
adding util/scan/dvb-t/fi-Joroinen_Puukkola
adding util/scan/dvb-t/fi-Juupajoki_Kopsamo
adding util/scan/dvb-t/fi-Jyvaskylan_mlk_Vaajakoski
adding util/scan/dvb-t/fi-Kaavi_Sivakkavaara_Luikonlahti
adding util/scan/dvb-t/fi-Kalajoki
adding util/scan/dvb-t/fi-Kemijarvi_Suomutunturi
adding util/scan/dvb-t/fi-Kolari_Vuolittaja
adding util/scan/dvb-t/fi-Kuhmo_Iivantiira
adding util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen
adding util/scan/dvb-t/fi-Kyyjarvi_Noposenaho
adding util/scan/dvb-t/fi-Lavia_Lavianjarvi
adding util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi
adding util/scan/dvb-t/fi-Nilsia_Pisa
adding util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen
adding util/scan/dvb-t/fi-Paltamo_Kivesvaara
adding util/scan/dvb-t/fi-Pieksamaki_Halkokumpu
adding util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara
adding util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi
adding util/scan/dvb-t/fi-Raahe_Piehinki
adding util/scan/dvb-t/fi-Ranua_Leppiaho
adding util/scan/dvb-t/fi-Rovaniemi_Karhuvaara_Marrasjarvi
adding util/scan/dvb-t/fi-Rovaniemi_Marasenkallio
adding util/scan/dvb-t/fi-Rovaniemi_Sonka
adding util/scan/dvb-t/fi-Saarijarvi_Kalmari
adding util/scan/dvb-t/fi-Saarijarvi_Mahlu
adding util/scan/dvb-t/fi-Salla_Hirvasvaara
adding util/scan/dvb-t/fi-Salla_Sallatunturi
adding util/scan/dvb-t/fi-Salo_Isokyla
adding util/scan/dvb-t/fi-Savukoski_Martti_Haarahonganmaa
adding util/scan/dvb-t/fi-Savukoski_Tanhua
adding util/scan/dvb-t/fi-Taivalkoski_Taivalvaara
adding util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara
adding util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja
adding util/scan/dvb-t/fi-Utsjoki_Outakoski
adding util/scan/dvb-t/fi-Utsjoki_Polvarniemi
adding util/scan/dvb-t/fi-Utsjoki_Rovisuvanto
adding util/scan/dvb-t/fi-Utsjoki_Tenola
adding util/scan/dvb-t/fi-Uusikaupunki_Orivo
adding util/scan/dvb-t/fi-Vammala_Roismala
adding util/scan/dvb-t/fi-Vammala_Savi
adding util/scan/dvb-t/fi-Ylitornio_Raanujarvi
removing util/scan/dvb-t/fi-Salla
removing util/scan/dvb-t/fi-SaloIsokyla
removing util/scan/dvb-t/fi-Uusikaupunki_Ruokola


Antti Palosaari wrote:
> moikka
> patch updates Finland DVB-T tuning files.
> 
> regards,
> Antti
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

--------------030807030000050601060000
Content-Type: text/x-patch;
 name="fi-update_2008-05-26.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2008-05-26.patch"

diff -r 31a6dd437b9a util/scan/dvb-t/fi-Enontekio_Ahovaara_Raattama
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Enontekio_Ahovaara_Raattama	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Haapavesi
--- a/util/scan/dvb-t/fi-Haapavesi	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Haapavesi	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi_Paljakka
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Paljakka	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ii_Raiskio
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ii_Raiskio	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Jamsa_Ouninpohja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jamsa_Ouninpohja	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Joroinen_Puukkola
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Joroinen_Puukkola	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Joutseno
--- a/util/scan/dvb-t/fi-Joutseno	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Joutseno	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Juupajoki_Kopsamo
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Jyvaskylan_mlk_Vaajakoski
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jyvaskylan_mlk_Vaajakoski	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kaavi_Sivakkavaara_Luikonlahti
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kaavi_Sivakkavaara_Luikonlahti	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kalajoki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kalajoki	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Karkkila
--- a/util/scan/dvb-t/fi-Karkkila	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Karkkila	Mon May 26 18:28:55 2008 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kemijarvi_Suomutunturi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kemijarvi_Suomutunturi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kerimaki
--- a/util/scan/dvb-t/fi-Kerimaki	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Kerimaki	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kolari_Vuolittaja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kolari_Vuolittaja	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Koli
--- a/util/scan/dvb-t/fi-Koli	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Koli	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kruunupyy
--- a/util/scan/dvb-t/fi-Kruunupyy	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Kruunupyy	Mon May 26 18:28:55 2008 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kuhmo_Iivantiira
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmo_Iivantiira	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kyyjarvi_Noposenaho
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kyyjarvi_Noposenaho	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Lavia_Lavianjarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Lavia_Lavianjarvi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Lieksa_Vieki
--- a/util/scan/dvb-t/fi-Lieksa_Vieki	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Lieksa_Vieki	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Loimaa
--- a/util/scan/dvb-t/fi-Loimaa	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Loimaa	Mon May 26 18:28:55 2008 +0300
@@ -1,5 +1,5 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Mikkeli
--- a/util/scan/dvb-t/fi-Mikkeli	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Mikkeli	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Nilsia_Pisa
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nilsia_Pisa	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Paltamo_Kivesvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Paltamo_Kivesvaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pieksamaki_Halkokumpu
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pieksamaki_Halkokumpu	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pihtipudas
--- a/util/scan/dvb-t/fi-Pihtipudas	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Pihtipudas	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Puolanka
--- a/util/scan/dvb-t/fi-Puolanka	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Puolanka	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Raahe_Mestauskallio
--- a/util/scan/dvb-t/fi-Raahe_Mestauskallio	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Raahe_Mestauskallio	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Raahe_Piehinki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Raahe_Piehinki	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ranua_Leppiaho
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ranua_Leppiaho	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi
--- a/util/scan/dvb-t/fi-Rovaniemi	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Karhuvaara_Marrasjarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Karhuvaara_Marrasjarvi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Marasenkallio
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Marasenkallio	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Sonka
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Sonka	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Saarijarvi_Kalmari
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Saarijarvi_Kalmari	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Saarijarvi_Mahlu
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Saarijarvi_Mahlu	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salla
--- a/util/scan/dvb-t/fi-Salla	Wed May 14 19:15:22 2008 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salla_Hirvasvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salla_Hirvasvaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salla_Sallatunturi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salla_Sallatunturi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-SaloIsokyla
--- a/util/scan/dvb-t/fi-SaloIsokyla	Wed May 14 19:15:22 2008 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salo_Isokyla
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salo_Isokyla	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,6 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Savukoski_Martti_Haarahonganmaa
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Savukoski_Martti_Haarahonganmaa	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Savukoski_Tanhua
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Savukoski_Tanhua	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Taivalkoski_Taivalvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Taivalkoski_Taivalvaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Tammela
--- a/util/scan/dvb-t/fi-Tammela	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Tammela	Mon May 26 18:28:55 2008 +0300
@@ -3,3 +3,4 @@ T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Tervola
--- a/util/scan/dvb-t/fi-Tervola	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Tervola	Mon May 26 18:28:55 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Turku
--- a/util/scan/dvb-t/fi-Turku	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Turku	Mon May 26 18:28:55 2008 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Outakoski
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Outakoski	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Polvarniemi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Polvarniemi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Rovisuvanto
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Rovisuvanto	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Tenola
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Tenola	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Uusikaupunki_Orivo
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Uusikaupunki_Orivo	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,5 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Uusikaupunki_Ruokola
--- a/util/scan/dvb-t/fi-Uusikaupunki_Ruokola	Wed May 14 19:15:22 2008 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Jyranvuori
--- a/util/scan/dvb-t/fi-Vammala_Jyranvuori	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Jyranvuori	Mon May 26 18:28:55 2008 +0300
@@ -1,5 +1,5 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Roismala
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Vammala_Roismala	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Savi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Vammala_Savi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vuokatti
--- a/util/scan/dvb-t/fi-Vuokatti	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Vuokatti	Mon May 26 18:28:55 2008 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ylitornio_Raanujarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ylitornio_Raanujarvi	Mon May 26 18:28:55 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------030807030000050601060000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030807030000050601060000--
