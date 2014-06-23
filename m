Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:50786 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754617AbaFWNm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 07/22] media: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:35 -0700
Message-Id: <a7fe4c3fb2422b3c2eaaebe4772c36469906a303.1403530604.git.joe@perches.com>
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/saa7146/saa7146_core.c       | 15 ++++++---------
 drivers/media/common/saa7146/saa7146_fops.c       |  5 +++--
 drivers/media/pci/bt8xx/bt878.c                   | 16 ++++------------
 drivers/media/pci/ngene/ngene-core.c              |  7 +++----
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 11 +++--------
 drivers/media/usb/ttusb-dec/ttusb_dec.c           | 11 +++--------
 6 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index 34b0d0d..97afee6 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -421,23 +421,20 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	err = -ENOMEM;
 
 	/* get memory for various stuff */
-	dev->d_rps0.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						    &dev->d_rps0.dma_handle);
+	dev->d_rps0.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						     &dev->d_rps0.dma_handle);
 	if (!dev->d_rps0.cpu_addr)
 		goto err_free_irq;
-	memset(dev->d_rps0.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
-	dev->d_rps1.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						    &dev->d_rps1.dma_handle);
+	dev->d_rps1.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						     &dev->d_rps1.dma_handle);
 	if (!dev->d_rps1.cpu_addr)
 		goto err_free_rps0;
-	memset(dev->d_rps1.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
-	dev->d_i2c.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						   &dev->d_i2c.dma_handle);
+	dev->d_i2c.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						    &dev->d_i2c.dma_handle);
 	if (!dev->d_i2c.cpu_addr)
 		goto err_free_rps1;
-	memset(dev->d_i2c.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
 	/* the rest + print status message */
 
diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index eda01bc..a776a80 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -520,14 +520,15 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	   configuration data) */
 	dev->ext_vv_data = ext_vv;
 
-	vv->d_clipping.cpu_addr = pci_alloc_consistent(dev->pci, SAA7146_CLIPPING_MEM, &vv->d_clipping.dma_handle);
+	vv->d_clipping.cpu_addr =
+		pci_zalloc_consistent(dev->pci, SAA7146_CLIPPING_MEM,
+				      &vv->d_clipping.dma_handle);
 	if( NULL == vv->d_clipping.cpu_addr ) {
 		ERR("out of memory. aborting.\n");
 		kfree(vv);
 		v4l2_ctrl_handler_free(hdl);
 		return -1;
 	}
-	memset(vv->d_clipping.cpu_addr, 0x0, SAA7146_CLIPPING_MEM);
 
 	saa7146_video_uops.init(dev,vv);
 	if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index d0c281f..1176583 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -101,28 +101,20 @@ static int bt878_mem_alloc(struct bt878 *bt)
 	if (!bt->buf_cpu) {
 		bt->buf_size = 128 * 1024;
 
-		bt->buf_cpu =
-		    pci_alloc_consistent(bt->dev, bt->buf_size,
-					 &bt->buf_dma);
-
+		bt->buf_cpu = pci_zalloc_consistent(bt->dev, bt->buf_size,
+						    &bt->buf_dma);
 		if (!bt->buf_cpu)
 			return -ENOMEM;
-
-		memset(bt->buf_cpu, 0, bt->buf_size);
 	}
 
 	if (!bt->risc_cpu) {
 		bt->risc_size = PAGE_SIZE;
-		bt->risc_cpu =
-		    pci_alloc_consistent(bt->dev, bt->risc_size,
-					 &bt->risc_dma);
-
+		bt->risc_cpu = pci_zalloc_consistent(bt->dev, bt->risc_size,
+						     &bt->risc_dma);
 		if (!bt->risc_cpu) {
 			bt878_mem_free(bt);
 			return -ENOMEM;
 		}
-
-		memset(bt->risc_cpu, 0, bt->risc_size);
 	}
 
 	return 0;
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 970e833..37dc149 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1078,12 +1078,11 @@ static int AllocCommonBuffers(struct ngene *dev)
 	dev->ngenetohost = dev->FWInterfaceBuffer + 256;
 	dev->EventBuffer = dev->FWInterfaceBuffer + 512;
 
-	dev->OverflowBuffer = pci_alloc_consistent(dev->pci_dev,
-						   OVERFLOW_BUFFER_SIZE,
-						   &dev->PAOverflowBuffer);
+	dev->OverflowBuffer = pci_zalloc_consistent(dev->pci_dev,
+						    OVERFLOW_BUFFER_SIZE,
+						    &dev->PAOverflowBuffer);
 	if (!dev->OverflowBuffer)
 		return -ENOMEM;
-	memset(dev->OverflowBuffer, 0, OVERFLOW_BUFFER_SIZE);
 
 	for (i = STREAM_VIDEOIN1; i < MAX_STREAM; i++) {
 		int type = dev->card_info->io_type[i];
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index f8a60c1..0d3194a 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -804,11 +804,9 @@ static int ttusb_alloc_iso_urbs(struct ttusb *ttusb)
 {
 	int i;
 
-	ttusb->iso_buffer = pci_alloc_consistent(NULL,
-						 ISO_FRAME_SIZE *
-						 FRAMES_PER_ISO_BUF *
-						 ISO_BUF_COUNT,
-						 &ttusb->iso_dma_handle);
+	ttusb->iso_buffer = pci_zalloc_consistent(NULL,
+						  ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
+						  &ttusb->iso_dma_handle);
 
 	if (!ttusb->iso_buffer) {
 		dprintk("%s: pci_alloc_consistent - not enough memory\n",
@@ -816,9 +814,6 @@ static int ttusb_alloc_iso_urbs(struct ttusb *ttusb)
 		return -ENOMEM;
 	}
 
-	memset(ttusb->iso_buffer, 0,
-	       ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT);
-
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		struct urb *urb;
 
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 29724af..15ab584 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1151,11 +1151,9 @@ static int ttusb_dec_alloc_iso_urbs(struct ttusb_dec *dec)
 
 	dprintk("%s\n", __func__);
 
-	dec->iso_buffer = pci_alloc_consistent(NULL,
-					       ISO_FRAME_SIZE *
-					       (FRAMES_PER_ISO_BUF *
-						ISO_BUF_COUNT),
-					       &dec->iso_dma_handle);
+	dec->iso_buffer = pci_zalloc_consistent(NULL,
+						ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF * ISO_BUF_COUNT),
+						&dec->iso_dma_handle);
 
 	if (!dec->iso_buffer) {
 		dprintk("%s: pci_alloc_consistent - not enough memory\n",
@@ -1163,9 +1161,6 @@ static int ttusb_dec_alloc_iso_urbs(struct ttusb_dec *dec)
 		return -ENOMEM;
 	}
 
-	memset(dec->iso_buffer, 0,
-	       ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF * ISO_BUF_COUNT));
-
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		struct urb *urb;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

