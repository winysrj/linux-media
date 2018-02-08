Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbeBHOsP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 09:48:15 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: imx: csi: fix enum_mbus_code for unknown mbus format codes
Date: Thu,  8 Feb 2018 15:47:49 +0100
Message-Id: <20180208144749.10558-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If no imx_media_pixfmt is found for a given mbus format code,
we shouldn't crash. Return -EINVAL for any index.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index eb7be5093a9d..89903f267d60 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1138,6 +1138,10 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 
 	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, code->which);
 	incc = imx_media_find_mbus_format(infmt->code, CS_SEL_ANY, true);
+	if (!incc) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	switch (code->pad) {
 	case CSI_SINK_PAD:
-- 
2.15.1
