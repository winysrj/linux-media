Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2836BC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECA18217D6
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5jbdV6W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfAVNnP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:43:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34481 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbfAVNnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 08:43:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id j10so11111342pga.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 05:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Vc2c/+U0K+i3PDuQKIuUzE1dLsI3MguVhRYJJzQN88Q=;
        b=N5jbdV6WeFoWI3z3/ZCd+k9xo/C8c2omnrqE9POPSEfJCUZYnvqvXpvYQqk5ZfKoV6
         ie5jtoAOdXEeC4dvnVDmzkXbLK/T+2/WVt2GYR1NuDtB3PGEAhPU4KPOq3HVGXJKklck
         JQDbZeZNu2BOIqZoSDxs+W6sp7i04jlpehMMkgWxmEFUiJCZGZcCNBeTYcSzDX1Ruf1g
         08DXQ4QC9abGpTo87nKiVKfA651ecRzoFpAfQ4myfUB5ReJOVy69T6OonhLStlYe969Q
         iN5ZQ0GMhF8cJbS8l1eLbbQW3FG81gkcKRBwxx0JepIdcuQjsfjDoG94zlu9t0x8zlFm
         eT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vc2c/+U0K+i3PDuQKIuUzE1dLsI3MguVhRYJJzQN88Q=;
        b=fJoeVnaJLtsqCPO05wSo4uQHAXgSyFdsTP36sX6dMV+C3b4k+25NQZbatM2bv3lQ6f
         ceJIoKgF8GQcZdStO1866FIcwQpQtnojH88ajsuM5jt2lY4OLTQ+IVPxxLtyPg0HDh3r
         yD2dgYq8MnmXSP0BcptRiMIoBXRBQa+I2Ns18fDbuq1Isn7j8U+x8eYG/alhK31Tf7vG
         6hQoJ0jvqCl4DWxVVgCZRF2wnfZ2glaasDVaiSOZ3oafmws0j9jzE5OHr+zNGkGT4/w8
         x1h4E4Ax9Ucn2W9kkWfimhwYKnHwhCCixABdL5m9TKDU4e4kiMxp+V9RJtkG+p1j4jTa
         +IQA==
X-Gm-Message-State: AJcUukej6UH/3rsRfQ00dUJh7N80ANjAZAXVUk0lKIFvZQ94HYJWD2Pb
        GdE3EAsmSCkuPikgxWg09waE7ocP
X-Google-Smtp-Source: ALg8bN6/T1etB4bxiBdpztPuA4w6X+DsyrqjZ7AmKEZ5rgm/Rr//i0OkjAH1QjxoLTLjTHTS8mszUQ==
X-Received: by 2002:a62:39cb:: with SMTP id u72mr10888564pfj.223.1548164594476;
        Tue, 22 Jan 2019 05:43:14 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:b4ea:7cb5:3c80:b4f1])
        by smtp.gmail.com with ESMTPSA id r66sm25435133pfk.157.2019.01.22.05.43.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Jan 2019 05:43:13 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH -next] media: ov2640: fix initial try format
Date:   Tue, 22 Jan 2019 22:42:59 +0900
Message-Id: <1548164579-21458-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Set initial try format with default configuration instead of current one.

Fixes: 8d3b307a150a ("media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY")
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 37e7c98..83031cf 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1011,14 +1011,14 @@ static int ov2640_init_cfg(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_pad_config *cfg)
 {
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
 	struct v4l2_mbus_framefmt *try_fmt =
 		v4l2_subdev_get_try_format(sd, cfg, 0);
+	const struct ov2640_win_size *win =
+		ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
 
-	try_fmt->width = priv->win->width;
-	try_fmt->height = priv->win->height;
-	try_fmt->code = priv->cfmt_code;
+	try_fmt->width = win->width;
+	try_fmt->height = win->height;
+	try_fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	try_fmt->colorspace = V4L2_COLORSPACE_SRGB;
 	try_fmt->field = V4L2_FIELD_NONE;
 	try_fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
-- 
2.7.4

