Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3111 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3BPKSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 05:18:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/5] fsl-viu: remove deprecated use of current_norm.
Date: Sat, 16 Feb 2013 11:18:26 +0100
Message-Id: <a381147b566f92fd8fb82643636f5175be9e0d4b.1361009701.git.hans.verkuil@cisco.com>
In-Reply-To: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
References: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
References: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was pointless anyway since fsl-viu already implements g_std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 961fc72..c7c1295 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1376,8 +1376,7 @@ static struct video_device viu_template = {
 	.ioctl_ops	= &viu_ioctl_ops,
 	.release	= video_device_release,
 
-	.tvnorms        = V4L2_STD_NTSC_M | V4L2_STD_PAL,
-	.current_norm   = V4L2_STD_NTSC_M,
+	.tvnorms        = V4L2_STD_ALL,
 };
 
 static int viu_of_probe(struct platform_device *op)
@@ -1452,6 +1451,7 @@ static int viu_of_probe(struct platform_device *op)
 	/* This control handler will inherit the control(s) from the
 	   sub-device(s). */
 	viu_dev->v4l2_dev.ctrl_handler = &viu_dev->hdl;
+	viu_dev->std = V4L2_STD_NTSC_M;
 	viu_dev->decoder = v4l2_i2c_new_subdev(&viu_dev->v4l2_dev, ad,
 			"saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
 
-- 
1.7.10.4

