Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49429 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2IXK40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 06:56:26 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control framework
Date: Mon, 24 Sep 2012 12:58:51 +0200
Message-Id: <1348484332-8106-3-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch re-write the driver and use the videobuf2
interface instead of the old videobuf. Moreover, it uses also
the control framework which allows the driver to inherit
controls from its subdevice (ADV7180)

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/media/pci/sta2x11/Kconfig       |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c | 1238 ++++++++++---------------------
 2 file modificati, 407 inserzioni(+), 833 rimozioni(-)

diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 6749f67..654339f 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -2,7 +2,7 @@ config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_STREAMING
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
 	help
 	  Say Y for support for STA2X11 VIP (Video Input Port) capture
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 4c10205..b9ff926 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1,6 +1,7 @@
 /*
  * This is the driver for the STA2x11 Video Input Port.
  *
+ * Copyright (C) 2012       ST Microelectronics
  * Copyright (C) 2010       WindRiver Systems, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -19,36 +20,30 @@
  * The full GNU General Public License is included in this distribution in
  * the file called "COPYING".
  *
- * Author: Andreas Kies <andreas.kies@windriver.com>
- *		Vlad Lungu <vlad.lungu@windriver.com>
- *
  */
 
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/vmalloc.h>
-
 #include <linux/videodev2.h>
-
 #include <linux/kmod.h>
-
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf-dma-contig.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/videobuf2-dma-streaming.h>
 
 #include "sta2x11_vip.h"
 
-#define DRV_NAME "sta2x11_vip"
 #define DRV_VERSION "1.3"
 
 #ifndef PCI_DEVICE_ID_STMICRO_VIP
@@ -63,8 +58,8 @@
 #define DVP_TFS		0x08
 #define DVP_BFO		0x0C
 #define DVP_BFS		0x10
-#define DVP_VTP         0x14
-#define DVP_VBP         0x18
+#define DVP_VTP		0x14
+#define DVP_VBP		0x18
 #define DVP_VMP		0x1C
 #define DVP_ITM		0x98
 #define DVP_ITS		0x9C
@@ -84,43 +79,20 @@
 
 #define DVP_HLFLN_SD	0x00000001
 
-#define REG_WRITE(vip, reg, value) iowrite32((value), (vip->iomem)+(reg))
-#define REG_READ(vip, reg) ioread32((vip->iomem)+(reg))
-
 #define SAVE_COUNT 8
 #define AUX_COUNT 3
 #define IRQ_COUNT 1
 
-/**
- * struct sta2x11_vip - All internal data for one instance of device
- * @v4l2_dev: device registered in v4l layer
- * @video_dev: properties of our device
- * @pdev: PCI device
- * @adapter: contains I2C adapter information
- * @register_save_area: All relevant register are saved here during suspend
- * @decoder: contains information about video DAC
- * @format: pixel format, fixed UYVY
- * @std: video standard (e.g. PAL/NTSC)
- * @input: input line for video signal ( 0 or 1 )
- * @users: Number of open of device ( max. 1 )
- * @disabled: Device is in power down state
- * @mutex: ensures exclusive opening of device
- * @slock: for excluse acces of registers
- * @vb_vidq: queue maintained by videobuf layer
- * @capture: linked list of capture buffer
- * @active: struct videobuf_buffer currently beingg filled
- * @started: device is ready to capture frame
- * @closing: device will be shut down
- * @tcount: Number of top frames
- * @bcount: Number of bottom frames
- * @overflow: Number of FIFO overflows
- * @mem_spare: small buffer of unused frame
- * @dma_spare: dma addres of mem_spare
- * @iomem: hardware base address
- * @config: I2C and gpio config from platform
- *
- * All non-local data is accessed via this structure.
- */
+
+struct vip_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	dma_addr_t		dma;
+};
+static inline struct vip_buffer *to_vip_buffer(struct vb2_buffer *vb2)
+{
+	return container_of(vb2, struct vip_buffer, vb);
+}
 
 struct sta2x11_vip {
 	struct v4l2_device v4l2_dev;
@@ -129,21 +101,27 @@ struct sta2x11_vip {
 	struct i2c_adapter *adapter;
 	unsigned int register_save_area[IRQ_COUNT + SAVE_COUNT + AUX_COUNT];
 	struct v4l2_subdev *decoder;
-	struct v4l2_pix_format format;
-	v4l2_std_id std;
-	unsigned int input;
-	int users;
-	int disabled;
-	struct mutex mutex;	/* exclusive access during open */
-	spinlock_t slock;	/* spin lock for hardware and queue access */
-	struct videobuf_queue vb_vidq;
-	struct list_head capture;
-	struct videobuf_buffer *active;
-	int started, closing, tcount, bcount;
+	struct v4l2_ctrl_handler ctrl_hdl;
+
+
+	struct v4l2_pix_format format;	/* pixel format, fixed UYVY */
+	v4l2_std_id std;	/* Video standard (PAL/NTSC)*/
+	unsigned int input;	/* Input line (0 or 1) */
+	int disabled; /* 1 disabled 0 enabled */
+	spinlock_t slock; /* spin lock for hardware */
+
+	struct vb2_alloc_ctx *alloc_ctx;
+	struct vb2_queue vb_vidq; /* queue maintaned by videobuf2 */
+	struct list_head buffer_list; /* list of buffers */
+	unsigned int sequence;
+	struct vip_buffer *active; /* current active buffer */
+	spinlock_t lock; /* Used in videobuf2 callback */
+
+	/* Interrupt counters */
+	int tcount, bcount;
 	int overflow;
-	void *mem_spare;
-	dma_addr_t dma_spare;
-	void *iomem;
+
+	void *iomem;	/* I/O Memory */
 	struct vip_config *config;
 };
 
@@ -206,360 +184,212 @@ static struct v4l2_pix_format formats_60[] = {
 	 .colorspace = V4L2_COLORSPACE_SMPTE170M},
 };
 
