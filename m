Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64396 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2JDKzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 06:55:19 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD002EB7NZUOU0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 19:55:17 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBD00M257NWB340@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 19:55:16 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH] [media] s5p-mfc: Set vfl_dir for encoder
Date: Fri, 05 Oct 2012 00:44:56 +0530
Message-id: <1349378096-15696-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vfl_dir flag is presently set to VFL_DIR_M2M only for decoder.
The encoder is not working because of this. So adding this flag
to the encoder part also.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index aa55133..130f4ac 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1155,6 +1155,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->release	= video_device_release,
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
+	vfd->vfl_dir	= VFL_DIR_M2M;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
 	dev->vfd_enc	= vfd;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-- 
1.7.0.4

