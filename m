Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C352C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05CE2145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cj5ppDz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbeL2RH5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:07:57 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40785 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeL2RH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:07:56 -0500
Received: by mail-pg1-f196.google.com with SMTP id z10so11241489pgp.7
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 09:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hCfbsDT3WB7JJDTASC61Hh4ta8XGF8ois0pAxvjQ2dY=;
        b=cj5ppDz1eCQnSBLfFSQrreFPKzFOb86wUl9lZp/hu4p5g845X8t7AviwGiKkKQVtYj
         NIKIbY5pIrp1Boc6S0DsyTJdlPpMXbBbYSahjqFBJWw3oB1yMbw1w1vw9TaCnsNDTjvT
         Ukwxxh6TQEoWgXojY4XF2Qy+v4SggS4cdpDu47hOaLN7h1H60Q0kkoVJ76+FO5vpZF59
         r6QNZkMwq8hsUCAc1Vp+Q2frPhOEgP+TeJy7SzsE9RSvC70jqHEtGwZScQRZq4ApE/mm
         R0OvJhuT1yuyOeb8XVl2PMv32KzMc/8EPuJKithac3FcriPutVerPQhHybDPCQ0f/A1G
         9kLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hCfbsDT3WB7JJDTASC61Hh4ta8XGF8ois0pAxvjQ2dY=;
        b=mOuAc1HX7VvaWw3eMI56YCTHhUCKLV/FOt6OxNE5WxFQEe9N94WRf5H0wWAovE3Cfe
         RSODmqddWfzpCn3qymo8AmBDxXXgqAMR0pn471ABosE+lUqHB4vO9eMUvMHIATPQz8u8
         AduVpKG6IYRYlpXLg3+0+hLKY1XUzWNLbwpawxm94zK++8sclwP35Ip2I8WKz1k9B++Q
         pKMQQOHY8nwl2Lf6+/QBpD/44YyUBdoSeLK68Z770cfOtjIMlFKPYM2gSCdBWbcNa3SN
         c/ueqGgQqgTs4ErY7Dun/R36JyNxVW2SI4+XQ4K4a9HRIywRP+oGfNWWHKAL6OJ4Lzca
         YUqQ==
X-Gm-Message-State: AA+aEWbN6AhdUUn0iqJ52NP1sWhUsyeRhZZWYA98n6TOxfXIc6uT0q5F
        z2JVbL931YivTZLOaccs9ktopTSLXEY=
X-Google-Smtp-Source: AFSGD/VsYdi6dJzYc1dl0eRxpJR7+IrP3CjjWbhBEuss+JDU9g2T4ApIVwPA5z7iSp5qANrRC9Jpkg==
X-Received: by 2002:a62:1542:: with SMTP id 63mr32607572pfv.230.1546103275682;
        Sat, 29 Dec 2018 09:07:55 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d91e:35b2:75a8:1394])
        by smtp.gmail.com with ESMTPSA id h134sm86856276pfe.27.2018.12.29.09.07.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Dec 2018 09:07:55 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/4] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Sun, 30 Dec 2018 02:07:36 +0900
Message-Id: <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index f0e47fd..acb4dee 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
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
@@ -1090,6 +1100,26 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
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
@@ -1115,6 +1145,7 @@ static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
+	.init_cfg	= mt9m111_init_cfg,
 	.enum_mbus_code = mt9m111_enum_mbus_code,
 	.get_selection	= mt9m111_get_selection,
 	.set_selection	= mt9m111_set_selection,
-- 
2.7.4

