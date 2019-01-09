Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE04C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4075620883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BW4/CS5S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfAIAQt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41168 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfAIAQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id u6so2667677plm.8;
        Tue, 08 Jan 2019 16:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLI7uMbQh0mfAM6tmfvzNlOQxx3p7QRVTPoOFLrTj/Q=;
        b=BW4/CS5SMWnum8fj2Lkef1VkW9NpogzYVGWSSJOpZBX/PNxrGRvEe1CDZ09VBcE7+c
         ozoNZUlYd1SdtVh/bS+D2CZ3rEQ1XBMtIqy/b2YEPECIFjcnZurzpV2e8ertNtjWp/b0
         GB78ez0HfVbHUz2zJs4NNT9ekfsRN9ZI7UR/mlrB6FNu5RihnRj8q2CfOsy35fKGRtu5
         aSGewXrHuPudu0JffBvc4O1C8WHGOQ7jqPnHBhItcQakj6DvD90yG/CepXDyvm/faioG
         CsTCIdrGEu0gDif2L2+lfBIZISGh6VohNlnFrG7LjZrSzZ7ZpyVuYkouJ7BLwBErpFB0
         i5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLI7uMbQh0mfAM6tmfvzNlOQxx3p7QRVTPoOFLrTj/Q=;
        b=jRpXH6G3bK0K4sbHCZqGc8T6JQ/eYaPcsfZlj/E5/kL0PO7JgpQ9+drNioMP5MnWWw
         p4PL91aYZz76p5BlBE+tyuULCFI0oW4S8vv/nH8MFf5VY40BYEY5bvnyeFwprrZxpYVX
         JnPHT91aU1FNawfeSnaoNG4Fww4IFJjKJhKv8kFt4ElqtVX1bi8uK+EGHDq9orH0sHM9
         NK99+ZYqhuztlxH5OPf8uHB+sDL3AvPF1Knt7n8RLfmFAjm+1XqABFemx0QxZta6ZBMB
         HhYx4Ny0KiWiyCr3CnW5Tlp/uuSCZ8a9ozQrzS+fV7M/84qEZOxHbLCT7k2vbERskrvv
         ThXA==
X-Gm-Message-State: AJcUukfAjFo+D3tTETkHzI8UBXuXC+OpYiwl9si79oX/JXcQuh5eu89a
        s/Obata9riix2f9uYBvyD9R3VshS
X-Google-Smtp-Source: ALg8bN7TM254ECU1/mBZoPbFC/w0JXrSmvchvX8w+qCSn8gYi5eojgEYdCYv0O4b5RxLJCUha0sO4w==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr3746107plp.247.1546992969917;
        Tue, 08 Jan 2019 16:16:09 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:09 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 07/12] media: imx: interweave and odd-chroma-row skip are incompatible
Date:   Tue,  8 Jan 2019 16:15:46 -0800
Message-Id: <20190109001551.16113-8-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
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
index c40c3262038e..dbc5a92ec073 100644
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

