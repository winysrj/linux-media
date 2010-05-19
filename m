Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:63301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab0ESDSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:18:24 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:17:38 +0800
Subject: [PATCH v3 09/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895DA7@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 25b539d6fb4105c5552aca9a40f94aa30cd3a07c Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:52:01 +0800
Subject: [PATCH 09/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which declare the private ioctls information.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/ci_va.h        |   47 ++++++++++++++++++++
 .../media/video/mrstisp/include/v4l2_jpg_review.h  |   47 ++++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/ci_va.h
 create mode 100644 drivers/media/video/mrstisp/include/v4l2_jpg_review.h

diff --git a/drivers/media/video/mrstisp/include/ci_va.h b/drivers/media/video/mrstisp/include/ci_va.h
new file mode 100644
index 0000000..e77bb58
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/ci_va.h
@@ -0,0 +1,47 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+/*
+ * for buffer sharing between camera and video subsystem to improve preview
+ *  and video capture perofrmance
+ */
+
+#ifndef _CI_VA_H
+#define _CI_VA_H
+
+/* fixme: will be replaced for subdev/media controller framework */
+struct ci_frame_info {
+	unsigned long frame_id; /* in */
+	unsigned int width; /* out */
+	unsigned int height; /* out */
+	unsigned int stride; /* out */
+	unsigned int fourcc; /* out */
+	unsigned int offset; /* out */
+};
+
+#define ISP_IOCTL_GET_FRAME_INFO _IOWR('V', 192 + 5, struct ci_frame_info)
+
+#endif
+
diff --git a/drivers/media/video/mrstisp/include/v4l2_jpg_review.h b/drivers/media/video/mrstisp/include/v4l2_jpg_review.h
new file mode 100644
index 0000000..d574d83
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/v4l2_jpg_review.h
@@ -0,0 +1,47 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef	__V4L2_JPG_REVIEW_EXT_H
+#define	__V4L2_JPG_REVIEW_EXT_H
+
+#include <linux/videodev2.h>
+
+/*
+ * Moorestown JPG image auto review structure and IOCTL.
+ */
+struct v4l2_jpg_review_buffer{
+	__u32	width;		/* in: frame width */
+	__u32	height;		/* in: frame height */
+	__u32	pix_fmt;	/* in: frame fourcc */
+	__u32	jpg_frame;	/* in: corresponding jpg frame id */
+	__u32	bytesperline;	/* out: 0 if not used */
+	__u32	frame_size;	/* out: frame size */
+	__u32	offset;		/* out: mmap offset */
+};
+
+#define	BASE_VIDIOC_PRIVATE_JPG_REVIEW	(BASE_VIDIOC_PRIVATE + 10)
+
+#define	VIDIOC_CREATE_JPG_REVIEW_BUF	_IOWR('V', \
+		BASE_VIDIOC_PRIVATE_JPG_REVIEW + 1, \
+		struct v4l2_jpg_review_buffer)
+#endif
-- 
1.6.3.2

