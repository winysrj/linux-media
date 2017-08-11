Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39200 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbdHKJ51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:27 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 17/20] adv748x: implement get_frame_desc
Date: Fri, 11 Aug 2017 11:57:00 +0200
Message-Id: <20170811095703.6170-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index a77069fc1adc1eca..58a9d9105148c15b 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -225,9 +225,38 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
+				       struct v4l2_mbus_frame_desc *fd)
+{
+	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct adv748x_state *state = tx->state;
+	struct v4l2_mbus_framefmt *mbusformat;
+
+	if (pad != ADV748X_CSI2_SOURCE || fd == NULL)
+		return -EINVAL;
+
+	mbusformat = adv748x_csi2_get_pad_format(sd, NULL, ADV748X_CSI2_SINK,
+						 V4L2_SUBDEV_FORMAT_ACTIVE);
+	if (!mbusformat)
+		return -EINVAL;
+
+	mutex_lock(&state->mutex);
+	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_CSI2;
+	fd->entry[0].pixelcode = mbusformat->code;
+	fd->entry[0].csi2.channel = tx->vc;
+	fd->entry[0].csi2.datatype =
+		adv748x_csi2_code_to_datatype(fd->entry[0].pixelcode);
+	fd->entry[0].csi2.pad = ADV748X_CSI2_SINK;
+	fd->num_entries = 1;
+	mutex_unlock(&state->mutex);
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
2.13.3
