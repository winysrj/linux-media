Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34324 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754272AbdLNTJW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:22 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 11/15] adv748x: csi2: implement get_frame_desc
Date: Thu, 14 Dec 2017 20:08:31 +0100
Message-Id: <20171214190835.7672-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide CSI-2 bus information for the multiplexed source pad using the
frame descriptor.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index a2a6d93077204731..a43b251d0bc67a43 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -225,9 +225,37 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
+				       struct v4l2_mbus_frame_desc *fd)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_mbus_framefmt *mbusformat;
+
+	memset(fd, 0, sizeof(*fd));
+
+	if (pad != ADV748X_CSI2_SOURCE)
+		return -EINVAL;
+
+	mbusformat = adv748x_csi2_get_pad_format(sd, NULL, ADV748X_CSI2_SINK,
+						 V4L2_SUBDEV_FORMAT_ACTIVE);
+	if (!mbusformat)
+		return -EINVAL;
+
+	fd->entry->stream = 0;
+	fd->entry->bus.csi2.channel = tx->vc;
+	fd->entry->bus.csi2.data_type =
+		adv748x_csi2_code_to_datatype(mbusformat->code);
+
+	fd->type = V4L2_MBUS_FRAME_DESC_TYPE_CSI2;
+	fd->num_entries = 1;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
 	.get_fmt = adv748x_csi2_get_format,
 	.set_fmt = adv748x_csi2_set_format,
+	.get_frame_desc = adv748x_csi2_get_frame_desc,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.15.1
