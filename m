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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C6FC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17E312087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFTAayT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfAHOwo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:44 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35557 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbfAHOwo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:44 -0500
Received: by mail-pg1-f196.google.com with SMTP id s198so1848618pgs.2;
        Tue, 08 Jan 2019 06:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hz1efdGFA0dZw4z6O3AH/HTzRkZXZBoGU+b+2ggkl38=;
        b=ZFTAayT/7Z5jiEgCcbgjGo1lN+7bneKO+04Fqv8RbnFgg9yvJf+BramDtQBc2C1FOv
         lFpCd6eCgAYikk4dK8PjTTfFcJ4WPTjVlO/2aDq3CA5fNIXf/UBg80aQlqoLfxn5zLLd
         ATAE5d7bTowC0zahp3h+k35j584fUMsNO/sZFH0eFgJ/AfX/ogOGRo37f2iMEdIj0Vwp
         wnbkeqt+fG2BTK1je5wc/+XcsSS4wuvPuwOnIVPsKdOD9P9iQKBNTlpTtmbWtCVeVQaE
         UATlSq8/apklgnZnOZHdjdxf3PQXO0MV4iFE9ssmoJ3Y2t/8xnDWxP3WAev9+yNFBDJH
         546A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hz1efdGFA0dZw4z6O3AH/HTzRkZXZBoGU+b+2ggkl38=;
        b=Zd/K7i5i95z/+IhQf6aBMBfwJ8FYO0uVQXuiU/WCX7Kygv4f2NumxW9vCn+cum/sLU
         K4jyPrNJ4zLNwSVf+PNxBuckmh9dSW7ui2bxT0Be0JbqZDaX6Z6gD01GhvYNlRKhwov4
         nO9Ir3ujmTwEUZck7BWdD7zB8w95ByrKAZe9RrrArdDpzkG17IH9KAnsM0VlcXDe31fQ
         pF/Pckyu+SQ68Rph4TF+642z+89oYG9R10nZ6ObsW/3GNXPgeDSRJrfK6bolAUo6nGEE
         Q4rBet4MwIdHTY4NGNDOihfVT6rReqO9ng920cr0GYjrjFuALeoT6e5S0E1ivOupJBju
         qu/Q==
X-Gm-Message-State: AJcUukfaPb6drccnd/s8DGWgG64+c6+5202g4BWQEOdGlRyhewT0e/Xm
        BBMzbyJynAbgBE+mLPqK390rHLvZ
X-Google-Smtp-Source: ALg8bN6kck/PdiCpLjfzQKdNZd8vA8IloNxDQexIIysm+AiVBuHYmKnBqg5KlLRyIltCEC2kSKjRFw==
X-Received: by 2002:a62:178f:: with SMTP id 137mr2014436pfx.226.1546959163500;
        Tue, 08 Jan 2019 06:52:43 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:42 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 12/13] media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Tue,  8 Jan 2019 23:51:49 +0900
Message-Id: <1546959110-19445-13-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
is specified.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Set initial try format with default configuration instead of
  current one.

 drivers/media/i2c/mt9m001.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 66a0928..f97ab48 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -329,6 +329,12 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
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
@@ -642,6 +648,26 @@ static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
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
+	try_fmt->width		= MT9M001_MAX_WIDTH;
+	try_fmt->height		= MT9M001_MAX_HEIGHT;
+	try_fmt->code		= mt9m001->fmts[0].code;
+	try_fmt->colorspace	= mt9m001->fmts[0].colorspace;
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
@@ -678,6 +704,7 @@ static const struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
+	.init_cfg	= mt9m001_init_cfg,
 	.enum_mbus_code = mt9m001_enum_mbus_code,
 	.get_selection	= mt9m001_get_selection,
 	.set_selection	= mt9m001_set_selection,
-- 
2.7.4

