Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52147 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753418AbdEEPcP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 11:32:15 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v5 2/8] [media] stm32-dcmi: STM32 DCMI camera interface driver
Date: Fri, 5 May 2017 17:31:21 +0200
Message-ID: <1493998287-5828-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
References: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This V4L2 subdev driver enables Digital Camera Memory Interface (DCMI)
of STMicroelectronics STM32 SoC series.

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/Kconfig            |   12 +
 drivers/media/platform/Makefile           |    2 +
 drivers/media/platform/stm32/Makefile     |    1 +
 drivers/media/platform/stm32/stm32-dcmi.c | 1403 +++++++++++++++++++++++++++++
 4 files changed, 1418 insertions(+)
 create mode 100644 drivers/media/platform/stm32/Makefile
 create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ac026ee..de6e18b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -114,6 +114,18 @@ config VIDEO_S3C_CAMIF
 	  To compile this driver as a module, choose M here: the module
 	  will be called s3c-camif.
 
+config VIDEO_STM32_DCMI
+	tristate "Digital Camera Memory Interface (DCMI) support"
+	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on ARCH_STM32 || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This module makes the STM32 Digital Camera Memory Interface (DCMI)
+	  available as a v4l2 device.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called stm32-dcmi.
+
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 63303d6..231f3c2 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -68,6 +68,8 @@ obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
 obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel/
 
+obj-$(CONFIG_VIDEO_STM32_DCMI)		+= stm32/
+
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
 obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
