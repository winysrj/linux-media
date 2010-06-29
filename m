Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38526 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab0F2Mop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:45 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl RFC][PATCH 5/5] v4l: Add missing linux/types.h include
Date: Tue, 29 Jun 2010 07:43:10 -0500
Message-Id: <1277815390-24681-6-git-send-email-saaguirre@ti.com>
In-Reply-To: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
References: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes following headers_check warnings:

*/usr/include/linux/v4l2-mediabus.h:63: found __[us]{8,16,32,64} type without #include <linux/types.h>
*/usr/include/linux/v4l2-subdev.h:33: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/v4l2-mediabus.h |    1 +
 include/linux/v4l2-subdev.h   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 6832919..2a8e490 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -11,6 +11,7 @@
 #ifndef __LINUX_V4L2_MEDIABUS_H
 #define __LINUX_V4L2_MEDIABUS_H
 
+#include <linux/types.h>
 #include <linux/videodev2.h>
 
 /*
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 5df95d4..e2e2c8d 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -19,6 +19,7 @@
 #define __LINUX_V4L2_SUBDEV_H
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 #include <linux/v4l2-mediabus.h>
 
 enum v4l2_subdev_format {
-- 
1.6.3.3

