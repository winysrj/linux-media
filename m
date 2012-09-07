Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1677 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2IGN3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 24/28] v4l2-dev: add new VFL_DIR_ defines.
Date: Fri,  7 Sep 2012 15:29:24 +0200
Message-Id: <e2043c0ca47cc3ed1fd45f62a6bce14e3ed5e2e8.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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

