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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B18C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C74720859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2FSjtA/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfAISRo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41250 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbfAISQ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:16:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so3936127plm.8;
        Wed, 09 Jan 2019 10:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SvPBX07XjgOGjqAl4kODKrCpf2pdSaymIbWsAOXzlto=;
        b=P2FSjtA/AFIUJ0B7E2bHY8ZlHE06kJgOgbNdMaudi2t93LLFehOHn6hGIQ1TKVqMrZ
         6hk+Y3MPEJsFj3fID1Bykg0MjyUF9QCfMlLsRBMnrssULuFv8TkobyA2DTaczoXjTvIq
         u612sq2vDON6162mxNN5WBTgMwJ5uqCj43nkkXRvdy0Co5Yah5eBGtbUVv8CfPr8CZ74
         NJSvaIMP92D+vwTBQRhdZr3xDmS49miEy/HjF67Z1VglHpPXFIGoAsNI55dEI2/M3dGV
         xo9GPYpFuTYXEk/KzDoeqc+LIfx7TXM9XhYiVSfyzXGF/RWozTNPN30yr7NPOEEe18G+
         YKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SvPBX07XjgOGjqAl4kODKrCpf2pdSaymIbWsAOXzlto=;
        b=HD9Ow16CuaVFDGP30ozuqiDPGjGlMrKL6oz15ibs8y8miwIvcKkZKjmQBATspt6IFs
         PTHCEodY09qIBC4hNkYfwtEmax+D0iJeO8cyvKppdIC5TkdbvedoyWCC+PxMJEdY3pmc
         JsChdxnmYqopg1ur4nJfGFjnMH9gHZ7AfJpPo1JYhW0WWXpUlhta7vVEoW7mdhS/2gd9
         W+k/QqhKuqmlzpdqrPR8fupmxaWW8hpN2UDFuHT8GXvjvRO0UkP9/NJIqRtDtTl5XjDE
         Cb/g8eEkfZ3Z4JVWC1lm7ZKXIUvZ15GlLt0b1E0bwrIn2n2x+7nPR4Ue/h2ET/1RdHwX
         yCdA==
X-Gm-Message-State: AJcUukffcMS2+Yk4JWq9MsLKYsgmpK63qS5ouYQlBBGAacdKZtBQNKJ2
        u6nUtg4en26WA0es9I3I1pNMhHGa
X-Google-Smtp-Source: ALg8bN5RpekqRXGkMC78h9iYu2I/BwvLr7u6xQvL8c5whTr0h/chvEiQaDFPi374W/bA4g77awVTmg==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr7082951plo.162.1547057817818;
        Wed, 09 Jan 2019 10:16:57 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:16:56 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 05/11] media: imx-csi: Double crop height for alternate fields at sink
Date:   Wed,  9 Jan 2019 10:16:35 -0800
Message-Id: <20190109181642.19378-6-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
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

