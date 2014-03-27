Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbaC0VeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 17:34:10 -0400
Date: Thu, 27 Mar 2014 22:34:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility
 mode
Message-ID: <Pine.LNX.4.64.1403272206410.18471@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turns out, that 64-bit compilations sometimes align structs within 
other structs on 32-bit boundaries, but in other cases alignment is done 
on 64-bit boundaries, adding padding if necessary. This is done, for 
example when the embedded struct contains a pointer. This is the case with 
struct v4l2_window, which is embedded into struct v4l2_format, and that 
one is embedded into struct v4l2_create_buffers. Unlike some other 
structs, used as a part of the kernel ABI as ioctl() arguments, that are 
packed, these structs aren't packed. This isn't a problem per se, but it 
turns out, that the ioctl-compat code for VIDIOC_CREATE_BUFS contains a 
bug, that triggers in such 64-bit builds. That code wrongly assumes, that 
in struct v4l2_create_buffers, struct v4l2_format immediately follows the 
__u32 memory field, which in fact isn't the case. This bug wasn't visible 
until now, because until recently hardly any applications used this 
ioctl() and mostly embedded 32-bit only drivers implemented it. This is 
changing now with addition of this ioctl() to some USB drivers, e.g. UVC. 
This patch fixes the bug by copying parts of struct v4l2_create_buffers 
separately.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

It's probably too late for 3.14, but maybe after pushing it into 3.15 we 
have to send it to stable.

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 04b2daf..28f87d7 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -213,8 +213,9 @@ static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
-	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format.fmt)))
-			return -EFAULT;
+	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format)) ||
+	    get_user(kp->format.type, &up->format.type))
+		return -EFAULT;
 	return __get_v4l2_format32(&kp->format, &up->format);
 }
 
