Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2885 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1FNHO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 10/10] v4l2-ioctl.c: check for valid tuner type in S_HW_FREQ_SEEK.
Date: Tue, 14 Jun 2011 09:14:42 +0200
Message-Id: <aec4ab9a3c1dacba4f9a6633b2603fdf0c29f3a8.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Prohibit attempts to change the tuner to a type that is different
from the device node the ioctl is called from. I.e. the type must
be RADIO for a radio node and ANALOG_TV for a video/vbi node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 26bf3bf..55df143 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1946,13 +1946,19 @@ static long __video_do_ioctl(struct file *file,
 	case VIDIOC_S_HW_FREQ_SEEK:
 	{
 		struct v4l2_hw_freq_seek *p = arg;
+		enum v4l2_tuner_type type;
 
 		if (!ops->vidioc_s_hw_freq_seek)
 			break;
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd,
-			"tuner=%d, type=%d, seek_upward=%d, wrap_around=%d\n",
-			p->tuner, p->type, p->seek_upward, p->wrap_around);
-		ret = ops->vidioc_s_hw_freq_seek(file, fh, p);
+			"tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u\n",
+			p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing);
+		if (p->type != type)
+			ret = -EINVAL;
+		else
+			ret = ops->vidioc_s_hw_freq_seek(file, fh, p);
 		break;
 	}
 	case VIDIOC_ENUM_FRAMESIZES:
-- 
1.7.1

