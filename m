Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4602 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaAFOVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/27] videodev2.h: add struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL.
Date: Mon,  6 Jan 2014 15:21:04 +0100
Message-Id: <1389018086-15903-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new struct and ioctl to extend the amount of information you can
get for a control/property.

It allows you to query controls in a specific configuration store, it
gives back a unit string, the range is now a s64 type, and the matrix
and element size can be reported through cols/rows/elem_size.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e2259..2dda52d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1272,6 +1272,35 @@ struct v4l2_queryctrl {
 	__u32		     reserved[2];
 };
 
+/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
+struct v4l2_query_ext_ctrl {
+	__u32                config_store;
+	__u32		     id;
+	__u32		     type;
+	char		     name[32];
+	char		     unit[32];
+	union {
+		__s64 val;
+		__u32 reserved[4];
+	} min;
+	union {
+		__s64 val;
+		__u32 reserved[4];
+	} max;
+	union {
+		__u64 val;
+		__u32 reserved[4];
+	} step;
+	union {
+		__s64 val;
+		__u32 reserved[4];
+	} def;
+	__u32                flags;
+	__u32                cols, rows;
+	__u32                elem_size;
+	__u32		     reserved[16];
+};
+
 /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
 struct v4l2_querymenu {
 	__u32		id;
@@ -1965,6 +1994,8 @@ struct v4l2_create_buffers {
    Never use these in applications! */
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
 
+#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.8.5.2

