Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3F1C282C7
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 11:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1781B217D7
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 11:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfAZLG0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 26 Jan 2019 06:06:26 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:54295 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbfAZLG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Jan 2019 06:06:26 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id nLn1gc44KBDyInLn5gjlnI; Sat, 26 Jan 2019 12:06:24 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] videodev2.h: introduce VIDIOC_DQEXTEVENT
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <700eff44-b903-24d0-ef41-e634e643a200@xs4all.nl>
Date:   Sat, 26 Jan 2019 12:06:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKCFUC1bHSd/qsYXZUGs/55Qfh8b78PyX3SBmZO8nuF8eZIs6HTZjwPfORpFg9JeP6nEBdnIvniwoj41ZUfSYs+YIElXq2GhNQZcMOmOk3h5XCOgTFci
 I3VeDvmena5eAHGj8LzMGGvQ08tyXuoXDyboyox2A5lYfniWDfqkEbTJv/yklDQNeu3heGHGETURSUHMFDjVNQhraUICt+l+W6e6ClkblTFxAeNlXkGrwEJs
 VKsZbgYRkgcueOiTjVgemIgt7bqnzXDj+qV0XfUfjFc=
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
Please let me know if there are additional requests for such a new ioctl.

Note that I am using number 104 for the ioctl, but perhaps it would be better to
use an unused ioctl number like 1 or 3. There are quite a few holes in the
ioctl numbers. We currently have only 82 ioctls, yet are up to ioctl number 103.
---
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9a920f071ff9..969e775b8c25 100644
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
+	__u64				timestamp;
+	__u32				pending;
+	__u32				sequence;
+	__u32				reserved[8];
+};
+
 #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
 #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)

@@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)

 #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
+#define	VIDIOC_DQEXTEVENT	 _IOR('V', 104, struct v4l2_ext_event)

 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
