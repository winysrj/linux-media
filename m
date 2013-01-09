Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58062 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab3AIP0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 10:26:51 -0500
Message-ID: <50ED8C15.8010807@iki.fi>
Date: Wed, 09 Jan 2013 17:26:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>,
	LMML <linux-media@vger.kernel.org>
Subject: Fwd: update Finland DVB-T tuning files
References: <500DBA9E.10105@iki.fi>
In-Reply-To: <500DBA9E.10105@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------040704040306090903060205"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040704040306090903060205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Oliver,
could you apply that one?

Antti


-------- Original Message --------
Subject: update Finland DVB-T tuning files
Date: Mon, 23 Jul 2012 23:57:02 +0300
From: Antti Palosaari <crope@iki.fi>
To: Christoph Pfister <christophpfister@gmail.com>,        linux-media 
<linux-media@vger.kernel.org>

Christoph, apply attached patch thanks!

Antti
-- 
http://palosaari.fi/




--------------040704040306090903060205
Content-Type: text/x-patch;
 name="fi-update-2012-07-23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fi-update-2012-07-23.patch"

# HG changeset patch
# User Antti Palosaari <crope@iki.fi>
# Date 1343076451 -10800
# Node ID 595b4077aa6c5dda3374c95596800a2505116e99
# Parent  96025655e6e844af2bc69bd368f8d04a4e5bc58b
update Finland DVB-T initial tuning files

diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Aanekoski
--- a/util/scan/dvb-t/fi-Aanekoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Aanekoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Aanekoski_Konginkangas
--- a/util/scan/dvb-t/fi-Aanekoski_Konginkangas	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Aanekoski_Konginkangas	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ahtari
--- a/util/scan/dvb-t/fi-Ahtari	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ahtari	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ala-Vuokki
--- a/util/scan/dvb-t/fi-Ala-Vuokki	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Alajarvi
--- a/util/scan/dvb-t/fi-Alajarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Alajarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ammansaari
--- a/util/scan/dvb-t/fi-Ammansaari	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Anjalankoski
--- a/util/scan/dvb-t/fi-Anjalankoski	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Anjalankoski_Ruotila
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Anjalankoski_Ruotila	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,7 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Enontekio_Ahovaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Enontekio_Ahovaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Enontekio_Hetta
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Enontekio_Hetta	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Enontekio_Kuttanen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Enontekio_Kuttanen	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Enontekio_Raattama
--- a/util/scan/dvb-t/fi-Enontekio_Raattama	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Espoo
--- a/util/scan/dvb-t/fi-Espoo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Espoo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Eurajoki
--- a/util/scan/dvb-t/fi-Eurajoki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Eurajoki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Fiskars
--- a/util/scan/dvb-t/fi-Fiskars	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Fiskars	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Haapavesi
--- a/util/scan/dvb-t/fi-Haapavesi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Haapavesi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hameenkyro_Kyroskoski
--- a/util/scan/dvb-t/fi-Hameenkyro_Kyroskoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hameenkyro_Kyroskoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hameenlinna_Painokangas
--- a/util/scan/dvb-t/fi-Hameenlinna_Painokangas	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hameenlinna_Painokangas	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hanko
--- a/util/scan/dvb-t/fi-Hanko	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hanko	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hartola
--- a/util/scan/dvb-t/fi-Hartola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hartola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Haukela
--- a/util/scan/dvb-t/fi-Haukela	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Heinavesi
--- a/util/scan/dvb-t/fi-Heinavesi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Heinavesi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Heinola
--- a/util/scan/dvb-t/fi-Heinola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Heinola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hetta
--- a/util/scan/dvb-t/fi-Hetta	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hossa
--- a/util/scan/dvb-t/fi-Hossa	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Houtskari
--- a/util/scan/dvb-t/fi-Houtskari	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hyrynsalmi
--- a/util/scan/dvb-t/fi-Hyrynsalmi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hyrynsalmi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara
--- a/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hyrynsalmi_Paljakka
--- a/util/scan/dvb-t/fi-Hyrynsalmi_Paljakka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Paljakka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hyvinkaa
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyvinkaa	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,6 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 350000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Hyvinkaa_Musta-Mannisto
--- a/util/scan/dvb-t/fi-Hyvinkaa_Musta-Mannisto	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 350000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ii_Raiskio
--- a/util/scan/dvb-t/fi-Ii_Raiskio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ii_Raiskio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Iisalmi
--- a/util/scan/dvb-t/fi-Iisalmi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Iisalmi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ikaalinen
--- a/util/scan/dvb-t/fi-Ikaalinen	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ikaalinen	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ikaalinen_Riitiala
--- a/util/scan/dvb-t/fi-Ikaalinen_Riitiala	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ikaalinen_Riitiala	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Inari
--- a/util/scan/dvb-t/fi-Inari	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Inari	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Inari_Janispaa
--- a/util/scan/dvb-t/fi-Inari_Janispaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Inari_Janispaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Inari_Naatamo
--- a/util/scan/dvb-t/fi-Inari_Naatamo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Inari_Naatamo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ivalo_Saarineitamovaara
--- a/util/scan/dvb-t/fi-Ivalo_Saarineitamovaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ivalo_Saarineitamovaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jalasjarvi
--- a/util/scan/dvb-t/fi-Jalasjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jalasjarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsa_Halli
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jamsa_Halli	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,6 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsa_Kaipola
--- a/util/scan/dvb-t/fi-Jamsa_Kaipola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jamsa_Kaipola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsa_Kuorevesi_Halli
--- a/util/scan/dvb-t/fi-Jamsa_Kuorevesi_Halli	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsa_Matkosvuori
--- a/util/scan/dvb-t/fi-Jamsa_Matkosvuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jamsa_Matkosvuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsa_Ouninpohja
--- a/util/scan/dvb-t/fi-Jamsa_Ouninpohja	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jamsa_Ouninpohja	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jamsankoski
--- a/util/scan/dvb-t/fi-Jamsankoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jamsankoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Joensuu_Vestinkallio
--- a/util/scan/dvb-t/fi-Joensuu_Vestinkallio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Joensuu_Vestinkallio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Joroinen_Puukkola
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Joroinen_Puukkola	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Joroinen_Puukkola-Huutokoski
--- a/util/scan/dvb-t/fi-Joroinen_Puukkola-Huutokoski	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Joutsa_Lankia
--- a/util/scan/dvb-t/fi-Joutsa_Lankia	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Joutsa_Lankia	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Joutseno
--- a/util/scan/dvb-t/fi-Joutseno	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Joutseno	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Juntusranta
--- a/util/scan/dvb-t/fi-Juntusranta	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Juupajoki_Kopsamo
--- a/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Juva
--- a/util/scan/dvb-t/fi-Juva	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Juva	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jyvaskyla
--- a/util/scan/dvb-t/fi-Jyvaskyla	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Jyvaskyla	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Jyvaskyla_Vaajakoski
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jyvaskyla_Vaajakoski	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kaavi_Luikonlahti
--- a/util/scan/dvb-t/fi-Kaavi_Luikonlahti	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kaavi_Sivakkavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kaavi_Sivakkavaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kajaani_Pollyvaara
--- a/util/scan/dvb-t/fi-Kajaani_Pollyvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kajaani_Pollyvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kalajoki
--- a/util/scan/dvb-t/fi-Kalajoki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kalajoki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kangaslampi
--- a/util/scan/dvb-t/fi-Kangaslampi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kangaslampi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kangasniemi_Turkinmaki
--- a/util/scan/dvb-t/fi-Kangasniemi_Turkinmaki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kangasniemi_Turkinmaki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kankaanpaa
--- a/util/scan/dvb-t/fi-Kankaanpaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kankaanpaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Karigasniemi
--- a/util/scan/dvb-t/fi-Karigasniemi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Karigasniemi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Karkkila
--- a/util/scan/dvb-t/fi-Karkkila	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Karkkila	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Karstula
--- a/util/scan/dvb-t/fi-Karstula	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Karstula	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Karvia
--- a/util/scan/dvb-t/fi-Karvia	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Karvia	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kaunispaa
--- a/util/scan/dvb-t/fi-Kaunispaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kaunispaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kemijarvi_Suomutunturi
--- a/util/scan/dvb-t/fi-Kemijarvi_Suomutunturi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kemijarvi_Suomutunturi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kerimaki
--- a/util/scan/dvb-t/fi-Kerimaki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kerimaki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Keuruu
--- a/util/scan/dvb-t/fi-Keuruu	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Keuruu	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Keuruu_Haapamaki
--- a/util/scan/dvb-t/fi-Keuruu_Haapamaki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Keuruu_Haapamaki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kihnio
--- a/util/scan/dvb-t/fi-Kihnio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kihnio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kiihtelysvaara
--- a/util/scan/dvb-t/fi-Kiihtelysvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kiihtelysvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kilpisjarvi
--- a/util/scan/dvb-t/fi-Kilpisjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kilpisjarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kittila_Levitunturi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kittila_Levitunturi	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kittila_Sirkka_Levitunturi
--- a/util/scan/dvb-t/fi-Kittila_Sirkka_Levitunturi	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kolari_Vuolittaja
--- a/util/scan/dvb-t/fi-Kolari_Vuolittaja	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kolari_Vuolittaja	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Koli
--- a/util/scan/dvb-t/fi-Koli	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Koli	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Korpilahti_Vaarunvuori
--- a/util/scan/dvb-t/fi-Korpilahti_Vaarunvuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Korpilahti_Vaarunvuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Korppoo
--- a/util/scan/dvb-t/fi-Korppoo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Korppoo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kruunupyy
--- a/util/scan/dvb-t/fi-Kruunupyy	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kruunupyy	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmo_Haukela
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmo_Haukela	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmo_Iivantiira
--- a/util/scan/dvb-t/fi-Kuhmo_Iivantiira	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmo_Lentiira
--- a/util/scan/dvb-t/fi-Kuhmo_Lentiira	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kuhmo_Lentiira	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmo_Niva
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmo_Niva	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmoinen
--- a/util/scan/dvb-t/fi-Kuhmoinen	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmoinen_Harjunsalmi
--- a/util/scan/dvb-t/fi-Kuhmoinen_Harjunsalmi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen_Harjunsalmi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen
--- a/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuopio
--- a/util/scan/dvb-t/fi-Kuopio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kuopio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kustavi_Viherlahti
--- a/util/scan/dvb-t/fi-Kustavi_Viherlahti	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kustavi_Viherlahti	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuttanen
--- a/util/scan/dvb-t/fi-Kuttanen	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kuusamo_Hamppulampi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuusamo_Hamppulampi	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Kyyjarvi_Noposenaho
--- a/util/scan/dvb-t/fi-Kyyjarvi_Noposenaho	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Kyyjarvi_Noposenaho	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lahti
--- a/util/scan/dvb-t/fi-Lahti	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Lahti	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lapua
--- a/util/scan/dvb-t/fi-Lapua	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Lapua	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Laukaa
--- a/util/scan/dvb-t/fi-Laukaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Laukaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Laukaa_Vihtavuori
--- a/util/scan/dvb-t/fi-Laukaa_Vihtavuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Laukaa_Vihtavuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lavia
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Lavia	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lavia_Lavianjarvi
--- a/util/scan/dvb-t/fi-Lavia_Lavianjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lieksa_Konnanvaara
--- a/util/scan/dvb-t/fi-Lieksa_Konnanvaara	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Lohja
--- a/util/scan/dvb-t/fi-Lohja	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Lohja	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Loimaa
--- a/util/scan/dvb-t/fi-Loimaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Loimaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Luhanka
--- a/util/scan/dvb-t/fi-Luhanka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Luhanka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Luopioinen
--- a/util/scan/dvb-t/fi-Luopioinen	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Luopioinen	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Mantta
--- a/util/scan/dvb-t/fi-Mantta	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Mantta	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Mantyharju
--- a/util/scan/dvb-t/fi-Mantyharju	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Mantyharju	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Mikkeli
--- a/util/scan/dvb-t/fi-Mikkeli	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Mikkeli	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Muonio_Olostunturi
--- a/util/scan/dvb-t/fi-Muonio_Olostunturi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Muonio_Olostunturi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Mustasaari
--- a/util/scan/dvb-t/fi-Mustasaari	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,3 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Myllylahti
--- a/util/scan/dvb-t/fi-Myllylahti	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nilsia
--- a/util/scan/dvb-t/fi-Nilsia	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nilsia	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi
--- a/util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nilsia_Pisa
--- a/util/scan/dvb-t/fi-Nilsia_Pisa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nilsia_Pisa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nokia
--- a/util/scan/dvb-t/fi-Nokia	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nokia	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nokia_Siuro
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nokia_Siuro	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,6 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nokia_Siuro_Linnavuori
--- a/util/scan/dvb-t/fi-Nokia_Siuro_Linnavuori	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,6 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nummi-Pusula_Hyonola
--- a/util/scan/dvb-t/fi-Nummi-Pusula_Hyonola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nummi-Pusula_Hyonola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nuorgam_Njallavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nuorgam_Njallavaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nuorgam_raja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nuorgam_raja	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nurmes_Konnanvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nurmes_Konnanvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,6 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Nurmes_Kortevaara
--- a/util/scan/dvb-t/fi-Nurmes_Kortevaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Nurmes_Kortevaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen
--- a/util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Orivesi_Talviainen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Orivesi_Talviainen	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,5 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Oulu
--- a/util/scan/dvb-t/fi-Oulu	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Oulu	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Padasjoki
--- a/util/scan/dvb-t/fi-Padasjoki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Padasjoki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Padasjoki_Arrakoski
--- a/util/scan/dvb-t/fi-Padasjoki_Arrakoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Padasjoki_Arrakoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Paltamo_Kivesvaara
--- a/util/scan/dvb-t/fi-Paltamo_Kivesvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Paltamo_Kivesvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Parainen_Houtskari
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Parainen_Houtskari	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,6 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Parikkala
--- a/util/scan/dvb-t/fi-Parikkala	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Parikkala	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Parkano_Sopukallio
--- a/util/scan/dvb-t/fi-Parkano_Sopukallio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Parkano_Sopukallio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pello
--- a/util/scan/dvb-t/fi-Pello	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pello	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pello_Ratasvaara
--- a/util/scan/dvb-t/fi-Pello_Ratasvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pello_Ratasvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Perho
--- a/util/scan/dvb-t/fi-Perho	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Perho	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pernaja
--- a/util/scan/dvb-t/fi-Pernaja	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pernaja	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pieksamaki_Halkokumpu
--- a/util/scan/dvb-t/fi-Pieksamaki_Halkokumpu	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pieksamaki_Halkokumpu	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pihtipudas
--- a/util/scan/dvb-t/fi-Pihtipudas	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pihtipudas	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Porvoo_Suomenkyla
--- a/util/scan/dvb-t/fi-Porvoo_Suomenkyla	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Porvoo_Suomenkyla	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Posio
--- a/util/scan/dvb-t/fi-Posio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Posio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pudasjarvi
--- a/util/scan/dvb-t/fi-Pudasjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pudasjarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pudasjarvi_Hirvaskoski
--- a/util/scan/dvb-t/fi-Pudasjarvi_Hirvaskoski	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote
--- a/util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pudasjarvi_Iso-Syote	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Puolanka
--- a/util/scan/dvb-t/fi-Puolanka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Puolanka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pyhatunturi
--- a/util/scan/dvb-t/fi-Pyhatunturi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pyhatunturi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pyhavuori
--- a/util/scan/dvb-t/fi-Pyhavuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pyhavuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi
--- a/util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Raahe_Mestauskallio
--- a/util/scan/dvb-t/fi-Raahe_Mestauskallio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Raahe_Mestauskallio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Raahe_Piehinki
--- a/util/scan/dvb-t/fi-Raahe_Piehinki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Raahe_Piehinki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ranua_Haasionmaa
--- a/util/scan/dvb-t/fi-Ranua_Haasionmaa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ranua_Haasionmaa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ranua_Leppiaho
--- a/util/scan/dvb-t/fi-Ranua_Leppiaho	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ranua_Leppiaho	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rautavaara_Angervikko
--- a/util/scan/dvb-t/fi-Rautavaara_Angervikko	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rautavaara_Angervikko	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rautjarvi_Simpele
--- a/util/scan/dvb-t/fi-Rautjarvi_Simpele	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rautjarvi_Simpele	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ristijarvi
--- a/util/scan/dvb-t/fi-Ristijarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ristijarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi
--- a/util/scan/dvb-t/fi-Rovaniemi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Ala-Nampa_Yli-Nampa_Rantalaki
--- a/util/scan/dvb-t/fi-Rovaniemi_Ala-Nampa_Yli-Nampa_Rantalaki	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Kaihuanvaara
--- a/util/scan/dvb-t/fi-Rovaniemi_Kaihuanvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi_Kaihuanvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Karhuvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Karhuvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Marasenkallio
--- a/util/scan/dvb-t/fi-Rovaniemi_Marasenkallio	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi_Marasenkallio	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Marrasjarvi
--- a/util/scan/dvb-t/fi-Rovaniemi_Marrasjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Meltaus_Sorviselka
--- a/util/scan/dvb-t/fi-Rovaniemi_Meltaus_Sorviselka	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Rantalaki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Rantalaki	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Sonka
--- a/util/scan/dvb-t/fi-Rovaniemi_Sonka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi_Sonka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Rovaniemi_Sorviselka
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Sorviselka	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ruka
--- a/util/scan/dvb-t/fi-Ruka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ruka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ruovesi_Storminiemi
--- a/util/scan/dvb-t/fi-Ruovesi_Storminiemi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ruovesi_Storminiemi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Saarijarvi
--- a/util/scan/dvb-t/fi-Saarijarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Saarijarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Saarijarvi_Kalmari
--- a/util/scan/dvb-t/fi-Saarijarvi_Kalmari	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Saarijarvi_Kalmari	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Saarijarvi_Mahlu
--- a/util/scan/dvb-t/fi-Saarijarvi_Mahlu	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Saarijarvi_Mahlu	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salla_Hirvasvaara
--- a/util/scan/dvb-t/fi-Salla_Hirvasvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salla_Hirvasvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salla_Ihistysjanka
--- a/util/scan/dvb-t/fi-Salla_Ihistysjanka	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salla_Ihistysjanka	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salla_Naruska
--- a/util/scan/dvb-t/fi-Salla_Naruska	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salla_Naruska	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salla_Sallatunturi
--- a/util/scan/dvb-t/fi-Salla_Sallatunturi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salla_Sallatunturi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salla_Sarivaara
--- a/util/scan/dvb-t/fi-Salla_Sarivaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salla_Sarivaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Salo_Isokyla
--- a/util/scan/dvb-t/fi-Salo_Isokyla	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Salo_Isokyla	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Savukoski_Martti
--- a/util/scan/dvb-t/fi-Savukoski_Martti	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Savukoski_Martti	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Savukoski_Tanhua
--- a/util/scan/dvb-t/fi-Savukoski_Tanhua	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Savukoski_Tanhua	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Siilinjarvi
--- a/util/scan/dvb-t/fi-Siilinjarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Siilinjarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Sipoo_Norrkulla
--- a/util/scan/dvb-t/fi-Sipoo_Norrkulla	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Sipoo_Norrkulla	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Sodankyla_Pittiovaara
--- a/util/scan/dvb-t/fi-Sodankyla_Pittiovaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Sodankyla_Pittiovaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Sodankyla_Vuotso
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Sodankyla_Vuotso	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Sulkava_Vaatalanmaki
--- a/util/scan/dvb-t/fi-Sulkava_Vaatalanmaki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Sulkava_Vaatalanmaki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Suomussalmi_Ala-Vuokki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Suomussalmi_Ala-Vuokki	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Suomussalmi_Ammansaari
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Suomussalmi_Ammansaari	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Suomussalmi_Juntusranta
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Suomussalmi_Juntusranta	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Suomussalmi_Myllylahti
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Suomussalmi_Myllylahti	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Sysma_Liikola
--- a/util/scan/dvb-t/fi-Sysma_Liikola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Sysma_Liikola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Taivalkoski
--- a/util/scan/dvb-t/fi-Taivalkoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Taivalkoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Taivalkoski_Taivalvaara
--- a/util/scan/dvb-t/fi-Taivalkoski_Taivalvaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Taivalkoski_Taivalvaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Tammela
--- a/util/scan/dvb-t/fi-Tammela	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Tammela	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Tammisaari
--- a/util/scan/dvb-t/fi-Tammisaari	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Tammisaari	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Tampere
--- a/util/scan/dvb-t/fi-Tampere	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Tampere	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Tampere_Pyynikki
--- a/util/scan/dvb-t/fi-Tampere_Pyynikki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Tampere_Pyynikki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,6 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Tervola
--- a/util/scan/dvb-t/fi-Tervola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Tervola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Turku
--- a/util/scan/dvb-t/fi-Turku	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Turku	Mon Jul 23 23:47:31 2012 +0300
@@ -1,7 +1,7 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki
--- a/util/scan/dvb-t/fi-Utsjoki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara
--- a/util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja
--- a/util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Nuvvus
--- a/util/scan/dvb-t/fi-Utsjoki_Nuvvus	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki_Nuvvus	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Outakoski
--- a/util/scan/dvb-t/fi-Utsjoki_Outakoski	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki_Outakoski	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Polvarniemi
--- a/util/scan/dvb-t/fi-Utsjoki_Polvarniemi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki_Polvarniemi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Rovisuvanto
--- a/util/scan/dvb-t/fi-Utsjoki_Rovisuvanto	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki_Rovisuvanto	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Utsjoki_Tenola
--- a/util/scan/dvb-t/fi-Utsjoki_Tenola	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Utsjoki_Tenola	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Uusikaupunki_Orivo
--- a/util/scan/dvb-t/fi-Uusikaupunki_Orivo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Uusikaupunki_Orivo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vaajakoski
--- a/util/scan/dvb-t/fi-Vaajakoski	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,5 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vaala
--- a/util/scan/dvb-t/fi-Vaala	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vaala	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vaasa
--- a/util/scan/dvb-t/fi-Vaasa	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vaasa	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Valtimo
--- a/util/scan/dvb-t/fi-Valtimo	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Valtimo	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vammala_Jyranvuori
--- a/util/scan/dvb-t/fi-Vammala_Jyranvuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Jyranvuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vammala_Roismala
--- a/util/scan/dvb-t/fi-Vammala_Roismala	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Roismala	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vammala_Savi
--- a/util/scan/dvb-t/fi-Vammala_Savi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Savi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vantaa_Hakunila
--- a/util/scan/dvb-t/fi-Vantaa_Hakunila	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vantaa_Hakunila	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Varpaisjarvi_Honkamaki
--- a/util/scan/dvb-t/fi-Varpaisjarvi_Honkamaki	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Varpaisjarvi_Honkamaki	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Virrat_Lappavuori
--- a/util/scan/dvb-t/fi-Virrat_Lappavuori	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Virrat_Lappavuori	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vuokatti
--- a/util/scan/dvb-t/fi-Vuokatti	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Vuokatti	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Vuotso
--- a/util/scan/dvb-t/fi-Vuotso	Tue Jun 26 22:28:54 2012 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ylitornio_Ainiovaara
--- a/util/scan/dvb-t/fi-Ylitornio_Ainiovaara	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ylitornio_Ainiovaara	Mon Jul 23 23:47:31 2012 +0300
@@ -1,5 +1,5 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Ylitornio_Raanujarvi
--- a/util/scan/dvb-t/fi-Ylitornio_Raanujarvi	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Ylitornio_Raanujarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Yllas
--- a/util/scan/dvb-t/fi-Yllas	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/fi-Yllas	Mon Jul 23 23:47:31 2012 +0300
@@ -1,4 +1,4 @@
-# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 96025655e6e8 -r 595b4077aa6c util/scan/dvb-t/fi-Yllasjarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Yllasjarvi	Mon Jul 23 23:47:31 2012 +0300
@@ -0,0 +1,4 @@
+# 2012-07-23 Antti Palosaari <crope@iki.fi>
+# generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE


--------------040704040306090903060205--
