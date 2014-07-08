Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51091 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbaGHRAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 13:00:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/8] videodev2.h: add V4L2_FIELD_HAS_T_OR_B macro
Date: Tue,  8 Jul 2014 18:31:16 +0200
Message-Id: <1404837078-15608-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
References: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a macro to test if the field consists of a single top
or bottom field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 168ff50..6d4659a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -124,6 +124,10 @@ enum v4l2_field {
 	 (field) == V4L2_FIELD_INTERLACED_BT ||\
 	 (field) == V4L2_FIELD_SEQ_TB ||\
 	 (field) == V4L2_FIELD_SEQ_BT)
+#define V4L2_FIELD_HAS_T_OR_B(field)	\
+	((field) == V4L2_FIELD_BOTTOM ||\
+	 (field) == V4L2_FIELD_TOP ||\
+	 (field) == V4L2_FIELD_ALTERNATE)
 
 enum v4l2_buf_type {
 	V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
-- 
2.0.0

