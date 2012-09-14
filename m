Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:48145 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2INK6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:06 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBw013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:59 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 27/31] v4l2-dev: add new VFL_DIR_ defines.
Date: Fri, 14 Sep 2012 12:57:42 +0200
Message-Id: <5a262a9825e89a2c7b3e094de9432d65634fd1ba.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These will be used by v4l2-dev.c to improve ioctl checking.
I.e. ioctls for capture should return -ENOTTY when called for
an output device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-dev.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 6ee8897..95d1c91 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -26,6 +26,12 @@
 #define VFL_TYPE_SUBDEV		3
 #define VFL_TYPE_MAX		4
 
+/* Is this a receiver, transmitter or mem-to-mem? */
+/* Ignored for VFL_TYPE_SUBDEV. */
+#define VFL_DIR_RX		0
+#define VFL_DIR_TX		1
+#define VFL_DIR_M2M		2
+
 struct v4l2_ioctl_callbacks;
 struct video_device;
 struct v4l2_device;
@@ -105,7 +111,8 @@ struct video_device
 
 	/* device info */
 	char name[32];
-	int vfl_type;
+	int vfl_type;	/* device type */
+	int vfl_dir;	/* receiver, transmitter or m2m */
 	/* 'minor' is set to -1 if the registration failed */
 	int minor;
 	u16 num;
-- 
1.7.10.4

