Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54114 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbcHRKXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 06:23:25 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <laurent.pinchart@ideasonboard.com>
CC: <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
	<linux@armlinux.org.uk>
Subject: [PATCH] [media] v4l: omap_vout: vrfb: Convert to dmaengine
Date: Thu, 18 Aug 2016 13:22:59 +0300
Message-ID: <20160818102259.5815-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dmaengine driver for sDMA now have support for interleaved transfer.
This trasnfer type was open coded with the legacy omap-dma API, but now
we can move it to dmaengine.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
The dmaengine driver for sDMA now have support for interleaved transfer.
This trasnfer type was open coded with the legacy omap-dma API, but now
we can move it to dmaengine.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi,

I do not have access to any hardware where I could test if the conversion works
correctly. I think it should. The dmaengine part looks fine to me - not that
this means too much as I have written it ;)
Based on debugging the code with starring at it I think the old and the new way
would end up setting up the DMA in a same way. However the dmaengine driver will
set CSDP_DST_PACKED | CSDP_SRC_PACKED.

Laurent: would you be able to test this?

Regards,
Peter

 drivers/media/platform/omap/omap_vout_vrfb.c | 133 ++++++++++++++++-----------
 drivers/media/platform/omap/omap_voutdef.h   |   6 +-
 2 files changed, 83 insertions(+), 56 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index b8638e4e1627..957ff7621652 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -16,7 +16,6 @@
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>

-#include <linux/omap-dma.h>
 #include <video/omapvrfb.h>

 #include "omap_voutdef.h"
@@ -63,7 +62,7 @@ static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
 /*
  * Wakes up the application once the DMA transfer to VRFB space is completed.
  */
-static void omap_vout_vrfb_dma_tx_callback(int lch, u16 ch_status, void *data)
+static void omap_vout_vrfb_dma_tx_callback(void *data)
 {
 	struct vid_vrfb_dma *t = (struct vid_vrfb_dma *) data;

@@ -94,6 +93,7 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 	int ret = 0, i, j;
 	struct omap_vout_device *vout;
 	struct video_device *vfd;
+	dma_cap_mask_t mask;
 	int image_width, image_height;
 	int vrfb_num_bufs = VRFB_NUM_BUFS;
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
@@ -131,17 +131,26 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 	/*
 	 * Request and Initialize DMA, for DMA based VRFB transfer
 	 */
-	vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
-	vout->vrfb_dma_tx.dma_ch = -1;
-	vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
-	ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
-			omap_vout_vrfb_dma_tx_callback,
-			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
-	if (ret < 0) {
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_INTERLEAVE, mask);
+	vout->vrfb_dma_tx.chan = dma_request_chan_by_mask(&mask);
+	if (IS_ERR(vout->vrfb_dma_tx.chan)) {
 		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+	} else {
+		size_t xt_size = sizeof(struct dma_interleaved_template) +
+				 sizeof(struct data_chunk);
+
+		vout->vrfb_dma_tx.xt = kzalloc(xt_size, GFP_KERNEL);
+		if (!vout->vrfb_dma_tx.xt) {
+			dma_release_channel(vout->vrfb_dma_tx.chan);
+			vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+		}
+	}
+
+	if (vout->vrfb_dma_tx.req_status == DMA_CHAN_NOT_ALLOTED)
 		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
 				" video%d\n", vfd->minor);
-	}
+
 	init_waitqueue_head(&vout->vrfb_dma_tx.wait);

 	/* statically allocated the VRFB buffer is done through
@@ -176,7 +185,9 @@ void omap_vout_release_vrfb(struct omap_vout_device *vout)

 	if (vout->vrfb_dma_tx.req_status == DMA_CHAN_ALLOTED) {
 		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
-		omap_free_dma(vout->vrfb_dma_tx.dma_ch);
+		kfree(vout->vrfb_dma_tx.xt);
+		dmaengine_terminate_sync(vout->vrfb_dma_tx.chan);
+		dma_release_channel(vout->vrfb_dma_tx.chan);
 	}
 }

@@ -218,70 +229,84 @@ int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
 }

 int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
-				struct videobuf_buffer *vb)
+			   struct videobuf_buffer *vb)
 {
-	dma_addr_t dmabuf;
-	struct vid_vrfb_dma *tx;
+	struct dma_async_tx_descriptor *tx;
+	enum dma_ctrl_flags flags;
+	struct dma_chan *chan = vout->vrfb_dma_tx.chan;
+	struct dma_device *dmadev = chan->device;
+	struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
+	dma_cookie_t cookie;
+	enum dma_status status;
 	enum dss_rotation rotation;
-	u32 dest_frame_index = 0, src_element_index = 0;
-	u32 dest_element_index = 0, src_frame_index = 0;
-	u32 elem_count = 0, frame_count = 0, pixsize = 2;
+	size_t dst_icg;
+	u32 pixsize;

 	if (!is_rotation_enabled(vout))
 		return 0;

-	dmabuf = vout->buf_phy_addr[vb->i];
 	/* If rotation is enabled, copy input buffer into VRFB
 	 * memory space using DMA. We are copying input buffer
 	 * into VRFB memory space of desired angle and DSS will
 	 * read image VRFB memory for 0 degree angle
 	 */
