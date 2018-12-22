Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641A4C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3524D21A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyyoujA+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391084AbeLVRNe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:34 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42168 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeLVRNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:33 -0500
Received: by mail-pf1-f196.google.com with SMTP id 64so4044185pfr.9;
        Sat, 22 Dec 2018 09:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6TBqITmEv0kT2GhOzw5W1AUzDWZJgB6wkauSBHb8q0w=;
        b=LyyoujA+KCC8HtAHPSi7A90sHgrxZDlJXzneAu2VKQRNF8PBxVbeEQyLbKb8IcsacG
         GRmbqXLmMb8qcNLlO9phypDEdJQ+fy162I7LUl6Mv7tXdKNH5Ad75FKFIfh0Z2qK4H+E
         ThU5BXcicde+zUPIHshBXUCf/LLsXUQgQLPkRj9wE0SmtQ1b0EsVhy8/MPTDWwa6PQhe
         DckdZHTF6Q9XJnvLB6WQCMZ9QVla/rXJLtf5k3g9Nk85yGrj/O1B3DphQ4fjHucEd4Bs
         LDHZLJ1pLiJoS2CV8iZ/FuurkV1Z0lqmoY2iBA2csHct/y4bSKuLx/BlXdzyeRM3kDQM
         z59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6TBqITmEv0kT2GhOzw5W1AUzDWZJgB6wkauSBHb8q0w=;
        b=Y2FDMjrIEbJ9uU+XI8ji9Wjt072aKn034OFCl4ikuqNaQKTAuVYWYUCNCUKYSAVdbv
         OQ8p5gx94Egh34VrWqSv9vnjWDzIdjFq/hzNGf/fVc64m61sBp4JxAh4IRfy3i6cj9Vn
         8zocYvdeL3Kmh8AwgBLDSWZKEDdLi6WgmsLtr2NW2DnA2t3dfKZqx/rouJTHZVXuxZ9b
         saYdS/zbgzumASHD+jtsOw0Y1D0ZFeYhMZRFKAx7tnl5B9FXvuz0wds/rwIpW01pfv9W
         qYDQmYwztL3OaZSRXye55dA12XuBG6A4a4yIEd8cEHWeTBSFqThpV0Bt8VlaH/27he/v
         rN/Q==
X-Gm-Message-State: AA+aEWaxIlyRMWJuvZds16WxDdmvkIg26dcRTM3RYPYdtGD4/SaP3BM1
        Lf2BtKQseKWs0i7N2Nesy2frRQDPLDc=
X-Google-Smtp-Source: AFSGD/UoWAmrkaySnrMqPOGmldbGRhmGwiVZhzg/EaCTUn0LgaaSWWuS9cAKzHfYAsOEe4L2m1GuTw==
X-Received: by 2002:a62:5301:: with SMTP id h1mr7086009pfb.17.1545498812034;
        Sat, 22 Dec 2018 09:13:32 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:31 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 12/12] media: mt9m001: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Sun, 23 Dec 2018 02:12:54 +0900
Message-Id: <1545498774-11754-13-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index f4afbc9..82b89d5 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -342,6 +342,9 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= mt9m001->fmt->code;
 	mf->colorspace	= mt9m001->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -402,6 +405,10 @@ static int mt9m001_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	mf->colorspace	= fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return mt9m001_s_fmt(sd, fmt, mf);
-- 
2.7.4

