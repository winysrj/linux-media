Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:12528 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729541AbeHWQ6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:58:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 26/30] adv748x: csi2: describe the multiplexed stream
Date: Thu, 23 Aug 2018 15:25:40 +0200
Message-Id: <20180823132544.521-27-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv748x CSI-2 transmitter can only transmit one stream over the
CSI-2 link, however it can choose which virtual channel is used. This
choice effects the CSI-2 receiver and needs to be captured in the frame
descriptor information, solve this by implementing .get_frame_desc().

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 31 +++++++++++++++++++++++-
 drivers/media/i2c/adv748x/adv748x.h      |  1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 9f736da2ad60160f..5087b87a2c2e8f7d 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -231,9 +231,37 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
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
+	fd->entry->stream = tx->vc;
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
@@ -309,7 +337,8 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 	}
 
 	/* Initialise the virtual channel */
-	adv748x_csi2_set_virtual_channel(tx, 0);
+	tx->vc = 0;
+	adv748x_csi2_set_virtual_channel(tx, tx->vc);
 
 	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
 			    MEDIA_ENT_F_VID_IF_BRIDGE,
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 65f83741277e1365..90901b8a4e027ae5 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -80,6 +80,7 @@ enum adv748x_csi2_pads {
 
 struct adv748x_csi2 {
 	struct adv748x_state *state;
+	unsigned int vc;
 	struct v4l2_mbus_framefmt format;
 	unsigned int page;
 
-- 
2.18.0