diff --git a/drivers/media/platform/stm32/Makefile b/drivers/media/platform/stm32/Makefile
new file mode 100644
index 0000000..9b606a7
--- /dev/null
+++ b/drivers/media/platform/stm32/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_STM32_DCMI) += stm32-dcmi.o
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
new file mode 100644
index 0000000..348f025
--- /dev/null
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -0,0 +1,1403 @@
+/*
+ * Driver for STM32 Digital Camera Memory Interface
+ *
+ * Copyright (C) STMicroelectronics SA 2017
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * This driver is based on atmel_isi.c
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-image-sizes.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-of.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define DRV_NAME "stm32-dcmi"
+
+/* Registers offset for DCMI */
+#define DCMI_CR		0x00 /* Control Register */
+#define DCMI_SR		0x04 /* Status Register */
+#define DCMI_RIS	0x08 /* Raw Interrupt Status register */
+#define DCMI_IER	0x0C /* Interrupt Enable Register */
+#define DCMI_MIS	0x10 /* Masked Interrupt Status register */
+#define DCMI_ICR	0x14 /* Interrupt Clear Register */
+#define DCMI_ESCR	0x18 /* Embedded Synchronization Code Register */
+#define DCMI_ESUR	0x1C /* Embedded Synchronization Unmask Register */
+#define DCMI_CWSTRT	0x20 /* Crop Window STaRT */
+#define DCMI_CWSIZE	0x24 /* Crop Window SIZE */
+#define DCMI_DR		0x28 /* Data Register */
+#define DCMI_IDR	0x2C /* IDentifier Register */
+
+/* Bits definition for control register (DCMI_CR) */
+#define CR_CAPTURE	BIT(0)
+#define CR_CM		BIT(1)
+#define CR_CROP		BIT(2)
+#define CR_JPEG		BIT(3)
+#define CR_ESS		BIT(4)
+#define CR_PCKPOL	BIT(5)
+#define CR_HSPOL	BIT(6)
+#define CR_VSPOL	BIT(7)
+#define CR_FCRC_0	BIT(8)
+#define CR_FCRC_1	BIT(9)
+#define CR_EDM_0	BIT(10)
+#define CR_EDM_1	BIT(11)
+#define CR_ENABLE	BIT(14)
+
+/* Bits definition for status register (DCMI_SR) */
+#define SR_HSYNC	BIT(0)
+#define SR_VSYNC	BIT(1)
+#define SR_FNE		BIT(2)
+
+/*
+ * Bits definition for interrupt registers
+ * (DCMI_RIS, DCMI_IER, DCMI_MIS, DCMI_ICR)
+ */
+#define IT_FRAME	BIT(0)
+#define IT_OVR		BIT(1)
+#define IT_ERR		BIT(2)
+#define IT_VSYNC	BIT(3)
+#define IT_LINE		BIT(4)
+
+enum state {
+	STOPPED = 0,
+	RUNNING,
+	STOPPING,
+};
+
+#define MIN_WIDTH	16U
+#define MAX_WIDTH	2048U
+#define MIN_HEIGHT	16U
+#define MAX_HEIGHT	2048U
+
+#define TIMEOUT_MS	1000
+
+struct dcmi_graph_entity {
+	struct device_node *node;
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+};
+
+struct dcmi_format {
+	u32	fourcc;
+	u32	mbus_code;
+	u8	bpp;
+};
+
+struct dcmi_buf {
+	struct vb2_v4l2_buffer	vb;
+	bool			prepared;
+	dma_addr_t		paddr;
+	size_t			size;
+	struct list_head	list;
+};
+
+struct stm32_dcmi {
+	/* Protects the access of variables shared within the interrupt */
+	spinlock_t			irqlock;
+	struct device			*dev;
+	void __iomem			*regs;
+	struct resource			*res;
+	struct reset_control		*rstc;
+	int				sequence;
+	struct list_head		buffers;
+	struct dcmi_buf			*active;
+
+	struct v4l2_device		v4l2_dev;
+	struct video_device		*vdev;
+	struct v4l2_async_notifier	notifier;
+	struct dcmi_graph_entity	entity;
+	struct v4l2_format		fmt;
+
+	const struct dcmi_format	**user_formats;
+	unsigned int			num_user_formats;
+	const struct dcmi_format	*current_fmt;
+
+	/* Protect this data structure */
+	struct mutex			lock;
+	struct vb2_queue		queue;
+
+	struct v4l2_of_bus_parallel	bus;
+	struct completion		complete;
+	struct clk			*mclk;
+	enum state			state;
+	struct dma_chan			*dma_chan;
+	dma_cookie_t			dma_cookie;
+	u32				misr;
+	int				errors_count;
+	int				buffers_count;
+};
+
+static inline struct stm32_dcmi *notifier_to_dcmi(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct stm32_dcmi, notifier);
+}
+
+static inline u32 reg_read(void __iomem *base, u32 reg)
+{
+	return readl_relaxed(base + reg);
+}
+
+static inline void reg_write(void __iomem *base, u32 reg, u32 val)
+{
+	writel_relaxed(val, base + reg);
+}
+
+static inline void reg_set(void __iomem *base, u32 reg, u32 mask)
+{
+	reg_write(base, reg, reg_read(base, reg) | mask);
+}
+
+static inline void reg_clear(void __iomem *base, u32 reg, u32 mask)
+{
+	reg_write(base, reg, reg_read(base, reg) & ~mask);
+}
+
+static int dcmi_start_capture(struct stm32_dcmi *dcmi);
+
+static void dcmi_dma_callback(void *param)
+{
+	struct stm32_dcmi *dcmi = (struct stm32_dcmi *)param;
+	struct dma_chan *chan = dcmi->dma_chan;
+	struct dma_tx_state state;
+	enum dma_status status;
+
+	spin_lock(&dcmi->irqlock);
+
+	/* Check DMA status */
+	status = dmaengine_tx_status(chan, dcmi->dma_cookie, &state);
+
+	switch (status) {
+	case DMA_IN_PROGRESS:
+		dev_dbg(dcmi->dev, "%s: Received DMA_IN_PROGRESS\n", __func__);
+		break;
+	case DMA_PAUSED:
+		dev_err(dcmi->dev, "%s: Received DMA_PAUSED\n", __func__);
+		break;
+	case DMA_ERROR:
+		dev_err(dcmi->dev, "%s: Received DMA_ERROR\n", __func__);
+		break;
+	case DMA_COMPLETE:
+		dev_dbg(dcmi->dev, "%s: Received DMA_COMPLETE\n", __func__);
+
+		if (dcmi->active) {
+			struct dcmi_buf *buf = dcmi->active;
+			struct vb2_v4l2_buffer *vbuf = &dcmi->active->vb;
+
+			vbuf->sequence = dcmi->sequence++;
+			vbuf->field = V4L2_FIELD_NONE;
+			vbuf->vb2_buf.timestamp = ktime_get_ns();
+			vb2_set_plane_payload(&vbuf->vb2_buf, 0, buf->size);
+			vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
+			dev_dbg(dcmi->dev, "buffer[%d] done seq=%d\n",
+				vbuf->vb2_buf.index, vbuf->sequence);
+
+			dcmi->buffers_count++;
+			dcmi->active = NULL;
+		}
+
+		/* Restart a new DMA transfer with next buffer */
+		if (dcmi->state == RUNNING) {
+			if (list_empty(&dcmi->buffers)) {
+				dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer",
+					__func__);
+				dcmi->errors_count++;
+				dcmi->active = NULL;
+
+				spin_unlock(&dcmi->irqlock);
+				return;
+			}
+
+			dcmi->active = list_entry(dcmi->buffers.next,
+						  struct dcmi_buf, list);
+
+			list_del_init(&dcmi->active->list);
+
+			if (dcmi_start_capture(dcmi)) {
+				dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete",
+					__func__);
+
+				spin_unlock(&dcmi->irqlock);
+				return;
+			}
+
+			/* Enable capture */
+			reg_set(dcmi->regs, DCMI_CR, CR_CAPTURE);
+		}
+
+		break;
+	default:
+		dev_err(dcmi->dev, "%s: Received unknown status\n", __func__);
+		break;
+	}
+
+	spin_unlock(&dcmi->irqlock);
+}
+
+static int dcmi_start_dma(struct stm32_dcmi *dcmi,
+			  struct dcmi_buf *buf)
+{
+	struct dma_async_tx_descriptor *desc = NULL;
+	struct dma_slave_config config;
+	int ret;
+
+	memset(&config, 0, sizeof(config));
+
+	config.src_addr = (dma_addr_t)dcmi->res->start + DCMI_DR;
+	config.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	config.dst_maxburst = 4;
+
+	/* Configure DMA channel */
+	ret = dmaengine_slave_config(dcmi->dma_chan, &config);
+	if (ret < 0) {
+		dev_err(dcmi->dev, "%s: DMA channel config failed (%d)\n",
+			__func__, ret);
+		return ret;
+	}
+
+	/* Prepare a DMA transaction */
+	desc = dmaengine_prep_slave_single(dcmi->dma_chan, buf->paddr,
+					   buf->size,
+					   DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
+	if (!desc) {
+		dev_err(dcmi->dev, "%s: DMA dmaengine_prep_slave_single failed for buffer size %zu\n",
+			__func__, buf->size);
+		return -EINVAL;
+	}
+
+	/* Set completion callback routine for notification */
+	desc->callback = dcmi_dma_callback;
+	desc->callback_param = dcmi;
+
+	/* Push current DMA transaction in the pending queue */
+	dcmi->dma_cookie = dmaengine_submit(desc);
+
+	dma_async_issue_pending(dcmi->dma_chan);
+
+	return 0;
+}
+
+static int dcmi_start_capture(struct stm32_dcmi *dcmi)
+{
+	int ret;
+	struct dcmi_buf *buf = dcmi->active;
+
+	if (!buf)
+		return -EINVAL;
+
+	ret = dcmi_start_dma(dcmi, buf);
+	if (ret) {
+		dcmi->errors_count++;
+		return ret;
+	}
+
+	/* Enable capture */
+	reg_set(dcmi->regs, DCMI_CR, CR_CAPTURE);
+
+	return 0;
+}
+
+static irqreturn_t dcmi_irq_thread(int irq, void *arg)
+{
+	struct stm32_dcmi *dcmi = arg;
+
+	spin_lock(&dcmi->irqlock);
+
+	/* Stop capture is required */
+	if (dcmi->state == STOPPING) {
+		reg_clear(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
+
+		dcmi->state = STOPPED;
+
+		complete(&dcmi->complete);
+
+		spin_unlock(&dcmi->irqlock);
+		return IRQ_HANDLED;
+	}
+
+	if ((dcmi->misr & IT_OVR) || (dcmi->misr & IT_ERR)) {
+		/*
+		 * An overflow or an error has been detected,
+		 * stop current DMA transfert & restart it
+		 */
+		dev_warn(dcmi->dev, "%s: Overflow or error detected\n",
+			 __func__);
+
+		dcmi->errors_count++;
+		dmaengine_terminate_all(dcmi->dma_chan);
+
+		reg_set(dcmi->regs, DCMI_ICR, IT_FRAME | IT_OVR | IT_ERR);
+
+		dev_dbg(dcmi->dev, "Restarting capture after DCMI error\n");
+
+		if (dcmi_start_capture(dcmi)) {
+			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
+				__func__);
+
+			spin_unlock(&dcmi->irqlock);
+			return IRQ_HANDLED;
+		}
+	}
+
+	spin_unlock(&dcmi->irqlock);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t dcmi_irq_callback(int irq, void *arg)
+{
+	struct stm32_dcmi *dcmi = arg;
+
+	spin_lock(&dcmi->irqlock);
+
+	dcmi->misr = reg_read(dcmi->regs, DCMI_MIS);
+
+	/* Clear interrupt */
+	reg_set(dcmi->regs, DCMI_ICR, IT_FRAME | IT_OVR | IT_ERR);
+
+	spin_unlock(&dcmi->irqlock);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static int dcmi_queue_setup(struct vb2_queue *vq,
+			    unsigned int *nbuffers,
+			    unsigned int *nplanes,
+			    unsigned int sizes[],
+			    struct device *alloc_devs[])
+{
+	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
+	unsigned int size;
+
+	size = dcmi->fmt.fmt.pix.sizeimage;
+
+	/* Make sure the image size is large enough */
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	dcmi->active = NULL;
+
+	dev_dbg(dcmi->dev, "Setup queue, count=%d, size=%d\n",
+		*nbuffers, size);
+
+	return 0;
+}
+
+static int dcmi_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct dcmi_buf *buf = container_of(vbuf, struct dcmi_buf, vb);
+
+	INIT_LIST_HEAD(&buf->list);
+
+	return 0;
+}
+
+static int dcmi_buf_prepare(struct vb2_buffer *vb)
+{
+	struct stm32_dcmi *dcmi =  vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct dcmi_buf *buf = container_of(vbuf, struct dcmi_buf, vb);
+	unsigned long size;
+
+	size = dcmi->fmt.fmt.pix.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(dcmi->dev, "%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+
+	if (!buf->prepared) {
+		/* Get memory addresses */
+		buf->paddr =
+			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
+		buf->size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+		buf->prepared = true;
+
+		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->size);
+
+		dev_dbg(dcmi->dev, "buffer[%d] phy=0x%pad size=%zu\n",
+			vb->index, &buf->paddr, buf->size);
+	}
+
+	return 0;
+}
+
+static void dcmi_buf_queue(struct vb2_buffer *vb)
+{
+	struct stm32_dcmi *dcmi =  vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct dcmi_buf *buf = container_of(vbuf, struct dcmi_buf, vb);
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&dcmi->irqlock, flags);
+
+	if ((dcmi->state == RUNNING) && (!dcmi->active)) {
+		dcmi->active = buf;
+
+		dev_dbg(dcmi->dev, "Starting capture on buffer[%d] queued\n",
+			buf->vb.vb2_buf.index);
+
+		if (dcmi_start_capture(dcmi)) {
+			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
+				__func__);
+
+			spin_unlock_irqrestore(&dcmi->irqlock, flags);
+			return;
+		}
+	} else {
+		/* Enqueue to video buffers list */
+		list_add_tail(&buf->list, &dcmi->buffers);
+	}
+
+	spin_unlock_irqrestore(&dcmi->irqlock, flags);
+}
+
+static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
+	struct dcmi_buf *buf, *node;
+	u32 val;
+	int ret;
+
+	ret = clk_enable(dcmi->mclk);
+	if (ret) {
+		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot enable clock",
+			__func__);
+		goto err_release_buffers;
+	}
+
+	/* Enable stream on the sub device */
+	ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD) {
+		dev_err(dcmi->dev, "%s: Failed to start streaming, subdev streamon error",
+			__func__);
+		goto err_disable_clock;
+	}
+
+	spin_lock_irq(&dcmi->irqlock);
+
+	val = reg_read(dcmi->regs, DCMI_CR);
+
+	val &= ~(CR_PCKPOL | CR_HSPOL | CR_VSPOL |
+		 CR_EDM_0 | CR_EDM_1 | CR_FCRC_0 |
+		 CR_FCRC_1 | CR_JPEG | CR_ESS);
+
+	/* Set bus width */
+	switch (dcmi->bus.bus_width) {
+	case 14:
+		val &= CR_EDM_0 + CR_EDM_1;
+		break;
+	case 12:
+		val &= CR_EDM_1;
+		break;
+	case 10:
+		val &= CR_EDM_0;
+		break;
+	default:
+		/* Set bus width to 8 bits by default */
+		break;
+	}
+
+	/* Set vertical synchronization polarity */
+	if (dcmi->bus.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		val |= CR_VSPOL;
+
+	/* Set horizontal synchronization polarity */
+	if (dcmi->bus.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		val |= CR_HSPOL;
+
+	/* Set pixel clock polarity */
+	if (dcmi->bus.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		val |= CR_PCKPOL;
+
+	reg_write(dcmi->regs, DCMI_CR, val);
+
+	/* Enable dcmi */
+	reg_set(dcmi->regs, DCMI_CR, CR_ENABLE);
+
+	dcmi->state = RUNNING;
+
+	dcmi->sequence = 0;
+	dcmi->errors_count = 0;
+	dcmi->buffers_count = 0;
+	dcmi->active = NULL;
+
+	/*
+	 * Start transfer if at least one buffer has been queued,
+	 * otherwise transfer is deferred at buffer queueing
+	 */
+	if (list_empty(&dcmi->buffers)) {
+		dev_dbg(dcmi->dev, "Start streaming is deferred to next buffer queueing\n");
+		spin_unlock_irq(&dcmi->irqlock);
+		return 0;
+	}
+
+	dcmi->active = list_entry(dcmi->buffers.next, struct dcmi_buf, list);
+	list_del_init(&dcmi->active->list);
+
+	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
+
+	ret = dcmi_start_capture(dcmi);
+	if (ret) {
+		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture",
+			__func__);
+
+		spin_unlock_irq(&dcmi->irqlock);
+		goto err_subdev_streamoff;
+	}
+
+	/* Enable interruptions */
+	reg_set(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
+
+	spin_unlock_irq(&dcmi->irqlock);
+
+	return 0;
+
+err_subdev_streamoff:
+	v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
+
+err_disable_clock:
+	clk_disable(dcmi->mclk);
+
+err_release_buffers:
+	spin_lock_irq(&dcmi->irqlock);
+	/*
+	 * Return all buffers to vb2 in QUEUED state.
+	 * This will give ownership back to userspace
+	 */
+	if (dcmi->active) {
+		buf = dcmi->active;
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+		dcmi->active = NULL;
+	}
+	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
+		list_del_init(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irq(&dcmi->irqlock);
+
+	return ret;
+}
+
+static void dcmi_stop_streaming(struct vb2_queue *vq)
+{
+	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
+	struct dcmi_buf *buf, *node;
+	unsigned long time_ms = msecs_to_jiffies(TIMEOUT_MS);
+	long timeout;
+	int ret;
+
+	/* Disable stream on the sub device */
+	ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
+	if (ret && ret != -ENOIOCTLCMD)
+		dev_err(dcmi->dev, "stream off failed in subdev\n");
+
+	dcmi->state = STOPPING;
+
+	timeout = wait_for_completion_interruptible_timeout(&dcmi->complete,
+							    time_ms);
+
+	spin_lock_irq(&dcmi->irqlock);
+
+	/* Disable interruptions */
+	reg_clear(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
+
+	/* Disable DCMI */
+	reg_clear(dcmi->regs, DCMI_CR, CR_ENABLE);
+
+	if (!timeout) {
+		dev_err(dcmi->dev, "Timeout during stop streaming\n");
+		dcmi->state = STOPPED;
+	}
+
+	/* Return all queued buffers to vb2 in ERROR state */
+	if (dcmi->active) {
+		buf = dcmi->active;
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		dcmi->active = NULL;
+	}
+	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
+		list_del_init(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irq(&dcmi->irqlock);
+
+	/* Stop all pending DMA operations */
+	dmaengine_terminate_all(dcmi->dma_chan);
+
+	clk_disable(dcmi->mclk);
+
+	dev_dbg(dcmi->dev, "Stop streaming, errors=%d buffers=%d\n",
+		dcmi->errors_count, dcmi->buffers_count);
+}
+
+static struct vb2_ops dcmi_video_qops = {
+	.queue_setup		= dcmi_queue_setup,
+	.buf_init		= dcmi_buf_init,
+	.buf_prepare		= dcmi_buf_prepare,
+	.buf_queue		= dcmi_buf_queue,
+	.start_streaming	= dcmi_start_streaming,
+	.stop_streaming		= dcmi_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static int dcmi_g_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *fmt)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+
+	*fmt = dcmi->fmt;
+
+	return 0;
+}
+
+static const struct dcmi_format *find_format_by_fourcc(struct stm32_dcmi *dcmi,
+						       unsigned int fourcc)
+{
+	unsigned int num_formats = dcmi->num_user_formats;
+	const struct dcmi_format *fmt;
+	unsigned int i;
+
+	for (i = 0; i < num_formats; i++) {
+		fmt = dcmi->user_formats[i];
+		if (fmt->fourcc == fourcc)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
+			const struct dcmi_format **current_fmt)
+{
+	const struct dcmi_format *dcmi_fmt;
+	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	int ret;
+
+	dcmi_fmt = find_format_by_fourcc(dcmi, pixfmt->pixelformat);
+	if (!dcmi_fmt) {
+		dcmi_fmt = dcmi->user_formats[dcmi->num_user_formats - 1];
+		pixfmt->pixelformat = dcmi_fmt->fourcc;
+	}
+
+	/* Limit to hardware capabilities */
+	pixfmt->width = clamp(pixfmt->width, MIN_WIDTH, MAX_WIDTH);
+	pixfmt->height = clamp(pixfmt->height, MIN_HEIGHT, MAX_HEIGHT);
+
+	v4l2_fill_mbus_format(&format.format, pixfmt, dcmi_fmt->mbus_code);
+	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, set_fmt,
+			       &pad_cfg, &format);
+	if (ret < 0)
+		return ret;
+
+	v4l2_fill_pix_format(pixfmt, &format.format);
+
+	pixfmt->field = V4L2_FIELD_NONE;
+	pixfmt->bytesperline = pixfmt->width * dcmi_fmt->bpp;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
+
+	if (current_fmt)
+		*current_fmt = dcmi_fmt;
+
+	return 0;
+}
+
+static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
+{
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	const struct dcmi_format *current_fmt;
+	int ret;
+
+	ret = dcmi_try_fmt(dcmi, f, &current_fmt);
+	if (ret)
+		return ret;
+
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
+			      current_fmt->mbus_code);
+	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
+			       set_fmt, NULL, &format);
+	if (ret < 0)
+		return ret;
+
+	dcmi->fmt = *f;
+	dcmi->current_fmt = current_fmt;
+
+	return 0;
+}
+
+static int dcmi_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+
+	if (vb2_is_streaming(&dcmi->queue))
+		return -EBUSY;
+
+	return dcmi_set_fmt(dcmi, f);
+}
+
+static int dcmi_try_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+
+	return dcmi_try_fmt(dcmi, f, NULL);
+}
+
+static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
+				 struct v4l2_fmtdesc *f)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+
+	if (f->index >= dcmi->num_user_formats)
+		return -EINVAL;
+
+	f->pixelformat = dcmi->user_formats[f->index]->fourcc;
+	return 0;
+}
+
+static int dcmi_querycap(struct file *file, void *priv,
+			 struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, "STM32 Camera Memory Interface",
+		sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform:dcmi", sizeof(cap->bus_info));
+	return 0;
+}
+
+static int dcmi_enum_input(struct file *file, void *priv,
+			   struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(i->name, "Camera", sizeof(i->name));
+	return 0;
+}
+
+static int dcmi_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int dcmi_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int dcmi_enum_framesizes(struct file *file, void *fh,
+				struct v4l2_frmsizeenum *fsize)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+	const struct dcmi_format *dcmi_fmt;
+	struct v4l2_subdev_frame_size_enum fse = {
+		.index = fsize->index,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+
+	dcmi_fmt = find_format_by_fourcc(dcmi, fsize->pixel_format);
+	if (!dcmi_fmt)
+		return -EINVAL;
+
+	fse.code = dcmi_fmt->mbus_code;
+
+	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, enum_frame_size,
+			       NULL, &fse);
+	if (ret)
+		return ret;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = fse.max_width;
+	fsize->discrete.height = fse.max_height;
+
+	return 0;
+}
+
+static int dcmi_enum_frameintervals(struct file *file, void *fh,
+				    struct v4l2_frmivalenum *fival)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+	const struct dcmi_format *dcmi_fmt;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = fival->index,
+		.width = fival->width,
+		.height = fival->height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+
+	dcmi_fmt = find_format_by_fourcc(dcmi, fival->pixel_format);
+	if (!dcmi_fmt)
+		return -EINVAL;
+
+	fie.code = dcmi_fmt->mbus_code;
+
+	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
+			       enum_frame_interval, NULL, &fie);
+	if (ret)
+		return ret;
+
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete = fie.interval;
+
+	return 0;
+}
+
+static const struct of_device_id stm32_dcmi_of_match[] = {
+	{ .compatible = "st,stm32-dcmi"},
+	{ /* end node */ },
+};
+MODULE_DEVICE_TABLE(of, stm32_dcmi_of_match);
+
+static int dcmi_open(struct file *file)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+	struct v4l2_subdev *sd = dcmi->entity.subdev;
+	int ret;
+
+	if (mutex_lock_interruptible(&dcmi->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	if (!v4l2_fh_is_singular_file(file))
+		goto fh_rel;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto fh_rel;
+
+	ret = dcmi_set_fmt(dcmi, &dcmi->fmt);
+	if (ret)
+		v4l2_subdev_call(sd, core, s_power, 0);
+fh_rel:
+	if (ret)
+		v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&dcmi->lock);
+	return ret;
+}
+
+static int dcmi_release(struct file *file)
+{
+	struct stm32_dcmi *dcmi = video_drvdata(file);
+	struct v4l2_subdev *sd = dcmi->entity.subdev;
+	bool fh_singular;
+	int ret;
+
+	mutex_lock(&dcmi->lock);
+
+	fh_singular = v4l2_fh_is_singular_file(file);
+
+	ret = _vb2_fop_release(file, NULL);
+
+	if (fh_singular)
+		v4l2_subdev_call(sd, core, s_power, 0);
+
+	mutex_unlock(&dcmi->lock);
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops dcmi_ioctl_ops = {
+	.vidioc_querycap		= dcmi_querycap,
+
+	.vidioc_try_fmt_vid_cap		= dcmi_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= dcmi_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= dcmi_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap	= dcmi_enum_fmt_vid_cap,
+
+	.vidioc_enum_input		= dcmi_enum_input,
+	.vidioc_g_input			= dcmi_g_input,
+	.vidioc_s_input			= dcmi_s_input,
+
+	.vidioc_enum_framesizes		= dcmi_enum_framesizes,
+	.vidioc_enum_frameintervals	= dcmi_enum_frameintervals,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_file_operations dcmi_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= video_ioctl2,
+	.open		= dcmi_open,
+	.release	= dcmi_release,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = vb2_fop_get_unmapped_area,
+#endif
+	.read		= vb2_fop_read,
+};
+
+static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
+{
+	struct v4l2_format f = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.fmt.pix = {
+			.width		= CIF_WIDTH,
+			.height		= CIF_HEIGHT,
+			.field		= V4L2_FIELD_NONE,
+			.pixelformat	= dcmi->user_formats[0]->fourcc,
+		},
+	};
+	int ret;
+
+	ret = dcmi_try_fmt(dcmi, &f, NULL);
+	if (ret)
+		return ret;
+	dcmi->current_fmt = dcmi->user_formats[0];
+	dcmi->fmt = f;
+	return 0;
+}
+
+static const struct dcmi_format dcmi_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_RGB565,
+		.mbus_code = MEDIA_BUS_FMT_RGB565_2X8_LE,
+		.bpp = 2,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.mbus_code = MEDIA_BUS_FMT_YUYV8_2X8,
+		.bpp = 2,
+	}, {
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.mbus_code = MEDIA_BUS_FMT_UYVY8_2X8,
+		.bpp = 2,
+	},
+};
+
+static int dcmi_formats_init(struct stm32_dcmi *dcmi)
+{
+	const struct dcmi_format *dcmi_fmts[ARRAY_SIZE(dcmi_formats)];
+	unsigned int num_fmts = 0, i, j;
+	struct v4l2_subdev *subdev = dcmi->entity.subdev;
+	struct v4l2_subdev_mbus_code_enum mbus_code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
+				 NULL, &mbus_code)) {
+		for (i = 0; i < ARRAY_SIZE(dcmi_formats); i++) {
+			if (dcmi_formats[i].mbus_code != mbus_code.code)
+				continue;
+
+			/* Code supported, have we got this fourcc yet? */
+			for (j = 0; j < num_fmts; j++)
+				if (dcmi_fmts[j]->fourcc ==
+						dcmi_formats[i].fourcc)
+					/* Already available */
+					break;
+			if (j == num_fmts)
+				/* New */
+				dcmi_fmts[num_fmts++] = dcmi_formats + i;
+		}
+		mbus_code.index++;
+	}
+
+	if (!num_fmts)
+		return -ENXIO;
+
+	dcmi->num_user_formats = num_fmts;
+	dcmi->user_formats = devm_kcalloc(dcmi->dev,
+					 num_fmts, sizeof(struct dcmi_format *),
+					 GFP_KERNEL);
+	if (!dcmi->user_formats) {
+		dev_err(dcmi->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	memcpy(dcmi->user_formats, dcmi_fmts,
+	       num_fmts * sizeof(struct dcmi_format *));
+	dcmi->current_fmt = dcmi->user_formats[0];
+
+	return 0;
+}
+
+static int dcmi_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
+	int ret;
+
+	dcmi->vdev->ctrl_handler = dcmi->entity.subdev->ctrl_handler;
+	ret = dcmi_formats_init(dcmi);
+	if (ret) {
+		dev_err(dcmi->dev, "No supported mediabus format found\n");
+		return ret;
+	}
+
+	ret = dcmi_set_default_fmt(dcmi);
+	if (ret) {
+		dev_err(dcmi->dev, "Could not set default format\n");
+		return ret;
+	}
+
+	ret = video_register_device(dcmi->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(dcmi->dev, "Failed to register video device\n");
+		return ret;
+	}
+
+	dev_dbg(dcmi->dev, "Device registered as %s\n",
+		video_device_node_name(dcmi->vdev));
+	return 0;
+}
+
+static void dcmi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *sd,
+				     struct v4l2_async_subdev *asd)
+{
+	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
+
+	dev_dbg(dcmi->dev, "Removing %s\n", video_device_node_name(dcmi->vdev));
+
+	/* Checks internaly if vdev has been init or not */
+	video_unregister_device(dcmi->vdev);
+}
+
+static int dcmi_graph_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
+
+	dev_dbg(dcmi->dev, "Subdev %s bound\n", subdev->name);
+
+	dcmi->entity.subdev = subdev;
+
+	return 0;
+}
+
+static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
+{
+	struct device_node *ep = NULL;
+	struct device_node *remote;
+
+	while (1) {
+		ep = of_graph_get_next_endpoint(node, ep);
+		if (!ep)
+			return -EINVAL;
+
+		remote = of_graph_get_remote_port_parent(ep);
+		if (!remote) {
+			of_node_put(ep);
+			return -EINVAL;
+		}
+
+		/* Remote node to connect */
+		dcmi->entity.node = remote;
+		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
+		dcmi->entity.asd.match.of.node = remote;
+		return 0;
+	}
+}
+
+static int dcmi_graph_init(struct stm32_dcmi *dcmi)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	int ret;
+
+	/* Parse the graph to extract a list of subdevice DT nodes. */
+	ret = dcmi_graph_parse(dcmi, dcmi->dev->of_node);
+	if (ret < 0) {
+		dev_err(dcmi->dev, "Graph parsing failed\n");
+		return ret;
+	}
+
+	/* Register the subdevices notifier. */
+	subdevs = devm_kzalloc(dcmi->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (!subdevs) {
+		of_node_put(dcmi->entity.node);
+		return -ENOMEM;
+	}
+
+	subdevs[0] = &dcmi->entity.asd;
+
+	dcmi->notifier.subdevs = subdevs;
+	dcmi->notifier.num_subdevs = 1;
+	dcmi->notifier.bound = dcmi_graph_notify_bound;
+	dcmi->notifier.unbind = dcmi_graph_notify_unbind;
+	dcmi->notifier.complete = dcmi_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(&dcmi->v4l2_dev, &dcmi->notifier);
+	if (ret < 0) {
+		dev_err(dcmi->dev, "Notifier registration failed\n");
+		of_node_put(dcmi->entity.node);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int dcmi_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match = NULL;
+	struct v4l2_of_endpoint ep;
+	struct stm32_dcmi *dcmi;
+	struct vb2_queue *q;
+	struct dma_chan *chan;
+	struct clk *mclk;
+	int irq;
+	int ret = 0;
+
+	match = of_match_device(of_match_ptr(stm32_dcmi_of_match), &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Could not find a match in devicetree\n");
+		return -ENODEV;
+	}
+
+	dcmi = devm_kzalloc(&pdev->dev, sizeof(struct stm32_dcmi), GFP_KERNEL);
+	if (!dcmi)
+		return -ENOMEM;
+
+	dcmi->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(dcmi->rstc)) {
+		dev_err(&pdev->dev, "Could not get reset control\n");
+		return -ENODEV;
+	}
+
+	/* Get bus characteristics from devicetree */
+	np = of_graph_get_next_endpoint(np, NULL);
+	if (!np) {
+		dev_err(&pdev->dev, "Could not find the endpoint\n");
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	ret = v4l2_of_parse_endpoint(np, &ep);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not parse the endpoint\n");
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	if (ep.bus_type == V4L2_MBUS_CSI2) {
+		dev_err(&pdev->dev, "CSI bus not supported\n");
+		of_node_put(np);
+		return -ENODEV;
+	}
+	dcmi->bus.flags = ep.bus.parallel.flags;
+	dcmi->bus.bus_width = ep.bus.parallel.bus_width;
+	dcmi->bus.data_shift = ep.bus.parallel.data_shift;
+
+	of_node_put(np);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev, "Could not get irq\n");
+		return -ENODEV;
+	}
+
+	dcmi->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!dcmi->res) {
+		dev_err(&pdev->dev, "Could not get resource\n");
+		return -ENODEV;
+	}
+
+	dcmi->regs = devm_ioremap_resource(&pdev->dev, dcmi->res);
+	if (IS_ERR(dcmi->regs)) {
+		dev_err(&pdev->dev, "Could not map registers\n");
+		return PTR_ERR(dcmi->regs);
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, dcmi_irq_callback,
+					dcmi_irq_thread, IRQF_ONESHOT,
+					dev_name(&pdev->dev), dcmi);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
+		return -ENODEV;
+	}
+
+	mclk = devm_clk_get(&pdev->dev, "mclk");
+	if (IS_ERR(mclk)) {
+		dev_err(&pdev->dev, "Unable to get mclk\n");
+		return PTR_ERR(mclk);
+	}
+
+	chan = dma_request_slave_channel(&pdev->dev, "tx");
+	if (!chan) {
+		dev_info(&pdev->dev, "Unable to request DMA channel, defer probing\n");
+		return -EPROBE_DEFER;
+	}
+
+	ret = clk_prepare(mclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to prepare mclk %p\n", mclk);
+		goto err_dma_release;
+	}
+
+	spin_lock_init(&dcmi->irqlock);
+	mutex_init(&dcmi->lock);
+	init_completion(&dcmi->complete);
+	INIT_LIST_HEAD(&dcmi->buffers);
+
+	dcmi->dev = &pdev->dev;
+	dcmi->mclk = mclk;
+	dcmi->state = STOPPED;
+	dcmi->dma_chan = chan;
+
+	q = &dcmi->queue;
+
+	/* Initialize the top-level structure */
+	ret = v4l2_device_register(&pdev->dev, &dcmi->v4l2_dev);
+	if (ret)
+		goto err_clk_unprepare;
+
+	dcmi->vdev = video_device_alloc();
+	if (!dcmi->vdev) {
+		ret = -ENOMEM;
+		goto err_device_unregister;
+	}
+
+	/* Video node */
+	dcmi->vdev->fops = &dcmi_fops;
+	dcmi->vdev->v4l2_dev = &dcmi->v4l2_dev;
+	dcmi->vdev->queue = &dcmi->queue;
+	strlcpy(dcmi->vdev->name, KBUILD_MODNAME, sizeof(dcmi->vdev->name));
+	dcmi->vdev->release = video_device_release;
+	dcmi->vdev->ioctl_ops = &dcmi_ioctl_ops;
+	dcmi->vdev->lock = &dcmi->lock;
+	dcmi->vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+				  V4L2_CAP_READWRITE;
+	video_set_drvdata(dcmi->vdev, dcmi);
+
+	/* Buffer queue */
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
+	q->lock = &dcmi->lock;
+	q->drv_priv = dcmi;
+	q->buf_struct_size = sizeof(struct dcmi_buf);
+	q->ops = &dcmi_video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->dev = &pdev->dev;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize vb2 queue\n");
+		goto err_device_release;
+	}
+
+	ret = dcmi_graph_init(dcmi);
+	if (ret < 0)
+		goto err_device_release;
+
+	/* Reset device */
+	ret = reset_control_assert(dcmi->rstc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to assert the reset line\n");
+		goto err_device_release;
+	}
+
+	usleep_range(3000, 5000);
+
+	ret = reset_control_deassert(dcmi->rstc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to deassert the reset line\n");
+		goto err_device_release;
+	}
+
+	dev_info(&pdev->dev, "Probe done\n");
+
+	platform_set_drvdata(pdev, dcmi);
+	return 0;
+
+err_device_release:
+	video_device_release(dcmi->vdev);
+err_device_unregister:
+	v4l2_device_unregister(&dcmi->v4l2_dev);
+err_clk_unprepare:
+	clk_unprepare(dcmi->mclk);
+err_dma_release:
+	dma_release_channel(dcmi->dma_chan);
+
+	return ret;
+}
+
+static int dcmi_remove(struct platform_device *pdev)
+{
+	struct stm32_dcmi *dcmi = platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&dcmi->notifier);
+	v4l2_device_unregister(&dcmi->v4l2_dev);
+	clk_unprepare(dcmi->mclk);
+	dma_release_channel(dcmi->dma_chan);
+
+	return 0;
+}
+
+static struct platform_driver stm32_dcmi_driver = {
+	.probe		= dcmi_probe,
+	.remove		= dcmi_remove,
+	.driver		= {
+		.name = DRV_NAME,
+		.of_match_table = of_match_ptr(stm32_dcmi_of_match),
+	},
+};
+
+module_platform_driver(stm32_dcmi_driver);
+
+MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
+MODULE_AUTHOR("Hugues Fruchet <hugues.fruchet@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics STM32 Digital Camera Memory Interface driver");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("video");
-- 
1.9.1