-/**
- * buf_setup - Get size and number of video buffer
- * @vq: queue in videobuf
- * @count: Number of buffers (1..MAX_FRAMES).
- *		0 use default value.
- * @size:  size of buffer in bytes
- *
- * returns size and number of buffers
- * a preset value of 0 returns the default number.
- * return value: 0, always succesfull.
- */
-static int buf_setup(struct videobuf_queue *vq, unsigned int *count,
-		     unsigned int *size)
+/* Write VIP register */
+static inline void reg_write(struct sta2x11_vip *vip, unsigned int reg, u32 val)
 {
-	struct sta2x11_vip *vip = vq->priv_data;
-
-	*size = vip->format.width * vip->format.height * 2;
-	if (0 == *count || MAX_FRAMES < *count)
-		*count = MAX_FRAMES;
-	return 0;
-};
-
-/**
- * buf_prepare - prepare buffer for usage
- * @vq: queue in videobuf layer
- * @vb: buffer to be prepared
- * @field: type of video data (interlaced/non-interlaced)
- *
- * Allocate or realloc buffer
- * return value: 0, successful.
- *
- * -EINVAL, supplied buffer is too small.
- *
- *  other, buffer could not be locked.
- */
-static int buf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-		       enum v4l2_field field)
+	iowrite32((val), (vip->iomem)+(reg));
+}
+/* Read VIP register */
+static inline u32 reg_read(struct sta2x11_vip *vip, unsigned int reg)
 {
-	struct sta2x11_vip *vip = vq->priv_data;
-	int ret;
-
-	vb->size = vip->format.width * vip->format.height * 2;
-	if ((0 != vb->baddr) && (vb->bsize < vb->size))
-		return -EINVAL;
-	vb->width = vip->format.width;
-	vb->height = vip->format.height;
-	vb->field = field;
-
-	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		ret = videobuf_iolock(vq, vb, NULL);
-		if (ret)
-			goto fail;
-	}
-	vb->state = VIDEOBUF_PREPARED;
-	return 0;
-fail:
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
-	return ret;
+	return  ioread32((vip->iomem)+(reg));
 }
-
-/**
- * buf_queu - queue buffer for filling
- * @vq: queue in videobuf layer
- * @vb: buffer to be queued
- *
- * if capturing is already running, the buffer will be queued. Otherwise
- * capture is started and the buffer is used directly.
- */
-static void buf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+/* Start DMA acquisition */
+static void start_dma(struct sta2x11_vip *vip, struct vip_buffer *vip_buf)
 {
-	struct sta2x11_vip *vip = vq->priv_data;
-	u32 dma;
+	unsigned long offset = 0;
+
+	if (vip->format.field == V4L2_FIELD_INTERLACED)
+		offset = vip->format.width * 2;
 
-	vb->state = VIDEOBUF_QUEUED;
+	spin_lock_irq(&vip->slock);
+	/* Enable acquisition */
+	reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) | DVP_CTL_ENA);
+	/* Set Top and Bottom Field memory address */
+	reg_write(vip, DVP_VTP, (u32)vip_buf->dma);
+	reg_write(vip, DVP_VBP, (u32)vip_buf->dma + offset);
+	spin_unlock_irq(&vip->slock);
+}
 
