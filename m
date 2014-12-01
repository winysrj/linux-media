Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44361 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbaLANLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:11:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] v4l2-framework.txt: document debug attribute
Date: Mon,  1 Dec 2014 14:10:45 +0100
Message-Id: <1417439445-34862-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
References: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The debug attribute in /sys/class/video4linux/<devX>/debug was never
documented. Add this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index a11dff0..f586e29 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -793,8 +793,10 @@ video_register_device_no_warn() instead.
 
 Whenever a device node is created some attributes are also created for you.
 If you look in /sys/class/video4linux you see the devices. Go into e.g.
-video0 and you will see 'name' and 'index' attributes. The 'name' attribute
-is the 'name' field of the video_device struct.
+video0 and you will see 'name', 'debug' and 'index' attributes. The 'name'
+attribute is the 'name' field of the video_device struct. The 'debug' attribute
+can be used to enable core debugging. See the next section for more detailed
+information on this.
 
 The 'index' attribute is the index of the device node: for each call to
 video_register_device() the index is just increased by 1. The first video
@@ -816,6 +818,25 @@ video_device was embedded in it. The vdev->release() callback will never
 be called if the registration failed, nor should you ever attempt to
 unregister the device if the registration failed.
 
+video device debugging
+----------------------
+
+The 'debug' attribute that is created for each video, vbi, radio or swradio
+device in /sys/class/video4linux/<devX>/ allows you to enable logging of
+file operations.
+
+It is a bitmask and the following bits can be set:
+
+0x01: Log the ioctl name and error code. VIDIOC_(D)QBUF ioctls are only logged
+      if bit 0x08 is also set.
+0x02: Log the ioctl name arguments and error code. VIDIOC_(D)QBUF ioctls are
+      only logged if bit 0x08 is also set.
+0x04: Log the file operations open, release, read, write, mmap and
+      get_unmapped_area. The read and write operations are only logged if
+      bit 0x08 is also set.
+0x08: Log the read and write file operations and the VIDIOC_QBUF and
+      VIDIOC_DQBUF ioctls.
+0x10: Log the poll file operation.
 
 video_device cleanup
 --------------------
-- 
2.1.3

