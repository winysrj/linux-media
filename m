Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:6631 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbeKBIiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:19 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 26/30] adv748x: csi2: describe the multiplexed stream
Date: Fri,  2 Nov 2018 00:31:40 +0100
Message-Id: <20181101233144.31507-27-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
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
index 9f2c49221a8ddebc..d83ae8e5d802a3bd 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -222,9 +222,37 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
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
@@ -291,7 +319,8 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 		return 0;
 
 	/* Initialise the virtual channel */
-	adv748x_csi2_set_virtual_channel(tx, 0);
+	tx->vc = 0;
+	adv748x_csi2_set_virtual_channel(tx, tx->vc);
 
 	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
 			    MEDIA_ENT_F_VID_IF_BRIDGE,
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 39c2fdc3b41667d8..b24e5ea1fe0f8c8d 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -76,6 +76,7 @@ enum adv748x_csi2_pads {
 
 struct adv748x_csi2 {
 	struct adv748x_state *state;
+	unsigned int vc;
 	struct v4l2_mbus_framefmt format;
 	unsigned int page;
 	unsigned int port;
-- 
2.19.1
