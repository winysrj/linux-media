Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:7742
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZDRWpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 18:45:53 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com
Subject: [PATCH][libv4l] Support V4L2_CTRL_FLAG_NEXT_CTRL for fake controls
Date: Sat, 18 Apr 2009 23:45:48 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49E5D4DE.6090108@hhs.nl> <49E9B989.70602@redhat.com> <200904182044.06879.linux@baker-net.org.uk>
In-Reply-To: <200904182044.06879.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904182345.48441.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "fake" controls added by libv4l to provide whitebalance on some cameras do 
not respect the V4L2_CTRL_FLAG_NEXT_CTRL and hence don't appear on control 
programs that try to use that flag if there are any driver controls that do 
support the flag. Add support for V4L2_CTRL_FLAG_NEXT_CTRL

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
---
This isn't extensively tested but v4l2ucp (and my version does use the flag) now
lists both fake and original control for a camera with both and adds the fake controls
for a camera with none.
---
--- libv4l-0.5.97/libv4lconvert/control/libv4lcontrol.c	2009-04-14 09:17:02.000000000 +0100
+++ new/libv4lconvert/control/libv4lcontrol.c	2009-04-18 23:36:28.000000000 +0100
@@ -280,7 +280,10 @@
 {
   int i;
   struct v4l2_queryctrl *ctrl = arg;
+  int retval;
+  __u32 orig_id=ctrl->id;
 
+  /* if we have an exact match return it */
   for (i = 0; i < V4LCONTROL_COUNT; i++)
     if ((data->controls & (1 << i)) &&
 	ctrl->id == fake_controls[i].id) {
@@ -288,7 +291,21 @@
       return 0;
     }
 
-  return syscall(SYS_ioctl, data->fd, VIDIOC_QUERYCTRL, arg);
+  /* find out what the kernel driver would respond. */
+  retval = syscall(SYS_ioctl, data->fd, VIDIOC_QUERYCTRL, arg);
+
+  /* if any of our controls have an id > orig_id but less than
+     ctrl->id then return that control instead. */
+  if (orig_id & V4L2_CTRL_FLAG_NEXT_CTRL)
+    for (i = 0; i < V4LCONTROL_COUNT; i++)
+      if ((data->controls & (1 << i)) &&
+          (fake_controls[i].id > (orig_id & ~V4L2_CTRL_FLAG_NEXT_CTRL)) &&
+          (fake_controls[i].id <= ctrl->id)) {
+        memcpy(ctrl, &fake_controls[i], sizeof(struct v4l2_queryctrl));
+        retval = 0;
+      }
+
+  return retval;
 }
 
 int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)

