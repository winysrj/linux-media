Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2533 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3BJMuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 04/19] bttv: remove g/s_audio since there is only one audio input.
Date: Sun, 10 Feb 2013 13:49:59 +0100
Message-Id: <0681941b222b6cc9c0bb288f81019d4f90c9d683.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 6e61dbd..a02c031 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3138,23 +3138,6 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 	return 0;
 }
 
-static int bttv_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	strcpy(a->name, "audio");
-	return 0;
-}
-
-static int bttv_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
-
-	return 0;
-}
-
 static ssize_t bttv_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
@@ -3390,8 +3373,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_g_fmt_vbi_cap           = bttv_g_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap         = bttv_try_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap           = bttv_s_fmt_vbi_cap,
-	.vidioc_g_audio                 = bttv_g_audio,
-	.vidioc_s_audio                 = bttv_s_audio,
 	.vidioc_cropcap                 = bttv_cropcap,
 	.vidioc_reqbufs                 = bttv_reqbufs,
 	.vidioc_querybuf                = bttv_querybuf,
-- 
1.7.10.4

