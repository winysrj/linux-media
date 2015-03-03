Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23480 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbbCCOdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 09:33:18 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKN00HRE4FG1N60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Mar 2015 23:33:16 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com
Subject: [PATCH] s5p-mfc: Fix NULL pointer dereference caused by not set q->lock
Date: Tue, 03 Mar 2015 15:32:58 +0100
Message-id: <1425393178-27940-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch "media: s5p-mfc: use vb2_ops_wait_prepare/finish helper"
(654a731be1a0b6f606f3f3d12b50db08f2ae3c3) introduced a kernel panic.
The q->lock was set for just one queue, the other was not set thus causing
a NULL pointer dereference.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 9fe4d90..8333fbc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -833,6 +833,7 @@ static int s5p_mfc_open(struct file *file)
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	q->io_modes = VB2_MMAP;
 	q->drv_priv = &ctx->fh;
+	q->lock = &dev->mfc_mutex;
 	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-- 
1.7.9.5

