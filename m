Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752848AbZFKHMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 03:12:38 -0400
Date: Thu, 11 Jun 2009 09:12:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: [PATCH 2/4] ov772x: implement a band-stop filter support
In-Reply-To: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
Message-ID: <Pine.LNX.4.64.0906101559010.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_BAND_STOP_FILTER control is used to switch the "Banding 
Filter" on OV772x cameras on and off and to set the minimum AEC value in 
BDBASE register. BDBASE default value is 0xff, which makes the use of the 
filter practically unnoticeable. Reducing BDBASE increases the effect, 
which may be interpreted as increasing the "filter strength." Setting 
strength to 0 switches the filter completely off by clearing bit 5 in 
COM8.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov772x.c |   52 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 1191597..4c550f9 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -403,8 +403,9 @@ struct ov772x_priv {
 	const struct ov772x_color_format *fmt;
 	const struct ov772x_win_size     *win;
 	int                               model;
-	unsigned int                      flag_vflip:1;
-	unsigned int                      flag_hflip:1;
+	unsigned short                    flag_vflip:1;
+	unsigned short                    flag_hflip:1;
+	unsigned short                    band_filter;	/* 256 - BDBASE, 0 if (!COM8[5]) */
 };
 
 #define ENDMARKER { 0xff, 0xff }
@@ -569,6 +570,15 @@ static const struct v4l2_queryctrl ov772x_controls[] = {
 		.step		= 1,
 		.default_value	= 0,
 	},
+	{
+		.id		= V4L2_CID_BAND_STOP_FILTER,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Band-stop filter",
+		.minimum	= 0,
+		.maximum	= 256,
+		.step		= 1,
+		.default_value	= 0,
+	},
 };
 
 
@@ -674,6 +684,9 @@ static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_HFLIP:
 		ctrl->value = priv->flag_hflip;
 		break;
+	case V4L2_CID_BAND_STOP_FILTER:
+		ctrl->value = priv->band_filter;
+		break;
 	}
 	return 0;
 }
@@ -700,6 +713,29 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			val ^= HFLIP_IMG;
 		ret = ov772x_mask_set(client, COM3, HFLIP_IMG, val);
 		break;
+	case V4L2_CID_BAND_STOP_FILTER:
+		if ((unsigned)ctrl->value > 256)
+			ctrl->value = 256;
+		if (ctrl->value == priv->band_filter)
+			break;
+		if (!ctrl->value) {
+			/* Switch the filter off, it is on now */
+			ret = ov772x_mask_set(client, BDBASE, 0xff, 0xff);
+			if (!ret)
+				ret = ov772x_mask_set(client, COM8,
+						      BNDF_ON_OFF, 0);
+		} else {
+			/* Switch the filter on, set AEC low limit */
+			val = 256 - ctrl->value;
+			ret = ov772x_mask_set(client, COM8,
+					      BNDF_ON_OFF, BNDF_ON_OFF);
+			if (!ret)
+				ret = ov772x_mask_set(client, BDBASE,
+						      0xff, val);
+		}
+		if (!ret)
+			priv->band_filter = ctrl->value;
+		break;
 	}
 
 	return ret;
@@ -893,6 +929,18 @@ static int ov772x_set_params(struct i2c_client *client,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
+	/*
+	 * set COM8
+	 */
+	if (priv->band_filter) {
+		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
+		if (!ret)
+			ret = ov772x_mask_set(client, BDBASE,
+					      0xff, 256 - priv->band_filter);
+		if (ret < 0)
+			goto ov772x_set_fmt_error;
+	}
+
 	return ret;
 
 ov772x_set_fmt_error:
-- 
1.6.2.4

