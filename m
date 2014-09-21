Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2673 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaIUOss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags field
Date: Sun, 21 Sep 2014 16:48:24 +0200
Message-Id: <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace reserved2 by a flags field. This is used to tell whether
setting a new store value is applied only once or every time that
v4l2_ctrl_apply_store() is called for that store.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2ca44ed..fa84070 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1282,7 +1282,7 @@ struct v4l2_control {
 struct v4l2_ext_control {
 	__u32 id;
 	__u32 size;
-	__u32 reserved2[1];
+	__u32 flags;
 	union {
 		__s32 value;
 		__s64 value64;
@@ -1294,6 +1294,10 @@ struct v4l2_ext_control {
 	};
 } __attribute__ ((packed));
 
+/* v4l2_ext_control flags */
+#define V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE	0x00000001
+#define V4L2_EXT_CTRL_FL_IGN_STORE		0x00000002
+
 struct v4l2_ext_controls {
 	union {
 		__u32 ctrl_class;
-- 
2.1.0

