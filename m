Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:31258 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0FINkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 09:40:51 -0400
Received: from meyreuil.atmel.fr (meyreuil [10.159.254.132])
	by sjogate2.atmel.com (8.13.6/8.13.6) with ESMTP id o59Dcp82008704
	for <linux-media@vger.kernel.org>; Wed, 9 Jun 2010 06:38:51 -0700 (PDT)
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
To: linux-media@vger.kernel.org
Cc: sedji.gaouaou@atmel.com
Subject: [PATCH] Atmel IMAGE SENSOR INTERFACE (ISI) driver.
Date: Wed,  9 Jun 2010 16:46:27 +0200
Message-Id: <1276094787-11214-1-git-send-email-sedji.gaouaou@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is the first try for the atmel video driver.
Basically it has 2 video entries:
	1) One for the capture. It will only allow you to grab one frame
	2) One for the streaming part.

Memoy allocation needs to be contiguous, and so is done at probe time.
For the streaming part no actual interupt is needed as the ISI handles link
list of buffers.

I am still facing some issues with the v4l2_i2c_new_subdev_board function which
retunrs an error, but as we fix a video format I don't really need to be able
to set up the sensor format(done at probe time).

This driver will only work or the at91sam9g45 and at91sam9m10 as it is a new
version of the Image Sensor Interface IP.

Regards,
Sedji

