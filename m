Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33420 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbcLGFIq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 00:08:46 -0500
Received: by mail-pg0-f54.google.com with SMTP id 3so157603500pgd.0
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 21:08:46 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 3/5] [media] davinci: vpif_capture: fix start/stop streaming locking
Date: Tue,  6 Dec 2016 21:08:24 -0800
Message-Id: <20161207050826.23174-4-khilman@baylibre.com>
In-Reply-To: <20161207050826.23174-1-khilman@baylibre.com>
References: <20161207050826.23174-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video capture subdevs may be over I2C and may sleep during xfer, so we
cannot do IRQ-disabled locking when calling the subdev.

The IRQ-disabled locking is meant to protect the DMA queue list
throughout the rest of the driver, so update the locking in
[start|stop]_streaming to protect just this list.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c24049acd40a..f72a719efb3d 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -179,8 +179,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long addr, flags;
 	int ret;
 
-	spin_lock_irqsave(&common->irqlock, flags);
-
 	/* Initialize field_id */
 	ch->field_id = 0;
 
@@ -211,6 +209,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	vpif_config_addr(ch, ret);
 
 	/* Get the next frame from the buffer queue */
+	spin_lock_irqsave(&common->irqlock, flags);
 	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
 				    struct vpif_cap_buffer, list);
 	/* Remove buffer from the buffer queue */
@@ -244,6 +243,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 err:
+	spin_lock_irqsave(&common->irqlock, flags);
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
@@ -287,7 +287,6 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		vpif_dbg(1, debug, "stream off failed in subdev\n");
 
 	/* release all active buffers */
-	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
 		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
@@ -300,6 +299,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 					VB2_BUF_STATE_ERROR);
 	}
 
+	spin_lock_irqsave(&common->irqlock, flags);
 	while (!list_empty(&common->dma_queue)) {
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
-- 
2.9.3

