Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34652 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752771AbcKHHVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 02:21:31 -0500
Received: by mail-qt0-f193.google.com with SMTP id l20so6854380qta.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 23:21:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de> <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
From: Ying Liu <gnuiyl@gmail.com>
Date: Tue, 8 Nov 2016 15:21:29 +0800
Message-ID: <CAOcKUNXpuBgc07bMpMo0MGjxa4CJwDTvLH3SiFkAwDF6c4dGxQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/21] [media] imx: Add i.MX IPUv3 capture driver
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Sat, Oct 15, 2016 at 1:34 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This driver uses the IDMAC module's double buffering feature to do the
> processing of finished frames in the new frame acknowledge (NFACK)
> interrupt handler while the next frame is already being captured. This
> avoids a race condition between the end of frame interrupt and NFACK for
> very short blanking intervals, but causes the driver to need at least
> two buffers in flight. The last remaining frame will never be handed out
> to userspace until a new one is queued.
> It supports interlaced input and allows to translate between sequential
> and interlaced field formats using the IDMAC scan order and interlace
> offset parameters.
> Currently the direct CSI -> SMFC -> IDMAC path is supported.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Remove v4l2_media_subdev_prepare_stream and v4l2_media_subdev_s_stream,
>    subdevices will propagate s_stream calls to their upstream subdevices
>    themselves.
>  - Fix width/height to CSI output size
>  - Use colorspace provided by CSI output
>  - Implement enum/g/s/_input for v4l2-compliance
>  - Fix ipu_capture_g_parm to use the correct pad
> ---
>  drivers/media/platform/imx/Kconfig           |    9 +
>  drivers/media/platform/imx/Makefile          |    1 +
>  drivers/media/platform/imx/imx-ipu-capture.c | 1015 ++++++++++++++++++++++++++
>  drivers/media/platform/imx/imx-ipu.h         |    9 +
>  drivers/media/platform/imx/imx-ipuv3-csi.c   |   29 +-
>  5 files changed, 1061 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/platform/imx/imx-ipu-capture.c
>
> diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
> index a88c4f7..69e8648 100644
> --- a/drivers/media/platform/imx/Kconfig
> +++ b/drivers/media/platform/imx/Kconfig
> @@ -9,6 +9,15 @@ config MEDIA_IMX
>  config VIDEO_IMX_IPU_COMMON
>         tristate
>
> +config VIDEO_IMX_IPU_CAPTURE
> +       tristate "i.MX5/6 Video Capture driver"
> +       depends on IMX_IPUV3_CORE && VIDEO_V4L2_SUBDEV_API && MEDIA_IMX
> +       select VIDEOBUF2_DMA_CONTIG
> +       select VIDEO_IMX_IPU_COMMON
> +       select VIDEO_IMX_IPUV3
> +       help
> +         This is a v4l2 video capture driver for the IPUv3 on i.MX5/6.
> +
>  config VIDEO_IMX_IPU_CSI
>         tristate "i.MX5/6 CMOS Sensor Interface driver"
>         depends on VIDEO_DEV && IMX_IPUV3_CORE && MEDIA_IMX
> diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
> index 82a3616..919eaa1 100644
> --- a/drivers/media/platform/imx/Makefile
> +++ b/drivers/media/platform/imx/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_MEDIA_IMX)                        += imx-media.o
>  obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)     += imx-ipu.o
> +obj-$(CONFIG_VIDEO_IMX_IPU_CAPTURE)    += imx-ipu-capture.o
>  obj-$(CONFIG_VIDEO_IMX_IPU_CSI)                += imx-ipuv3-csi.o
> diff --git a/drivers/media/platform/imx/imx-ipu-capture.c b/drivers/media/platform/imx/imx-ipu-capture.c
> new file mode 100644
> index 0000000..1308c1e
> --- /dev/null
> +++ b/drivers/media/platform/imx/imx-ipu-capture.c
> @@ -0,0 +1,1015 @@
> +/*
> + * i.MX IPUv3 V4L2 Capture Driver
> + *
> + * Copyright (C) 2016, Pengutronix, Philipp Zabel <kernel@pengutronix.de>
> + *
> + * Based on code
> + * Copyright (C) 2006, Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> + * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/videodev2.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/time.h>
> +
> +#include <video/imx-ipu-v3.h>
> +#include "imx-ipu.h"
> +
> +#include <linux/of_graph.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mc.h>
> +#include <media/v4l2-of.h>
> +
> +#define DRIVER_NAME "imx-ipuv3-capture"
> +
> +/* buffer for one video frame */
> +struct ipu_capture_buffer {
> +       struct vb2_v4l2_buffer          vb;
> +       struct list_head                queue;
> +};
> +
> +struct ipu_capture {
> +       struct video_device             vdev;
> +
> +       struct device                   *dev;
> +       struct v4l2_fh                  fh;
> +       struct vb2_queue                vb2_vidq;
> +       struct media_pad                pad;
> +       struct media_pipeline           pipe;
> +       struct v4l2_format              format;
> +
> +       struct v4l2_subdev              *csi_sd;
> +       struct ipu_smfc                 *smfc;
> +       struct ipuv3_channel            *ipuch;
> +       struct ipu_soc                  *ipu;
> +       int                             id;
> +
> +       spinlock_t                      lock;
> +       struct mutex                    mutex;
> +
> +       /* The currently active buffer, set by NFACK and cleared by EOF interrupt */
> +       struct ipu_capture_buffer               *active;
> +       struct list_head                capture;
> +       int                             ilo;
> +       int                             sequence;
> +
> +       int                             done_count;
> +       int                             skip_count;
> +};
> +
> +
> +static struct ipu_capture_buffer *to_ipu_capture_buffer(struct vb2_buffer *vb)
> +{
> +       return container_of(vb, struct ipu_capture_buffer, vb.vb2_buf);
> +}
> +
> +static inline void ipu_capture_set_inactive_buffer(struct ipu_capture *priv,
> +                                                  struct vb2_buffer *vb)
> +{
> +       int bufptr = !ipu_idmac_get_current_buffer(priv->ipuch);
> +       dma_addr_t eba = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +       if (priv->ilo < 0)
> +               eba -= priv->ilo;
> +
> +       ipu_cpmem_set_buffer(priv->ipuch, bufptr, eba);
> +       ipu_idmac_select_buffer(priv->ipuch, bufptr);
> +}
> +
> +static irqreturn_t ipu_capture_new_frame_handler(int irq, void *context)
> +{
> +       struct ipu_capture *priv = context;
> +       struct ipu_capture_buffer *buf;
> +       struct vb2_v4l2_buffer *vb;
> +       unsigned long flags;
> +
> +       /* The IDMAC just started to write pixel data into the current buffer */
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       /*
> +        * If there is a previously active frame, mark it as done to hand it off
> +        * to userspace. Or, if there are no further frames queued, hold on to it.
> +        */
> +       if (priv->active) {
> +               vb = &priv->active->vb;
> +               buf = to_ipu_capture_buffer(&vb->vb2_buf);
> +
> +               if (vb2_is_streaming(vb->vb2_buf.vb2_queue) &&
> +                   list_is_singular(&priv->capture)) {
> +                       pr_debug("%s: reusing 0x%08x\n", __func__,
> +                               vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0));
> +                       /* DEBUG: check if buf == EBA(active) */
> +               } else {
> +                       /* Otherwise, mark buffer as finished */
> +                       list_del_init(&buf->queue);
> +
> +                       vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
> +                       priv->done_count++;
> +               }
> +       }
> +
> +       if (list_empty(&priv->capture))
> +               goto out;
> +
> +       priv->active = list_first_entry(&priv->capture,
> +                                          struct ipu_capture_buffer, queue);
> +       vb = &priv->active->vb;
> +       vb->vb2_buf.timestamp = ktime_get_ns();
> +       vb->field = priv->format.fmt.pix.field;
> +       vb->sequence = priv->sequence++;
> +
> +       /*
> +        * Point the inactive buffer address to the next queued buffer,
> +        * if available. Otherwise, prepare to reuse the currently active
> +        * buffer, unless ipu_capture_buf_queue gets called in time.
> +        */
> +       if (!list_is_singular(&priv->capture)) {
> +               buf = list_entry(priv->capture.next->next,
> +                                struct ipu_capture_buffer, queue);
> +               vb = &buf->vb;
> +       }
> +       ipu_capture_set_inactive_buffer(priv, &vb->vb2_buf);
> +out:
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int ipu_capture_get_resources(struct ipu_capture *priv)
> +{
> +       struct device *dev = priv->dev;
> +       int channel = priv->id * 2;
> +       int ret;
> +
> +       priv->ipuch = ipu_idmac_get(priv->ipu, channel);
> +       if (IS_ERR(priv->ipuch)) {
> +               ret = PTR_ERR(priv->ipuch);
> +               dev_err(dev, "Failed to get IDMAC channel %d: %d\n", channel,
> +                       ret);
> +               priv->ipuch = NULL;
> +               return ret;
> +       }
> +
> +       priv->smfc = ipu_smfc_get(priv->ipu, channel);
> +       if (!priv->smfc) {
> +               dev_err(dev, "Failed to get SMFC channel %d\n", channel);
> +               ret = -EBUSY;
> +               goto err;
> +       }
> +
> +       return 0;
> +err:
> +       ipu_idmac_put(priv->ipuch);
> +       return ret;
> +}
> +
> +static void ipu_capture_put_resources(struct ipu_capture *priv)
> +{
> +       if (priv->ipuch) {
> +               ipu_idmac_put(priv->ipuch);
> +               priv->ipuch = NULL;
> +       }
> +
> +       if (priv->smfc) {
> +               ipu_smfc_put(priv->smfc);
> +               priv->smfc = NULL;
> +       }
> +}
> +
> +/*
> + *  Videobuf operations
> + */
> +static int ipu_capture_queue_setup(struct vb2_queue *vq, unsigned int *count,
> +                                  unsigned int *num_planes, unsigned int sizes[],
> +                                  struct device *alloc_devs[])
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +
> +       priv->sequence = 0;
> +
> +       if (!*count)
> +               *count = 32;
> +       *num_planes = 1;
> +       sizes[0] = priv->format.fmt.pix.sizeimage;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_buf_prepare(struct vb2_buffer *vb)
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vb->vb2_queue);
> +       struct v4l2_pix_format *pix = &priv->format.fmt.pix;
> +
> +       if (vb2_plane_size(vb, 0) < pix->sizeimage)
> +               return -ENOBUFS;
> +
> +       vb2_set_plane_payload(vb, 0, pix->sizeimage);
> +
> +       return 0;
> +}
> +
> +static void ipu_capture_buf_queue(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +       struct ipu_capture_buffer *buf = to_ipu_capture_buffer(vb);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       /*
> +        * If there is no next buffer queued, point the inactive buffer
> +        * address to the incoming buffer
> +        */
> +       if (vb2_is_streaming(vb->vb2_queue) &&
> +           list_is_singular(&priv->capture))
> +               ipu_capture_set_inactive_buffer(priv, vb);
> +
> +       list_add_tail(&buf->queue, &priv->capture);
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void ipu_capture_buf_cleanup(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +       struct ipu_capture_buffer *buf = to_ipu_capture_buffer(vb);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       if (priv->active == buf)
> +               priv->active = NULL;
> +
> +       if (!list_empty(&buf->queue))
> +               list_del_init(&buf->queue);
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       ipu_capture_put_resources(priv);
> +}
> +
> +static int ipu_capture_buf_init(struct vb2_buffer *vb)
> +{
> +       struct ipu_capture_buffer *buf = to_ipu_capture_buffer(vb);
> +
> +       /* This is for locking debugging only */
> +       INIT_LIST_HEAD(&buf->queue);
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +       struct v4l2_subdev *csi_sd = priv->csi_sd;
> +       u32 width = priv->format.fmt.pix.width;
> +       u32 height = priv->format.fmt.pix.height;
> +       struct device *dev = priv->dev;
> +       int burstsize;
> +       struct ipu_capture_buffer *buf;
> +       int nfack_irq;
> +       int ret;
> +       const char *irq_name[2] = { "CSI0", "CSI1" };
> +       bool raw;
> +
> +       ret = ipu_capture_get_resources(priv);
> +       if (ret < 0) {
> +               dev_err(dev, "Failed to get resources: %d\n", ret);
> +               goto err_dequeue;
> +       }
> +
> +       ipu_cpmem_zero(priv->ipuch);
> +
> +       nfack_irq = ipu_idmac_channel_irq(priv->ipu, priv->ipuch,
> +                                         IPU_IRQ_NFACK);
> +       ret = request_threaded_irq(nfack_irq, NULL,
> +                                  ipu_capture_new_frame_handler, IRQF_ONESHOT,
> +                                  irq_name[priv->id], priv);
> +       if (ret) {
> +               dev_err(dev, "Failed to request NFACK interrupt: %d\n", nfack_irq);
> +               goto put_resources;
> +       }
> +
> +       dev_dbg(dev, "width: %d height: %d, %.4s\n",
> +               width, height, (char *)&priv->format.fmt.pix.pixelformat);
> +
> +       ipu_cpmem_set_resolution(priv->ipuch, width, height);
> +
> +       raw = false;
> +
> +       if (raw && priv->smfc) {
> +               /*
> +                * raw formats. We can only pass them through to memory
> +                */
> +               u32 fourcc = priv->format.fmt.pix.pixelformat;
> +               int bytes;
> +
> +               switch (fourcc) {
> +               case V4L2_PIX_FMT_GREY:
> +                       bytes = 1;
> +                       break;
> +               case V4L2_PIX_FMT_Y10:
> +               case V4L2_PIX_FMT_Y16:
> +               case V4L2_PIX_FMT_UYVY:
> +               case V4L2_PIX_FMT_YUYV:
> +                       bytes = 2;
> +                       break;
> +               }
> +
> +               ipu_cpmem_set_stride(priv->ipuch, width * bytes);
> +               ipu_cpmem_set_format_passthrough(priv->ipuch, bytes * 8);
> +               /*
> +                * According to table 37-727 (SMFC Burst Size), burstsize should
> +                * be set to NBP[6:4] for PFS == 6. Unfortunately, with a 16-bit
> +                * bus any value below 4 doesn't produce proper images.
> +                */
> +               burstsize = (64 / bytes) >> 3;
> +       } else {
> +               /*
> +                * formats we understand, we can write it in any format not requiring
> +                * colorspace conversion.
> +                */
> +               u32 fourcc = priv->format.fmt.pix.pixelformat;
> +
> +               switch (fourcc) {
> +               case V4L2_PIX_FMT_RGB32:
> +                       ipu_cpmem_set_stride(priv->ipuch, width * 4);
> +                       ipu_cpmem_set_fmt(priv->ipuch, fourcc);
> +                       break;
> +               case V4L2_PIX_FMT_UYVY:
> +               case V4L2_PIX_FMT_YUYV:
> +                       ipu_cpmem_set_stride(priv->ipuch, width * 2);
> +                       ipu_cpmem_set_yuv_interleaved(priv->ipuch, fourcc);
> +                       break;
> +               case V4L2_PIX_FMT_YUV420:
> +               case V4L2_PIX_FMT_YVU420:
> +               case V4L2_PIX_FMT_NV12:
> +               case V4L2_PIX_FMT_YUV422P:
> +                       ipu_cpmem_set_stride(priv->ipuch, width);
> +                       ipu_cpmem_set_fmt(priv->ipuch, fourcc);
> +                       ipu_cpmem_set_yuv_planar(priv->ipuch, fourcc,
> +                                                width, height);
> +                       burstsize = 16;
> +                       break;
> +               default:
> +                       dev_err(dev, "invalid color format: %4.4s\n",
> +                               (char *)&fourcc);
> +                       ret = -EINVAL;
> +                       goto free_irq;
> +               }
> +       }
> +
> +       if (priv->ilo)
> +               ipu_cpmem_interlaced_scan(priv->ipuch, priv->ilo);
> +
> +       if (priv->smfc) {
> +               /*
> +                * Set the channel for the direct CSI-->memory via SMFC
> +                * use-case to very high priority, by enabling the watermark
> +                * signal in the SMFC, enabling WM in the channel, and setting
> +                * the channel priority to high.
> +                *
> +                * Refer to the iMx6 rev. D TRM Table 36-8: Calculated priority
> +                * value.
> +                *
> +                * The WM's are set very low by intention here to ensure that
> +                * the SMFC FIFOs do not overflow.
> +                */
> +               ipu_smfc_set_watermark(priv->smfc, 2, 1);
> +               ipu_idmac_enable_watermark(priv->ipuch, true);
> +               ipu_cpmem_set_high_priority(priv->ipuch);
> +
> +               /* Superfluous due to call to ipu_cpmem_zero above */
> +               ipu_cpmem_set_axi_id(priv->ipuch, 0);
> +
> +               ipu_smfc_set_burstsize(priv->smfc, burstsize - 1);
> +               ipu_smfc_map_channel(priv->smfc, priv->id * 2, 0);
> +       }
> +
> +       /* Set the media pipeline to streaming state */
> +       ret = media_entity_pipeline_start(&csi_sd->entity, &priv->pipe);
> +       if (ret) {
> +               dev_err(dev, "Failed to start external media pipeline\n");
> +               goto stop_pipe;
> +       }
> +
> +       ipu_idmac_set_double_buffer(priv->ipuch, 1);
> +
> +       if (list_empty(&priv->capture)) {
> +               dev_err(dev, "No capture buffers\n");
> +               ret = -ENOMEM;
> +               goto stop_pipe;
> +       }
> +
> +       priv->active = NULL;
> +
> +       /* Point the inactive buffer address to the first buffer */
> +       buf = list_first_entry(&priv->capture, struct ipu_capture_buffer, queue);
> +       ipu_capture_set_inactive_buffer(priv, &buf->vb.vb2_buf);
> +
> +       ipu_idmac_enable_channel(priv->ipuch);
> +
> +       if (priv->smfc)
> +               ipu_smfc_enable(priv->smfc);
> +
> +
> +       ret = v4l2_subdev_call(priv->csi_sd, video, s_stream, 1);
> +       if (ret) {
> +               dev_err(dev, "Failed to start streaming: %d\n", ret);
> +               goto stop_pipe;
> +       }
> +
> +       return 0;
> +
> +stop_pipe:
> +       media_entity_pipeline_stop(&csi_sd->entity);
> +free_irq:
> +       free_irq(nfack_irq, priv);
> +put_resources:
> +       ipu_capture_put_resources(priv);
> +err_dequeue:
> +       while (!list_empty(&vq->queued_list)) {
> +               struct vb2_v4l2_buffer *buf;
> +
> +               buf = to_vb2_v4l2_buffer(list_first_entry(&vq->queued_list,
> +                                                         struct vb2_buffer,
> +                                                         queued_entry));
> +               list_del(&buf->vb2_buf.queued_entry);
> +               vb2_buffer_done(&buf->vb2_buf, VB2_BUF_STATE_QUEUED);
> +       }
> +       return ret;
> +}
> +
> +static void ipu_capture_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +       unsigned long flags;
> +       int nfack_irq = ipu_idmac_channel_irq(priv->ipu, priv->ipuch,
> +                                             IPU_IRQ_NFACK);
> +
> +       free_irq(nfack_irq, priv);
> +
> +       v4l2_subdev_call(priv->csi_sd, video, s_stream, 0);
> +       ipu_idmac_disable_channel(priv->ipuch);
> +       if (priv->smfc)
> +               ipu_smfc_disable(priv->smfc);
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +       while (!list_empty(&priv->capture)) {
> +               struct ipu_capture_buffer *buf = list_entry(priv->capture.next,
> +                                                struct ipu_capture_buffer, queue);
> +               list_del_init(priv->capture.next);
> +               vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +       }
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       media_entity_pipeline_stop(&priv->csi_sd->entity);
> +
> +       ipu_capture_put_resources(priv);
> +}
> +
> +static void ipu_capture_lock(struct vb2_queue *vq)
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +
> +       mutex_lock(&priv->mutex);
> +}
> +
> +static void ipu_capture_unlock(struct vb2_queue *vq)
> +{
> +       struct ipu_capture *priv = vb2_get_drv_priv(vq);
> +
> +       mutex_unlock(&priv->mutex);
> +}
> +
> +static struct vb2_ops ipu_capture_vb2_ops = {
> +       .queue_setup            = ipu_capture_queue_setup,
> +       .buf_prepare            = ipu_capture_buf_prepare,
> +       .buf_queue              = ipu_capture_buf_queue,
> +       .buf_cleanup            = ipu_capture_buf_cleanup,
> +       .buf_init               = ipu_capture_buf_init,
> +       .start_streaming        = ipu_capture_start_streaming,
> +       .stop_streaming         = ipu_capture_stop_streaming,
> +       .wait_prepare           = ipu_capture_unlock,
> +       .wait_finish            = ipu_capture_lock,
> +};
> +
> +static int ipu_capture_querycap(struct file *file, void *priv,
> +                                       struct v4l2_capability *cap)
> +{
> +       strlcpy(cap->driver, "imx-ipuv3-capture", sizeof(cap->driver));
> +       /* cap->name is set by the friendly caller:-> */
> +       strlcpy(cap->card, "imx-ipuv3-csi", sizeof(cap->card));
> +       strlcpy(cap->bus_info, "platform:imx-ipuv3-capture", sizeof(cap->bus_info));
> +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_try_fmt(struct file *file, void *fh,
> +                              struct v4l2_format *f)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev_format sd_fmt;
> +       struct ipu_fmt *fmt = NULL;
> +       enum v4l2_field in, out;
> +       int bytes_per_pixel;
> +       int ret;
> +
> +       sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       sd_fmt.pad = 1;
> +       ret = v4l2_subdev_call(priv->csi_sd, pad, get_fmt, NULL, &sd_fmt);
> +       if (ret)
> +               return ret;
> +
> +       in = sd_fmt.format.field;
> +       out = f->fmt.pix.field;
> +
> +       switch (sd_fmt.format.code) {
> +       case MEDIA_BUS_FMT_FIXED:
> +               fmt = ipu_find_fmt_rgb(f->fmt.pix.pixelformat);
> +               if (!fmt)
> +                       return -EINVAL;
> +               bytes_per_pixel = fmt->bytes_per_pixel;
> +               break;
> +       case MEDIA_BUS_FMT_UYVY8_2X8:
> +       case MEDIA_BUS_FMT_YUYV8_2X8:
> +               fmt = ipu_find_fmt_yuv(f->fmt.pix.pixelformat);
> +               if (!fmt)
> +                       return -EINVAL;
> +               bytes_per_pixel = fmt->bytes_per_pixel;
> +               break;
> +       case MEDIA_BUS_FMT_Y8_1X8:
> +               f->fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
> +               bytes_per_pixel = 1;
> +               break;
> +       case MEDIA_BUS_FMT_UYVY8_1X16:
> +               f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
> +               bytes_per_pixel = 2;
> +               break;
> +       case MEDIA_BUS_FMT_YUYV8_1X16:
> +               f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +               bytes_per_pixel = 2;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       f->fmt.pix.width = round_up(sd_fmt.format.width, 8);
> +       f->fmt.pix.height = round_up(sd_fmt.format.height, 2);
> +       f->fmt.pix.bytesperline = f->fmt.pix.width * bytes_per_pixel;
> +       f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
> +       if (fmt) {
> +               if (fmt->fourcc == V4L2_PIX_FMT_YUV420 ||
> +                   fmt->fourcc == V4L2_PIX_FMT_YVU420 ||
> +                   fmt->fourcc == V4L2_PIX_FMT_NV12)
> +                       f->fmt.pix.sizeimage = f->fmt.pix.sizeimage * 3 / 2;
> +               else if (fmt->fourcc == V4L2_PIX_FMT_YUV422P)
> +                       f->fmt.pix.sizeimage *= 2;
> +       }
> +
> +       if ((in == V4L2_FIELD_SEQ_TB && out == V4L2_FIELD_INTERLACED_TB) ||
> +           (in == V4L2_FIELD_INTERLACED_TB && out == V4L2_FIELD_SEQ_TB) ||
> +           (in == V4L2_FIELD_SEQ_BT && out == V4L2_FIELD_INTERLACED_BT) ||
> +           (in == V4L2_FIELD_INTERLACED_BT && out == V4L2_FIELD_SEQ_BT)) {
> +               /*
> +                * IDMAC scan order can be used for translation between
> +                * interlaced and sequential field formats.
> +                */
> +       } else if (out == V4L2_FIELD_NONE || out == V4L2_FIELD_INTERLACED) {
> +               /*
> +                * If userspace requests progressive or interlaced frames,
> +                * interlace sequential fields as closest approximation.
> +                */
> +               if (in == V4L2_FIELD_SEQ_TB)
> +                       out = V4L2_FIELD_INTERLACED_TB;
> +               else if (in == V4L2_FIELD_SEQ_BT)
> +                       out = V4L2_FIELD_INTERLACED_BT;
> +               else
> +                       out = in;
> +       } else {
> +               /* Translation impossible or userspace doesn't care */
> +               out = in;
> +       }
> +       f->fmt.pix.field = out;
> +
> +       if (sd_fmt.format.colorspace)
> +               f->fmt.pix.colorspace = sd_fmt.format.colorspace;
> +       else if (f->fmt.pix.colorspace == V4L2_COLORSPACE_DEFAULT)
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_s_fmt(struct file *file, void *fh,
> +               struct v4l2_format *f)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev_format sd_fmt;
> +       enum v4l2_field in, out;
> +       int ret;
> +
> +       sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       sd_fmt.pad = 1;
> +       ret = v4l2_subdev_call(priv->csi_sd, pad, get_fmt, NULL, &sd_fmt);
> +       if (ret)
> +               return ret;
> +
> +       ret = ipu_capture_try_fmt(file, fh, f);
> +       if (ret)
> +               return ret;
> +
> +       priv->format = *f;
> +
> +       /*
> +        * Set IDMAC scan order interlace offset (ILO) for translation between
> +        * interlaced and sequential field formats.
> +        */
> +       in = sd_fmt.format.field;
> +       out = f->fmt.pix.field;
> +       if ((in == V4L2_FIELD_SEQ_TB && out == V4L2_FIELD_INTERLACED_TB) ||
> +           (in == V4L2_FIELD_INTERLACED_TB && out == V4L2_FIELD_SEQ_TB))
> +               priv->ilo = f->fmt.pix.bytesperline;
> +       else if ((in == V4L2_FIELD_SEQ_BT && out == V4L2_FIELD_INTERLACED_BT) ||
> +                (in == V4L2_FIELD_INTERLACED_BT && out == V4L2_FIELD_SEQ_BT))
> +               priv->ilo = -f->fmt.pix.bytesperline;
> +       else
> +               priv->ilo = 0;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +
> +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       *f = priv->format;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_enum_input(struct file *file, void *fh,
> +                                 struct v4l2_input *i)
> +{
> +       if (i->index != 0)
> +               return -EINVAL;
> +
> +       strcpy(i->name, "CSI");
> +       i->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_g_input(struct file *file, void *fh, unsigned int *i)
> +{
> +       *i = 0;
> +       return 0;
> +}
> +
> +static int ipu_capture_s_input(struct file *file, void *fh, unsigned int i)
> +{
> +       if (i != 0)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int ipu_capture_enum_fmt(struct file *file, void *fh,
> +                               struct v4l2_fmtdesc *f)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev_format sd_fmt;
> +       u32 fourcc;
> +       int ret;
> +
> +       sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       sd_fmt.pad = 1;
> +       ret = v4l2_subdev_call(priv->csi_sd, pad, get_fmt, NULL, &sd_fmt);
> +       if (ret)
> +               return ret;
> +
> +       switch (sd_fmt.format.code) {
> +       case V4L2_PIX_FMT_RGB32:
> +               return ipu_enum_fmt_rgb(file, priv, f);
> +       case MEDIA_BUS_FMT_UYVY8_2X8:
> +       case MEDIA_BUS_FMT_YUYV8_2X8:
> +               return ipu_enum_fmt_yuv(file, priv, f);
> +       case MEDIA_BUS_FMT_Y8_1X8:
> +               fourcc = V4L2_PIX_FMT_GREY;
> +               break;
> +       case MEDIA_BUS_FMT_UYVY8_1X16:
> +               fourcc = V4L2_PIX_FMT_UYVY;
> +               break;
> +       case MEDIA_BUS_FMT_YUYV8_1X16:
> +               fourcc = V4L2_PIX_FMT_YUYV;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       if (f->index)
> +               return -EINVAL;
> +
> +       f->pixelformat = fourcc;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_link_setup(struct media_entity *entity,
> +                                 const struct media_pad *local,
> +                                 const struct media_pad *remote, u32 flags)
> +{
> +       struct video_device *vdev = media_entity_to_video_device(entity);
> +       struct ipu_capture *priv = container_of(vdev, struct ipu_capture, vdev);
> +
> +       if (priv->smfc)
> +               ipu_smfc_map_channel(priv->smfc, priv->id * 2, 0);
> +
> +       return 0;
> +}
> +
> +struct media_entity_operations ipu_capture_entity_ops = {
> +       .link_setup = ipu_capture_link_setup,
> +};
> +
> +static int ipu_capture_open(struct file *file)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       int ret;
> +
> +       ret = v4l2_pipeline_pm_use(&priv->vdev.entity, 1);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&priv->mutex);
> +       ret = v4l2_fh_open(file);
> +       mutex_unlock(&priv->mutex);
> +
> +       return ret;
> +}
> +
> +static int ipu_capture_release(struct file *file)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +
> +       v4l2_pipeline_pm_use(&priv->vdev.entity, 0);
> +
> +       if (v4l2_fh_is_singular_file(file))
> +               vb2_fop_release(file);
> +       else
> +               v4l2_fh_release(file);
> +
> +       return 0;
> +}
> +
> +static const struct v4l2_file_operations ipu_capture_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = ipu_capture_open,
> +       .release        = ipu_capture_release,
> +       .unlocked_ioctl = video_ioctl2,
> +       .mmap           = vb2_fop_mmap,
> +       .poll           = vb2_fop_poll,
> +};
> +
> +static int ipu_capture_g_parm(struct file *file, void *fh,
> +                        struct v4l2_streamparm *sp)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev *sd = priv->csi_sd;
> +       struct v4l2_subdev_frame_interval fi;
> +
> +       if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +       fi.pad = 1;
> +       v4l2_subdev_call(sd, video, g_frame_interval, &fi);
> +       sp->parm.capture.timeperframe = fi.interval;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_s_parm(struct file *file, void *fh,
> +                        struct v4l2_streamparm *sp)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev *sd = priv->csi_sd;
> +       struct v4l2_subdev_frame_interval fi;
> +
> +       if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       fi.pad = 1;
> +       fi.interval = sp->parm.capture.timeperframe;
> +       v4l2_subdev_call(sd, video, s_frame_interval, &fi);
> +       v4l2_subdev_call(sd, video, g_frame_interval, &fi);
> +       sp->parm.capture.timeperframe = fi.interval;
> +
> +       return 0;
> +}
> +
> +static int ipu_capture_enum_framesizes(struct file *file, void *fh,
> +                                      struct v4l2_frmsizeenum *fsize)
> +{
> +       struct ipu_capture *priv = video_drvdata(file);
> +       struct v4l2_subdev_format sd_fmt;
> +       struct ipu_fmt *fmt = NULL;
> +       int ret;
> +
> +       if (fsize->index != 0)
> +               return -EINVAL;
> +
> +       sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       sd_fmt.pad = 1;
> +       ret = v4l2_subdev_call(priv->csi_sd, pad, get_fmt, NULL, &sd_fmt);
> +       if (ret)
> +               return ret;
> +
> +       switch (sd_fmt.format.code) {
> +       case V4L2_PIX_FMT_RGB32:
> +               fmt = ipu_find_fmt_rgb(fsize->pixel_format);
> +               if (!fmt)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_UYVY8_2X8:
> +       case MEDIA_BUS_FMT_YUYV8_2X8:
> +               fmt = ipu_find_fmt_yuv(fsize->pixel_format);
> +               if (!fmt)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_Y8_1X8:
> +               if (fsize->pixel_format != V4L2_PIX_FMT_GREY)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_Y10_1X10:
> +               if (fsize->pixel_format != V4L2_PIX_FMT_Y10)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_Y12_1X12:
> +               if (fsize->pixel_format != V4L2_PIX_FMT_Y16)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_UYVY8_1X16:
> +               if (fsize->pixel_format != V4L2_PIX_FMT_UYVY)
> +                       return -EINVAL;
> +               break;
> +       case MEDIA_BUS_FMT_YUYV8_1X16:
> +               if (fsize->pixel_format != V4L2_PIX_FMT_YUYV)
> +                       return -EINVAL;
> +               break;
> +       }
> +
> +       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +       fsize->discrete.width = sd_fmt.format.width;
> +       fsize->discrete.height = sd_fmt.format.height;
> +
> +       return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops ipu_capture_ioctl_ops = {
> +       .vidioc_querycap                = ipu_capture_querycap,
> +
> +       .vidioc_enum_fmt_vid_cap        = ipu_capture_enum_fmt,
> +       .vidioc_try_fmt_vid_cap         = ipu_capture_try_fmt,
> +       .vidioc_s_fmt_vid_cap           = ipu_capture_s_fmt,
> +       .vidioc_g_fmt_vid_cap           = ipu_capture_g_fmt,
> +
> +       .vidioc_create_bufs             = vb2_ioctl_create_bufs,
> +       .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
> +       .vidioc_querybuf                = vb2_ioctl_querybuf,
> +
> +       .vidioc_qbuf                    = vb2_ioctl_qbuf,
> +       .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
> +       .vidioc_expbuf                  = vb2_ioctl_expbuf,
> +
> +       .vidioc_streamon                = vb2_ioctl_streamon,
> +       .vidioc_streamoff               = vb2_ioctl_streamoff,
> +
> +       .vidioc_enum_input              = ipu_capture_enum_input,
> +       .vidioc_g_input                 = ipu_capture_g_input,
> +       .vidioc_s_input                 = ipu_capture_s_input,
> +
> +       .vidioc_g_parm                  = ipu_capture_g_parm,
> +       .vidioc_s_parm                  = ipu_capture_s_parm,
> +
> +       .vidioc_enum_framesizes         = ipu_capture_enum_framesizes,
> +};
> +
> +static int ipu_capture_vb2_init(struct ipu_capture *priv)
> +{
> +       struct vb2_queue *q = &priv->vb2_vidq;
> +
> +       q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       q->io_modes = VB2_MMAP | VB2_DMABUF;
> +       q->drv_priv = priv;
> +       q->ops = &ipu_capture_vb2_ops;
> +       q->mem_ops = &vb2_dma_contig_memops;
> +       q->buf_struct_size = sizeof(struct ipu_capture_buffer);
> +       q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +       q->dev = priv->dev;
> +
> +       return vb2_queue_init(q);
> +}
> +
> +struct ipu_capture *ipu_capture_create(struct device *dev, struct ipu_soc *ipu,
> +                                      int id, struct v4l2_subdev *sd,
> +                                      int pad_index)
> +{
> +       struct video_device *vdev;
> +       struct ipu_capture *priv;
> +       struct media_link *link;
> +       int ret;
> +
> +       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return ERR_PTR(-ENOMEM);
> +
> +       priv->dev = dev;
> +       priv->ipu = ipu;
> +       priv->csi_sd = sd;
> +
> +       INIT_LIST_HEAD(&priv->capture);
> +       spin_lock_init(&priv->lock);
> +       mutex_init(&priv->mutex);
> +
> +       ret = ipu_capture_vb2_init(priv);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +
> +       vdev = &priv->vdev;
> +
> +       snprintf(vdev->name, sizeof(vdev->name), DRIVER_NAME ".%d", id);
> +       vdev->release   = video_device_release_empty;
> +       vdev->fops      = &ipu_capture_fops;
> +       vdev->ioctl_ops = &ipu_capture_ioctl_ops;
> +       vdev->v4l2_dev  = sd->v4l2_dev;
> +       vdev->minor     = -1;
> +       vdev->release   = video_device_release_empty;

This line is redundant.

Regards,
Liu Ying

> +       vdev->lock      = &priv->mutex;
> +       vdev->queue     = &priv->vb2_vidq;
> +
> +       priv->format.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32;
> +       priv->format.fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +       video_set_drvdata(vdev, priv);
> +
> +       priv->pad.flags = MEDIA_PAD_FL_SINK;
> +       vdev->entity.ops = &ipu_capture_entity_ops;
> +
> +       ret = media_entity_pads_init(&vdev->entity, 1, &priv->pad);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +
> +       ret = video_register_device(&priv->vdev, VFL_TYPE_GRABBER, -1);
> +       if (ret)
> +               media_entity_cleanup(&vdev->entity);
> +
> +       ret = media_create_pad_link(&sd->entity, pad_index,
> +                                   &vdev->entity, 0, 0);
> +       if (ret < 0) {
> +               v4l2_err(sd->v4l2_dev,
> +                        "failed to create link for '%s':%d: %d\n",
> +                        sd->entity.name, pad_index, ret);
> +               return ERR_PTR(ret);
> +       }
> +
> +       link = media_entity_find_link(&sd->entity.pads[pad_index],
> +                                     &vdev->entity.pads[0]);
> +       media_entity_setup_link(link, MEDIA_LNK_FL_ENABLED);
> +
> +       return priv;
> +}
> +EXPORT_SYMBOL_GPL(ipu_capture_create);
> +
> +void ipu_capture_destroy(struct ipu_capture *priv)
> +{
> +       video_unregister_device(&priv->vdev);
> +       media_entity_cleanup(&priv->vdev.entity);
> +       ipu_capture_put_resources(priv);
> +
> +       kfree(priv);
> +}
> +EXPORT_SYMBOL_GPL(ipu_capture_destroy);
> diff --git a/drivers/media/platform/imx/imx-ipu.h b/drivers/media/platform/imx/imx-ipu.h
> index 7b344b6..3690915 100644
> --- a/drivers/media/platform/imx/imx-ipu.h
> +++ b/drivers/media/platform/imx/imx-ipu.h
> @@ -31,4 +31,13 @@ int ipu_g_fmt(struct v4l2_format *f, struct v4l2_pix_format *pix);
>  int ipu_enum_framesizes(struct file *file, void *fh,
>                         struct v4l2_frmsizeenum *fsize);
>
> +struct device;
> +struct ipu_soc;
> +struct v4l2_subdev;
> +
> +struct ipu_capture *ipu_capture_create(struct device *dev, struct ipu_soc *ipu,
> +                                      int id, struct v4l2_subdev *sd,
> +                                      int pad_index);
> +void ipu_capture_destroy(struct ipu_capture *capture);
> +
>  #endif /* __MEDIA_IMX_IPU_H */
> diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
> index 83e0511..7837978 100644
> --- a/drivers/media/platform/imx/imx-ipuv3-csi.c
> +++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
> @@ -61,6 +61,8 @@ struct ipucsi {
>         struct media_pad                subdev_pad[2];
>         struct v4l2_mbus_framefmt       format_mbus[2];
>         struct v4l2_fract               timeperframe[2];
> +
> +       struct ipu_capture              *capture;
>  };
>
>  static int ipu_csi_get_mbus_config(struct ipucsi *ipucsi,
> @@ -266,7 +268,7 @@ static int ipucsi_subdev_g_frame_interval(struct v4l2_subdev *subdev,
>  {
>         struct ipucsi *ipucsi = container_of(subdev, struct ipucsi, subdev);
>
> -       if (fi->pad > 4)
> +       if (fi->pad > 1)
>                 return -EINVAL;
>
>         fi->interval = ipucsi->timeperframe[(fi->pad == 0) ? 0 : 1];
> @@ -311,7 +313,7 @@ static int ipucsi_subdev_s_frame_interval(struct v4l2_subdev *subdev,
>         int i, best_i = 0;
>         u64 want_us;
>
> -       if (fi->pad > 4)
> +       if (fi->pad > 1)
>                 return -EINVAL;
>
>         if (fi->pad == 0) {
> @@ -409,6 +411,7 @@ static int ipu_csi_registered(struct v4l2_subdev *sd)
>  {
>         struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
>         struct device_node *rpp;
> +       int ret;
>
>         /*
>          * Add source subdevice to asynchronous subdevice waiting list.
> @@ -429,11 +432,33 @@ static int ipu_csi_registered(struct v4l2_subdev *sd)
>                 __v4l2_async_notifier_add_subdev(sd->notifier, asd);
>         }
>
> +       /*
> +        * Create an ipu_capture instance per CSI.
> +        */
> +       ipucsi->capture = ipu_capture_create(ipucsi->dev, ipucsi->ipu,
> +                                            ipucsi->id, sd, 1);
> +       if (IS_ERR(ipucsi->capture)) {
> +               ret = PTR_ERR(ipucsi->capture);
> +               ipucsi->capture = NULL;
> +               v4l2_err(sd->v4l2_dev, "Failed to create capture device for %s: %d\n",
> +                        sd->name, ret);
> +               return ret;
> +       }
> +
>         return 0;
>  }
>
> +static void ipu_csi_unregistered(struct v4l2_subdev *sd)
> +{
> +       struct ipucsi *ipucsi = container_of(sd, struct ipucsi, subdev);
> +
> +       if (ipucsi->capture)
> +               ipu_capture_destroy(ipucsi->capture);
> +}
> +
>  struct v4l2_subdev_internal_ops ipu_csi_internal_ops = {
>         .registered = ipu_csi_registered,
> +       .unregistered = ipu_csi_unregistered,
>  };
>
>  static int ipucsi_subdev_init(struct ipucsi *ipucsi, struct device_node *node)
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
