Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1FCC64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906BA20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AssjWBid"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906BA20837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbeLGN6r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:58:47 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35834 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGN61 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:58:27 -0500
Received: by mail-lf1-f67.google.com with SMTP id e26so3106767lfc.2;
        Fri, 07 Dec 2018 05:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffKmnpXVEGqvKdWMlz9/DjQRtkJ60DTmwDe4HXvNTn8=;
        b=AssjWBid8A0FDA7+upnV7LVl0B/Ruhk0p3DbY0fqmb6sg/Ghm+KhLQrXhvTLbvsTvX
         tC+vATAa/TtDru6iLkR9mturqu4S3U01bEXSJAR5bwXf36EawBB5fyGC1XptLe9wnegR
         2InkHcmtYdPpcLI1sLi+t7T3T4t+CeOF3mubExgZ9LKro+dMzcpUIRJRBI9HQejEVRmn
         e98npOE6iH5MTf443lNkW0vJJlXMv3tmXhHsN3NMNzQBk3+ZdmQsEEHkQONc6ZV1wjHj
         wVRCf5AsB2BGxZSxYYQWf7XjEgN/hMBu9oFZ/iO9maObiGS3tGzPAxmYW3OV+hxvRXxB
         zXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffKmnpXVEGqvKdWMlz9/DjQRtkJ60DTmwDe4HXvNTn8=;
        b=XDPZ1X5FU3/o49sEeGMLVL3Ysnvw0KE0aPFUtaqrOGo4oSmLTo1alHw8fU2h1s3aJo
         Jg0OXzzm6iCDAII41eh9U07klnz5g+L6uW4jG4tsIWU0hS73s0QNt7etApCc00MDd4YV
         yVG5qLuIUOLEvETXjUDVpPUiYVXgi03BMcQiOCHdW9D6lNhS/K8IGFlCCrEtwRUTKud5
         AcnzL/guNi2BBiG0a9tjvaHr3uRRRiLAy8ER9Ww3VEdZnnM/WrSWj2KIyaDMjvWXZArl
         fgG3yC8d+ojOz6sW6MRSg0DyqN0wfM1KI1WvjhfoigyHn1z+OjwwgTG9i51lQKlUwK9m
         5FMw==
X-Gm-Message-State: AA+aEWY/gDGxclMLhebXbLl2p+XO4XORrO186U58rAa7XP0wfOJbQyq2
        oyQcZQl9cIVBjeyr1CzJJT9emX/+T4HtTg==
X-Google-Smtp-Source: AFSGD/WBCpnDlLlFH/M/wj714MJsQalIv69jRwvLjeZohx4CCQNr03u4mazA9fROs1EkZRo7jAMSVQ==
X-Received: by 2002:a19:4e59:: with SMTP id c86mr1472016lfb.132.1544191105149;
        Fri, 07 Dec 2018 05:58:25 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.googlemail.com with ESMTPSA id i143sm624609lfg.74.2018.12.07.05.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 05:58:24 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH v2 2/4] si470x-i2c: Use managed resource helpers
Date:   Fri,  7 Dec 2018 14:58:10 +0100
Message-Id: <20181207135812.12842-3-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
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

