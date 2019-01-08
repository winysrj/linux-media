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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80463C43612
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E003206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sGdBilz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfAHOwh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37037 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id y126so2049120pfb.4;
        Tue, 08 Jan 2019 06:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VDVo3mgCLYbxIdXX1opZLNh+A7ToRAEkhx9YgnB+Y7M=;
        b=sGdBilz2CqWz3Y3bMddGbRZrodQS2QqKxW4jfvRcjLmLNWTaBkJE6BnEDD8tfXs6Jx
         1PUpEhoik8uJ372YwdNSqMC+KfZU9uqiHK5kMF4DpMC5fRWPjqADFXl2NxOm+d8G7dc0
         8KXatTEFFcLYIV7jmBszKKO9DCQlgqroEwOAq+snBOheFRSk+698c1K6BErPZ3v8JfX5
         mbSVycXbgFRvoKEGPwBbyd3K4fNpSbjd8OOvuPIOpbShYdZ/bryTtkcZDmflR1OrOlIO
         ADD1VfxZRmRg9Ooy4q+kttCIlhmB5BBtUO6rkcdixFNF4SFPJsZ8zRfLq2JkY2kcpcW+
         Wjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VDVo3mgCLYbxIdXX1opZLNh+A7ToRAEkhx9YgnB+Y7M=;
        b=l1QDEMvwN0R+NQDTuS1255P73X6ESRZRjOHaJDFA7Vlp9KVENs9uGZwHt1kBF1RwXN
         U5/cRfTjJdRHGIZmXKl8Kcm/hnhCo8D4j/aQpRWBjbCDyM9y5C/nV7ink8mmb6we9w2y
         KA7JeJOWdeZc7hB7jMzjx2OAAi5nGUcJEs/NoyD6FkfKmR1ibwu/vOvF1060mqaFyky4
         e5/kGZ4K/3OURbnXtnavB55qRYanDYs+uCjkdXXJ/QXnTTFuOCsbUmMKYDympzBjZsC5
         evo9szgan8um3n+fpDw1FWepEcChZMUFIYZAA0553U8VyKygAMFrbgiswWUxFG8P+Piu
         lQyg==
X-Gm-Message-State: AJcUukfB6f+mLyTncFG8Rc/Byfuw/9nXspXkHyBxB445JXoHo5Ims6aH
        RkgNRlLjR88h1nPYqVkrq+5+2Zeo
X-Google-Smtp-Source: ALg8bN5HBGBLtk+XkTzYaIXE4bOaN1pByrSNiYElEpUhbyl/m4ZSzMTUIDSxfwtHiV3J5O+GQet/5Q==
X-Received: by 2002:a63:5b48:: with SMTP id l8mr1814733pgm.80.1546959156070;
        Tue, 08 Jan 2019 06:52:36 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:35 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 09/13] media: mt9m001: add media controller support
Date:   Tue,  8 Jan 2019 23:51:46 +0900
Message-Id: <1546959110-19445-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Create a source pad and set the media controller type to the sensor.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/Kconfig   | 2 ++
 drivers/media/i2c/mt9m001.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index bc248d9..2d13898 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -860,6 +860,8 @@ config VIDEO_VS6624
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
 	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CONTROLLER
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 0f5e3f9..3b55aa85 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -103,6 +103,7 @@ struct mt9m001 {
 	int num_fmts;
 	unsigned int total_h;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
+	struct media_pad pad;
 };
 
 static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
@@ -761,6 +762,12 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (ret)
 		goto error_power_off;
 
+	mt9m001->pad.flags = MEDIA_PAD_FL_SOURCE;
+	mt9m001->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&mt9m001->subdev.entity, 1, &mt9m001->pad);
+	if (ret)
+		goto error_power_off;
+
 	pm_runtime_idle(&client->dev);
 
 	return 0;
@@ -784,6 +791,8 @@ static int mt9m001_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
 
+	media_entity_cleanup(&mt9m001->subdev.entity);
+
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-- 
2.7.4

