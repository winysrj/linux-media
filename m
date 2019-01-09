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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1BCC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456A22173B
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ln0vlqgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfAISah (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:37 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41804 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbfAISah (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id b7so4044219pfi.8;
        Wed, 09 Jan 2019 10:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VLRlyyf684+Sy+VEdPL3zWCq7VMbjh74HM7d3CHGuyk=;
        b=Ln0vlqgBmAye0sWe7KkDpi4O2nR8gU3r+bjvxxiGbsrry7JvwJU4yYf1VZf5gx8Vjc
         T0x7pT7DjeN2FXcU3qcpC39/xSnWT1LXPUUDpq4fsvOAHtsvg41eVqxUT0a4eUN+ysDT
         RkZu4pTIcvN3ZUhAng/xbBv7G1pKKNzMzLHqAILqTbbHXDREXYS2Ps1RpaVjMdT+xq1s
         jgkhX12yn3Sqa0L2vjLXuKoqHMUE/yIEKFmwh3UIpbd4eHb/As6nIFSSWMLfsHE9K5r3
         2mHCCCQKX5vnUqNSjoaSc0gfJBzUA3lYmE07lA8PuPg0OidBmyoOA0V8YaAxblBNh8U/
         K/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLRlyyf684+Sy+VEdPL3zWCq7VMbjh74HM7d3CHGuyk=;
        b=t2aIl7OOgPbIQntfMUXa6CHqBbQ0ZcUX4c4hLK83/BjL4aqy73LK2EExF2Yrg9U7F7
         1CDYX8fc9YincDZVQ6ipspbQfXS4y5dd2rqSPzS05mTzhTZQX4uK2vEI1xlk6eRs6baS
         vRaLcoHH3otgrz7bwLzf1c9/hUH/90dW2/l1bEgwCVRoAFEPyxMf2roiMx2zn1qXyyNa
         xL3iLiU39LjsFlRhlndI1iYk0jcsJ+J19h14ZUvv2HEiCTh5bLeHe2mZzDXmGCUeMol5
         yB5Pm++NaOXF0WJDfNnXKH2VTVi9pt3LXINMqK8x/53a8owZtSFL8HpT8e9OVFgRZdaG
         vhdQ==
X-Gm-Message-State: AJcUukcrm/vTZBfakP+paWCmM0l3B56p2siL30EXnLsZ40u1RzBl0PaS
        arXcrPgS4b626MXaA2nF3pLBim7m
X-Google-Smtp-Source: ALg8bN5QI2x3wMNhqcrigoZbWemdDTgcKsFrAcECYj25M3VxSh3N6xZn1wXqILMFEIg70OFr38AV2g==
X-Received: by 2002:a63:6c48:: with SMTP id h69mr6143222pgc.139.1547058636032;
        Wed, 09 Jan 2019 10:30:36 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:35 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 06/11] media: imx: interweave and odd-chroma-row skip are incompatible
Date:   Wed,  9 Jan 2019 10:30:09 -0800
Message-Id: <20190109183014.20466-7-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
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

