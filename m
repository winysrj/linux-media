Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14882 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaAaQMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 11:12:36 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v2 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
Date: Fri, 31 Jan 2014 18:15:52 +0200
Message-Id: <1391184952-22223-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <52EBCA3D.2040106@xs4all.nl>
References: <52EBCA3D.2040106@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I thought this was already working but apparently not. Allow 32-bit compat
IOCTLs on 64-bit systems.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..1fce944 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1087,6 +1087,18 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_QUERY_DV_TIMINGS:
 	case VIDIOC_DV_TIMINGS_CAP:
 	case VIDIOC_ENUM_FREQ_BANDS:
+		/* Sub-device IOCTLs */
+	case VIDIOC_SUBDEV_G_FMT:
+	case VIDIOC_SUBDEV_S_FMT:
+	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
+	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
+	case VIDIOC_SUBDEV_ENUM_MBUS_CODE:
+	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
+	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
+	case VIDIOC_SUBDEV_G_CROP:
+	case VIDIOC_SUBDEV_S_CROP:
+	case VIDIOC_SUBDEV_G_SELECTION:
+	case VIDIOC_SUBDEV_S_SELECTION:
 	case VIDIOC_SUBDEV_G_EDID32:
 	case VIDIOC_SUBDEV_S_EDID32:
 		ret = do_video_ioctl(file, cmd, arg);
-- 
1.8.3.2

