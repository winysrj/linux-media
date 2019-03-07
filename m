Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9717C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D9F20840
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCGXMA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:12:00 -0500
Received: from relayout02-q02.e.movistar.es ([86.109.101.152]:43025 "EHLO
        relayout02-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbfCGXMA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 18:12:00 -0500
Received: from relayout02-redir.e.movistar.es (relayout02-redir.e.movistar.es [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 44Fmby1fHnzhYXs;
        Fri,  8 Mar 2019 00:11:58 +0100 (CET)
Received: from [192.168.0.167] (unknown [47.62.122.75])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout02.e.movistar.es (Postfix) with ESMTPA id 44Fmbx1h0szdZqS;
        Fri,  8 Mar 2019 00:11:57 +0100 (CET)
Date:   Fri, 08 Mar 2019 00:11:58 +0100
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH V4 1/2] init i2c already in it930x_frontend_attach
To:     Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        Andreas Kemnade <andreas@kemnade.info>,
        jose.alberto.reguero@gmail.com
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <3280B2FE-5401-479F-BD3B-F4F48DA4E464@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 47.62.122.75 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout02
X-TnetOut-MsgID: 44Fmbx1h0szdZqS.AA002
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1552605118.10246@Bpg7hcDNyXLJXQiFg6yYTg
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

i2c bus is already needed when the frontend is probed, so init it already in it930x_frontend_attach.That prevents errors like
si2168: probe of 6-0067 failed with error -5


From: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>

diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2018-09-12 07:40:12.000000000 +0200
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-20 16:45:17.467869437 +0100
@@ -1218,6 +1218,48 @@ static int it930x_frontend_attach(struct
 
 	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
+	/* I2C master bus 2 clock speed 300k */
+	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
+	if (ret < 0)
+		goto err;
+
+	/* I2C master bus 1,3 clock speed 300k */
+	ret = af9035_wr_reg(d, 0x00f103, 0x07);
+	if (ret < 0)
+		goto err;
+
+	/* set gpio11 low */
+	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
+	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
+	if (ret < 0)
+		goto err;
+
+	msleep(200);
+
+	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
+	if (ret < 0)
+		goto err;
+
 	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe[0];
@@ -1575,48 +1617,6 @@ static int it930x_tuner_attach(struct dv
 
 	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
-	/* I2C master bus 2 clock speed 300k */
-	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
-	if (ret < 0)
-		goto err;
-
-	/* I2C master bus 1,3 clock speed 300k */
-	ret = af9035_wr_reg(d, 0x00f103, 0x07);
-	if (ret < 0)
-		goto err;
-
-	/* set gpio11 low */
-	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
-	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
-	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
-	if (ret < 0)
-		goto err;
-
-	msleep(200);
-
-	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
-	if (ret < 0)
-		goto err;
-
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
 	si2157_config.if_port = 1;

-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
