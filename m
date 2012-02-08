Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:15560 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2BHMKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 07:10:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] -EINVAL -> -ENOTTY
Date: Wed, 8 Feb 2012 13:09:36 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202081309.36371.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found one more place where -EINVAL is used instead of -ENOTTY:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Note that drivers/media/dvb/dvb-core/dvbdev.c has the same code, but as far as
I can tell DVB is still using -EINVAL for unknown ioctls so I didn't change
that.

Regards,

	Hans

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index d0d7281..52657fd 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2421,7 +2421,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	/* Handles IOCTL */
 	err = func(file, cmd, parg);
 	if (err == -ENOIOCTLCMD)
-		err = -EINVAL;
+		err = -ENOTTY;
 
 	if (has_array_args) {
 		*kernel_ptr = user_ptr;
