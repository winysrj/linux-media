Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33853 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387714AbeHAVAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:00:06 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 09/14] media: imx: interweave and odd-chroma-row skip are incompatible
Date: Wed,  1 Aug 2018 12:12:22 -0700
Message-Id: <1533150747-30677-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
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
index 1a03d4c..cf76b04 100644
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
index 3a09a9b..1155d50d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -454,8 +454,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
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
2.7.4
