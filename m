Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8976C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A206D214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDIFoWUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfAISb0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:31:26 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38724 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfAISaf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id g189so3667949pgc.5;
        Wed, 09 Jan 2019 10:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SvPBX07XjgOGjqAl4kODKrCpf2pdSaymIbWsAOXzlto=;
        b=KDIFoWUONF4BlbZrrGTI5ZwLmaqWunmSYo+8LTdW2elyu2fQ4zJK2OvADyaDfceoac
         V2iRzonNtLof4HvxvqS7ljYEcJjOIhCJvX8uOo8z8QqQWg7My3Qszeo7S5JL25cQMXoI
         a2g+yc1KGjvGdSl5+q/Fkm7kJJQ4bS3+PtX0BKMz8qFIJeCODcUN7Fiwf5w//MNOCexC
         ecnmiONuX9a7HMSBbE9KdRZfFIDVUQfcxJUisgdaZqX9Yvre7ZZOj1bEfM6UXELAwe02
         8X+YHA4uzxIVY22B1QySb5m9IwmiRJ10XUNNvQLUE2w7lwUuUxNepnlQ86mtZFcRCtxG
         titw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SvPBX07XjgOGjqAl4kODKrCpf2pdSaymIbWsAOXzlto=;
        b=MFcSzLWNKl6OHmZMdYc0C5P3cbQv6GDfN/kQp0xonRjT2vUfygQAzJ5kwTwwccX+lZ
         kcTtfuamBKrIYlM//TJJ8LPKT+3V0xTRjQpQI7/8uLNVeh4ePxh1XtJmrnUqJ6iSXxNX
         Hrn7CYnK3J9X+xFwYsDLaTIhOaq4dLt1Rjfrcx5ILwqZosCO+DPjRnwDiV4zfXBNGbua
         7pqRkl/n3KtEtrpBbJHiR/CD9QgCOpq3335GczpVommUD332o0GrqBgOWsI6baZvQVrt
         XOygin5s0Gt8+qKPO6DzxtX4WXK2cv3O3gu+LlCY/uFMGvftBkEWS73vcDqUxgYVUxUY
         IfAw==
X-Gm-Message-State: AJcUukfEaiupL0X2wbPzOz92mPPcuVlmKhaSEGsAehedaFpR2yb4qnoo
        +PDhb4XxTi92Z31+Bd5IlrlKyO01
X-Google-Smtp-Source: ALg8bN5m9CbaoKVOSx8jAYQ8UwTNDz7BMjGiAIY6sZbLCqFkuIwSbO4HxeMcpApYddvMsahQpJm/ew==
X-Received: by 2002:a62:2f06:: with SMTP id v6mr7131370pfv.216.1547058634466;
        Wed, 09 Jan 2019 10:30:34 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:33 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 05/11] media: imx-csi: Double crop height for alternate fields at sink
Date:   Wed,  9 Jan 2019 10:30:08 -0800
Message-Id: <20190109183014.20466-6-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If the incoming sink field type is alternate, the reset crop height
and crop height bounds must be set to twice the incoming height,
because in alternate field mode, upstream will report only the
lines for a single field, and the CSI captures the whole frame.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index e3a4f39dbf73..10945cbdbd71 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1142,6 +1142,8 @@ static void csi_try_crop(struct csi_priv *priv,
 			 struct v4l2_mbus_framefmt *infmt,
 			 struct v4l2_fwnode_endpoint *upstream_ep)
 {
+	u32 in_height;
+
 	crop->width = min_t(__u32, infmt->width, crop->width);
 	if (crop->left + crop->width > infmt->width)
 		crop->left = infmt->width - crop->width;
@@ -1149,6 +1151,10 @@ static void csi_try_crop(struct csi_priv *priv,
 	crop->left &= ~0x3;
 	crop->width &= ~0x7;
 
+	in_height = infmt->height;
+	if (infmt->field == V4L2_FIELD_ALTERNATE)
+		in_height *= 2;
+
 	/*
 	 * FIXME: not sure why yet, but on interlaced bt.656,
 	 * changing the vertical cropping causes loss of vertical
@@ -1158,12 +1164,12 @@ static void csi_try_crop(struct csi_priv *priv,
 	if (upstream_ep->bus_type == V4L2_MBUS_BT656 &&
 	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
 	     infmt->field == V4L2_FIELD_ALTERNATE)) {
-		crop->height = infmt->height;
-		crop->top = (infmt->height == 480) ? 2 : 0;
+		crop->height = in_height;
+		crop->top = (in_height == 480) ? 2 : 0;
 	} else {
-		crop->height = min_t(__u32, infmt->height, crop->height);
-		if (crop->top + crop->height > infmt->height)
-			crop->top = infmt->height - crop->height;
+		crop->height = min_t(__u32, in_height, crop->height);
+		if (crop->top + crop->height > in_height)
+			crop->top = in_height - crop->height;
 	}
 }
 
@@ -1403,6 +1409,8 @@ static void csi_try_fmt(struct csi_priv *priv,
 		crop->top = 0;
 		crop->width = sdformat->format.width;
 		crop->height = sdformat->format.height;
+		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
+			crop->height *= 2;
 		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
 		compose->left = 0;
 		compose->top = 0;
@@ -1530,6 +1538,8 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 		sel->r.top = 0;
 		sel->r.width = infmt->width;
 		sel->r.height = infmt->height;
+		if (infmt->field == V4L2_FIELD_ALTERNATE)
+			sel->r.height *= 2;
 		break;
 	case V4L2_SEL_TGT_CROP:
 		sel->r = *crop;
-- 
2.17.1

