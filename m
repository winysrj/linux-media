Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55524 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbcBUVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:36:20 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC 2/4] media: Rearrange the fields in the G_TOPOLOGY IOCTL argument
Date: Sun, 21 Feb 2016 23:36:13 +0200
Message-Id: <1456090575-28354-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

This avoids having multiple reserved fields in the struct. Reserved fields
are added in order to align the struct size to a power of two as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/media.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 008d077..77a95db 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -341,21 +341,16 @@ struct media_v2_link {
 struct media_v2_topology {
 	__u64 topology_version;
 
-	__u32 num_entities;
-	__u32 reserved1;
 	__u64 ptr_entities;
-
-	__u32 num_interfaces;
-	__u32 reserved2;
 	__u64 ptr_interfaces;
-
-	__u32 num_pads;
-	__u32 reserved3;
 	__u64 ptr_pads;
+	__u64 ptr_links;
 
+	__u32 num_entities;
+	__u32 num_interfaces;
+	__u32 num_pads;
 	__u32 num_links;
-	__u32 reserved4;
-	__u64 ptr_links;
+	__u32 reserved[18];
 };
 
 static inline void __user *media_get_uptr(__u64 arg)
-- 
2.1.4

