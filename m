Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35144 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1K3VRw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:17:52 -0500
Received: by eeuu47 with SMTP id u47so653102eeu.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:17:51 -0800 (PST)
Message-ID: <1322687863.2476.10.camel@tvbox>
Subject: [PATCH 3/3] [For 3.3] it913x dvb-get-firmware update
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 30 Nov 2011 21:17:43 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes to extract firmware for it913x devices

./get_dvb_firmware it9135
extracts
dvb-usb-it9135-01.fw
dvb-usb-it9135-02.fw

./get_dvb_firmware it9137
extracts
dvb-usb-it9137-01.fw

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 0f15ab7..d1d4a17 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -28,7 +28,7 @@ use IO::Handle;
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
-		"drxk_hauppauge_hvr930c", "tda10071", "it9135" );
+		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -676,6 +676,26 @@ sub drxk_terratec_h5 {
 }
 
 sub it9135 {
+	my $sourcefile = "dvb-usb-it9135.zip";
+	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
+	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
+	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
+	my $outfile = "dvb-usb-it9135.fw";
+	my $fwfile1 = "dvb-usb-it9135-01.fw";
+	my $fwfile2 = "dvb-usb-it9135-02.fw";
+
+	checkstandard();
+
+	wgetfile($sourcefile, $url);
+	unzip($sourcefile, $tmpdir);
+	verify("$tmpdir/$outfile", $hash);
+	extract("$tmpdir/$outfile", 64, 8128, "$fwfile1");
+	extract("$tmpdir/$outfile", 12866, 5817, "$fwfile2");
+
+	"$fwfile1 $fwfile2"
+}
+
+sub it9137 {
     my $url = "http://kworld.server261.com/kworld/CD/ITE_TiVme/V1.00/";
     my $zipfile = "Driver_V10.323.1.0412.100412.zip";
     my $hash = "79b597dc648698ed6820845c0c9d0d37";
-- 
1.7.7.1



