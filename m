Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50721 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1LSQwD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 11:52:03 -0500
Message-ID: <4EEF6BAD.1020805@iki.fi>
Date: Mon, 19 Dec 2011 18:51:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [PATCH dvb-apps] update Finland DVB-T initial tuning files
Content-Type: multipart/mixed;
 boundary="------------060505060304060702050405"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505060304060702050405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello

Actually almost all those new multiplexes are for DVB-T2... but maybe 
better to add those and fix later.

regards
Antti

-- 
http://palosaari.fi/

--------------060505060304060702050405
Content-Type: text/plain;
 name="fi-update_2011-12-19.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fi-update_2011-12-19.patch"

diff -r bec11f78be51 util/scan/dvb-t/fi-Espoo
--- a/util/scan/dvb-t/fi-Espoo	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Espoo	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Eurajoki
--- a/util/scan/dvb-t/fi-Eurajoki	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Eurajoki	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Jyvaskyla
--- a/util/scan/dvb-t/fi-Jyvaskyla	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Jyvaskyla	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Lahti
--- a/util/scan/dvb-t/fi-Lahti	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Lahti	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Lohja
--- a/util/scan/dvb-t/fi-Lohja	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Lohja	Mon Dec 19 18:47:59 2011 +0200
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Oulu
--- a/util/scan/dvb-t/fi-Oulu	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Oulu	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Tampere
--- a/util/scan/dvb-t/fi-Tampere	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Tampere	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r bec11f78be51 util/scan/dvb-t/fi-Turku
--- a/util/scan/dvb-t/fi-Turku	Wed Dec 07 15:26:50 2011 +0100
+++ b/util/scan/dvb-t/fi-Turku	Mon Dec 19 18:47:59 2011 +0200
@@ -4,3 +4,4 @@
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------060505060304060702050405--