-	if (vip->active) {
-		list_add_tail(&vb->queue, &vip->capture);
+/* Fetch the next buffer to activate */
+static void vip_active_buf_next(struct sta2x11_vip *vip)
+{
+	/* Get the next buffer */
+	spin_lock(&vip->lock);
+	if (list_empty(&vip->buffer_list)) {/* No available buffer */
+		spin_unlock(&vip->lock);
 		return;
 	}
-
-	vip->started = 1;
+	vip->active = list_first_entry(&vip->buffer_list,
+				       struct vip_buffer,
+				       list);
+	/* Reset Top and Bottom counter */
 	vip->tcount = 0;
 	vip->bcount = 0;
-	vip->active = vb;
-	vb->state = VIDEOBUF_ACTIVE;
+	spin_unlock(&vip->lock);
+	if (vb2_is_streaming(&vip->vb_vidq)) {	/* streaming is on */
+		start_dma(vip, vip->active);	/* start dma capture */
+	}
+}
 
-	dma = videobuf_to_dma_contig(vb);
 
-	REG_WRITE(vip, DVP_TFO, (0 << 16) | (0));
-	/* despite of interlace mode, upper and lower frames start at zero */
-	REG_WRITE(vip, DVP_BFO, (0 << 16) | (0));
+/* Videobuf2 Operations */
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
 
-	switch (vip->format.field) {
-	case V4L2_FIELD_INTERLACED:
-		REG_WRITE(vip, DVP_TFS,
-			  ((vip->format.height / 2 - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS, ((vip->format.height / 2 - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
-		REG_WRITE(vip, DVP_VMP, 4 * vip->format.width);
-		break;
-	case V4L2_FIELD_TOP:
-		REG_WRITE(vip, DVP_TFS,
-			  ((vip->format.height - 1) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS, ((0) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma);
-		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
-		break;
-	case V4L2_FIELD_BOTTOM:
-		REG_WRITE(vip, DVP_TFS, ((0) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_BFS,
-			  ((vip->format.height) << 16) |
-			  (2 * vip->format.width - 1));
-		REG_WRITE(vip, DVP_VTP, dma);
-		REG_WRITE(vip, DVP_VBP, dma);
-		REG_WRITE(vip, DVP_VMP, 2 * vip->format.width);
-		break;
+	if (!(*nbuffers) || *nbuffers < MAX_FRAMES)
+		*nbuffers = MAX_FRAMES;
 
-	default:
-		pr_warning("VIP: unknown field format\n");
-		return;
-	}
+	*nplanes = 1;
+	sizes[0] = vip->format.sizeimage;
+	alloc_ctxs[0] = vip->alloc_ctx;
 
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_ENA);
-}
+	vip->sequence = 0;
+	vip->active = NULL;
+	vip->tcount = 0;
+	vip->bcount = 0;
 
-/**
- * buff_release - release buffer
- * @vq: queue in videobuf layer
- * @vb: buffer to be released
- *
- * release buffer in videobuf layer
- */
-static void buf_release(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+	return 0;
+};
+static int buffer_init(struct vb2_buffer *vb)
 {
+	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 
-	videobuf_dma_contig_free(vq, vb);
-	vb->state = VIDEOBUF_NEEDS_INIT;
+	vip_buf->dma = vb2_dma_streaming_plane_paddr(vb, 0);
+	INIT_LIST_HEAD(&vip_buf->list);
+	return 0;
 }
 
-static struct videobuf_queue_ops vip_qops = {
-	.buf_setup = buf_setup,
-	.buf_prepare = buf_prepare,
-	.buf_queue = buf_queue,
-	.buf_release = buf_release,
-};
-
-/**
- * vip_open - open video device
- * @file: descriptor of device
- *
- * open device, make sure it is only opened once.
- * return value: 0, no error.
- *
- * -EBUSY, device is already opened
- *
- * -ENOMEM, no memory for auxiliary DMA buffer
- */
-static int vip_open(struct file *file)
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct video_device *dev = video_devdata(file);
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+	unsigned long size;
+
+	size = vip->format.sizeimage;
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(&vip->v4l2_dev, "buffer too small (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
 
-	mutex_lock(&vip->mutex);
-	vip->users++;
+	vb2_set_plane_payload(&vip_buf->vb, 0, size);
 
-	if (vip->users > 1) {
-		vip->users--;
-		mutex_unlock(&vip->mutex);
-		return -EBUSY;
+	return 0;
+}
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+
+	spin_lock(&vip->lock);
+	list_add_tail(&vip_buf->list, &vip->buffer_list);
+	if (!vip->active) {	/* No active buffer, active the first one */
+		vip->active = list_first_entry(&vip->buffer_list,
+					       struct vip_buffer,
+					       list);
+		if (vb2_is_streaming(&vip->vb_vidq))	/* streaming is on */
+			start_dma(vip, vip_buf);	/* start dma capture */
 	}
+	spin_unlock(&vip->lock);
+}
+static int buffer_finish(struct vb2_buffer *vb)
+{
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 
-	file->private_data = dev;
-	vip->overflow = 0;
-	vip->started = 0;
-	vip->closing = 0;
-	vip->active = NULL;
+	/* Buffer handled, remove it from the list */
+	spin_lock(&vip->lock);
+	list_del_init(&vip_buf->list);
+	spin_unlock(&vip->lock);
 
-	INIT_LIST_HEAD(&vip->capture);
-	vip->mem_spare = dma_alloc_coherent(&vip->pdev->dev, 64,
-					    &vip->dma_spare, GFP_KERNEL);
-	if (!vip->mem_spare) {
-		vip->users--;
-		mutex_unlock(&vip->mutex);
-		return -ENOMEM;
-	}
+	vip_active_buf_next(vip);
 
-	mutex_unlock(&vip->mutex);
-	videobuf_queue_dma_contig_init_cached(&vip->vb_vidq,
-					      &vip_qops,
-					      &vip->pdev->dev,
-					      &vip->slock,
-					      V4L2_BUF_TYPE_VIDEO_CAPTURE,
-					      V4L2_FIELD_INTERLACED,
-					      sizeof(struct videobuf_buffer),
-					      vip, NULL);
-	REG_READ(vip, DVP_ITS);
-	REG_WRITE(vip, DVP_HLFLN, DVP_HLFLN_SD);
-	REG_WRITE(vip, DVP_ITM, DVP_IT_VSB | DVP_IT_VST);
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
-	REG_WRITE(vip, DVP_CTL, 0);
-	REG_READ(vip, DVP_ITS);
 	return 0;
 }
 
-/**
- * vip_close - close video device
- * @file: descriptor of device
- *
- * close video device, wait until all pending operations are finished
- * ( maximum FRAME_MAX buffers pending )
- * Turn off interrupts.
- *
- * return value: 0, always succesful.
- */
-static int vip_close(struct file *file)
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct video_device *dev = video_devdata(file);
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
 
-	vip->closing = 1;
-	if (vip->active)
-		videobuf_waiton(&vip->vb_vidq, vip->active, 0, 0);
 	spin_lock_irq(&vip->slock);
-
-	REG_WRITE(vip, DVP_ITM, 0);
-	REG_WRITE(vip, DVP_CTL, DVP_CTL_RST);
-	REG_WRITE(vip, DVP_CTL, 0);
-	REG_READ(vip, DVP_ITS);
-
-	vip->started = 0;
-	vip->active = NULL;
-
+	/* Enable interrupt VSYNC Top and Bottom*/
+	reg_write(vip, DVP_ITM, DVP_IT_VSB | DVP_IT_VST);
 	spin_unlock_irq(&vip->slock);
 
-	videobuf_stop(&vip->vb_vidq);
-	videobuf_mmap_free(&vip->vb_vidq);
+	if (count)
+		start_dma(vip, vip->active);
 
-	dma_free_coherent(&vip->pdev->dev, 64, vip->mem_spare, vip->dma_spare);
-	file->private_data = NULL;
-	mutex_lock(&vip->mutex);
-	vip->users--;
-	mutex_unlock(&vip->mutex);
 	return 0;
 }
 
-/**
- * vip_read - read from video input
- * @file: descriptor of device
- * @data: user buffer
- * @count: number of bytes to be read
- * @ppos: position within stream
- *
- * read video data from video device.
- * handling is done in generic videobuf layer
- * return value: provided by videobuf layer
- */
-static ssize_t vip_read(struct file *file, char __user *data,
-			size_t count, loff_t *ppos)
+/* abort streaming and wait for last buffer */
+static int stop_streaming(struct vb2_queue *vq)
 {
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_read_stream(&vip->vb_vidq, data, count, ppos, 0,
-				    file->f_flags & O_NONBLOCK);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
+	struct vip_buffer *vip_buf, *node;
+
+	/* Disable acquisition */
+	reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
+	/* Disable all interrupts */
+	reg_write(vip, DVP_ITM, 0);
+
+	/* Release all active buffers */
+	spin_lock(&vip->lock);
+	list_for_each_entry_safe(vip_buf, node, &vip->buffer_list, list) {
+		vb2_buffer_done(&vip_buf->vb, VB2_BUF_STATE_ERROR);
+		list_del(&vip_buf->list);
+	}
+	spin_unlock(&vip->lock);
+	return 0;
 }
 
-/**
- * vip_mmap - map user buffer
- * @file: descriptor of device
- * @vma: user buffer
- *
- * map user space buffer into kernel mode, including DMA address.
- * handling is done in generic videobuf layer.
- * return value: provided by videobuf layer
- */
-static int vip_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+static struct vb2_ops vip_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_init		= buffer_init,
+	.buf_prepare		= buffer_prepare,
+	.buf_finish		= buffer_finish,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+};
 
-	return videobuf_mmap_mapper(&vip->vb_vidq, vma);
-}
 
-/**
- * vip_poll - poll for event
- * @file: descriptor of device
- * @wait: contains events to be waited for
- *
- * wait for event related to video device.
- * handling is done in generic videobuf layer.
- * return value: provided by videobuf layer
- */
-static unsigned int vip_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct video_device *dev = file->private_data;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+/* File Operations */
+static const struct v4l2_file_operations vip_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.unlocked_ioctl = video_ioctl2,
+	.read = vb2_fop_read,
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll
+};
 
-	return videobuf_poll_stream(file, &vip->vb_vidq, wait);
-}
 
-/**
- * vidioc_querycap - return capabilities of device
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @cap: contains return values
- *
- * the capabilities of the device are returned
- *
- * return value: 0, no error.
- */
+/* V4L2 ioctl Operations */
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 
-	memset(cap, 0, sizeof(struct v4l2_capability));
-	strcpy(cap->driver, DRV_NAME);
-	strcpy(cap->card, DRV_NAME);
-	cap->version = 0;
+	strcpy(cap->driver, KBUILD_MODNAME);
+	strcpy(cap->card, KBUILD_MODNAME);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(vip->pdev));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-	    V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+			   V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
 
-/**
- * vidioc_s_std - set video standard
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains standard to be set
- *
- * the video standard is set
- *
- * return value: 0, no error.
- *
- * -EIO, no input signal detected
- *
- * other, returned from video DAC.
- */
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 	v4l2_std_id oldstd = vip->std, newstd;
 	int status;
 
@@ -590,110 +420,21 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 	return v4l2_subdev_call(vip->decoder, core, s_std, *std);
 }
 
