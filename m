Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55518 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbcBUVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:36:20 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC 1/4] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments
Date: Sun, 21 Feb 2016 23:36:12 +0200
Message-Id: <1456090575-28354-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Align them up to a power of two.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/media.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 6aac2f0..008d077 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -302,7 +302,7 @@ struct media_v2_entity {
 	__u32 id;
 	char name[64];		/* FIXME: move to a property? (RFC says so) */
 	__u32 function;		/* Main function of the entity */
-	__u16 reserved[12];
+	__u32 reserved[14];
 };
 
 /* Should match the specific fields at media_intf_devnode */
@@ -315,7 +315,7 @@ struct media_v2_interface {
 	__u32 id;
 	__u32 intf_type;
 	__u32 flags;
-	__u32 reserved[9];
+	__u32 reserved[13];
 
 	union {
 		struct media_v2_intf_devnode devnode;
@@ -327,7 +327,7 @@ struct media_v2_pad {
 	__u32 id;
 	__u32 entity_id;
 	__u32 flags;
-	__u16 reserved[9];
+	__u32 reserved[5];
 };
 
 struct media_v2_link {
@@ -335,7 +335,7 @@ struct media_v2_link {
 	__u32 source_id;
 	__u32 sink_id;
 	__u32 flags;
-	__u32 reserved[5];
+	__u32 reserved[4];
 };
 
 struct media_v2_topology {
-- 
2.1.4

