Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:50715 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMVch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 16:32:37 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so8182812wes.3
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 13:32:36 -0800 (PST)
Message-ID: <1392327139.6200.18.camel@canaries32-MCP7A>
Subject: [PATCH 4/4] get_dvb_firmware: it913x: Remove it9137 firmware files
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Date: Thu, 13 Feb 2014 21:32:19 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove it9137 firmware files it9137.txt and it9137 get_dvb_firmware.

dvb-usb-it9137-01.fw firmware is no longer in use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 Documentation/dvb/get_dvb_firmware | 22 ++--------------------
 Documentation/dvb/it9137.txt       |  9 ---------
 2 files changed, 2 insertions(+), 29 deletions(-)
 delete mode 100644 Documentation/dvb/it9137.txt

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 5d5ee4c..d91b8be 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -28,8 +28,8 @@ use IO::Handle;
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
-		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137",
-		"drxk_pctv", "drxk_terratec_htc_stick", "sms1xxx_hcw");
+		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "drxk_pctv",
+		"drxk_terratec_htc_stick", "sms1xxx_hcw");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -727,24 +727,6 @@ sub it9135 {
 	"$fwfile1 $fwfile2"
 }
 
-sub it9137 {
-    my $url = "http://kworld.server261.com/kworld/CD/ITE_TiVme/V1.00/";
-    my $zipfile = "Driver_V10.323.1.0412.100412.zip";
-    my $hash = "79b597dc648698ed6820845c0c9d0d37";
-    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
-    my $drvfile = "Driver_V10.323.1.0412.100412/Data/x86/IT9135BDA.sys";
-    my $fwfile = "dvb-usb-it9137-01.fw";
-
-    checkstandard();
-
-    wgetfile($zipfile, $url . $zipfile);
-    verify($zipfile, $hash);
-    unzip($zipfile, $tmpdir);
-    extract("$tmpdir/$drvfile", 69632, 5731, "$fwfile");
-
-    "$fwfile"
-}
-
 sub tda10071 {
     my $sourcefile = "PCTV_460e_reference.zip";
     my $url = "ftp://ftp.pctvsystems.com/TV/driver/PCTV%2070e%2080e%20100e%20320e%20330e%20800e/";
diff --git a/Documentation/dvb/it9137.txt b/Documentation/dvb/it9137.txt
deleted file mode 100644
index 9e6726e..0000000
--- a/Documentation/dvb/it9137.txt
+++ /dev/null
@@ -1,9 +0,0 @@
-To extract firmware for Kworld UB499-2T (id 1b80:e409) you need to copy the
-following file(s) to this directory.
-
-IT9135BDA.sys Dated Mon 22 Mar 2010 02:20:08 GMT
-
-extract using dd
-dd if=IT9135BDA.sys ibs=1 skip=69632 count=5731 of=dvb-usb-it9137-01.fw
-
-copy to default firmware location.
-- 
1.9.rc1

