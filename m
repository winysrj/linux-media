Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093AbbFJPfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 11:35:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] bdisp: remove unused var
Date: Wed, 10 Jun 2015 12:34:45 -0300
Message-Id: <1433950485-12994-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warning:

drivers/media/platform/sti/bdisp/bdisp-v4l2.c: In function 'bdisp_register_device':
drivers/media/platform/sti/bdisp/bdisp-v4l2.c:1024:26: warning: variable 'pdev' set but not used [-Wunused-but-set-variable]
  struct platform_device *pdev;

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 9a8405cd5216..9e782ebe18da 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -1021,14 +1021,11 @@ static const struct v4l2_ioctl_ops bdisp_ioctl_ops = {
 
 static int bdisp_register_device(struct bdisp_dev *bdisp)
 {
-	struct platform_device *pdev;
 	int ret;
 
 	if (!bdisp)
 		return -ENODEV;
 
-	pdev = bdisp->pdev;
-
 	bdisp->vdev.fops        = &bdisp_fops;
 	bdisp->vdev.ioctl_ops   = &bdisp_ioctl_ops;
 	bdisp->vdev.release     = video_device_release_empty;
-- 
2.4.2

