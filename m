Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4452 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935469Ab3DHKr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:47:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/7] radio-si4713: remove audout ioctls
Date: Mon,  8 Apr 2013 12:47:35 +0200
Message-Id: <1365418061-23694-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The audout ioctls are not appropriate for radio transmitters, they apply to
video output devices only. Remove them from this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-si4713.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 38b3f15..320f301 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -59,35 +59,6 @@ static const struct v4l2_file_operations radio_si4713_fops = {
 };
 
 /* Video4Linux Interface */
-static int radio_si4713_fill_audout(struct v4l2_audioout *vao)
-{
-	/* TODO: check presence of audio output */
-	strlcpy(vao->name, "FM Modulator Audio Out", 32);
-
-	return 0;
-}
-
-static int radio_si4713_enumaudout(struct file *file, void *priv,
-						struct v4l2_audioout *vao)
-{
-	return radio_si4713_fill_audout(vao);
-}
-
-static int radio_si4713_g_audout(struct file *file, void *priv,
-					struct v4l2_audioout *vao)
-{
-	int rval = radio_si4713_fill_audout(vao);
-
-	vao->index = 0;
-
-	return rval;
-}
-
-static int radio_si4713_s_audout(struct file *file, void *priv,
-					const struct v4l2_audioout *vao)
-{
-	return vao->index ? -EINVAL : 0;
-}
 
 /* radio_si4713_querycap - query device capabilities */
 static int radio_si4713_querycap(struct file *file, void *priv,
@@ -229,9 +200,6 @@ static long radio_si4713_default(struct file *file, void *p,
 }
 
 static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
-	.vidioc_enumaudout	= radio_si4713_enumaudout,
-	.vidioc_g_audout	= radio_si4713_g_audout,
-	.vidioc_s_audout	= radio_si4713_s_audout,
 	.vidioc_querycap	= radio_si4713_querycap,
 	.vidioc_queryctrl	= radio_si4713_queryctrl,
 	.vidioc_g_ext_ctrls	= radio_si4713_g_ext_ctrls,
-- 
1.7.10.4

