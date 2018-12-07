Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C40C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE1F20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrwUqJi3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAE1F20837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbeLGN6a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:58:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35837 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbeLGN63 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:58:29 -0500
Received: by mail-lf1-f67.google.com with SMTP id e26so3106854lfc.2;
        Fri, 07 Dec 2018 05:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MgD/GG9O1K1FRD9ALik5jgeXm7lZuOo80znVVMI+qnU=;
        b=GrwUqJi3NDdUmAbb89sJnr1kVZkvvXo1Lfz6rmvI/jcKwpVzw9bfklMLirJMe+8XO0
         IOVOEx0m2nnfoaJCW+G3thgIZd6UQBPqT7hoigC7I3VASeHsSm0A2sUq8mjgG5S1vw1j
         jUtHK8CAq5sX9oRXNfT7UVuvbv1lQv/cIUiYCjy0CrowiF0e162eTD9PU2EaTrreJSfE
         YWs7WaK+XYleFBBwNvgll+6GWOzr1M4ZwYGx7W0WWZAe1DCuAIzDz0E7kahWJt7Xow1t
         lAge2scVn8F7c71eeJHpqCVYBRMYQ5dVP1A3fVlrh2GRW97nhpQtLRWrjCWODmuE9kf3
         xVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MgD/GG9O1K1FRD9ALik5jgeXm7lZuOo80znVVMI+qnU=;
        b=GuU5JwnottjJzgUDazCETYLdsjf+XXme1re7Bx1X9e8GpKRp220jWkklc70QpVv3Yi
         otqpcx81t3UJ1W5pxswo3ex58k0J89/M3mzR4GT7tHsxMRJE3C1WHwYaORiRMeWU7vlA
         wLz2AEloT/ozt/9sR+8dYSEtHimB3e7YvYLA2Qk5QjpaAO8IHoYN8QGlP5qfd6L3HBPb
         GKoOS5MzC4syWfgzocCa1fgXsJ6QDMirC4rQMmWIK/YDxZ/dEIf2yqkVBffepGgqMS4n
         E29NJck2mrDVt6ebD6+PGYrQfGeBEXqgECrQ/hR7W4kGaiM4bOsKvK82qWUAtf9ATXFw
         9pzg==
X-Gm-Message-State: AA+aEWYBxETu3HcWa/goK1itNm86b92x6OLlSF/9JIFGI/AVAaMJs/xI
        lejUj9xfHiC1a8CxUGD2CdY=
X-Google-Smtp-Source: AFSGD/V5hu/QTqO0GEpy55BYULjHQ+UZygv1OIqKgLqzm7jlNC6BrKwACMUb0m76CE8ow++0bTELiw==
X-Received: by 2002:a19:24c6:: with SMTP id k189mr1468130lfk.77.1544191106776;
        Fri, 07 Dec 2018 05:58:26 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.googlemail.com with ESMTPSA id i143sm624609lfg.74.2018.12.07.05.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 05:58:26 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH v2 3/4] si470x-i2c: Add optional reset-gpio support
Date:   Fri,  7 Dec 2018 14:58:11 +0100
Message-Id: <20181207135812.12842-4-pawel.mikolaj.chmiel@gmail.com>
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

If reset-gpio is defined, use it to bring device out of reset.
Without this, it's not possible to access si470x registers.

Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 15 +++++++++++++++
 drivers/media/radio/si470x/radio-si470x.h     |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index a7ac09c55188..15eea2b2c90f 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 
 #include "radio-si470x.h"
@@ -392,6 +393,17 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	radio->videodev.release = video_device_release_empty;
 	video_set_drvdata(&radio->videodev, radio);
 
+	radio->gpio_reset = devm_gpiod_get_optional(&client->dev, "reset",
+						    GPIOD_OUT_LOW);
+	if (IS_ERR(radio->gpio_reset)) {
+		retval = PTR_ERR(radio->gpio_reset);
+		dev_err(&client->dev, "Failed to request gpio: %d\n", retval);
+		goto err_all;
+	}
+
+	if (radio->gpio_reset)
+		gpiod_set_value(radio->gpio_reset, 1);
+
 	/* power up : need 110ms */
 	radio->registers[POWERCFG] = POWERCFG_ENABLE;
 	if (si470x_set_register(radio, POWERCFG) < 0) {
@@ -478,6 +490,9 @@ static int si470x_i2c_remove(struct i2c_client *client)
 
 	video_unregister_device(&radio->videodev);
 
+	if (radio->gpio_reset)
+		gpiod_set_value(radio->gpio_reset, 0);
+
 	return 0;
 }
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 35fa0f3bbdd2..6fd6a399cb77 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -189,6 +189,7 @@ struct si470x_device {
 
 #if IS_ENABLED(CONFIG_I2C_SI470X)
 	struct i2c_client *client;
+	struct gpio_desc *gpio_reset;
 #endif
 };
 
-- 
2.17.1

