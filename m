Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4651 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3BZRgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/11] s2255: don't zero struct v4l2_streamparm
Date: Tue, 26 Feb 2013 18:35:43 +0100
Message-Id: <81909fd798e35d06599fe41a106c94edb5b55c1f.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All fields after 'type' are already zeroed by the core framework.
Clearing the full struct also clears 'type', which causes a wrong
type value to be returned.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 9693eb9..eaae9d1 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1476,7 +1476,6 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	struct s2255_channel *channel = fh->channel;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	memset(sp, 0, sizeof(struct v4l2_streamparm));
 	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 	sp->parm.capture.capturemode = channel->cap_parm.capturemode;
 	def_num = (channel->mode.format == FORMAT_NTSC) ? 1001 : 1000;
-- 
1.7.10.4

