Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([193.12.106.18]:44567 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1G0Mmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 08:42:52 -0400
Received: from [192.168.16.134] (assp.southpole.se [193.12.106.25])
	by mail.southpole.se (Postfix) with ESMTPA id C5780880002
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 14:21:15 +0200 (CEST)
Message-ID: <4E3002DF.7060209@ludd.ltu.se>
Date: Wed, 27 Jul 2011 14:21:51 +0200
From: Benjamin Larsson <banan@ludd.ltu.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Firmware extraction for IT9135 based devices
Content-Type: multipart/mixed;
 boundary="------------010604070709010008060209"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a multi-part message in MIME format.
--------------010604070709010008060209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

MvH
Benjamin Larsson

--------------010604070709010008060209
Content-Type: text/x-patch;
 name="0001-Firmware-extraction-for-IT9135-based-devices.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Firmware-extraction-for-IT9135-based-devices.patch"

>From b3cbee633f5a6403c2460892e64adcb88f6ae4a6 Mon Sep 17 00:00:00 2001
From: Benjamin Larsson <benjamin@southpole.se>
Date: Wed, 27 Jul 2011 13:43:38 +0200
Subject: [PATCH 1/1] Firmware extraction for IT9135 based devices


Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 Documentation/dvb/get_dvb_firmware |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index c466f58..65ebe20 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -27,7 +27,8 @@ use IO::Handle;
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
-		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5");
+		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
+                "it9135" );
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -665,6 +666,26 @@ sub drxk_terratec_h5 {
     "$fwfile"
 }
 
+sub it9135 {
+    my $url = "http://kworld.server261.com/kworld/CD/ITE_TiVme/V1.00/";
+    my $zipfile = "Driver_V10.323.1.0412.100412.zip";
+    my $hash = "79b597dc648698ed6820845c0c9d0d37";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
+    my $drvfile = "Driver_V10.323.1.0412.100412/Data/x86/IT9135BDA.sys";
+    my $fwfile = "dvb-usb-it9137-01.fw";
+
+    checkstandard();
+
+    wgetfile($zipfile, $url . $zipfile);
+    verify($zipfile, $hash);
+    unzip($zipfile, $tmpdir);
+    extract("$tmpdir/$drvfile", 69632, 5731, "$fwfile");
+
+    "$fwfile"
+}
+
+
+
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.1


--------------010604070709010008060209--
