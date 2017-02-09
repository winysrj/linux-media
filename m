Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51860
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932355AbdBIWLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 17:11:22 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p_mfc - remove unneeded io_modes initialzation in s5p_mfc_open()
Date: Thu,  9 Feb 2017 15:11:17 -0700
Message-Id: <20170209221117.26381-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded io_modes initialzation in s5p_mfc_open(). It gets done
right below in vdev == dev->vfd_dec conditional.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index bb0a588..20beaa2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -866,7 +866,6 @@ static int s5p_mfc_open(struct file *file)
 	/* Init videobuf2 queue for OUTPUT */
 	q = &ctx->vq_src;
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	q->io_modes = VB2_MMAP;
 	q->drv_priv = &ctx->fh;
 	q->lock = &dev->mfc_mutex;
 	if (vdev == dev->vfd_dec) {
-- 
2.7.4

