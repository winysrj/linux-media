Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3LNQQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 11:16:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v2 2/7] v4l: add device type for Software Defined Radio
Date: Sat, 14 Dec 2013 18:15:24 +0200
Message-Id: <1387037729-1977-3-git-send-email-crope@iki.fi>
In-Reply-To: <1387037729-1977-1-git-send-email-crope@iki.fi>
References: <1387037729-1977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new V4L device type VFL_TYPE_SDR for Software Defined Radio.
It is registered as /dev/sdr0

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-dev.c | 5 +++++
 include/media/v4l2-dev.h           | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1cc1749..c9cf54c 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -767,6 +767,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
  *	%VFL_TYPE_RADIO - A radio card
  *
  *	%VFL_TYPE_SUBDEV - A subdevice
+ *
+ *	%VFL_TYPE_SDR - Software Defined Radio
  */
 int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use, struct module *owner)
@@ -806,6 +808,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	case VFL_TYPE_SUBDEV:
 		name_base = "v4l-subdev";
 		break;
+	case VFL_TYPE_SDR:
+		name_base = "sdr";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index c768c9f..eec6e46 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -24,7 +24,8 @@
 #define VFL_TYPE_VBI		1
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_SUBDEV		3
-#define VFL_TYPE_MAX		4
+#define VFL_TYPE_SDR		4
+#define VFL_TYPE_MAX		5
 
 /* Is this a receiver, transmitter or mem-to-mem? */
 /* Ignored for VFL_TYPE_SUBDEV. */
-- 
1.8.4.2

