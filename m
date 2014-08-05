Return-path: <linux-media-owner@vger.kernel.org>
Received: from HC210-202-87-179.vdslpro.static.apol.com.tw ([210.202.87.179]:58339
	"EHLO ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaHEFn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 01:43:26 -0400
Received: from ms2.internal.ite.com.tw (ms2.internal.ite.com.tw [192.168.15.236])
	by mse.ite.com.tw with ESMTP id s755hIXl000575
	for <linux-media@vger.kernel.org>; Tue, 5 Aug 2014 13:43:18 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
Received: from [192.168.190.2] (unknown [192.168.190.2])
	by ms2.internal.ite.com.tw (Postfix) with ESMTP id 1FFAA45307
	for <linux-media@vger.kernel.org>; Tue,  5 Aug 2014 13:43:15 +0800 (CST)
Subject: [PATCH 1/4] V4L/DVB: Update firmware of ITEtech IT9135
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-M3NlUEBCGTX12VNRdTd1"
Date: Tue, 05 Aug 2014 13:44:18 +0800
Message-ID: <1407217458.2988.3.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-M3NlUEBCGTX12VNRdTd1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-M3NlUEBCGTX12VNRdTd1
Content-Disposition: attachment; filename="0001-Update-firmware-of-ITEtech-IT9135.patch"
Content-Type: text/x-patch; name="0001-Update-firmware-of-ITEtech-IT9135.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From b5f4f4c0060ed95ea93f1aadc361eaa71929176c Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Fri, 1 Aug 2014 17:19:58 +0800
Subject: [PATCH 1/4] Update firmware of ITEtech IT9135.


Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 Documentation/dvb/get_dvb_firmware |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index d91b8be..efa100a 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -708,23 +708,25 @@ sub drxk_terratec_htc_stick {
 }
 
 sub it9135 {
-	my $sourcefile = "dvb-usb-it9135.zip";
-	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
-	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
-	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
-	my $outfile = "dvb-usb-it9135.fw";
+	my $url = "http://www.ite.com.tw/uploads/firmware/v3.25.0.0/";
+	my $file1 = "dvb-usb-it9135-01.zip";
 	my $fwfile1 = "dvb-usb-it9135-01.fw";
+	my $hash1 = "02fcf11174eda84745dae7e61c5ff9ba";
+	my $file2 = "dvb-usb-it9135-02.zip";
 	my $fwfile2 = "dvb-usb-it9135-02.fw";
+	my $hash2 = "d5e1437dc24358578e07999475d4cac9";
 
 	checkstandard();
 
-	wgetfile($sourcefile, $url);
-	unzip($sourcefile, $tmpdir);
-	verify("$tmpdir/$outfile", $hash);
-	extract("$tmpdir/$outfile", 64, 8128, "$fwfile1");
-	extract("$tmpdir/$outfile", 12866, 5817, "$fwfile2");
+	wgetfile($file1, $url . $file1);
+	unzip($file1, "");
+	verify("$fwfile1", $hash1);
+
+	wgetfile($file2, $url . $file2);
+	unzip($file2, "");
+	verify("$fwfile2", $hash2);
 
-	"$fwfile1 $fwfile2"
+	"$file1 $file2"
 }
 
 sub tda10071 {
-- 
1.7.0.4


--=-M3NlUEBCGTX12VNRdTd1--

