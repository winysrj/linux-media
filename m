Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4140 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3FCJhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [RFC PATCH 03/13] sh_vou: remove current_norm
Date: Mon,  3 Jun 2013 11:36:40 +0200
Message-Id: <1370252210-4994-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current_norm field is deprecated and is replaced by g_std. This driver
already implements g_std, so just remove current_norm.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/sh_vou.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 7d02350..84625fa 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1313,7 +1313,6 @@ static const struct video_device sh_vou_video_template = {
 	.fops		= &sh_vou_fops,
 	.ioctl_ops	= &sh_vou_ioctl_ops,
 	.tvnorms	= V4L2_STD_525_60, /* PAL only supported in 8-bit non-bt656 mode */
-	.current_norm	= V4L2_STD_NTSC_M,
 	.vfl_dir	= VFL_DIR_TX,
 };
 
@@ -1352,7 +1351,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	pix = &vou_dev->pix;
 
 	/* Fill in defaults */
-	vou_dev->std		= sh_vou_video_template.current_norm;
+	vou_dev->std		= V4L2_STD_NTSC_M;
 	rect->left		= 0;
 	rect->top		= 0;
 	rect->width		= VOU_MAX_IMAGE_WIDTH;
-- 
1.7.10.4

