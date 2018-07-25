Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39375 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729025AbeGYODP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:03:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media.h: remove linux/version.h include
Message-ID: <7f418498-14ae-c127-61a6-31071e042631@xs4all.nl>
Date: Wed, 25 Jul 2018 14:51:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media.h public header is one of only three public headers that include
linux/version.h. Drop it from media.h. It was only used for an obsolete
define.

It has to be added to media-device.c, since that source relied on media.h
to include it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 14959b19a342..fcdf3d5dc4b6 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/usb.h>
+#include <linux/version.h>

 #include <media/media-device.h>
 #include <media/media-devnode.h>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 82ec9f132a53..36f76e777ef9 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -25,7 +25,6 @@
 #endif
 #include <linux/ioctl.h>
 #include <linux/types.h>
-#include <linux/version.h>

 struct media_device_info {
 	char driver[16];
@@ -421,7 +420,7 @@ struct media_v2_topology {
 #define MEDIA_INTF_T_ALSA_TIMER			(MEDIA_INTF_T_ALSA_BASE + 7)

 /* Obsolete symbol for media_version, no longer used in the kernel */
-#define MEDIA_API_VERSION			KERNEL_VERSION(0, 1, 0)
+#define MEDIA_API_VERSION			((0 << 16) | (1 << 8) | 0)

 #endif
