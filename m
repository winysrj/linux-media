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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E082C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DD820883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5G56hB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfAIAQ7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:59 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35024 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfAIAQJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:09 -0500
Received: by mail-pl1-f195.google.com with SMTP id p8so2688572plo.2;
        Tue, 08 Jan 2019 16:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+gWCj7jpvSU77lLytUOhuIltx3JiK4hVtYn+wZJtUfw=;
        b=q5G56hB3/UtigqYXXaajaktbTSpAcYphGCWMngYN20YMS2sLaoqJ0btQpqQQtyernT
         wZLxt+Gn/LBlidqla7kym+q5m5v3v4Jv/WkExVsRYmSchHWQcZUDIne/p6aSuDgGho9g
         x0OyiMQhTagByfTgml8soqLgbEP0zYUQXNAzuagZgJtSz4VSrsOW1Q4KmuKgaNXhhhVO
         OrY9WmxLy8KMMnS1ZwvfA8GIdJYSFIYvwyyRckAp9n/Iu2NNpzfI40P7z1W6oYg661gN
         gi0EvIBN+EYTb23sjMzGh2t/VECoAT1J2HObhvJD7tHEz1qBHI3axPTnfYlwwvNfq3Pc
         Y1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+gWCj7jpvSU77lLytUOhuIltx3JiK4hVtYn+wZJtUfw=;
        b=q7Vc/JJvPQ3d/DZOVPyvWl3/wNv03dW5w01qA19hcsh7NAp4U1aYZEfHsQ1zPkaXcZ
         dZTxT+BxJrqp+Qt/0/ReFzCEz6QtD11Z6ICyCFDqSFmmxYj/YHMzHTALI8YqdbbsWluw
         aKbV1W1RwMiZqlnwNVvQTc5A7FjhbBl3KiF6w+a1dlGzavQEOLuA0Xpo4WxbMkGsqyyF
         07cRsGDRlwjkdMdMgsUBDa62KiegGl/jbhnOYZCqBTMFhDXxyyDf3OxjDlBgKmfUa6Ys
         qUcPw5LQXYAc5q/hFUFqwwb85Yt3o22V8s35YQlH4HDIOpuj8CgYvGbx4+klvTLH3+Mp
         +j2A==
X-Gm-Message-State: AJcUukdRbN/m2UBC3IrUjtkeWejfIw8IulzucMeprHTMTY5gmHxGV6It
        0lVBg4gEK3wfV4XKc9EefWU8mq5A
X-Google-Smtp-Source: ALg8bN7vwSQNPhHu8DLr+fcN9skgUteAg2/eBG1ARIAKhAYPSGytmUXbrMam4h/VdhQICMXin4nvcw==
X-Received: by 2002:a17:902:7201:: with SMTP id ba1mr3845000plb.105.1546992968556;
        Tue, 08 Jan 2019 16:16:08 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:07 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 06/12] media: imx-csi: Double crop height for alternate fields at sink
Date:   Tue,  8 Jan 2019 16:15:45 -0800
Message-Id: <20190109001551.16113-7-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
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
index b276672cae1d..c40c3262038e 100644
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

