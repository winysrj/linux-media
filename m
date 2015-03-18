Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32908 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbbCRKWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:22:09 -0400
Received: by wixw10 with SMTP id w10so61258028wix.0
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 03:22:07 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	corbet@lwn.net, mchehab@osg.samsung.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [RFC PATCH] v4l2-subdev: allow subdev to send an event to the v4l2_device notify function
Date: Wed, 18 Mar 2015 11:21:47 +0100
Message-Id: <1426674107-23721-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All drivers use custom notifications, in particular when source changes.
The bridge only has to map the subdev that sends it to whatever video node it is connected to.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 Documentation/video4linux/v4l2-framework.txt | 4 ++++
 include/media/v4l2-subdev.h                  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f586e29..b01068e 100644
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
index 5beeb87..1798360 100644
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
2.3.1