-/**
- * vidioc_g_std - get video standard
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains return values
- *
- * the current video standard is returned
- *
- * return value: 0, no error.
- */
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 
 	*std = vip->std;
 	return 0;
 }
 
-/**
- * vidioc_querystd - get possible video standards
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @std: contains return values
- *
- * all possible video standards are returned
- *
- * return value: delivered by video DAC routine.
- */
 static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 
 	return v4l2_subdev_call(vip->decoder, video, querystd, std);
-
 }
 
-/**
- * vidioc_queryctl - get possible control settings
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains return values
- *
- * return possible values for a control
- * return value: delivered by video DAC routine.
- */
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, queryctrl, ctrl);
-}
-
-/**
- * vidioc_g_ctl - get control value
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains return values
- *
- * return setting for a control value
- * return value: delivered by video DAC routine.
- */
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, g_ctrl, ctrl);
-}
-
-/**
- * vidioc_s_ctl - set control value
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @ctrl: contains value to be set
- *
- * set value for a specific control
- * return value: delivered by video DAC routine.
- */
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return v4l2_subdev_call(vip->decoder, core, s_ctrl, ctrl);
-}
-
-/**
- * vidioc_enum_input - return name of input line
- * @file: descriptor of device (not used)
- * @priv: points to current videodevice
- * @inp: contains return values
- *
- * the user friendly name of the input line is returned
- *
- * return value: 0, no error.
- *
- * -EINVAL, input line number out of range
- */
 static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *inp)
 {
@@ -707,22 +448,9 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	return 0;
 }
 
-/**
- * vidioc_s_input - set input line
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @i: new input line number
- *
- * the current active input line is set
- *
- * return value: 0, no error.
- *
- * -EINVAL, line number out of range
- */
 static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 	int ret;
 
 	if (i > 1)
@@ -735,36 +463,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-/**
- * vidioc_g_input - return input line
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @i: returned input line number
- *
- * the current active input line is returned
- *
- * return value: always 0.
- */
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 
 	*i = vip->input;
 	return 0;
 }
 
-/**
- * vidioc_enum_fmt_vid_cap - return video capture format
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: returned format information
- *
- * returns name and format of video capture
- * Only UYVY is supported by hardware.
- *
- * return value: always 0.
- */
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
@@ -778,38 +484,19 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-/**
- * vidioc_try_fmt_vid_cap - set video capture format
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: new format
- *
- * new video format is set which includes width and
- * field type. width is fixed to 720, no scaling.
- * Only UYVY is supported by this hardware.
- * the minimum height is 200, the maximum is 576 (PAL)
- *
- * return value: 0, no error
- *
- * -EINVAL, pixel or field format not supported
- *
- */
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 	int interlace_lim;
 
-	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
-		return -EINVAL;
-
 	if (V4L2_STD_525_60 & vip->std)
 		interlace_lim = 240;
 	else
 		interlace_lim = 288;
 
 	switch (f->fmt.pix.field) {
+	default:
 	case V4L2_FIELD_ANY:
 		if (interlace_lim < f->fmt.pix.height)
 			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
@@ -823,10 +510,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		break;
 	case V4L2_FIELD_INTERLACED:
 		break;
-	default:
-		return -EINVAL;
 	}
 
+	/* It is the only supported format */
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
 	f->fmt.pix.height &= ~1;
 	if (2 * interlace_lim < f->fmt.pix.height)
 		f->fmt.pix.height = 2 * interlace_lim;
@@ -840,304 +527,221 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-/**
- * vidioc_s_fmt_vid_cap - set current video format parameters
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: returned format information
- *
- * set new capture format
- * return value: 0, no error
- *
- * other, delivered by video DAC routine.
- */
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
+	unsigned int t_stop, b_stop, pitch;
 	int ret;
 
 	ret = vidioc_try_fmt_vid_cap(file, priv, f);
 	if (ret)
 		return ret;
 
