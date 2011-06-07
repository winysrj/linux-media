Return-path: <mchehab@pedra>
Received: from newsmtp5.atmel.com ([204.2.163.5]:59064 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1FGHFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 03:05:44 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Tue, 7 Jun 2011 15:04:59 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801E23ABF@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1106031503110.5065@axis700.grange>
References: <1307097008-30022-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1106031503110.5065@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <mchehab@redhat.com>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	"Haring, Lars" <Lars.Haring@atmel.com>, <ryan@bluewatersys.com>,
	<arnd@arndb.de>, <plagnioj@jcrosoft.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Guennadi

On Friday, June 03, 2011, Guennadi Liakhovetski wrote 

> On Fri, 3 Jun 2011, Josh Wu wrote:

>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
>> - Using soc-camera framework with videobuf2 dma-contig allocator
>> - Supporting video streaming of YUV packed format
>> - Tested on AT91SAM9M10G45-EK with OV2640
>> 
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> base on branch staging/for_v3.0
>> Modified in V3:
>> refined the interrupt handling code.
>> added a list to manage the allocated descriptors.
>> removed redundant code in isi_camera_set_bus_param().
>> return error when platform data is not provided.
>> 
>>  drivers/media/video/Kconfig     |    8 +
>>  drivers/media/video/Makefile    |    1 +
>>  drivers/media/video/atmel-isi.c | 1074 +++++++++++++++++++++++++++++++++++++++
>>  include/media/atmel-isi.h       |  119 +++++
>>  4 files changed, 1202 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/atmel-isi.c
>>  create mode 100644 include/media/atmel-isi.h
>> 
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index bb53de7..93d1098 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -952,6 +952,14 @@ config  VIDEO_SAMSUNG_S5P_FIMC
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called s5p-fimc.
>>  
>> +config VIDEO_ATMEL_ISI
>> +	tristate "ATMEL Image Sensor Interface (ISI) support"
>> +	depends on VIDEO_DEV && SOC_CAMERA && ARCH_AT91
>> +	select VIDEOBUF2_DMA_CONTIG
>> +	---help---
>> +	  This module makes the ATMEL Image Sensor Interface available
>> +	  as a v4l2 device.
>> +
>>  config VIDEO_S5P_MIPI_CSIS
>>  	tristate "Samsung S5P and EXYNOS4 MIPI CSI receiver driver"
>>  	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P && VIDEO_V4L2_SUBDEV_API
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index f0fecd6..d9833f4 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -166,6 +166,7 @@ obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
>>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>> +obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>>  
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>>  
>> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
>> new file mode 100644
>> index 0000000..a020bd3
>> --- /dev/null
>> +++ b/drivers/media/video/atmel-isi.c
>> @@ -0,0 +1,1074 @@
>> +/*
>> + * Copyright (c) 2011 Atmel Corporation
>> + * Josh Wu, <josh.wu@atmel.com>
>> + *
>> + * Based on previous work by Lars Haring, <lars.haring@atmel.com>
>> + * and Sedji Gaouaou
>> + * Based on the bttv driver for Bt848 with respective copyright holders
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/completion.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/atmel-isi.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#define MAX_BUFFER_NUM			32
>> +#define MAX_SUPPORT_WIDTH		2048
>> +#define MAX_SUPPORT_HEIGHT		2048
>> +#define VID_LIMIT_BYTES			(16 * 1024 * 1024)
>> +#define MIN_FRAME_RATE			15
>> +#define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
>> +
>> +/* ISI states */
>> +enum {
>> +	ISI_STATE_IDLE = 0,
>> +	ISI_STATE_READY,
>> +	ISI_STATE_WAIT_SOF,
>> +};
>> +
>> +/* Frame buffer descriptor */
>> +struct fbd {
>> +	/* Physical address of the frame buffer */
>> +	u32 fb_address;
>> +	/* DMA Control Register(only in HISI2) */
>> +	u32 dma_ctrl;
>> +	/* Physical address of the next fbd */
>> +	u32 next_fbd_address;
>> +};
>> +
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
>> +{
>> +	fb_desc->dma_ctrl = ctrl;
>> +}
>> +
>> +struct isi_dma_desc {
>> +	struct list_head list;
>> +	struct fbd *p_fbd;
>> +	u32 fbd_phys;
>> +};
>> +
>> +/* Frame buffer data */
>> +struct frame_buffer {
>> +	struct vb2_buffer vb;
>> +	struct fbd *p_fb_desc;
>> +	u32 fb_desc_phys;

> Why don't you replace the above two members with "struct isi_dma_desc *"? 
> Then you also don't need to scan the DMA descriptor array in 
> .buf_cleanup().

Will fix in v4. This change makes code simpler.

>> +	struct list_head list;
>> +};
>> +
>> +struct atmel_isi {
>> +	/* Protects the access of variables shared with the ISR */
>> +	spinlock_t			lock;
>> +	void __iomem			*regs;
>> +
>> +	int				sequence;
>> +	/* State of the ISI module in capturing mode */
>> +	int				state;
>> +
>> +	/* Wait queue for waiting for SOF */
>> +	wait_queue_head_t		vsync_wq;
>> +
>> +	struct vb2_alloc_ctx		*alloc_ctx;
>> +
>> +	/* Allocate descriptors for dma buffer use */
>> +	struct fbd			*p_fb_descriptors;
>> +	u32				fb_descriptors_phys;
>> +	struct				list_head dma_desc_head;
>> +	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
>> +
>> +	struct completion		complete;
>> +	struct clk			*pclk;
>> +	unsigned int			irq;
>> +
>> +	struct isi_platform_data	*pdata;
>> +
>> +	struct list_head		video_buffer_list;
>> +	struct frame_buffer		*active;
>> +
>> +	struct soc_camera_device	*icd;
>> +	struct soc_camera_host		soc_host;
>> +};
>> +
>> +static void isi_writel(struct atmel_isi *isi, u32 reg, u32 val)
>> +{
>> +	writel(val, isi->regs + reg);
>> +}
>> +static u32 isi_readl(struct atmel_isi *isi, u32 reg)
>> +{
>> +	return readl(isi->regs + reg);
>> +}
>> +
>> +static int configure_geometry(struct atmel_isi *isi, u32 width,
>> +			u32 height, enum v4l2_mbus_pixelcode code)
>> +{
>> +	u32 cfg2, cr;
>> +
>> +	switch (code) {
>> +	/* YUV, including grey */
>> +	case V4L2_MBUS_FMT_Y8_1X8:
>> +		cr = ISI_CFG2_GRAYSCALE;
>> +		break;
>> +	case V4L2_MBUS_FMT_UYVY8_2X8:
>> +		cr = ISI_CFG2_YCC_SWAP_MODE_3;
>> +		break;
>> +	case V4L2_MBUS_FMT_VYUY8_2X8:
>> +		cr = ISI_CFG2_YCC_SWAP_MODE_2;
>> +		break;
>> +	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +		cr = ISI_CFG2_YCC_SWAP_MODE_1;
>> +		break;
>> +	case V4L2_MBUS_FMT_YVYU8_2X8:
>> +		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
>> +		break;
>> +	/* RGB, TODO */
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> +
>> +	cfg2 = isi_readl(isi, ISI_CFG2);
>> +	cfg2 |= cr;
>> +	/* Set width */
>> +	cfg2 &= ~(ISI_CFG2_IM_HSIZE_MASK);
>> +	cfg2 |= ((width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
>> +			ISI_CFG2_IM_HSIZE_MASK;
>> +	/* Set height */
>> +	cfg2 &= ~(ISI_CFG2_IM_VSIZE_MASK);
>> +	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
>> +			& ISI_CFG2_IM_VSIZE_MASK;
>> +	isi_writel(isi, ISI_CFG2, cfg2);
>> +
>> +	return 0;
>> +}
>> +
>> +static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
>> +{
>> +	if (isi->active) {
>> +		struct vb2_buffer *vb = &isi->active->vb;
>> +		struct frame_buffer *buf = isi->active;
>> +
>> +		list_del_init(&buf->list);
>> +		do_gettimeofday(&vb->v4l2_buf.timestamp);
>> +		vb->v4l2_buf.sequence = isi->sequence++;
>> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +	}
>> +
>> +	if (list_empty(&isi->video_buffer_list)) {
>> +		isi->active = NULL;
>> +	} else {
>> +		/* start next dma frame. */
>> +		isi->active = list_entry(isi->video_buffer_list.next,
>> +					struct frame_buffer, list);
>> +		isi_writel(isi, ISI_DMA_C_DSCR, isi->active->fb_desc_phys);
>> +		isi_writel(isi, ISI_DMA_C_CTRL,
>> +			ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
>> +		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
>> +	}
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +/* ISI interrupt service routine */
>> +static irqreturn_t isi_interrupt(int irq, void *dev_id)
>> +{
>> +	struct atmel_isi *isi = dev_id;
>> +	u32 status, mask, pending;
>> +	irqreturn_t ret = IRQ_NONE;
>> +
>> +	spin_lock(&isi->lock);
>> +
>> +	status = isi_readl(isi, ISI_STATUS);
>> +	mask = isi_readl(isi, ISI_INTMASK);
>> +	pending = status & mask;
>> +
>> +	if (pending & ISI_CTRL_SRST) {
>> +		complete(&isi->complete);
>> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
>> +		ret = IRQ_HANDLED;
>> +	} else if (pending & ISI_CTRL_DIS) {
>> +		complete(&isi->complete);
>> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
>> +		ret = IRQ_HANDLED;
>> +	} else {
>> +		if ((pending & ISI_SR_VSYNC) &&
>> +				(isi->state == ISI_STATE_IDLE)) {

> Superfluous second pair of parenthesis

I think using both pair of parenthesis will make code clearer. Can you accept this?

>> +			isi->state = ISI_STATE_READY;
>> +			wake_up_interruptible(&isi->vsync_wq);
>> +			ret = IRQ_HANDLED;
>> +		}
>> +		if (likely(pending & ISI_SR_CXFR_DONE))
>> +			ret = atmel_isi_handle_streaming(isi);
>> +	}
>> +
>> +	spin_unlock(&isi->lock);
>> +	return ret;
>> +}
>> +
>> +#define	WAIT_ISI_RESET		1
>> +#define	WAIT_ISI_DISABLE	0
>> +static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
>> +{
>> +	unsigned long timeout;
>> +	/*
>> +	 * The reset or disable will only succeed if we have a
>> +	 * pixel clock from the camera.
>> +	 */
>> +	init_completion(&isi->complete);
>> +
>> +	if (wait_reset) {
>> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
>> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
>> +	} else {
>> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
>> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> +	}
>> +
>> +	timeout = wait_for_completion_timeout(&isi->complete,
>> +			msecs_to_jiffies(100));
>> +	if (timeout == 0)
>> +		return -ETIMEDOUT;
>> +
>> +	return 0;
>> +}
>> +
>> +/* ------------------------------------------------------------------
>> +	Videobuf operations
>> +   ------------------------------------------------------------------*/
>> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
>> +				unsigned int *nplanes, unsigned long sizes[],
>> +				void *alloc_ctxs[])
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	unsigned long size;
>> +	int ret, bytes_per_line;
>> +
>> +	/* Reset ISI */
>> +	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
>> +	if (ret < 0) {
>> +		dev_err(icd->dev.parent, "Reset ISI timed out\n");
>> +		return ret;
>> +	}
>> +	/* Disable all interrupts */
>> +	isi_writel(isi, ISI_INTDIS, ~0UL);
>> +
>> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						icd->current_fmt->host_fmt);
>> +
>> +	if (bytes_per_line < 0)
>> +		return bytes_per_line;
>> +
>> +	size = bytes_per_line * icd->user_height;
>> +
>> +	if (*nbuffers == 0)
>> +		*nbuffers = MAX_BUFFER_NUM;
>> +	else if (*nbuffers > MAX_BUFFER_NUM)
>> +		*nbuffers = MAX_BUFFER_NUM;

> /me wondering, why not just
>
>	if (!*nbuffers || *nbuffers > MAX_BUFFER_NUM)
>		*nbuffers = MAX_BUFFER_NUM;

Will fixed in v4.

>> +
>> +	if (size * *nbuffers > VID_LIMIT_BYTES)
>> +		*nbuffers = VID_LIMIT_BYTES / size;
>> +
>> +	*nplanes = 1;
>> +	sizes[0] = size;
>> +	alloc_ctxs[0] = isi->alloc_ctx;
>> +
>> +	isi->sequence = 0;
>> +	isi->active = NULL;
>> +
>> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
>> +		*nbuffers, size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_init(struct vb2_buffer *vb)
>> +{
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
>> +
>> +	buf->p_fb_desc = NULL;
>> +	memset(&buf->fb_desc_phys, 0, sizeof(buf->fb_desc_phys));

> I don't think this is what the reviewer meant - here you're using memset 
> to nullify a u32 field. He probably was asking you to clean the whole 
> struct frame_buffer, which I actually don't necessarily agree with. So, 
> unless there's an evidence, why that memest is needed, I'd just keep your 
> original "->fb_desc_phys = 0". Notice, none of the soc-camera drivers 
> nullifies anything in .buf_init(), it cannot also be mandatory, because 
> the actual method is optional.

Well, in the v4 version, only following code are needed in this function.
	buf->p_dma_desc = NULL;
	INIT_LIST_HEAD(&buf->list);

>> +	INIT_LIST_HEAD(&buf->list);
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	unsigned long size;
>> +	struct isi_dma_desc *desc;
>> +	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						icd->current_fmt->host_fmt);
>> +
>> +	if (bytes_per_line < 0)
>> +		return bytes_per_line;
>> +
>> +	size = bytes_per_line * icd->user_height;
>> +
>> +	if (vb2_plane_size(vb, 0) < size) {
>> +		dev_err(icd->dev.parent, "%s data will not fit into plane (%lu < %lu)\n",
>> +				__func__, vb2_plane_size(vb, 0), size);
>> +		return -EINVAL;
>> +	}
>> +
>> +	vb2_set_plane_payload(&buf->vb, 0, size);
>> +
>> +	if (!buf->p_fb_desc) {
>> +		if (list_empty(&isi->dma_desc_head)) {
>> +			dev_err(icd->dev.parent, "Not enough dma descriptors.\n");
>> +			return -EINVAL;
>> +		} else {
>> +			/* Get an available descriptor */
>> +			desc = list_entry(isi->dma_desc_head.next,
>> +						struct isi_dma_desc, list);
>> +			buf->p_fb_desc = desc->p_fbd;
>> +			buf->fb_desc_phys = desc->fbd_phys;
>> +
>> +			/* Initialize the dma descriptor */
>> +			buf->p_fb_desc->fb_address =
>> +					vb2_dma_contig_plane_paddr(vb, 0);
>> +			buf->p_fb_desc->next_fbd_address = 0;
>> +			set_dma_ctrl(buf->p_fb_desc, ISI_DMA_CTRL_WB);
>> +
>> +			/* Delete the descriptor since now it is used */
>> +			list_del_init(&desc->list);

> It probably doesn't matter here, if there were a race, you'd need to 
> protect anyway, but stylistically you usually first grab ownership of an 
> object, and only then you modify it, so, it would be more logical to first 
> list_del(init) the buffer. As for locking as such - we just rely on v4l2 
> file-operation mutex locking for now.

I will fix it in v4.

>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void buffer_cleanup(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
>> +	unsigned long flags;
>> +	int i;
>> +
>> +	spin_lock_irqsave(&isi->lock, flags);

> You say, this lock protects data, shared with the ISR, these are the 
> buffer list and the ->state, none of them is accessed below.

I think I can remove the spin_lock here.

>> +	if (buf->p_fb_desc) {
>> +		/* This descriptor is available now and we add to head list */
>> +		for (i = 0; i < MAX_BUFFER_NUM; i++)
>> +			if (isi->dma_desc[i].p_fbd == buf->p_fb_desc) {
>> +				list_add(&isi->dma_desc[i].list,
>> +							&isi->dma_desc_head);
>> +				break;
>> +			}

> With modified struct frame_buffer the above loop will go.

sure.

>> +
>> +		buf->p_fb_desc = NULL;
>> +		memset(&buf->fb_desc_phys, 0, sizeof(buf->fb_desc_phys));

> You really need to do clean up in .buf_cleanup() and in .buf_init()? I 
> think, one of them should be enough. And memset is bogus here too.

This initialization code is only needed in buffer_init(). I will remove such code in buffer_cleanup().

>> +	}
>> +	spin_unlock_irqrestore(&isi->lock, flags);
>> +}
>> +
>> +static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
>> +{
>> +	u32 ctrl, cfg1;
>> +
>> +	cfg1 = isi_readl(isi, ISI_CFG1);
>> +	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
>> +	isi_writel(isi, ISI_INTEN,
>> +			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
>> +
>> +	/* Check if already in a frame */
>> +	if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
>> +		dev_err(isi->icd->dev.parent, "Already in frame handling.\n");
>> +		return;
>> +	}
>> +
>> +	isi_writel(isi, ISI_DMA_C_DSCR, buffer->fb_desc_phys);
>> +	isi_writel(isi, ISI_DMA_C_CTRL, ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
>> +	isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
>> +
>> +	/* Enable linked list */
>> +	cfg1 |= isi->pdata->frate | ISI_CFG1_DISCR;
>> +
>> +	/* Enable codec path and ISI */
>> +	ctrl = ISI_CTRL_CDC | ISI_CTRL_EN;
>> +	isi_writel(isi, ISI_CTRL, ctrl);
>> +	isi_writel(isi, ISI_CFG1, cfg1);
>> +}
>> +
>> +static void buffer_queue(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
>> +	unsigned long flags = 0;
>> +
>> +	spin_lock_irqsave(&isi->lock, flags);
>> +	list_add_tail(&buf->list, &isi->video_buffer_list);
>> +
>> +	if (isi->active == NULL) {
>> +		isi->active = buf;
>> +		start_dma(isi, buf);
>> +	}
>> +	spin_unlock_irqrestore(&isi->lock, flags);
>> +}
>> +
>> +static int start_streaming(struct vb2_queue *vq)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +
>> +	u32 sr = 0;
>> +	int ret;
>> +
>> +	spin_lock_irq(&isi->lock);
>> +	isi->state = ISI_STATE_IDLE;
>> +
>> +	/* Clear any pending SOF interrupt */
>> +	sr = isi_readl(isi, ISI_STATUS);
>> +	/* Enable VSYNC interrupt for SOF */
>> +	isi_writel(isi, ISI_INTEN, ISI_SR_VSYNC);
>> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_EN);
>> +
>> +	spin_unlock_irq(&isi->lock);
>> +	dev_dbg(icd->dev.parent, "Waiting for SOF\n");
>> +	ret = wait_event_interruptible(isi->vsync_wq,
>> +				       isi->state != ISI_STATE_IDLE);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (isi->state != ISI_STATE_READY)
>> +		return -EIO;
>> +
>> +	spin_lock_irq(&isi->lock);
>> +	isi->state = ISI_STATE_WAIT_SOF;
>> +	isi_writel(isi, ISI_INTDIS, ISI_SR_VSYNC);
>> +	spin_unlock_irq(&isi->lock);
>> +
>> +	return 0;
>> +}
>> +
>> +/* abort streaming and wait for last buffer */
>> +static int stop_streaming(struct vb2_queue *vq)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	struct frame_buffer *buf, *node;
>> +	int ret = 0;
>> +	unsigned long timeout;
>> +
>> +	spin_lock_irq(&isi->lock);
>> +	isi->active = NULL;
>> +	/* Release all active buffers */
>> +	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
>> +		list_del_init(&buf->list);
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +	}
>> +	spin_unlock_irq(&isi->lock);
>> +
>> +	timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
>> +	/* Wait until the end of the current frame. */
>> +	while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
>> +			time_before(jiffies, timeout))
>> +		msleep(1);
>> +
>> +	if (time_after(jiffies, timeout)) {
>> +		dev_err(icd->dev.parent,
>> +			"Timeout waiting for finishing codec request\n");
>> +		return -ETIMEDOUT;
>> +	}
>> +
>> +	/* Disable interrupts */
>> +	isi_writel(isi, ISI_INTDIS,
>> +			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
>> +
>> +	/* Disable ISI and wait for it is done */
>> +	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
>> +	if (ret < 0)
>> +		dev_err(icd->dev.parent, "Disable ISI timed out\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static struct vb2_ops isi_video_qops = {
>> +	.queue_setup		= queue_setup,
>> +	.buf_init		= buffer_init,
>> +	.buf_prepare		= buffer_prepare,
>> +	.buf_cleanup		= buffer_cleanup,
>> +	.buf_queue		= buffer_queue,
>> +	.start_streaming	= start_streaming,
>> +	.stop_streaming		= stop_streaming,
>> +	.wait_prepare		= soc_camera_unlock,
>> +	.wait_finish		= soc_camera_lock,
>> +};
>> +
>> +/* ------------------------------------------------------------------
>> +	SOC camera operations for the device
>> +   ------------------------------------------------------------------*/
>> +static int isi_camera_init_videobuf(struct vb2_queue *q,
>> +				     struct soc_camera_device *icd)
>> +{
>> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes = VB2_MMAP;
>> +	q->drv_priv = icd;
>> +	q->buf_struct_size = sizeof(struct frame_buffer);
>> +	q->ops = &isi_video_qops;
>> +	q->mem_ops = &vb2_dma_contig_memops;
>> +
>> +	return vb2_queue_init(q);
>> +}
>> +
>> +static int isi_camera_set_fmt(struct soc_camera_device *icd,
>> +			      struct v4l2_format *f)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	const struct soc_camera_format_xlate *xlate;
>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>> +	struct v4l2_mbus_framefmt mf;
>> +	int ret;
>> +
>> +	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>> +	if (!xlate) {
>> +		dev_warn(icd->dev.parent, "Format %x not found\n",
>> +			 pix->pixelformat);
>> +		return -EINVAL;
>> +	}
>> +
>> +	dev_dbg(icd->dev.parent, "Plan to set format %dx%d\n",
>> +			pix->width, pix->height);
>> +
>> +	mf.width	= pix->width;
>> +	mf.height	= pix->height;
>> +	mf.field	= pix->field;
>> +	mf.colorspace	= pix->colorspace;
>> +	mf.code		= xlate->code;
>> +
>> +	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (mf.code != xlate->code)
>> +		return -EINVAL;
>> +
>> +	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	pix->width		= mf.width;
>> +	pix->height		= mf.height;
>> +	pix->field		= mf.field;
>> +	pix->colorspace		= mf.colorspace;
>> +	icd->current_fmt	= xlate;
>> +
>> +	dev_dbg(icd->dev.parent, "Finally set format %dx%d\n",
>> +		pix->width, pix->height);
>> +
>> +	return ret;
>> +}
>> +
>> +static int isi_camera_try_fmt(struct soc_camera_device *icd,
>> +			      struct v4l2_format *f)
>> +{
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	const struct soc_camera_format_xlate *xlate;
>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>> +	struct v4l2_mbus_framefmt mf;
>> +	u32 pixfmt = pix->pixelformat;
>> +	int ret;
>> +
>> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> +	if (pixfmt && !xlate) {
>> +		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* limit to Atmel ISI hardware capabilities */
>> +	if (pix->height > MAX_SUPPORT_HEIGHT)
>> +		pix->height = MAX_SUPPORT_HEIGHT;
>> +	if (pix->width > MAX_SUPPORT_WIDTH)
>> +		pix->width = MAX_SUPPORT_WIDTH;
>> +
>> +	/* limit to sensor capabilities */
>> +	mf.width	= pix->width;
>> +	mf.height	= pix->height;
>> +	mf.field	= pix->field;
>> +	mf.colorspace	= pix->colorspace;
>> +	mf.code		= xlate->code;
>> +
>> +	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	pix->width	= mf.width;
>> +	pix->height	= mf.height;
>> +	pix->colorspace	= mf.colorspace;
>> +
>> +	switch (mf.field) {
>> +	case V4L2_FIELD_ANY:
>> +		pix->field = V4L2_FIELD_NONE;
>> +		break;
>> +	case V4L2_FIELD_NONE:
>> +		break;
>> +	default:
>> +		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
>> +			mf.field);
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
>> +	{
>> +		.fourcc			= V4L2_PIX_FMT_YUYV,
>> +		.name			= "Packed YUV422 16 bit",
>> +		.bits_per_sample	= 8,
>> +		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>> +		.order			= SOC_MBUS_ORDER_LE,
>> +	},
>> +};
>> +
>> +/* This will be corrected as we get more formats */
>> +static bool isi_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
>> +{
>> +	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
>> +		(fmt->bits_per_sample == 8 &&
>> +		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
>> +		(fmt->bits_per_sample > 8 &&
>> +		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
>> +}
>> +
>> +static unsigned long make_bus_param(struct atmel_isi *isi)
>> +{
>> +	unsigned long flags;
>> +	/*
>> +	 * Platform specified synchronization and pixel clock polarities are
>> +	 * only a recommendation and are only used during probing. Atmel ISI
>> +	 * camera interface only works in master mode, i.e., uses HSYNC and
>> +	 * VSYNC signals from the sensor
>> +	 */
>> +	flags = SOCAM_MASTER |
>> +		SOCAM_HSYNC_ACTIVE_HIGH |
>> +		SOCAM_HSYNC_ACTIVE_LOW |
>> +		SOCAM_VSYNC_ACTIVE_HIGH |
>> +		SOCAM_VSYNC_ACTIVE_LOW |
>> +		SOCAM_PCLK_SAMPLE_RISING |
>> +		SOCAM_PCLK_SAMPLE_FALLING |
>> +		SOCAM_DATA_ACTIVE_HIGH;
>> +
>> +	if (isi->pdata->data_width_flags & ISI_DATAWIDTH_10)
>> +		flags |= SOCAM_DATAWIDTH_10;
>> +
>> +	if (isi->pdata->data_width_flags & ISI_DATAWIDTH_8)
>> +		flags |= SOCAM_DATAWIDTH_8;
>> +
>> +	if (flags & SOCAM_DATAWIDTH_MASK)
>> +		return flags;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isi_camera_try_bus_param(struct soc_camera_device *icd,
>> +				    unsigned char buswidth)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	unsigned long camera_flags;
>> +	int ret;
>> +
>> +	camera_flags = icd->ops->query_bus_param(icd);
>> +	ret = soc_camera_bus_param_compatible(camera_flags,
>> +					make_bus_param(isi));
>> +	if (!ret)
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +
>> +static int isi_camera_get_formats(struct soc_camera_device *icd,
>> +				  unsigned int idx,
>> +				  struct soc_camera_format_xlate *xlate)
>> +{
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	int formats = 0, ret;
>> +	/* sensor format */
>> +	enum v4l2_mbus_pixelcode code;
>> +	/* soc camera host format */
>> +	const struct soc_mbus_pixelfmt *fmt;
>> +
>> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
>> +	if (ret < 0)
>> +		/* No more formats */
>> +		return 0;
>> +
>> +	fmt = soc_mbus_get_fmtdesc(code);
>> +	if (!fmt) {
>> +		dev_err(icd->dev.parent,
>> +			"Invalid format code #%u: %d\n", idx, code);
>> +		return 0;
>> +	}
>> +
>> +	/* This also checks support for the requested bits-per-sample */
>> +	ret = isi_camera_try_bus_param(icd, fmt->bits_per_sample);
>> +	if (ret < 0) {
>> +		dev_err(icd->dev.parent,
>> +			"Fail to try the bus parameters.\n");
>> +		return 0;
>> +	}
>> +
>> +	switch (code) {
>> +	case V4L2_MBUS_FMT_UYVY8_2X8:
>> +	case V4L2_MBUS_FMT_VYUY8_2X8:
>> +	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +	case V4L2_MBUS_FMT_YVYU8_2X8:
>> +		formats++;
>> +		if (xlate) {
>> +			xlate->host_fmt	= &isi_camera_formats[0];
>> +			xlate->code	= code;
>> +			xlate++;
>> +			dev_dbg(icd->dev.parent, "Providing format %s using code %d\n",
>> +				isi_camera_formats[0].name, code);
>> +		}
>> +		break;
>> +	default:
>> +		if (!isi_camera_packing_supported(fmt))
>> +			return 0;
>> +		if (xlate)
>> +			dev_dbg(icd->dev.parent,
>> +				"Providing format %s in pass-through mode\n",
>> +				fmt->name);
>> +	}
>> +
>> +	/* Generic pass-through */
>> +	formats++;
>> +	if (xlate) {
>> +		xlate->host_fmt	= fmt;
>> +		xlate->code	= code;
>> +		xlate++;
>> +	}
>> +
>> +	return formats;
>> +}
>> +
>> +/* Called with .video_lock held */
>> +static int isi_camera_add_device(struct soc_camera_device *icd)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	int ret;
>> +
>> +	if (isi->icd)
>> +		return -EBUSY;
>> +
>> +	ret = clk_enable(isi->pclk);
>> +	if (ret)
>> +		return ret;
>> +
>> +	isi->icd = icd;
>> +	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver attached to camera %d\n",
>> +		 icd->devnum);
>> +	return 0;
>> +}
>> +/* Called with .video_lock held */
>> +static void isi_camera_remove_device(struct soc_camera_device *icd)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +
>> +	BUG_ON(icd != isi->icd);
>> +
>> +	clk_disable(isi->pclk);
>> +	isi->icd = NULL;
>> +
>> +	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver detached from camera %d\n",
>> +		 icd->devnum);
>> +}
>> +
>> +static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
>> +{
>> +	struct soc_camera_device *icd = file->private_data;
>> +
>> +	return vb2_poll(&icd->vb2_vidq, file, pt);
>> +}
>> +
>> +static int isi_camera_querycap(struct soc_camera_host *ici,
>> +			       struct v4l2_capability *cap)
>> +{
>> +	strcpy(cap->driver, "atmel-isi");
>> +	strcpy(cap->card, "Atmel Image Sensor Interface");
>> +	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE |
>> +				V4L2_CAP_STREAMING);
>> +	return 0;
>> +}
>> +
>> +static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	unsigned long bus_flags, camera_flags, common_flags;
>> +	int ret;
>> +	u32 cfg1 = 0;
>> +
>> +	camera_flags = icd->ops->query_bus_param(icd);
>> +
>> +	bus_flags = make_bus_param(isi);
>> +	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
>> +	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
>> +		camera_flags, bus_flags, common_flags);
>> +	if (!common_flags)
>> +		return -EINVAL;
>> +
>> +	/* Make choises, based on platform preferences */
>> +	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
>> +	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
>> +		if (isi->pdata->hsync_act_low)
>> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
>> +		else
>> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
>> +	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
>> +		if (isi->pdata->vsync_act_low)
>> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
>> +		else
>> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
>> +	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
>> +		if (isi->pdata->pclk_act_falling)
>> +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
>> +		else
>> +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
>> +	}
>> +
>> +	ret = icd->ops->set_bus_param(icd, common_flags);
>> +	if (ret < 0) {
>> +		dev_dbg(icd->dev.parent, "Camera set_bus_param(%lx) returned %d\n",
>> +			common_flags, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* set bus param for ISI */
>> +	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
>> +		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;
>> +	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
>> +		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
>> +	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
>> +		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
>> +
>> +	if (isi->pdata->has_emb_sync)
>> +		cfg1 |= ISI_CFG1_EMB_SYNC;
>> +	if (isi->pdata->isi_full_mode)
>> +		cfg1 |= ISI_CFG1_FULL_MODE;
>> +
>> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> +	isi_writel(isi, ISI_CFG1, cfg1);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct soc_camera_host_ops isi_soc_camera_host_ops = {
>> +	.owner		= THIS_MODULE,
>> +	.add		= isi_camera_add_device,
>> +	.remove		= isi_camera_remove_device,
>> +	.set_fmt	= isi_camera_set_fmt,
>> +	.try_fmt	= isi_camera_try_fmt,
>> +	.get_formats	= isi_camera_get_formats,
>> +	.init_videobuf2	= isi_camera_init_videobuf,
>> +	.poll		= isi_camera_poll,
>> +	.querycap	= isi_camera_querycap,
>> +	.set_bus_param	= isi_camera_set_bus_param,
>> +};
>> +
>> +/* -----------------------------------------------------------------------*/
>> +static int __devexit atmel_isi_remove(struct platform_device *pdev)
>> +{
>> +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
>> +	struct atmel_isi *isi = container_of(soc_host,
>> +					struct atmel_isi, soc_host);
>> +

> Wouldn't it be better to first free IRQs to prevent any possible 
> interrupts?

I'll move it ahead.

>> +	soc_camera_host_unregister(soc_host);
>> +	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
>> +	dma_free_coherent(&pdev->dev,
>> +			sizeof(struct fbd) * MAX_BUFFER_NUM,
>> +			isi->p_fb_descriptors,
>> +			isi->fb_descriptors_phys);
>> +
>> +	free_irq(isi->irq, isi);
>> +	iounmap(isi->regs);
>> +	clk_put(isi->pclk);
>> +	kfree(isi);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __devinit atmel_isi_probe(struct platform_device *pdev)
>> +{
>> +	unsigned int irq;
>> +	struct atmel_isi *isi;
>> +	struct clk *pclk;
>> +	struct resource *regs;
>> +	int ret, i;
>> +	struct device *dev = &pdev->dev;
>> +	struct soc_camera_host *soc_host;
>> +
>> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!regs)
>> +		return -ENXIO;
>> +
>> +	pclk = clk_get(&pdev->dev, "isi_clk");
>> +	if (IS_ERR(pclk))
>> +		return PTR_ERR(pclk);
>> +
>> +	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
>> +	if (!isi) {
>> +		ret = -ENOMEM;
>> +		dev_err(&pdev->dev, "Can't allocate interface!\n");
>> +		goto err_alloc_isi;
>> +	}
>> +
>> +	isi->pclk = pclk;
>> +
>> +	spin_lock_init(&isi->lock);
>> +	init_waitqueue_head(&isi->vsync_wq);
>> +
>> +	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
>> +				sizeof(struct fbd) * MAX_BUFFER_NUM,
>> +				&isi->fb_descriptors_phys,
>> +				GFP_KERNEL);
>> +	if (!isi->p_fb_descriptors) {
>> +		ret = -ENOMEM;
>> +		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
>> +		goto err_alloc_descriptors;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&isi->dma_desc_head);
>> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
>> +		isi->dma_desc[i].p_fbd = isi->p_fb_descriptors + i;
>> +		isi->dma_desc[i].fbd_phys = isi->fb_descriptors_phys +
>> +					i * sizeof(struct fbd);
>> +		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
>> +	}
>> +
>> +	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>> +	if (IS_ERR(isi->alloc_ctx)) {
>> +		ret = PTR_ERR(isi->alloc_ctx);
>> +		goto err_alloc_ctx;
>> +	}
>> +
>> +	isi->regs = ioremap(regs->start, resource_size(regs));
>> +	if (!isi->regs) {
>> +		ret = -ENOMEM;
>> +		goto err_ioremap;
>> +	}
>> +
>> +	if (!dev->platform_data) {

> I would do this check right in the beginning of this function to simplify 
> error handling.

yes, indeed simplify the error handling code a lot. I'll change it.

>> +		dev_err(&pdev->dev,
>> +			"No config available for Atmel ISI\n");
>> +		ret = -EINVAL;
>> +		goto err_req_irq;
>> +	}
>> +
>> +	isi->pdata = dev->platform_data;
>> +	if (isi->pdata->data_width_flags == 0) {

> And this check too. You can even unite them into one like

>+	if (!dev->platform_data || !dev->platform_data->data_width_flags) {
>+		...
>+	}

I will change this.

> Thanks
> Guennadi

Thank you.

>> [snip]

Best Regards,
Josh Wu
