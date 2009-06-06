Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:33248 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZFFIkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 04:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <4A292067.1070405@mocean-labs.com>
References: <4A292067.1070405@mocean-labs.com>
Date: Sat, 6 Jun 2009 12:40:02 +0400
Message-ID: <208cbae30906060140n3f64cf13gc162eee3c5a1c2ef@mail.gmail.com>
Subject: Re: [PATCH 5/9] V4L2: Added Timberdale Logiwin driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Richard
i have only two small suggestions.

On Fri, Jun 5, 2009 at 5:40 PM, Richard
Röjfors<richard.rojfors.ext@mocean-labs.com> wrote:
> V4L2 video capture driver for the logiwin IP on the Timberdale FPGA.
>
> The driver uses the Timberdale DMA engine
>
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.30-rc7/drivers/media/video/timblogiw.c
> ===================================================================
> --- linux-2.6.30-rc7/drivers/media/video/timblogiw.c    (revision 0)
> +++ linux-2.6.30-rc7/drivers/media/video/timblogiw.c    (revision 867)
> @@ -0,0 +1,949 @@
> +/*
> + * timblogiw.c timberdale FPGA LogiWin Video In driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * Timberdale FPGA LogiWin Video In
> + */
> +
> +#include <linux/list.h>
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/dma-mapping.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include "timblogiw.h"
> +#include <linux/mfd/timbdma.h>
> +#include <linux/i2c.h>
> +#include <media/timb_video.h>
> +
> +#define TIMBLOGIW_CTRL 0x40
> +
> +#define TIMBLOGIW_H_SCALE 0x20
> +#define TIMBLOGIW_V_SCALE 0x28
> +
> +#define TIMBLOGIW_X_CROP 0x58
> +#define TIMBLOGIW_Y_CROP 0x60
> +
> +#define TIMBLOGIW_W_CROP 0x00
> +#define TIMBLOGIW_H_CROP 0x08
> +
> +#define TIMBLOGIW_VERSION_CODE 0x02
> +
> +#define TIMBLOGIW_BUF  0x04
> +#define TIMBLOGIW_TBI  0x2c
> +#define TIMBLOGIW_BPL  0x30
> +
> +#define dbg(...)
> +
> +#define DMA_BUFFER_SIZE (720 * 576 * 2)
> +
> +const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
> +       {
> +               .std                    = V4L2_STD_PAL,
> +               .name                   = "PAL",
> +               .width                  = 720,
> +               .height                 = 576
> +       },
> +       {
> +               .std                    = V4L2_STD_NTSC_M,
> +               .name                   = "NTSC",
> +               .width                  = 720,
> +               .height                 = 480
> +       }
> +};
> +
> +static int timblogiw_bytes_per_line(const struct timblogiw_tvnorm *norm)
> +{
> +       return norm->width * 2;
> +}
> +
> +
> +static int timblogiw_frame_size(const struct timblogiw_tvnorm *norm)
> +{
> +       return norm->height * timblogiw_bytes_per_line(norm);
> +}
> +
> +static const struct timblogiw_tvnorm *timblogiw_get_norm(const v4l2_std_id std)
> +{
> +       int i;
> +       for (i = 0; i < ARRAY_SIZE(timblogiw_tvnorms); i++)
> +               if (timblogiw_tvnorms[i].std == std)
> +                       return timblogiw_tvnorms + i;
> +
> +       /* default to first element */
> +       return timblogiw_tvnorms;
> +}
> +
> +static void timblogiw_handleframe(unsigned long arg)
> +{
> +       struct timblogiw_frame *f;
> +       struct timblogiw *lw = (struct timblogiw *)arg;
> +
> +       spin_lock_bh(&lw->queue_lock);
> +       if (lw->dma.filled && !list_empty(&lw->inqueue)) {
> +               /* put the entry in the outqueue */
> +               f = list_entry(lw->inqueue.next, struct timblogiw_frame, frame);
> +
> +               /* copy data from the DMA buffer */
> +               memcpy(f->bufmem, lw->dma.filled->buf, f->buf.length);
> +               /* buffer consumed */
> +               lw->dma.filled = NULL;
> +
> +               do_gettimeofday(&f->buf.timestamp);
> +               f->buf.sequence = ++lw->frame_count;
> +               f->buf.field = V4L2_FIELD_NONE;
> +               f->state = F_DONE;
> +               f->buf.bytesused = f->buf.length;
> +               list_move_tail(&f->frame, &lw->outqueue);
> +               /* wake up any waiter */
> +               wake_up(&lw->wait_frame);
> +       } else {
> +               /* No user buffer available, consume buffer anyway
> +                * who wants an old video frame?
> +                */
> +               lw->dma.filled = NULL;
> +       }
> +       spin_unlock_bh(&lw->queue_lock);
> +}
> +
> +static int timblogiw_isr(u32 flag, void *pdev)
> +{
> +       struct timblogiw *lw = (struct timblogiw *)pdev;
> +
> +       if (!lw->dma.filled && (flag & DMA_IRQ_VIDEO_RX)) {
> +               /* Got a frame, store it, and flip to next DMA buffer */
> +               lw->dma.filled = lw->dma.transfer + lw->dma.curr;
> +               lw->dma.curr = !lw->dma.curr;
> +       }
> +
> +       if (lw->stream == STREAM_ON)
> +               timb_start_dma(DMA_IRQ_VIDEO_RX,
> +                       lw->dma.transfer[lw->dma.curr].handle,
> +                       timblogiw_frame_size(lw->cur_norm),
> +                       timblogiw_bytes_per_line(lw->cur_norm));
> +
> +       if (flag & DMA_IRQ_VIDEO_DROP)
> +               dbg("%s: frame dropped\n", __func__);
> +       if (flag & DMA_IRQ_VIDEO_RX) {
> +               dbg("%s: frame RX\n", __func__);
> +               tasklet_schedule(&lw->tasklet);
> +       }
> +       return 0;
> +}
> +
> +static void timblogiw_empty_framequeues(struct timblogiw *lw)
> +{
> +       u32 i;
> +
> +       dbg("%s\n", __func__);
> +
> +       INIT_LIST_HEAD(&lw->inqueue);
> +       INIT_LIST_HEAD(&lw->outqueue);
> +
> +       for (i = 0; i < lw->num_frames; i++) {
> +               lw->frame[i].state = F_UNUSED;
> +               lw->frame[i].buf.bytesused = 0;
> +       }
> +}
> +
> +u32 timblogiw_request_buffers(struct timblogiw *lw, u32 count)
> +{
> +       /* needs to be page aligned cause the */
> +       /* buffers can be mapped individually! */
> +       const size_t imagesize = PAGE_ALIGN(timblogiw_frame_size(lw->cur_norm));
> +       void *buff = NULL;
> +       u32 i;
> +
> +       dbg("%s - request of %i buffers of size %zi\n",
> +               __func__, count, imagesize);
> +
> +       lw->dma.transfer[0].buf = pci_alloc_consistent(lw->dev, DMA_BUFFER_SIZE,
> +               &lw->dma.transfer[0].handle);
> +       lw->dma.transfer[1].buf = pci_alloc_consistent(lw->dev, DMA_BUFFER_SIZE,
> +               &lw->dma.transfer[1].handle);
> +       if ((lw->dma.transfer[0].buf == NULL) ||
> +               (lw->dma.transfer[1].buf == NULL)) {
> +               printk(KERN_ALERT "alloc failed\n");

It's probably better to add module name here. This will make easy to
understand from what module this message come.

> +               if (lw->dma.transfer[0].buf != NULL)
> +                       pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
> +                               lw->dma.transfer[0].buf,
> +                               lw->dma.transfer[0].handle);
> +               if (lw->dma.transfer[1].buf != NULL)
> +                       pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
> +                               lw->dma.transfer[1].buf,
> +                               lw->dma.transfer[1].handle);
> +               return 0;
> +       }
> +
> +       if (count > TIMBLOGIW_NUM_FRAMES)
> +               count = TIMBLOGIW_NUM_FRAMES;
> +
> +       lw->num_frames = count;
> +       while (lw->num_frames > 0) {
> +               buff = vmalloc_32(lw->num_frames * imagesize);
> +               if (buff) {
> +                       memset(buff, 0, lw->num_frames * imagesize);
> +                       break;
> +               }
> +               lw->num_frames--;
> +       }
> +
> +       for (i = 0; i < lw->num_frames; i++) {
> +               lw->frame[i].bufmem = buff + i * imagesize;
> +               lw->frame[i].buf.index = i;
> +               lw->frame[i].buf.m.offset = i * imagesize;
> +               lw->frame[i].buf.length = timblogiw_frame_size(lw->cur_norm);
> +               lw->frame[i].buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               lw->frame[i].buf.sequence = 0;
> +               lw->frame[i].buf.field = V4L2_FIELD_NONE;
> +               lw->frame[i].buf.memory = V4L2_MEMORY_MMAP;
> +               lw->frame[i].buf.flags = 0;
> +       }
> +
> +       lw->dma.curr = 0;
> +       lw->dma.filled = NULL;
> +       return lw->num_frames;
> +}
> +
> +void timblogiw_release_buffers(struct timblogiw *lw)
> +{
> +       dbg("%s\n", __func__);
> +
> +       if (lw->frame[0].bufmem != NULL) {
> +               vfree(lw->frame[0].bufmem);
> +               lw->frame[0].bufmem = NULL;
> +               lw->num_frames = TIMBLOGIW_NUM_FRAMES;
> +               pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
> +                       lw->dma.transfer[0].buf, lw->dma.transfer[0].handle);
> +               pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
> +                       lw->dma.transfer[1].buf, lw->dma.transfer[1].handle);
> +       }
> +}
> +
> +/* IOCTL functions */
> +
> +static int timblogiw_g_fmt(struct file *file, void  *priv,
> +       struct v4l2_format *format)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       format->fmt.pix.width = lw->cur_norm->width;
> +       format->fmt.pix.height = lw->cur_norm->height;
> +       format->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +       format->fmt.pix.bytesperline = timblogiw_bytes_per_line(lw->cur_norm);
> +       format->fmt.pix.sizeimage = timblogiw_frame_size(lw->cur_norm);
> +       format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +       format->fmt.pix.field = V4L2_FIELD_NONE;
> +       return 0;
> +}
> +
> +static int timblogiw_try_fmt(struct file *file, void  *priv,
> +       struct v4l2_format *format)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +       struct v4l2_pix_format *pix = &format->fmt.pix;
> +
> +       dbg("%s - width=%d, height=%d, pixelformat=%d, field=%d\n"
> +               "bytes per line %d, size image: %d, colorspace: %d\n",
> +               __func__,
> +               pix->width, pix->height, pix->pixelformat, pix->field,
> +               pix->bytesperline, pix->sizeimage, pix->colorspace);
> +
> +       if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       if (format->fmt.pix.field != V4L2_FIELD_NONE)
> +               return -EINVAL;
> +
> +       if ((lw->cur_norm->height != pix->height) ||
> +               (lw->cur_norm->width != pix->width)) {
> +               pix->width = lw->cur_norm->width;
> +               pix->height = lw->cur_norm->height;
> +       }
> +
> +       return 0;
> +}
> +
> +static int timblogiw_querycap(struct file *file, void  *priv,
> +       struct v4l2_capability *cap)
> +{
> +       dbg("%s\n",  __func__);
> +       memset(cap, 0, sizeof(*cap));
> +       strncpy(cap->card, "Timberdale Video", sizeof(cap->card)-1);
> +       strncpy(cap->driver, "Timblogiw", sizeof(cap->card)-1);
> +       cap->version = TIMBLOGIW_VERSION_CODE;
> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
> +               V4L2_CAP_STREAMING;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_enum_fmt(struct file *file, void  *priv,
> +       struct v4l2_fmtdesc *fmt)
> +{
> +       dbg("%s, index: %d\n",  __func__, fmt->index);
> +
> +       if (fmt->index != 0)
> +               return -EINVAL;
> +       memset(fmt, 0, sizeof(*fmt));
> +       fmt->index = 0;
> +       fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       strncpy(fmt->description, "4:2:2, packed, YUYV",
> +               sizeof(fmt->description)-1);
> +       fmt->pixelformat = V4L2_PIX_FMT_YUYV;
> +       memset(fmt->reserved, 0, sizeof(fmt->reserved));
> +
> +       return 0;
> +}
> +
> +static int timblogiw_reqbufs(struct file *file, void  *priv,
> +       struct v4l2_requestbuffers *rb)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (rb->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +               rb->memory != V4L2_MEMORY_MMAP)
> +               return -EINVAL;
> +
> +       timblogiw_empty_framequeues(lw);
> +
> +       timblogiw_release_buffers(lw);
> +       if (rb->count)
> +               rb->count = timblogiw_request_buffers(lw, rb->count);
> +
> +       dbg("%s - VIDIOC_REQBUFS: io method is mmap. num bufs %i\n",
> +               __func__, rb->count);
> +
> +       return 0;
> +}
> +
> +static int timblogiw_querybuf(struct file *file, void  *priv,
> +       struct v4l2_buffer *b)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +               b->index >= lw->num_frames)
> +               return -EINVAL;
> +
> +       memcpy(b, &lw->frame[b->index].buf, sizeof(*b));
> +
> +       if (lw->frame[b->index].vma_use_count)
> +               b->flags |= V4L2_BUF_FLAG_MAPPED;
> +
> +       if (lw->frame[b->index].state == F_DONE)
> +               b->flags |= V4L2_BUF_FLAG_DONE;
> +       else if (lw->frame[b->index].state != F_UNUSED)
> +               b->flags |= V4L2_BUF_FLAG_QUEUED;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_qbuf(struct file *file, void  *priv, struct v4l2_buffer *b)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +       unsigned long lock_flags;
> +
> +       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +               b->index >= lw->num_frames)
> +               return -EINVAL;
> +
> +       if (lw->frame[b->index].state != F_UNUSED)
> +               return -EAGAIN;
> +
> +       if (b->memory != V4L2_MEMORY_MMAP)
> +               return -EINVAL;
> +
> +       lw->frame[b->index].state = F_QUEUED;
> +
> +       spin_lock_irqsave(&lw->queue_lock, lock_flags);
> +       list_add_tail(&lw->frame[b->index].frame, &lw->inqueue);
> +       spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
> +
> +       return 0;
> +}
> +
> +static int timblogiw_dqbuf(struct file *file, void  *priv,
> +       struct v4l2_buffer *b)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +       struct timblogiw_frame *f;
> +       unsigned long lock_flags;
> +       int ret = 0;
> +
> +       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               dbg("%s - VIDIOC_DQBUF, illegal buf type!\n",
> +                       __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (list_empty(&lw->outqueue)) {
> +               if (file->f_flags & O_NONBLOCK)
> +                       return -EAGAIN;
> +
> +               ret = wait_event_interruptible(lw->wait_frame,
> +                       !list_empty(&lw->outqueue));
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       spin_lock_irqsave(&lw->queue_lock, lock_flags);
> +       f = list_entry(lw->outqueue.next,
> +                       struct timblogiw_frame, frame);
> +       list_del(lw->outqueue.next);
> +       spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
> +
> +       f->state = F_UNUSED;
> +       memcpy(b, &f->buf, sizeof(*b));
> +
> +       if (f->vma_use_count)
> +               b->flags |= V4L2_BUF_FLAG_MAPPED;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id *std)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       *std = lw->cur_norm->std;
> +       return 0;
> +}
> +
> +static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id *std)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (!(*std & lw->cur_norm->std))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int timblogiw_enuminput(struct file *file, void  *priv,
> +       struct v4l2_input *inp)
> +{
> +       dbg("%s\n",  __func__);
> +
> +       if (inp->index != 0)
> +               return -EINVAL;
> +
> +       memset(inp, 0, sizeof(*inp));
> +       inp->index = 0;
> +
> +       strncpy(inp->name, "Timb input 1", sizeof(inp->name) - 1);
> +       inp->type = V4L2_INPUT_TYPE_CAMERA;
> +       inp->std = V4L2_STD_ALL;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_g_input(struct file *file, void  *priv,
> +       unsigned int *input)
> +{
> +       dbg("%s\n",  __func__);
> +
> +       *input = 0;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_s_input(struct file *file, void  *priv, unsigned int input)
> +{
> +       dbg("%s\n",  __func__);
> +
> +       if (input != 0)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int timblogiw_streamon(struct file *file, void  *priv, unsigned int type)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +       struct timblogiw_frame *f;
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               dbg("%s - No capture device\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (list_empty(&lw->inqueue)) {
> +               dbg("%s - inqueue is empty\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (lw->stream == STREAM_ON)
> +               return 0;
> +
> +       lw->stream = STREAM_ON;
> +
> +       f = list_entry(lw->inqueue.next,
> +               struct timblogiw_frame, frame);
> +
> +       dbg("%s - f size: %d, bpr: %d, dma addr: %x\n", __func__,
> +               timblogiw_frame_size(lw->cur_norm),
> +               timblogiw_bytes_per_line(lw->cur_norm),
> +               (unsigned int)lw->dma.transfer[lw->dma.curr].handle);
> +
> +       timb_start_dma(DMA_IRQ_VIDEO_RX,
> +               lw->dma.transfer[lw->dma.curr].handle,
> +               timblogiw_frame_size(lw->cur_norm),
> +               timblogiw_bytes_per_line(lw->cur_norm));
> +
> +       return 0;
> +}
> +
> +static int timblogiw_streamoff(struct file *file, void  *priv,
> +       unsigned int type)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       if (lw->stream == STREAM_ON) {
> +               unsigned long lock_flags;
> +               spin_lock_irqsave(&lw->queue_lock, lock_flags);
> +               timb_stop_dma(DMA_IRQ_VIDEO_RX);
> +               lw->stream = STREAM_OFF;
> +               spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
> +       }
> +       timblogiw_empty_framequeues(lw);
> +
> +       return 0;
> +}
> +
> +static int timblogiw_querystd(struct file *file, void  *priv, v4l2_std_id *std)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s\n",  __func__);
> +
> +       return v4l2_subdev_call(lw->sd_enc, video, querystd, std);
> +}
> +
> +static int timblogiw_enum_framesizes(struct file *file, void  *priv,
> +       struct v4l2_frmsizeenum *fsize)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +
> +       dbg("%s - index: %d, format: %d\n",  __func__,
> +               fsize->index, fsize->pixel_format);
> +
> +       if ((fsize->index != 0) ||
> +               (fsize->pixel_format != V4L2_PIX_FMT_YUYV))
> +               return -EINVAL;
> +
> +       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +       fsize->discrete.width = lw->cur_norm->width;
> +       fsize->discrete.height = lw->cur_norm->height;
> +
> +       return 0;
> +}
> +
> +/*******************************
> + * Device Operations functions *
> + *******************************/
> +
> +static int timblogiw_open(struct file *file)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct timblogiw *lw = video_get_drvdata(vdev);
> +       v4l2_std_id std = V4L2_STD_UNKNOWN;
> +
> +       dbg("%s -\n", __func__);
> +
> +       mutex_init(&lw->fileop_lock);
> +       spin_lock_init(&lw->queue_lock);
> +       init_waitqueue_head(&lw->wait_frame);
> +
> +       mutex_lock(&lw->lock);
> +
> +       timblogiw_querystd(file, NULL, &std);
> +       lw->video_dev->tvnorms = std;
> +       lw->cur_norm = timblogiw_get_norm(std);
> +
> +       file->private_data = lw;
> +       lw->stream = STREAM_OFF;
> +       lw->num_frames = TIMBLOGIW_NUM_FRAMES;
> +
> +       timblogiw_empty_framequeues(lw);
> +       timb_set_dma_interruptcb(DMA_IRQ_VIDEO_RX | DMA_IRQ_VIDEO_DROP,
> +               timblogiw_isr, (void *)lw);
> +       mutex_unlock(&lw->lock);
> +
> +       return 0;
> +}
> +
> +static int timblogiw_close(struct file *file)
> +{
> +       struct timblogiw *lw = file->private_data;
> +
> +       dbg("%s - entry\n", __func__);
> +
> +       mutex_lock(&lw->lock);
> +
> +       timb_stop_dma(DMA_IRQ_VIDEO_RX);
> +       timb_set_dma_interruptcb(DMA_IRQ_VIDEO_RX | DMA_IRQ_VIDEO_DROP, NULL,
> +               NULL);
> +       timblogiw_release_buffers(lw);
> +
> +       mutex_unlock(&lw->lock);
> +       return 0;
> +}
> +
> +static ssize_t timblogiw_read(struct file *file, char __user *data,
> +       size_t count, loff_t *ppos)
> +{
> +       dbg("%s - read request\n", __func__);
> +       return -EINVAL;
> +}
> +
> +static void timblogiw_vm_open(struct vm_area_struct *vma)
> +{
> +       struct timblogiw_frame *f = vma->vm_private_data;
> +       f->vma_use_count++;
> +}
> +
> +static void timblogiw_vm_close(struct vm_area_struct *vma)
> +{
> +       struct timblogiw_frame *f = vma->vm_private_data;
> +       f->vma_use_count--;
> +}
> +
> +static struct vm_operations_struct timblogiw_vm_ops = {
> +       .open = timblogiw_vm_open,
> +       .close = timblogiw_vm_close,
> +};
> +
> +static int timblogiw_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +       unsigned long size = vma->vm_end - vma->vm_start, start = vma->vm_start;
> +       void *pos;
> +       u32 i;
> +       int ret = -EINVAL;
> +
> +       struct timblogiw *lw = filp->private_data;
> +       dbg("%s\n", __func__);
> +
> +       if (mutex_lock_interruptible(&lw->fileop_lock))
> +               return -ERESTARTSYS;
> +
> +       if (!(vma->vm_flags & VM_WRITE) ||
> +               size != PAGE_ALIGN(lw->frame[0].buf.length))
> +               goto error_unlock;
> +
> +       for (i = 0; i < lw->num_frames; i++)
> +               if ((lw->frame[i].buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
> +                       break;
> +
> +       if (i == lw->num_frames) {
> +               dbg("%s - user supplied mapping address is out of range\n",
> +                       __func__);
> +               goto error_unlock;
> +       }
> +
> +       vma->vm_flags |= VM_IO;
> +       vma->vm_flags |= VM_RESERVED;   /* Do not swap out this VMA */
> +
> +       pos = lw->frame[i].bufmem;
> +       while (size > 0) {              /* size is page-aligned */
> +               if (vm_insert_page(vma, start, vmalloc_to_page(pos))) {
> +                       dbg("%s - vm_insert_page failed\n", __func__);
> +                       ret = -EAGAIN;
> +                       goto error_unlock;
> +               }
> +               start += PAGE_SIZE;
> +               pos += PAGE_SIZE;
> +               size -= PAGE_SIZE;
> +       }
> +
> +       vma->vm_ops = &timblogiw_vm_ops;
> +       vma->vm_private_data = &lw->frame[i];
> +       timblogiw_vm_open(vma);
> +       ret = 0;
> +
> +error_unlock:
> +       mutex_unlock(&lw->fileop_lock);
> +       return ret;
> +}
> +
> +
> +void timblogiw_vdev_release(struct video_device *vdev)
> +{
> +       kfree(vdev);
> +}
> +
> +static const struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
> +       .vidioc_querycap      = timblogiw_querycap,
> +       .vidioc_enum_fmt_vid_cap  = timblogiw_enum_fmt,
> +       .vidioc_g_fmt_vid_cap     = timblogiw_g_fmt,
> +       .vidioc_try_fmt_vid_cap   = timblogiw_try_fmt,
> +       .vidioc_s_fmt_vid_cap     = timblogiw_try_fmt,
> +       .vidioc_reqbufs       = timblogiw_reqbufs,
> +       .vidioc_querybuf      = timblogiw_querybuf,
> +       .vidioc_qbuf          = timblogiw_qbuf,
> +       .vidioc_dqbuf         = timblogiw_dqbuf,
> +       .vidioc_g_std         = timblogiw_g_std,
> +       .vidioc_s_std         = timblogiw_s_std,
> +       .vidioc_enum_input    = timblogiw_enuminput,
> +       .vidioc_g_input       = timblogiw_g_input,
> +       .vidioc_s_input       = timblogiw_s_input,
> +       .vidioc_streamon      = timblogiw_streamon,
> +       .vidioc_streamoff     = timblogiw_streamoff,
> +       .vidioc_querystd      = timblogiw_querystd,
> +       .vidioc_enum_framesizes = timblogiw_enum_framesizes,
> +};
> +
> +static const struct v4l2_file_operations timblogiw_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = timblogiw_open,
> +       .release        = timblogiw_close,
> +       .ioctl          = video_ioctl2, /* V4L2 ioctl handler */
> +       .mmap           = timblogiw_mmap,
> +       .read           = timblogiw_read,
> +};
> +
> +static const struct video_device timblogiw_template = {
> +       .name           = TIMBLOGIWIN_NAME,
> +       .fops           = &timblogiw_fops,
> +       .ioctl_ops      = &timblogiw_ioctl_ops,
> +       .release        = &timblogiw_vdev_release,
> +       .minor          = -1
> +};
> +
> +
> +struct find_addr_arg {
> +       char const *name;
> +       struct i2c_client *client;
> +};
> +
> +static int find_name(struct device *dev, void *argp)
> +{
> +       struct find_addr_arg    *arg = (struct find_addr_arg *)argp;
> +       struct i2c_client       *client = i2c_verify_client(dev);
> +
> +       if (client && !strcmp(arg->name, client->name) && client->driver)
> +               arg->client = client;
> +
> +       return 0;
> +}
> +
> +static int timblogiw_probe(struct platform_device *dev)
> +{
> +       int err;
> +       struct timblogiw *lw;
> +       struct resource *iomem;
> +       struct timb_video_platform_data *pdata = dev->dev.platform_data;
> +       struct i2c_adapter *adapt;
> +       struct i2c_client *encoder;
> +       struct find_addr_arg find_arg;
> +
> +       if (!pdata) {
> +               printk(KERN_ERR "timblogiw: Platform data missing\n");
> +               err = -EINVAL;
> +               goto err_mem;
> +       }
> +
> +       iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +       if (!iomem) {
> +               err = -EINVAL;
> +               goto err_mem;
> +       }
> +
> +       lw = kzalloc(sizeof(*lw), GFP_KERNEL);
> +       if (!lw) {
> +               err = -EINVAL;

Looks like this error is -ENOMEM.

> +               goto err_mem;
> +       }
> +
> +       /* find the PCI device from the parent... */
> +       if (!dev->dev.parent) {
> +               printk(KERN_ERR "timblogiw: No parent device found??\n");
> +               err = -ENODEV;
> +               goto err_encoder;
> +       }
> +
> +       lw->dev = container_of(dev->dev.parent, struct pci_dev, dev);
> +
> +       /* find the video decoder */
> +       adapt = i2c_get_adapter(pdata->i2c_adapter);
> +       if (!adapt) {
> +               printk(KERN_ERR "timblogiw: No I2C bus\n");
> +               err = -ENODEV;
> +               goto err_encoder;
> +       }
> +
> +       /* now find the encoder */
> +#ifdef MODULE
> +       request_module(pdata->encoder);
> +#endif
> +       /* Code for finding the I2C child */
> +       find_arg.name = pdata->encoder;
> +       find_arg.client = NULL;
> +       device_for_each_child(&adapt->dev, &find_arg, find_name);
> +       encoder = find_arg.client;
> +       i2c_put_adapter(adapt);
> +
> +       if (!encoder) {
> +               printk(KERN_ERR "timblogiw: Failed to get encoder\n");
> +               err = -ENODEV;
> +               goto err_encoder;
> +       }
> +
> +       /* Lock the module */
> +       if (!try_module_get(encoder->driver->driver.owner)) {
> +               err = -ENODEV;
> +               goto err_encoder;
> +       }
> +
> +       lw->sd_enc = i2c_get_clientdata(encoder);
> +
> +       mutex_init(&lw->lock);
> +
> +       lw->video_dev = video_device_alloc();
> +       if (!lw->video_dev) {
> +               err = -ENOMEM;
> +               goto err_video_req;
> +       }
> +       *lw->video_dev = timblogiw_template;
> +
> +       err = video_register_device(lw->video_dev, VFL_TYPE_GRABBER, 0);
> +       if (err) {
> +               video_device_release(lw->video_dev);
> +               printk(KERN_ALERT "Error reg video\n");

Probably, here module name is needed too.

-- 
Best regards, Klimov Alexey
