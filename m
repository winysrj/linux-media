Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29749 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab1KBQQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 12:16:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU100E1VJUQJW90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Nov 2011 16:16:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU100HCEJUP4Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Nov 2011 16:16:01 +0000 (GMT)
Date: Wed, 02 Nov 2011 17:15:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320250557-20880-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_LOG_STATUS ioctl allows to dump current status of a driver
to the kernel log. Currently this ioctl is only available at video 
device nodes and the subdevs rely on the host driver to expose their 
core.log_status operation to user space.

This patch adds VIDIOC_LOG_STATUS support at the sub-device nodes,
for standalone subdevs that expose their own /dev entry.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-subdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 179e20e..4fe1e7a 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -192,6 +192,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(sd, core, s_register, p);
 	}
 #endif
+	case VIDIOC_LOG_STATUS:
+		return v4l2_subdev_call(sd, core, log_status);
+
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	case VIDIOC_SUBDEV_G_FMT: {
 		struct v4l2_subdev_format *format = arg;
-- 
1.7.7.1

