Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2510 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0L2Vn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:27 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhQch046857
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:26 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <05f9b24918aaa009885961423728d43de77b841f.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:25 +0100
Subject: [PATCH 08/10] [RFC] v4l2-framework: update documentation for new prio field
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-framework.txt |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f22f35c..7739705 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -448,15 +448,20 @@ allocated memory.
 You should also set these fields:
 
 - v4l2_dev: set to the v4l2_device parent device.
+
 - name: set to something descriptive and unique.
+
 - fops: set to the v4l2_file_operations struct.
+
 - ioctl_ops: if you use the v4l2_ioctl_ops to simplify ioctl maintenance
   (highly recommended to use this and it might become compulsory in the
   future!), then set this to your v4l2_ioctl_ops struct.
+
 - lock: leave to NULL if you want to do all the locking in the driver.
   Otherwise you give it a pointer to a struct mutex_lock and before any
   of the v4l2_file_operations is called this lock will be taken by the
   core and released afterwards.
+
 - parent: you only set this if v4l2_device was registered with NULL as
   the parent device struct. This only happens in cases where one hardware
   device has multiple PCI devices that all share the same v4l2_device core.
@@ -467,8 +472,18 @@ You should also set these fields:
   PCI device it is setup without a parent device. But when the struct
   video_device is setup you do know which parent PCI device to use.
 
-If you use v4l2_ioctl_ops, then you should set either .unlocked_ioctl or
-.ioctl to video_ioctl2 in your v4l2_file_operations struct.
+- prio: if left to NULL, then the prio state in struct v4l2_device will be
+  used, otherwise you can point it to your own struct v4l2_prio_state.
+  This field is used for checking priorities (see VIDIOC_S_PRIORITY). In most
+  cases this field remains NULL.
+
+  Only if the driver has multiple device nodes and some of those can be used
+  independently from others (e.g. capture and display nodes are often
+  independent), then you need to have multiple v4l2_prio_state structs and
+  point this field to the correct one.
+
+If you use v4l2_ioctl_ops, then you should set .unlocked_ioctl to video_ioctl2
+in your v4l2_file_operations struct.
 
 The v4l2_file_operations struct is a subset of file_operations. The main
 difference is that the inode argument is omitted since it is never used.
-- 
1.6.4.2

