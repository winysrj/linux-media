Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57318 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbbEHJH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 05:07:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH 3/5] v4l2-subdev: allow subdev to send an event to the v4l2_device notify function
Date: Fri,  8 May 2015 11:07:26 +0200
Message-Id: <1431076048-1963-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
References: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "jean-michel.hautbois@vodalys.com" <jean-michel.hautbois@vodalys.com>

All drivers use custom notifications, in particular when source changes.
The bridge only has to map the subdev that sends it to whatever video node it is connected to.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 Documentation/video4linux/v4l2-framework.txt | 4 ++++
 include/media/v4l2-subdev.h                  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 59e619f..75d5c18 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -1129,6 +1129,10 @@ available event type is 'class base + 1'.
 An example on how the V4L2 events may be used can be found in the OMAP
 3 ISP driver (drivers/media/platform/omap3isp).
 
+A subdev can directly send an event to the v4l2_device notify function with
+V4L2_DEVICE_NOTIFY_EVENT. This allows the bridge to map the subdev that sends
+the event to the video node(s) associated with the subdev that need to be
+informed about such an event.
 
 V4L2 clocks
 -----------
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 8f5da73..dc20102 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -40,6 +40,8 @@
 #define V4L2_SUBDEV_IR_TX_NOTIFY		_IOW('v', 1, u32)
 #define V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ	0x00000001
 
+#define	V4L2_DEVICE_NOTIFY_EVENT		_IOW('v', 2, struct v4l2_event)
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
-- 
2.1.4

