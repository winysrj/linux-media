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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE67BC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9011020685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGymEQW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfAJP2x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:28:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33368 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfAJP2w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 10:28:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id z23so5351970plo.0
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 07:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vbK0onps6QNpGFPH3w79wJbQWfWBHGk9EgEyiWWP5OI=;
        b=KGymEQW+iZWOMvUYRVwF2jaFkfxB4C2fOQP1iJQepWH+KJJZAmRMRL/qfqX1suog5C
         HsXz2b67pQ7Jilan7qsoxzA4HMU145ED0JsNbrF385cy2D1Pa4xeyc5HnFohZ4jg4uqJ
         pbBcITu9kED0fDZzer5N/FaR7AKm2XE5oeebV2ikk2zamuxlMWXdEZ7dio6m8Z4VIxE+
         sQEozr8F9i8y6ZbZwaPGkhZGZme1I2xAlR/958tb/v+lYEzX0kQH5loPjxXYJadQpy5o
         NwZPl4WNd8ZZdrIT7AzNqbKFnpS+9NrIIIaC3bHvacCW603Se6su3lWCeTz3hAvuXenY
         5o+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vbK0onps6QNpGFPH3w79wJbQWfWBHGk9EgEyiWWP5OI=;
        b=lvDBCvi4ww4GR7IZh5XyUFhHcpIumzFGM4rIVX9wAlfTkX0+M2jPWtiAePu2cz0OmJ
         z93Rg52Ow28NF/BFOM/5qeUqifPg2GPJm2gxD9SVZPRTWlTWfmf1Oz/8xT6g67Y2ajW2
         0G+hQEaUZHS4MXnHBiB8IRL/doYWU8evkK0PIkfWJvqLrgJlAsl/OtZ4wCygV6nUl20j
         q86GqVHKRBU5Nl9OAzU1LUgCCuhGHnz8UXqAZUQdr89Bcsg9LY+hKq5JtK0JfwQAIF6O
         X3O9qvVRWcUwIhDfPtBKC5QTwQTual3jAb/rJ2/1bP52bEIjkc0T4YOMg4wMoxyPmlWk
         gyZA==
X-Gm-Message-State: AJcUukdFh9QW/g/HHN/mri7x8UdRo94OYLlqr3aarwjnn08xuvArOb6H
        51xnikqdlQEwe/ucVdoBoDD6uwZK
X-Google-Smtp-Source: ALg8bN6gu2Q43kveMNX2nihPt/YGT4B6PGyuRMjZNa9loXsFldteTeXdnsxnmP9680HE/R0hglwHiQ==
X-Received: by 2002:a17:902:b68d:: with SMTP id c13mr10785967pls.102.1547134131931;
        Thu, 10 Jan 2019 07:28:51 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:25a3:d6ca:ee6b:e202])
        by smtp.gmail.com with ESMTPSA id y1sm105916116pfe.9.2019.01.10.07.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 10 Jan 2019 07:28:51 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 2/3] media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Fri, 11 Jan 2019 00:28:28 +0900
Message-Id: <1547134109-21449-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
References: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/mt9m111.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index eb5bf71..e758b4d 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -543,6 +543,9 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= mt9m111->fmt->code;
 	mf->colorspace	= mt9m111->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -670,6 +673,10 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 
 	mf->code = fmt->code;
 	mf->colorspace = fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization	= V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = *mf;
-- 
2.7.4