-	memcpy(&vip->format, &f->fmt.pix, sizeof(struct v4l2_pix_format));
-	return 0;
-}
+	if (vb2_is_busy(&vip->vb_vidq)) {
+		/* Can't change format during acquisition */
+		v4l2_err(&vip->v4l2_dev, "device busy\n");
+		return -EBUSY;
+	}
+	vip->format = f->fmt.pix;
+	switch (vip->format.field) {
+	case V4L2_FIELD_INTERLACED:
+		t_stop = ((vip->format.height / 2 - 1) << 16) |
+			 (2 * vip->format.width - 1);
+		b_stop = t_stop;
+		pitch = 4 * vip->format.width;
+		break;
+	case V4L2_FIELD_TOP:
+		t_stop = ((vip->format.height - 1) << 16) |
+			 (2 * vip->format.width - 1);
+		b_stop = (0 << 16) | (2 * vip->format.width - 1);
+		pitch = 2 * vip->format.width;
+		break;
+	case V4L2_FIELD_BOTTOM:
+		t_stop = (0 << 16) | (2 * vip->format.width - 1);
+		b_stop = (vip->format.height << 16) |
+			 (2 * vip->format.width - 1);
+		pitch = 2 * vip->format.width;
+		break;
+	default:
+		v4l2_err(&vip->v4l2_dev, "unknown field format\n");
+		return -EINVAL;
+	}
 
-/**
- * vidioc_g_fmt_vid_cap - get current video format parameters
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @f: contains format information
- *
- * returns current video format parameters
- *
- * return value: 0, always successful
- */
-static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	spin_lock_irq(&vip->slock);
+	/* Y-X Top Field Offset */
+	reg_write(vip, DVP_TFO, 0);
+	/* Y-X Bottom Field Offset */
+	reg_write(vip, DVP_BFO, 0);
+	/* Y-X Top Field Stop*/
+	reg_write(vip, DVP_TFS, t_stop);
+	/* Y-X Bottom Field Stop */
+	reg_write(vip, DVP_BFS, b_stop);
+	/* Video Memory Pitch */
+	reg_write(vip, DVP_VMP, pitch);
+	spin_unlock_irq(&vip->slock);
 
-	memcpy(&f->fmt.pix, &vip->format, sizeof(struct v4l2_pix_format));
 	return 0;
 }
 
-/**
- * vidioc_reqfs - request buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_reqbufs(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_querybuf - query buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * query buffer state.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_querybuf(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_qbuf - queue a buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_qbuf(&vip->vb_vidq, p);
-}
-
-/**
- * vidioc_dqbuf - dequeue a buffer
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @p: video buffer
- *
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_dqbuf(&vip->vb_vidq, p, file->f_flags & O_NONBLOCK);
-}
-
-/**
- * vidioc_streamon - turn on streaming
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @type: type of capture
- *
- * turn on streaming.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
 {
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
+	struct sta2x11_vip *vip = video_drvdata(file);
 
-	return videobuf_streamon(&vip->vb_vidq);
-}
+	f->fmt.pix = vip->format;
 
-/**
- * vidioc_streamoff - turn off streaming
- * @file: descriptor of device ( not used)
- * @priv: points to current videodevice
- * @type: type of capture
- *
- * turn off streaming.
- * Handling is done in generic videobuf layer.
- */
-static int vidioc_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct video_device *dev = priv;
-	struct sta2x11_vip *vip = video_get_drvdata(dev);
-
-	return videobuf_streamoff(&vip->vb_vidq);
+	return 0;
 }
 
