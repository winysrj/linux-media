Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D62EC282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B29B218D4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7qTkT4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfBHOxC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:53:02 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42536 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfBHOxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:53:02 -0500
Received: by mail-pl1-f194.google.com with SMTP id s1so1783907plp.9
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=soC6E4l0050itrBl5bDRGiK/SYtRT65nFYPm5R+cUJE=;
        b=S7qTkT4Zlh3ru/VE90IUrIHIkZiQJHU8dGsCizQn2XQZ3HvcptIaWhISYj5AncZLza
         u1/zWzi42IPyVZhiJICnFm6DJ52tk56DBlcFkhHpumX61Gzdm6q48MtoXTcLA3xeEey/
         nC7ULveJkPb313D3dlNIV+GPSqVYrfLz4I3vTBHTJwRcF356dpLf8ZUSf0P2VYu9pGIo
         edrPhpF/zluaNyzTLTNUW38zdxjzI8msrAY7Qi7GTF+Osx8JOat3/3SHMOcPAAiIgMpF
         FwqTPpsGbr6uNY/91g9hCS7v4HLiyrOfukWASXOHuejEdziM2R2KRIQ2Jgg0XvzoNGPs
         MLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=soC6E4l0050itrBl5bDRGiK/SYtRT65nFYPm5R+cUJE=;
        b=BV88Wo7fY6wRf7sBo7rGgoFbtpNev6RhLRVU2OehwSVbcQZLajsq35e46ISUfcNd7G
         687+qxb1QVNUilyowJ2L9D6tfn0VU0EHkBNJH8ipcY+bvWf8fR40WmwYc31EQEhrcrws
         rhv/EgGegC2qopTLhW9QHq8M62ukIzUG0S3tsT9s50ycytRS65lNzGLR4k1JH1Mw8tF+
         +PWUZ1n94taaQ+IZrT+WPv9PkX9v8EYuDxN+8aQb9fB47kG8b2KTKpUUjoMSDByR09AK
         083lH4Z6KIEp5lhKxHvbIhxsPHWtbp6BZTUDlERV28Qu1sa6+W8lx2aqhc1l610039G5
         ybug==
X-Gm-Message-State: AHQUAuYnCXR/5YR3eybhGjI/0W5PvosBHwUZwW1uwX2LUBOce/AOJZEz
        kAe3WXQeR96X1kZ/BHbrARbtQrrheIk=
X-Google-Smtp-Source: AHgI3IYHgoqGegW8k8bnqmFC4CwKoh8/y61T2rpqWSMdyKyo2CNz5ro0JL3kJx86K4qVOUUQ+tp2HA==
X-Received: by 2002:a17:902:f091:: with SMTP id go17mr23460556plb.235.1549637581777;
        Fri, 08 Feb 2019 06:53:01 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id s79sm3425216pgs.50.2019.02.08.06.53.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:53:01 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/4] media: ov2640: add VIDEO_V4L2_SUBDEV_API dependency
Date:   Fri,  8 Feb 2019 23:52:42 +0900
Message-Id: <1549637565-32096-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
References: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver currently supports MC and V4L2 sub-device uAPI, so add
related dependency and remove unneeded ifdefs.

Just adding VIDEO_V4L2_SUBDEV_API dependency is enough, because
VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig  |  2 +-
 drivers/media/i2c/ov2640.c | 12 ++----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index be8166d..12d7e52 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -652,7 +652,7 @@ config VIDEO_IMX355
 
 config VIDEO_OV2640
 	tristate "OmniVision OV2640 sensor support"
-	depends on VIDEO_V4L2 && I2C
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 83031cf..22782e62 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -298,9 +298,7 @@ struct ov2640_win_size {
 
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_pad pad;
-#endif
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
 	struct clk			*clk;
@@ -927,13 +925,9 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 		format->format = *mf;
 		return 0;
-#else
-		return -ENOTTY;
-#endif
 	}
 
 	mf->width	= priv->win->width;
@@ -1010,7 +1004,6 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 static int ov2640_init_cfg(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_pad_config *cfg)
 {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *try_fmt =
 		v4l2_subdev_get_try_format(sd, cfg, 0);
 	const struct ov2640_win_size *win =
@@ -1024,7 +1017,7 @@ static int ov2640_init_cfg(struct v4l2_subdev *sd,
 	try_fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
 	try_fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
 	try_fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
-#endif
+
 	return 0;
 }
 
@@ -1245,13 +1238,12 @@ static int ov2640_probe(struct i2c_client *client,
 		ret = priv->hdl.error;
 		goto err_hdl;
 	}
-#if defined(CONFIG_MEDIA_CONTROLLER)
+
 	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
 	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
 	if (ret < 0)
 		goto err_hdl;
-#endif
 
 	ret = ov2640_video_probe(client);
 	if (ret < 0)
-- 
2.7.4