---
 drivers/media/video/atmel-isi.c | 1789 +++++++++++++++++++++++++++++++++++++++
 include/media/atmel-isi.h       |  460 ++++++++++
 2 files changed, 2249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/atmel-isi.c
 create mode 100644 include/media/atmel-isi.h

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
new file mode 100644
index 0000000..1348830
--- /dev/null
+++ b/drivers/media/video/atmel-isi.c
@@ -0,0 +1,1789 @@
+/*
+ * Copyright (c) 2007 Atmel Corporation
+ *
+ * Based on the bttv driver for Bt848 with respective copyright holders
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <linux/wait.h>
+#include <linux/i2c.h>
+#include <linux/kfifo.h>
+#include <linux/time.h>
+#include<linux/io.h>
+
+#include <mach/board.h>
+#include <mach/cpu.h>
+
+#include <media/atmel-isi.h>
+
+#define ATMEL_ISI_VERSION	KERNEL_VERSION(0, 1, 0)
+
+/* Default ISI capture buffer size */
+#define ISI_CAPTURE_BUFFER_SIZE (800*600*2)
+/* Default ISI video frame size ie qvga */
+#define ISI_VIDEO_BUFFER_SIZE (320*240*2)
+/* Default number of ISI video buffers */
+/*(if qvga we can use 4 buffers)*/
+#define ISI_VIDEO_BUFFERS 4
+/* Interrupt mask for a single capture */
+#define ISI_V2_CAPTURE_MASK (ISI_BIT(V2_VSYNC) \
+		| ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE))
+/* ISI capture buffer size */
+static int capture_buffer_size = ISI_CAPTURE_BUFFER_SIZE;
+/* Number of buffers used for streaming video */
+static int video_buffers = ISI_VIDEO_BUFFERS;
+static int video_buffer_size = ISI_VIDEO_BUFFER_SIZE;
+
+static int input_format = ATMEL_ISI_PIXFMT_CbYCrY;
+static u8 has_emb_sync, emb_crc_sync, hsync_act_low;
+static u8 vsync_act_low, pclk_act_falling, isi_full_mode;
+/* Preview path horizontal size */
+static int prev_hsize = 320;
+/* Preview path vertical size */
+static int prev_vsize = 240;
+
+/* Input image horizontal size */
+static int image_hsize = 320;
+/* Input image vertical size */
+static int image_vsize = 240;
+
+static struct timeval start_time;
+/* Frame rate scaler
+ * 1 = capture every second frame
+ * 2 = capture every third frame
+ * ...
+ * */
+static int frame_rate_scaler;
+
+/* Set this value if we want to pretend a specific V4L2 output format
+ *  This format is for the capturing interface
+ */
+static int capture_v4l2_fmt = V4L2_PIX_FMT_YUYV;
+
+/* Set this value if we want to pretend a specific V4L2 output format
+ *  This format is for the streaming interface
+ */
+static int streaming_v4l2_fmt = V4L2_PIX_FMT_YUYV;
+
+/* Declare static vars that will be used as parameters */
+/* 0 <-> dev/video0, 1 <-> dev/video1, -1 <-> first free */
+static int video_nr = -1;
+
+MODULE_PARM_DESC(video_buffers, "Number of frame buffers used for streaming");
+module_param(video_buffers, int, 0664);
+MODULE_PARM_DESC(capture_buffer_size, "Capture buffer size");
+module_param(capture_buffer_size, int, 0664);
+MODULE_PARM_DESC(image_hsize, "Horizontal size of input image");
+module_param(image_hsize, int, 0664);
+MODULE_PARM_DESC(image_vsize, "Vertical size of input image");
+module_param(image_vsize, int, 0664);
+MODULE_PARM_DESC(frame_rate_scaler, "Frame rate scaler");
+module_param(frame_rate_scaler, int, 0664);
+MODULE_PARM_DESC(prev_hsize, "Horizontal image size of preview path output");
+module_param(prev_hsize, int, 0664);
+MODULE_PARM_DESC(prev_vsize, "Vertical image size of preview path output");
+module_param(prev_vsize, int, 0664);
+module_param(video_nr, int, 0444);
+
+/* Single frame capturing states */
+enum {
+	STATE_IDLE = 0,
+	STATE_CAPTURE_READY,
+	STATE_CAPTURE_WAIT_SOF,
+	STATE_CAPTURE_IN_PROGRESS,
+	STATE_CAPTURE_DONE,
+	STATE_CAPTURE_ERROR,
+};
+
+/* Frame buffer states
+ *  FRAME_UNUSED Frame(buffer) is not used by the ISI module -> an application
+ *  can usually read out data in this state
+ *  FRAME_QUEUED An application has queued the buffer in the incoming queue
+ *  FRAME_DONE The ISI module has filled the buffer with data and placed is on
+ *  the outgoing queue
+ *  FRAME_ERROR Not used at the moment
+ *  */
+enum frame_status {
+	FRAME_UNUSED,
+	FRAME_QUEUED,
+	FRAME_DONE,
+	FRAME_ERROR,
+};
+/* Frame buffer descriptor
+ *  Used by the ISI module as a linked list for the DMA controller.
+ */
+struct fbd {
+	/* Physical address of the frame buffer */
+	dma_addr_t fb_address;
+#if defined(CONFIG_ARCH_AT91SAM9G45) || defined(CONFIG_ARCH_AT91SAM9M10)
+	/* DMA Control Register(new: only in HISI2) */
+	u32 dma_ctrl;
+#endif
+	/* Physical address of the next fbd */
+	dma_addr_t next_fbd_address;
+};
+
+/* Frame buffer data
+ */
+struct frame_buffer {
+	/*  Frame buffer descriptor
+	 *  Used by the ISI DMA controller to provide linked list DMA operation
+	 */
+	struct fbd fb_desc;
+	/* Pointer to the start of the frame buffer */
+	void *frame_buffer;
+	/* Timestamp of the captured frame */
+	struct timeval timestamp;
+	/* Frame number of the frame  */
+	unsigned long sequence;
+	/* Buffer number*/
+	int index;
+	/* Bytes used in the buffer for data, needed as buffers are always
+	 *  aligned to pages and thus may be bigger than the amount of data*/
+	int bytes_used;
+	/* Mmap count
+	 *  Counter to measure how often this buffer is mmapped
+	 */
+	int mmap_count;
+	/* Buffer status */
+	enum frame_status status;
+};
+
+struct atmel_isi {
+	/* ISI module spin lock. Protects against concurrent access of variables
+	 * that are shared with the ISR */
+	spinlock_t			lock;
+	void __iomem			*regs;
+	/* Pointer to the start of the fbd list */
+	dma_addr_t			fbd_list_start;
+	/* Frame buffers */
+	struct frame_buffer 		video_buffer[ISI_VIDEO_BUFFERS];
+	/* Frame buffer currently used by the ISI module */
+	struct frame_buffer		*current_buffer;
+	/* Size of a frame buffer */
+	size_t				capture_buffer_size;
+	/* Streaming status
+	 *  If set ISI is in streaming mode */
+	int				streaming;
+	/* Queue for incoming buffers
+	 *  The buffer number (index) is stored in the fifo as reference
+	 */
+	int				head, tail;
+	/* State of the ISI module in capturing mode */
+	int				state;
+	/* Pointer to ISI buffer */
+	void				*capture_buf;
+	/* Physical address of the capture buffer */
+	dma_addr_t			capture_phys;
+	/* Size of the ISI buffer */
+	size_t				capture_buf_size;
+	/* Capture/streaming wait queue */
+	wait_queue_head_t		capture_wq;
+
+	struct atmel_isi_format		format;
+	struct atmel_isi_format		streaming_format;
+
+	struct mutex			mutex;
+	/* User counter for the streaming interface */
+	int				stream_users;
+	/* User counter of the capture interface */
+	int				capture_users;
+
+	/* v4l2 device */
+	struct device			*dev;
+	struct v4l2_device 	   	v4l2_dev;
+	/* sub devices */
+	struct v4l2_subdev 		*sd;
+	/* Video device for capturing */
+	struct video_device		cdev;
+	/* Video device for streaming */
+	struct video_device		vdev;
+
+	/* i2c subdevice board info */
+	struct i2c_board_info 		board_info;
+	struct i2c_adapter		*i2c_adapter;
+
+	struct completion		reset_complete;
+	struct clk			*pclk;
+	struct clk			*hclk;
+	struct platform_device		*pdev;
+	unsigned int			irq;
+};
+
+#define to_atmel_isi(vdev) container_of(vdev, struct atmel_isi, vdev)
+
+struct atmel_isi_fh {
+	struct atmel_isi		*isi;
+	unsigned int			read_off;
+};
+
+
+static void atmel_isi_set_default_format(struct atmel_isi *isi)
+{
+
+	isi->format.pix.width = (u32)min((u32)2048l, (u32)image_hsize);
+	isi->format.pix.height = (u32)min((u32)2048l, (u32)image_vsize);
+
+	/* Set capture format if we have explicitely specified one */
+	if (capture_v4l2_fmt) {
+		isi->format.pix.pixelformat = capture_v4l2_fmt;
+	} else {
+		/* Codec path output format */
+		isi->format.pix.pixelformat = V4L2_PIX_FMT_YVYU;
+	}
+
+	/* The ISI module codec path tries to output YUV 4:2:2
+	 * Therefore two pixels will be in a 32bit word */
+	isi->format.pix.bytesperline = ALIGN(isi->format.pix.width * 2, 4);
+	isi->format.pix.sizeimage = isi->format.pix.bytesperline *
+		isi->format.pix.height;
+
+	pr_debug("set default format: width=%d height=%d\n",
+		isi->format.pix.width, isi->format.pix.height);
+
+	isi->streaming_format.pix.width = isi->format.pix.width;
+	isi->streaming_format.pix.height = isi->format.pix.height;
+	isi->streaming_format.pix.bytesperline = isi->format.pix.bytesperline;
+	isi->streaming_format.pix.sizeimage = isi->format.pix.sizeimage;
+
+	/* Set streaming format if we have explicitely specified one */
+	if (streaming_v4l2_fmt) {
+		isi->streaming_format.pix.pixelformat = streaming_v4l2_fmt;
+	} else {
+		/* Preview path output format
+		 * Would be logically V4L2_PIX_FMT_BGR555X
+		 * but this format does not exist in the specification
+		 * So for now we pretend V4L2_PIX_FMT_RGB555X
+		 * Also the Greyscale format does not fit on top of the V4L2
+		 * format but for now we just return it.
+		 */
+		if (input_format == ATMEL_ISI_PIXFMT_GREY)
+			isi->streaming_format.pix.pixelformat =
+							V4L2_PIX_FMT_GREY;
+		else
+			isi->streaming_format.pix.pixelformat =
+							V4L2_PIX_FMT_RGB555X;
+	}
+
+	if (input_format) {
+		isi->format.input_format = input_format;
+		/* Not needed but for completeness*/
+		isi->streaming_format.input_format = input_format;
+	}
+
+}
+
+static int atmel_isi_init_hardware(struct atmel_isi *isi)
+{
+	u32 cfg2, cfg1, cr, ctrl;
+
+	cr = 0;
+	switch (isi->format.input_format) {
+	case ATMEL_ISI_PIXFMT_GREY:
+		cr = ISI_BIT(GRAYSCALE);
+		break;
+	case ATMEL_ISI_PIXFMT_YCrYCb:
+		cr = ISI_BF(V2_YCC_SWAP, 0);
+		break;
+	case ATMEL_ISI_PIXFMT_YCbYCr:
+		cr = ISI_BF(V2_YCC_SWAP, 1);
+		break;
+	case ATMEL_ISI_PIXFMT_CrYCbY:
+		cr = ISI_BF(V2_YCC_SWAP, 2);
+		break;
+	case ATMEL_ISI_PIXFMT_CbYCrY:
+		cr = ISI_BF(YCC_SWAP, 3);
+		break;
+	case ATMEL_ISI_PIXFMT_RGB24:
+		cr = ISI_BIT(V2_COL_SPACE) | ISI_BF(V2_RGB_CFG, 0);
+		break;
+	case ATMEL_ISI_PIXFMT_BGR24:
+		cr = ISI_BIT(V2_COL_SPACE) | ISI_BF(V2_RGB_CFG, 1);
+		break;
+	case ATMEL_ISI_PIXFMT_RGB16:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_MODE)
+		       | ISI_BF(V2_RGB_CFG, 0));
+		break;
+	case ATMEL_ISI_PIXFMT_BGR16:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_MODE)
+		       | ISI_BF(V2_RGB_CFG, 1));
+		break;
+	case ATMEL_ISI_PIXFMT_GRB16:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_MODE)
+		       | ISI_BF(V2_RGB_CFG, 2));
+		break;
+	case ATMEL_ISI_PIXFMT_GBR16:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_MODE)
+		       | ISI_BF(V2_RGB_CFG, 3));
+		break;
+	case ATMEL_ISI_PIXFMT_RGB24_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BF(V2_RGB_CFG, 0));
+		break;
+	case ATMEL_ISI_PIXFMT_BGR24_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BF(V2_RGB_CFG, 1));
+		break;
+	case ATMEL_ISI_PIXFMT_RGB16_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BIT(V2_RGB_MODE) | ISI_BF(V2_RGB_CFG, 0));
+		break;
+	case ATMEL_ISI_PIXFMT_BGR16_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BIT(V2_RGB_MODE) | ISI_BF(V2_RGB_CFG, 1));
+		break;
+	case ATMEL_ISI_PIXFMT_GRB16_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BIT(V2_RGB_MODE) | ISI_BF(V2_RGB_CFG, 2));
+		break;
+	case ATMEL_ISI_PIXFMT_GBR16_REV:
+		cr = (ISI_BIT(V2_COL_SPACE) | ISI_BIT(V2_RGB_SWAP)
+		       | ISI_BIT(V2_RGB_MODE) | ISI_BF(V2_RGB_CFG, 3));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cfg1 = ISI_BF(V2_EMB_SYNC, (has_emb_sync))
+		| ISI_BF(V2_HSYNC_POL, hsync_act_low)
+		| ISI_BF(V2_VSYNC_POL, vsync_act_low)
+		| ISI_BF(V2_PIXCLK_POL, pclk_act_falling)
+		| ISI_BF(V2_FULL, isi_full_mode);
+
+	ctrl = ISI_BIT(DIS);
+
+	isi_writel(isi, V2_CFG1, cfg1);
+	isi_writel(isi, V2_CTRL, ctrl);
+	/* Check if module properly disable */
+	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS_DONE))
+		cpu_relax();
+
+	cfg2 = isi_readl(isi, V2_CFG2);
+	cfg2 |= cr;
+	cfg2 = ISI_BFINS(V2_IM_VSIZE, isi->format.pix.height - 1, cfg2);
+	cfg2 = ISI_BFINS(V2_IM_HSIZE, isi->format.pix.width - 1, cfg2);
+
+	isi_writel(isi, V2_CFG2, cfg2);
+
+	return 0;
+}
+
+static int atmel_isi_start_capture(struct atmel_isi *isi)
+{
+	u32 cr, sr = 0;
+	int ret;
+
+	spin_lock_irq(&isi->lock);
+	isi->state = STATE_IDLE;
+
+	/* clear any pending SOF interrupt */
+	sr = isi_readl(isi, V2_STATUS);
+	/* <=> SOF in previous ISI */
+	isi_writel(isi, V2_INTEN, ISI_BIT(V2_VSYNC));
+	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_EN));
+
+	spin_unlock_irq(&isi->lock);
+
+	pr_debug("isi: waiting for SOF\n");
+
+	ret = wait_event_interruptible(isi->capture_wq,
+				       isi->state != STATE_IDLE);
+	if (ret)
+		return ret;
+
+	if (isi->state != STATE_CAPTURE_READY)
+		return -EIO;
+
+	/*
+	 * Do a codec request. Next SOF indicates start of capture,
+	 * the one after that indicates end of capture.
+	 */
+	pr_debug("isi: starting capture\n");
+
+	/* Enable */
+	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
+	isi_writel(isi, V2_DMA_C_ADDR, isi->capture_phys);
+
+	spin_lock_irq(&isi->lock);
+	isi->state = STATE_CAPTURE_WAIT_SOF;
+	/* Check if already in a frame */
+	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
+		cpu_relax();
+	cr = isi_readl(isi, V2_CTRL);
+	cr |= ISI_BIT(V2_CDC);
+	isi_writel(isi, V2_CTRL, cr);
+	isi_writel(isi, V2_INTEN, ISI_V2_CAPTURE_MASK);
+
+	spin_unlock_irq(&isi->lock);
+
+	return 0;
+}
+
+static void atmel_isi_capture_done(struct atmel_isi *isi,
+				   int state)
+{
+	u32 cr;
+
+	cr = isi_readl(isi, V2_CTRL);
+	cr &= ~ISI_BIT(V2_CDC);
+	isi_writel(isi, V2_CTRL, cr);
+
+	isi->state = state;
+	wake_up_interruptible(&isi->capture_wq);
+	isi_writel(isi, V2_INTDIS, ISI_V2_CAPTURE_MASK);
+}
+
+static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi,
+							int sequence)
+{
+	return IRQ_HANDLED;
+}
+
+/* isi interrupt service routine */
+static irqreturn_t isi_interrupt(int irq, void *dev_id)
+{
+	struct atmel_isi *isi = dev_id;
+	u32 status, mask, pending;
+	irqreturn_t ret = IRQ_NONE;
+	static int sequence;
+
+	spin_lock(&isi->lock);
+
+	status = isi_readl(isi, V2_STATUS);
+	mask = isi_readl(isi, V2_INTMASK);
+	pending = status & mask;
+
+	if (isi->streaming) {
+		if (likely(pending & (ISI_BIT(V2_CXFR_DONE)))) {
+			sequence++;
+			ret = atmel_isi_handle_streaming(isi, sequence);
+		}
+	} else {
+		while (pending) {
+			if (pending &
+				(ISI_BIT(V2_C_OVR) | ISI_BIT(V2_FR_OVR))) {
+				atmel_isi_capture_done(isi,
+						STATE_CAPTURE_ERROR);
+				pr_debug("%s: FIFO overrun (status=0x%x)\n",
+					 isi->vdev.name, status);
+			} else if (pending &
+				(ISI_BIT(V2_VSYNC) | ISI_BIT(V2_CDC))) {
+				switch (isi->state) {
+				case STATE_IDLE:
+					isi->state = STATE_CAPTURE_READY;
+					wake_up_interruptible(&isi->capture_wq);
+					break;
+				case STATE_CAPTURE_READY:
+					break;
+				case STATE_CAPTURE_WAIT_SOF:
+					isi->state = STATE_CAPTURE_IN_PROGRESS;
+					break;
+				}
+			}
+			if (pending &
+			(ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE))) {
+				if (isi->state == STATE_CAPTURE_IN_PROGRESS)
+					atmel_isi_capture_done(isi,
+							STATE_CAPTURE_DONE);
+			}
+
+			if (pending & ISI_BIT(V2_SRST)) {
+				complete(&isi->reset_complete);
+				isi_writel(isi, V2_INTDIS, ISI_BIT(V2_SRST));
+			}
+
+			status = isi_readl(isi, V2_STATUS);
+			mask = isi_readl(isi, V2_INTMASK);
+			pending = status & mask;
+			ret = IRQ_HANDLED;
+		}
+	}
+	spin_unlock(&isi->lock);
+
+	return ret;
+}
+/* ------------------------------------------------------------------------
+ *  IOCTL videoc handling
+ *  ----------------------------------------------------------------------*/
+
+/* --------Capture ioctls ------------------------------------------------*/
+/* Device capabilities callback function.
+ */
+static int atmel_isi_capture_querycap(struct file *file, void *priv,
+			      struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "atmel-isi");
+	strcpy(cap->card, "Atmel Image Sensor Interface");
+	cap->version = ATMEL_ISI_VERSION;
+	/* V4L2_CAP_VIDEO_CAPTURE -> This is a capture device
+	 * V4L2_CAP_READWRITE -> read/write interface used
+	 */
+	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE
+			     | V4L2_CAP_READWRITE
+			     );
+	return 0;
+}
+
+/*  Input enumeration callback function.
+ *  Enumerates available input devices.
+ *  This can be called many times from the V4L2-layer by
+ *  incrementing the index to get all avaliable input devices.
+ */
+static int atmel_isi_capture_enum_input(struct file *file, void *priv,
+				struct v4l2_input *input)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	/* Just one input (ISI) is available */
+	if (input->index != 0)
+		return -EINVAL;
+
+	/* Set input name as camera name */
+	strlcpy(input->name, "atmel-isi stream", sizeof(input->name));
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+
+	/* Set to this value just because this should be set to a
+	 * defined value
+	 */
+	input->std = V4L2_STD_PAL;
+
+	return 0;
+}
+/* Selects an input device.
+ *  One input device (ISI) currently supported.
+ */
+static int atmel_isi_capture_s_input(struct file *file, void *priv,
+			     unsigned int index)
+{
+	if (index != 0)
+		return -EINVAL;
+	return 0;
+}
+
+/* Gets current input device.
+ */
+static int atmel_isi_capture_g_input(struct file *file, void *priv,
+			     unsigned int *index)
+{
+	*index = 0;
+	return 0;
+}
+
+/* Format callback function
+ * Returns a v4l2_fmtdesc structure with according values to a
+ * index.
+ * This function is called from user space until it returns
+ * -EINVAL.
+ */
+static int atmel_isi_capture_enum_fmt_cap(struct file *file, void *priv,
+				  struct v4l2_fmtdesc *fmt)
+{
+	if (fmt->index != 0)
+		return -EINVAL;
+
+	/* if we want to pretend another ISI output
+	 * this is usefull if we input an other input format from a camera
+	 * than specified in the ISI -> makes it possible to swap bytes
+	 * in the ISI output format but messes up the preview path output
+	 */
+	if (capture_v4l2_fmt) {
+		fmt->pixelformat = capture_v4l2_fmt;
+	} else {
+		/* This is the format the ISI tries to output */
+		strcpy(fmt->description, "YCbYCr (YUYV) 4:2:2");
+		fmt->pixelformat = V4L2_PIX_FMT_YUYV;
+	}
+
+	return 0;
+}
+
+static int atmel_isi_capture_try_fmt_cap(struct file *file, void *priv,
+			struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+	/* Just return the current format for now */
+	memcpy(&vfmt->fmt.pix, &isi->format.pix,
+		sizeof(struct v4l2_pix_format));
+
+	return 0;
+}
+
+/* Gets current hardware configuration
+ *  For capture devices the pixel format settings are
+ *  important.
+ */
+static int atmel_isi_capture_g_fmt_cap(struct file *file, void *priv,
+			       struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	/* Return current pixel format */
+	memcpy(&vfmt->fmt.pix, &isi->format.pix,
+	       sizeof(struct v4l2_pix_format));
+
+	return 0;
+}
+
+static int atmel_isi_capture_s_fmt_cap(struct file *file, void *priv,
+			       struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+	int ret = 0;
+
+	/* We have a fixed format so just copy the current format
+	 * back
+	 */
+	memcpy(&vfmt->fmt.pix, &isi->format.pix,
+		sizeof(struct v4l2_pix_format));
+
+	return ret;
+}
+
+/* ------------ Preview path ioctls ------------------------------*/
+/* Device capabilities callback function.
+ */
+static int atmel_isi_streaming_querycap(struct file *file, void *priv,
+			      struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "atmel-isi");
+	strcpy(cap->card, "Atmel Image Sensor Interface");
+	cap->version = ATMEL_ISI_VERSION;
+	/* V4L2_CAP_VIDEO_CAPTURE -> This is a capture device
+	 * V4L2_CAP_READWRITE -> read/write interface used
+	 * V4L2_CAP_STREAMING -> ioctl + mmap interface used
+	 */
+	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE
+			     | V4L2_CAP_READWRITE
+			     | V4L2_CAP_STREAMING
+			     );
+	return 0;
+}
+/* Input enumeration callback function.
+ *  Enumerates available input devices.
+ *  This can be called many times from the V4L2-layer by
+ *  incrementing the index to get all avaliable input devices.
+ */
+static int atmel_isi_streaming_enum_input(struct file *file, void *priv,
+				struct v4l2_input *input)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	/* Just one input (ISI) is available */
+	if (input->index != 0)
+		return -EINVAL;
+
+	/* Set input name as camera name */
+	strlcpy(input->name, "atmel-isi", sizeof(input->name));
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+
+	/* Set to this value just because this should be set to a
+	 * defined value
+	 */
+	input->std = V4L2_STD_PAL;
+
+	return 0;
+}
+/* Selects an input device.
+ *  One input device (ISI) currently supported.
+ */
+static int atmel_isi_streaming_s_input(struct file *file, void *priv,
+			     unsigned int index)
+{
+	if (index != 0)
+		return -EINVAL;
+
+	return 0;
+}
+/* Gets current input device.
+ */
+static int atmel_isi_streaming_g_input(struct file *file, void *priv,
+			     unsigned int *index)
+{
+	*index = 0;
+	return 0;
+}
+
+/* Format callback function
+ * Returns a v4l2_fmtdesc structure with according values to a
+ * index.
+ * This function is called from user space until it returns
+ * -EINVAL.
+ */
+static int atmel_isi_streaming_enum_fmt_cap(struct file *file, void *priv,
+				  struct v4l2_fmtdesc *fmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	if (fmt->index != 0)
+		return -EINVAL;
+
+	/* TODO: Return all possible formats
+	* This depends on ISI and camera.
+	* A enum_fmt function or a data structure should be
+	* added to the camera driver.
+	* For now just one format supported
+	*/
+	if (streaming_v4l2_fmt)
+		strcpy(fmt->description, "Pretended format");
+	else
+		strcpy(fmt->description, "Normal format");
+
+	/* The pretended and normal format are already set earlier */
+	fmt->pixelformat = isi->streaming_format.pix.pixelformat;
+
+	return 0;
+}
+static int atmel_isi_streaming_try_fmt_cap(struct file *file, void *priv,
+			struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	/* FIXME For now we just return the current format*/
+	memcpy(&vfmt->fmt.pix, &isi->streaming_format.pix,
+		sizeof(struct v4l2_pix_format));
+	return 0;
+}
+/* Gets current hardware configuration
+ *  For capture devices the pixel format settings are
+ *  important.
+ */
+static int atmel_isi_streaming_g_fmt_cap(struct file *file, void *priv,
+			       struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+
+	/*Copy current pixel format structure to user space*/
+	memcpy(&vfmt->fmt.pix, &isi->streaming_format.pix,
+	       sizeof(struct v4l2_pix_format));
+
+	return 0;
+}
+static int atmel_isi_streaming_s_fmt_cap(struct file *file, void *priv,
+			       struct v4l2_format *vfmt)
+{
+	struct atmel_isi_fh *fh = priv;
+	struct atmel_isi *isi = fh->isi;
+	int ret = 0;
+
+	if (vfmt->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV) {
+		/* Just return the current format as we do not support
+		* format switching */
+		pr_debug("S_FMT: format not supported(only YUV)\n");
+		memcpy(&vfmt->fmt.pix, &isi->streaming_format.pix,
+			sizeof(struct v4l2_pix_format));
+	} else {
+		/* Set the sensor accordingly */
+		memcpy(&isi->format.pix, &vfmt->fmt.pix,
+			sizeof(struct v4l2_pix_format));
+		v4l2_subdev_call(isi->sd, video, s_fmt, vfmt);
+	}
+
+	return ret;
+}
+/* Checks if control is supported in driver
+ * No controls currently supported yet
+ */
+static int atmel_isi_streaming_queryctrl(struct file *file, void *priv,
+			   struct v4l2_queryctrl *qc)
+{
+	switch (qc->id) {
+	case V4L2_CID_BRIGHTNESS:
+		strcpy(qc->name, "Brightness");
+		qc->minimum = 0;
+		qc->maximum = 100;
+		qc->step = 1;
+		qc->default_value = 50;
+		qc->flags = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+static int atmel_isi_streaming_g_ctrl(struct file *file, void *priv,
+			struct v4l2_control *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+static int atmel_isi_streaming_s_ctrl(struct file *file, void *priv,
+			struct v4l2_control *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+static int atmel_isi_reqbufs(struct file *file, void *private_data,
+			struct v4l2_requestbuffers *req)
+{
+	/* Only memory mapped buffers supported*/
+	if (req->memory != V4L2_MEMORY_MMAP) {
+		pr_debug("atmel_isi: buffer format not supported\n");
+		return -EINVAL;
+	}
+	pr_debug("atmel_isi: Requested %d buffers. Using %d buffers\n",
+		req->count, video_buffers);
+	/* buffer number is fixed for now as it is difficult to get
+	 * that memory at runtime */
+	req->count = video_buffers;
+	memset(&req->reserved, 0, sizeof(req->reserved));
+	return 0;
+}
+
+static int atmel_isi_querybuf(struct file *file, void *private_data,
+			struct v4l2_buffer *buf)
+{
+	struct atmel_isi_fh *fh = private_data;
+	struct atmel_isi *isi = fh->isi;
+	struct frame_buffer *buffer;
+
+	if (unlikely(buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+	if (unlikely(buf->index >= video_buffers))
+		return -EINVAL;
+
+	buffer = &(isi->video_buffer[buf->index]);
+
+	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf->length = video_buffer_size;
+	buf->memory = V4L2_MEMORY_MMAP;
+
+	/* set index as mmap reference to the buffer */
+	buf->m.offset = buf->index << PAGE_SHIFT;
+
+	switch (buffer->status) {
+	case FRAME_UNUSED:
+	case FRAME_ERROR:
+	case FRAME_QUEUED:
+		buf->flags |= V4L2_BUF_FLAG_QUEUED;
+		buf->bytesused = buffer->bytes_used;
+		break;
+	case FRAME_DONE:
+		buf->flags |= V4L2_BUF_FLAG_DONE;
+		buf->bytesused = buffer->bytes_used;
+		buf->sequence = buffer->sequence;
+		buf->timestamp = buffer->timestamp;
+		break;
+	}
+
+	buf->field = V4L2_FIELD_NONE; /* no interlacing stuff */
+
+	if (buffer->mmap_count)
+		buf->flags |= V4L2_BUF_FLAG_MAPPED;
+	else
+		buf->flags &= ~V4L2_BUF_FLAG_MAPPED;
+
+	pr_debug("atmel_isi: querybuf index:%d offset:%d\n",
+		buf->index, buf->m.offset);
+
+	return 0;
+}
+
+static int atmel_isi_qbuf(struct file *file, void *private_data,
+			struct v4l2_buffer *buf)
+{
+	struct atmel_isi_fh *fh = private_data;
+	struct atmel_isi *isi = fh->isi;
+	struct frame_buffer *buffer, *next_buffer;
+	u32 old_ctrl;
+
+	if (unlikely(buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	if (unlikely(buf->index >= video_buffers || buf->index < 0)) {
+		pr_debug("Buffer index is not valid index=%d\n", buf->index);
+		return -EINVAL;
+	}
+
+	if (unlikely(buf->memory != V4L2_MEMORY_MMAP)) {
+		pr_debug("Buffer is not of MEMORY_MMAP type\n");
+		return -EINVAL;
+	}
+
+	buffer = &(isi->video_buffer[isi->tail]);
+	isi->tail++;
+	if (isi->tail == (video_buffers))
+		isi->tail = 0;
+	next_buffer = &(isi->video_buffer[isi->tail]);
+
+	/* disable fetch on next buff */
+	next_buffer->fb_desc.dma_ctrl &= ~ISI_BIT(V2_DMA_FETCH);
+	buffer->fb_desc.dma_ctrl |= ISI_BIT(V2_DMA_FETCH);
+
+	/* Restart the ISI transfert if suspended */
+	old_ctrl = isi_readl(isi, V2_DMA_C_CTRL);
+	isi_writel(isi, V2_DMA_C_CTRL, ISI_BIT(V2_DMA_FETCH) | old_ctrl);
+	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
+
+	mutex_lock(&isi->mutex);
+	buf->flags |= V4L2_BUF_FLAG_QUEUED;
+	buf->flags &= ~V4L2_BUF_FLAG_DONE;
+	buffer->status = FRAME_QUEUED;
+
+	mutex_unlock(&isi->mutex);
+
+	return 0;
+}
+
+static int atmel_isi_dqbuf(struct file *file, void *private_data,
+			struct v4l2_buffer *buf)
+{
+	struct atmel_isi_fh *fh = private_data;
+	struct atmel_isi *isi = fh->isi;
+	struct frame_buffer *buffer;
+	static int sequence;
+
+	if (unlikely(buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	buffer = &(isi->video_buffer[isi->head]);
+	/* TEST if C_DONE == 1 ie isi transfer */
+	if ((buffer->fb_desc.dma_ctrl & ISI_BIT(V2_DMA_DONE)) == 0) {
+		pr_debug("In dqbuf: Buffer not ready\n");
+		return -EAGAIN;
+	} else {
+		buffer->status = FRAME_DONE;
+	}
+
+	buffer->fb_desc.dma_ctrl &= ~ISI_BIT(V2_DMA_DONE) ;
+
+	if (unlikely(buffer->status == FRAME_QUEUED)) {
+		if (isi->streaming == 0)
+			return 0;
+		pr_debug("isi: error, dequeued buffer not ready\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&isi->mutex);
+	buf->index = isi->head;
+	buf->bytesused = buffer->bytes_used;
+	do_gettimeofday(&buf->timestamp);
+	buf->timestamp.tv_sec -= start_time.tv_sec;
+	buf->timestamp.tv_usec -= start_time.tv_usec;
+	buf->sequence = sequence++;
+	buf->m.offset = (isi->head) << PAGE_SHIFT;
+	buffer->status = FRAME_UNUSED;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE;
+	buf->length = video_buffer_size;
+	buf->field = V4L2_FIELD_NONE;
+	buf->memory = V4L2_MEMORY_MMAP;
+	mutex_unlock(&isi->mutex);
+
+	isi->head++;
+	if ((isi->head) == (video_buffers))
+		isi->head = 0;
+
+	return 0;
+}
+static int atmel_isi_streamon(struct file *file, void *private_data,
+			enum v4l2_buf_type type)
+{
+	struct atmel_isi_fh *fh = private_data;
+	struct atmel_isi *isi = fh->isi;
+	int i;
+	struct frame_buffer *buffer;
+	u32 cfg1, ctrl;
+
+	if (unlikely(type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	/* reset ISI transfert desc */
+	for (i = 0; i < (video_buffers - 1); i++)
+		isi->video_buffer[i].fb_desc.dma_ctrl =
+				ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_WB);
+
+	/* ISI will stop at this point(last buffer of the queue) */
+	isi->video_buffer[i].fb_desc.dma_ctrl = ISI_BIT(V2_DMA_WB);
+
+	buffer = &(isi->video_buffer[isi->head]);
+
+	spin_lock_irq(&isi->lock);
+	isi->streaming = 1;
+
+	ctrl = isi_readl(isi, V2_CTRL);
+	cfg1 = isi_readl(isi, V2_CFG1);
+	/* Disable irq: cxfr for the codec path, pxfr for the preview path */
+	isi_writel(isi, V2_INTDIS,
+			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
+
+	/* Enable codec path */
+	ctrl |= ISI_BIT(V2_CDC);
+
+	/* Write the address of the first frame buffer in the C_ADDR reg
+	* write the address of the first descriptor(link list of buffer)
+	* in the C_DSCR reg, and enable dma channel.
+	*/
+	isi_writel(isi, V2_DMA_C_DSCR, (__pa(&(buffer->fb_desc))));
+	isi_writel(isi, V2_DMA_C_CTRL,
+			ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_DONE));
+	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
+
+	/* Enable linked list */
+	cfg1 |= ISI_BF(V2_FRATE, frame_rate_scaler) | ISI_BIT(V2_DISCR);
+
+	/* Enable ISI module*/
+	ctrl |= ISI_BIT(V2_ENABLE);
+	isi_writel(isi, V2_CTRL, ctrl);
+	isi_writel(isi, V2_CFG1, cfg1);
+
+	/* To properly set the timestamp we need to record the time at start
+	 * up*/
+	do_gettimeofday(&start_time);
+
+	spin_unlock_irq(&isi->lock);
+
+	return 0;
+}
+
+static int atmel_isi_streamoff(struct file *file, void *private_data,
+			enum v4l2_buf_type type)
+{
+	struct atmel_isi_fh *fh = private_data;
+	struct atmel_isi *isi = fh->isi;
+	int reqnr;
+
+	if (unlikely(type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	spin_lock_irq(&isi->lock);
+	isi->streaming = 0;
+
+	/* Disble codec path */
+	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) & (~ISI_BIT(V2_CDC)));
+	/* Disable interrupts */
+	isi_writel(isi, V2_INTDIS,
+			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
+	/* Disable ISI module*/
+	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_DIS));
+
+	spin_unlock_irq(&isi->lock);
+
+	for (reqnr = 0;  reqnr < video_buffers; reqnr++)
+		isi->video_buffer[reqnr].status = FRAME_UNUSED;
+
+	return 0;
+}
+static int atmel_isi_g_parm(struct file *file, void *f,
+				struct v4l2_streamparm *parm)
+{
+	int err = 0;
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return err;
+}
+/*----------------------------------------------------------------------------*/
+
+static int atmel_isi_init(struct atmel_isi *isi)
+{
+	unsigned long timeout;
+
+	/*
+	 * Reset the controller and wait for completion.
+	 * The reset will only succeed if we have a
+	 * pixel clock from the camera.
+	 */
+	init_completion(&isi->reset_complete);
+
+	isi_writel(isi, V2_INTEN, ISI_BIT(V2_SRST));
+	isi_writel(isi, V2_CTRL, ISI_BIT(V2_SRST));
+
+	timeout = wait_for_completion_timeout(&isi->reset_complete,
+		msecs_to_jiffies(100));
+	if (timeout == 0)
+		return -ETIMEDOUT;
+
+	isi_writel(isi, V2_INTDIS, ~0UL);
+
+	atmel_isi_set_default_format(isi);
+
+	atmel_isi_init_hardware(isi);
+
+	return 0;
+}
+
+static int atmel_isi_capture_close(struct file *file)
+{
+	struct atmel_isi_fh *fh = file->private_data;
+	struct atmel_isi *isi = fh->isi;
+	u32 cr;
+
+	mutex_lock(&isi->mutex);
+
+	isi->capture_users--;
+	kfree(fh);
+
+	/* Stop camera and ISI  if driver has no users */
+	if (!isi->stream_users) {
+
+		spin_lock_irq(&isi->lock);
+
+		cr = isi_readl(isi, V2_CTRL);
+		cr |= ISI_BIT(V2_DIS);
+		isi_writel(isi, V2_CTRL, cr);
+
+		spin_unlock_irq(&isi->lock);
+	}
+	mutex_unlock(&isi->mutex);
+
+	return 0;
+}
+
+static int atmel_isi_capture_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct atmel_isi *isi = container_of(vdev, struct atmel_isi, cdev);
+	struct atmel_isi_fh *fh;
+	int ret = -EBUSY;
+
+	pr_debug("%s: opened\n", isi->cdev.name);
+
+	mutex_lock(&isi->mutex);
+
+	if (isi->capture_users) {
+		pr_debug("%s: open(): device busy\n", isi->cdev.name);
+		goto out;
+	}
+
+	/* If the streaming interface has no users too we do a
+	 * init of the hardware and software configuration.
+	 */
+	if (isi->stream_users == 0) {
+		ret = atmel_isi_init(isi);
+		if (ret)
+			goto out;
+	}
+
+	ret = -ENOMEM;
+	fh = kzalloc(sizeof(struct atmel_isi_fh), GFP_KERNEL);
+	if (!fh) {
+		pr_debug("%s: open(): out of memory\n", isi->cdev.name);
+		goto out;
+	}
+
+
+	fh->isi = isi;
+	file->private_data = fh;
+	isi->capture_users++;
+
+	ret = 0;
+
+out:
+	mutex_unlock(&isi->mutex);
+	return ret;
+}
+
+static ssize_t atmel_isi_capture_read(struct file *file, char __user *data,
+			      size_t count, loff_t *ppos)
+{
+	struct atmel_isi_fh *fh = file->private_data;
+	struct atmel_isi *isi = fh->isi;
+	int state;
+	int ret;
+
+	state = STATE_IDLE;
+
+	pr_debug("isi: read %zu bytes read_off=%u state=%u sizeimage=%u\n",
+		count, fh->read_off, state, isi->format.pix.sizeimage);
+
+	atmel_isi_start_capture(isi);
+
+	ret = wait_event_interruptible(isi->capture_wq,
+			(isi->state == STATE_CAPTURE_DONE)
+			|| (isi->state == STATE_CAPTURE_ERROR));
+
+	if (ret)
+		return ret;
+
+	if (isi->state == STATE_CAPTURE_ERROR) {
+		isi->state = STATE_IDLE;
+		return -EIO;
+	}
+
+	fh->read_off = 0;
+
+	count = min(count, (size_t)isi->format.pix.sizeimage - fh->read_off);
+	ret = copy_to_user(data, isi->capture_buf + fh->read_off, count);
+	if (ret)
+		return -EFAULT;
+
+	fh->read_off += count;
+	if (fh->read_off >= isi->format.pix.sizeimage)
+		isi->state = STATE_IDLE;
+
+	return count;
+}
+
+static void atmel_isi_capture_release(struct video_device *vdev)
+{
+	pr_debug("%s: release\n", vdev->name);
+}
+/* ----------------- Streaming interface -------------------------------------*/
+static void atmel_isi_vm_open(struct vm_area_struct *vma)
+{
+	struct frame_buffer *buffer =
+		(struct frame_buffer *) vma->vm_private_data;
+	buffer->mmap_count++;
+	pr_debug("atmel_isi: vm_open count=%d\n", buffer->mmap_count);
+}
+
+static void atmel_isi_vm_close(struct vm_area_struct *vma)
+{
+	struct frame_buffer *buffer =
+		(struct frame_buffer *) vma->vm_private_data;
+	pr_debug("atmel_isi: vm_close count=%d\n", buffer->mmap_count);
+	buffer->mmap_count--;
+	if (buffer->mmap_count < 0)
+		printk(KERN_INFO "atmel_isi: mmap_count went negative\n");
+}
+
+static struct vm_operations_struct atmel_isi_vm_ops = {
+	.open = atmel_isi_vm_open,
+	.close = atmel_isi_vm_close,
+};
+
+static int atmel_isi_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long pfn;
+	int ret;
+	struct atmel_isi_fh *fh = file->private_data;
+	struct atmel_isi *isi = fh->isi;
+	struct frame_buffer *buffer = &(isi->video_buffer[vma->vm_pgoff]);
+	unsigned long size = vma->vm_end - vma->vm_start;
+
+	pr_debug("atmel_isi: mmap called pgoff=%ld size=%ld \n",
+		vma->vm_pgoff, size);
+
+	if (size > video_buffer_size) {
+		pr_debug("atmel_isi: mmap requested buffer is to large\n");
+		return -EINVAL;
+	}
+	if (vma->vm_pgoff > video_buffers) {
+		pr_debug("atmel_isi: invalid mmap page offset\n");
+		return -EINVAL;
+	}
+	pfn = isi->video_buffer[vma->vm_pgoff].fb_desc.fb_address >> PAGE_SHIFT;
+
+	ret = remap_pfn_range(vma, vma->vm_start, pfn,
+		vma->vm_end - vma->vm_start, vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_ops = &atmel_isi_vm_ops;
+	vma->vm_flags |= VM_DONTEXPAND; /* fixed size */
+	vma->vm_flags |= VM_RESERVED;/* do not swap out */
+	vma->vm_flags |= VM_DONTCOPY;
+	vma->vm_flags |= VM_SHARED;
+	vma->vm_private_data = (void *) buffer;
+	atmel_isi_vm_open(vma);
+
+	pr_debug("atmel_isi: vma start=0x%08lx, size=%ld phys=%ld \n",
+		(unsigned long) vma->vm_start,
+		(unsigned long) vma->vm_end - (unsigned long) vma->vm_start,
+		pfn << PAGE_SHIFT);
+
+	return 0;
+}
+
+static int atmel_isi_stream_close(struct file *file)
+{
+	struct atmel_isi_fh *fh = file->private_data;
+	struct atmel_isi *isi = fh->isi;
+	u32 cr;
+
+	mutex_lock(&isi->mutex);
+
+	isi->stream_users--;
+	kfree(fh);
+
+	/* Stop camera and ISI if driver has no users */
+	if (!isi->capture_users) {
+		spin_lock_irq(&isi->lock);
+		cr = isi_readl(isi, V2_CTRL);
+		cr |= ISI_BIT(V2_DIS);
+		isi_writel(isi, V2_CTRL, cr);
+		spin_unlock_irq(&isi->lock);
+	}
+
+	mutex_unlock(&isi->mutex);
+
+	return 0;
+}
+
+static int atmel_isi_stream_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct atmel_isi *isi = to_atmel_isi(vdev);
+	struct atmel_isi_fh *fh;
+	int ret = -EBUSY;
+
+	mutex_lock(&isi->mutex);
+	/* Just one user is allowed for the streaming device*/
+	if (isi->stream_users) {
+		pr_debug("%s: open(): device busy\n", vdev->name);
+		goto out;
+	}
+
+	/* If the capture interface is unused too we do a
+	 * init of hardware/software configuration
+	 */
+	if (isi->capture_users == 0) {
+		ret = atmel_isi_init(isi);
+		if (ret)
+			goto out;
+	}
+
+	ret = -ENOMEM;
+	fh = kzalloc(sizeof(struct atmel_isi_fh), GFP_KERNEL);
+	if (!fh) {
+		pr_debug("%s: open(): out of memory\n", vdev->name);
+		goto out;
+	}
+
+	fh->isi = isi;
+	file->private_data = fh;
+	isi->stream_users++;
+
+	ret = 0;
+
+out:
+	mutex_unlock(&isi->mutex);
+	return ret;
+}
+
+static void atmel_isi_stream_release(struct video_device *vdev)
+{
+	struct atmel_isi *isi = to_atmel_isi(vdev);
+	pr_debug("%s: release\n", vdev->name);
+	kfree(isi);
+}
+/* -----------------------------------------------------------------------*/
+/* Streaming v4l2 device file operations */
+static struct v4l2_file_operations atmel_isi_streaming_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= video_ioctl2,
+	.open		= atmel_isi_stream_open,
+	.release	= atmel_isi_stream_close,
+	.mmap		= atmel_isi_mmap,
+};
+/* Capture v4l2 device file operations */
+static struct v4l2_file_operations atmel_isi_capture_fops = {
+	.owner		= THIS_MODULE,
+	.open		= atmel_isi_capture_open,
+	.release	= atmel_isi_capture_close,
+	.read		= atmel_isi_capture_read,
+	.ioctl		= video_ioctl2,
+};
+
+static int __exit atmel_isi_remove(struct platform_device *pdev)
+{
+	struct atmel_isi *isi = platform_get_drvdata(pdev);
+	int i;
+
+	kfree(&isi->sd);
+	v4l2_device_unregister(&isi->v4l2_dev);
+	video_unregister_device(&isi->cdev);
+	video_unregister_device(&isi->vdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	/* release capture buffer */
+	dma_free_coherent(&pdev->dev, capture_buffer_size,
+			  isi->capture_buf, isi->capture_phys);
+
+	/* release frame buffers */
+	for (i = 0; i < video_buffers; i++) {
+		dma_free_coherent(&pdev->dev,
+			video_buffer_size,
+			isi->video_buffer[i].frame_buffer,
+			isi->video_buffer[i].fb_desc.fb_address);
+	}
+
+	free_irq(isi->irq, isi);
+	iounmap(isi->regs);
+	clk_disable(isi->hclk);
+	clk_disable(isi->pclk);
+	clk_put(isi->hclk);
+	clk_put(isi->pclk);
+
+	/*
+	 * Don't free isi here -- it will be taken care of by the
+	 * release() callback.
+	 */
+
+	return 0;
+}
+
+
+static const struct v4l2_ioctl_ops atmel_isi_capture_ioctl_ops = {
+	.vidioc_querycap		= atmel_isi_capture_querycap,
+	.vidioc_enum_fmt_vid_cap	= atmel_isi_capture_enum_fmt_cap,
+	.vidioc_g_fmt_vid_cap		= atmel_isi_capture_g_fmt_cap,
+	.vidioc_try_fmt_vid_cap		= atmel_isi_capture_try_fmt_cap,
+	.vidioc_s_fmt_vid_cap		= atmel_isi_capture_s_fmt_cap,
+	.vidioc_reqbufs			= atmel_isi_reqbufs,
+	.vidioc_querybuf		= atmel_isi_querybuf,
+	.vidioc_qbuf			= atmel_isi_qbuf,
+	.vidioc_dqbuf			= atmel_isi_dqbuf,
+	.vidioc_enum_input		= atmel_isi_capture_enum_input,
+	.vidioc_g_input			= atmel_isi_capture_g_input,
+	.vidioc_s_input			= atmel_isi_capture_s_input,
+};
+
+static struct video_device atmel_isi_capture_template = {
+	.fops		= &atmel_isi_capture_fops,
+	.minor		= -1,
+	.ioctl_ops	= &atmel_isi_capture_ioctl_ops,
+	.current_norm	= V4L2_STD_PAL,
+};
+static const struct v4l2_ioctl_ops atmel_isi_streaming_ioctl_ops = {
+	.vidioc_querycap		= atmel_isi_streaming_querycap,
+	.vidioc_enum_fmt_vid_cap	= atmel_isi_streaming_enum_fmt_cap,
+	.vidioc_g_fmt_vid_cap		= atmel_isi_streaming_g_fmt_cap,
+	.vidioc_try_fmt_vid_cap		= atmel_isi_streaming_try_fmt_cap,
+	.vidioc_s_fmt_vid_cap		= atmel_isi_streaming_s_fmt_cap,
+	.vidioc_reqbufs			= atmel_isi_reqbufs,
+	.vidioc_querybuf		= atmel_isi_querybuf,
+	.vidioc_qbuf			= atmel_isi_qbuf,
+	.vidioc_dqbuf			= atmel_isi_dqbuf,
+	.vidioc_enum_input		= atmel_isi_streaming_enum_input,
+	.vidioc_g_input			= atmel_isi_streaming_g_input,
+	.vidioc_s_input			= atmel_isi_streaming_s_input,
+	.vidioc_queryctrl		= atmel_isi_streaming_queryctrl,
+	.vidioc_g_ctrl			= atmel_isi_streaming_g_ctrl,
+	.vidioc_s_ctrl			= atmel_isi_streaming_s_ctrl,
+	.vidioc_streamon		= atmel_isi_streamon,
+	.vidioc_streamoff		= atmel_isi_streamoff,
+	.vidioc_g_parm			= atmel_isi_g_parm,
+};
+
+static struct video_device atmel_isi_streaming_template = {
+	.fops		= &atmel_isi_streaming_fops,
+	.minor		= -1,
+	.ioctl_ops	= &atmel_isi_streaming_ioctl_ops,
+	.current_norm	= V4L2_STD_PAL,
+};
+
+
+static int __init atmel_isi_probe(struct platform_device *pdev)
+{
+	unsigned int irq;
+	struct atmel_isi *isi;
+	struct clk *pclk;
+	struct resource *regs;
+	int ret;
+	int i;
+	int video_bytes_used = video_buffer_size;
+	struct device *dev = &pdev->dev;
+	struct isi_platform_data *pdata;
+	struct i2c_adapter *i2c_adap;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	pclk = clk_get(&pdev->dev, "isi_clk");
+	if (IS_ERR(pclk))
+		return PTR_ERR(pclk);
+
+	clk_enable(pclk);
+
+	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
+	if (!isi) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "can't allocate interface!\n");
+		goto err_alloc_isi;
+	}
+
+	isi->pclk = pclk;
+	spin_lock_init(&isi->lock);
+	mutex_init(&isi->mutex);
+	init_waitqueue_head(&isi->capture_wq);
+
+	/* Initialize v4l2 capture device */
+	isi->cdev = atmel_isi_capture_template;
+	isi->cdev.release = atmel_isi_capture_release;
+	strcpy(isi->cdev.name, "atmel_isi_capture");
+#ifdef DEBUG
+	isi->cdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
+#endif
+
+	/* Initialize v4l2 streaming device */
+	isi->vdev = atmel_isi_streaming_template;
+	isi->vdev.release = atmel_isi_stream_release;
+	strcpy(isi->vdev.name, "atmel_isi_streaming");
+#ifdef DEBUG
+	isi->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
+#endif
+	isi->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!isi->regs) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	if (dev->platform_data) {
+		pdata = (struct isi_platform_data *) dev->platform_data;
+		image_hsize = pdata->image_hsize;
+		image_vsize = pdata->image_vsize;
+
+		/* load i2c info */
+		isi->board_info = pdata->board_info;
+
+		if (pdata->prev_hsize)
+			prev_hsize = pdata->prev_hsize;
+		if (pdata->prev_vsize)
+			prev_vsize = pdata->prev_vsize;
+		if (pdata->pixfmt)
+			input_format = pdata->pixfmt;
+		else
+			input_format = ATMEL_ISI_PIXFMT_YCbYCr;
+		frame_rate_scaler = pdata->frate;
+		if (pdata->capture_v4l2_fmt)
+			capture_v4l2_fmt = pdata->capture_v4l2_fmt;
+		if (pdata->streaming_v4l2_fmt)
+			streaming_v4l2_fmt = pdata->streaming_v4l2_fmt;
+		if (pdata->cr1_flags & ISI_HSYNC_ACT_LOW)
+			hsync_act_low = 1;
+		if (pdata->cr1_flags & ISI_VSYNC_ACT_LOW)
+			vsync_act_low = 1;
+		if (pdata->cr1_flags & ISI_PXCLK_ACT_FALLING)
+			pclk_act_falling = 1;
+		if (pdata->cr1_flags & ISI_EMB_SYNC)
+			has_emb_sync = 1;
+		if (pdata->cr1_flags & ISI_CRC_SYNC)
+			emb_crc_sync = 1;
+		if (pdata->cr1_flags & ISI_FULL)
+			isi_full_mode = 1;
+	} else {
+		has_emb_sync = 0;
+		emb_crc_sync = 0;
+		hsync_act_low = 0;
+		vsync_act_low = 0;
+		pclk_act_falling = 0;
+		isi_full_mode = 0;
+		prev_hsize = 320;
+		prev_vsize = 240;
+		image_hsize = 320;
+		image_vsize = 240;
+		dev_info(&pdev->dev,
+				"No config available using default values\n");
+	}
+
+	video_buffer_size = prev_hsize * prev_vsize * 2;
+	video_bytes_used = video_buffer_size;
+
+	/* Round up buffer sizes to the next page if needed */
+	video_buffer_size = PAGE_ALIGN(video_buffer_size);
+	capture_buffer_size = PAGE_ALIGN(capture_buffer_size);
+
+	isi_writel(isi, V2_CTRL, ISI_BIT(V2_DIS));
+	/* Check if module disable */
+	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS))
+		cpu_relax();
+
+	irq = platform_get_irq(pdev, 0);
+	ret = request_irq(irq, isi_interrupt, 0, "isi", isi);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to request irq %d\n", irq);
+		goto err_req_irq;
+	}
+	isi->irq = irq;
+
+	/* Allocate ISI capture buffer */
+	isi->capture_buf = dma_alloc_coherent(&pdev->dev,
+					      capture_buffer_size,
+					      &isi->capture_phys,
+					      GFP_KERNEL);
+	if (!isi->capture_buf) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "failed to allocate capture buffer\n");
+		goto err_alloc_cbuf;
+	}
+
+	/* Allocate and initialize video buffers */
+	for (i = 0 ; i < video_buffers; i++) {
+		memset(&isi->video_buffer[i], 0, sizeof(struct frame_buffer));
+		isi->video_buffer[i].frame_buffer =
+			dma_alloc_coherent(&pdev->dev,
+				video_buffer_size,
+				(dma_addr_t *)
+				&(isi->video_buffer[i].fb_desc.fb_address),
+				GFP_KERNEL);
+		if (!isi->video_buffer[i].frame_buffer) {
+			ret = -ENOMEM;
+			dev_err(&pdev->dev,
+				"failed to allocate video buffer\n");
+			goto err_alloc_vbuf;
+		}
+
+		isi->video_buffer[i].bytes_used = video_bytes_used;
+		isi->video_buffer[i].status = FRAME_UNUSED;
+		isi->video_buffer[i].index = i;
+	}
+
+	isi->fbd_list_start = __pa(&isi->video_buffer[0].fb_desc);
+	for (i = 0 ; i < (video_buffers - 1); i++) {
+		isi->video_buffer[i].fb_desc.next_fbd_address =
+			__pa(&isi->video_buffer[i+1].fb_desc);
+	}
+	isi->video_buffer[i].fb_desc.next_fbd_address =
+				__pa(&isi->video_buffer[0].fb_desc);
+
+	/* Set head & tail of the TD */
+	isi->head = 0;
+	isi->tail = video_buffers - 1;
+
+	for (i = 0 ; i < video_buffers; i++) {
+		dev_info(&pdev->dev,
+		"video buffer: %d bytes at %p (phys %08lx)\n",
+		video_buffer_size,
+		isi->video_buffer[i].frame_buffer,
+		(unsigned long) isi->video_buffer[i].fb_desc.fb_address);
+	}
+
+	dev_info(&pdev->dev,
+		 "capture buffer: %d bytes at %p (phys 0x%08x)\n",
+		 capture_buffer_size, isi->capture_buf,
+		 isi->capture_phys);
+
+	ret = video_register_device(&isi->cdev, VFL_TYPE_GRABBER, video_nr);
+	if (ret) {
+		dev_err(&pdev->dev, "Registering capturing device failed\n");
+		video_device_release(&isi->cdev);
+		kfree(dev);
+		goto err_register1;
+	}
+
+	ret = video_register_device(&isi->vdev, VFL_TYPE_GRABBER, video_nr);
+	if (ret) {
+		dev_err(&pdev->dev, "Registering streaming device failed\n");
+		video_device_release(&isi->vdev);
+		kfree(dev);
+		goto err_register2;
+	}
+
+	ret = v4l2_device_register(dev, &isi->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Unable to register v4l2 device.\n");
+		goto err_register_v4l2_device;
+	}
+
+	platform_set_drvdata(pdev, isi);
+
+	/* Set the subdev info */
+	i2c_adap = i2c_get_adapter(0);
+	isi->sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	/* Load up the subdevice */
+	isi->sd =
+		v4l2_i2c_new_subdev_board(&isi->v4l2_dev,
+					  i2c_adap,
+					  "atmel_isi",
+					  &isi->board_info,
+					  NULL);
+	if (isi->sd) {
+		dev_err(&pdev->dev,
+			  "v4l2 sub device registered\n");
+	} else {
+		dev_err(&pdev->dev,
+			  "v4l2 sub device register fails\n");
+		goto probe_sd_out;
+	}
+
+	dev_info(&pdev->dev, "Atmel ISI V4L2 device at 0x%08lx\n",
+		 (unsigned long)regs->start);
+
+	return 0;
+
+probe_sd_out:
+	kfree(isi->sd);
+err_register_v4l2_device:
+	v4l2_device_unregister(&isi->v4l2_dev);
+err_register2:
+	video_unregister_device(&isi->vdev);
+err_register1:
+	video_unregister_device(&isi->cdev);
+err_alloc_vbuf:
+	while (i--)
+		dma_free_coherent(&pdev->dev, video_buffer_size,
+				isi->video_buffer[i].frame_buffer,
+				isi->video_buffer[i].fb_desc.fb_address);
+err_alloc_cbuf:
+	dma_free_coherent(&pdev->dev, capture_buffer_size,
+				isi->capture_buf,
+				isi->capture_phys);
+	free_irq(isi->irq, isi);
+err_req_irq:
+	iounmap(isi->regs);
+err_ioremap:
+	kfree(isi);
+err_alloc_isi:
+	clk_disable(pclk);
+
+	return ret;
+
+}
+
+static struct platform_driver atmel_isi_driver = {
+	.probe		= atmel_isi_probe,
+	.remove		= __exit_p(atmel_isi_remove),
+	.driver		= {
+		.name = "atmel_isi",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init atmel_isi_init_module(void)
+{
+	return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
+}
+
+
+static void __exit atmel_isi_exit(void)
+{
+	platform_driver_unregister(&atmel_isi_driver);
+}
+
+
+module_init(atmel_isi_init_module);
+module_exit(atmel_isi_exit);
+
+MODULE_AUTHOR("Lars Häring <lharing@atmel.com>");
+MODULE_DESCRIPTION("The V4L2 driver for atmel Linux");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("video");
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
new file mode 100644
index 0000000..1776fea
--- /dev/null
+++ b/include/media/atmel-isi.h
@@ -0,0 +1,460 @@
+/*
+ * Register definitions for the Atmel Image Sensor Interface.
+ *
+ * Copyright (C) 2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_AVR32_ISI_H__
+#define __ASM_AVR32_ISI_H__
+
+#include <linux/videodev2.h>
+#include <linux/i2c.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+/* ISI register offsets */
+#define ISI_CR1					0x0000
+#define ISI_CR2					0x0004
+#define ISI_SR					0x0008
+#define ISI_IER					0x000c
+#define ISI_IDR					0x0010
+#define ISI_IMR					0x0014
+#define ISI_PSIZE				0x0020
+#define ISI_PDECF				0x0024
+#define ISI_PPFBD				0x0028
+#define ISI_CDBA				0x002c
+#define ISI_Y2R_SET0				0x0030
+#define ISI_Y2R_SET1				0x0034
+#define ISI_R2Y_SET0				0x0038
+#define ISI_R2Y_SET1				0x003c
+#define ISI_R2Y_SET2				0x0040
+
+/* ISI_V2 register offsets */
+#define ISI_V2_CFG1				0x0000
+#define ISI_V2_CFG2				0x0004
+#define ISI_V2_PSIZE				0x0008
+#define ISI_V2_PDECF				0x000c
+#define ISI_V2_Y2R_SET0				0x0010
+#define ISI_V2_Y2R_SET1				0x0014
+#define ISI_V2_R2Y_SET0				0x0018
+#define ISI_V2_R2Y_SET1				0x001C
+#define ISI_V2_R2Y_SET2				0x0020
+#define ISI_V2_CTRL				0x0024
+#define ISI_V2_STATUS				0x0028
+#define ISI_V2_INTEN				0x002C
+#define ISI_V2_INTDIS				0x0030
+#define ISI_V2_INTMASK				0x0034
+#define ISI_V2_DMA_CHER				0x0038
+#define ISI_V2_DMA_CHDR				0x003C
+#define ISI_V2_DMA_CHSR				0x0040
+#define ISI_V2_DMA_P_ADDR			0x0044
+#define ISI_V2_DMA_P_CTRL			0x0048
+#define ISI_V2_DMA_P_DSCR			0x004C
+#define ISI_V2_DMA_C_ADDR			0x0050
+#define ISI_V2_DMA_C_CTRL			0x0054
+#define ISI_V2_DMA_C_DSCR			0x0058
+
+/* Bitfields in CR1 */
+#define ISI_RST_OFFSET				0
+#define ISI_RST_SIZE				1
+#define ISI_DIS_OFFSET				1
+#define ISI_DIS_SIZE				1
+#define ISI_HSYNC_POL_OFFSET			2
+#define ISI_HSYNC_POL_SIZE			1
+#define ISI_VSYNC_POL_OFFSET			3
+#define ISI_VSYNC_POL_SIZE			1
+#define ISI_PIXCLK_POL_OFFSET			4
+#define ISI_PIXCLK_POL_SIZE			1
+#define ISI_EMB_SYNC_OFFSET			6
+#define ISI_EMB_SYNC_SIZE			1
+#define ISI_CRC_SYNC_OFFSET			7
+#define ISI_CRC_SYNC_SIZE			1
+#define ISI_FRATE_OFFSET			8
+#define ISI_FRATE_SIZE				3
+#define ISI_FULL_OFFSET				12
+#define ISI_FULL_SIZE				1
+#define ISI_THMASK_OFFSET			13
+#define ISI_THMASK_SIZE				2
+#define ISI_CODEC_ON_OFFSET			15
+#define ISI_CODEC_ON_SIZE			1
+#define ISI_SLD_OFFSET				16
+#define ISI_SLD_SIZE				8
+#define ISI_SFD_OFFSET				24
+#define ISI_SFD_SIZE				8
+
+/* Bitfields in CFG1 */
+#define ISI_V2_HSYNC_POL_OFFSET			2
+#define ISI_V2_HSYNC_POL_SIZE			1
+#define ISI_V2_VSYNC_POL_OFFSET			3
+#define ISI_V2_VSYNC_POL_SIZE			1
+#define ISI_V2_PIXCLK_POL_OFFSET		4
+#define ISI_V2_PIXCLK_POL_SIZE			1
+#define ISI_V2_EMB_SYNC_OFFSET			6
+#define ISI_V2_EMB_SYNC_SIZE			1
+#define ISI_V2_CRC_SYNC_OFFSET			7
+#define ISI_V2_CRC_SYNC_SIZE			1
+#define ISI_V2_FRATE_OFFSET			8
+#define ISI_V2_FRATE_SIZE			3
+#define ISI_V2_DISCR_OFFSET			11
+#define ISI_V2_DISCR_SIZE			1
+#define ISI_V2_FULL_OFFSET			12
+#define ISI_V2_FULL_SIZE			1
+#define ISI_V2_THMASK_OFFSET			13
+#define ISI_V2_THMASK_SIZE			2
+#define ISI_V2_SLD_OFFSET			16
+#define ISI_V2_SLD_SIZE				8
+#define ISI_V2_SFD_OFFSET			24
+#define ISI_V2_SFD_SIZE				8
+
+/* Bitfields in CR2 */
+#define ISI_IM_VSIZE_OFFSET			0
+#define ISI_IM_VSIZE_SIZE			11
+#define ISI_GS_MODE_OFFSET			11
+#define ISI_GS_MODE_SIZE			1
+#define ISI_RGB_MODE_OFFSET			12
+#define ISI_RGB_MODE_SIZE			1
+#define ISI_GRAYSCALE_OFFSET			13
+#define ISI_GRAYSCALE_SIZE			1
+#define ISI_RGB_SWAP_OFFSET			14
+#define ISI_RGB_SWAP_SIZE			1
+#define ISI_COL_SPACE_OFFSET			15
+#define ISI_COL_SPACE_SIZE			1
+#define ISI_IM_HSIZE_OFFSET			16
+#define ISI_IM_HSIZE_SIZE			11
+#define ISI_YCC_SWAP_OFFSET			28
+#define ISI_YCC_SWAP_SIZE			2
+#define ISI_RGB_CFG_OFFSET			30
+#define ISI_RGB_CFG_SIZE			2
+
+/* Bitfields in CFG2 */
+#define ISI_V2_IM_VSIZE_OFFSET			0
+#define ISI_V2_IM_VSIZE_SIZE			11
+#define ISI_V2_GS_MODE_OFFSET			11
+#define ISI_V2_GS_MODE_SIZE			1
+#define ISI_V2_RGB_MODE_OFFSET			12
+#define ISI_V2_RGB_MODE_SIZE			1
+#define ISI_V2_GRAYSCALE_OFFSET			13
+#define ISI_V2_GRAYSCALE_SIZE			1
+#define ISI_V2_RGB_SWAP_OFFSET			14
+#define ISI_V2_RGB_SWAP_SIZE			1
+#define ISI_V2_COL_SPACE_OFFSET			15
+#define ISI_V2_COL_SPACE_SIZE			1
+#define ISI_V2_IM_HSIZE_OFFSET			16
+#define ISI_V2_IM_HSIZE_SIZE			11
+#define ISI_V2_YCC_SWAP_OFFSET			28
+#define ISI_V2_YCC_SWAP_SIZE			2
+#define ISI_V2_RGB_CFG_OFFSET			30
+#define ISI_V2_RGB_CFG_SIZE			2
+
+/* Bitfields in CTRL */
+#define ISI_V2_EN_OFFSET			0
+#define ISI_V2_EN_SIZE				1
+#define ISI_V2_DIS_OFFSET			1
+#define ISI_V2_DIS_SIZE				1
+#define ISI_V2_SRST_OFFSET			2
+#define ISI_V2_SRST_SIZE			1
+#define ISI_V2_CDC_OFFSET			8
+#define ISI_V2_CDC_SIZE				1
+
+/* Bitfields in SR/IER/IDR/IMR */
+#define ISI_SOF_OFFSET				0
+#define ISI_SOF_SIZE				1
+#define ISI_SOFTRST_OFFSET			2
+#define ISI_SOFTRST_SIZE			1
+#define ISI_CDC_STATUS_OFFSET			3
+#define ISI_CDC_STATUS_SIZE			1
+#define ISI_CRC_ERR_OFFSET			4
+#define ISI_CRC_ERR_SIZE			1
+#define ISI_FO_C_OVF_OFFSET			5
+#define ISI_FO_C_OVF_SIZE			1
+#define ISI_FO_P_OVF_OFFSET			6
+#define ISI_FO_P_OVF_SIZE			1
+#define ISI_FO_P_EMP_OFFSET			7
+#define ISI_FO_P_EMP_SIZE			1
+#define ISI_FO_C_EMP_OFFSET			8
+#define ISI_FO_C_EMP_SIZE			1
+#define ISI_FR_OVR_OFFSET			9
+#define ISI_FR_OVR_SIZE				1
+
+/* Bitfields in SR/IER/IDR/IMR(ISI_V2) */
+#define ISI_V2_ENABLE_OFFSET			0
+#define ISI_V2_ENABLE_SIZE			1
+#define ISI_V2_DIS_DONE_OFFSET			1
+#define ISI_V2_DIS_DONE_SIZE			1
+#define ISI_V2_SRST_OFFSET			2
+#define ISI_V2_SRST_SIZE			1
+#define ISI_V2_CDC_STATUS_OFFSET		8
+#define ISI_V2_CDC_STATUS_SIZE			1
+#define ISI_V2_VSYNC_OFFSET			10
+#define ISI_V2_VSYNC_SIZE			1
+#define ISI_V2_PXFR_DONE_OFFSET			16
+#define ISI_V2_PXFR_DONE_SIZE			1
+#define ISI_V2_CXFR_DONE_OFFSET			17
+#define ISI_V2_CXFR_DONE_SIZE			1
+#define ISI_V2_P_OVR_OFFSET			24
+#define ISI_V2_P_OVR_SIZE			1
+#define ISI_V2_C_OVR_OFFSET			25
+#define ISI_V2_C_OVR_SIZE			1
+#define ISI_V2_CRC_ERR_OFFSET			26
+#define ISI_V2_CRC_ERR_SIZE			1
+#define ISI_V2_FR_OVR_OFFSET			27
+#define ISI_V2_FR_OVR_SIZE			1
+
+/* Bitfields in PSIZE */
+#define ISI_PREV_VSIZE_OFFSET			0
+#define ISI_PREV_VSIZE_SIZE			10
+#define ISI_PREV_HSIZE_OFFSET			16
+#define ISI_PREV_HSIZE_SIZE			10
+
+/* Bitfields in PSIZE(ISI_V2) */
+#define ISI_V2_PREV_VSIZE_OFFSET		0
+#define ISI_V2_PREV_VSIZE_SIZE			10
+#define ISI_V2_PREV_HSIZE_OFFSET		16
+#define ISI_V2_PREV_HSIZE_SIZE			10
+
+/* Bitfields in PCDEF */
+#define ISI_DEC_FACTOR_OFFSET			0
+#define ISI_DEC_FACTOR_SIZE			8
+
+/* Bitfields in PCDEF */
+#define ISI_V2_DEC_FACTOR_OFFSET		0
+#define ISI_V2_DEC_FACTOR_SIZE			8
+
+/* Bitfields in PPFBD */
+#define ISI_PREV_FBD_ADDR_OFFSET		0
+#define ISI_PREV_FBD_ADDR_SIZE			32
+
+/* Bitfields in CDBA */
+#define ISI_CODEC_DMA_ADDR_OFFSET		0
+#define ISI_CODEC_DMA_ADDR_SIZE			32
+
+/* Bitfields in DMA_C_ADDR */
+#define ISI_V2_DMA_ADDR_OFFSET			0
+#define ISI_V2_DMA_ADDR_SIZE			32
+
+/* Bitfields in DMA_C_CTRL & in DMA_P_CTRL */
+#define ISI_V2_DMA_FETCH_OFFSET			0
+#define ISI_V2_DMA_FETCH_SIZE			1
+#define ISI_V2_DMA_WB_OFFSET			1
+#define ISI_V2_DMA_WB_SIZE			1
+#define ISI_V2_DMA_IEN_OFFSET			2
+#define ISI_V2_DMA_IEN_SIZE			1
+#define ISI_V2_DMA_DONE_OFFSET			3
+#define ISI_V2_DMA_DONE_SIZE			1
+
+/* Bitfields in DMA_CHER */
+#define ISI_V2_DMA_P_CH_EN_OFFSET		0
+#define ISI_V2_DMA_P_CH_EN_SIZE			1
+#define ISI_V2_DMA_C_CH_EN_OFFSET		1
+#define ISI_V2_DMA_C_CH_EN_SIZE			1
+
+/* Bitfields in Y2R_SET0 */
+#define ISI_Y2R_SET0_C3_OFFSET			24
+#define ISI_Y2R_SET0_C3_SIZE			8
+
+/* Bitfields in Y2R_SET0(ISI_V2) */
+#define ISI_V2_Y2R_SET0_C3_OFFSET		24
+#define ISI_V2_Y2R_SET0_C3_SIZE			8
+
+/* Bitfields in Y2R_SET1 */
+#define ISI_Y2R_SET1_C4_OFFSET			0
+#define ISI_Y2R_SET1_C4_SIZE			9
+#define ISI_YOFF_OFFSET				12
+#define ISI_YOFF_SIZE				1
+#define ISI_CROFF_OFFSET			13
+#define ISI_CROFF_SIZE				1
+#define ISI_CBOFF_OFFSET			14
+#define ISI_CBOFF_SIZE				1
+
+/* Bitfields in Y2R_SET1(ISI_V2) */
+#define ISI_V2_Y2R_SET1_C4_OFFSET		0
+#define ISI_V2_Y2R_SET1_C4_SIZE			9
+#define ISI_V2_YOFF_OFFSET			12
+#define ISI_V2_YOFF_SIZE			1
+#define ISI_V2_CROFF_OFFSET			13
+#define ISI_V2_CROFF_SIZE			1
+#define ISI_V2_CBOFF_OFFSET			14
+#define ISI_V2_CBOFF_SIZE			1
+
+/* Bitfields in R2Y_SET0 */
+#define ISI_C0_OFFSET				0
+#define ISI_C0_SIZE				8
+#define ISI_C1_OFFSET				8
+#define ISI_C1_SIZE				8
+#define ISI_C2_OFFSET				16
+#define ISI_C2_SIZE				8
+#define ISI_ROFF_OFFSET				24
+#define ISI_ROFF_SIZE				1
+
+/* Bitfields in R2Y_SET0(ISI_V2) */
+#define ISI_V2_C0_OFFSET			0
+#define ISI_V2_C0_SIZE				8
+#define ISI_V2_C1_OFFSET			8
+#define ISI_V2_C1_SIZE				8
+#define ISI_V2_C2_OFFSET			16
+#define ISI_V2_C2_SIZE				8
+#define ISI_V2_ROFF_OFFSET			24
+#define ISI_V2_ROFF_SIZE			1
+
+/* Bitfields in R2Y_SET1 */
+#define ISI_R2Y_SET1_C3_OFFSET			0
+#define ISI_R2Y_SET1_C3_SIZE			8
+#define ISI_R2Y_SET1_C4_OFFSET			8
+#define ISI_R2Y_SET1_C4_SIZE			8
+#define ISI_C5_OFFSET				16
+#define ISI_C5_SIZE				8
+#define ISI_GOFF_OFFSET				24
+#define ISI_GOFF_SIZE				1
+
+/* Bitfields in R2Y_SET1(ISI_V2) */
+#define ISI_V2_R2Y_SET1_C3_OFFSET		0
+#define ISI_V2_R2Y_SET1_C3_SIZE			8
+#define ISI_V2_R2Y_SET1_C4_OFFSET		8
+#define ISI_V2_R2Y_SET1_C4_SIZE			8
+#define ISI_V2_C5_OFFSET			16
+#define ISI_V2_C5_SIZE				8
+#define ISI_V2_GOFF_OFFSET			24
+#define ISI_V2_GOFF_SIZE			1
+
+/* Bitfields in R2Y_SET2 */
+#define ISI_C6_OFFSET				0
+#define ISI_C6_SIZE				8
+#define ISI_C7_OFFSET				8
+#define ISI_C7_SIZE				8
+#define ISI_C8_OFFSET				16
+#define ISI_C8_SIZE				8
+#define ISI_BOFF_OFFSET				24
+#define ISI_BOFF_SIZE				1
+
+/* Bitfields in R2Y_SET2(ISI_V2) */
+#define ISI_V2_C6_OFFSET			0
+#define ISI_V2_C6_SIZE				8
+#define ISI_V2_C7_OFFSET			8
+#define ISI_V2_C7_SIZE				8
+#define ISI_V2_C8_OFFSET			16
+#define ISI_V2_C8_SIZE				8
+#define ISI_V2_BOFF_OFFSET			24
+#define ISI_V2_BOFF_SIZE			1
+
+/* Constants for FRATE */
+#define ISI_FRATE_CAPTURE_ALL			0
+
+/* Constants for FRATE(ISI_V2) */
+#define ISI_V2_FRATE_CAPTURE_ALL		0
+
+/* Constants for YCC_SWAP */
+#define ISI_YCC_SWAP_DEFAULT			0
+#define ISI_YCC_SWAP_MODE_1			1
+#define ISI_YCC_SWAP_MODE_2			2
+#define ISI_YCC_SWAP_MODE_3			3
+
+/* Constants for YCC_SWAP(ISI_V2) */
+#define ISI_V2_YCC_SWAP_DEFAULT			0
+#define ISI_V2_YCC_SWAP_MODE_1			1
+#define ISI_V2_YCC_SWAP_MODE_2			2
+#define ISI_V2_YCC_SWAP_MODE_3			3
+
+/* Constants for RGB_CFG */
+#define ISI_RGB_CFG_DEFAULT			0
+#define ISI_RGB_CFG_MODE_1			1
+#define ISI_RGB_CFG_MODE_2			2
+#define ISI_RGB_CFG_MODE_3			3
+
+/* Constants for RGB_CFG(ISI_V2) */
+#define ISI_V2_RGB_CFG_DEFAULT			0
+#define ISI_V2_RGB_CFG_MODE_1			1
+#define ISI_V2_RGB_CFG_MODE_2			2
+#define ISI_V2_RGB_CFG_MODE_3			3
+
+/* Bit manipulation macros */
+#define ISI_BIT(name)					\
+	(1 << ISI_##name##_OFFSET)
+#define ISI_BF(name, value)				\
+	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
+	 << ISI_##name##_OFFSET)
+#define ISI_BFEXT(name, value)				\
+	(((value) >> ISI_##name##_OFFSET)		\
+	 & ((1 << ISI_##name##_SIZE) - 1))
+#define ISI_BFINS(name, value, old)			\
+	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
+		    << ISI_##name##_OFFSET))\
+	 | ISI_BF(name, value))
+
+/* Register access macros */
+#define isi_readl(port, reg)				\
+	__raw_readl((port)->regs + ISI_##reg)
+#define isi_writel(port, reg, value)			\
+	__raw_writel((value), (port)->regs + ISI_##reg)
+
+#define ATMEL_V4L2_VID_FLAGS (V4L2_CAP_VIDEO_OUTPUT)
+
+struct atmel_isi;
+
+enum atmel_isi_pixfmt {
+	ATMEL_ISI_PIXFMT_GREY,		/* Greyscale */
+	ATMEL_ISI_PIXFMT_CbYCrY,
+	ATMEL_ISI_PIXFMT_CrYCbY,
+	ATMEL_ISI_PIXFMT_YCbYCr,
+	ATMEL_ISI_PIXFMT_YCrYCb,
+	ATMEL_ISI_PIXFMT_RGB24,
+	ATMEL_ISI_PIXFMT_BGR24,
+	ATMEL_ISI_PIXFMT_RGB16,
+	ATMEL_ISI_PIXFMT_BGR16,
+	ATMEL_ISI_PIXFMT_GRB16,		/* G[2:0] R[4:0]/B[4:0] G[5:3] */
+	ATMEL_ISI_PIXFMT_GBR16,		/* G[2:0] B[4:0]/R[4:0] G[5:3] */
+	ATMEL_ISI_PIXFMT_RGB24_REV,
+	ATMEL_ISI_PIXFMT_BGR24_REV,
+	ATMEL_ISI_PIXFMT_RGB16_REV,
+	ATMEL_ISI_PIXFMT_BGR16_REV,
+	ATMEL_ISI_PIXFMT_GRB16_REV,	/* G[2:0] R[4:0]/B[4:0] G[5:3] */
+	ATMEL_ISI_PIXFMT_GBR16_REV,	/* G[2:0] B[4:0]/R[4:0] G[5:3] */
+};
+
+struct atmel_isi_format {
+	struct v4l2_pix_format pix;
+	enum atmel_isi_pixfmt input_format;
+};
+
+struct isi_platform_data {
+	u16 image_hsize;
+	u16 image_vsize;
+	u16 prev_hsize;
+	u16 prev_vsize;
+	u16 cr1_flags;
+#define ISI_HSYNC_ACT_LOW	0x01
+#define ISI_VSYNC_ACT_LOW	0x02
+#define ISI_PXCLK_ACT_FALLING	0x04
+#define ISI_EMB_SYNC		0x08
+#define ISI_CRC_SYNC		0x10
+#define ISI_FULL		0x20
+	u8 gs_mode;
+#define ISI_GS_2PIX_PER_WORD	0x00
+#define ISI_GS_1PIX_PER_WORD	0x01
+	u8 pixfmt;
+	u8 sfd;
+	u8 sld;
+	u8 thmask;
+#define ISI_BURST_4_8_16	0x00
+#define ISI_BURST_8_16		0x01
+#define ISI_BURST_16		0x02
+	u8 frate;
+#define ISI_FRATE_DIV_2		0x01
+#define ISI_FRATE_DIV_3		0x02
+#define ISI_FRATE_DIV_4		0x03
+#define ISI_FRATE_DIV_5		0x04
+#define ISI_FRATE_DIV_6		0x05
+#define ISI_FRATE_DIV_7		0x06
+#define ISI_FRATE_DIV_8		0x07
+	int capture_v4l2_fmt;
+	int streaming_v4l2_fmt;
+	/* i2c needed for subdev struct */
+	struct i2c_board_info board_info;
+};
+
+#endif /* __ASM_AVR32_ISI_H__ */
+
-- 
1.5.6.5