-static const struct v4l2_file_operations vip_fops = {
-	.owner = THIS_MODULE,
-	.open = vip_open,
-	.release = vip_close,
-	.ioctl = video_ioctl2,
-	.read = vip_read,
-	.mmap = vip_mmap,
-	.poll = vip_poll
-};
-
 static const struct v4l2_ioctl_ops vip_ioctl_ops = {
 	.vidioc_querycap = vidioc_querycap,
-	.vidioc_s_std = vidioc_s_std,
+	/* FMT handling */
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
+	/* Buffer handlers */
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	/* Stream on/off */
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	/* Standard handling */
 	.vidioc_g_std = vidioc_g_std,
+	.vidioc_s_std = vidioc_s_std,
 	.vidioc_querystd = vidioc_querystd,
-	.vidioc_queryctrl = vidioc_queryctrl,
-	.vidioc_g_ctrl = vidioc_g_ctrl,
-	.vidioc_s_ctrl = vidioc_s_ctrl,
+	/* Input handling */
 	.vidioc_enum_input = vidioc_enum_input,
-	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
-	.vidioc_s_input = vidioc_s_input,
 	.vidioc_g_input = vidioc_g_input,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
-	.vidioc_reqbufs = vidioc_reqbufs,
-	.vidioc_querybuf = vidioc_querybuf,
-	.vidioc_qbuf = vidioc_qbuf,
-	.vidioc_dqbuf = vidioc_dqbuf,
-	.vidioc_streamon = vidioc_streamon,
-	.vidioc_streamoff = vidioc_streamoff,
+	.vidioc_s_input = vidioc_s_input,
+	/* Log status ioctl */
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	/* Event handling */
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device video_dev_template = {
-	.name = DRV_NAME,
+	.name = KBUILD_MODNAME,
 	.release = video_device_release,
 	.fops = &vip_fops,
 	.ioctl_ops = &vip_ioctl_ops,
 	.tvnorms = V4L2_STD_ALL,
 };
 
-/**
- * vip_irq - interrupt routine
- * @irq: Number of interrupt ( not used, correct number is assumed )
- * @vip: local data structure containing all information
- *
- * check for both frame interrupts set ( top and bottom ).
- * check FIFO overflow, but limit number of log messages after open.
- * signal a complete buffer if done.
- * dequeue a new buffer if available.
- * disable VIP if no buffer available.
- *
- * return value: IRQ_NONE, interrupt was not generated by VIP
- *
- * IRQ_HANDLED, interrupt done.
- */
+
 static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 {
-	u32 status, dma;
-	unsigned long flags;
-	struct videobuf_buffer *vb;
+	unsigned int status;
 
-	status = REG_READ(vip, DVP_ITS);
+	status = reg_read(vip, DVP_ITS);
 
-	if (!status) {
-		pr_debug("VIP: irq ignored\n");
+	if (!status)		/* No interrupt to handle */
 		return IRQ_NONE;
-	}
-
-	if (!vip->started)
-		return IRQ_HANDLED;
-
-	if (status & DVP_IT_VSB)
-		vip->bcount++;
 
-	if (status & DVP_IT_VST)
-		vip->tcount++;
+	if (status & DVP_IT_FIFO)
+		if (vip->overflow++ > 5)
+			pr_info("VIP: fifo overflow\n");
 
-	if ((DVP_IT_VSB | DVP_IT_VST) == (status & (DVP_IT_VST | DVP_IT_VSB))) {
+	if ((status & DVP_IT_VST) && (status & DVP_IT_VSB)) {
 		/* this is bad, we are too slow, hope the condition is gone
 		 * on the next frame */
-		pr_info("VIP: both irqs\n");
 		return IRQ_HANDLED;
 	}
 
-	if (status & DVP_IT_FIFO) {
-		if (5 > vip->overflow++)
-			pr_info("VIP: fifo overflow\n");
-	}
-
-	if (2 > vip->tcount)
+	if (status & DVP_IT_VST)
+		if ((++vip->tcount) < 2)
+			return IRQ_HANDLED;
+	if (status & DVP_IT_VSB) {
+		vip->bcount++;
 		return IRQ_HANDLED;
+	}
 
-	if (status & DVP_IT_VSB)
-		return IRQ_HANDLED;
+	if (vip->active) { /* Acquisition is over on this buffer */
+		/* Disable acquisition */
+		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
+		/* Remove the active buffer from the list */
+		do_gettimeofday(&vip->active->vb.v4l2_buf.timestamp);
+		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
+		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
+	}
 
-	spin_lock_irqsave(&vip->slock, flags);
+	return IRQ_HANDLED;
+}
 
-	REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) & ~DVP_CTL_ENA);
-	if (vip->active) {
-		do_gettimeofday(&vip->active->ts);
-		vip->active->field_count++;
-		vip->active->state = VIDEOBUF_DONE;
-		wake_up(&vip->active->done);
-		vip->active = NULL;
+static void sta2x11_vip_init_register(struct sta2x11_vip *vip)
+{
+	/* Register initialization */
+	spin_lock_irq(&vip->slock);
+	/* Clean interrupt */
+	reg_read(vip, DVP_ITS);
+	/* Enable Half Line per vertical */
+	reg_write(vip, DVP_HLFLN, DVP_HLFLN_SD);
+	/* Reset VIP control */
+	reg_write(vip, DVP_CTL, DVP_CTL_RST);
+	/* Clear VIP control */
+	reg_write(vip, DVP_CTL, 0);
+	spin_unlock_irq(&vip->slock);
+}
+static void sta2x11_vip_clear_register(struct sta2x11_vip *vip)
+{
+	spin_lock_irq(&vip->slock);
+	/* Disable interrupt */
+	reg_write(vip, DVP_ITM, 0);
+	/* Reset VIP Control */
+	reg_write(vip, DVP_CTL, DVP_CTL_RST);
+	/* Clear VIP Control */
+	reg_write(vip, DVP_CTL, 0);
+	/* Clean VIP Interrupt */
+	reg_read(vip, DVP_ITS);
+	spin_unlock_irq(&vip->slock);
+}
+static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
+{
+	memset(&vip->vb_vidq, 0, sizeof(struct vb2_queue));
+	vip->vb_vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vip->vb_vidq.io_modes = VB2_MMAP | VB2_READ;
+	vip->vb_vidq.drv_priv = vip;
+	vip->vb_vidq.buf_struct_size = sizeof(struct vip_buffer);
+	vip->vb_vidq.ops = &vip_video_qops;
+	vip->vb_vidq.mem_ops = &vb2_dma_streaming_memops;
+	vb2_queue_init(&vip->vb_vidq);
+	INIT_LIST_HEAD(&vip->buffer_list);
+	spin_lock_init(&vip->lock);
+
+	vip->alloc_ctx = vb2_dma_streaming_init_ctx(&vip->pdev->dev);
+	if (IS_ERR(vip->alloc_ctx)) {
+		v4l2_err(&vip->v4l2_dev, "Can't allocate buffer context");
+		return PTR_ERR(vip->alloc_ctx);
 	}
-	if (!vip->closing) {
-		if (list_empty(&vip->capture))
-			goto done;
-
-		vb = list_first_entry(&vip->capture, struct videobuf_buffer,
-				      queue);
-		if (NULL == vb) {
-			pr_info("VIP: no buffer\n");
-			goto done;
-		}
-		vb->state = VIDEOBUF_ACTIVE;
-		list_del(&vb->queue);
-		vip->active = vb;
-		dma = videobuf_to_dma_contig(vb);
-		switch (vip->format.field) {
-		case V4L2_FIELD_INTERLACED:
-			REG_WRITE(vip, DVP_VTP, dma);
-			REG_WRITE(vip, DVP_VBP, dma + vip->format.width * 2);
-			break;
-		case V4L2_FIELD_TOP:
-		case V4L2_FIELD_BOTTOM:
-			REG_WRITE(vip, DVP_VTP, dma);
-			REG_WRITE(vip, DVP_VBP, dma);
-			break;
-		default:
-			pr_warning("VIP: unknown field format\n");
-			goto done;
-			break;
-		}
-		REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) | DVP_CTL_ENA);
+	return 0;
+}
+static void sta2x11_vip_release_buffer(struct sta2x11_vip *vip)
+{
+	vb2_dma_streaming_cleanup_ctx(vip->alloc_ctx);
+}
+static int sta2x11_vip_init_controls(struct sta2x11_vip *vip)
+{
+	/*
+	 * Inititialize an empty control so VIP can inerithing controls
+	 * from ADV7180
+	 */
+	v4l2_ctrl_handler_init(&vip->ctrl_hdl, 0);
+
+	vip->v4l2_dev.ctrl_handler = &vip->ctrl_hdl;
+	if (vip->ctrl_hdl.error) {
+		int err = vip->ctrl_hdl.error;
+
+		v4l2_ctrl_handler_free(&vip->ctrl_hdl);
+		return err;
 	}
-done:
-	spin_unlock_irqrestore(&vip->slock, flags);
-	return IRQ_HANDLED;
+
+	return 0;
 }
 
