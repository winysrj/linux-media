Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55750 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZEYLMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 07:12:44 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-media@vger.kernel.org
Subject: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
Date: Mon, 25 May 2009 13:17:02 +0200
Cc: nm127@freemail.hu
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905251317.02633.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Márton Németh found an integer overflow bug in the extended control ioctl 
handling code. This affects both video_usercopy and video_ioctl2. See 
http://bugzilla.kernel.org/show_bug.cgi?id=13357 for a detailed description of 
the problem.

v4l2_ext_controls::count is not checked explicitly by 
video_usercopy/video_ioctl2. Instead the code tries to allocate 
v4l2_ext_controls::count * sizeof(struct v4l2_ext_control) to copy 
v4l2_ext_controls::controls from userspace to kernelspace, and return an error 
if the memory can't be allocated or if the user pointer is invalid.

The v4l2_ext_controls::count * sizeof(struct v4l2_ext_control) value is stored 
in a 32 bits integer, resulting in an overflow if v4l2_ext_controls::count is 
too high. If the result is smaller than the maximum kmalloc'able size, the 
ioctl call will make it to the device driver, which will likely crash.

The following patch (copied from bugzilla) fixes the problem.

diff -r e0d881b21bc9 linux/drivers/media/video/v4l2-ioctl.c
--- a/linux/drivers/media/video/v4l2-ioctl.c	Tue May 19 15:12:17 2009 +0200
+++ b/linux/drivers/media/video/v4l2-ioctl.c	Sun May 24 18:26:29 2009 +0200
@@ -402,6 +402,10 @@
 		   a specific control that caused it. */
 		p->error_idx = p->count;
 		user_ptr = (void __user *)p->controls;
+		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
+			err = -ENOMEM;
+			goto out_ext_ctrl;
+		}
 		if (p->count) {
 			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
@@ -1859,6 +1863,10 @@
 		   a specific control that caused it. */
 		p->error_idx = p->count;
 		user_ptr = (void __user *)p->controls;
+		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
+			err = -ENOMEM;
+			goto out_ext_ctrl;
+		}
 		if (p->count) {
 			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */

Restricting v4l2_ext_controls::count to values smaller than KMALLOC_MAX_SIZE /
sizeof(struct v4l2_ext_control) should be enough, but we might want to 
restrict the value even further. I'd like opinions on this.

Best regards,

Laurent Pinchart

