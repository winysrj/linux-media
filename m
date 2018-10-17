Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34398 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJQHxj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 03:53:39 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 07/12] media: imx: interweave and odd-chroma-row skip are incompatible
Date: Tue, 16 Oct 2018 17:00:22 -0700
Message-Id: <20181017000027.23696-8-slongerbeam@gmail.com>
In-Reply-To: <20181017000027.23696-1-slongerbeam@gmail.com>
References: <20181017000027.23696-1-slongerbeam@gmail.com>
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
index d5b0f8a66750..7e648fc9626a 100644
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
