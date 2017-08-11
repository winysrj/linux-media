Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39204 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdHKJ52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:28 -0400
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
Subject: [PATCH 19/20] adv748x: only allow formats on sink pads
Date: Fri, 11 Aug 2017 11:57:02 +0200
Message-Id: <20170811095703.6170-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is now pad and stream aware, only allow to get/set format on
sink pads. Also record a different format for each sink pad since it's
no longer true that they are all the same

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 39d7877ff615fed1..9af33edfa7bed0a0 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -176,6 +176,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
 	struct adv748x_state *state = tx->state;
 	struct v4l2_mbus_framefmt *mbusformat;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
@@ -199,6 +202,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mbusformat;
 	int ret = 0;
 
+	if (sdformat->pad != ADV748X_CSI2_SINK)
+		return -EINVAL;
+
 	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
 						 sdformat->which);
 	if (!mbusformat)
-- 
2.13.3
