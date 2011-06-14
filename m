Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3950 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1FNHOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 03/10] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner.
Date: Tue, 14 Jun 2011 09:14:35 +0200
Message-Id: <c15382a416f0f95a9569647da5bae590bee2cefa.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The subdevs are supposed to receive a valid tuner type for the g_frequency
and g/s_tuner subdev ops. Some drivers do this, others don't. So prefill
this in v4l2-ioctl.c based on whether the device node from which this is
called is a radio node or not.

The spec does not require applications to fill in the type, and if they
leave it at 0 then the 'check_mode' call in tuner-core.c will return
an error and the ioctl does nothing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 213ba7d..26bf3bf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1822,6 +1822,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_tuner)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1840,6 +1842,8 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
 				"capability=0x%x, rangelow=%d, "
 				"rangehigh=%d, signal=%d, afc=%d, "
@@ -1858,6 +1862,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_frequency)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
-- 
1.7.1

