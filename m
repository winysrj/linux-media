Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AB6C07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0339220837
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kU59vhin"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0339220837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeLIFUs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 00:20:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40794 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeLIFUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 00:20:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id z10so3474300pgp.7
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 21:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WBQlmUFigG6XjRPhVyNz9kgraxu7zwYVtMWk1l0gYuk=;
        b=kU59vhinSQqPf0hyKHR7b0XMnickmmURWrRJzOrGShynxnUnZeHnmewgSrxLWlSnSr
         8YtmSjXjHN89lUWZQ/ZX+M03YNVp2c248t/2xi/NItcz0tVakF106w4xGL+GeSQYVKUI
         +7GM01n8lcXZkLcN5jfR9HZdGhL04Vr6pU4JMtnJF9r9AMJ7K+Tk5mFZhLb+vL54ZSLJ
         3OQ+rkC1wjcjSWIV2doZ4hGa6yvro+YvzKOMRNVT9lzvhvrrzAf2ix7wunK+ugGfMMb4
         WRlccWVo1yH5zU/2oBK4xXoe3XbmAoL6fNBmw+QPX1qA7JdY9EyjiQLQOavNa1K0QFmz
         pTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WBQlmUFigG6XjRPhVyNz9kgraxu7zwYVtMWk1l0gYuk=;
        b=SxU9AADyNw0bXLnK7bwN7h+zTH+idHbFTATXvItfkD+Boz1B7qAmAg/NHmJrc9Mde2
         4V3uo4q13jZllCWlUINWNr64cTGPA8TlMmtnA+EMZEov8L6w/hvhMflHVpUn8FxneCkx
         wejkbAOfR6LNHg8Pd6VC8B85EtX9djdxyFTzI+cVXx9RAr2zV9PN22NlhuPLNxSCU0qx
         cZhjd0IMPh5XXn0vmSZGfZDD/+Pm4ZBlvBtyVcUheSOX7HQFtCQfUENfzhIXwKvJhDJv
         VvQYscHa3w5MwGItF0Rpw1TW8bz9ZyEIRx82+MygfMtStNMMvuOSIhHkSHcDdPfurOIp
         AySQ==
X-Gm-Message-State: AA+aEWYm7UyMVkzSeouPrXcI5VB4HXKE0qa2QWgC8DwGl2uAo1/ZXOzJ
        44/g793+wvbc7zJxVJRsFWYmjKmWhgE=
X-Google-Smtp-Source: AFSGD/VKVlMPRceVe5eGGaO5I7QN1GxcWhH0Iu3/mZ1NgRPoxQNyKAciBcXZbBjZyN0+o3UHzqkFiw==
X-Received: by 2002:a63:a84a:: with SMTP id i10mr7045181pgp.263.1544332847211;
        Sat, 08 Dec 2018 21:20:47 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:a17f:ba11:defa:e2d1])
        by smtp.gmail.com with ESMTPSA id v14sm14973270pgf.3.2018.12.08.21.20.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 08 Dec 2018 21:20:46 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 1/3] media: ov2640: set default window and format code at probe time
Date:   Sun,  9 Dec 2018 14:20:31 +0900
Message-Id: <1544332833-10369-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
References: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Set default window and format code at probe time instead of always checking
if they have not been set yet when VIDIOC_SUBDEV_G_FMT ioctl is called.

This change simplifies the next patch (make VIDIOC_SUBDEV_G_FMT ioctl work
with V4L2_SUBDEV_FORMAT_TRY).

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index d8e91bc..a07e6f2 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -842,9 +842,6 @@ static int ov2640_set_params(struct i2c_client *client,
 	u8 val;
 	int ret;
 
-	if (!win)
-		return -EINVAL;
-
 	switch (code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 BE", __func__);
@@ -929,10 +926,6 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
-	if (!priv->win) {
-		priv->win = ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
-		priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
-	}
 
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
@@ -1193,6 +1186,9 @@ static int ov2640_probe(struct i2c_client *client,
 	if (ret)
 		goto err_clk;
 
+	priv->win = ov2640_select_win(SVGA_WIDTH, SVGA_HEIGHT);
+	priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 			      V4L2_SUBDEV_FL_HAS_EVENTS;
-- 
2.7.4

