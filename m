Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33475 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdHBDPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 23:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <5dabed8f-f848-1ada-533e-2d7614862172@xs4all.nl>
References: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
 <1501515182-26705-4-git-send-email-jacob-chen@iotwrt.com> <5dabed8f-f848-1ada-533e-2d7614862172@xs4all.nl>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Wed, 2 Aug 2017 11:15:38 +0800
Message-ID: <CAFLEztTCYSR7zRbuYKb=AgvLmY1hYkchku_znGNOwi9k_ksXjQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] [media] rockchip/rga: v4l2 m2m support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2017-08-01 0:18 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 07/31/2017 05:32 PM, Jacob Chen wrote:
>> Rockchip RGA is a separate 2D raster graphic acceleration unit. It
>> accelerates 2D graphics operations, such as point/line drawing, image
>> scaling, rotation, BitBLT, alpha blending and image blur/sharpness
>>
>> The drvier is mostly based on s5p-g2d v4l2 m2m driver
>> And supports various operations from the rendering pipeline.
>>  - copy
>>  - fast solid color fill
>>  - rotation
>>  - flip
>>  - alpha blending
>>
>> The code in rga-hw.c is used to configure regs according to operations
>> The code in rga-buf.c is used to create private mmu table for RGA.
>>
>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>> ---
>>  drivers/media/platform/Kconfig                |  11 +
>>  drivers/media/platform/Makefile               |   2 +
>>  drivers/media/platform/rockchip-rga/Makefile  |   3 +
>>  drivers/media/platform/rockchip-rga/rga-buf.c | 155 ++++
>>  drivers/media/platform/rockchip-rga/rga-hw.c  | 650 +++++++++++++++++
>>  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
>>  drivers/media/platform/rockchip-rga/rga.c     | 980 ++++++++++++++++++++++++++
>>  drivers/media/platform/rockchip-rga/rga.h     | 109 +++
>>  8 files changed, 2347 insertions(+)
>>  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>>  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>>  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>>
>
> <snip>
>
>> diff --git a/drivers/media/platform/rockchip-rga/rga.c b/drivers/media/platform/rockchip-rga/rga.c
>> new file mode 100644
>> index 0000000..0c0bc4b
>> --- /dev/null
>> +++ b/drivers/media/platform/rockchip-rga/rga.c
>> @@ -0,0 +1,980 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author: Jacob Chen <jacob-chen@iotwrt.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/reset.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/timer.h>
>> +
>> +#include <linux/platform_device.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-mem2mem.h>
>> +#include <media/videobuf2-dma-sg.h>
>> +#include <media/videobuf2-v4l2.h>
>> +
>> +#include "rga-hw.h"
>> +#include "rga.h"
>> +
>> +static void job_abort(void *prv)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct rockchip_rga *rga = ctx->rga;
>> +
>> +     if (rga->curr == NULL)  /* No job currently running */
>> +             return;
>> +
>> +     wait_event_timeout(rga->irq_queue,
>> +                        rga->curr == NULL, msecs_to_jiffies(RGA_TIMEOUT));
>> +}
>> +
>> +static void device_run(void *prv)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct rockchip_rga *rga = ctx->rga;
>> +     struct vb2_buffer *src, *dst;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&rga->ctrl_lock, flags);
>> +
>> +     rga->curr = ctx;
>> +
>> +     src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>> +     dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>> +
>> +     rga_buf_map(src);
>> +     rga_buf_map(dst);
>> +
>> +     rga_cmd_set(ctx);
>> +
>> +     rga_start(rga);
>> +
>> +     spin_unlock_irqrestore(&rga->ctrl_lock, flags);
>> +}
>> +
>> +static irqreturn_t rga_isr(int irq, void *prv)
>> +{
>> +     struct rockchip_rga *rga = prv;
>> +     int intr;
>> +
>> +     intr = rga_read(rga, RGA_INT) & 0xf;
>> +
>> +     rga_mod(rga, RGA_INT, intr << 4, 0xf << 4);
>> +
>> +     if (intr & 0x04) {
>> +             struct vb2_v4l2_buffer *src, *dst;
>> +             struct rga_ctx *ctx = rga->curr;
>> +
>> +             BUG_ON(ctx == NULL);
>> +
>> +             rga->curr = NULL;
>> +
>> +             src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>> +             dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>> +
>> +             BUG_ON(src == NULL);
>> +             BUG_ON(dst == NULL);
>> +
>> +             dst->timecode = src->timecode;
>> +             dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
>> +             dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>> +             dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>> +
>> +             v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
>> +             v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
>> +             v4l2_m2m_job_finish(rga->m2m_dev, ctx->fh.m2m_ctx);
>> +
>> +             wake_up(&rga->irq_queue);
>> +     }
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static struct v4l2_m2m_ops rga_m2m_ops = {
>> +     .device_run = device_run,
>> +     .job_abort = job_abort,
>> +};
>> +
>> +static int
>> +queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
>> +{
>> +     struct rga_ctx *ctx = priv;
>> +     int ret;
>> +
>> +     src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +     src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
>> +     src_vq->drv_priv = ctx;
>> +     src_vq->ops = &rga_qops;
>> +     src_vq->mem_ops = &vb2_dma_sg_memops;
>> +     src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> +     src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +     src_vq->lock = &ctx->rga->mutex;
>> +     src_vq->dev = ctx->rga->v4l2_dev.dev;
>> +
>> +     ret = vb2_queue_init(src_vq);
>> +     if (ret)
>> +             return ret;
>> +
>> +     dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
>> +     dst_vq->drv_priv = ctx;
>> +     dst_vq->ops = &rga_qops;
>> +     dst_vq->mem_ops = &vb2_dma_sg_memops;
>> +     dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> +     dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +     dst_vq->lock = &ctx->rga->mutex;
>> +     dst_vq->dev = ctx->rga->v4l2_dev.dev;
>> +
>> +     return vb2_queue_init(dst_vq);
>> +}
>> +
>> +static int rga_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +     struct rga_ctx *ctx = container_of(ctrl->handler, struct rga_ctx,
>> +                                        ctrl_handler);
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&ctx->rga->ctrl_lock, flags);
>> +     switch (ctrl->id) {
>> +     case V4L2_CID_PORTER_DUFF_MODE:
>> +             ctx->op = ctrl->val;
>> +             break;
>> +     case V4L2_CID_HFLIP:
>> +             ctx->hflip = ctrl->val;
>> +             break;
>> +     case V4L2_CID_VFLIP:
>> +             ctx->vflip = ctrl->val;
>> +             break;
>> +     case V4L2_CID_ROTATE:
>> +             ctx->rotate = ctrl->val;
>> +             break;
>> +     case V4L2_CID_BG_COLOR:
>> +             ctx->fill_color = ctrl->val;
>> +             break;
>> +     }
>> +     spin_unlock_irqrestore(&ctx->rga->ctrl_lock, flags);
>> +     return 0;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops rga_ctrl_ops = {
>> +     .s_ctrl = rga_s_ctrl,
>> +};
>> +
>> +static int rga_setup_ctrls(struct rga_ctx *ctx)
>> +{
>> +     struct rockchip_rga *rga = ctx->rga;
>> +
>> +     v4l2_ctrl_handler_init(&ctx->ctrl_handler, 7);
>> +
>> +     v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &rga_ctrl_ops,
>> +                            V4L2_CID_PORTER_DUFF_MODE,
>> +                            V4L2_PORTER_DUFF_CLEAR, 0,
>> +                            V4L2_PORTER_DUFF_SRC);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
>> +                       V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
>> +                       V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
>> +                       V4L2_CID_ROTATE, 0, 270, 90, 0);
>> +
>> +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
>> +                       V4L2_CID_BG_COLOR, 0, 0xffffffff, 1, 0);
>> +
>> +     if (ctx->ctrl_handler.error) {
>> +             int err = ctx->ctrl_handler.error;
>> +
>> +             v4l2_err(&rga->v4l2_dev, "%s failed\n", __func__);
>> +             v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>> +             return err;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +struct rga_fmt formats[] = {
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_ARGB32,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_ABGR8888,
>> +             .depth = 32,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_XRGB32,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_XBGR8888,
>> +             .depth = 32,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_ABGR32,
>> +             .color_swap = RGA_COLOR_ALPHA_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_ABGR8888,
>> +             .depth = 32,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_XBGR32,
>> +             .color_swap = RGA_COLOR_ALPHA_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_XBGR8888,
>> +             .depth = 32,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_RGB24,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_BGR888,
>> +             .depth = 24,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_ARGB444,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_ABGR4444,
>> +             .depth = 16,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_ARGB555,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_ABGR1555,
>> +             .depth = 16,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_RGB565,
>> +             .color_swap = RGA_COLOR_RB_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_BGR565,
>> +             .depth = 16,
>> +             .uv_factor = 1,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_NV21,
>> +             .color_swap = RGA_COLOR_UV_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV420SP,
>> +             .depth = 12,
>> +             .uv_factor = 4,
>> +             .y_div = 2,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_NV61,
>> +             .color_swap = RGA_COLOR_UV_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV422SP,
>> +             .depth = 16,
>> +             .uv_factor = 2,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_NV12,
>> +             .color_swap = RGA_COLOR_NONE_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV420SP,
>> +             .depth = 12,
>> +             .uv_factor = 4,
>> +             .y_div = 2,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_NV16,
>> +             .color_swap = RGA_COLOR_NONE_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV422SP,
>> +             .depth = 16,
>> +             .uv_factor = 2,
>> +             .y_div = 1,
>> +             .x_div = 1,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_YUV420,
>> +             .color_swap = RGA_COLOR_NONE_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV420P,
>> +             .depth = 12,
>> +             .uv_factor = 4,
>> +             .y_div = 2,
>> +             .x_div = 2,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_YUV422P,
>> +             .color_swap = RGA_COLOR_NONE_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV422P,
>> +             .depth = 16,
>> +             .uv_factor = 2,
>> +             .y_div = 1,
>> +             .x_div = 2,
>> +     },
>> +     {
>> +             .fourcc = V4L2_PIX_FMT_YVU420,
>> +             .color_swap = RGA_COLOR_UV_SWAP,
>> +             .hw_format = RGA_COLOR_FMT_YUV420P,
>> +             .depth = 12,
>> +             .uv_factor = 4,
>> +             .y_div = 2,
>> +             .x_div = 2,
>> +     },
>> +};
>> +
>> +#define NUM_FORMATS ARRAY_SIZE(formats)
>> +
>> +struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
>> +{
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < NUM_FORMATS; i++) {
>> +             if (formats[i].fourcc == f->fmt.pix.pixelformat)
>> +                     return &formats[i];
>> +     }
>> +     return NULL;
>> +}
>> +
>> +static struct rga_frame def_frame = {
>> +     .width = DEFAULT_WIDTH,
>> +     .height = DEFAULT_HEIGHT,
>> +     .crop.left = 0,
>> +     .crop.top = 0,
>> +     .crop.width = DEFAULT_WIDTH,
>> +     .crop.height = DEFAULT_HEIGHT,
>> +     .fmt = &formats[0],
>> +};
>> +
>> +struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum v4l2_buf_type type)
>> +{
>> +     switch (type) {
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             return &ctx->in;
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             return &ctx->out;
>> +     default:
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +}
>> +
>> +static int rga_open(struct file *file)
>> +{
>> +     struct rockchip_rga *rga = video_drvdata(file);
>> +     struct rga_ctx *ctx = NULL;
>> +     int ret = 0;
>> +
>> +     ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +     if (!ctx)
>> +             return -ENOMEM;
>> +     ctx->rga = rga;
>> +     /* Set default formats */
>> +     ctx->in = def_frame;
>> +     ctx->out = def_frame;
>> +
>> +     if (mutex_lock_interruptible(&rga->mutex)) {
>> +             kfree(ctx);
>> +             return -ERESTARTSYS;
>> +     }
>> +     ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(rga->m2m_dev, ctx, &queue_init);
>> +     if (IS_ERR(ctx->fh.m2m_ctx)) {
>> +             ret = PTR_ERR(ctx->fh.m2m_ctx);
>> +             mutex_unlock(&rga->mutex);
>> +             kfree(ctx);
>> +             return ret;
>> +     }
>> +     v4l2_fh_init(&ctx->fh, video_devdata(file));
>> +     file->private_data = &ctx->fh;
>> +     v4l2_fh_add(&ctx->fh);
>> +
>> +     rga_setup_ctrls(ctx);
>> +
>> +     /* Write the default values to the ctx struct */
>> +     v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
>> +
>> +     ctx->fh.ctrl_handler = &ctx->ctrl_handler;
>> +     mutex_unlock(&rga->mutex);
>> +
>> +     return 0;
>> +}
>> +
>> +static int rga_release(struct file *file)
>> +{
>> +     struct rga_ctx *ctx =
>> +             container_of(file->private_data, struct rga_ctx, fh);
>> +     struct rockchip_rga *rga = ctx->rga;
>> +
>> +     mutex_lock(&rga->mutex);
>> +
>> +     v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>> +
>> +     v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +     kfree(ctx);
>> +
>> +     mutex_unlock(&rga->mutex);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct v4l2_file_operations rga_fops = {
>> +     .owner = THIS_MODULE,
>> +     .open = rga_open,
>> +     .release = rga_release,
>> +     .poll = v4l2_m2m_fop_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap = v4l2_m2m_fop_mmap,
>> +};
>> +
>> +static int
>> +vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
>> +{
>> +     strlcpy(cap->driver, RGA_NAME, sizeof(cap->driver));
>> +     strlcpy(cap->card, "rockchip rga", sizeof(cap->card));
>> +     strlcpy(cap->bus_info, "platform:rga", sizeof(cap->bus_info));
>> +
>> +     cap->bus_info[0] = 0;
>
> You forgot to remove this line.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
>> +{
>> +     struct rga_fmt *fmt;
>> +
>> +     if (f->index >= NUM_FORMATS)
>> +             return -EINVAL;
>> +
>> +     fmt = &formats[f->index];
>> +     f->pixelformat = fmt->fourcc;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct vb2_queue *vq;
>> +     struct rga_frame *frm;
>> +
>> +     vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>> +     if (!vq)
>> +             return -EINVAL;
>> +     frm = rga_get_frame(ctx, f->type);
>> +     if (IS_ERR(frm))
>> +             return PTR_ERR(frm);
>> +
>> +     f->fmt.pix.width = frm->width;
>> +     f->fmt.pix.height = frm->height;
>> +     f->fmt.pix.field = V4L2_FIELD_NONE;
>> +     f->fmt.pix.pixelformat = frm->fmt->fourcc;
>> +     f->fmt.pix.bytesperline = frm->stride;
>> +     f->fmt.pix.sizeimage = frm->size;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_try_fmt(struct file *file, void *prv, struct v4l2_format *f)
>> +{
>> +     struct rga_fmt *fmt;
>> +
>> +     fmt = rga_fmt_find(f);
>> +     if (!fmt)
>> +             return -EINVAL;
>> +
>> +     f->fmt.pix.field = V4L2_FIELD_NONE;
>> +
>> +     if (f->fmt.pix.width > MAX_WIDTH)
>> +             f->fmt.pix.width = MAX_WIDTH;
>> +     if (f->fmt.pix.height > MAX_HEIGHT)
>> +             f->fmt.pix.height = MAX_HEIGHT;
>> +
>> +     if (f->fmt.pix.width < MIN_WIDTH)
>> +             f->fmt.pix.width = MIN_WIDTH;
>> +     if (f->fmt.pix.height < MIN_HEIGHT)
>> +             f->fmt.pix.height = MIN_HEIGHT;
>> +
>> +     if (fmt->hw_format >= RGA_COLOR_FMT_YUV422SP)
>> +             f->fmt.pix.bytesperline = f->fmt.pix.width;
>> +     else
>> +             f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
>> +
>> +     f->fmt.pix.sizeimage =
>> +             f->fmt.pix.height * (f->fmt.pix.width * fmt->depth) >> 3;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct rockchip_rga *rga = ctx->rga;
>> +     struct vb2_queue *vq;
>> +     struct rga_frame *frm;
>> +     struct rga_fmt *fmt;
>> +     int ret = 0;
>> +
>> +     /* Adjust all values accordingly to the hardware capabilities
>> +      * and chosen format.
>> +      */
>> +     ret = vidioc_try_fmt(file, prv, f);
>> +     if (ret)
>> +             return ret;
>> +     vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>> +     if (vb2_is_busy(vq)) {
>> +             v4l2_err(&rga->v4l2_dev, "queue (%d) bust\n", f->type);
>> +             return -EBUSY;
>> +     }
>> +     frm = rga_get_frame(ctx, f->type);
>> +     if (IS_ERR(frm))
>> +             return PTR_ERR(frm);
>> +     fmt = rga_fmt_find(f);
>> +     if (!fmt)
>> +             return -EINVAL;
>> +     frm->width = f->fmt.pix.width;
>> +     frm->height = f->fmt.pix.height;
>> +     frm->size = f->fmt.pix.sizeimage;
>> +     frm->fmt = fmt;
>> +     frm->stride = f->fmt.pix.bytesperline;
>> +
>> +     /* Reset crop settings */
>> +     frm->crop.left = 0;
>> +     frm->crop.top = 0;
>> +     frm->crop.width = frm->width;
>> +     frm->crop.height = frm->height;
>> +     return 0;
>> +}
>> +
>> +static int
>> +vidioc_try_crop(struct rga_ctx *ctx, u32 type,
>> +                         struct v4l2_rect *r)
>> +{
>> +     struct rockchip_rga *rga = ctx->rga;
>> +     struct rga_frame *f;
>> +
>> +     f = rga_get_frame(ctx, type);
>> +     if (IS_ERR(f))
>> +             return PTR_ERR(f);
>> +
>> +     if (r->top < 0 || r->left < 0) {
>> +             v4l2_err(&rga->v4l2_dev,
>> +                      "doesn't support negative values for top & left.\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (r->left + r->width > f->width ||
>> +         r->top + r->height > f->height ||
>> +         r->width < MIN_WIDTH || r->height < MIN_HEIGHT) {
>> +
>> +             v4l2_err(&rga->v4l2_dev, "unsupport crop value.\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_selection(struct file *file, void *prv,
>> +                                    struct v4l2_selection *s)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct rga_frame *f;
>> +
>> +     f = rga_get_frame(ctx, s->type);
>> +     if (IS_ERR(f))
>> +             return PTR_ERR(f);
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             s->r.left = 0;
>> +             s->r.top = 0;
>> +             s->r.width = f->width;
>> +             s->r.height = f->height;
>> +             return 0;
>> +
>> +     case V4L2_SEL_TGT_COMPOSE:
>> +     case V4L2_SEL_TGT_CROP:
>> +             s->r.left = f->crop.left;
>> +             s->r.top = f->crop.top;
>> +             s->r.width = f->crop.width;
>> +             s->r.height = f->crop.height;
>> +             return 0;
>> +     }
>
> You're now supporting both crop and compose. That can't be right. I suspect
> that you support crop for the output queue and compose for the capture queue.
> That's typical for m2m devices. So you need to check which queue you are
> setting the selection for and check the selection target accordingly.
>

Done.

>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static int vidioc_s_selection(struct file *file, void *prv,
>> +                                    struct v4l2_selection *s)
>> +{
>> +     struct rga_ctx *ctx = prv;
>> +     struct rga_frame *f;
>> +     struct v4l2_rect new_r;
>> +     int ret = 0;
>> +
>
> Same here: you need to check the selection target based on the queue type.
>
>> +     new_r = s->r;
>> +     ret = vidioc_try_crop(ctx, s->type, &new_r);
>> +     if (ret)
>> +             return ret;
>> +
>> +     f = rga_get_frame(ctx, s->type);
>> +     if (IS_ERR(f))
>> +             return PTR_ERR(f);
>> +
>> +     s->r = new_r;
>> +     f->crop = new_r;
>> +
>> +     return ret;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops rga_ioctl_ops = {
>> +     .vidioc_querycap = vidioc_querycap,
>> +
>> +     .vidioc_enum_fmt_vid_cap = vidioc_enum_fmt,
>> +     .vidioc_g_fmt_vid_cap = vidioc_g_fmt,
>> +     .vidioc_try_fmt_vid_cap = vidioc_try_fmt,
>> +     .vidioc_s_fmt_vid_cap = vidioc_s_fmt,
>> +
>> +     .vidioc_enum_fmt_vid_out = vidioc_enum_fmt,
>> +     .vidioc_g_fmt_vid_out = vidioc_g_fmt,
>> +     .vidioc_try_fmt_vid_out = vidioc_try_fmt,
>> +     .vidioc_s_fmt_vid_out = vidioc_s_fmt,
>> +
>> +     .vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
>> +     .vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
>> +     .vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
>> +     .vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
>> +     .vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
>> +     .vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
>> +     .vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
>> +
>> +     .vidioc_streamon = v4l2_m2m_ioctl_streamon,
>> +     .vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
>> +
>> +     .vidioc_g_selection = vidioc_g_selection,
>> +     .vidioc_s_selection = vidioc_s_selection
>> +};
>> +
>> +static struct video_device rga_videodev = {
>> +     .name = "rockchip-rga",
>> +     .fops = &rga_fops,
>> +     .ioctl_ops = &rga_ioctl_ops,
>> +     .minor = -1,
>> +     .release = video_device_release,
>> +     .vfl_dir = VFL_DIR_M2M,
>> +     .device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
>> +};
>> +
>> +static int rga_enable_clocks(struct rockchip_rga *rga)
>> +{
>> +     int ret;
>> +
>> +     ret = clk_prepare_enable(rga->sclk);
>> +     if (ret) {
>> +             dev_err(rga->dev, "Cannot enable rga sclk: %d\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     ret = clk_prepare_enable(rga->aclk);
>> +     if (ret) {
>> +             dev_err(rga->dev, "Cannot enable rga aclk: %d\n", ret);
>> +             goto err_disable_sclk;
>> +     }
>> +
>> +     ret = clk_prepare_enable(rga->hclk);
>> +     if (ret) {
>> +             dev_err(rga->dev, "Cannot enable rga hclk: %d\n", ret);
>> +             goto err_disable_aclk;
>> +     }
>> +
>> +     return 0;
>> +
>> +err_disable_sclk:
>> +     clk_disable_unprepare(rga->sclk);
>> +err_disable_aclk:
>> +     clk_disable_unprepare(rga->aclk);
>> +
>> +     return ret;
>> +}
>> +
>> +static void rga_disable_clocks(struct rockchip_rga *rga)
>> +{
>> +     clk_disable_unprepare(rga->sclk);
>> +     clk_disable_unprepare(rga->hclk);
>> +     clk_disable_unprepare(rga->aclk);
>> +}
>> +
>> +static int rga_parse_dt(struct rockchip_rga *rga)
>> +{
>> +     struct reset_control *core_rst, *axi_rst, *ahb_rst;
>> +
>> +     core_rst = devm_reset_control_get(rga->dev, "core");
>> +     if (IS_ERR(core_rst)) {
>> +             dev_err(rga->dev, "failed to get core reset controller\n");
>> +             return PTR_ERR(core_rst);
>> +     }
>> +
>> +     axi_rst = devm_reset_control_get(rga->dev, "axi");
>> +     if (IS_ERR(axi_rst)) {
>> +             dev_err(rga->dev, "failed to get axi reset controller\n");
>> +             return PTR_ERR(axi_rst);
>> +     }
>> +
>> +     ahb_rst = devm_reset_control_get(rga->dev, "ahb");
>> +     if (IS_ERR(ahb_rst)) {
>> +             dev_err(rga->dev, "failed to get ahb reset controller\n");
>> +             return PTR_ERR(ahb_rst);
>> +     }
>> +
>> +     reset_control_assert(core_rst);
>> +     udelay(1);
>> +     reset_control_deassert(core_rst);
>> +
>> +     reset_control_assert(axi_rst);
>> +     udelay(1);
>> +     reset_control_deassert(axi_rst);
>> +
>> +     reset_control_assert(ahb_rst);
>> +     udelay(1);
>> +     reset_control_deassert(ahb_rst);
>> +
>> +     rga->sclk = devm_clk_get(rga->dev, "sclk");
>> +     if (IS_ERR(rga->sclk)) {
>> +             dev_err(rga->dev, "failed to get sclk clock\n");
>> +             return PTR_ERR(rga->sclk);
>> +     }
>> +
>> +     rga->aclk = devm_clk_get(rga->dev, "aclk");
>> +     if (IS_ERR(rga->aclk)) {
>> +             dev_err(rga->dev, "failed to get aclk clock\n");
>> +             return PTR_ERR(rga->aclk);
>> +     }
>> +
>> +     rga->hclk = devm_clk_get(rga->dev, "hclk");
>> +     if (IS_ERR(rga->hclk)) {
>> +             dev_err(rga->dev, "failed to get hclk clock\n");
>> +             return PTR_ERR(rga->hclk);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int rga_probe(struct platform_device *pdev)
>> +{
>> +     struct rockchip_rga *rga;
>> +     struct video_device *vfd;
>> +     struct resource *res;
>> +     int ret = 0;
>> +     int irq;
>> +
>> +     if (!pdev->dev.of_node)
>> +             return -ENODEV;
>> +
>> +     rga = devm_kzalloc(&pdev->dev, sizeof(*rga), GFP_KERNEL);
>> +     if (!rga)
>> +             return -ENOMEM;
>> +
>> +     rga->dev = &pdev->dev;
>> +     spin_lock_init(&rga->ctrl_lock);
>> +     mutex_init(&rga->mutex);
>> +
>> +     init_waitqueue_head(&rga->irq_queue);
>> +
>> +     ret = rga_parse_dt(rga);
>> +     if (ret)
>> +             dev_err(&pdev->dev, "Unable to parse OF data\n");
>> +
>> +     pm_runtime_enable(rga->dev);
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +     rga->regs = devm_ioremap_resource(rga->dev, res);
>> +     if (IS_ERR(rga->regs)) {
>> +             ret = PTR_ERR(rga->regs);
>> +             goto err_put_clk;
>> +     }
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0) {
>> +             dev_err(rga->dev, "failed to get irq\n");
>> +             ret = irq;
>> +             goto err_put_clk;
>> +     }
>> +
>> +     ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
>> +                            dev_name(rga->dev), rga);
>> +     if (ret < 0) {
>> +             dev_err(rga->dev, "failed to request irq\n");
>> +             goto err_put_clk;
>> +     }
>> +
>> +     ret = v4l2_device_register(&pdev->dev, &rga->v4l2_dev);
>> +     if (ret)
>> +             goto err_put_clk;
>> +     vfd = video_device_alloc();
>> +     if (!vfd) {
>> +             v4l2_err(&rga->v4l2_dev, "Failed to allocate video device\n");
>> +             ret = -ENOMEM;
>> +             goto unreg_v4l2_dev;
>> +     }
>> +     *vfd = rga_videodev;
>> +     vfd->lock = &rga->mutex;
>> +     vfd->v4l2_dev = &rga->v4l2_dev;
>> +
>> +     video_set_drvdata(vfd, rga);
>> +     snprintf(vfd->name, sizeof(vfd->name), "%s", rga_videodev.name);
>> +     rga->vfd = vfd;
>> +     v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
>> +               vfd->name, video_device_node_name(vfd));
>> +     platform_set_drvdata(pdev, rga);
>> +     rga->m2m_dev = v4l2_m2m_init(&rga_m2m_ops);
>> +     if (IS_ERR(rga->m2m_dev)) {
>> +             v4l2_err(&rga->v4l2_dev, "Failed to init mem2mem device\n");
>> +             ret = PTR_ERR(rga->m2m_dev);
>> +             goto unreg_video_dev;
>> +     }
>> +
>> +     pm_runtime_get_sync(rga->dev);
>> +
>> +     rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
>> +     rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
>> +
>> +     v4l2_info(&rga->v4l2_dev, "HW Verson: 0x%x%x\n", rga->version.major,
>> +             rga->version.minor);
>
> s/Verson/Version/
>
> Also add a '.' to separate major from minor: 0x%02x.%x or something like that.
>
>> +
>> +     pm_runtime_put(rga->dev);
>> +
>> +     /* Create CMD buffer */
>> +     rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
>> +                                        &rga->cmdbuf_phy, GFP_KERNEL,
>> +                                        DMA_ATTR_WRITE_COMBINE);
>> +
>> +     rga->src_mmu_pages =
>> +             (unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
>> +     rga->dst_mmu_pages =
>> +             (unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
>> +
>> +     def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
>> +
>> +     ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
>> +     if (ret) {
>> +             v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
>> +             goto rel_vdev;
>> +     }
>> +
>> +     return 0;
>> +
>> +rel_vdev:
>> +     video_device_release(vfd);
>> +unreg_video_dev:
>> +     video_unregister_device(rga->vfd);
>> +unreg_v4l2_dev:
>> +     v4l2_device_unregister(&rga->v4l2_dev);
>> +err_put_clk:
>> +     pm_runtime_disable(rga->dev);
>> +
>> +     return ret;
>> +}
>> +
>> +static int rga_remove(struct platform_device *pdev)
>> +{
>> +     struct rockchip_rga *rga = platform_get_drvdata(pdev);
>> +
>> +     dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, &rga->cmdbuf_virt,
>> +                    rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
>> +
>> +     free_pages((unsigned long)rga->src_mmu_pages, 3);
>> +     free_pages((unsigned long)rga->dst_mmu_pages, 3);
>> +
>> +     v4l2_info(&rga->v4l2_dev, "Removing\n");
>> +
>> +     v4l2_m2m_release(rga->m2m_dev);
>> +     video_unregister_device(rga->vfd);
>> +     v4l2_device_unregister(&rga->v4l2_dev);
>> +
>> +     pm_runtime_disable(rga->dev);
>> +
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int rga_runtime_suspend(struct device *dev)
>> +{
>> +     struct rockchip_rga *rga = dev_get_drvdata(dev);
>> +
>> +     rga_disable_clocks(rga);
>> +
>> +     return 0;
>> +}
>> +
>> +static int rga_runtime_resume(struct device *dev)
>> +{
>> +     struct rockchip_rga *rga = dev_get_drvdata(dev);
>> +
>> +     return rga_enable_clocks(rga);
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops rga_pm = {
>> +     SET_RUNTIME_PM_OPS(rga_runtime_suspend,
>> +                        rga_runtime_resume, NULL)
>> +};
>> +
>> +static const struct of_device_id rockchip_rga_match[] = {
>> +     {
>> +             .compatible = "rockchip,rk3288-rga",
>> +     },
>> +     {
>> +             .compatible = "rockchip,rk3399-rga",
>> +     },
>> +     {},
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, rockchip_rga_match);
>> +
>> +static struct platform_driver rga_pdrv = {
>> +     .probe = rga_probe,
>> +     .remove = rga_remove,
>> +     .driver = {
>> +             .name = RGA_NAME,
>> +             .pm = &rga_pm,
>> +             .of_match_table = rockchip_rga_match,
>> +     },
>> +};
>> +
>> +module_platform_driver(rga_pdrv);
>> +
>> +MODULE_AUTHOR("Jacob Chen <jacob-chen@iotwrt.com>");
>> +MODULE_DESCRIPTION("Rockchip Raster 2d Grapphic Acceleration Unit");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/platform/rockchip-rga/rga.h b/drivers/media/platform/rockchip-rga/rga.h
>> new file mode 100644
>> index 0000000..3249ce2
>> --- /dev/null
>> +++ b/drivers/media/platform/rockchip-rga/rga.h
>> @@ -0,0 +1,109 @@
>> +/*
>> + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
>> + * Author: Jacob Chen <jacob-chen@iotwrt.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#ifndef __RGA_H__
>> +#define __RGA_H__
>> +
>> +#include <linux/platform_device.h>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +
>> +#define RGA_NAME "rockchip-rga"
>> +
>> +struct rga_fmt {
>> +     u32 fourcc;
>> +     int depth;
>> +     u8 uv_factor;
>> +     u8 y_div;
>> +     u8 x_div;
>> +     u8 color_swap;
>> +     u8 hw_format;
>> +};
>> +
>> +struct rga_frame {
>> +     /* Original dimensions */
>> +     u32 width;
>> +     u32 height;
>> +
>> +     /* Crop */
>> +     struct v4l2_rect crop;
>> +
>> +     /* Image format */
>> +     struct rga_fmt *fmt;
>> +
>> +     /* Variables that can calculated once and reused */
>> +     u32 stride;
>> +     u32 size;
>> +};
>> +
>> +struct rockchip_rga_version {
>> +     u32 major;
>> +     u32 minor;
>> +};
>> +
>> +struct rga_ctx {
>> +     struct v4l2_fh fh;
>> +     struct rockchip_rga *rga;
>> +     struct rga_frame in;
>> +     struct rga_frame out;
>> +     struct v4l2_ctrl_handler ctrl_handler;
>> +
>> +     /* Control values */
>> +     u32 op;
>> +     u32 hflip;
>> +     u32 vflip;
>> +     u32 rotate;
>> +     u32 fill_color;
>> +};
>> +
>> +struct rockchip_rga {
>> +     struct v4l2_device v4l2_dev;
>> +     struct v4l2_m2m_dev *m2m_dev;
>> +     struct video_device *vfd;
>> +
>> +     struct device *dev;
>> +     struct regmap *grf;
>> +     void __iomem *regs;
>> +     struct clk *sclk;
>> +     struct clk *aclk;
>> +     struct clk *hclk;
>> +     struct rockchip_rga_version version;
>> +
>> +     struct mutex mutex;
>> +     spinlock_t ctrl_lock;
>> +
>> +     wait_queue_head_t irq_queue;
>> +
>> +     struct rga_ctx *curr;
>> +     dma_addr_t cmdbuf_phy;
>> +     void *cmdbuf_virt;
>> +     unsigned int *src_mmu_pages;
>> +     unsigned int *dst_mmu_pages;
>> +};
>> +
>> +struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum v4l2_buf_type type);
>> +
>> +/* RGA Buffers Manage Part */
>> +extern const struct vb2_ops rga_qops;
>> +void rga_buf_map(struct vb2_buffer *vb);
>> +
>> +/* RGA Hardware Part */
>> +void rga_write(struct rockchip_rga *rga, u32 reg, u32 value);
>> +u32 rga_read(struct rockchip_rga *rga, u32 reg);
>> +void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32 mask);
>> +void rga_start(struct rockchip_rga *rga);
>> +
>> +void rga_cmd_set(struct rga_ctx *ctx);
>> +
>> +#endif
>>
>
> Did you test this with v4l2-compliance? What is the output?
>

I fixed some fails in V5 Patches, except "fmt_cap.g_colorspace() != col"
It seems v4l2-compliance assume capture and output should use the same
colorspace.

In RGA, yuv -> yuv convert pipeline are yuv -> rgb -> yuv, so it could
use different colorspace
in capture(rgb->yuv) and output(yuv->rgb).


> Regards,
>
>         Hans
