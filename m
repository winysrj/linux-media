Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:39183 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752415Ab0AYPcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 10:32:48 -0500
Received: from office-abk.mandriva.com (unknown [195.7.104.248])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.mandriva.com (Postfix) with ESMTP id 8456A274026
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 16:01:58 +0100 (CET)
Received: from anduin.mandriva.com (fw2.mandriva.com [192.168.2.3])
	by office-abk.mandriva.com (Postfix) with ESMTP id A6B46828F7
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 16:16:50 +0100 (CET)
Received: from anduin.mandriva.com (localhost [127.0.0.1])
	by anduin.mandriva.com (Postfix) with ESMTP id 23028FF855
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 16:02:32 +0100 (CET)
From: Arnaud Patard <apatard@mandriva.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix VIDIOC_QBUF compat ioctl32
Date: Mon, 25 Jan 2010 16:02:31 +0100
Message-ID: <m3bpgi448o.fsf@anduin.mandriva.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=


When using VIDIOC_QBUF with memory type set to V4L2_MEMORY_MMAP, the
v4l2_buffer buffer gets unmodified on drivers like uvc (well, only
bytesused field is modified). Then some apps like gstreamer are reusing
the same buffer later to call munmap (eg passing the buffer "length"
field as 2nd parameter of munmap).

It's working fine on full 32bits but on 32bits systems with 64bit
kernel, the get_v4l2_buffer32() doesn't copy length/m.offset values and
then copy garbage to userspace in put_v4l2_buffer32().

This has for consequence things like that in the libv4l2 logs:

libv4l2: v4l2 unknown munmap 0x2e2b0000, -2145144908
libv4l2: v4l2 unknown munmap 0x2e530000, -2145144908

The buffer are not unmap'ed and then if the application close and open
again the device, it won't work and logs will show something like:

libv4l2: error setting pixformat: Device or resource busy

The easy solution is to read length and m.offset in get_v4l2_buffer32().


Signed-off-by: Arnaud Patard <apatard@mandriva.com>
---

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=v4l_ioctl32.patch

---
 drivers/media/video/v4l2-compat-ioctl32.c |    5 	5 +	0 -	0 !
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/media/video/v4l2-compat-ioctl32.c
===================================================================
--- linux-2.6.orig/drivers/media/video/v4l2-compat-ioctl32.c
+++ linux-2.6/drivers/media/video/v4l2-compat-ioctl32.c
@@ -475,6 +475,9 @@ static int get_v4l2_buffer32(struct v4l2
 			return -EFAULT;
 	switch (kp->memory) {
 	case V4L2_MEMORY_MMAP:
+		if (get_user(kp->length, &up->length) ||
+			get_user(kp->m.offset, &up->m.offset))
+			return -EFAULT;
 		break;
 	case V4L2_MEMORY_USERPTR:
 		{

--=-=-=--
