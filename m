Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37968 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755097AbcCCRUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 12:20:20 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2.1 1/4] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments
Date: Thu,  3 Mar 2016 19:20:14 +0200
Message-Id: <1457025614-16037-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20160301081615.68b1ef2c@recife.lan>
References: <20160301081615.68b1ef2c@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The argument structs are used in arrays for G_TOPOLOGY IOCTL. The
arguments themselves do not need to be aligned to a power of two, but
aligning them up to the largest basic type alignment (u64) on common ABIs
is a good thing to do.

The patch changes the size of the reserved fields to 5 or 6 u32's and
aligns the size of the struct to 8 bytes so we do no longer depend on the
compiler to perform the alignment.

While at it, add __attribute__ ((packed)) to these structs as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v2:

- Use 5 or 6 __u32's for alignment instead of 8 or 9, except for struct
  media_v2_interface.

- Add __attribute__ ((packed)).

 include/uapi/linux/media.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 95e126e..860932f 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -319,14 +319,14 @@ struct media_v2_entity {
 	__u32 id;
 	char name[64];		/* FIXME: move to a property? (RFC says so) */
 	__u32 function;		/* Main function of the entity */
-	__u16 reserved[12];
-};
+	__u32 reserved[6];
+} __attribute__ ((packed));
 
 /* Should match the specific fields at media_intf_devnode */
 struct media_v2_intf_devnode {
 	__u32 major;
 	__u32 minor;
-};
+} __attribute__ ((packed));
 
 struct media_v2_interface {
 	__u32 id;
@@ -338,22 +338,22 @@ struct media_v2_interface {
 		struct media_v2_intf_devnode devnode;
 		__u32 raw[16];
 	};
-};
+} __attribute__ ((packed));
 
 struct media_v2_pad {
 	__u32 id;
 	__u32 entity_id;
 	__u32 flags;
-	__u16 reserved[9];
-};
+	__u32 reserved[5];
+} __attribute__ ((packed));
 
 struct media_v2_link {
 	__u32 id;
 	__u32 source_id;
 	__u32 sink_id;
 	__u32 flags;
-	__u32 reserved[5];
-};
+	__u32 reserved[6];
+} __attribute__ ((packed));
 
 struct media_v2_topology {
 	__u64 topology_version;
@@ -373,7 +373,7 @@ struct media_v2_topology {
 	__u32 num_links;
 	__u32 reserved4;
 	__u64 ptr_links;
-};
+} __attribute__ ((packed));
 
 static inline void __user *media_get_uptr(__u64 arg)
 {
-- 
2.1.4

