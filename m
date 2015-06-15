Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50508 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbbFOLeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/14] tw9910: init priv->scale and update standard
Date: Mon, 15 Jun 2015 13:33:31 +0200
Message-Id: <1434368021-7467-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the standard changes the VACTIVE and VDELAY values need to be updated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/tw9910.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index df66417..e939c24 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -510,13 +510,39 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
+	const unsigned hact = 720;
+	const unsigned hdelay = 15;
+	unsigned vact;
+	unsigned vdelay;
+	int ret;
 
 	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
 		return -EINVAL;
 
 	priv->norm = norm;
+	if (norm & V4L2_STD_525_60) {
+		vact = 240;
+		vdelay = 18;
+		ret = tw9910_mask_set(client, VVBI, 0x10, 0x10);
+	} else {
+		vact = 288;
+		vdelay = 24;
+		ret = tw9910_mask_set(client, VVBI, 0x10, 0x00);
+	}
+	if (!ret)
+		ret = i2c_smbus_write_byte_data(client, CROP_HI,
+			((vdelay >> 2) & 0xc0) |
+			((vact >> 4) & 0x30) |
+			((hdelay >> 6) & 0x0c) |
+			((hact >> 8) & 0x03));
+	if (!ret)
+		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
+			vdelay & 0xff);
+	if (!ret)
+		ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
+			vact & 0xff);
 
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -820,6 +846,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 		 "tw9910 Product ID %0x:%0x\n", id, priv->revision);
 
 	priv->norm = V4L2_STD_NTSC;
+	priv->scale = &tw9910_ntsc_scales[0];
 
 done:
 	tw9910_s_power(&priv->subdev, 0);
-- 
2.1.4

