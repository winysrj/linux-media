Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53892 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FLWTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:36 -0400
Received: by weyu7 with SMTP id u7so40001wey.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 15:19:35 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: sven.pilz@gmail.com, soeren.moch@ims.uni-hannover.de,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/3] [media] Add support for downloading the firmware of the Terratec Cinergy HTC Stick HD's firmware.
Date: Wed, 13 Jun 2012 00:19:26 +0200
Message-Id: <1339539568-7725-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of June 2012 it uses the same firmware as the Hauppauge WinTV HVR 930C.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/dvb/get_dvb_firmware |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index fbb2411..94b0168 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -29,7 +29,7 @@ use IO::Handle;
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
 		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137",
-		"drxk_pctv");
+		"drxk_pctv", "drxk_terratec_htc_stick");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -676,6 +676,24 @@ sub drxk_terratec_h5 {
     "$fwfile"
 }
 
+sub drxk_terratec_htc_stick {
+    my $url = "http://ftp.terratec.de/Receiver/Cinergy_HTC_Stick/Updates/";
+    my $zipfile = "Cinergy_HTC_Stick_Drv_5.09.1202.00_XP_Vista_7.exe";
+    my $hash = "6722a2442a05423b781721fbc069ed5e";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
+    my $drvfile = "Cinergy HTC Stick/BDA Driver 5.09.1202.00/Windows 32 Bit/emOEM.sys";
+    my $fwfile = "dvb-usb-terratec-htc-stick-drxk.fw";
+
+    checkstandard();
+
+    wgetfile($zipfile, $url . $zipfile);
+    verify($zipfile, $hash);
+    unzip($zipfile, $tmpdir);
+    extract("$tmpdir/$drvfile", 0x4e5c0, 42692, "$fwfile");
+
+    "$fwfile"
+}
+
 sub it9135 {
 	my $sourcefile = "dvb-usb-it9135.zip";
 	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
-- 
1.7.10.4

