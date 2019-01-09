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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800A0C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4D9206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lyahv7FK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfAISQ4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:16:56 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35435 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfAISQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:16:56 -0500
Received: by mail-pg1-f196.google.com with SMTP id s198so3663373pgs.2;
        Wed, 09 Jan 2019 10:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4N7ojczW0kjHmDJMWNYmDjBpUir6wWRrzDKNFy4GszY=;
        b=Lyahv7FKoDdYwh7bib8JjifyGKFgDxWBbx7CE8z0sZ9ebOziV1IV3pFqDAjrUw01Ci
         aWj0uRrf5RaA7TPKkeBpSgzv4uoKF3zqt8DALAUej3uwC5qK6pwkVEHWmZpGafZk9i/p
         qnlCU0OMBKPXBosfJfIBfhjYVZUanhimNYWdepF8/b6VinuZUKj4p6JD9qC3QkVwZ0m9
         5lqywR0PVJlI+skU1Q0JAO616YV2BuIg35PFT+nXPcH5q1ll3Yjg8fQqqzX8S7t54oPV
         K2TRJRUvBz4UApnWqZeY1KvHqvd2a7oONXdZL0Mio53mmJfWQDQ8Tac7CUA0kGzCy24N
         7wOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4N7ojczW0kjHmDJMWNYmDjBpUir6wWRrzDKNFy4GszY=;
        b=TiXQ8AwpxWihcZ39mS/zIvxUZk023fWyF9n6uxP4/G91BRjLqAAzG3JbU0c9vCaiQ5
         t/OuJr+B3UcpR4TxXXQDxivAPtmBSdPiWfQwreG3PEgmbNmPqcyhhMtqUqWp8SDkUQBv
         TsrHGWG1l2dsoWjnWnmj0n/gD+eAMzDDDsf39Wg+JrcIy/WoFyv0ExowWa4iWL21THkG
         CEa2pHWKh91Emovf8b00np0Yqwx9hdOQtt9HptvU5tJ0CYBr/j6tDAdZ71ab/3q0pBrP
         DTInGR8WEXxXKgMqJCibPkH8voEVyZjMYo6CF2UeBPlgDVTM5LX+nuylvOzx4mF2YNg/
         lSTA==
X-Gm-Message-State: AJcUukd/xybmj46B4lXkwiXUrA9QlDp9LNuaqr+UjZOaajGBRt/yJ6hM
        5c5xZp+7qwPej+ZFT6PHDczewhJf
X-Google-Smtp-Source: ALg8bN4zyfPen9WA9SHmkQaDZApgW9wCC+VdYU6dNO+I+cSKQYnXS8k5Ng8f6lt1lyR5JOljrRBgWQ==
X-Received: by 2002:a63:1408:: with SMTP id u8mr6402757pgl.271.1547057814345;
        Wed, 09 Jan 2019 10:16:54 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:16:53 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH v7 03/11] gpu: ipu-v3: Add planar support to interlaced scan
Date:   Wed,  9 Jan 2019 10:16:33 -0800
Message-Id: <20190109181642.19378-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

To support interlaced scan with planar formats, cpmem SLUV must
be programmed with the correct chroma line stride. For full and
partial planar 4:2:2 (YUV422P, NV16), chroma line stride must
be doubled. For full and partial planar 4:2:0 (YUV420, YVU420, NV12),
chroma line stride must _not_ be doubled, since a single chroma line
is shared by two luma lines.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c              | 26 +++++++++++++++++++--
 drivers/staging/media/imx/imx-ic-prpencvf.c |  3 ++-
 drivers/staging/media/imx/imx-media-csi.c   |  3 ++-
 include/video/imx-ipu-v3.h                  |  3 ++-
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 163fadb8a33a..d047a6867c59 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -277,9 +277,10 @@ void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off)
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
 
-void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
+void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride,
+			       u32 pixelformat)
 {
-	u32 ilo, sly;
+	u32 ilo, sly, sluv;
 
 	if (stride < 0) {
 		stride = -stride;
@@ -290,9 +291,30 @@ void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
 
 	sly = (stride * 2) - 1;
 
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		sluv = stride / 2 - 1;
+		break;
+	case V4L2_PIX_FMT_NV12:
+		sluv = stride - 1;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		sluv = stride - 1;
+		break;
+	case V4L2_PIX_FMT_NV16:
+		sluv = stride * 2 - 1;
+		break;
+	default:
+		sluv = 0;
+		break;
+	}
+
 	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
 	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
 	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, sly);
+	if (sluv)
+		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, sluv);
 };
 EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
 
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 28f41caba05d..af7224846bd5 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -412,7 +412,8 @@ static int prp_setup_channel(struct prp_priv *priv,
 	if (image.pix.field == V4L2_FIELD_NONE &&
 	    V4L2_FIELD_HAS_BOTH(infmt->field) &&
 	    channel == priv->out_ch)
-		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline);
+		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline,
+					  image.pix.pixelformat);
 
 	ret = ipu_ic_task_idma_init(priv->ic, channel,
 				    image.pix.width, image.pix.height,
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index c2a8d9cd31b7..da4808348845 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -512,7 +512,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	if (image.pix.field == V4L2_FIELD_NONE &&
 	    V4L2_FIELD_HAS_BOTH(infmt->field))
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
-					  image.pix.bytesperline);
+					  image.pix.bytesperline,
+					  image.pix.pixelformat);
 
 	ipu_idmac_set_double_buffer(priv->idmac_ch, true);
 
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index bbc8481f567d..c887f4bee5f8 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -258,7 +258,8 @@ void ipu_cpmem_set_stride(struct ipuv3_channel *ch, int stride);
 void ipu_cpmem_set_high_priority(struct ipuv3_channel *ch);
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf);
 void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off);
-void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride);
+void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride,
+			       u32 pixelformat);
 void ipu_cpmem_set_axi_id(struct ipuv3_channel *ch, u32 id);
 int ipu_cpmem_get_burstsize(struct ipuv3_channel *ch);
 void ipu_cpmem_set_burstsize(struct ipuv3_channel *ch, int burstsize);
-- 
2.17.1

