Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34005 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752342AbdGVVVw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 17:21:52 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: imx: prpencvf: enable double write reduction
Date: Sat, 22 Jul 2017 14:21:41 -0700
Message-Id: <1500758501-5394-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the write channels with 4:2:0 subsampled YUV formats, avoid chroma
overdraw by only writing chroma for even lines. Reduces necessary write
memory bandwidth by at least 25% (more with rotation enabled).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index ed363fe..42c5045 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -374,6 +374,17 @@ static int prp_setup_channel(struct prp_priv *priv,
 	image.phys0 = addr0;
 	image.phys1 = addr1;
 
+	if (channel == priv->out_ch || channel == priv->rot_out_ch) {
+		switch (image.pix.pixelformat) {
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_YVU420:
+		case V4L2_PIX_FMT_NV12:
+			/* Skip writing U and V components to odd rows */
+			ipu_cpmem_skip_odd_chroma_rows(channel);
+			break;
+		}
+	}
+
 	ret = ipu_cpmem_set_image(channel, &image);
 	if (ret)
 		return ret;
-- 
2.7.4
