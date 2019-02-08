Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2294CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11FF2075C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRTwqlgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfBHOxF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:53:05 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38983 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfBHOxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:53:05 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so1676023pgp.6
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y23HW3DG8+piGfD7AMC056053ljBU2/Aa3AAn1dICDc=;
        b=NRTwqlgFmnM0WA7Gm8QIgxTWaBXIeKqQIY7ZmqTAJU8N7tByulbNj/+M3mNfPI7iWD
         zB6q+4aPRMkF7ZHCr1VQHl29gq3sFnaUw0hsNwzXcOupAYcPzXHua7VWyQMNBuvm+gMb
         ysb0q0ubFdpa/MfqiDUSty3B09UgaefeYe/9knioagGvklJpWHANySdzhn5xcVjnaUEu
         6eCZ7jOHuF2VmTNC1lP3KfQwxsK8h6+c1WQwwgU2YxPF7QsvP2ekstKWf0wnZ/Q0OCfn
         Rz4kUMnNZSzSf+qucLdYWURpp+I9ypMfoxFOO4DAG0D9KUA6O0RgxKQSk59OpTa3PA5M
         ru8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y23HW3DG8+piGfD7AMC056053ljBU2/Aa3AAn1dICDc=;
        b=umcw6pI4NUOoi8lU1+dzAzizBgwIh/FWgWOT9gJHGMopQW2KGF6PJ/UYzg6qp+rTh9
         MPj2wBsDpWFU41KTciVXFzf0hWgHK+sTNJngjw1FVmi6A1kneNIdTxtGXb4S4EDY53ar
         w25B3aO23ITRiRQFtLgf3Zbd9Jk2n4KbbJx+bO6s/yTi/F53agxf9SMhIIg1gsgksMWe
         Jo1XUxWCyK9qr/OhXLqwt2S8UxeyJCIvO5J+9S+1TmthtZ+/4TzYgNkenteLac226F2z
         ERBXKu96SYvH6p0c0Yu62z8utGxm7LGRpl5c0XjRhm1JAbDxTJ8sfeKMuEOxGg+F6hB5
         KdTQ==
X-Gm-Message-State: AHQUAuZyvlM7xMWfzAmSdGKvLbsjVToTTzC92J/Z6xl+Yc2uuSW7E7/P
        q3zhJ+U+JkGb23B8dMxV5/WLT04Yvu8=
X-Google-Smtp-Source: AHgI3IYJkUFsm5zziUnIhJBNyH1eZ1XDgtkzzijEDrJ99Hmj6iVFV0I7bsJHjdOPxGRdawSTnARU/w==
X-Received: by 2002:a63:4566:: with SMTP id u38mr20585106pgk.4.1549637584215;
        Fri, 08 Feb 2019 06:53:04 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id s79sm3425216pgs.50.2019.02.08.06.53.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:53:03 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/4] media: mt9m111: add VIDEO_V4L2_SUBDEV_API dependency
Date:   Fri,  8 Feb 2019 23:52:43 +0900
Message-Id: <1549637565-32096-3-git-send-email-akinobu.mita@gmail.com>
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

Suggested-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig   |  2 +-
 drivers/media/i2c/mt9m111.c | 13 +------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 12d7e52..71c7433 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -876,7 +876,7 @@ config VIDEO_MT9M032
 
 config VIDEO_MT9M111
 	tristate "mt9m111, mt9m112 and mt9m131 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	help
 	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 5168bb5..55e2f46 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -246,9 +246,7 @@ struct mt9m111 {
 	bool is_streaming;
 	/* user point of view - 0: falling 1: rising edge */
 	unsigned int pclk_sample:1;
-#ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
-#endif
 };
 
 static const struct mt9m111_mode_info mt9m111_mode_data[MT9M111_NUM_MODES] = {
@@ -529,13 +527,9 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mf = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		format->format = *mf;
 		return 0;
-#else
-		return -ENOTTY;
-#endif
 	}
 
 	mf->width	= mt9m111->width;
@@ -1109,7 +1103,6 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
 static int mt9m111_init_cfg(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_pad_config *cfg)
 {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *format =
 		v4l2_subdev_get_try_format(sd, cfg, 0);
 
@@ -1121,7 +1114,7 @@ static int mt9m111_init_cfg(struct v4l2_subdev *sd,
 	format->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
 	format->quantization	= V4L2_QUANTIZATION_DEFAULT;
 	format->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
-#endif
+
 	return 0;
 }
 
@@ -1293,13 +1286,11 @@ static int mt9m111_probe(struct i2c_client *client,
 		goto out_clkput;
 	}
 
-#ifdef CONFIG_MEDIA_CONTROLLER
 	mt9m111->pad.flags = MEDIA_PAD_FL_SOURCE;
 	mt9m111->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&mt9m111->subdev.entity, 1, &mt9m111->pad);
 	if (ret < 0)
 		goto out_hdlfree;
-#endif
 
 	mt9m111->current_mode = &mt9m111_mode_data[MT9M111_MODE_SXGA_15FPS];
 	mt9m111->frame_interval.numerator = 1;
@@ -1328,10 +1319,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	return 0;
 
 out_entityclean:
-#ifdef CONFIG_MEDIA_CONTROLLER
 	media_entity_cleanup(&mt9m111->subdev.entity);
 out_hdlfree:
-#endif
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 out_clkput:
 	v4l2_clk_put(mt9m111->clk);
-- 
2.7.4

