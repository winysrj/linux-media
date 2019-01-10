Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51304C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2316120685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBu73nkJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfAJP2u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:28:50 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36576 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfAJP2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 10:28:50 -0500
Received: by mail-pl1-f196.google.com with SMTP id g9so5338325plo.3
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 07:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oRLQpJfC6sZ1ksdB3sjUANiu4JbRPckOpm5gxomixO4=;
        b=BBu73nkJdsbYAjVMr34t4tuAZg7ImzIHLrw5Tse8SyN/Fq3h+Idog35KhXLdgjZCvq
         c8Gd6B480iadXsPFOgfVtb/GT5CU3CUPAywGRqskShtwcrPlhUFAh94CuNnw+1t3zauV
         uViHIIkvtO2/WcSWNSohSJi5LWQbHrKSvHTIY0gxiiSEeF5rGYHK6iRV1mOg+SC+zW9v
         q7VjwgNZb0d1RCCzU3EryIYyF/w5lUhWjQVpJn0zVuFZQRrSZME4cN5vOlfarZ1e5RIw
         ikDk6bJdnZr6srdv5WSjHaXSq0Kszb+HE+I51k53KzzpZ/lmvTSa+DdfSNpTPRJPirbk
         reZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oRLQpJfC6sZ1ksdB3sjUANiu4JbRPckOpm5gxomixO4=;
        b=fBHkA2OemmRah4HWthmvzeDxeZ7XEmAjTdQpUN6MvsTYdkMi47nmIr3J3u8tO8bZtE
         fSxSBT5Mbb6dJACrZJpb5klgGO+R8aJeDx4KD0iD+kEmnl25O7zb/JP+8DOr6csauGSW
         8PXgyIuvdb+lHl7AbJjtIvnhEZ4IeCYXd/1QguQ6uxhRUdls0gTumZIzGk7xWJL86Wcy
         rniFCOUJkauyPfW4gOc9zwTUOu/qBOtRLWkQa3yvXxgzhuQAcPDvX3GJhopIkKVyH9wR
         epUUKTETaT+oLrnjEFhbQehFXc++6Om2d5DbucSr23t3lXFKw3E15+4SwIde7oPjiRPL
         NnEQ==
X-Gm-Message-State: AJcUukcs45f6ryTliRArwOou8vA531a6J/IXTBgDbfPbTgFq/8BnS60N
        melK+gwhyy0V5vOL3/Fb2IbmKI2X
X-Google-Smtp-Source: ALg8bN6tjmRxrjbl5MElKMQea4wQR+eVkizgCWcTg09C1eW5JUw/tl7wlH3Z2rq7MOl/gMbsbRAelw==
X-Received: by 2002:a17:902:2c03:: with SMTP id m3mr10252465plb.6.1547134129778;
        Thu, 10 Jan 2019 07:28:49 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:25a3:d6ca:ee6b:e202])
        by smtp.gmail.com with ESMTPSA id y1sm105916116pfe.9.2019.01.10.07.28.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 10 Jan 2019 07:28:49 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Fri, 11 Jan 2019 00:28:27 +0900
Message-Id: <1547134109-21449-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
References: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
is specified.

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Use format->pad for the argument of v4l2_subdev_get_try_format().

 drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index d639b9b..eb5bf71 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		mf = v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		format->format = *mf;
+		return 0;
+#else
+		return -ENOTTY;
+#endif
+	}
+
 	mf->width	= mt9m111->width;
 	mf->height	= mt9m111->height;
 	mf->code	= mt9m111->fmt->code;
@@ -1089,6 +1099,26 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
+static int mt9m111_init_cfg(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg)
+{
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	struct v4l2_mbus_framefmt *format =
+		v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	format->width	= mt9m111->width;
+	format->height	= mt9m111->height;
+	format->code	= mt9m111->fmt->code;
+	format->colorspace	= mt9m111->fmt->colorspace;
+	format->field	= V4L2_FIELD_NONE;
+	format->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	format->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	format->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
+#endif
+	return 0;
+}
+
 static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
@@ -1114,6 +1144,7 @@ static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
+	.init_cfg	= mt9m111_init_cfg,
 	.enum_mbus_code = mt9m111_enum_mbus_code,
 	.get_selection	= mt9m111_get_selection,
 	.set_selection	= mt9m111_set_selection,
-- 
2.7.4

