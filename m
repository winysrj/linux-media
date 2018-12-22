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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35BEC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B298921A48
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tfjIp9bY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391082AbeLVRNb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37616 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeLVRNa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:30 -0500
Received: by mail-pf1-f196.google.com with SMTP id y126so4052358pfb.4;
        Sat, 22 Dec 2018 09:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gc3m1uDP8Wo5z1wzLJY3/rncC3r7LBdywkd5BimQRx0=;
        b=tfjIp9bYdq3HZVhVXgGea51u7Q59g3bdzS22k84U3I/O3TU1QeO9qJWXWbzp1xZITP
         FI361bf6ejyHf4hb4lrMfVZks6kFgbMCKUkfL2pBXcrdNe57hHiF71wj21u640kwASrH
         f5wCLu/LohGryS5pV5Wv9oFiduxc4sC/6g5LeXlrLo9/XrlpkJcc3IXhxs4SgFe+B5jF
         bCaEOwekLD8Wgri6XGpJ9jCzzAkZyh+ZL7sNVIl5B81S9Ysg5okCcFJ9Td1cJf+uvur8
         aTPaM3r2nWJktiXeVOjAKv9VyureUWOGB+Vn/5Us0qzDZLw7psS0wshuCLBNP4b5rU48
         ZBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gc3m1uDP8Wo5z1wzLJY3/rncC3r7LBdywkd5BimQRx0=;
        b=tiX4ZE9RQfO5CZ7tkJCqWOzoJfn2KxTIbHtDsfaLRFfoHBBpNQUu5aAjjpRNlbdoC7
         BjIhrbxmkvhpsMjtDBkAkGByregeFjjyV2zPvOkZq2d7mIPQ411Prdhuj0pdggI9+hy+
         tjXHMYI57glD3QdwMm9WQpEpjozXH0DmcaCYKxWWRgcyvR9m72vTqNBEaUztdog7HCnZ
         WoHq+bFzxVU2OgFwgQKYDqUadhJnZjtVtR0EtrS4fy+gh8LbE2OJfDhpiojZ0cX3LVFS
         DVWwCDrVTeUW4Mss+XY+QT7xCpOuN68dyWOQbbEE13mxUS/UR599DY6dBvzSkz1oqt7R
         Bv3Q==
X-Gm-Message-State: AJcUukdgJF+DKu5nkbT+wsNUJkm3P/DlMeAM7j6/yZf2bkQTd/rzqofQ
        qAK4yEOonAIZ67gWnblkcFIAR3R6yzw=
X-Google-Smtp-Source: ALg8bN540j0IRYmE+vH+xS41YVfBHp5zK2etvez8YFjsiD1382KHoVhJ7Y4c+Zp9H2nJKuNvIHvcww==
X-Received: by 2002:a63:5346:: with SMTP id t6mr6911125pgl.40.1545498809954;
        Sat, 22 Dec 2018 09:13:29 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:29 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 11/12] media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Sun, 23 Dec 2018 02:12:53 +0900
Message-Id: <1545498774-11754-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
is specified.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index a5b94d7..f4afbc9 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -331,6 +331,12 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *mf;
+		return 0;
+	}
+
 	mf->width	= mt9m001->rect.width;
 	mf->height	= mt9m001->rect.height;
 	mf->code	= mt9m001->fmt->code;
@@ -638,6 +644,26 @@ static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 #endif
 };
 
+static int mt9m001_init_cfg(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct v4l2_mbus_framefmt *try_fmt =
+		v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	try_fmt->width		= mt9m001->rect.width;
+	try_fmt->height		= mt9m001->rect.height;
+	try_fmt->code		= mt9m001->fmt->code;
+	try_fmt->colorspace	= mt9m001->fmt->colorspace;
+	try_fmt->field		= V4L2_FIELD_NONE;
+	try_fmt->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	try_fmt->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	try_fmt->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
+
+	return 0;
+}
+
 static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -674,6 +700,7 @@ static const struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
+	.init_cfg	= mt9m001_init_cfg,
 	.enum_mbus_code = mt9m001_enum_mbus_code,
 	.get_selection	= mt9m001_get_selection,
 	.set_selection	= mt9m001_set_selection,
-- 
2.7.4