+
 	pixsize = vout->bpp * vout->vrfb_bpp;
-	/*
-	 * DMA transfer in double index mode
-	 */
+	dst_icg = ((MAX_PIXELS_PER_LINE * pixsize) -
+		  (vout->pix.width * vout->bpp)) + 1;
+
+	xt->src_start = vout->buf_phy_addr[vb->i];
+	xt->dst_start = vout->vrfb_context[vb->i].paddr[0];
+
+	xt->numf = vout->pix.height;
+	xt->frame_size = 1;
+	xt->sgl[0].size = vout->pix.width * vout->bpp;
+	xt->sgl[0].icg = dst_icg;
+
+	xt->dir = DMA_MEM_TO_MEM;
+	xt->src_sgl = false;
+	xt->src_inc = true;
+	xt->dst_sgl = true;
+	xt->dst_inc = true;
+
+	tx = dmadev->device_prep_interleaved_dma(chan, xt, flags);
+	if (tx == NULL) {
+		pr_err("%s: DMA interleaved prep error\n", __func__);
+		return -EINVAL;
+	}

-	/* Frame index */
-	dest_frame_index = ((MAX_PIXELS_PER_LINE * pixsize) -
-			(vout->pix.width * vout->bpp)) + 1;
-
-	/* Source and destination parameters */
-	src_element_index = 0;
-	src_frame_index = 0;
-	dest_element_index = 1;
-	/* Number of elements per frame */
-	elem_count = vout->pix.width * vout->bpp;
-	frame_count = vout->pix.height;
-	tx = &vout->vrfb_dma_tx;
-	tx->tx_status = 0;
-	omap_set_dma_transfer_params(tx->dma_ch, OMAP_DMA_DATA_TYPE_S32,
-			(elem_count / 4), frame_count, OMAP_DMA_SYNC_ELEMENT,
-			tx->dev_id, 0x0);
-	/* src_port required only for OMAP1 */
-	omap_set_dma_src_params(tx->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
-			dmabuf, src_element_index, src_frame_index);
-	/*set dma source burst mode for VRFB */
-	omap_set_dma_src_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
-	rotation = calc_rotation(vout);
+	tx->callback = omap_vout_vrfb_dma_tx_callback;
+	tx->callback_param = &vout->vrfb_dma_tx;
+
+	cookie = dmaengine_submit(tx);
+	if (dma_submit_error(cookie)) {
+		pr_err("%s: dmaengine_submit failed (%d)\n", __func__, cookie);
+		return -EINVAL;
+	}

-	/* dest_port required only for OMAP1 */
-	omap_set_dma_dest_params(tx->dma_ch, 0, OMAP_DMA_AMODE_DOUBLE_IDX,
-			vout->vrfb_context[vb->i].paddr[0], dest_element_index,
-			dest_frame_index);
-	/*set dma dest burst mode for VRFB */
-	omap_set_dma_dest_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
-	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
+	vout->vrfb_dma_tx.tx_status = 0;
+	dma_async_issue_pending(chan);

-	omap_start_dma(tx->dma_ch);
-	wait_event_interruptible_timeout(tx->wait, tx->tx_status == 1,
+	wait_event_interruptible_timeout(vout->vrfb_dma_tx.wait,
+					 vout->vrfb_dma_tx.tx_status == 1,
 					 VRFB_TX_TIMEOUT);

-	if (tx->tx_status == 0) {
-		omap_stop_dma(tx->dma_ch);
+	status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
+
+	if (vout->vrfb_dma_tx.tx_status == 0) {
+		pr_err("%s: Timeout while waiting for DMA\n", __func__);
+		dmaengine_terminate_sync(chan);
+		return -EINVAL;
+	} else if (status != DMA_COMPLETE) {
+		pr_err("%s: DMA completion %s status\n", __func__,
+		       status == DMA_ERROR ? "error" : "busy");
+		dmaengine_terminate_sync(chan);
 		return -EINVAL;
 	}
+
 	/* Store buffers physical address into an array. Addresses
 	 * from this array will be used to configure DSS */
+	rotation = calc_rotation(vout);
 	vout->queued_buf_addr[vb->i] = (u8 *)
 		vout->vrfb_context[vb->i].paddr[rotation];
 	return 0;
diff --git a/drivers/media/platform/omap/omap_voutdef.h b/drivers/media/platform/omap/omap_voutdef.h
index 80c79fabdf95..56b630b1c8b4 100644
--- a/drivers/media/platform/omap/omap_voutdef.h
+++ b/drivers/media/platform/omap/omap_voutdef.h
@@ -14,6 +14,7 @@
 #include <media/v4l2-ctrls.h>
 #include <video/omapfb_dss.h>
 #include <video/omapvrfb.h>
+#include <linux/dmaengine.h>

 #define YUYV_BPP        2
 #define RGB565_BPP      2
@@ -81,8 +82,9 @@ enum vout_rotaion_type {
  * for VRFB hidden buffer
  */
 struct vid_vrfb_dma {
-	int dev_id;
-	int dma_ch;
+	struct dma_chan *chan;
+	struct dma_interleaved_template *xt;
+
 	int req_status;
 	int tx_status;
 	wait_queue_head_t wait;
--
2.9.2

