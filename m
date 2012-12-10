Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:39858 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2LJVhp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:45 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 8/9] [media] get_dvb_firmware: add entry for the vp7049 firmware
Date: Mon, 10 Dec 2012 22:37:16 +0100
Message-Id: <1355175437-21623-9-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry to download the dvb-usb-vp7049-0.95.fw firmware for the
Twinhan vp7049 and similar devices.

Known devices of this kind are:
  Twinhan/Azurewave DTV-DVB UDTT7049
  Digicom Digitune-S
  Think Xtra Hollywood DVB-T USB2.0

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 Documentation/dvb/get_dvb_firmware |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 32bc56b..0cdb157 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -23,7 +23,7 @@ use IO::Handle;
 
 @components = ( "sp8870", "sp887x", "tda10045", "tda10046",
 		"tda10046lifeview", "av7110", "dec2000t", "dec2540t",
-		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
+		"dec3000s", "vp7041", "vp7049", "dibusb", "nxt2002", "nxt2004",
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
@@ -289,6 +289,19 @@ sub vp7041 {
     $outfile;
 }
 
+sub vp7049 {
+    my $fwfile = "dvb-usb-vp7049-0.95.fw";
+    my $url = "http://ao2.it/sites/default/files/blog/2012/11/06/linux-support-digicom-digitune-s-vp7049-udtt7049/$fwfile";
+    my $hash = "5609fd295168aea88b25ff43a6f79c36";
+
+    checkstandard();
+
+    wgetfile($fwfile, $url);
+    verify($fwfile, $hash);
+
+    $fwfile;
+}
+
 sub dibusb {
 	my $url = "http://www.linuxtv.org/downloads/firmware/dvb-usb-dibusb-5.0.0.11.fw";
 	my $outfile = "dvb-dibusb-5.0.0.11.fw";
-- 
1.7.10.4

