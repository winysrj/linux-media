Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2771 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1AHNhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:08 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08DalkD015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 16/16] v4l2-framework.txt: improve v4l2_fh/priority documentation
Date: Sat,  8 Jan 2011 14:36:41 +0100
Message-Id: <c644550d1d65a6ea7174c74afae8c11d24268026.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-framework.txt |  120 +++++++++++++++++++-------
 1 files changed, 87 insertions(+), 33 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f22f35c..39b7be4 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -457,6 +457,10 @@ You should also set these fields:
   Otherwise you give it a pointer to a struct mutex_lock and before any
   of the v4l2_file_operations is called this lock will be taken by the
   core and released afterwards.
+- prio: keeps track of the priorities. Used to implement VIDIOC_G/S_PRIORITY.
+  If left to NULL, then it will use the struct v4l2_prio_state in v4l2_device.
+  If you want to have a separate priority state per (group of) device node(s),
+  then you can point it to your own struct v4l2_prio_state.
 - parent: you only set this if v4l2_device was registered with NULL as
   the parent device struct. This only happens in cases where one hardware
   device has multiple PCI devices that all share the same v4l2_device core.
@@ -467,12 +471,14 @@ You should also set these fields:
   PCI device it is setup without a parent device. But when the struct
   video_device is setup you do know which parent PCI device to use.
 
-If you use v4l2_ioctl_ops, then you should set either .unlocked_ioctl or
-.ioctl to video_ioctl2 in your v4l2_file_operations struct.
+If you use v4l2_ioctl_ops, then you should set .unlocked_ioctl to video_ioctl2
+in your v4l2_file_operations struct.
 
 The v4l2_file_operations struct is a subset of file_operations. The main
 difference is that the inode argument is omitted since it is never used.
 
+Do not use .ioctl! This is deprecated and will go away in the future.
+
 v4l2_file_operations and locking
 --------------------------------
 
@@ -636,39 +642,24 @@ struct v4l2_fh
 --------------
 
 struct v4l2_fh provides a way to easily keep file handle specific data
-that is used by the V4L2 framework. Using v4l2_fh is optional for
-drivers.
+that is used by the V4L2 framework. New drivers must use struct v4l2_fh
+since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY).
 
 The users of v4l2_fh (in the V4L2 framework, not the driver) know
 whether a driver uses v4l2_fh as its file->private_data pointer by
-testing the V4L2_FL_USES_V4L2_FH bit in video_device->flags.
-
-Useful functions:
-
-- v4l2_fh_init()
-
-  Initialise the file handle. This *MUST* be performed in the driver's
-  v4l2_file_operations->open() handler.
-
-- v4l2_fh_add()
+testing the V4L2_FL_USES_V4L2_FH bit in video_device->flags. This bit is
+set whenever v4l2_fh_init() is called.
 
-  Add a v4l2_fh to video_device file handle list. May be called after
-  initialising the file handle.
-
-- v4l2_fh_del()
-
-  Unassociate the file handle from video_device(). The file handle
-  exit function may now be called.
+struct v4l2_fh is allocated as a part of the driver's own file handle
+structure and file->private_data is set to it in the driver's open
+function by the driver.
 
-- v4l2_fh_exit()
+In many cases the struct v4l2_fh will be embedded in a larger structure.
+In that case you should call v4l2_fh_init+v4l2_fh_add in open() and
+v4l2_fh_del+v4l2_fh_exit in release().
 
-  Uninitialise the file handle. After uninitialisation the v4l2_fh
-  memory can be freed.
-
-struct v4l2_fh is allocated as a part of the driver's own file handle
-structure and is set to file->private_data in the driver's open
-function by the driver. Drivers can extract their own file handle
-structure by using the container_of macro. Example:
+Drivers can extract their own file handle structure by using the container_of
+macro. Example:
 
 struct my_fh {
 	int blah;
@@ -685,15 +676,21 @@ int my_open(struct file *file)
 
 	...
 
+	my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+
+	...
+
 	ret = v4l2_fh_init(&my_fh->fh, vfd);
-	if (ret)
+	if (ret) {
+		kfree(my_fh);
 		return ret;
+	}
 
-	v4l2_fh_add(&my_fh->fh);
+	...
 
 	file->private_data = &my_fh->fh;
-
-	...
+	v4l2_fh_add(&my_fh->fh);
+	return 0;
 }
 
 int my_release(struct file *file)
@@ -702,8 +699,65 @@ int my_release(struct file *file)
 	struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
 
 	...
+	v4l2_fh_del(&my_fh->fh);
+	v4l2_fh_exit(&my_fh->fh);
+	kfree(my_fh);
+	return 0;
 }
 
+Below is a short description of the v4l2_fh functions used:
+
+int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+
+  Initialise the file handle. This *MUST* be performed in the driver's
+  v4l2_file_operations->open() handler.
+
+void v4l2_fh_add(struct v4l2_fh *fh)
+
+  Add a v4l2_fh to video_device file handle list. Must be called once the
+  file handle is completely initialized.
+
+void v4l2_fh_del(struct v4l2_fh *fh)
+
+  Unassociate the file handle from video_device(). The file handle
+  exit function may now be called.
+
+void v4l2_fh_exit(struct v4l2_fh *fh)
+
+  Uninitialise the file handle. After uninitialisation the v4l2_fh
+  memory can be freed.
+
+
+If struct v4l2_fh is not embedded, then you can use these helper functions:
+
+int v4l2_fh_open(struct file *filp)
+
+  This allocates a struct v4l2_fh, initializes it and adds it to the struct
+  video_device associated with the file struct.
+
+int v4l2_fh_release(struct file *filp)
+
+  This deletes it from the struct video_device associated with the file
+  struct, uninitialised the v4l2_fh and frees it.
+
+These two functions can be plugged into the v4l2_file_operation's open() and
+release() ops.
+
+
+Several drivers need to do something when the first file handle is opened and
+when the last file handle closes. Two helper functions were added to check
+whether the v4l2_fh struct is the only open filehandle of the associated
+device node:
+
+int v4l2_fh_is_singular(struct v4l2_fh *fh)
+
+  Returns 1 if the file handle is the only open file handle, else 0.
+
+int v4l2_fh_is_singular_file(struct file *filp)
+
+  Same, but it calls v4l2_fh_is_singular with filp->private_data.
+
+
 V4L2 events
 -----------
 
-- 
1.7.0.4

