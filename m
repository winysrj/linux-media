Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2CDC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410F820873
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTMTJ80L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbfAOOF6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:05:58 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34138 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAOOF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:05:58 -0500
Received: by mail-pl1-f193.google.com with SMTP id w4so1354889plz.1
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 06:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hlnm9D8OUwcR3uZqYdz7phjSb/NYSvzfP6TAHCc46Ks=;
        b=kTMTJ80Lz2nr78589pVnVy2Vl275T0hpiOEofTkNM+i2xwtVeu0J1KyFt2IuFIWt/H
         iJi/8UmcrSrp1RGeqm5SP/KN22nkkBPQoSvhUV4arGuq5kZq5SxYw/VSJszTE7wTVp1v
         RFkofkgV1Q1H5FhPVaAW/2tt5QSNVLDt4NTvBdvhEK1rVOI7YySZ8HMCLjuemdhvbzjR
         WAUcOjVp/u+aiMNo73TrmKwHCyddRy76Xeg/Wt9UZArqz/2fRy1h/ZQ9cXdnuPkdmsvC
         rKf6sBHJCzew8QxbYAaeRQe2wndKTRRrEOr/g1OXlXhuUUwR2Zes4r0I8r3DIl0UN7B0
         j0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hlnm9D8OUwcR3uZqYdz7phjSb/NYSvzfP6TAHCc46Ks=;
        b=i2dZME6ZXQs4R0eDtWHOgZkXesT7Co8HlxAK0mfc6jG668gKLOr6X+oa18wVqbIDOq
         B4o/ckcZ6hOZKsmJLzCdIwwR+7SFospFyEmUOh3f8A3HOd0xRJJP5PKTSXrjGqoUWV8W
         v9trFDCdh2xvz+JjoqbjhdBvGLQL3J9A/cPuROvi7pT7eIQwc5FWIPZZPp5HrCGJtnV7
         tvWDoCVmDFyR+04Na7pJK5bltZpkOxAs64zPKU3lmJAP/Xa4fgtcE2PUlmdnFA//Of0Q
         27dnFVHCvrGpDVkpaOLjbnqUhMBtyYZ2GMXIvkgUlj0lZKd+Cs0aKuhu02tTKq4FqYcm
         7u7w==
X-Gm-Message-State: AJcUukfPn9KXqTcewpccl3tLHcvvIjANtXW8OIWjhUS0iB4b7VqWpwYQ
        9pVgw1EdwuG/S+n6moOPEk0yqUVb
X-Google-Smtp-Source: ALg8bN7iepZwWACewAv0VOnzMKJLixmPiJFZlthVzpmFf+mMmkG++9VF1zgkMwwPSiIiCkrMQQ+D3Q==
X-Received: by 2002:a17:902:6a4:: with SMTP id 33mr4204922plh.99.1547561157312;
        Tue, 15 Jan 2019 06:05:57 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5894:91d7:f206:dece])
        by smtp.gmail.com with ESMTPSA id c72sm5394125pfb.107.2019.01.15.06.05.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 06:05:56 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Tue, 15 Jan 2019 23:05:39 +0900
Message-Id: <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
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
* v3
- Set initial try format with default configuration instead of
  current one.

 drivers/media/i2c/mt9m111.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index d639b9b..63a5253 100644
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
@@ -1089,6 +1099,25 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
+static int mt9m111_init_cfg(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg)
+{
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+	struct v4l2_mbus_framefmt *format =
+		v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	format->width	= MT9M111_MAX_WIDTH;
+	format->height	= MT9M111_MAX_HEIGHT;
+	format->code	= mt9m111_colour_fmts[0].code;
+	format->colorspace	= mt9m111_colour_fmts[0].colorspace;
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
@@ -1114,6 +1143,7 @@ static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
+	.init_cfg	= mt9m111_init_cfg,
 	.enum_mbus_code = mt9m111_enum_mbus_code,
 	.get_selection	= mt9m111_get_selection,
 	.set_selection	= mt9m111_set_selection,
-- 
2.7.4

