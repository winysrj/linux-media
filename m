Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ED0C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7D49206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ruC9fZrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfAHOwj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:39 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44267 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:39 -0500
Received: by mail-pg1-f193.google.com with SMTP id t13so1823152pgr.11;
        Tue, 08 Jan 2019 06:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H8K7tcMKsKg0bjCBuWoXsmz7HuFTuwLp5XgOVd7wnMY=;
        b=ruC9fZrtaNDL4+Qx96+oToEIBalSIPf+DaXtgcrcNjJ3gD3D4AD9g6FAhSK0wkoMkI
         Y4Mzo6d0pdq3I26B/iRi5fE/lWM4BWf5HTss3KqDyXjULptvlgEZV8TGGvLTHsKkFMQB
         NHl9K3nphVSzsrWDrocPVbY/BCOJrAruNX5ZnTCSYL4eRYxrhtwjgfhTqjFDV/MuZaG7
         2w4C1wGWmplRBnTNDEGkEq6YIPXSkNdOyQkTGPlQSiWjx69rafNmhv9NoJYKHrYyF4BC
         VHWPy+Oe1XiFSlAssNhRIpq3OuowlD2zq6v3UBIVxuza3Bcnoja3B5oMFRrDBEKpGQ3J
         RviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H8K7tcMKsKg0bjCBuWoXsmz7HuFTuwLp5XgOVd7wnMY=;
        b=uEBISneyZ4Ozk2a0PjwMlly3jO0OzBHqdijQxGHuIn5h7XJhBh9RAfddlxpK3qDCb5
         cQs66CcXHmOF/BnthT5S2UQHXYJaYRQxFIiN6I902erny0OFsGRnTo44IWsECsJ72aLJ
         INI6op6JHdnkvYmXAh/fHqSmbeL1L6HsOITsjO3mDB2ilaweMZ4s0RslgfhrAJqDORAm
         t8bTfaOOChQaBvwnqs7qNgncYgmiblBsh89Azkl2Q5Ed0PSMRsGRwlGdomlgldSKvN3S
         9F7YtNsHAWXlOslmcDT8XjUQOL+QVu5ixk1O8hOQrn3GYBWqa2SsLpEok1NwamQhGI/3
         9a8Q==
X-Gm-Message-State: AJcUuke9gYCQhSL9wI4bOb0n0tTfyZouAO/9kJ6Ml0iblqvNhrTcgomD
        jZ1gE061qqzOl/aGocZTNf+baiRd
X-Google-Smtp-Source: ALg8bN7SogbnOkhJtHO9SKnipamWptjkH7fIxPYJNXSpfK7AKVsWXO463iO3f2+bDtBx41M9s9HCxg==
X-Received: by 2002:a65:590b:: with SMTP id f11mr1826246pgu.60.1546959158592;
        Tue, 08 Jan 2019 06:52:38 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:38 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 10/13] media: mt9m001: register to V4L2 asynchronous subdevice framework
Date:   Tue,  8 Jan 2019 23:51:47 +0900
Message-Id: <1546959110-19445-11-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Register a sub-device to the asynchronous subdevice framework, and also
create subdevice device node.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Remove redundant Kconfig dependency
- Preserve subdev flags set by v4l2_i2c_subdev_init().

 drivers/media/i2c/Kconfig   | 3 +--
 drivers/media/i2c/mt9m001.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2d13898..be8166d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -859,9 +859,8 @@ config VIDEO_VS6624
 
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on MEDIA_CONTROLLER
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 3b55aa85..5e93c7d 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -720,6 +720,7 @@ static int mt9m001_probe(struct i2c_client *client,
 		return PTR_ERR(mt9m001->reset_gpio);
 
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
+	mt9m001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
 	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
@@ -768,10 +769,16 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (ret)
 		goto error_power_off;
 
+	ret = v4l2_async_register_subdev(&mt9m001->subdev);
+	if (ret)
+		goto error_entity_cleanup;
+
 	pm_runtime_idle(&client->dev);
 
 	return 0;
 
+error_entity_cleanup:
+	media_entity_cleanup(&mt9m001->subdev.entity);
 error_power_off:
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
@@ -788,9 +795,9 @@ static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
-	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
 
+	v4l2_async_unregister_subdev(&mt9m001->subdev);
 	media_entity_cleanup(&mt9m001->subdev.entity);
 
 	pm_runtime_disable(&client->dev);
-- 
2.7.4

