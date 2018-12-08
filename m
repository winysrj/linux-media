Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792C0C64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3853E2082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdEVYbiv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3853E2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbeLHEpD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 23:45:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43531 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeLHEpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 23:45:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id v28so2578876pgk.10
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 20:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Eo9cjpGrYKwVLG6uLmFxmXJ7VVMeoxAuQcb66SpiWa8=;
        b=OdEVYbivilLm3CsUH/Z9NZWo7uwxl3Qcz13X4L9zkE5/TT3jHg+rRhwB88gNfCZKfL
         eqx7Yl3bqevnIp0ljJoQGMOrZC34DVymfEvwaHl/3Xor68QJUvOTf+U00QuUO/503U4D
         OLGuJlBzMljY2Qm8Pv70/OgqEx0/Bg4uSzY72Huz0+Eu5nNq3ICVJ/i8K6Ur0anBzgxS
         KjS08NHppJfEBga/6V+CmTTi2Wmu2H/nHkGGF/O0/wZSlkZ1Z+YzIORLtA/ZBu2bjtAz
         ayzyM2BJzas4Gqpni/DLLw5e4ubesyVdI5Q60hpBx3YHkKc1/e6D8toLlLwbKZpWcjJL
         Fh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Eo9cjpGrYKwVLG6uLmFxmXJ7VVMeoxAuQcb66SpiWa8=;
        b=NriSHmttYqSz6bnfGlEFSokIjYITxLq/zMUEHiRsepV96/ee+ew5F5tgbaxgVMvyqV
         xkD37M8f7IjtZz4Cihk+Rnb6EmXxKjx/t2nMiTynWjmKizmumeYfj5Usm7i6JGyAV6Je
         8bpQ5k6gooRx2cBxDZIvs7pZTf+QFGhe4cADyFOwcM5A+Nw/xAt5QDqtIaT4pZLgw9O6
         UX/gWu5jvgrVKi1LDVbhWjgMQPN4jBliL++HT2UYQOsLNU+7ExZq85p7++lsFoFQXKaU
         zKj9jrNdLnZho84rPMrnZsoaY7DBWk60Ilh8NeZz8U0/Q2mW5eZeABVn1mW7VqOI238A
         Yz+Q==
X-Gm-Message-State: AA+aEWY6TAgBb2d/OPWtyYPXTjyBR3EfPFAN1ARCViyfCkM+sLA5M8Kp
        o2/V8sdhfbn0K3VSoDXOavyr4ZSJ
X-Google-Smtp-Source: AFSGD/V29lYZolZxJU2DNS27Vfyc//OvkOuZPZeGz8JtZ6Gip6VqctSrfp/GFxbTXOj2t0/WfsPCEA==
X-Received: by 2002:a62:6f88:: with SMTP id k130mr4761569pfc.234.1544244302143;
        Fri, 07 Dec 2018 20:45:02 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9ca3:939e:b94a:438e])
        by smtp.gmail.com with ESMTPSA id h74sm8248193pfd.35.2018.12.07.20.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Dec 2018 20:45:01 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/3] media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Sat,  8 Dec 2018 13:44:45 +0900
Message-Id: <1544244286-11597-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
References: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
is specified.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index a07e6f2..5f888f5 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -926,6 +926,12 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *mf;
+
+		return 0;
+	}
 
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
@@ -992,6 +998,26 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int ov2640_init_cfg(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
+	struct v4l2_mbus_framefmt *try_fmt =
+		v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	try_fmt->width = priv->win->width;
+	try_fmt->height = priv->win->height;
+	try_fmt->code = priv->cfmt_code;
+	try_fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	try_fmt->field = V4L2_FIELD_NONE;
+	try_fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	try_fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
+	try_fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	return 0;
+}
+
 static int ov2640_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -1101,6 +1127,7 @@ static const struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
+	.init_cfg	= ov2640_init_cfg,
 	.enum_mbus_code = ov2640_enum_mbus_code,
 	.get_selection	= ov2640_get_selection,
 	.get_fmt	= ov2640_get_fmt,
-- 
2.7.4

