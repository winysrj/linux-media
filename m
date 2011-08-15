Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48129 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1HOAjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 20:39:00 -0400
Message-ID: <4E486AA2.30905@iki.fi>
Date: Mon, 15 Aug 2011 03:38:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: dvb-apps: update DVB-T intial tuning files for Finland (fi-*)
Content-Type: multipart/mixed;
 boundary="------------070604070002060401020603"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070604070002060401020603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Moi Christoph,
Updates all Finnish channels as today.

Antti
-- 
http://palosaari.fi/


--------------070604070002060401020603
Content-Type: text/plain;
 name="fi-update_2011-08-15.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fi-update_2011-08-15.patch"

diff -r 36a084aace47 util/scan/dvb-t/fi-Alajarvi
--- a/util/scan/dvb-t/fi-Alajarvi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Alajarvi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Hanko
--- a/util/scan/dvb-t/fi-Hanko	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Hanko	Mon Aug 15 03:30:49 2011 +0300
@@ -1,5 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Hartola
--- a/util/scan/dvb-t/fi-Hartola	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Hartola	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Heinavesi
--- a/util/scan/dvb-t/fi-Heinavesi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Heinavesi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Heinola
--- a/util/scan/dvb-t/fi-Heinola	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Heinola	Mon Aug 15 03:30:49 2011 +0300
@@ -2,5 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 826000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Houtskari
--- a/util/scan/dvb-t/fi-Houtskari	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Houtskari	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Hyrynsalmi
--- a/util/scan/dvb-t/fi-Hyrynsalmi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Hyrynsalmi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara
--- a/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Hyvinkaa_Musta-Mannisto
--- a/util/scan/dvb-t/fi-Hyvinkaa_Musta-Mannisto	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Hyvinkaa_Musta-Mannisto	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 350000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Ikaalinen
--- a/util/scan/dvb-t/fi-Ikaalinen	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Ikaalinen	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Ikaalinen_Riitiala
--- a/util/scan/dvb-t/fi-Ikaalinen_Riitiala	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Ikaalinen_Riitiala	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Jalasjarvi
--- a/util/scan/dvb-t/fi-Jalasjarvi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Jalasjarvi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Jamsa_Kuorevesi_Halli
--- a/util/scan/dvb-t/fi-Jamsa_Kuorevesi_Halli	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Jamsa_Kuorevesi_Halli	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Joensuu_Vestinkallio
--- a/util/scan/dvb-t/fi-Joensuu_Vestinkallio	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Joensuu_Vestinkallio	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Joutsa_Lankia
--- a/util/scan/dvb-t/fi-Joutsa_Lankia	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Joutsa_Lankia	Mon Aug 15 03:30:49 2011 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Juupajoki_Kopsamo
--- a/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Juva
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Juva	Mon Aug 15 03:30:49 2011 +0300
@@ -0,0 +1,6 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kaavi_Luikonlahti
--- a/util/scan/dvb-t/fi-Kaavi_Luikonlahti	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kaavi_Luikonlahti	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kangaslampi
--- a/util/scan/dvb-t/fi-Kangaslampi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kangaslampi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kankaanpaa
--- a/util/scan/dvb-t/fi-Kankaanpaa	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kankaanpaa	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Keuruu_Haapamaki
--- a/util/scan/dvb-t/fi-Keuruu_Haapamaki	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Keuruu_Haapamaki	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kihnio
--- a/util/scan/dvb-t/fi-Kihnio	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kihnio	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Korppoo
--- a/util/scan/dvb-t/fi-Korppoo	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Korppoo	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kuhmo_Lentiira
--- a/util/scan/dvb-t/fi-Kuhmo_Lentiira	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kuhmo_Lentiira	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kuhmoinen
--- a/util/scan/dvb-t/fi-Kuhmoinen	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen
--- a/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Laukaa
--- a/util/scan/dvb-t/fi-Laukaa	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Laukaa	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Lieksa_Konnanvaara
--- a/util/scan/dvb-t/fi-Lieksa_Konnanvaara	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Lieksa_Konnanvaara	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Loimaa
--- a/util/scan/dvb-t/fi-Loimaa	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Loimaa	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Mantta
--- a/util/scan/dvb-t/fi-Mantta	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Mantta	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Nilsia
--- a/util/scan/dvb-t/fi-Nilsia	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Nilsia	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Nokia
--- a/util/scan/dvb-t/fi-Nokia	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Nokia	Mon Aug 15 03:30:49 2011 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 826000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Nokia_Siuro_Linnavuori
--- a/util/scan/dvb-t/fi-Nokia_Siuro_Linnavuori	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Nokia_Siuro_Linnavuori	Mon Aug 15 03:30:49 2011 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Nummi-Pusula_Hyonola
--- a/util/scan/dvb-t/fi-Nummi-Pusula_Hyonola	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Nummi-Pusula_Hyonola	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Nurmes_Kortevaara
--- a/util/scan/dvb-t/fi-Nurmes_Kortevaara	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Nurmes_Kortevaara	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen
--- a/util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Padasjoki
--- a/util/scan/dvb-t/fi-Padasjoki	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Padasjoki	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Parkano_Sopukallio
--- a/util/scan/dvb-t/fi-Parkano_Sopukallio	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Parkano_Sopukallio	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Porvoo_Suomenkyla
--- a/util/scan/dvb-t/fi-Porvoo_Suomenkyla	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Porvoo_Suomenkyla	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Pudasjarvi
--- a/util/scan/dvb-t/fi-Pudasjarvi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Pudasjarvi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote
--- a/util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Puolanka
--- a/util/scan/dvb-t/fi-Puolanka	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Puolanka	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Pyhatunturi
--- a/util/scan/dvb-t/fi-Pyhatunturi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Pyhatunturi	Mon Aug 15 03:30:49 2011 +0300
@@ -1,4 +1,4 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Raahe_Mestauskallio
--- a/util/scan/dvb-t/fi-Raahe_Mestauskallio	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Raahe_Mestauskallio	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Rautavaara_Angervikko
--- a/util/scan/dvb-t/fi-Rautavaara_Angervikko	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Rautavaara_Angervikko	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Ruovesi_Storminiemi
--- a/util/scan/dvb-t/fi-Ruovesi_Storminiemi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Ruovesi_Storminiemi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Tammisaari
--- a/util/scan/dvb-t/fi-Tammisaari	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Tammisaari	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Valtimo
--- a/util/scan/dvb-t/fi-Valtimo	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Valtimo	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Vammala_Jyranvuori
--- a/util/scan/dvb-t/fi-Vammala_Jyranvuori	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Jyranvuori	Mon Aug 15 03:30:49 2011 +0300
@@ -1,5 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Vammala_Savi
--- a/util/scan/dvb-t/fi-Vammala_Savi	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Savi	Mon Aug 15 03:30:49 2011 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 36a084aace47 util/scan/dvb-t/fi-Virrat_Lappavuori
--- a/util/scan/dvb-t/fi-Virrat_Lappavuori	Sat Jul 16 17:42:28 2011 +0200
+++ b/util/scan/dvb-t/fi-Virrat_Lappavuori	Mon Aug 15 03:30:49 2011 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------070604070002060401020603--
