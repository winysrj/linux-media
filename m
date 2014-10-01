Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35863 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJAF6Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:58:24 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 1/2] get_dvb_firmware: si2165: drop the extra header from the firmware
Date: Wed,  1 Oct 2014 07:58:17 +0200
Message-Id: <1412143098-18293-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Store it with a different name based on hardware revision.

V2: change firmware filename to lower case.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 Documentation/dvb/get_dvb_firmware | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 91b43d2..c3e758b 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -789,7 +789,8 @@ sub si2165 {
     my $sourcefile = "model_111xxx_122xxx_driver_6_0_119_31191_WHQL.zip";
     my $url = "http://www.hauppauge.de/files/drivers/";
     my $hash = "76633e7c76b0edee47c3ba18ded99336";
-    my $fwfile = "dvb-demod-si2165.fw";
+    my $fwfile = "dvb-demod-si2165-d.fw";
+    my $fwhash = "1255c70a53fe562a89d5ff08d7461e2c";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
 
     checkstandard();
@@ -797,21 +798,8 @@ sub si2165 {
     wgetfile($sourcefile, $url . $sourcefile);
     verify($sourcefile, $hash);
     unzip($sourcefile, $tmpdir);
-    extract("$tmpdir/Driver10/Hcw10bda.sys", 0x80788, 0x81E08-0x80788, "$tmpdir/fw1");
-
-    delzero("$tmpdir/fw1","$tmpdir/fw1-1");
-    #verify("$tmpdir/fw1","5e0909858fdf0b5b09ad48b9fe622e70");
-
-    my $CRC="\x0A\xCC";
-    my $BLOCKS_MAIN="\x27";
-    open FW,">$fwfile";
-    print FW "\x01\x00"; # just a version id for the driver itself
-    print FW "\x9A"; # fw version
-    print FW "\x00"; # padding
-    print FW "$BLOCKS_MAIN"; # number of blocks of main part
-    print FW "\x00"; # padding
-    print FW "$CRC"; # 16bit crc value of main part
-    appendfile(FW,"$tmpdir/fw1");
+    extract("$tmpdir/Driver10/Hcw10bda.sys", 0x80788, 0x81E08-0x80788, "$fwfile");
+    verify($fwfile, $fwhash);
 
     "$fwfile";
 }
-- 
2.1.1

