Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4365 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaCQMyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:54:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH for v3.15 4/5] v4l2-common.h: remove __user annotation in struct v4l2_edid
Date: Mon, 17 Mar 2014 13:54:22 +0100
Message-Id: <1395060863-42211-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
References: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The edid array is copied to kernelspace by the v4l2 core, so drivers
shouldn't see the __user annotation. This conforms to other structs like
v4l2_ext_controls where the data pointed to is copied to from user to
kernelspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 270db89..e9011cd 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -73,7 +73,7 @@ struct v4l2_edid {
 	__u32 start_block;
 	__u32 blocks;
 	__u32 reserved[5];
-	__u8 __user *edid;
+	__u8  *edid;
 };
 
 #endif /* __V4L2_COMMON__ */
-- 
1.9.0

