Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33540 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753213AbdCMTVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:21:00 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 06/10] [media] v4l: add V4L2_EVENT_BUF_QUEUED event
Date: Mon, 13 Mar 2017 16:20:31 -0300
Message-Id: <20170313192035.29859-7-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Add a new event the userspace can subscribe to receive notifications
about when a buffer was enqueued onto the driver. The event provides
the index of the enqueued buffer.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/uapi/linux/videodev2.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3b6cfa6..5b44fd0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2133,6 +2133,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_FRAME_SYNC			4
 #define V4L2_EVENT_SOURCE_CHANGE		5
 #define V4L2_EVENT_MOTION_DET			6
+#define V4L2_EVENT_BUF_QUEUED			7
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -2185,6 +2186,10 @@ struct v4l2_event_motion_det {
 	__u32 region_mask;
 };
 
+struct v4l2_event_buf_queued {
+	__u32 index;
+};
+
 struct v4l2_event {
 	__u32				type;
 	union {
@@ -2193,6 +2198,7 @@ struct v4l2_event {
 		struct v4l2_event_frame_sync	frame_sync;
 		struct v4l2_event_src_change	src_change;
 		struct v4l2_event_motion_det	motion_det;
+		struct v4l2_event_buf_queued	buf_queued;
 		__u8				data[64];
 	} u;
 	__u32				pending;
-- 
2.9.3
