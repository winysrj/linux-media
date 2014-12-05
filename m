Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41954 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaLEOTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:19:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.19 1/4] v4l2-mediabus.h: use two __u16 instead of two __u32
Date: Fri,  5 Dec 2014 15:19:21 +0100
Message-Id: <1417789164-28468-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ycbcr_enc and quantization fields do not need a __u32. Switch to
two __u16 types, thus preserving alignment and avoiding holes in the
struct. This makes one more __u32 available for future expansion.

Suggested by Sakari Ailus.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-mediabus.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 5a86d8e..26db206 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -31,9 +31,9 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u32			ycbcr_enc;
-	__u32			quantization;
-	__u32			reserved[5];
+	__u16			ycbcr_enc;
+	__u16			quantization;
+	__u32			reserved[6];
 };
 
 #ifndef __KERNEL__
-- 
2.1.3

