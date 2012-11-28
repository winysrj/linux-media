Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:39387 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2K1UPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 15:15:54 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] soc_camera: fix VIDIOC_S_GROP ioctl
Date: Wed, 28 Nov 2012 21:15:51 +0100
Message-Id: <1354133751-31985-1-git-send-email-agust@denx.de>
In-Reply-To: <Pine.LNX.4.64.1211261618390.11501@axis700.grange>
References: <Pine.LNX.4.64.1211261618390.11501@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes VIDIOC_S_GROP ioctl doesn't work, soc-camera driver reports:

soc-camera-pdrv soc-camera-pdrv.0: S_CROP denied: getting current crop failed

The VIDIOC_G_CROP documentation states that the type field needs to be
set to the respective buffer type when querying, so the check in .g_crop()
of the subdevices returns -EINVAL if the type is not set properly. Here the
uninitialized local variable 'current_crop' is passed to the .g_crop() and
this leads to the observed error. Initialize the type field of the local
'current_crop' before get_crop call.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d3f0b84..7ebc784 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -902,6 +902,8 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
 		rect->width, rect->height, rect->left, rect->top);
 
+	current_crop.type = a->type;
+
 	/* If get_crop fails, we'll let host and / or client drivers decide */
 	ret = ici->ops->get_crop(icd, &current_crop);
 
-- 
1.7.1

