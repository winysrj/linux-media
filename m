Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B018C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF358214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNtX8hA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfAISRB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44644 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727712AbfAISRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:17:00 -0500
Received: by mail-pl1-f195.google.com with SMTP id e11so3938318plt.11;
        Wed, 09 Jan 2019 10:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VLRlyyf684+Sy+VEdPL3zWCq7VMbjh74HM7d3CHGuyk=;
        b=VNtX8hA7i4uGN8swLTj5yfzjcrG695efAsUimK75yzGf79dc8Hce9UKm6SLqALK6+h
         WFfwEHsPQe/SwZCiT/firucPnDxEWmQZqAuaWWZH93mUdaIqZJAZxLDvoLZ4oiST1RDm
         nZWzuIMDzrzhn95FebB6J1ojp8MpvMZyH/Dkm5esuxH58l8s72cbQEqaXwXN3zD1G2ML
         IemgBynl694ElIvtTwWj/pPjuDlngPDCHk0rY/eFbXjIK8MRF7xMnMj621pR3dlEljl8
         VbT+TM+eGC+BTw8h5SoonhYnfvmuubQVmTZH1FmgLzJ9+mCAKCZ42yJyIXQlvtlkz1v/
         nOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLRlyyf684+Sy+VEdPL3zWCq7VMbjh74HM7d3CHGuyk=;
        b=SGPKXlb96mRt2Y5z/AtIoBADdAG3ktXwbfXgnLjuI+ZWWt+oOsqAZoauGOOQOhQ7QT
         zFzPKqIS4bbZNl/Mg2uAOagEGTbnahsWkoiQcypzqPcWLQ7bKddVpJ/99y2DtsumkEwL
         BvRYXOEW8uZrONBy40rivG+mtcK3uozDwoNmJEhIPgyAMS0ZaNcYhI4gaGMIOKQ5Un7S
         er9fmZC5KPN/NxKNnXaSaDxJ7hAM1wRcsTuZPBLH9tyeGjicgph+M0BBGmypZ0rThCP0
         bXEb/6GFjhvgLdDkBlMGciMT3xJQ7Q/jFxkGDu4KZV/9pVZE5HWGbvrTrw4NCH5jeL8R
         8jqQ==
X-Gm-Message-State: AJcUukcDfVRC7RcR7X/vVW0dLP0FDmExz+c5eH+i8kGXOlrPMdxeEURo
        4IIUJ/X7lEX59bM/TGj3uEzsCjG1
X-Google-Smtp-Source: ALg8bN4jY8X7MdotqgdICjCJ+Hca3YuOZH1EyKP877I4DKkd1FPdp0niFcNr71ObIrOzR1d+AOrJ1Q==
X-Received: by 2002:a17:902:6b83:: with SMTP id p3mr7032374plk.118.1547057819292;
        Wed, 09 Jan 2019 10:16:59 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:16:58 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 06/11] media: imx: interweave and odd-chroma-row skip are incompatible
Date:   Wed,  9 Jan 2019 10:16:36 -0800
Message-Id: <20190109181642.19378-7-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If IDMAC interweaving is enabled in a write channel, the channel must
write the odd chroma rows for 4:2:0 formats. Skipping writing the odd
chroma rows produces corrupted captured 4:2:0 images when interweave
is enabled.

Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 9 +++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 1a03d4c9d7b8..cf76b0432371 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -391,12 +391,17 @@ static int prp_setup_channel(struct prp_priv *priv,
 	image.phys0 = addr0;
 	image.phys1 = addr1;
 
-	if (channel == priv->out_ch || channel == priv->rot_out_ch) {
+	/*
+	 * Skip writing U and V components to odd rows in the output
+	 * channels for planar 4:2:0 (but not when enabling IDMAC
+	 * interweaving, they are incompatible).
+	 */
+	if (!interweave && (channel == priv->out_ch ||
+			    channel == priv->rot_out_ch)) {
 		switch (image.pix.pixelformat) {
 		case V4L2_PIX_FMT_YUV420:
 		case V4L2_PIX_FMT_YVU420:
 		case V4L2_PIX_FMT_NV12:
-			/* Skip writing U and V components to odd rows */
 			ipu_cpmem_skip_odd_chroma_rows(channel);
 			break;
 		}
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 10945cbdbd71..604d0bd24389 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -457,8 +457,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 			     ((image.pix.width & 0x1f) ?
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
 		passthrough_bits = 16;
-		/* Skip writing U and V components to odd rows */
-		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
+		/*
+		 * Skip writing U and V components to odd rows (but not
+		 * when enabling IDMAC interweaving, they are incompatible).
+		 */
+		if (!interweave)
+			ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
-- 
2.17.1

