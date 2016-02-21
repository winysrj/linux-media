Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55534 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447AbcBUVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:36:20 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC 4/4] media: Drop media_get_uptr() macro
Date: Sun, 21 Feb 2016 23:36:15 +0200
Message-Id: <1456090575-28354-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

There's no real need for such a macro, especially not in the user space
header.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 8 ++++----
 include/uapi/linux/media.h   | 5 -----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index f001c27..8a20383 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -256,7 +256,7 @@ static long __media_device_get_topology(struct media_device *mdev,
 
 	/* Get entities and number of entities */
 	i = 0;
-	uentity = media_get_uptr(topo->ptr_entities);
+	uentity = (void __user *)(uintptr_t)topo->ptr_entities;
 	media_device_for_each_entity(entity, mdev) {
 		i++;
 		if (ret || !uentity)
@@ -282,7 +282,7 @@ static long __media_device_get_topology(struct media_device *mdev,
 
 	/* Get interfaces and number of interfaces */
 	i = 0;
-	uintf = media_get_uptr(topo->ptr_interfaces);
+	uintf = (void __user *)(uintptr_t)topo->ptr_interfaces;
 	media_device_for_each_intf(intf, mdev) {
 		i++;
 		if (ret || !uintf)
@@ -317,7 +317,7 @@ static long __media_device_get_topology(struct media_device *mdev,
 
 	/* Get pads and number of pads */
 	i = 0;
-	upad = media_get_uptr(topo->ptr_pads);
+	upad = (void __user *)(uintptr_t)topo->ptr_pads;
 	media_device_for_each_pad(pad, mdev) {
 		i++;
 		if (ret || !upad)
@@ -343,7 +343,7 @@ static long __media_device_get_topology(struct media_device *mdev,
 
 	/* Get links and number of links */
 	i = 0;
-	ulink = media_get_uptr(topo->ptr_links);
+	ulink = (void __user *)(uintptr_t)topo->ptr_links;
 	media_device_for_each_link(link, mdev) {
 		if (link->is_backlink)
 			continue;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 77a95db..f4f7897 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -353,11 +353,6 @@ struct media_v2_topology {
 	__u32 reserved[18];
 };
 
-static inline void __user *media_get_uptr(__u64 arg)
-{
-	return (void __user *)(uintptr_t)arg;
-}
-
 /* ioctls */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
-- 
2.1.4

