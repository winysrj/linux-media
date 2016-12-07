Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35688 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932502AbcLGSab (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 13:30:31 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so164614698pga.2
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 10:30:31 -0800 (PST)
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
Subject: [PATCH v6 3/5] [media] davinci: vpif_capture: fix start/stop streaming locking
Date: Wed,  7 Dec 2016 10:30:23 -0800
Message-Id: <20161207183025.20684-4-khilman@baylibre.com>
In-Reply-To: <20161207183025.20684-1-khilman@baylibre.com>
References: <20161207183025.20684-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video capture subdevs may be over I2C and may sleep during xfer, so we
cannot do IRQ-disabled locking when calling the subdev.

The IRQ-disabled locking is meant to protect the DMA queue list
throughout the rest of the driver, so update the locking in
[start|stop]_streaming to protect just this list, and update the irqlock
comment to reflect what it actually protects.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 6 +++---
 drivers/media/platform/davinci/vpif_capture.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 9e35b6771d22..1d2c052deedf 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -67,7 +67,7 @@ struct common_obj {
 	struct vb2_queue buffer_queue;
 	/* Queue of filled frames */
 	struct list_head dma_queue;
-	/* Used in video-buf */
+	/* Protects the dma_queue field */
 	spinlock_t irqlock;
 	/* lock used to access this structure */
 	struct mutex lock;
-- 
2.9.3

