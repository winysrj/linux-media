Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:18079 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755650AbdLOU7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 15:59:40 -0500
From: Sushmita Susheelendra <ssusheel@codeaurora.org>
To: labbott@redhat.com
Cc: sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org,
        Sushmita Susheelendra <ssusheel@codeaurora.org>
Subject: [PATCH] staging: android: ion: Fix dma direction for dma_sync_sg_for_cpu/device
Date: Fri, 15 Dec 2017 13:59:13 -0700
Message-Id: <1513371553-24774-1-git-send-email-ssusheel@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the direction argument passed into begin_cpu_access
and end_cpu_access when calling the dma_sync_sg_for_cpu/device.
The actual cache primitive called depends on the direction
passed in.

Signed-off-by: Sushmita Susheelendra <ssusheel@codeaurora.org>
---
 drivers/staging/android/ion/ion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index a7d9b0e..f480885 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -346,7 +346,7 @@ static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		dma_sync_sg_for_cpu(a->dev, a->table->sgl, a->table->nents,
-				    DMA_BIDIRECTIONAL);
+				    direction);
 	}
 	mutex_unlock(&buffer->lock);
 
@@ -368,7 +368,7 @@ static int ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
 	mutex_lock(&buffer->lock);
 	list_for_each_entry(a, &buffer->attachments, list) {
 		dma_sync_sg_for_device(a->dev, a->table->sgl, a->table->nents,
-				       DMA_BIDIRECTIONAL);
+				       direction);
 	}
 	mutex_unlock(&buffer->lock);
 
-- 
1.9.1
