Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:35357 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932909AbcFIBfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2016 21:35:18 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
Date: Wed,  8 Jun 2016 19:35:15 -0600
Message-Id: <1465436115-13880-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_mfc_remove() fails to release encoder and decoder video devices.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 274b4f1..af61f54 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1317,7 +1317,9 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	destroy_workqueue(dev->watchdog_workqueue);
 
 	video_unregister_device(dev->vfd_enc);
+	video_device_release(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
+	video_device_release(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
-- 
2.7.4

