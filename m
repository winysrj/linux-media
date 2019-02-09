Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE16C169C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C961217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnB8OTRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfBIBr7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:47:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38694 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfBIBr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 20:47:59 -0500
Received: by mail-pg1-f195.google.com with SMTP id g189so2347376pgc.5;
        Fri, 08 Feb 2019 17:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LNLh7fiEUgpdrV87cZRzOzgatsSJFrmOUrkiGIqiIBs=;
        b=TnB8OTRpB1FkqnKuYsYoMx0Lno9toRpZiFzo4v3777fuUfPLIX7wPx/SmpG9/Ohzyz
         pA+djEy5+UVbjY9K3YvSC//zNjFf0LP/OdOFnrbO2ArQAq3c2Hu0sJUrph8HAcv/7K5A
         j0qaOoecXnZdrZitbq0ATV4Q2bOcZJFYbEUxfAt7rVyjULLOmhE1X5ZtegsVl1ddbG+o
         2k/TwLJ589ccKBhAKcb7AzVseR7K7sMlbeuO83J11Lr7nC6HsCsit9lesTXGfdrNIlN9
         axuNhQ3WSB9F06kzw4/e6nq/a2rFvk3a5zEy9UjcvWjP6aLx46BlV64D2RQx8uXYdmOi
         WeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LNLh7fiEUgpdrV87cZRzOzgatsSJFrmOUrkiGIqiIBs=;
        b=rZ7L0lRpoOQxQVL6vq6/4FvYFwXn64vJNwa4kcQbDicaMsBO4zSRnBwJG+/lx4o7yG
         yLU8ksAnbG3MuKr+r2XIGCP5YogmsD+bFQzHEk6vF2eTxAFOB2tgIhJOTVEcpgXUl4gz
         zM3IR3uVfJo7BfRnlsiRQRK/RIuqUp4L4GOQXI7TJtM6S+ZvvRJBy81XeGCw4iJZcpus
         qJTHQv0Z/tWGqNLycQy1MWFfkCYNrAr/WuhwvxRY4/Lzx1ajpKxbU4S1y7ZCYXTBXqwN
         2r8eu40mkw2kR7BjOrMSiZTErEUaK9db2MEuZuyqhLKXzmjcfx1fotD9tYwEd8WFnMay
         oOSw==
X-Gm-Message-State: AHQUAuZFrgxrck2HcYPhBqbLq9NqnVe2gWJIFrJanOB9rbiLTUChzLcN
        e6vyrWBkxrd/T/tI+04rLNlNrb7+
X-Google-Smtp-Source: AHgI3IYfH59fQQgl0GUSasdyDGQClQsutpvoNHOhBE5D4GX+ybxW12af5zlBsOKpn490RKwie2XNFA==
X-Received: by 2002:aa7:8101:: with SMTP id b1mr19035568pfi.148.1549676877857;
        Fri, 08 Feb 2019 17:47:57 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id p67sm4305393pfg.44.2019.02.08.17.47.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 17:47:57 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
Date:   Fri,  8 Feb 2019 17:47:45 -0800
Message-Id: <20190209014748.10427-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209014748.10427-1-slongerbeam@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ycbcr2rgb and inverse rgb2ycbcr matrices define the BT.601 encoding
coefficients, so rename them to indicate that. And add some comments
to make clear these are BT.601 coefficients encoding between YUV limited
range and RGB full range. The ic_csc_rgb2rgb matrix is just an identity
matrix, so rename to ic_csc_identity. No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v2:
- rename ic_csc_rgb2rgb matrix to ic_csc_identity.
---
 drivers/gpu/ipu-v3/ipu-ic.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 594c3cbc8291..3ef61f0b509b 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -183,11 +183,13 @@ struct ic_csc_params {
 };
 
 /*
+ * BT.601 encoding from RGB full range to YUV limited range:
+ *
  * Y = R *  .299 + G *  .587 + B *  .114;
  * U = R * -.169 + G * -.332 + B *  .500 + 128.;
  * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
  */
-static const struct ic_csc_params ic_csc_rgb2ycbcr = {
+static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
 	.coeff = {
 		{ 77, 150, 29 },
 		{ 469, 427, 128 },
@@ -197,8 +199,11 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr = {
 	.scale = 1,
 };
 
-/* transparent RGB->RGB matrix for graphics combining */
-static const struct ic_csc_params ic_csc_rgb2rgb = {
+/*
+ * identity matrix, used for transparent RGB->RGB graphics
+ * combining.
+ */
+static const struct ic_csc_params ic_csc_identity = {
 	.coeff = {
 		{ 128, 0, 0 },
 		{ 0, 128, 0 },
@@ -208,11 +213,13 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
 };
 
 /*
+ * Inverse BT.601 encoding from YUV limited range to RGB full range:
+ *
  * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
  * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
  * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
  */
-static const struct ic_csc_params ic_csc_ycbcr2rgb = {
+static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
 	.coeff = {
 		{ 149, 0, 204 },
 		{ 149, 462, 408 },
@@ -238,11 +245,11 @@ static int init_csc(struct ipu_ic *ic,
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
 	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_ycbcr2rgb;
+		params = &ic_csc_ycbcr2rgb_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-		params = &ic_csc_rgb2ycbcr;
+		params = &ic_csc_rgb2ycbcr_bt601;
 	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_rgb2rgb;
+		params = &ic_csc_identity;
 	else {
 		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
 		return -EINVAL;
-- 
2.17.1

