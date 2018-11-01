Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:7084 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728361AbeKBIiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:18 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 25/30] adv748x: csi2: only allow formats on sink pads
Date: Fri,  2 Nov 2018 00:31:39 +0100
Message-Id: <20181101233144.31507-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
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
index 8a7cc713c7adfcc1..9f2c49221a8ddebc 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -163,6 +163,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
 	struct adv748x_state *state = tx->state;
 	struct v4l2_mbus_framefmt *mbusformat;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
@@ -186,6 +189,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mbusformat;
 	int ret = 0;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
-- 
2.19.1
