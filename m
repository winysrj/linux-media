Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44177 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbcAGMr2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:28 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2 06/10] [media] tvp5150: Add g_mbus_config subdev operation support
Date: Thu,  7 Jan 2016 09:46:46 -0300
Message-Id: <1452170810-32346-7-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch adds the .g_mbus_config subdev operation to the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

Changes in v2: None

 drivers/media/i2c/tvp5150.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index fb7a4ddff1fe..105bd1c6b17f 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -936,6 +936,16 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
+static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_config *cfg)
+{
+	cfg->type = V4L2_MBUS_BT656;
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
+		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;
+
+	return 0;
+}
+
  /****************************************************************************
 			V4L2 subdev pad ops
  ****************************************************************************/
@@ -1114,6 +1124,7 @@ static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
 	.cropcap = tvp5150_cropcap,
+	.g_mbus_config = tvp5150_g_mbus_config,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
-- 
2.4.3

