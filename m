Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3CEC43444
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF6121A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgcXrKMt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbeLVRNY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:24 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42909 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388743AbeLVRNY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:24 -0500
Received: by mail-pg1-f196.google.com with SMTP id d72so3899719pga.9;
        Sat, 22 Dec 2018 09:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iztLCeSm0ee+oLD+LTtVDeW3poO526flL4FbQi6FTH4=;
        b=fgcXrKMtI9ysqtVagvWOJhDhLyzvadKLvIeg+dPWzhV6BHWskkQup+DSJyfLq1JeYq
         eRKG9d+lYTfywCNtVIUnQUMgWg/M2dzS6Zdt9mJXzXwTJERP2/CgxAP0Lj78H7jiBJDs
         CM1IDIv0M4rPzauJ0/L+F4XiohrlrOGpZE9CwSWuujmPM27H/5rvSDVKoIjMAHtyYQJs
         rfVTZ5P+Vt/Hv0Uqcwj8a/fN3PiUGp1SV7bscgprlmXHW6OigMh/WoBfgMsDJ32xojVX
         8IVEe7dZitcIr1BLteWvy52XQr81g/QWNUJPX6ZWad/aaPW8IrIxq21KZaOdJ8b0df/K
         4nHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iztLCeSm0ee+oLD+LTtVDeW3poO526flL4FbQi6FTH4=;
        b=giD8hfHsKoIHEIEq5THmSn4XOuI0s4dqhIAOTkCCFs+29Z/xFln/8MUzyeLa7QpCj3
         +r8H7xnEQE28sdKfMjeBzVQF2OSGcXgm+jk8W5QNYcAL6GHLX1tQ1+nngwAF7JFaX1tP
         buDRoZsjHUOH7WXxruERgRWUR+BP12oKyaGVIJaG6mpV21lm/2zyfxZ1JKvEY54oYzeV
         3+wNoqt91MoyGwczB2iVqVHSh795LOiheG1Oj1yIDDvAVlo/+EhfaFg4DNJg4EAI/SOX
         Dk8g8pxJ2Hw090gjKGPEg6hndAZIAJCEJAwpQv9XFJdLrsUdaeELG0sOZHDF2Pcxi0en
         nA2Q==
X-Gm-Message-State: AJcUukeOhJiRDAzdEEFOVO9SbOhlRpl0Jdjrx+k9LHkl6X+bfRgt3kqB
        AypqLWK1JPKd7Nw2ODMD35Mmx8L4eSU=
X-Google-Smtp-Source: ALg8bN7rMIMDD9zuhzERFxecX/DILSgirelwBEU8Nj7TbZpIYX6XZMmjBwWD13xa9xHdEh5buHy0iQ==
X-Received: by 2002:a63:a84a:: with SMTP id i10mr6843277pgp.263.1545498803694;
        Sat, 22 Dec 2018 09:13:23 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:23 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 08/12] media: mt9m001: add media controller support
Date:   Sun, 23 Dec 2018 02:12:50 +0900
Message-Id: <1545498774-11754-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Create a source pad and set the media controller type to the sensor.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig   | 2 ++
 drivers/media/i2c/mt9m001.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4bdf043..5e30ad3 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -846,6 +846,8 @@ config VIDEO_VS6624
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CONTROLLER
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index eb5c4ed..e31fb7d 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -103,6 +103,7 @@ struct mt9m001 {
 	int num_fmts;
 	unsigned int total_h;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
+	struct media_pad pad;
 };
 
 static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
@@ -758,6 +759,12 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (ret)
 		goto error_power_off;
 
+	mt9m001->pad.flags = MEDIA_PAD_FL_SOURCE;
+	mt9m001->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&mt9m001->subdev.entity, 1, &mt9m001->pad);
+	if (ret)
+		goto error_power_off;
+
 	pm_runtime_put_sync(&client->dev);
 
 	return 0;
@@ -781,6 +788,8 @@ static int mt9m001_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
 
+	media_entity_cleanup(&mt9m001->subdev.entity);
+
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-- 
2.7.4

