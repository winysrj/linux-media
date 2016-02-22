Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49801 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752980AbcBVUrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:47:08 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 1/4] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments
Date: Mon, 22 Feb 2016 22:47:01 +0200
Message-Id: <1456174024-11389-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The argument structs are used in arrays for G_TOPOLOGY IOCTL. The
arguments themselves do not need to be aligned to a power of two, but
aligning them up to the largest basic type alignment (u64) on common ABIs
is a good thing to do.

The patch changes the size of the reserved fields to 8 or 9 u32's and
aligns the size of the struct to 8 bytes so we do no longer depend on the
compiler to perform the alignment.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/media.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 6aac2f0..1468651 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -302,7 +302,7 @@ struct media_v2_entity {
 	__u32 id;
 	char name[64];		/* FIXME: move to a property? (RFC says so) */
 	__u32 function;		/* Main function of the entity */
-	__u16 reserved[12];
+	__u32 reserved[8];
 };
 
 /* Should match the specific fields at media_intf_devnode */
@@ -327,7 +327,7 @@ struct media_v2_pad {
 	__u32 id;
 	__u32 entity_id;
 	__u32 flags;
-	__u16 reserved[9];
+	__u32 reserved[9];
 };
 
 struct media_v2_link {
@@ -335,7 +335,7 @@ struct media_v2_link {
 	__u32 source_id;
 	__u32 sink_id;
 	__u32 flags;
-	__u32 reserved[5];
+	__u32 reserved[8];
 };
 
 struct media_v2_topology {
-- 
2.1.4

