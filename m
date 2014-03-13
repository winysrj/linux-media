Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10104 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaCMO2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:28:17 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2D0070RPJ3QJ70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 10:28:15 -0400 (EDT)
Date: Thu, 13 Mar 2014 11:28:09 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH] v4l2-pci-skeleton: add a V4L2 PCI skeleton driver
Message-id: <20140313112809.72523301@samsung.com>
In-reply-to: <531C91CE.9050904@xs4all.nl>
References: <531C91CE.9050904@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I don't like very much the idea of adding skeleton drivers inside
drivers/media. We have there already enough drivers to pollute
it with more skeleton ones.

I think that the best is to put it on some other place.

Eventually, we could put it at Documentation:

$ ls Documentation/*/*.c
Documentation/accounting/getdelays.c           Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
Documentation/auxdisplay/cfag12864b-example.c  Documentation/prctl/disable-tsc-on-off-stress-test.c
Documentation/blackfin/gptimers-example.c      Documentation/prctl/disable-tsc-test.c
Documentation/connector/cn_test.c              Documentation/ptp/testptp.c
Documentation/connector/ucon.c                 Documentation/spi/spidev_fdx.c
Documentation/filesystems/dnotify_test.c       Documentation/spi/spidev_test.c
Documentation/ia64/aliasing-test.c             Documentation/timers/hpet_example.c
Documentation/laptops/dslm.c                   Documentation/vDSO/parse_vdso.c
Documentation/laptops/hpfall.c                 Documentation/vDSO/vdso_test.c

Some drivers there, like:
	Documentation/blackfin/gptimers-example.c

Are clearly skeleton drivers.

Regards,
Mauro

Em Sun, 09 Mar 2014 17:07:42 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This patch is almost identical to the earlier RFC version:
> 
> https://patchwork.linuxtv.org/patch/21780/
> 
> The only changes are that it has been rebased to the latest vb2 changes so it
> can take advantage of the min_buffers_needed field and it adds code to requeue
> buffers in case of a failure when starting the DMA.
> 
> This example driver uses all the latest frameworks and can serve as a
> starting point for a new V4L2 PCI driver.
> 
> Originally written for a presentation on how to use V4L2 frameworks
> during FOSDEM 2014.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/Kconfig                      |   1 +
>  drivers/media/pci/Makefile                     |   2 +
>  drivers/media/pci/skeleton/Kconfig             |  11 +
>  drivers/media/pci/skeleton/Makefile            |   1 +
>  drivers/media/pci/skeleton/v4l2-pci-skeleton.c | 912 +++++++++++++++++++++++++
>  5 files changed, 927 insertions(+)
>  create mode 100644 drivers/media/pci/skeleton/Kconfig
>  create mode 100644 drivers/media/pci/skeleton/Makefile
>  create mode 100644 drivers/media/pci/skeleton/v4l2-pci-skeleton.c
> 
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 53196f1..1717a91 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -19,6 +19,7 @@ if MEDIA_ANALOG_TV_SUPPORT
>  source "drivers/media/pci/ivtv/Kconfig"
>  source "drivers/media/pci/zoran/Kconfig"
>  source "drivers/media/pci/saa7146/Kconfig"
> +source "drivers/media/pci/skeleton/Kconfig"
>  endif
>  
>  if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index 35cc578..ec08f46 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -11,11 +11,13 @@ obj-y        +=	ttpci/		\
>  		ngene/		\
>  		ddbridge/	\
>  		b2c2/		\
> +		skeleton/	\
>  		saa7146/
>  
>  obj-$(CONFIG_VIDEO_IVTV) += ivtv/
>  obj-$(CONFIG_VIDEO_ZORAN) += zoran/
>  obj-$(CONFIG_VIDEO_CX18) += cx18/
> +obj-$(CONFIG_VIDEO_PCI_SKELETON) += skeleton/
>  obj-$(CONFIG_VIDEO_CX23885) += cx23885/
>  obj-$(CONFIG_VIDEO_CX25821) += cx25821/
>  obj-$(CONFIG_VIDEO_CX88) += cx88/
> diff --git a/drivers/media/pci/skeleton/Kconfig b/drivers/media/pci/skeleton/Kconfig
> new file mode 100644
> index 0000000..e58b150
> --- /dev/null
> +++ b/drivers/media/pci/skeleton/Kconfig
> @@ -0,0 +1,11 @@
> +config VIDEO_PCI_SKELETON
> +	tristate "V4L2 PCI Skeleton Driver"
> +	select VIDEOBUF2_DMA_CONTIG
> +	depends on PCI && VIDEO_V4L2
> +	default n
> +	help
> +	  Say Y for support for this PCI Skeleton Driver capture
> +	  device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called v4l2-pci-skeleton.
> diff --git a/drivers/media/pci/skeleton/Makefile b/drivers/media/pci/skeleton/Makefile
> new file mode 100644
> index 0000000..3a935ca
> --- /dev/null
> +++ b/drivers/media/pci/skeleton/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_PCI_SKELETON) += v4l2-pci-skeleton.o
> diff --git a/drivers/media/pci/skeleton/v4l2-pci-skeleton.c b/drivers/media/pci/skeleton/v4l2-pci-skeleton.c
> new file mode 100644
> index 0000000..53d2d7a
> --- /dev/null
> +++ b/drivers/media/pci/skeleton/v4l2-pci-skeleton.c
> @@ -0,0 +1,912 @@
> +/*
> + * This is a V4L2 PCI Skeleton Driver. It gives an initial skeleton source
> + * for use with other PCI drivers.
> + *
> + * This skeleton PCI driver assumes that the card has an S-Video connector as
> + * input 0 and an HDMI connector as input 1.
> + *
> + * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kmod.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/videodev2.h>
> +#include <linux/v4l2-dv-timings.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +MODULE_DESCRIPTION("V4L2 PCI Skeleton Driver");
> +MODULE_AUTHOR("Hans Verkuil");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DEVICE_TABLE(pci, skeleton_pci_tbl);
> +
> +/**
> + * struct skeleton - All internal data for one instance of device
> + * @pdev: PCI device
> + * @v4l2_dev: top-level v4l2 device struct
> + * @vdev: video node structure
> + * @ctrl_handler: control handler structure
> + * @lock: ioctl serialization mutex
> + * @std: current SDTV standard
> + * @timings: current HDTV timings
> + * @format: current pix format
> + * @input: current video input (0 = SDTV, 1 = HDTV)
> + * @queue: vb2 video capture queue
> + * @alloc_ctx: vb2 contiguous DMA context
> + * @qlock: spinlock controlling access to buf_list and sequence
> + * @buf_list: list of buffers queued for DMA
> + * @sequence: frame sequence counter
> + */
> +struct skeleton {
> +	struct pci_dev *pdev;
> +	struct v4l2_device v4l2_dev;
> +	struct video_device vdev;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct mutex lock;
> +	v4l2_std_id std;
> +	struct v4l2_dv_timings timings;
> +	struct v4l2_pix_format format;
> +	unsigned input;
> +
> +	struct vb2_queue queue;
> +	struct vb2_alloc_ctx *alloc_ctx;
> +
> +	spinlock_t qlock;
> +	struct list_head buf_list;
> +	unsigned int sequence;
> +};
> +
> +struct skel_buffer {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +};
> +
> +static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
> +{
> +	return container_of(vb2, struct skel_buffer, vb);
> +}
> +
> +static const struct pci_device_id skeleton_pci_tbl[] = {
> +	/* { PCI_DEVICE(PCI_VENDOR_ID_, PCI_DEVICE_ID_) }, */
> +	{ 0, }
> +};
> +
> +/*
> + * HDTV: this structure has the capabilities of the HDTV receiver.
> + * It is used to constrain the huge list of possible formats based
> + * upon the hardware capabilities.
> + */
> +static const struct v4l2_dv_timings_cap skel_timings_cap = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },
> +	V4L2_INIT_BT_TIMINGS(
> +		720, 1920,		/* min/max width */
> +		480, 1080,		/* min/max height */
> +		27000000, 74250000,	/* min/max pixelclock*/
> +		V4L2_DV_BT_STD_CEA861,	/* Supported standards */
> +		/* capabilities */
> +		V4L2_DV_BT_CAP_INTERLACED | V4L2_DV_BT_CAP_PROGRESSIVE
> +	)
> +};
> +
> +/*
> + * Supported SDTV standards. This does the same job as skel_timings_cap, but
> + * for standard TV formats.
> + */
> +#define SKEL_TVNORMS V4L2_STD_ALL
> +
> +/*
> + * Interrupt handler: typically interrupts happen after a new frame has been
> + * captured. It is the job of the handler to remove the new frame from the
> + * internal list and give it back to the vb2 framework, updating the sequence
> + * counter and timestamp at the same time.
> + */
> +static irqreturn_t skeleton_irq(int irq, void *dev_id)
> +{
> +#ifdef TODO
> +	struct skeleton *skel = dev_id;
> +
> +	/* handle interrupt */
> +
> +	/* Once a new frame has been captured, mark it as done like this: */
> +	if (captured_new_frame) {
> +		...
> +		spin_lock(&skel->qlock);
> +		list_del(&new_buf->list);
> +		spin_unlock(&skel->qlock);
> +		new_buf->vb.v4l2_buf.sequence = skel->sequence++;
> +		v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
> +		vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
> +	}
> +#endif
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * Setup the constraints of the queue: besides setting the number of planes
> + * per buffer and the size and allocation context of each plane, it also
> + * checks if sufficient buffers have been allocated. Usually 3 is a good
> + * minimum number: many DMA engines need a minimum of 2 buffers in the
> + * queue and you need to have another available for userspace processing.
> + */
> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> +		       unsigned int *nbuffers, unsigned int *nplanes,
> +		       unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct skeleton *skel = vb2_get_drv_priv(vq);
> +
> +	if (vq->num_buffers + *nbuffers < 3)
> +		*nbuffers = 3 - vq->num_buffers;
> +
> +	if (fmt && fmt->fmt.pix.sizeimage < skel->format.sizeimage)
> +		return -EINVAL;
> +	*nplanes = 1;
> +	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : skel->format.sizeimage;
> +	alloc_ctxs[0] = skel->alloc_ctx;
> +	return 0;
> +}
> +
> +/*
> + * Prepare the buffer for queueing to the DMA engine: check and set the
> + * payload size and fill in the field. Note: if the format's field is
> + * V4L2_FIELD_ALTERNATE, then vb->v4l2_buf.field should be set in the
> + * interrupt handler since that's usually where you know if the TOP or
> + * BOTTOM field has been captured.
> + */
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct skeleton *skel = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = skel->format.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(&skel->pdev->dev, "buffer too small (%lu < %lu)\n",
> +			 vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +	vb->v4l2_buf.field = skel->format.field;
> +	return 0;
> +}
> +
> +/*
> + * Queue this buffer to the DMA engine.
> + */
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct skeleton *skel = vb2_get_drv_priv(vb->vb2_queue);
> +	struct skel_buffer *buf = to_skel_buffer(vb);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&skel->qlock, flags);
> +	list_add_tail(&buf->list, &skel->buf_list);
> +
> +	/* TODO: Update any DMA pointers if necessary */
> +
> +	spin_unlock_irqrestore(&skel->qlock, flags);
> +}
> +
> +static void return_all_buffers(struct skeleton *skel,
> +			       enum vb2_buffer_state state)
> +{
> +	struct skel_buffer *buf, *node;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&skel->qlock, flags);
> +	list_for_each_entry_safe(buf, node, &skel->buf_list, list) {
> +		vb2_buffer_done(&buf->vb, state);
> +		list_del(&buf->list);
> +	}
> +	spin_unlock_irqrestore(&skel->qlock, flags);
> +}
> +
> +/*
> + * Start streaming. First check if the minimum number of buffers have been
> + * queued. If not, then return -ENOBUFS and the vb2 framework will call
> + * this function again the next time a buffer has been queued until enough
> + * buffers are available to actually start the DMA engine.
> + */
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct skeleton *skel = vb2_get_drv_priv(vq);
> +	int ret = 0;
> +
> +	skel->sequence = 0;
> +
> +	/* TODO: start DMA */
> +
> +	if (ret) {
> +		/*
> +		 * In case of an error, return all active buffers to the
> +		 * QUEUED state
> +		 */
> +		return_all_buffers(skel, VB2_BUF_STATE_QUEUED);
> +	}
> +	return ret;
> +}
> +
> +/*
> + * Stop the DMA engine. Any remaining buffers in the DMA queue are dequeued
> + * and passed on to the vb2 framework marked as STATE_ERROR.
> + */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct skeleton *skel = vb2_get_drv_priv(vq);
> +
> +	/* TODO: stop DMA */
> +
> +	/* Release all active buffers */
> +	return_all_buffers(skel, VB2_BUF_STATE_ERROR);
> +	return 0;
> +}
> +
> +/*
> + * The vb2 queue ops. Note that since q->lock is set we can use the standard
> + * vb2_ops_wait_prepare/finish helper functions. If q->lock would be NULL,
> + * then this driver would have to provide these ops.
> + */
> +static struct vb2_ops skel_qops = {
> +	.queue_setup		= queue_setup,
> +	.buf_prepare		= buffer_prepare,
> +	.buf_queue		= buffer_queue,
> +	.start_streaming	= start_streaming,
> +	.stop_streaming		= stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +/*
> + * Required ioctl querycap. Note that the version field is prefilled with
> + * the version of the kernel.
> + */
> +static int skeleton_querycap(struct file *file, void *priv,
> +			     struct v4l2_capability *cap)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, "V4L2 PCI Skeleton", sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
> +		 pci_name(skel->pdev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
> +			   V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +/*
> + * Helper function to check and correct struct v4l2_pix_format. It's used
> + * not only in VIDIOC_TRY/S_FMT, but also elsewhere if changes to the SDTV
> + * standard, HDTV timings or the video input would require updating the
> + * current format.
> + */
> +static void skeleton_fill_pix_format(struct skeleton *skel,
> +				     struct v4l2_pix_format *pix)
> +{
> +	pix->pixelformat = V4L2_PIX_FMT_YUYV;
> +	if (skel->input == 0) {
> +		/* S-Video input */
> +		pix->width = 720;
> +		pix->height = (skel->std & V4L2_STD_525_60) ? 480 : 576;
> +		pix->field = V4L2_FIELD_INTERLACED;
> +		pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	} else {
> +		/* HDMI input */
> +		pix->width = skel->timings.bt.width;
> +		pix->height = skel->timings.bt.height;
> +		if (skel->timings.bt.interlaced)
> +			pix->field = V4L2_FIELD_INTERLACED;
> +		else
> +			pix->field = V4L2_FIELD_NONE;
> +		pix->colorspace = V4L2_COLORSPACE_REC709;
> +	}
> +
> +	/*
> +	 * The YUYV format is four bytes for every two pixels, so bytesperline
> +	 * is width * 2.
> +	 */
> +	pix->bytesperline = pix->width * 2;
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +	pix->priv = 0;
> +}
> +
> +static int skeleton_try_fmt_vid_cap(struct file *file, void *priv,
> +				    struct v4l2_format *f)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +
> +	/*
> +	 * Due to historical reasons providing try_fmt with an unsupported
> +	 * pixelformat will return -EINVAL for video receivers. Webcam drivers,
> +	 * however, will silently correct the pixelformat. Some video capture
> +	 * applications rely on this behavior...
> +	 */
> +	if (pix->pixelformat != V4L2_PIX_FMT_YUYV)
> +		return -EINVAL;
> +	skeleton_fill_pix_format(skel, pix);
> +	return 0;
> +}
> +
> +static int skeleton_s_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +	int ret;
> +
> +	ret = skeleton_try_fmt_vid_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * It is not allowed to change the format while buffers for use with
> +	 * streaming have already been allocated.
> +	 */
> +	if (vb2_is_busy(&skel->queue))
> +		return -EBUSY;
> +
> +	/* TODO: change format */
> +	skel->format = f->fmt.pix;
> +	return 0;
> +}
> +
> +static int skeleton_g_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	f->fmt.pix = skel->format;
> +	return 0;
> +}
> +
> +static int skeleton_enum_fmt_vid_cap(struct file *file, void *priv,
> +				     struct v4l2_fmtdesc *f)
> +{
> +	if (f->index != 0)
> +		return -EINVAL;
> +
> +	strlcpy(f->description, "4:2:2, packed, YUYV", sizeof(f->description));
> +	f->pixelformat = V4L2_PIX_FMT_YUYV;
> +	f->flags = 0;
> +	return 0;
> +}
> +
> +static int skeleton_s_std(struct file *file, void *priv, v4l2_std_id std)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* S_STD is not supported on the HDMI input */
> +	if (skel->input)
> +		return -ENODATA;
> +
> +	/*
> +	 * No change, so just return. Some applications call S_STD again after
> +	 * the buffers for streaming have been set up, so we have to allow for
> +	 * this behavior.
> +	 */
> +	if (std == skel->std)
> +		return 0;
> +
> +	/*
> +	 * Changing the standard implies a format change, which is not allowed
> +	 * while buffers for use with streaming have already been allocated.
> +	 */
> +	if (vb2_is_busy(&skel->queue))
> +		return -EBUSY;
> +
> +	/* TODO: handle changing std */
> +
> +	skel->std = std;
> +
> +	/* Update the internal format */
> +	skeleton_fill_pix_format(skel, &skel->format);
> +	return 0;
> +}
> +
> +static int skeleton_g_std(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* G_STD is not supported on the HDMI input */
> +	if (skel->input)
> +		return -ENODATA;
> +
> +	*std = skel->std;
> +	return 0;
> +}
> +
> +/*
> + * Query the current standard as seen by the hardware. This function shall
> + * never actually change the standard, it just detects and reports.
> + * The framework will initially set *std to tvnorms (i.e. the set of
> + * supported standards by this input), and this function should just AND
> + * this value. If there is no signal, then *std should be set to 0.
> + */
> +static int skeleton_querystd(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* QUERY_STD is not supported on the HDMI input */
> +	if (skel->input)
> +		return -ENODATA;
> +
> +#ifdef TODO
> +	/*
> +	 * Query currently seen standard. Initial value of *std is
> +	 * V4L2_STD_ALL. This function should look something like this:
> +	 */
> +	get_signal_info();
> +	if (no_signal) {
> +		*std = 0;
> +		return 0;
> +	}
> +	/* Use signal information to reduce the number of possible standards */
> +	if (signal_has_525_lines)
> +		*std &= V4L2_STD_525_60;
> +	else
> +		*std &= V4L2_STD_625_50;
> +#endif
> +	return 0;
> +}
> +
> +static int skeleton_s_dv_timings(struct file *file, void *_fh,
> +				 struct v4l2_dv_timings *timings)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* S_DV_TIMINGS is not supported on the S-Video input */
> +	if (skel->input == 0)
> +		return -ENODATA;
> +
> +	/* Quick sanity check */
> +	if (!v4l2_valid_dv_timings(timings, &skel_timings_cap, NULL, NULL))
> +		return -EINVAL;
> +
> +	/* Check if the timings are part of the CEA-861 timings. */
> +	if (!v4l2_find_dv_timings_cap(timings, &skel_timings_cap,
> +				      0, NULL, NULL))
> +		return -EINVAL;
> +
> +	/* Return 0 if the new timings are the same as the current timings. */
> +	if (v4l2_match_dv_timings(timings, &skel->timings, 0))
> +		return 0;
> +
> +	/*
> +	 * Changing the timings implies a format change, which is not allowed
> +	 * while buffers for use with streaming have already been allocated.
> +	 */
> +	if (vb2_is_busy(&skel->queue))
> +		return -EBUSY;
> +
> +	/* TODO: Configure new timings */
> +
> +	/* Save timings */
> +	skel->timings = *timings;
> +
> +	/* Update the internal format */
> +	skeleton_fill_pix_format(skel, &skel->format);
> +	return 0;
> +}
> +
> +static int skeleton_g_dv_timings(struct file *file, void *_fh,
> +				 struct v4l2_dv_timings *timings)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* G_DV_TIMINGS is not supported on the S-Video input */
> +	if (skel->input == 0)
> +		return -ENODATA;
> +
> +	*timings = skel->timings;
> +	return 0;
> +}
> +
> +static int skeleton_enum_dv_timings(struct file *file, void *_fh,
> +				    struct v4l2_enum_dv_timings *timings)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* ENUM_DV_TIMINGS is not supported on the S-Video input */
> +	if (skel->input == 0)
> +		return -ENODATA;
> +
> +	return v4l2_enum_dv_timings_cap(timings, &skel_timings_cap,
> +					NULL, NULL);
> +}
> +
> +/*
> + * Query the current timings as seen by the hardware. This function shall
> + * never actually change the timings, it just detects and reports.
> + * If no signal is detected, then return -ENOLINK. If the hardware cannot
> + * lock to the signal, then return -ENOLCK. If the signal is out of range
> + * of the capabilities of the system (e.g., it is possible that the receiver
> + * can lock but that the DMA engine it is connected to cannot handle
> + * pixelclocks above a certain frequency), then -ERANGE is returned.
> + */
> +static int skeleton_query_dv_timings(struct file *file, void *_fh,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* QUERY_DV_TIMINGS is not supported on the S-Video input */
> +	if (skel->input == 0)
> +		return -ENODATA;
> +
> +#ifdef TODO
> +	/*
> +	 * Query currently seen timings. This function should look
> +	 * something like this:
> +	 */
> +	detect_timings();
> +	if (no_signal)
> +		return -ENOLINK;
> +	if (cannot_lock_to_signal)
> +		return -ENOLCK;
> +	if (signal_out_of_range_of_capabilities)
> +		return -ERANGE;
> +
> +	/* Useful for debugging */
> +	v4l2_print_dv_timings(skel->v4l2_dev.name, "query_dv_timings:",
> +			timings, true);
> +#endif
> +	return 0;
> +}
> +
> +static int skeleton_dv_timings_cap(struct file *file, void *fh,
> +				   struct v4l2_dv_timings_cap *cap)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	/* DV_TIMINGS_CAP is not supported on the S-Video input */
> +	if (skel->input == 0)
> +		return -ENODATA;
> +	*cap = skel_timings_cap;
> +	return 0;
> +}
> +
> +static int skeleton_enum_input(struct file *file, void *priv,
> +			       struct v4l2_input *i)
> +{
> +	if (i->index > 1)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	if (i->index == 0) {
> +		i->std = SKEL_TVNORMS;
> +		strlcpy(i->name, "S-Video", sizeof(i->name));
> +		i->capabilities = V4L2_IN_CAP_STD;
> +	} else {
> +		i->std = 0;
> +		strlcpy(i->name, "HDMI", sizeof(i->name));
> +		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> +	}
> +	return 0;
> +}
> +
> +static int skeleton_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	if (i > 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * Changing the input implies a format change, which is not allowed
> +	 * while buffers for use with streaming have already been allocated.
> +	 */
> +	if (vb2_is_busy(&skel->queue))
> +		return -EBUSY;
> +
> +	skel->input = i;
> +	/*
> +	 * Update tvnorms. The tvnorms value is used by the core to implement
> +	 * VIDIOC_ENUMSTD so it has to be correct. If tvnorms == 0, then
> +	 * ENUMSTD will return -ENODATA.
> +	 */
> +	skel->vdev.tvnorms = i ? 0 : SKEL_TVNORMS;
> +
> +	/* Update the internal format */
> +	skeleton_fill_pix_format(skel, &skel->format);
> +	return 0;
> +}
> +
> +static int skeleton_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct skeleton *skel = video_drvdata(file);
> +
> +	*i = skel->input;
> +	return 0;
> +}
> +
> +/* The control handler. */
> +static int skeleton_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	/*struct skeleton *skel =
> +		container_of(ctrl->handler, struct skeleton, ctrl_handler);*/
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		/* TODO: set brightness to ctrl->val */
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		/* TODO: set contrast to ctrl->val */
> +		break;
> +	case V4L2_CID_SATURATION:
> +		/* TODO: set saturation to ctrl->val */
> +		break;
> +	case V4L2_CID_HUE:
> +		/* TODO: set hue to ctrl->val */
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------
> +	File operations for the device
> +   ------------------------------------------------------------------*/
> +
> +static const struct v4l2_ctrl_ops skel_ctrl_ops = {
> +	.s_ctrl = skeleton_s_ctrl,
> +};
> +
> +/*
> + * The set of all supported ioctls. Note that all the streaming ioctls
> + * use the vb2 helper functions that take care of all the locking and
> + * that also do ownership tracking (i.e. only the filehandle that requested
> + * the buffers can call the streaming ioctls, all other filehandles will
> + * receive -EBUSY if they attempt to call the same streaming ioctls).
> + *
> + * The last three ioctls also use standard helper functions: these implement
> + * standard behavior for drivers with controls.
> + */
> +static const struct v4l2_ioctl_ops skel_ioctl_ops = {
> +	.vidioc_querycap = skeleton_querycap,
> +	.vidioc_try_fmt_vid_cap = skeleton_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = skeleton_s_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = skeleton_g_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = skeleton_enum_fmt_vid_cap,
> +
> +	.vidioc_g_std = skeleton_g_std,
> +	.vidioc_s_std = skeleton_s_std,
> +	.vidioc_querystd = skeleton_querystd,
> +
> +	.vidioc_s_dv_timings = skeleton_s_dv_timings,
> +	.vidioc_g_dv_timings = skeleton_g_dv_timings,
> +	.vidioc_enum_dv_timings = skeleton_enum_dv_timings,
> +	.vidioc_query_dv_timings = skeleton_query_dv_timings,
> +	.vidioc_dv_timings_cap = skeleton_dv_timings_cap,
> +
> +	.vidioc_enum_input = skeleton_enum_input,
> +	.vidioc_g_input = skeleton_g_input,
> +	.vidioc_s_input = skeleton_s_input,
> +
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status = v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +};
> +
> +/*
> + * The set of file operations. Note that all these ops are standard core
> + * helper functions.
> + */
> +static const struct v4l2_file_operations skel_fops = {
> +	.owner = THIS_MODULE,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.unlocked_ioctl = video_ioctl2,
> +	.read = vb2_fop_read,
> +	.mmap = vb2_fop_mmap,
> +	.poll = vb2_fop_poll,
> +};
> +
> +/*
> + * The initial setup of this device instance. Note that the initial state of
> + * the driver should be complete. So the initial format, standard, timings
> + * and video input should all be initialized to some reasonable value.
> + */
> +static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	/* The initial timings are chosen to be 720p60. */
> +	static const struct v4l2_dv_timings timings_def =
> +		V4L2_DV_BT_CEA_1280X720P60;
> +	struct skeleton *skel;
> +	struct video_device *vdev;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct vb2_queue *q;
> +	int ret;
> +
> +	/* Enable PCI */
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(&pdev->dev, "no suitable DMA available.\n");
> +		goto disable_pci;
> +	}
> +
> +	/* Allocate a new instance */
> +	skel = devm_kzalloc(&pdev->dev, sizeof(struct skeleton), GFP_KERNEL);
> +	if (!skel)
> +		return -ENOMEM;
> +
> +	/* Allocate the interrupt */
> +	ret = devm_request_irq(&pdev->dev, pdev->irq,
> +			       skeleton_irq, 0, KBUILD_MODNAME, skel);
> +	if (ret) {
> +		dev_err(&pdev->dev, "request_irq failed\n");
> +		goto disable_pci;
> +	}
> +	skel->pdev = pdev;
> +
> +	/* Fill in the initial format-related settings */
> +	skel->timings = timings_def;
> +	skel->std = V4L2_STD_625_50;
> +	skeleton_fill_pix_format(skel, &skel->format);
> +
> +	/* Initialize the top-level structure */
> +	ret = v4l2_device_register(&pdev->dev, &skel->v4l2_dev);
> +	if (ret)
> +		goto disable_pci;
> +
> +	mutex_init(&skel->lock);
> +
> +	/* Add the controls */
> +	hdl = &skel->ctrl_handler;
> +	v4l2_ctrl_handler_init(hdl, 4);
> +	v4l2_ctrl_new_std(hdl, &skel_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
> +	v4l2_ctrl_new_std(hdl, &skel_ctrl_ops,
> +			  V4L2_CID_CONTRAST, 0, 255, 1, 16);
> +	v4l2_ctrl_new_std(hdl, &skel_ctrl_ops,
> +			  V4L2_CID_SATURATION, 0, 255, 1, 127);
> +	v4l2_ctrl_new_std(hdl, &skel_ctrl_ops,
> +			  V4L2_CID_HUE, -128, 127, 1, 0);
> +	if (hdl->error) {
> +		ret = hdl->error;
> +		goto free_hdl;
> +	}
> +	skel->v4l2_dev.ctrl_handler = hdl;
> +
> +	/* Initialize the vb2 queue */
> +	q = &skel->queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
> +	q->drv_priv = skel;
> +	q->buf_struct_size = sizeof(struct skel_buffer);
> +	q->ops = &skel_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	/*
> +	 * Assume that this DMA engine needs to have at least two buffers
> +	 * available before it can be started. The start_streaming() op
> +	 * won't be called until at least this many buffers are queued up.
> +	 */
> +	q->min_buffers_needed = 2;
> +	/*
> +	 * The serialization lock for the streaming ioctls. This is the same
> +	 * as the main serialization lock, but if some of the non-streaming
> +	 * ioctls could take a long time to execute, then you might want to
> +	 * have a different lock here to prevent VIDIOC_DQBUF from being
> +	 * blocked while waiting for another action to finish. This is
> +	 * generally not needed for PCI devices, but USB devices usually do
> +	 * want a separate lock here.
> +	 */
> +	q->lock = &skel->lock;
> +	/*
> +	 * Since this driver can only do 32-bit DMA we must make sure that
> +	 * the vb2 core will allocate the buffers in 32-bit DMA memory.
> +	 */
> +	q->gfp_flags = GFP_DMA32;
> +	ret = vb2_queue_init(q);
> +	if (ret)
> +		goto free_hdl;
> +
> +	skel->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(skel->alloc_ctx)) {
> +		dev_err(&pdev->dev, "Can't allocate buffer context");
> +		ret = PTR_ERR(skel->alloc_ctx);
> +		goto free_hdl;
> +	}
> +	INIT_LIST_HEAD(&skel->buf_list);
> +	spin_lock_init(&skel->qlock);
> +
> +	/* Initialize the video_device structure */
> +	vdev = &skel->vdev;
> +	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	/*
> +	 * There is nothing to clean up, so release is set to an empty release
> +	 * function. The release callback must be non-NULL.
> +	 */
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &skel_fops,
> +	vdev->ioctl_ops = &skel_ioctl_ops,
> +	/*
> +	 * The main serialization lock. All ioctls are serialized by this
> +	 * lock. Exception: if q->lock is set, then the streaming ioctls
> +	 * are serialized by that separate lock.
> +	 */
> +	vdev->lock = &skel->lock;
> +	vdev->queue = q;
> +	vdev->v4l2_dev = &skel->v4l2_dev;
> +	/* Supported SDTV standards, if any */
> +	vdev->tvnorms = SKEL_TVNORMS;
> +	/* If this bit is set, then the v4l2 core will provide the support
> +	 * for the VIDIOC_G/S_PRIORITY ioctls. This flag will eventually
> +	 * go away once all drivers have been converted to use struct v4l2_fh.
> +	 */
> +	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
> +	video_set_drvdata(vdev, skel);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret)
> +		goto free_ctx;
> +
> +	dev_info(&pdev->dev, "V4L2 PCI Skeleton Driver loaded\n");
> +	return 0;
> +
> +free_ctx:
> +	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
> +free_hdl:
> +	v4l2_ctrl_handler_free(&skel->ctrl_handler);
> +	v4l2_device_unregister(&skel->v4l2_dev);
> +disable_pci:
> +	pci_disable_device(pdev);
> +	return ret;
> +}
> +
> +static void skeleton_remove(struct pci_dev *pdev)
> +{
> +	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
> +	struct skeleton *skel = container_of(v4l2_dev, struct skeleton, v4l2_dev);
> +
> +	video_unregister_device(&skel->vdev);
> +	v4l2_ctrl_handler_free(&skel->ctrl_handler);
> +	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
> +	v4l2_device_unregister(&skel->v4l2_dev);
> +	pci_disable_device(skel->pdev);
> +}
> +
> +static struct pci_driver skeleton_driver = {
> +	.name = KBUILD_MODNAME,
> +	.probe = skeleton_probe,
> +	.remove = skeleton_remove,
> +	.id_table = skeleton_pci_tbl,
> +};
> +
> +module_pci_driver(skeleton_driver);


-- 

Regards,
Mauro