-/**
- * vip_gpio_reserve - reserve gpio pin
- * @dev: device
- * @pin: GPIO pin number
- * @dir: direction, input or output
- * @name: GPIO pin name
- *
- */
 static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 			    const char *name)
 {
@@ -1170,13 +774,6 @@ static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 	return 0;
 }
 
-/**
- * vip_gpio_release - release gpio pin
- * @dev: device
- * @pin: GPIO pin number
- * @name: GPIO pin name
- *
- */
 static void vip_gpio_release(struct device *dev, int pin, const char *name)
 {
 	if (pin != -1) {
@@ -1186,25 +783,6 @@ static void vip_gpio_release(struct device *dev, int pin, const char *name)
 	}
 }
 
-/**
- * sta2x11_vip_init_one - init one instance of video device
- * @pdev: PCI device
- * @ent: (not used)
- *
- * allocate reset pins for DAC.
- * Reset video DAC, this is done via reset line.
- * allocate memory for managing device
- * request interrupt
- * map IO region
- * register device
- * find and initialize video DAC
- *
- * return value: 0, no error
- *
- * -ENOMEM, no memory
- *
- * -ENODEV, device could not be detected or registered
- */
 static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 					  const struct pci_device_id *ent)
 {
@@ -1212,10 +790,17 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 	struct sta2x11_vip *vip;
 	struct vip_config *config;
 
+	/* Check if hardware support 26-bit DMA */
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(26))) {
+		dev_err(&pdev->dev, "26-bit DMA addressing not available\n");
+		return -EINVAL;
+	}
+	/* Enable PCI */
 	ret = pci_enable_device(pdev);
 	if (ret)
 		return ret;
 
+	/* Get VIP platform data */
 	config = dev_get_platdata(&pdev->dev);
 	if (!config) {
 		dev_info(&pdev->dev, "VIP slot disabled\n");
@@ -1223,6 +808,7 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 		goto disable;
 	}
 
+	/* Power configuration */
 	ret = vip_gpio_reserve(&pdev->dev, config->pwr_pin, 0,
 			       config->pwr_name);
 	if (ret)
@@ -1237,7 +823,6 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 			goto disable;
 		}
 	}
-
 	if (config->pwr_pin != -1) {
 		/* Datasheet says 5ms between PWR and RST */
 		usleep_range(5000, 25000);
@@ -1251,17 +836,20 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 	}
 	usleep_range(5000, 25000);
 
+	/* Allocate a new VIP instance */
 	vip = kzalloc(sizeof(struct sta2x11_vip), GFP_KERNEL);
 	if (!vip) {
 		ret = -ENOMEM;
 		goto release_gpios;
 	}
-
 	vip->pdev = pdev;
 	vip->std = V4L2_STD_PAL;
 	vip->format = formats_50[0];
 	vip->config = config;
 
+	ret = sta2x11_vip_init_controls(vip);
+	if (ret)
+		goto free_mem;
 	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
 		goto free_mem;
 
@@ -1271,46 +859,52 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	ret = pci_request_regions(pdev, DRV_NAME);
+	ret = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (ret)
 		goto unreg;
 
 	vip->iomem = pci_iomap(pdev, 0, 0x100);
 	if (!vip->iomem) {
-		ret = -ENOMEM; /* FIXME */
+		ret = -ENOMEM;
 		goto release;
 	}
 
 	pci_enable_msi(pdev);
 
-	INIT_LIST_HEAD(&vip->capture);
+	/* Initialize buffer */
+	ret = sta2x11_vip_init_buffer(vip);
+	if (ret)
+		goto unmap;
+
 	spin_lock_init(&vip->slock);
-	mutex_init(&vip->mutex);
-	vip->started = 0;
-	vip->disabled = 0;
 
 	ret = request_irq(pdev->irq,
 			  (irq_handler_t) vip_irq,
-			  IRQF_SHARED, DRV_NAME, vip);
+			  IRQF_SHARED, KBUILD_MODNAME, vip);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		ret = -ENODEV;
-		goto unmap;
+		goto release_buf;
 	}
 
+	/* Alloc, initialize and register video device */
 	vip->video_dev = video_device_alloc();
 	if (!vip->video_dev) {
 		ret = -ENOMEM;
 		goto release_irq;
 	}
 
-	*(vip->video_dev) = video_dev_template;
+	vip->video_dev = &video_dev_template;
+	vip->video_dev->v4l2_dev = &vip->v4l2_dev;
+	vip->video_dev->queue = &vip->vb_vidq;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vip->video_dev->flags);
 	video_set_drvdata(vip->video_dev, vip);
 
 	ret = video_register_device(vip->video_dev, VFL_TYPE_GRABBER, -1);
 	if (ret)
 		goto vrelease;
 
+	/* Get ADV7180 subdevice */
 	vip->adapter = i2c_get_adapter(vip->config->i2c_id);
 	if (!vip->adapter) {
 		ret = -ENODEV;
@@ -1328,10 +922,11 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
 	}
 
 	i2c_put_adapter(vip->adapter);
-
 	v4l2_subdev_call(vip->decoder, core, init, 0);
 
-	pr_info("STA2X11 Video Input Port (VIP) loaded\n");
+	sta2x11_vip_init_register(vip);
+
+	dev_info(&pdev->dev, "STA2X11 Video Input Port (VIP) loaded\n");
 	return 0;
 
 vunreg:
@@ -1343,10 +938,12 @@ vrelease:
 		video_device_release(vip->video_dev);
 release_irq:
 	free_irq(pdev->irq, vip);
+release_buf:
+	sta2x11_vip_release_buffer(vip);
 	pci_disable_msi(pdev);
 unmap:
+	vb2_queue_release(&vip->vb_vidq);
 	pci_iounmap(pdev, vip->iomem);
-	mutex_destroy(&vip->mutex);
 release:
 	pci_release_regions(pdev);
 unreg:
@@ -1364,34 +961,24 @@ disable:
 	return ret;
 }
 
