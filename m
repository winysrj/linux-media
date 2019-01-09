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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6B7C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB8120665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7ej+k+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfAISad (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34754 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfAISac (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id j10so3678666pga.1;
        Wed, 09 Jan 2019 10:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4N7ojczW0kjHmDJMWNYmDjBpUir6wWRrzDKNFy4GszY=;
        b=I7ej+k+dFMuBnjZYmBkcISKCwv0/tA9IA/cIcx7zCrMr7gRrCeVvfeTd8x3mCp3mqe
         mS8nfKn0j3CcgPQPL+mfAD2JUb3s7wsdC35xvQbGLDTPJUN/dcL9SI8/FfzXZKkGXxU5
         TjQ1kteZJD6cIBUpBkv+b4QmtyFSJkDSo8DnfHT2c0mH8Juj5J6Dc6afkWc4AY1exlWB
         tCeHCaHSH5ecSZOHMKPceaBNcu7EB6vZ/hokxUN7OiV7FdeCIQxEgpSQHfgj81ig9VtD
         N7I3uFqig9zV0pnxjZ/+BeVEKfVirJScg6IGGMjh7mCGptfNtKg7NhtsdtTVwcyplFt6
         RBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4N7ojczW0kjHmDJMWNYmDjBpUir6wWRrzDKNFy4GszY=;
        b=CWD6VIFFFJcLbcxLZOdLCVb5vXxeA7sLaRgXO5M/oFLoY4TLZZT67jZLy2CUNOB7qb
         s0mXDlyKjC/6HQNHIgsywVP81NRuhzu0Ep2WW0DdXaRogQV78yFlaDZ4kYIjb9mGZO05
         0VH2vlFVUiv4abArkhl9qj1DOI6+QcYBZ5aeDcXFp96FUc/XM+9elnWvWGAu1NtGB/63
         CsphGIya2/DsqpDRL1UsPjIls/59Uy1KtVeCBFXUAbErQS5tfFCZ2e7h3FRrIOpis4DX
         4yITRGyfAby3K2uR8G102B7wg+Kj9oyG8+k9qvwSPa7NqpOO5Mn+C88dhBMzfUFyKE6W
         QASw==
X-Gm-Message-State: AJcUukdYKXg7Cw6qb/di+AxTIQEvJoJoEiwtdytgw59jLMKJq2XRrDHh
        zofKnTvgaIpRJkeoeInyA0aetFA/
X-Google-Smtp-Source: ALg8bN7g2lzEOGzHo4p7WEN6PrnndcZEIDpUQje3h4y70I0aNXlhxaFYzrXspUp1/yDVsTEKcXKHIw==
X-Received: by 2002:a62:2702:: with SMTP id n2mr7196147pfn.29.1547058631145;
        Wed, 09 Jan 2019 10:30:31 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:30 -0800 (PST)
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
Subject: [PATCH v8 03/11] gpu: ipu-v3: Add planar support to interlaced scan
Date:   Wed,  9 Jan 2019 10:30:06 -0800
Message-Id: <20190109183014.20466-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
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

