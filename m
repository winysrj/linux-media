Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3173 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161456Ab3BOMzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/10] au0828: add try_fmt_vbi support, zero vbi.reserved.
Date: Fri, 15 Feb 2013 13:55:11 +0100
Message-Id: <ca7a4df9ec61479426fa16ab270e6721d9a6b617.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 07287ef..17635e5 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1595,6 +1595,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	format->fmt.vbi.count[1] = dev->vbi_height;
 	format->fmt.vbi.start[0] = 21;
 	format->fmt.vbi.start[1] = 284;
+	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	return 0;
 }
@@ -1878,6 +1879,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap     = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
+	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_enumaudio           = vidioc_enumaudio,
 	.vidioc_g_audio             = vidioc_g_audio,
-- 
1.7.10.4

