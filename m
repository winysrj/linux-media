Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2432 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3FCJh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Anatolij Gustschin <agust@denx.de>
Subject: [RFC PATCH 06/13] fsl-viu: remove current_norm.
Date: Mon,  3 Jun 2013 11:36:43 +0200
Message-Id: <1370252210-4994-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of current_norm is deprecated, so remove it. This driver actually
already implements g_std, which overrides current_norm, but the 'std' field
was never initialized correctly. This has been fixed as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/platform/fsl-viu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 3a6a0dc..221ec42 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1475,7 +1475,6 @@ static struct video_device viu_template = {
 	.release	= video_device_release,
 
 	.tvnorms        = V4L2_STD_NTSC_M | V4L2_STD_PAL,
-	.current_norm   = V4L2_STD_NTSC_M,
 };
 
 static int viu_of_probe(struct platform_device *op)
@@ -1546,6 +1545,7 @@ static int viu_of_probe(struct platform_device *op)
 	viu_dev->vidq.timeout.function = viu_vid_timeout;
 	viu_dev->vidq.timeout.data     = (unsigned long)viu_dev;
 	init_timer(&viu_dev->vidq.timeout);
+	viu_dev->std = V4L2_STD_NTSC_M;
 	viu_dev->first = 1;
 
 	/* Allocate memory for video device */
-- 
1.7.10.4

