Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33619 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaANBU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 20:20:57 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v7 01/12] v4l: add device type for Software Defined Radio
Date: Tue, 14 Jan 2014 03:20:19 +0200
Message-Id: <1389662430-32699-2-git-send-email-crope@iki.fi>
In-Reply-To: <1389662430-32699-1-git-send-email-crope@iki.fi>
References: <1389662430-32699-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new V4L device type VFL_TYPE_SDR for Software Defined Radio.
It is registered as /dev/swradio0 (/dev/sdr0 was already reserved).

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 6 ++++++
 include/media/v4l2-dev.h           | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index b5aaaac..2ccacf2 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -758,6 +758,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
  *	%VFL_TYPE_RADIO - A radio card
  *
  *	%VFL_TYPE_SUBDEV - A subdevice
+ *
+ *	%VFL_TYPE_SDR - Software Defined Radio
  */
 int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use, struct module *owner)
@@ -797,6 +799,10 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	case VFL_TYPE_SUBDEV:
 		name_base = "v4l-subdev";
 		break;
+	case VFL_TYPE_SDR:
+		/* Use device name 'swradio' because 'sdr' was already taken. */
+		name_base = "swradio";
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

