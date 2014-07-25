Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:21991 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaGYIUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 04:20:55 -0400
Received: from ms2.internal.ite.com.tw (ms2.internal.ite.com.tw [192.168.15.236])
	by mse.ite.com.tw with ESMTP id s6P8AchZ087547
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 16:10:38 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
Received: from [192.168.190.2] (unknown [192.168.190.2])
	by ms2.internal.ite.com.tw (Postfix) with ESMTP id 83F3645307
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 16:10:34 +0800 (CST)
Subject: [PATCH] V4L/DVB: dvb-usb-v2: Update firmware and driver for
 performance of ITEtech IT9135
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-GRNu5yI+gCeLeeIqiIp3"
Date: Fri, 25 Jul 2014 16:11:20 +0800
Message-ID: <1406275880.18033.3.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GRNu5yI+gCeLeeIqiIp3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Fix performance issue of IT9135 AX and BX chip versions.

--=-GRNu5yI+gCeLeeIqiIp3
Content-Disposition: attachment; filename*0=0001-Update-firmware-and-driver-for-performance-of-ITEtec.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-Update-firmware-and-driver-for-performance-of-ITEtec.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 57fe102419e83e73080af15cc3ad3fe241d7f8b4 Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Thu, 24 Jul 2014 13:23:39 +0800
Subject: [PATCH 1/1] Update firmware and driver for performance of ITEtech IT9135

Fix performance issue of IT9135 AX and BX chip versions.

Signed-off-by: Bimow Chen <bimow.chen@ite.com.tw>
Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 Documentation/dvb/get_dvb_firmware        |   24 +++++++++++++-----------
 drivers/media/dvb-frontends/af9033.c      |   18 ++++++++++++++++++
 drivers/media/dvb-frontends/af9033_priv.h |   20 +++++++++-----------
 drivers/media/tuners/tuner_it913x.c       |    6 ------
 drivers/media/usb/dvb-usb-v2/af9035.c     |   11 +++++++++++
 5 files changed, 51 insertions(+), 28 deletions(-)

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
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index be4bec2..e96e655 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -274,6 +274,22 @@ static int af9033_init(struct dvb_frontend *fe)
 		{ 0x800045, state->cfg.adc_multiplier, 0xff },
 	};
 
+	/* power up tuner - for performance */
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		ret = af9033_wr_reg(state, 0x80ec40, 0x1);
+		ret |= af9033_wr_reg(state, 0x80fba8, 0x0);
+		ret |= af9033_wr_reg(state, 0x80ec57, 0x0);
+		ret |= af9033_wr_reg(state, 0x80ec58, 0x0);
+		if (ret < 0)
+			goto err;
+	}
+
 	/* program clock control */
 	clock_cw = af9033_div(state, state->cfg.clock, 1000000ul, 19ul);
 	buf[0] = (clock_cw >>  0) & 0xff;
@@ -440,6 +456,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
 		ret = af9033_wr_reg(state, 0x800000, 0x01);
+		ret |= af9033_wr_reg(state, 0x00d827, 0x00);
+		ret |= af9033_wr_reg(state, 0x00d829, 0x00);
 		if (ret < 0)
 			goto err;
 	}
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index fc2ad58..ded7b67 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -1418,7 +1418,7 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800068, 0x0a },
 	{ 0x80006a, 0x03 },
 	{ 0x800070, 0x0a },
-	{ 0x800071, 0x05 },
+	{ 0x800071, 0x0a },
 	{ 0x800072, 0x02 },
 	{ 0x800075, 0x8c },
 	{ 0x800076, 0x8c },
@@ -1484,7 +1484,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xbe },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xbe },
@@ -1510,7 +1509,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xac },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x1e },
 	{ 0x800153, 0xbc },
 	{ 0x800178, 0x09 },
@@ -1522,9 +1520,10 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xa0 },
 	{ 0x800190, 0x5a },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
@@ -1699,7 +1698,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xc8 },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xc6 },
@@ -1725,7 +1723,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xa8 },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x28 },
 	{ 0x800153, 0xcc },
 	{ 0x800178, 0x09 },
@@ -1737,9 +1734,10 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xfb },
 	{ 0x800190, 0x5c },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 6f30d7e..eb7e588 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -200,12 +200,6 @@ static int it913x_init(struct dvb_frontend *fe)
 		}
 	}
 
-	/* Power Up Tuner - common all versions */
-	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xfba8, 0x0);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
-
 	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 7b9b75f..3e212ae 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -602,6 +602,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	if (ret < 0)
 		goto err;
 
+	msleep(30);
+
 	/* firmware loaded, request boot */
 	req.cmd = CMD_FW_BOOT;
 	ret = af9035_ctrl_msg(d, &req);
@@ -621,6 +623,15 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		goto err;
 	}
 
+	/* tuner RF initial */
+	if (state->chip_type == 0x9135) {
+		ret = af9035_wr_reg(d, 0x80ec4c, 0x68);
+		if (ret < 0)
+			goto err;
+
+		msleep(30);
+	}
+
 	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
 			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
 
-- 
1.7.0.4


--=-GRNu5yI+gCeLeeIqiIp3--

