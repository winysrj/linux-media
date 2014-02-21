Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:18941 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaBUCTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 21:19:45 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1B00M30QGO5O10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Feb 2014 11:19:36 +0900 (KST)
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com
Subject: [PATCH] s5p-mfc: Replaced commas with semicolons.
Date: Fri, 21 Feb 2014 11:19:33 +0900
Message-id: <1392949173-17990-1-git-send-email-jy0922.shim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is any reason to use comma here.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e2aac59..90f4f69 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1147,9 +1147,9 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_dec_alloc;
 	}
-	vfd->fops	= &s5p_mfc_fops,
+	vfd->fops	= &s5p_mfc_fops;
 	vfd->ioctl_ops	= get_dec_v4l2_ioctl_ops();
-	vfd->release	= video_device_release,
+	vfd->release	= video_device_release;
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->vfl_dir	= VFL_DIR_M2M;
@@ -1172,9 +1172,9 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_enc_alloc;
 	}
-	vfd->fops	= &s5p_mfc_fops,
+	vfd->fops	= &s5p_mfc_fops;
 	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
-	vfd->release	= video_device_release,
+	vfd->release	= video_device_release;
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->vfl_dir	= VFL_DIR_M2M;
-- 
1.8.1.2

