Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6323BC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E17820878
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUOxfkvs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E17820878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbeLEPs6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:48:58 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:47029 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbeLEPs6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:58 -0500
Received: by mail-lf1-f66.google.com with SMTP id f23so15061164lfc.13;
        Wed, 05 Dec 2018 07:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffKmnpXVEGqvKdWMlz9/DjQRtkJ60DTmwDe4HXvNTn8=;
        b=gUOxfkvsJ+4crGEsAQFnrfC7IktC3ABIKy49VQhgvwHrOd7VSECyn6OdaqtWRgRr4d
         eM+rPmHVC0dfw+15LmKFB9Iop00sA6qNMRVxssuaAC8uaeeKhLH/6IlcdQiBIEERFZbc
         Mu4FSDCJAmDfmaSRCQ2JcWygspwB3Xec9lXifUKYVpGzmXMViFebHirJXLGt6MRPSGME
         V+nD+4AiYU/oZSf09gFhes+rEyV0eDvnMCD+N1T5Hv2dhLKMjs4eurE35BRBseOomraC
         Qz8i4oBUovpwUF034RON3UZmt6ulx1QQNndNUmluicobmvkUWBAKP9aSbTslz19NdnHX
         XQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffKmnpXVEGqvKdWMlz9/DjQRtkJ60DTmwDe4HXvNTn8=;
        b=i5JHzborwAcnFWgOm307u6nb4bhunBIbFPaL2AsrBjnaXtSEJO1OeJcQFvdu/J5zuD
         bbmPNKWlfKvBSoJefxMNJQp5M+5xrDqu8uS+e0u2+BIrk2+xIHKp/fy+kRmoBEs6nEaP
         XrYNyNs6vL+JWgd3VzxfyhiDk9ZxKRO9NKR8DdnivLAxMKVWxeGRKjHpdTl+6h5LVIxW
         5CDkxK4LD4Hza6V207b53yIV5p0lP8ZpxNZCH29BG0iil5WM1K8l/si+FdnfVxh5xWsF
         Q4bU+7idZSTyji+waoyRc/mI1r/9vavgIbQgVE81cbjb/a8NFDafN5m54kDezpn0smIt
         eWMw==
X-Gm-Message-State: AA+aEWZNMZ7czgwptQYuRAvlUV0TYj0O/+tW/22vvI6+bwquMxy/sdiF
        AjX1rEl1kc5l8xrQkVK/P0k=
X-Google-Smtp-Source: AFSGD/X9ahbaCI44cNt+tH4z7geyMHMjwAPJqn0+6m2/nEGjKZnyogZeVaPtPg54MnEgQzhk5X+GMg==
X-Received: by 2002:a19:f813:: with SMTP id a19mr14088331lff.67.1544024934173;
        Wed, 05 Dec 2018 07:48:54 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:53 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 3/5] si470x-i2c: Use managed resource helpers
Date:   Wed,  5 Dec 2018 16:47:48 +0100
Message-Id: <20181205154750.17996-4-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Simplify cleanup of failures by using managed resource helpers

Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 29 +++++++------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 250828ddb5fa..a7ac09c55188 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -350,7 +350,7 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	unsigned char version_warning = 0;
 
 	/* private data allocation and initialization */
-	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
+	radio = devm_kzalloc(&client->dev, sizeof(*radio), GFP_KERNEL);
 	if (!radio) {
 		retval = -ENOMEM;
 		goto err_initial;
@@ -370,7 +370,7 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	retval = v4l2_device_register(&client->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&client->dev, "couldn't register v4l2_device\n");
-		goto err_radio;
+		goto err_initial;
 	}
 
 	v4l2_ctrl_handler_init(&radio->hdl, 2);
@@ -396,14 +396,14 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	radio->registers[POWERCFG] = POWERCFG_ENABLE;
 	if (si470x_set_register(radio, POWERCFG) < 0) {
 		retval = -EIO;
-		goto err_ctrl;
+		goto err_all;
 	}
 	msleep(110);
 
 	/* get device and chip versions */
 	if (si470x_get_all_registers(radio) < 0) {
 		retval = -EIO;
-		goto err_ctrl;
+		goto err_all;
 	}
 	dev_info(&client->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
@@ -430,10 +430,10 @@ static int si470x_i2c_probe(struct i2c_client *client,
 
 	/* rds buffer allocation */
 	radio->buf_size = rds_buf * 3;
-	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
+	radio->buffer = devm_kmalloc(&client->dev, radio->buf_size, GFP_KERNEL);
 	if (!radio->buffer) {
 		retval = -EIO;
-		goto err_ctrl;
+		goto err_all;
 	}
 
 	/* rds buffer configuration */
@@ -441,12 +441,13 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);
 
-	retval = request_threaded_irq(client->irq, NULL, si470x_i2c_interrupt,
-			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, DRIVER_NAME,
-			radio);
+	retval = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+					   si470x_i2c_interrupt,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   DRIVER_NAME, radio);
 	if (retval) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
-		goto err_rds;
+		goto err_all;
 	}
 
 	/* register video device */
@@ -460,15 +461,9 @@ static int si470x_i2c_probe(struct i2c_client *client,
 
 	return 0;
 err_all:
-	free_irq(client->irq, radio);
-err_rds:
-	kfree(radio->buffer);
-err_ctrl:
 	v4l2_ctrl_handler_free(&radio->hdl);
 err_dev:
 	v4l2_device_unregister(&radio->v4l2_dev);
-err_radio:
-	kfree(radio);
 err_initial:
 	return retval;
 }
@@ -481,9 +476,7 @@ static int si470x_i2c_remove(struct i2c_client *client)
 {
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
-	free_irq(client->irq, radio);
 	video_unregister_device(&radio->videodev);
-	kfree(radio);
 
 	return 0;
 }
-- 
2.17.1

