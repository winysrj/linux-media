Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92461C64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5517E2082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqZUlj3Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5517E2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbeLHEpF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 23:45:05 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33940 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeLHEpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 23:45:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id h3so2883276pfg.1
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 20:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w8ZQhO0cjjcHm7rHaC9H5vuwi0uhHH55gn+KwXZEP2U=;
        b=TqZUlj3Zm6YSUYzP86VEojf+UvszEgEqdCRzlVekOL2ahSI28oFNnb4+hHh3wWvjMf
         1sTNQ2aaC7244qh4hY0Higddnce96v5UfsPtsZMZN/GG8KyEKGhOfMe1vM1HCAMTt7j6
         fDp6sxaAJc+sELfU4gPCQv9ST9za/atgA7LJA33cRvp0g9ln40Hh5KLh3CaqOsNW4fDT
         7TzHwQ034WUfX6NBya5lJ3rQQA5PCtw2sNF8FUj+I0DuOdI1IyvCITdhXeMTrkESGWao
         aNA9Wbrvw8CEpKeYnU6oC45yXEJDjLw8Pf2xyFJXWWFTlJIwclYOaqzmMLua50zeEKAk
         +Bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w8ZQhO0cjjcHm7rHaC9H5vuwi0uhHH55gn+KwXZEP2U=;
        b=dJfrG1b35ly8rtAJomt9or7Q7EiGleFKitbnhIqoozYta8jsjQq7Ao92T0rQ2nziIO
         0/abQHAMTOQ69usQuB7Ab1sy9EASly37i4bb7wutsLBRAbXemxLw4QFH7BRKNuj15km2
         faKQVlzJvo+JVQc2bWrp+EUSDnHGnaVzOBhxoN1dlmuLnv6w3LW+4vN7Pd+4IlemmLd8
         4JX40UKk986Oy76dkxy9xhqrd/jo1UcCQItJFmnVmx7dph1WrenasVs5TzBc2mx7caYB
         1BV4YeKk1ogtl81ubxrHx2OQXjOXs3rvSppIiBH/gdnxEEMwp+Us0N158pdS3B3RRDyF
         VH1w==
X-Gm-Message-State: AA+aEWbJfhqwG+p1LP8CoOFOryd032Zox+vc12l3q3P66GeRRYbN6i9e
        I9Gb6jfLA1BHbu4YQ4cSicFuY/wA
X-Google-Smtp-Source: AFSGD/W587gybZw5IqvksHp/UolaTgB3UiX6ncQ71cnzBeD1vGsyagGNiaXqoNQjnqbpaR7rFKaaSA==
X-Received: by 2002:a62:60c5:: with SMTP id u188mr4839977pfb.4.1544244303837;
        Fri, 07 Dec 2018 20:45:03 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9ca3:939e:b94a:438e])
        by smtp.gmail.com with ESMTPSA id h74sm8248193pfd.35.2018.12.07.20.45.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Dec 2018 20:45:03 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Sat,  8 Dec 2018 13:44:46 +0900
Message-Id: <1544244286-11597-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
References: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 5f888f5..439c6da 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -938,6 +938,9 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= priv->cfmt_code;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -964,6 +967,9 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 
 	mf->field	= V4L2_FIELD_NONE;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
-- 
2.7.4

