Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33367 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbdFPHjj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:39:39 -0400
Received: by mail-pf0-f196.google.com with SMTP id w12so4720045pfk.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 00:39:39 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 06/12] [media] v4l: add V4L2_EVENT_BUF_QUEUED event
Date: Fri, 16 Jun 2017 16:39:09 +0900
Message-Id: <20170616073915.5027-7-gustavo@padovan.org>
In-Reply-To: <20170616073915.5027-1-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add a new event the userspace can subscribe to receive notifications
when a buffer is queued onto the driver. The event provides the index of
the queued buffer.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/uapi/linux/videodev2.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 750d511..c2eda75 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2150,6 +2150,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_FRAME_SYNC			4
 #define V4L2_EVENT_SOURCE_CHANGE		5
 #define V4L2_EVENT_MOTION_DET			6
+#define V4L2_EVENT_BUF_QUEUED			7
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -2202,6 +2203,10 @@ struct v4l2_event_motion_det {
 	__u32 region_mask;
 };
 
+struct v4l2_event_buf_queued {
+	__u32 index;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
@@ -2210,6 +2215,7 @@ struct v4l2_event {
 		struct v4l2_event_frame_sync	frame_sync;
 		struct v4l2_event_src_change	src_change;
 		struct v4l2_event_motion_det	motion_det;
+		struct v4l2_event_buf_queued	buf_queued;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
2.9.4
