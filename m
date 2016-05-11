Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33930 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbcEKODf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:03:35 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v4 6/8] media: rcar-vin: initialize EDID data
Date: Wed, 11 May 2016 16:02:54 +0200
Message-Id: <1462975376-491-7-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initializes the decoder subdevice with a fixed EDID blob.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 46 +++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..5bb3c3b 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -765,6 +765,41 @@ static void rvin_notify(struct v4l2_subdev *sd,
 	}
 }
 
+static u8 edid[256] = {
+	0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,
+	0x48, 0xAE, 0x9C, 0x27, 0x00, 0x00, 0x00, 0x00,
+	0x19, 0x12, 0x01, 0x03, 0x80, 0x00, 0x00, 0x78,
+	0x0E, 0x00, 0xB2, 0xA0, 0x57, 0x49, 0x9B, 0x26,
+	0x10, 0x48, 0x4F, 0x2F, 0xCF, 0x00, 0x31, 0x59,
+	0x45, 0x59, 0x61, 0x59, 0x81, 0x99, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x02, 0x3A,
+	0x80, 0x18, 0x71, 0x38, 0x2D, 0x40, 0x58, 0x2C,
+	0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1E,
+	0x00, 0x00, 0x00, 0xFD, 0x00, 0x31, 0x55, 0x18,
+	0x5E, 0x11, 0x00, 0x0A, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xFC, 0x00, 0x43,
+	0x20, 0x39, 0x30, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
+	0x0A, 0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x10,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x68,
+	0x02, 0x03, 0x1a, 0xc0, 0x48, 0xa2, 0x10, 0x04,
+	0x02, 0x01, 0x21, 0x14, 0x13, 0x23, 0x09, 0x07,
+	0x07, 0x65, 0x03, 0x0c, 0x00, 0x10, 0x00, 0xe2,
+	0x00, 0x2a, 0x01, 0x1d, 0x00, 0x80, 0x51, 0xd0,
+	0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x1e, 0x8c, 0x0a, 0xd0, 0x8a,
+	0x20, 0xe0, 0x2d, 0x10, 0x10, 0x3e, 0x96, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd7
+};
+
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct v4l2_subdev_format fmt = {
@@ -870,5 +905,16 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	v4l2_info(&vin->v4l2_dev, "Device registered as %s\n",
 		  video_device_node_name(&vin->vdev));
 
+	{
+		struct v4l2_subdev_edid rvin_edid = {
+			.pad = 0,
+			.start_block = 0,
+			.blocks = 2,
+			.edid = edid,
+		};
+		v4l2_subdev_call(sd, pad, set_edid,
+				&rvin_edid);
+	}
+
 	return ret;
 }
-- 
2.7.4

