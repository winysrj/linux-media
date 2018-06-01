Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37862 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbeFAAbJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:09 -0400
Received: by mail-pg0-f66.google.com with SMTP id a13-v6so10442230pgu.4
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:09 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 05/10] media: imx: interweave and odd-chroma-row skip are incompatible
Date: Thu, 31 May 2018 17:30:44 -0700
Message-Id: <1527813049-3231-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If IDMAC interweaving is enabled in a write channel, the channel must
write the odd chroma rows for 4:2:0 formats. Skipping writing the odd
chroma rows produces corrupted captured 4:2:0 images when interweave
is enabled.

Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 9 +++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 894db21..7e1e0c3 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -393,12 +393,17 @@ static int prp_setup_channel(struct prp_priv *priv,
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
index 2c77ef9..6a2a47c 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -436,8 +436,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
 		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
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
2.7.4
