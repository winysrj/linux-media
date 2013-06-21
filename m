Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1659 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3FUGFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 02:05:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH] v4l2-controls.h: fix copy-and-paste error in comment
Date: Fri, 21 Jun 2013 08:05:34 +0200
Message-Id: <1371794734-10078-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The comment for the FM_RX class was copied from the DV class unchanged.
Fixed.

Also made the FM_TX comment consistent with the others.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-controls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 69bd5bb..e90a88a 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -53,13 +53,13 @@
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA		0x009a0000	/* Camera class controls */
-#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FM_TX		0x009b0000	/* FM Modulator controls */
 #define V4L2_CTRL_CLASS_FLASH		0x009c0000	/* Camera flash controls */
 #define V4L2_CTRL_CLASS_JPEG		0x009d0000	/* JPEG-compression controls */
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE	0x009e0000	/* Image source controls */
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
-#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* Digital Video controls */
+#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 
 /* User-class control IDs */
 
-- 
1.8.3.1

