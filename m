Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3088 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaHUUTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] videodev2.h: add __user to v4l2_ext_control pointers
Date: Thu, 21 Aug 2014 22:19:35 +0200
Message-Id: <1408652376-39525-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are not copied to kernel space by video_usercopy, so mark them
as __user.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 778a329..0b1ba5c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1285,11 +1285,11 @@ struct v4l2_ext_control {
 	union {
 		__s32 value;
 		__s64 value64;
-		char *string;
-		__u8 *p_u8;
-		__u16 *p_u16;
-		__u32 *p_u32;
-		void *ptr;
+		char __user *string;
+		__u8 __user *p_u8;
+		__u16 __user *p_u16;
+		__u32 __user *p_u32;
+		void __user *ptr;
 	};
 } __attribute__ ((packed));
 
-- 
2.1.0.rc1