-/**
- * sta2x11_vip_remove_one - release device
- * @pdev: PCI device
- *
- * Undo everything done in .._init_one
- *
- * unregister video device
- * free interrupt
- * unmap ioadresses
- * free memory
- * free GPIO pins
- */
 static void __devexit sta2x11_vip_remove_one(struct pci_dev *pdev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
 	struct sta2x11_vip *vip =
 	    container_of(v4l2_dev, struct sta2x11_vip, v4l2_dev);
 
+	sta2x11_vip_clear_register(vip);
+
 	video_set_drvdata(vip->video_dev, NULL);
 	video_unregister_device(vip->video_dev);
 	/*do not call video_device_release() here, is already done */
 	free_irq(pdev->irq, vip);
 	pci_disable_msi(pdev);
+	vb2_queue_release(&vip->vb_vidq);
 	pci_iounmap(pdev, vip->iomem);
 	pci_release_regions(pdev);
 
 	v4l2_device_unregister(&vip->v4l2_dev);
-	mutex_destroy(&vip->mutex);
 
 	vip_gpio_release(&pdev->dev, vip->config->pwr_pin,
 			 vip->config->pwr_name);
@@ -1407,18 +994,12 @@ static void __devexit sta2x11_vip_remove_one(struct pci_dev *pdev)
 
 #ifdef CONFIG_PM
 
-/**
- * sta2x11_vip_suspend - set device into power save mode
- * @pdev: PCI device
- * @state: new state of device
+/*
  *
  * all relevant registers are saved and an attempt to set a new state is made.
  *
  * return value: 0 always indicate success,
  * even if device could not be disabled. (workaround for hardware problem)
- *
- * reurn value : 0, always succesful, even if hardware does not not support
- * power down mode.
  */
 static int sta2x11_vip_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -1429,15 +1010,15 @@ static int sta2x11_vip_suspend(struct pci_dev *pdev, pm_message_t state)
 	int i;
 
 	spin_lock_irqsave(&vip->slock, flags);
-	vip->register_save_area[0] = REG_READ(vip, DVP_CTL);
-	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0] & DVP_CTL_DIS);
-	vip->register_save_area[SAVE_COUNT] = REG_READ(vip, DVP_ITM);
-	REG_WRITE(vip, DVP_ITM, 0);
+	vip->register_save_area[0] = reg_read(vip, DVP_CTL);
+	reg_write(vip, DVP_CTL, vip->register_save_area[0] & DVP_CTL_DIS);
+	vip->register_save_area[SAVE_COUNT] = reg_read(vip, DVP_ITM);
+	reg_write(vip, DVP_ITM, 0);
 	for (i = 1; i < SAVE_COUNT; i++)
-		vip->register_save_area[i] = REG_READ(vip, 4 * i);
+		vip->register_save_area[i] = reg_read(vip, 4 * i);
 	for (i = 0; i < AUX_COUNT; i++)
 		vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i] =
-		    REG_READ(vip, registers_to_save[i]);
+		    reg_read(vip, registers_to_save[i]);
 	spin_unlock_irqrestore(&vip->slock, flags);
 	/* save pci state */
 	pci_save_state(pdev);
@@ -1453,16 +1034,9 @@ static int sta2x11_vip_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-/**
- * sta2x11_vip_resume - resume device operation
- * @pdev : PCI device
- *
+/*
  * re-enable device, set PCI state to powered and restore registers.
  * resume normal device operation afterwards.
- *
- * return value: 0, no error.
- *
- * other, could not set device to power on state.
  */
 static int sta2x11_vip_resume(struct pci_dev *pdev)
 {
@@ -1477,7 +1051,7 @@ static int sta2x11_vip_resume(struct pci_dev *pdev)
 	if (vip->disabled) {
 		ret = pci_enable_device(pdev);
 		if (ret) {
-			pr_warning("VIP: Can't enable device.\n");
+			pr_warn("VIP: Can't enable device.\n");
 			return ret;
 		}
 		vip->disabled = 0;
@@ -1488,7 +1062,7 @@ static int sta2x11_vip_resume(struct pci_dev *pdev)
 		 * do not call pci_disable_device on sta2x11 because it
 		 * break all other Bus masters on this EP
 		 */
-		pr_warning("VIP: Can't enable device.\n");
+		pr_warn("VIP: Can't enable device.\n");
 		vip->disabled = 1;
 		return ret;
 	}
@@ -1497,12 +1071,12 @@ static int sta2x11_vip_resume(struct pci_dev *pdev)
 
 	spin_lock_irqsave(&vip->slock, flags);
 	for (i = 1; i < SAVE_COUNT; i++)
-		REG_WRITE(vip, 4 * i, vip->register_save_area[i]);
+		reg_write(vip, 4 * i, vip->register_save_area[i]);
 	for (i = 0; i < AUX_COUNT; i++)
-		REG_WRITE(vip, registers_to_save[i],
+		reg_write(vip, registers_to_save[i],
 			  vip->register_save_area[SAVE_COUNT + IRQ_COUNT + i]);
-	REG_WRITE(vip, DVP_CTL, vip->register_save_area[0]);
-	REG_WRITE(vip, DVP_ITM, vip->register_save_area[SAVE_COUNT]);
+	reg_write(vip, DVP_CTL, vip->register_save_area[0]);
+	reg_write(vip, DVP_ITM, vip->register_save_area[SAVE_COUNT]);
 	spin_unlock_irqrestore(&vip->slock, flags);
 	return 0;
 }
@@ -1515,7 +1089,7 @@ static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
 };
 
 static struct pci_driver sta2x11_vip_driver = {
-	.name = DRV_NAME,
+	.name = KBUILD_MODNAME,
 	.probe = sta2x11_vip_init_one,
 	.remove = __devexit_p(sta2x11_vip_remove_one),
 	.id_table = sta2x11_vip_pci_tbl,
@@ -1543,7 +1117,7 @@ late_initcall_sync(sta2x11_vip_init_module);
 #endif
 
 MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
-MODULE_AUTHOR("Wind River");
+MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_SUPPORTED_DEVICE("sta2x11 video input");
 MODULE_VERSION(DRV_VERSION);
-- 
1.7.11.4

