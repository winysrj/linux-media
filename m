Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49873 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413AbZJMPHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:07:34 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DF6sPm022672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:06:57 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/6] Davinci VPFE Capture: Specify device pointer in videobuf_queue_dma_contig_init
Date: Tue, 13 Oct 2009 20:36:52 +0530
Message-Id: <1255446412-16642-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index ff43446..dc32de0 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1547,7 +1547,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	vpfe_dev->memory = req_buf->memory;
 	videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
 				&vpfe_videobuf_qops,
-				NULL,
+				vpfe_dev->pdev,
 				&vpfe_dev->irqlock,
 				req_buf->type,
 				vpfe_dev->fmt.fmt.pix.field,
-- 
1.6.2.4

