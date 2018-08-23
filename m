Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12503 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730908AbeHWQ6D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:58:03 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 25/30] adv748x: csi2: only allow formats on sink pads
Date: Thu, 23 Aug 2018 15:25:39 +0200
Message-Id: <20180823132544.521-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once the CSI-2 subdevice of the ADV748X becomes aware of multiplexed
streams the format of the source pad is of no value as it carries
multiple streams. Prepare for this by explicitly denying setting a
format on anything but the sink pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index b759a7e22fbc98df..9f736da2ad60160f 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -172,6 +172,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
 	struct adv748x_state *state = tx->state;
 	struct v4l2_mbus_framefmt *mbusformat;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
@@ -195,6 +198,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mbusformat;
 	int ret = 0;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
-- 
2.18.0
