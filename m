Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A47C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E41BB2064A
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCESha convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:37:30 -0500
Received: from relayout03-q02.e.movistar.es ([86.109.101.162]:40297 "EHLO
        relayout03-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbfCESha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 13:37:30 -0500
Received: from relayout03-redir.e.movistar.es (unknown [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 44DQc918SVzQkBJ;
        Tue,  5 Mar 2019 19:37:29 +0100 (CET)
Received: from [192.168.0.167] (unknown [47.62.122.75])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPA id 44DQc83sRszMlCN;
        Tue,  5 Mar 2019 19:37:28 +0100 (CET)
Date:   Tue, 05 Mar 2019 19:37:35 +0100
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH V3 2/2] Add support for the Avermedia TD310
To:     Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        Andreas Kemnade <andreas@kemnade.info>,
        jose.alberto.reguero@gmail.com
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <A23F77AB-9546-4D74-8B1D-7360221CA6CF@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 47.62.122.75 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout03
X-TnetOut-MsgID: 44DQc83sRszMlCN.A63A4
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1552415848.98807@HXPxezBOeCKxfCvNNl7GsA
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch add support for Avermedia TD310 usb stick. 

V3 add a table for the i2c addresses an other needed options.


Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com> 

diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2019-03-05 18:44:34.936077251 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-03-05 18:43:31.512806221 +0100
@@ -846,6 +846,7 @@ static int af9035_read_config(struct dvb
 	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
 	state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
+	state->it930x_addresses = 0;
 
 	if (state->chip_type == 0x9135) {
 		/* feed clock for integrated RF tuner */
@@ -872,6 +873,10 @@ static int af9035_read_config(struct dvb
 		 * IT930x is an USB bridge, only single demod-single tuner
 		 * configurations seen so far.
 		 */
+		if ((le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) &&
+		    (le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_TD310)) {
+			state->it930x_addresses = 1;
+		}
 		return 0;
 	}
 
@@ -1267,8 +1272,9 @@ static int it930x_frontend_attach(struct
 
 	state->af9033_config[adap->id].fe = &adap->fe[0];
 	state->af9033_config[adap->id].ops = &state->ops;
-	ret = af9035_add_i2c_dev(d, "si2168", 0x67, &si2168_config,
-				&d->i2c_adap);
+	ret = af9035_add_i2c_dev(d, "si2168",
+				 it930x_addresses_table[state->it930x_addresses].frontend_i2c_addr,
+				 &si2168_config, &d->i2c_adap);
 	if (ret)
 		goto err;
 
@@ -1619,10 +1625,10 @@ static int it930x_tuner_attach(struct dv
 
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
-	si2157_config.if_port = 1;
-	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
-			&si2157_config, state->i2c_adapter_demod);
-
+	si2157_config.if_port = it930x_addresses_table[state->it930x_addresses].tuner_if_port;
+	ret = af9035_add_i2c_dev(d, "si2157",
+				 it930x_addresses_table[state->it930x_addresses].tuner_i2c_addr,
+				 &si2157_config, state->i2c_adapter_demod);
 	if (ret)
 		goto err;
 
@@ -2128,6 +2134,8 @@ static const struct usb_device_id af9035
 	/* IT930x devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
 		&it930x_props, "ITE 9303 Generic", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD310,
+		&it930x_props, "AVerMedia TD310 DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
--- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2017-02-01 06:41:13.000000000 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2019-03-05 18:19:31.450331996 +0100
@@ -69,6 +69,7 @@ struct state {
 	u8 dual_mode:1;
 	u8 no_read:1;
 	u8 af9033_i2c_addr[2];
+	u8 it930x_addresses;
 	struct af9033_config af9033_config[2];
 	struct af9033_ops ops;
 	#define AF9035_I2C_CLIENT_MAX 4
@@ -77,6 +78,17 @@ struct state {
 	struct platform_device *platform_device_tuner[2];
 };
 
+struct address_table {
+	u8 frontend_i2c_addr;
+	u8 tuner_i2c_addr;
+	u8 tuner_if_port;
+};
+
+static const struct address_table it930x_addresses_table[] = {
+	{ 0x67, 0x63, 1 },
+	{ 0x64, 0x60, 0 },
+};
+
 static const u32 clock_lut_af9035[] = {
 	20480000, /*      FPGA */
 	16384000, /* 16.38 MHz */

-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
