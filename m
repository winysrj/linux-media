Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C455C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 22:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB54B218A3
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 22:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICz7wzW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfBKWNV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 17:13:21 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:55478 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfBKWNV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 17:13:21 -0500
Received: by mail-wm1-f50.google.com with SMTP id r17so847923wmh.5
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 14:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:message-id:subject:mime-version
         :content-transfer-encoding:user-agent;
        bh=RaPZSRzRcgxn3aG3kv2hE4s/6LLwSbuE0gKdDyEneik=;
        b=ICz7wzW83ekg1cNkJcumRf909z9oQ5H0gJhiCtRWBXwZDMYlVjLa4Q03M0Qo/7kUU9
         bqdXo+5AjPKf6UbaRRcu8eakRk61dif+fNSynGMcekWk2wo5igF5EZICxrjNnd/SavQG
         0NlU3suxKGPEwlbNQf1vLfwgrU7Vapx0qiWiwhad4tMp+o+Jk98HuuWfuaXBLKHRYuoh
         RALp2btpx8zoA5azhsRqKfdLVO//x+B2sbFdTZbJXMdLQ00Tl6rhb11lM10Ulc0BHoVS
         OK4D+DwOGjXYjYkV1ykWAryixiDJhEPI6b83wJBHGaWK1XDqRZ7wES9nN/gR+6lNL2qd
         7ZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:message-id:subject:mime-version
         :content-transfer-encoding:user-agent;
        bh=RaPZSRzRcgxn3aG3kv2hE4s/6LLwSbuE0gKdDyEneik=;
        b=YGr+P8iML+zx46VnWT9bW8E7SHT5b0sSFOA6f32KFAMssEqNcVmEvqgBzeI/DXNiQ2
         2OoSvSByyMnpqiUchQ6p8ev8+5vIXiqLxQdgIAtXM0byTqUaCuGQMuM2AjXjdxgqg55G
         NFSle0hUd1Zw79OFV+WAgj0wSsYMOOZ8jlZi+aYpNJ7ZqRNd5F/wMT13KIovd8Nqv8Kb
         B0vl9aN5T/lXTyaTY5L8MK3F5UwH3q70GFb6O2478ui2BIT9Huiox9qof4jjL5nzoi+d
         ceE+BJG+pR8zsjx3rBjoQqfoAf61pGE8/t5vgFJiz39x5xQNc9eyQ00KrsNWEtZl4TIz
         5QSw==
X-Gm-Message-State: AHQUAuaie6Mds0Jco83/Peqfc6hxTXtBUA3LQYqSZFRHU2nHulPY+dxG
        aYePYH4ulRwuK69LTeGIDh3hCBiT
X-Google-Smtp-Source: AHgI3IbxNhphsWoSdGSLCk2exe+5rzbF66vJmaORJcwX7thHb2jsQzj6vMB1ts/9uTmIhRo8PeTPwg==
X-Received: by 2002:a1c:790c:: with SMTP id l12mr293636wme.11.1549923198985;
        Mon, 11 Feb 2019 14:13:18 -0800 (PST)
Received: from [192.168.0.161] (static-146-187-224-77.ipcom.comunitel.net. [77.224.187.146])
        by smtp.gmail.com with ESMTPSA id c129sm361073wma.48.2019.02.11.14.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 14:13:18 -0800 (PST)
From:   Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
X-Google-Original-From: Jose Alberto Reguero <jareguero@telefonica.net>
Date:   Mon, 11 Feb 2019 23:13:25 +0100
To:     linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Message-ID: <cba5b0fd-d626-4736-a017-5a1edf35283e.maildroid@localhost>
Subject: [PATCH] Add suport for Avermedia TD310
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: MailDroid/4.91 (Android 5.1.1)
User-Agent: MailDroid/4.91 (Android 5.1.1)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch add support for Avermedia TD310 usb stik.
This patch must be aplied after this one:
https://patchwork.linuxtv.org/patch/40087/

Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>

diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-11 14:48:58.133751038 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-11 15:02:10.646718610 +0100
@@ -1215,6 +1215,7 @@ static int it930x_frontend_attach(struct
 	int ret;
 	struct si2168_config si2168_config;
 	struct i2c_adapter *adapter;
+	u8 i2c_addr;
 
 	dev_dbg(&intf->dev, "%s  adap->id=%d\n", __func__, adap->id);
 
@@ -1266,7 +1267,11 @@ static int it930x_frontend_attach(struct
 
 	state->af9033_config[adap->id].fe = &adap->fe[0];
 	state->af9033_config[adap->id].ops = &state->ops;
-	ret = af9035_add_i2c_dev(d, "si2168", 0x67, &si2168_config,
+	i2c_addr = 0x67;
+	if ((le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) &&
+			(le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_TD310))
+		i2c_addr = 0x64;
+	ret = af9035_add_i2c_dev(d, "si2168", i2c_addr, &si2168_config,
 				&d->i2c_adap);
 	if (ret)
 		goto err;
@@ -1613,6 +1618,7 @@ static int it930x_tuner_attach(struct dv
 	struct usb_interface *intf = d->intf;
 	int ret;
 	struct si2157_config si2157_config;
+	u8 i2c_addr;
 
 	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
@@ -1661,7 +1667,13 @@ static int it930x_tuner_attach(struct dv
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
 	si2157_config.if_port = 1;
-	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
+	i2c_addr = 0x63;
+	if ((le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) &&
+			(le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_TD310)) {
+		i2c_addr = 0x60;
+		si2157_config.if_port = 0;
+	}
+	ret = af9035_add_i2c_dev(d, "si2157", i2c_addr,
 			&si2157_config, state->i2c_adapter_demod);
 
 	if (ret)
@@ -2169,6 +2181,8 @@ static const struct usb_device_id af9035
 	/* IT930x devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
 		&it930x_props, "ITE 9303 Generic", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD310,
+		&it930x_props, "AVerMedia TD310 DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
diff -upr linux/include/media/dvb-usb-ids.h linux.new/include/media/dvb-usb-ids.h
--- linux/include/media/dvb-usb-ids.h	2018-05-05 07:40:18.000000000 +0200
+++ linux.new/include/media/dvb-usb-ids.h	2019-02-08 22:00:24.765541474 +0100
@@ -258,6 +258,7 @@
 #define USB_PID_AVERMEDIA_A867				0xa867
 #define USB_PID_AVERMEDIA_H335				0x0335
 #define USB_PID_AVERMEDIA_TD110				0xa110
+#define USB_PID_AVERMEDIA_TD310				0x1871
 #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009



Sent from MailDroid
