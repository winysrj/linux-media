Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CCEC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011E2217D9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbfBENtt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 08:49:49 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41409 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfBENtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 08:49:49 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id r16ggQe7xNR5yr16hgpdAv; Tue, 05 Feb 2019 14:49:47 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFCv2 PATCH] videodev2.h: introduce VIDIOC_DQ_EXT_EVENT
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <a28bda76-c8e5-7e93-43a0-0d07844cebf0@xs4all.nl>
Date:   Tue, 5 Feb 2019 14:49:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIqCm/WVRa+zDgLHZ1vUJB1qXLA4bD02SMZsb4ggMALUY6pBCbKJnqQvH7Od0nZPAsRyAy5P/Yhc/Y6xdIZ4RfKu+YHrh7AV1I9igjn5PbzV9qpMqng5
 ruRsu4qdlmxrsTbUJb7kr2lUxOy4uzDx35lswAPUDtDI8KD7kU+pXhOnIKzMtp9W/Z/ekD1PwfDH3lonXXeLnBv4wuyR8dv8bvmmcmSLlVDu0E0pyyVpZpjm
 5dBZKIaodfoOX19Ux/ADeBVWANgVdBOP+pImhRpPOW9XIetwCz79m4zmjDEVfTVTwtNHIjAddA+zlxA1QMQMajxn1BulKbdwcaiCIyrwH8Y/aM1v+bFP+QJt
 vDUDmJZlKbG6jNa8/bSYTbSMy5Jof4cQnT2U+2YJC4GMO+sSOoo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds an extended version of VIDIOC_DQEVENT that:

1) is Y2038 safe by using a __u64 for the timestamp
2) needs no compat32 conversion code
3) is able to handle control events from 64-bit control types
   by changing the type of the minimum, maximum, step and default_value
   field to __u64

All drivers and frameworks will be using this, and v4l2-ioctl.c would be the
only place where the old event ioctl and structs are used.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
I chose to name this DQ_EXT_EVENT since the struct it dequeues is now called
v4l2_ext_event. This is also consistent with the names of the G/S/TRY_EXT_CTRLS
ioctls. An alternative could be VIDIOC_DQEXT_EVENT as that would be consistent
with the lack of _ between DQ and EVENT in the current ioctl. But somehow it
doesn't look right.

Changes since v1:
- rename ioctl from VIDIOC_DQEXTEVENT.
- move the reserved array up to right after the union: this will allow us to
  extend the union into the reserved array if we ever need more than 64 bytes
  for the event payload (suggested by Sakari).
---
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9a920f071ff9..301e3678bdb0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2303,6 +2303,37 @@ struct v4l2_event {
 	__u32				reserved[8];
 };

+struct v4l2_event_ext_ctrl {
+	__u32 changes;
+	__u32 type;
+	union {
+		__s32 value;
+		__s64 value64;
+	};
+	__s64 minimum;
+	__s64 maximum;
+	__s64 step;
+	__s64 default_value;
+	__u32 flags;
+};
+
+struct v4l2_ext_event {
+	__u32				type;
+	__u32				id;
+	union {
+		struct v4l2_event_vsync		vsync;
+		struct v4l2_event_ext_ctrl	ctrl;
+		struct v4l2_event_frame_sync	frame_sync;
+		struct v4l2_event_src_change	src_change;
+		struct v4l2_event_motion_det	motion_det;
+		__u8				data[64];
+	} u;
+	__u32				reserved[8];
+	__u64				timestamp;
+	__u32				pending;
+	__u32				sequence;
+};
+
 #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
 #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)

@@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)

 #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
+#define	VIDIOC_DQ_EXT_EVENT	 _IOR('V', 104, struct v4l2_ext_event)

 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
