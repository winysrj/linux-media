Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5567CC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1954E206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQDV+lJI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1954E206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbeLEPs7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:48:59 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36561 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbeLEPs6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:58 -0500
Received: by mail-lf1-f68.google.com with SMTP id a16so15092205lfg.3;
        Wed, 05 Dec 2018 07:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MgD/GG9O1K1FRD9ALik5jgeXm7lZuOo80znVVMI+qnU=;
        b=aQDV+lJIgY/8SNhwMCQemfFnuO+lF29H+g23P9xVbo9uzCUi9cuEB1bEh29VYxuiul
         oich56jnVKd1fO02DmNFFlR+qQOLgXc3jzNAyqQqpibCd/gdsl8o4yYIv/yWo6hLJvTY
         OUbnkw9tVbSUramjMVmqvrxYEEMA9gOHHIMK3CzZv1ciUuSRMLZzINdVnJRbXETC+rze
         UfA5s68SUm+6q2uhanIPVPBXUU1w9P1WN6JpzmT4Gt1/AsZ3KLTwXXipmLytOwKR7HUi
         wYMlv8QLEDwpjkdI1eqLq1zCXM9NIijIJ7CWI/pT3ORjZ8yjRtCTlnjhqg63Lh48S/0x
         TLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MgD/GG9O1K1FRD9ALik5jgeXm7lZuOo80znVVMI+qnU=;
        b=fK2vnJHCs94Hl9raRO9tBgIahA2REsQXq4faeW7WS4QRHYrxDbY8qmtdYMfxkmwZ+J
         3Bc1snQhI3nWKEvwqx7GBD0b79WfnvCNDVC7C04US41udpSaFFAkEUk8uFtogWvHatG2
         JLcCjb1RLCmKZzisU695KWgL+rwoGP+FgaBGPi6Fp+72jDEuNlHG4rSp4zqyUrl/9fVm
         42IXe5cA+1Y7gmGQeLpxNECBThR28mZ2uwbSpoCZygXXqqaRvsENE1Nnehdi/zLnoSzK
         H6jyT5X2qMb3NiNAIXgv82/sCZDsxjWayij3qM/A7iZfcsXUu0H2lZhoormR8la1htIq
         eU4A==
X-Gm-Message-State: AA+aEWbWkzfS19zIweJ03cwWaoRog/hXBnyY/oF2jfMHfTi0hC9ILNbH
        3egNcZqZPVWWt/cSzX6XNsk=
X-Google-Smtp-Source: AFSGD/Uh6TLHWpmb2xcn2W/t8RF7ODaw/hpyW0cU4FpVubTrSAhmDkI4GQs9pGtivfPWijdNile4Nw==
X-Received: by 2002:a19:41c4:: with SMTP id o187mr15409826lfa.32.1544024935664;
        Wed, 05 Dec 2018 07:48:55 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:55 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 4/5] si470x-i2c: Add optional reset-gpio support
Date:   Wed,  5 Dec 2018 16:47:49 +0100
Message-Id: <20181205154750.17996-5-pawel.mikolaj.chmiel@gmail.com>
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

