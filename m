Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34904 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbcAZNxC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 08:53:02 -0500
MIME-Version: 1.0
In-Reply-To: <1453799046-307-3-git-send-email-jung.zhao@rock-chips.com>
References: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
	<1453799046-307-3-git-send-email-jung.zhao@rock-chips.com>
Date: Tue, 26 Jan 2016 14:53:01 +0100
Message-ID: <CAFqH_51cpqc737qeefDfseyVCGp4JRFnVcz8VrCsp6LYqAq2HQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] media: VPU: support Rockchip VPU
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Jung Zhao <jung.zhao@rock-chips.com>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org, herman.chen@rock-chips.com,
	alpha.lin@rock-chips.com, linux-kernel@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jung,

I'm interested in this patch series and I'll try to test on my RK3288 board.

Please, see my comments below to improve some things that helped me to
upstream some other patches, based on feedback from others
maintainers. Also I tend to use checkpatch with --strict option, it's
not a must but helps.

2016-01-26 10:04 GMT+01:00 Jung Zhao <jung.zhao@rock-chips.com>:
> From: zhaojun <jung.zhao@rock-chips.com>
>
> The VPU driver for rk3229 & rk3288 platform.
> Now only support VP8 decoder.
>

The VP8 decoder support is introduced in patch 3, right ? So here the
message is inaccurate. It's preferred have a good explanation when you
introduce a new driver so will be good if you extend a bit more the
patch description, for example.

Add rockchip-vpu driver

The VPU driver for hw video codec in Rockchip's RK3229 and RK3288
SOCs, is able to handle video decoding/encoding of in a range of
formats ... blablabla

> Signed-off-by: zhaojun <jung.zhao@rock-chips.com>

If I'm not wrong this patch and the others are based on some patches
from the chromium tree, in such case, will be good, when possible to
maintain the signed-off chain

> ---
>
>  drivers/media/platform/rockchip-vpu/Makefile       |   6 +
>  drivers/media/platform/rockchip-vpu/rockchip_vpu.c | 799 +++++++++++++++++
>  .../platform/rockchip-vpu/rockchip_vpu_common.h    | 439 +++++++++
>  .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 994 +++++++++++++++++++++
>  .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |  33 +
>  .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  | 278 ++++++
>  .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  78 ++
>  7 files changed, 2627 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip-vpu/Makefile

Did you miss to add the Kconfig file here ?

>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu.c
>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
>  create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
>
> diff --git a/drivers/media/platform/rockchip-vpu/Makefile b/drivers/media/platform/rockchip-vpu/Makefile
> new file mode 100644
> index 0000000..5aab094
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/Makefile
> @@ -0,0 +1,6 @@
> +
> +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
> +
> +rockchip-vpu-y += rockchip_vpu.o \
> +               rockchip_vpu_dec.o \
> +               rockchip_vpu_hw.o
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu.c
> new file mode 100644
> index 0000000..e7e7cb5
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu.c
> @@ -0,0 +1,799 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *

We're in 2016, so I think you should update the copyright notice. The
same for all the new files you create

> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "rockchip_vpu_common.h"
> +
> +#include <linux/fs.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-event.h>
> +#include <linux/workqueue.h>
> +#include <linux/of.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "rockchip_vpu_dec.h"
> +#include "rockchip_vpu_hw.h"
> +

Alphabetical order is preferred, the same for other files.

> +int debug;
> +module_param(debug, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(debug,
> +                "Debug level - higher value produces more verbose messages");
> +
> +#define DUMP_FILE "/tmp/vpu.out"
> +
> +int rockchip_vpu_write(const char *file, void *buf, size_t size)
> +{
> +       const char __user *p = (__force const char __user *)buf;
> +       struct file *filp = filp_open(file ? file : DUMP_FILE,
> +                       O_CREAT | O_RDWR | O_APPEND, 0644);

For me is more clear define only the variable here and do the open
before check the error

            struct file *filp;

> +       mm_segment_t fs;
> +       int ret;
> +

            flip = filp_open(file ? file : DUMP_FILE, O_CREAT | O_RDWR
| O_APPEND, 0644);
> +       if (IS_ERR(filp)) {
> +               printk(KERN_ERR "open(%s) failed\n", file ? file : DUMP_FILE);
> +               return -ENODEV;
> +       }
> +
> +       fs = get_fs();
> +       set_fs(KERNEL_DS);
> +
> +       filp->f_pos = 0;
> +       ret = filp->f_op->write(filp, p, size, &filp->f_pos);
> +
> +       filp_close(filp, NULL);
> +       set_fs(fs);
> +
> +       return ret;
> +}

BTW, is this function used ? If not remove it.

> +
> +/*
> + * DMA coherent helpers.
> + */
> +
> +int rockchip_vpu_aux_buf_alloc(struct rockchip_vpu_dev *vpu,
> +                              struct rockchip_vpu_aux_buf *buf, size_t size)
> +{
> +       buf->cpu = dma_alloc_coherent(vpu->dev, size, &buf->dma, GFP_KERNEL);
> +       if (!buf->cpu)
> +               return -ENOMEM;
> +
> +       buf->size = size;
> +       return 0;
> +}
> +
> +void rockchip_vpu_aux_buf_free(struct rockchip_vpu_dev *vpu,
> +                              struct rockchip_vpu_aux_buf *buf)
> +{
> +       dma_free_coherent(vpu->dev, buf->size, buf->cpu, buf->dma);
> +
> +       buf->cpu = NULL;
> +       buf->dma = 0;
> +       buf->size = 0;
> +}
> +
> +/*
> + * Context scheduling.
> + */
> +
> +static void rockchip_vpu_prepare_run(struct rockchip_vpu_ctx *ctx)
> +{
> +       if (ctx->run_ops->prepare_run)
> +               ctx->run_ops->prepare_run(ctx);
> +}
> +
> +static void __rockchip_vpu_dequeue_run_locked(struct rockchip_vpu_ctx *ctx)
> +{
> +       struct rockchip_vpu_buf *src, *dst;
> +
> +       /*
> +        * Since ctx was dequeued from ready_ctxs list, we know that it has
> +        * at least one buffer in each queue.
> +        */
> +       src = list_first_entry(&ctx->src_queue, struct rockchip_vpu_buf, list);
> +       dst = list_first_entry(&ctx->dst_queue, struct rockchip_vpu_buf, list);
> +
> +       list_del(&src->list);
> +       list_del(&dst->list);
> +
> +       ctx->run.src = src;
> +       ctx->run.dst = dst;
> +}
> +
> +static void rockchip_vpu_try_run(struct rockchip_vpu_dev *dev)
> +{
> +       struct rockchip_vpu_ctx *ctx = NULL;
> +       unsigned long flags;
> +
> +       vpu_debug_enter();
> +

This is only to trace the function call, you can use ftrace for that
purpose so you can remove this and the others.

> +       spin_lock_irqsave(&dev->irqlock, flags);
> +
> +       if (list_empty(&dev->ready_ctxs) ||
> +           test_bit(VPU_SUSPENDED, &dev->state))
> +               /* Nothing to do. */
> +               goto out;
> +
> +       if (test_and_set_bit(VPU_RUNNING, &dev->state))
> +               /*
> +               * The hardware is already running. We will pick another
> +               * run after we get the notification in rockchip_vpu_run_done().
> +               */
> +               goto out;
> +
> +       ctx = list_entry(dev->ready_ctxs.next, struct rockchip_vpu_ctx, list);
> +
> +       list_del_init(&ctx->list);
> +       __rockchip_vpu_dequeue_run_locked(ctx);
> +
> +       dev->current_ctx = ctx;
> +
> +out:
> +       spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +       if (ctx) {
> +               rockchip_vpu_prepare_run(ctx);
> +               rockchip_vpu_run(ctx);
> +       }
> +
> +       vpu_debug_leave();

I think you can remove all these call too.

> +}
> +
> +static void __rockchip_vpu_try_context_locked(struct rockchip_vpu_dev *dev,
> +                                             struct rockchip_vpu_ctx *ctx)
> +{
> +       if (!list_empty(&ctx->list))
> +               /* Context already queued. */
> +               return;
> +
> +       if (!list_empty(&ctx->dst_queue) && !list_empty(&ctx->src_queue))
> +               list_add_tail(&ctx->list, &dev->ready_ctxs);
> +}
> +
> +void rockchip_vpu_run_done(struct rockchip_vpu_ctx *ctx,
> +                          enum vb2_buffer_state result)
> +{
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       unsigned long flags;
> +
> +       vpu_debug_enter();
> +
> +       if (ctx->run_ops->run_done)
> +               ctx->run_ops->run_done(ctx, result);
> +
> +       struct vb2_buffer *src = &ctx->run.src->b.vb2_buf;
> +       struct vb2_buffer *dst = &ctx->run.dst->b.vb2_buf;
> +
> +       to_vb2_v4l2_buffer(dst)->timestamp =
> +               to_vb2_v4l2_buffer(src)->timestamp;
> +       vb2_buffer_done(&ctx->run.src->b.vb2_buf, result);
> +       vb2_buffer_done(&ctx->run.dst->b.vb2_buf, result);
> +
> +       dev->current_ctx = NULL;
> +       wake_up_all(&dev->run_wq);
> +
> +       spin_lock_irqsave(&dev->irqlock, flags);
> +
> +       __rockchip_vpu_try_context_locked(dev, ctx);
> +       clear_bit(VPU_RUNNING, &dev->state);
> +
> +       spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +       /* Try scheduling another run to see if we have anything left to do. */
> +       rockchip_vpu_try_run(dev);
> +
> +       vpu_debug_leave();
> +}
> +
> +void rockchip_vpu_try_context(struct rockchip_vpu_dev *dev,
> +                             struct rockchip_vpu_ctx *ctx)
> +{
> +       unsigned long flags;
> +
> +       vpu_debug_enter();
> +
> +       spin_lock_irqsave(&dev->irqlock, flags);
> +
> +       __rockchip_vpu_try_context_locked(dev, ctx);
> +
> +       spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +       rockchip_vpu_try_run(dev);
> +
> +       vpu_debug_enter();
> +}
> +
> +/*
> + * Control registration.
> + */
> +
> +#define IS_VPU_PRIV(x) ((V4L2_CTRL_ID2WHICH(x) == V4L2_CTRL_CLASS_MPEG) && \
> +                         V4L2_CTRL_DRIVER_PRIV(x))
> +
> +int rockchip_vpu_ctrls_setup(struct rockchip_vpu_ctx *ctx,
> +                            const struct v4l2_ctrl_ops *ctrl_ops,
> +                            struct rockchip_vpu_control *controls,
> +                            unsigned num_ctrls,
> +                            const char* const* (*get_menu)(u32))
> +{
> +       struct v4l2_ctrl_config cfg;
> +       int i;
> +
> +       if (num_ctrls > ARRAY_SIZE(ctx->ctrls)) {
> +               vpu_err("context control array not large enough\n");
> +               return -ENOSPC;
> +       }
> +
> +       v4l2_ctrl_handler_init(&ctx->ctrl_handler, num_ctrls);
> +       if (ctx->ctrl_handler.error) {
> +               vpu_err("v4l2_ctrl_handler_init failed\n");
> +               return ctx->ctrl_handler.error;
> +       }
> +
> +       for (i = 0; i < num_ctrls; i++) {
> +               if (IS_VPU_PRIV(controls[i].id)
> +                   || controls[i].id >= V4L2_CID_CUSTOM_BASE
> +                   || controls[i].type == V4L2_CTRL_TYPE_PRIVATE) {
> +                       memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
> +
> +                       cfg.ops = ctrl_ops;
> +                       cfg.id = controls[i].id;
> +                       cfg.min = controls[i].minimum;
> +                       cfg.max = controls[i].maximum;
> +                       cfg.max_reqs = controls[i].max_reqs;
> +                       cfg.def = controls[i].default_value;
> +                       cfg.name = controls[i].name;
> +                       cfg.type = controls[i].type;
> +                       cfg.elem_size = controls[i].elem_size;
> +                       memcpy(cfg.dims, controls[i].dims, sizeof(cfg.dims));
> +
> +                       if (cfg.type == V4L2_CTRL_TYPE_MENU) {
> +                               cfg.menu_skip_mask = cfg.menu_skip_mask;
> +                               cfg.qmenu = get_menu(cfg.id);
> +                       } else {
> +                               cfg.step = controls[i].step;
> +                       }
> +
> +                       ctx->ctrls[i] = v4l2_ctrl_new_custom(
> +                                                            &ctx->ctrl_handler,
> +                                                            &cfg, NULL);
> +               } else {
> +                       if (controls[i].type == V4L2_CTRL_TYPE_MENU) {
> +                               ctx->ctrls[i] =
> +                                       v4l2_ctrl_new_std_menu
> +                                       (&ctx->ctrl_handler,
> +                                        ctrl_ops,
> +                                        controls[i].id,
> +                                        controls[i].maximum,
> +                                        0,
> +                                        controls[i].
> +                                        default_value);
> +                       } else {
> +                               ctx->ctrls[i] =
> +                                       v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +                                                         ctrl_ops,
> +                                                         controls[i].id,
> +                                                         controls[i].minimum,
> +                                                         controls[i].maximum,
> +                                                         controls[i].step,
> +                                                         controls[i].
> +                                                         default_value);
> +                       }
> +               }
> +
> +               if (ctx->ctrl_handler.error) {
> +                       vpu_err("Adding control (%d) failed\n", i);
> +                       return ctx->ctrl_handler.error;
> +               }
> +
> +               if (controls[i].is_volatile && ctx->ctrls[i])
> +                       ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +               if (controls[i].is_read_only && ctx->ctrls[i])
> +                       ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +               if (controls[i].can_store && ctx->ctrls[i])
> +                       ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
> +       }
> +
> +       v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> +       ctx->num_ctrls = num_ctrls;
> +       return 0;
> +}
> +
> +void rockchip_vpu_ctrls_delete(struct rockchip_vpu_ctx *ctx)
> +{
> +       int i;
> +
> +       v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +       for (i = 0; i < ctx->num_ctrls; i++)
> +               ctx->ctrls[i] = NULL;
> +}
> +
> +/*
> + * V4L2 file operations.
> + */
> +
> +static int rockchip_vpu_open(struct file *filp)
> +{
> +       struct video_device *vdev = video_devdata(filp);
> +       struct rockchip_vpu_dev *dev = video_drvdata(filp);
> +       struct rockchip_vpu_ctx *ctx = NULL;
> +       struct vb2_queue *q;
> +       int ret = 0;
> +
> +       /*
> +        * We do not need any extra locking here, because we operate only
> +        * on local data here, except reading few fields from dev, which
> +        * do not change through device's lifetime (which is guaranteed by
> +        * reference on module from open()) and V4L2 internal objects (such
> +        * as vdev and ctx->fh), which have proper locking done in respective
> +        * helper functions used here.
> +        */
> +
> +       vpu_debug_enter();
> +
> +       /* Allocate memory for context */
> +       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +       if (!ctx) {
> +               ret = -ENOMEM;
> +               goto err_leave;
> +       }
> +
> +       v4l2_fh_init(&ctx->fh, video_devdata(filp));
> +       filp->private_data = &ctx->fh;
> +       v4l2_fh_add(&ctx->fh);
> +       ctx->dev = dev;
> +       INIT_LIST_HEAD(&ctx->src_queue);
> +       INIT_LIST_HEAD(&ctx->dst_queue);
> +       INIT_LIST_HEAD(&ctx->list);
> +
> +       if (vdev == dev->vfd_dec) {
> +               /* only for decoder */
> +               ret = rockchip_vpu_dec_init(ctx);
> +               if (ret) {
> +                       vpu_err("Failed to initialize decoder context\n");
> +                       goto err_fh_free;
> +               }
> +       } else {
> +               ret = -ENOENT;
> +               goto err_fh_free;
> +       }
> +       ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> +
> +       /* Init videobuf2 queue for CAPTURE */
> +       q = &ctx->vq_dst;
> +       q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +       q->drv_priv = &ctx->fh;
> +       q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +       q->lock = &dev->vpu_mutex;
> +       q->buf_struct_size = sizeof(struct rockchip_vpu_buf);
> +
> +       if (vdev == dev->vfd_dec)
> +               q->ops = get_dec_queue_ops();
> +
> +       q->mem_ops = &vb2_dma_contig_memops;
> +       q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +       q->v4l2_allow_requests = true;
> +       ret = vb2_queue_init(q);
> +       if (ret) {
> +               vpu_err("Failed to initialize videobuf2 queue(capture)\n");
> +               goto err_dec_exit;
> +       }
> +
> +       /* Init videobuf2 queue for OUTPUT */
> +       q = &ctx->vq_src;
> +       q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +       q->drv_priv = &ctx->fh;
> +       q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +       q->lock = &dev->vpu_mutex;
> +       q->buf_struct_size = sizeof(struct rockchip_vpu_buf);
> +
> +       if (vdev == dev->vfd_dec)
> +               q->ops = get_dec_queue_ops();
> +
> +       q->mem_ops = &vb2_dma_contig_memops;
> +       q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +       q->v4l2_allow_requests = true;
> +       ret = vb2_queue_init(q);
> +       if (ret) {
> +               vpu_err("Failed to initialize videobuf2 queue(output)\n");
> +               goto err_vq_dst_release;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +
> +err_vq_dst_release:
> +       vb2_queue_release(&ctx->vq_dst);
> +err_dec_exit:
> +       if (vdev == dev->vfd_dec)
> +               rockchip_vpu_dec_exit(ctx);
> +err_fh_free:
> +       v4l2_fh_del(&ctx->fh);
> +       v4l2_fh_exit(&ctx->fh);
> +       kfree(ctx);
> +err_leave:
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int rockchip_vpu_release(struct file *filp)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
> +       struct video_device *vdev = video_devdata(filp);
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +
> +       /*
> +        * No need for extra locking because this was the last reference
> +        * to this file.
> +        */
> +
> +       vpu_debug_enter();
> +
> +       /*
> +        * vb2_queue_release() ensures that streaming is stopped, which
> +        * in turn means that there are no frames still being processed
> +        * by hardware.
> +        */
> +       vb2_queue_release(&ctx->vq_src);
> +       vb2_queue_release(&ctx->vq_dst);
> +
> +       v4l2_fh_del(&ctx->fh);
> +       v4l2_fh_exit(&ctx->fh);
> +
> +       if (vdev == dev->vfd_dec)
> +               rockchip_vpu_dec_exit(ctx);
> +
> +       kfree(ctx);
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static unsigned int rockchip_vpu_poll(struct file *filp,
> +                                     struct poll_table_struct *wait)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
> +       struct vb2_queue *src_q, *dst_q;
> +       struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
> +       unsigned int rc = 0;
> +       unsigned long flags;
> +
> +       vpu_debug_enter();
> +
> +       src_q = &ctx->vq_src;
> +       dst_q = &ctx->vq_dst;
> +
> +       /*
> +        * There has to be at least one buffer queued on each queued_list, which
> +        * means either in driver already or waiting for driver to claim it
> +        * and start processing.
> +        */
> +       if ((!vb2_is_streaming(src_q) || list_empty(&src_q->queued_list)) &&
> +           (!vb2_is_streaming(dst_q) || list_empty(&dst_q->queued_list))) {
> +               vpu_debug(0, "src q streaming %d, dst q streaming %d, src list empty(%d), dst list empty(%d)\n",
> +                         src_q->streaming, dst_q->streaming,
> +                         list_empty(&src_q->queued_list),
> +                         list_empty(&dst_q->queued_list));
> +               return POLLERR;
> +       }
> +
> +       poll_wait(filp, &ctx->fh.wait, wait);
> +       poll_wait(filp, &src_q->done_wq, wait);
> +       poll_wait(filp, &dst_q->done_wq, wait);
> +
> +       if (v4l2_event_pending(&ctx->fh))
> +               rc |= POLLPRI;
> +
> +       spin_lock_irqsave(&src_q->done_lock, flags);
> +
> +       if (!list_empty(&src_q->done_list))
> +               src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
> +                                         done_entry);
> +
> +       if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE ||
> +                      src_vb->state == VB2_BUF_STATE_ERROR))
> +               rc |= POLLOUT | POLLWRNORM;
> +
> +       spin_unlock_irqrestore(&src_q->done_lock, flags);
> +
> +       spin_lock_irqsave(&dst_q->done_lock, flags);
> +
> +       if (!list_empty(&dst_q->done_list))
> +               dst_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
> +                                         done_entry);
> +
> +       if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE ||
> +                      dst_vb->state == VB2_BUF_STATE_ERROR))
> +               rc |= POLLIN | POLLRDNORM;
> +
> +       spin_unlock_irqrestore(&dst_q->done_lock, flags);
> +
> +       return rc;
> +}
> +
> +static int rockchip_vpu_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
> +       unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       if (offset < DST_QUEUE_OFF_BASE) {
> +               vpu_debug(4, "mmaping source\n");
> +
> +               ret = vb2_mmap(&ctx->vq_src, vma);
> +       } else {        /* capture */
> +               vpu_debug(4, "mmaping destination\n");
> +
> +               vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
> +               ret = vb2_mmap(&ctx->vq_dst, vma);
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static const struct v4l2_file_operations rockchip_vpu_fops = {
> +       .owner = THIS_MODULE,
> +       .open = rockchip_vpu_open,
> +       .release = rockchip_vpu_release,
> +       .poll = rockchip_vpu_poll,
> +       .unlocked_ioctl = video_ioctl2,
> +       .mmap = rockchip_vpu_mmap,
> +};
> +
> +/*
> + * Platform driver.
> + */
> +
> +static void *rockchip_get_drv_data(struct platform_device *pdev);
> +
> +static int rockchip_vpu_probe(struct platform_device *pdev)
> +{
> +       struct rockchip_vpu_dev *vpu = NULL;
> +       DEFINE_DMA_ATTRS(attrs_novm);
> +       struct video_device *vfd;
> +       int ret = 0;
> +
> +       vpu_debug_enter();
> +
> +       vpu = devm_kzalloc(&pdev->dev, sizeof(*vpu), GFP_KERNEL);
> +       if (!vpu)
> +               return -ENOMEM;
> +
> +       vpu->dev = &pdev->dev;
> +       vpu->pdev = pdev;
> +       mutex_init(&vpu->vpu_mutex);
> +       spin_lock_init(&vpu->irqlock);
> +       INIT_LIST_HEAD(&vpu->ready_ctxs);
> +       init_waitqueue_head(&vpu->run_wq);
> +
> +       vpu->variant = rockchip_get_drv_data(pdev);
> +
> +       ret = rockchip_vpu_hw_probe(vpu);
> +       if (ret) {
> +               dev_err(&pdev->dev, "rockchip_vpu_hw_probe failed\n");
> +               goto err_hw_probe;
> +       }
> +
> +       dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs_novm);
> +       vpu->alloc_ctx = vb2_dma_contig_init_ctx_attrs(&pdev->dev,
> +                                                      &attrs_novm);
> +       if (IS_ERR(vpu->alloc_ctx)) {
> +               ret = PTR_ERR(vpu->alloc_ctx);
> +               goto err_dma_contig;
> +       }
> +
> +       vpu->alloc_ctx_vm = vb2_dma_contig_init_ctx(&pdev->dev);
> +       if (IS_ERR(vpu->alloc_ctx_vm)) {
> +               ret = PTR_ERR(vpu->alloc_ctx_vm);
> +               goto err_dma_contig_vm;
> +       }
> +
> +       ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +               goto err_v4l2_dev_reg;
> +       }
> +
> +       platform_set_drvdata(pdev, vpu);
> +
> +       /* decoder */
> +       vfd = video_device_alloc();
> +       if (!vfd) {
> +               v4l2_err(&vpu->v4l2_dev, "Failed to allocate video device\n");
> +               ret = -ENOMEM;
> +               goto err_v4l2_dev_reg;
> +       }
> +
> +       vfd->fops = &rockchip_vpu_fops;
> +       vfd->ioctl_ops = get_dec_v4l2_ioctl_ops();
> +       vfd->release = video_device_release;
> +       vfd->lock = &vpu->vpu_mutex;
> +       vfd->v4l2_dev = &vpu->v4l2_dev;
> +       vfd->vfl_dir = VFL_DIR_M2M;
> +       snprintf(vfd->name, sizeof(vfd->name), "%s", ROCKCHIP_VPU_DEC_NAME);
> +       vpu->vfd_dec = vfd;
> +
> +       video_set_drvdata(vfd, vpu);
> +
> +       ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +       if (ret) {
> +               v4l2_err(&vpu->v4l2_dev, "Failed to register video device\n");
> +               video_device_release(vfd);
> +               goto err_dec_reg;
> +       }
> +
> +       v4l2_info(&vpu->v4l2_dev,
> +                 "Rockchip VPU decoder registered as /vpu/video%d\n",
> +                 vfd->num);
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +
> +err_dec_reg:
> +       video_device_release(vpu->vfd_dec);
> +err_v4l2_dev_reg:
> +       vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx_vm);
> +err_dma_contig_vm:
> +       vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx);
> +err_dma_contig:
> +       rockchip_vpu_hw_remove(vpu);
> +err_hw_probe:
> +       pr_debug("%s-- with error\n", __func__);
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int rockchip_vpu_remove(struct platform_device *pdev)
> +{
> +       struct rockchip_vpu_dev *vpu = platform_get_drvdata(pdev);
> +
> +       vpu_debug_enter();
> +
> +       v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
> +
> +       /*
> +        * We are safe here assuming that .remove() got called as
> +        * a result of module removal, which guarantees that all
> +        * contexts have been released.
> +        */
> +
> +       video_unregister_device(vpu->vfd_dec);
> +       v4l2_device_unregister(&vpu->v4l2_dev);
> +       vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx_vm);
> +       vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx);
> +       rockchip_vpu_hw_remove(vpu);
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +/* Supported VPU variants. */
> +static const struct rockchip_vpu_variant rk3288_vpu_variant = {
> +       .vpu_type = RK3288_VPU,
> +       .name = "Rk3288 vpu",
> +       .dec_offset = 0x400,
> +       .dec_reg_num = 60 + 41,
> +};
> +
> +static const struct rockchip_vpu_variant rk3229_vpu_variant = {
> +       .vpu_type = RK3229_VPU,
> +       .name = "Rk3229 vpu",
> +       .dec_offset = 0x400,
> +       .dec_reg_num = 159,
> +};
> +
> +static struct platform_device_id vpu_driver_ids[] = {
> +       {
> +               .name = "rk3288-vpu",
> +               .driver_data = (unsigned long)&rk3288_vpu_variant,
> +       }, {
> +               .name = "rk3229-vpu",
> +               .driver_data = (unsigned long)&rk3229_vpu_variant,
> +       },
> +       { /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(platform, vpu_driver_ids);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_rockchip_vpu_match[] = {
> +       { .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> +       { .compatible = "rockchip,rk3229-vpu", .data = &rk3229_vpu_variant, },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, of_rockchip_vpu_match);
> +#endif
> +
> +static void *rockchip_get_drv_data(struct platform_device *pdev)
> +{
> +       void *driver_data = NULL;
> +
> +       if (pdev->dev.of_node) {
> +               const struct of_device_id *match;
> +
> +               match = of_match_node(of_rockchip_vpu_match,
> +                                     pdev->dev.of_node);
> +               if (match)
> +                       driver_data = (void *)match->data;
> +       } else {
> +               driver_data = (void *)platform_get_device_id(pdev)->driver_data;
> +       }
> +       return driver_data;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_vpu_suspend(struct device *dev)
> +{
> +       struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> +
> +       set_bit(VPU_SUSPENDED, &vpu->state);
> +       wait_event(vpu->run_wq, vpu->current_ctx == NULL);
> +
> +       return 0;
> +}
> +
> +static int rockchip_vpu_resume(struct device *dev)
> +{
> +       struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> +
> +       clear_bit(VPU_SUSPENDED, &vpu->state);
> +       rockchip_vpu_try_run(vpu);
> +
> +       return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops rockchip_vpu_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(rockchip_vpu_suspend, rockchip_vpu_resume)
> +};
> +
> +static struct platform_driver rockchip_vpu_driver = {
> +       .probe = rockchip_vpu_probe,
> +       .remove = rockchip_vpu_remove,
> +       .id_table = vpu_driver_ids,
> +       .driver = {
> +               .name = ROCKCHIP_VPU_NAME,
> +               .owner = THIS_MODULE,
> +#ifdef CONFIG_OF

I think this is  not required, of_match_ptr is already protected when !OF

> +               .of_match_table = of_match_ptr(of_rockchip_vpu_match),
> +#endif
> +               .pm = &rockchip_vpu_pm_ops,
> +       },
> +};
> +module_platform_driver(rockchip_vpu_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Jung Zhao <jung.zhao@rock-chips.com>");
> +MODULE_AUTHOR("Alpha Lin <Alpha.Lin@Rock-Chips.com>");
> +MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
> +MODULE_DESCRIPTION("Rockchip VPU codec driver");
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
> new file mode 100644
> index 0000000..0d77304
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
> @@ -0,0 +1,439 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ROCKCHIP_VPU_COMMON_H_
> +#define ROCKCHIP_VPU_COMMON_H_
> +
> +/* Enable debugging by default for now. */
> +#define DEBUG
> +
> +#include <linux/platform_device.h>
> +#include <linux/videodev2.h>
> +#include <linux/wait.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "rockchip_vpu_hw.h"
> +
> +#define ROCKCHIP_VPU_NAME              "rockchip-vpu"
> +#define ROCKCHIP_VPU_DEC_NAME          "rockchip-vpu-dec"
> +
> +#define V4L2_CID_CUSTOM_BASE           (V4L2_CID_USER_BASE | 0x1000)
> +
> +#define DST_QUEUE_OFF_BASE             (TASK_SIZE / 2)
> +
> +#define ROCKCHIP_VPU_MAX_CTRLS         32
> +
> +#define MB_DIM                         16
> +#define MB_WIDTH(x_size)               DIV_ROUND_UP(x_size, MB_DIM)
> +#define MB_HEIGHT(y_size)              DIV_ROUND_UP(y_size, MB_DIM)
> +
> +struct rockchip_vpu_ctx;
> +struct rockchip_vpu_codec_ops;
> +
> +/**
> + * struct rockchip_vpu_variant - information about VPU hardware variant
> + *
> + * @hw_id:             Top 16 bits (product ID) of hardware ID register.
> + * @vpu_type:          Vpu type.
> + * @name:              Vpu name.
> + * @dec_offset:                Offset from VPU base to decoder registers.
> + * @dec_reg_num:       Number of registers of decoder block.
> + */
> +struct rockchip_vpu_variant {
> +       enum rockchip_vpu_type vpu_type;
> +       char *name;
> +       unsigned dec_offset;
> +       unsigned dec_reg_num;
> +};
> +
> +/**
> + * enum rockchip_vpu_codec_mode - codec operating mode.
> + * @RK_VPU_CODEC_NONE: No operating mode. Used for RAW video formats.
> + * @RK3288_VPU_CODEC_VP8D:     Rk3288 VP8 decoder.
> + * @RK3229_VPU_CODEC_VP8D:     Rk3229 VP8 decoder.
> + */
> +enum rockchip_vpu_codec_mode {
> +       RK_VPU_CODEC_NONE = -1,
> +       RK3288_VPU_CODEC_VP8D,
> +       RK3229_VPU_CODEC_VP8D,
> +};
> +
> +/**
> + * enum rockchip_vpu_plane - indices of planes inside a VB2 buffer.
> + * @PLANE_Y:           Plane containing luminance data (also denoted as Y).
> + * @PLANE_CB_CR:       Plane containing interleaved chrominance data (also
> + *                     denoted as CbCr).
> + * @PLANE_CB:          Plane containing CB part of chrominance data.
> + * @PLANE_CR:          Plane containing CR part of chrominance data.
> + */
> +enum rockchip_vpu_plane {
> +       PLANE_Y         = 0,
> +       PLANE_CB_CR     = 1,
> +       PLANE_CB        = 1,
> +       PLANE_CR        = 2,
> +};
> +
> +/**
> + * struct rockchip_vpu_buf - Private data related to each VB2 buffer.
> + * @vb:                        Pointer to related VB2 buffer.
> + * @list:              List head for queuing in buffer queue.
> + * @flags:             Buffer state. See enum rockchip_vpu_buf_flags.
> + */
> +struct rockchip_vpu_buf {
> +       struct vb2_v4l2_buffer b;
> +       struct list_head list;
> +       /* Mode-specific data. */
> +};
> +
> +/**
> + * enum rockchip_vpu_state - bitwise flags indicating hardware state.
> + * @VPU_RUNNING:       The hardware has been programmed for operation
> + *                     and is running at the moment.
> + * @VPU_SUSPENDED:     System is entering sleep state and no more runs
> + *                     should be executed on hardware.
> + */
> +enum rockchip_vpu_state {
> +       VPU_RUNNING     = BIT(0),
> +       VPU_SUSPENDED   = BIT(1),
> +};
> +
> +/**
> + * struct rockchip_vpu_dev - driver data
> + * @v4l2_dev:          V4L2 device to register video devices for.
> + * @vfd_dec:           Video device for decoder.
> + * @pdev:              Pointer to VPU platform device.
> + * @dev:               Pointer to device for convenient logging using
> + *                     dev_ macros.
> + * @alloc_ctx:         VB2 allocator context
> + *                     (for allocations without kernel mapping).
> + * @alloc_ctx_vm:      VB2 allocator context
> + *                     (for allocations with kernel mapping).
> + * @aclk:              Handle of ACLK clock.
> + * @hclk:              Handle of HCLK clock.
> + * @base:              Mapped address of VPU registers.
> + * @dec_base:          Mapped address of VPU decoder register for convenience.
> + * @mapping:           DMA IOMMU mapping.
> + * @vpu_mutex:         Mutex to synchronize V4L2 calls.
> + * @irqlock:           Spinlock to synchronize access to data structures
> + *                     shared with interrupt handlers.
> + * @state:             Device state.
> + * @ready_ctxs:                List of contexts ready to run.
> + * @variant:           Hardware variant-specific parameters.
> + * @current_ctx:       Context being currently processed by hardware.
> + * @run_wq:            Wait queue to wait for run completion.
> + * @watchdog_work:     Delayed work for hardware timeout handling.
> + */
> +struct rockchip_vpu_dev {
> +       struct v4l2_device v4l2_dev;
> +       struct video_device *vfd_dec;
> +       struct platform_device *pdev;
> +       struct device *dev;
> +       void *alloc_ctx;
> +       void *alloc_ctx_vm;
> +       struct clk *aclk;
> +       struct clk *hclk;
> +       void __iomem *base;
> +       void __iomem *dec_base;
> +       struct dma_iommu_mapping *mapping;
> +
> +       struct mutex vpu_mutex; /* video_device lock */
> +       spinlock_t irqlock;
> +       unsigned long state;
> +       struct list_head ready_ctxs;
> +       const struct rockchip_vpu_variant *variant;
> +       struct rockchip_vpu_ctx *current_ctx;
> +       wait_queue_head_t run_wq;
> +       struct delayed_work watchdog_work;
> +};
> +
> +/**
> + * struct rockchip_vpu_run_ops - per context operations on run data.
> + * @prepare_run:       Called when the context was selected for running
> + *                     to prepare operating mode specific data.
> + * @run_done:          Called when hardware completed the run to collect
> + *                     operating mode specific data from hardware and
> + *                     finalize the processing.
> + */
> +struct rockchip_vpu_run_ops {
> +       void (*prepare_run)(struct rockchip_vpu_ctx *);
> +       void (*run_done)(struct rockchip_vpu_ctx *, enum vb2_buffer_state);
> +};
> +
> +/**
> + * struct rockchip_vpu_vp8d_run - per-run data specific to VP8
> + * decoding.
> + * @frame_hdr: Pointer to a buffer containing per-run frame data which
> + *                     is needed by setting vpu register.
> + */
> +struct rockchip_vpu_vp8d_run {
> +       const struct v4l2_ctrl_vp8_frame_hdr *frame_hdr;
> +};
> +
> +/**
> + * struct rockchip_vpu_run - per-run data for hardware code.
> + * @src:               Source buffer to be processed.
> + * @dst:               Destination buffer to be processed.
> + * @priv_src:          Hardware private source buffer.
> + * @priv_dst:          Hardware private destination buffer.
> + */
> +struct rockchip_vpu_run {
> +       /* Generic for more than one operating mode. */
> +       struct rockchip_vpu_buf *src;
> +       struct rockchip_vpu_buf *dst;
> +
> +       struct rockchip_vpu_aux_buf priv_src;
> +       struct rockchip_vpu_aux_buf priv_dst;
> +
> +       /* Specific for particular operating modes. */
> +       union {
> +               struct rockchip_vpu_vp8d_run vp8d;
> +               /* Other modes will need different data. */
> +       };
> +};
> +
> +/**
> + * struct rockchip_vpu_ctx - Context (instance) private data.
> + *
> + * @dev:               VPU driver data to which the context belongs.
> + * @fh:                        V4L2 file handler.
> + *
> + * @vpu_src_fmt:       Descriptor of active source format.
> + * @src_fmt:           V4L2 pixel format of active source format.
> + * @vpu_dst_fmt:       Descriptor of active destination format.
> + * @dst_fmt:           V4L2 pixel format of active destination format.
> + *
> + * @vq_src:            Videobuf2 source queue.
> + * @src_queue:         Internal source buffer queue.
> + * @src_crop:          Configured source crop rectangle (encoder-only).
> + * @vq_dst:            Videobuf2 destination queue
> + * @dst_queue:         Internal destination buffer queue.
> + * @dst_bufs:          Private buffers wrapping VB2 buffers (destination).
> + *
> + * @ctrls:             Array containing pointer to registered controls.
> + * @ctrl_handler:      Control handler used to register controls.
> + * @num_ctrls:         Number of registered controls.
> + *
> + * @list:              List head for queue of ready contexts.
> + *
> + * @run:               Structure containing data about currently scheduled
> + *                     processing run.
> + * @run_ops:           Set of operations related to currently scheduled run.
> + * @hw:                        Structure containing hardware-related context.
> + */
> +struct rockchip_vpu_ctx {
> +       struct rockchip_vpu_dev *dev;
> +       struct v4l2_fh fh;
> +
> +       /* Format info */
> +       struct rockchip_vpu_fmt *vpu_src_fmt;
> +       struct v4l2_pix_format_mplane src_fmt;
> +       struct rockchip_vpu_fmt *vpu_dst_fmt;
> +       struct v4l2_pix_format_mplane dst_fmt;
> +
> +       /* VB2 queue data */
> +       struct vb2_queue vq_src;
> +       struct list_head src_queue;
> +       struct v4l2_rect src_crop;
> +       struct vb2_queue vq_dst;
> +       struct list_head dst_queue;
> +       struct vb2_buffer *dst_bufs[VIDEO_MAX_FRAME];
> +
> +       /* Controls */
> +       struct v4l2_ctrl *ctrls[ROCKCHIP_VPU_MAX_CTRLS];
> +       struct v4l2_ctrl_handler ctrl_handler;
> +       unsigned num_ctrls;
> +
> +       /* Various runtime data */
> +       struct list_head list;
> +
> +       struct rockchip_vpu_run run;
> +       const struct rockchip_vpu_run_ops *run_ops;
> +       struct rockchip_vpu_hw_ctx hw;
> +};
> +
> +/**
> + * struct rockchip_vpu_fmt - information about supported video formats.
> + * @name:      Human readable name of the format.
> + * @fourcc:    FourCC code of the format. See V4L2_PIX_FMT_*.
> + * @vpu_type:  Vpu_type;
> + * @codec_mode:        Codec mode related to this format. See
> + *             enum rockchip_vpu_codec_mode.
> + * @num_planes:        Number of planes used by this format.
> + * @depth:     Depth of each plane in bits per pixel.
> + */
> +struct rockchip_vpu_fmt {
> +       char *name;
> +       u32 fourcc;
> +       enum rockchip_vpu_type vpu_type;
> +       enum rockchip_vpu_codec_mode codec_mode;
> +       int num_planes;
> +       u8 depth[VIDEO_MAX_PLANES];
> +};
> +
> +/**
> + * struct rockchip_vpu_control - information about controls to be registered.
> + * @id:                        Control ID.
> + * @type:              Type of the control.
> + * @name:              Human readable name of the control.
> + * @minimum:           Minimum value of the control.
> + * @maximum:           Maximum value of the control.
> + * @step:              Control value increase step.
> + * @menu_skip_mask:    Mask of invalid menu positions.
> + * @default_value:     Initial value of the control.
> + * @max_reqs:          Maximum number of configration request.
> + * @dims:              Size of each dimension of compound control.
> + * @elem_size:         Size of individual element of compound control.
> + * @is_volatile:       Control is volatile.
> + * @is_read_only:      Control is read-only.
> + * @can_store:         Control uses configuration stores.
> + *
> + * See also struct v4l2_ctrl_config.
> + */
> +struct rockchip_vpu_control {
> +       u32 id;
> +
> +       enum v4l2_ctrl_type type;
> +       const char *name;
> +       s32 minimum;
> +       s32 maximum;
> +       s32 step;
> +       u32 menu_skip_mask;
> +       s32 default_value;
> +       s32 max_reqs;
> +       u32 dims[V4L2_CTRL_MAX_DIMS];
> +       u32 elem_size;
> +
> +       bool is_volatile:1;
> +       bool is_read_only:1;
> +       bool can_store:1;
> +};
> +
> +/* Logging helpers */
> +
> +/**
> + * debug - Module parameter to control level of debugging messages.
> + *
> + * Level of debugging messages can be controlled by bits of module parameter
> + * called "debug". Meaning of particular bits is as follows:
> + *
> + * bit 0 - global information: mode, size, init, release
> + * bit 1 - each run start/result information
> + * bit 2 - contents of small controls from userspace
> + * bit 3 - contents of big controls from userspace
> + * bit 4 - detail fmt, ctrl, buffer q/dq information
> + * bit 5 - detail function enter/leave trace information
> + * bit 6 - register write/read information
> + */
> +extern int debug;
> +
> +#define vpu_debug(level, fmt, args...)                         \
> +       do {                                                    \
> +               if (debug & BIT(level))                         \
> +                       pr_err("%s:%d: " fmt,                   \
> +                              __func__, __LINE__, ##args);     \
> +       } while (0)
> +
> +#define vpu_debug_enter()      vpu_debug(5, "enter\n")
> +#define vpu_debug_leave()      vpu_debug(5, "leave\n")
> +

Remove these

> +#define vpu_err(fmt, args...)                                  \
> +       pr_err("%s:%d: " fmt, __func__, __LINE__, ##args)
> +
> +static inline char *fmt2str(u32 fmt, char *str)
> +{
> +       char a = fmt & 0xFF;
> +       char b = (fmt >> 8) & 0xFF;
> +       char c = (fmt >> 16) & 0xFF;
> +       char d = (fmt >> 24) & 0xFF;
> +
> +       sprintf(str, "%c%c%c%c", a, b, c, d);
> +
> +       return str;
> +}
> +
> +/* Structure access helpers. */
> +static inline struct rockchip_vpu_ctx *fh_to_ctx(struct v4l2_fh *fh)
> +{
> +       return container_of(fh, struct rockchip_vpu_ctx, fh);
> +}
> +
> +static inline struct rockchip_vpu_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
> +{
> +       return container_of(ctrl->handler,
> +                           struct rockchip_vpu_ctx, ctrl_handler);
> +}
> +
> +static inline struct rockchip_vpu_buf *vb_to_buf(struct vb2_buffer *vb)
> +{
> +       return container_of(to_vb2_v4l2_buffer(vb), struct rockchip_vpu_buf, b);
> +}
> +
> +static inline bool rockchip_vpu_ctx_is_encoder(struct rockchip_vpu_ctx *ctx)
> +{
> +       return ctx->vpu_dst_fmt->codec_mode != RK_VPU_CODEC_NONE;
> +}
> +
> +int rockchip_vpu_ctrls_setup(struct rockchip_vpu_ctx *ctx,
> +                            const struct v4l2_ctrl_ops *ctrl_ops,
> +                            struct rockchip_vpu_control *controls,
> +                            unsigned num_ctrls,
> +                            const char* const* (*get_menu)(u32));
> +void rockchip_vpu_ctrls_delete(struct rockchip_vpu_ctx *ctx);
> +
> +void rockchip_vpu_try_context(struct rockchip_vpu_dev *dev,
> +                             struct rockchip_vpu_ctx *ctx);
> +
> +void rockchip_vpu_run_done(struct rockchip_vpu_ctx *ctx,
> +                          enum vb2_buffer_state result);
> +
> +int rockchip_vpu_aux_buf_alloc(struct rockchip_vpu_dev *vpu,
> +                              struct rockchip_vpu_aux_buf *buf, size_t size);
> +void rockchip_vpu_aux_buf_free(struct rockchip_vpu_dev *vpu,
> +                              struct rockchip_vpu_aux_buf *buf);
> +
> +static inline void vdpu_write_relaxed(struct rockchip_vpu_dev *vpu,
> +                                     u32 val, u32 reg)
> +{
> +       vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
> +       writel_relaxed(val, vpu->dec_base + reg);
> +}
> +
> +static inline void vdpu_write(struct rockchip_vpu_dev *vpu, u32 val, u32 reg)
> +{
> +       vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
> +       writel(val, vpu->dec_base + reg);
> +}
> +
> +static inline u32 vdpu_read(struct rockchip_vpu_dev *vpu, u32 reg)
> +{
> +       u32 val = readl(vpu->dec_base + reg);
> +
> +       vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
> +       return val;
> +}
> +
> +int rockchip_vpu_write(const char *file, void *buf, size_t size);
> +
> +#endif /* ROCKCHIP_VPU_COMMON_H_ */
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
> new file mode 100644
> index 0000000..33e9a89
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
> @@ -0,0 +1,994 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Rockchip Electronics Co., Ltd.
> + *     Hertz Wong <hertz.wong@rock-chips.com>
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + *
> + * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "rockchip_vpu_common.h"
> +
> +#include <linux/module.h>
> +#include <linux/version.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "rockchip_vpu_dec.h"
> +#include "rockchip_vpu_hw.h"
> +
> +#define DEF_SRC_FMT_DEC                                V4L2_PIX_FMT_H264_SLICE
> +#define DEF_DST_FMT_DEC                                V4L2_PIX_FMT_NV12
> +
> +#define ROCKCHIP_DEC_MIN_WIDTH                 48U
> +#define ROCKCHIP_DEC_MAX_WIDTH                 3840U
> +#define ROCKCHIP_DEC_MIN_HEIGHT                        48U
> +#define ROCKCHIP_DEC_MAX_HEIGHT                        2160U
> +
> +static struct rockchip_vpu_fmt formats[] = {
> +       {
> +               .name = "4:2:0 1 plane Y/CbCr",
> +               .fourcc = V4L2_PIX_FMT_NV12,
> +               .vpu_type = RK_VPU_NONE,
> +               .codec_mode = RK_VPU_CODEC_NONE,
> +               .num_planes = 1,
> +               .depth = { 12 },
> +       },
> +       {
> +               .name = "Frames of VP8 Decoded Stream",
> +               .fourcc = V4L2_PIX_FMT_VP8_FRAME,
> +               .vpu_type = RK3288_VPU,
> +               .codec_mode = RK3288_VPU_CODEC_VP8D,
> +               .num_planes = 1,
> +       },
> +       {
> +               .name = "Frames of VP8 Decoded Stream",
> +               .fourcc = V4L2_PIX_FMT_VP8_FRAME,
> +               .vpu_type = RK3229_VPU,
> +               .codec_mode = RK3229_VPU_CODEC_VP8D,
> +               .num_planes = 1,
> +       },
> +};
> +
> +static struct rockchip_vpu_fmt *find_format(u32 fourcc, bool bitstream,
> +                                           struct rockchip_vpu_dev *dev)
> +{
> +       unsigned int i;
> +
> +       vpu_debug_enter();
> +
> +       for (i = 0; i < ARRAY_SIZE(formats); i++) {
> +               if (formats[i].fourcc != fourcc)
> +                       continue;
> +               if (bitstream && formats[i].codec_mode != RK_VPU_CODEC_NONE
> +                   && formats[i].vpu_type == dev->variant->vpu_type)
> +                       return &formats[i];
> +               if (!bitstream && formats[i].codec_mode == RK_VPU_CODEC_NONE)
> +                       return &formats[i];
> +       }
> +
> +       return NULL;
> +}
> +
> +/* Indices of controls that need to be accessed directly. */
> +enum {
> +       ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR,
> +};
> +
> +static struct rockchip_vpu_control controls[0];
> +
> +static inline const void *get_ctrl_ptr(struct rockchip_vpu_ctx *ctx,
> +                                      unsigned id)
> +{
> +       struct v4l2_ctrl *ctrl = ctx->ctrls[id];
> +
> +       return ctrl->p_cur.p;
> +}
> +
> +/* Query capabilities of the device */
> +static int vidioc_querycap(struct file *file, void *priv,
> +                          struct v4l2_capability *cap)
> +{
> +       struct rockchip_vpu_dev *dev = video_drvdata(file);
> +
> +       vpu_debug_enter();
> +
> +       strlcpy(cap->driver, ROCKCHIP_VPU_DEC_NAME, sizeof(cap->driver));
> +       strlcpy(cap->card, dev->pdev->name, sizeof(cap->card));
> +       strlcpy(cap->bus_info, "platform:" ROCKCHIP_VPU_NAME,
> +               sizeof(cap->bus_info));
> +
> +       /*
> +        * This is only a mem-to-mem video device. The capture and output
> +        * device capability flags are left only for backward compatibility
> +        * and are scheduled for removal.
> +        */
> +       cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
> +           V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *prov,
> +                                 struct v4l2_frmsizeenum *fsize)
> +{
> +       struct rockchip_vpu_dev *dev = video_drvdata(file);
> +       struct v4l2_frmsize_stepwise *s = &fsize->stepwise;
> +       struct rockchip_vpu_fmt *fmt;
> +
> +       if (fsize->index != 0) {
> +               vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
> +                               fsize->index);
> +               return -EINVAL;
> +       }
> +
> +       fmt = find_format(fsize->pixel_format, true, dev);
> +       if (!fmt) {
> +               vpu_debug(0, "unsupported bitstream format (%08x)\n",
> +                               fsize->pixel_format);
> +               return -EINVAL;
> +       }
> +
> +       fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +
> +       s->min_width = ROCKCHIP_DEC_MIN_WIDTH;
> +       s->max_width = ROCKCHIP_DEC_MAX_WIDTH;
> +       s->step_width = MB_DIM;
> +       s->min_height = ROCKCHIP_DEC_MIN_HEIGHT;
> +       s->max_height = ROCKCHIP_DEC_MAX_HEIGHT;
> +       s->step_height = MB_DIM;
> +
> +       return 0;
> +}
> +
> +static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool out,
> +                          struct rockchip_vpu_dev *dev)
> +{
> +       struct rockchip_vpu_fmt *fmt;
> +       int i, j = 0;
> +
> +       vpu_debug_enter();
> +
> +       for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> +               if (out && formats[i].codec_mode == RK_VPU_CODEC_NONE)
> +                       continue;
> +               else if (!out && (formats[i].codec_mode != RK_VPU_CODEC_NONE))
> +                       continue;
> +               else if (formats[i].vpu_type != dev->variant->vpu_type &&
> +                        formats[i].vpu_type != RK_VPU_NONE)
> +                       continue;
> +
> +               if (j == f->index) {
> +                       fmt = &formats[i];
> +                       strlcpy(f->description, fmt->name,
> +                               sizeof(f->description));
> +                       f->pixelformat = fmt->fourcc;
> +
> +                       f->flags = 0;
> +                       if (formats[i].codec_mode != RK_VPU_CODEC_NONE)
> +                               f->flags |= V4L2_FMT_FLAG_COMPRESSED;
> +
> +                       vpu_debug_leave();
> +
> +                       return 0;
> +               }
> +
> +               ++j;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
> +                                         struct v4l2_fmtdesc *f)
> +{
> +       struct rockchip_vpu_dev *dev = video_drvdata(file);
> +
> +       return vidioc_enum_fmt(f, false, dev);
> +}
> +
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
> +                                         struct v4l2_fmtdesc *f)
> +{
> +       struct rockchip_vpu_dev *dev = video_drvdata(file);
> +
> +       return vidioc_enum_fmt(f, true, dev);
> +}
> +
> +static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +
> +       vpu_debug_enter();
> +
> +       vpu_debug(4, "f->type = %d\n", f->type);
> +
> +       switch (f->type) {
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               f->fmt.pix_mp = ctx->dst_fmt;
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               f->fmt.pix_mp = ctx->src_fmt;
> +               break;
> +
> +       default:
> +               vpu_err("invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +       struct rockchip_vpu_dev *dev = video_drvdata(file);
> +       struct rockchip_vpu_fmt *fmt;
> +       struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +       char str[5];
> +
> +       vpu_debug_enter();
> +
> +       switch (f->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               vpu_debug(4, "%s\n", fmt2str(f->fmt.pix_mp.pixelformat, str));
> +
> +               fmt = find_format(pix_fmt_mp->pixelformat, true, dev);
> +               if (!fmt) {
> +                       vpu_err("failed to try output format\n");
> +                       return -EINVAL;
> +               }
> +
> +               if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
> +                       vpu_err("sizeimage of output format must be given\n");
> +                       return -EINVAL;
> +               }
> +
> +               pix_fmt_mp->plane_fmt[0].bytesperline = 0;
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               vpu_debug(4, "%s\n", fmt2str(f->fmt.pix_mp.pixelformat, str));
> +
> +               fmt = find_format(pix_fmt_mp->pixelformat, false, dev);
> +               if (!fmt) {
> +                       vpu_err("failed to try capture format\n");
> +                       return -EINVAL;
> +               }
> +
> +               if (fmt->num_planes != pix_fmt_mp->num_planes) {
> +                       vpu_err("plane number mismatches on capture format\n");
> +                       return -EINVAL;
> +               }
> +
> +               /* Limit to hardware min/max. */
> +               pix_fmt_mp->width = clamp(pix_fmt_mp->width,
> +                                         ROCKCHIP_DEC_MIN_WIDTH,
> +                                         ROCKCHIP_DEC_MAX_WIDTH);
> +               pix_fmt_mp->height = clamp(pix_fmt_mp->height,
> +                                          ROCKCHIP_DEC_MIN_HEIGHT,
> +                                          ROCKCHIP_DEC_MAX_HEIGHT);
> +
> +               /* Round up to macroblocks. */
> +               pix_fmt_mp->width = round_up(pix_fmt_mp->width, MB_DIM);
> +               pix_fmt_mp->height = round_up(pix_fmt_mp->height, MB_DIM);
> +               break;
> +
> +       default:
> +               vpu_err("invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +       struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       unsigned int mb_width, mb_height;
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       struct rockchip_vpu_fmt *fmt;
> +       int ret = 0;
> +       int i;
> +
> +       vpu_debug_enter();
> +
> +       switch (f->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               /* Change not allowed if any queue is streaming. */
> +               if (vb2_is_streaming(&ctx->vq_src)
> +                   || vb2_is_streaming(&ctx->vq_dst)) {
> +                       ret = -EBUSY;
> +                       goto out;
> +               }
> +               /*
> +                * Pixel format change is not allowed when the other queue has
> +                * buffers allocated.
> +                */
> +               if (vb2_is_busy(&ctx->vq_dst)
> +                   && pix_fmt_mp->pixelformat != ctx->src_fmt.pixelformat) {
> +                       ret = -EBUSY;
> +                       goto out;
> +               }
> +
> +               ret = vidioc_try_fmt(file, priv, f);
> +               if (ret)
> +                       goto out;
> +
> +               ctx->vpu_src_fmt = find_format(pix_fmt_mp->pixelformat,
> +                                              true, dev);
> +               ctx->src_fmt = *pix_fmt_mp;
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               /*
> +                * Change not allowed if this queue is streaming.
> +                *
> +                * NOTE: We allow changes with source queue streaming
> +                * to support resolution change in decoded stream.
> +                */
> +               if (vb2_is_streaming(&ctx->vq_dst)) {
> +                       ret = -EBUSY;
> +                       goto out;
> +               }
> +               /*
> +                * Pixel format change is not allowed when the other queue has
> +                * buffers allocated.
> +                */
> +               if (vb2_is_busy(&ctx->vq_src)
> +                   && pix_fmt_mp->pixelformat != ctx->dst_fmt.pixelformat) {
> +                       ret = -EBUSY;
> +                       goto out;
> +               }
> +
> +               ret = vidioc_try_fmt(file, priv, f);
> +               if (ret)
> +                       goto out;
> +
> +               fmt = find_format(pix_fmt_mp->pixelformat, false, dev);
> +               ctx->vpu_dst_fmt = fmt;
> +
> +               mb_width = MB_WIDTH(pix_fmt_mp->width);
> +               mb_height = MB_HEIGHT(pix_fmt_mp->height);
> +
> +               vpu_debug(0, "CAPTURE codec mode: %d\n", fmt->codec_mode);
> +               vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
> +                         pix_fmt_mp->width, pix_fmt_mp->height,
> +                         mb_width, mb_height);
> +
> +               for (i = 0; i < fmt->num_planes; ++i) {
> +                       pix_fmt_mp->plane_fmt[i].bytesperline =
> +                               mb_width * MB_DIM * fmt->depth[i] / 8;
> +                       pix_fmt_mp->plane_fmt[i].sizeimage =
> +                               pix_fmt_mp->plane_fmt[i].bytesperline
> +                               * mb_height * MB_DIM;
> +                       /*
> +                        * All of multiplanar formats we support have chroma
> +                        * planes subsampled by 2.
> +                        */
> +                       if (i != 0)
> +                               pix_fmt_mp->plane_fmt[i].sizeimage /= 2;
> +               }
> +
> +               ctx->dst_fmt = *pix_fmt_mp;
> +               break;
> +
> +       default:
> +               vpu_err("invalid buf type\n");
> +               return -EINVAL;
> +       }
> +
> +out:
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int vidioc_reqbufs(struct file *file, void *priv,
> +                         struct v4l2_requestbuffers *reqbufs)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (reqbufs->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
> +               if (ret != 0) {
> +                       vpu_err("error in vb2_reqbufs() for E(S)\n");
> +                       goto out;
> +               }
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +               if (ret != 0) {
> +                       vpu_err("error in vb2_reqbufs() for E(D)\n");
> +                       goto out;
> +               }
> +               break;
> +
> +       default:
> +               vpu_err("invalid buf type\n");
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +out:
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int vidioc_querybuf(struct file *file, void *priv,
> +                          struct v4l2_buffer *buf)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (buf->type) {
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_querybuf(&ctx->vq_dst, buf);
> +               if (ret != 0) {
> +                       vpu_err("error in vb2_querybuf() for E(D)\n");
> +                       goto out;
> +               }
> +
> +               buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_querybuf(&ctx->vq_src, buf);
> +               if (ret != 0) {
> +                       vpu_err("error in vb2_querybuf() for E(S)\n");
> +                       goto out;
> +               }
> +               break;
> +
> +       default:
> +               vpu_err("invalid buf type\n");
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +out:
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +/* Queue a buffer */
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +       int i;
> +
> +       vpu_debug_enter();
> +
> +       for (i = 0; i < buf->length; i++)
> +               vpu_debug(4, "plane[%d]->length %d bytesused %d\n",
> +                               i, buf->m.planes[i].length,
> +                               buf->m.planes[i].bytesused);
> +
> +       switch (buf->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_qbuf(&ctx->vq_src, buf);
> +               vpu_debug(4, "OUTPUT_MPLANE : vb2_qbuf return %d\n", ret);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_qbuf(&ctx->vq_dst, buf);
> +               vpu_debug(4, "CAPTURE_MPLANE: vb2_qbuf return %d\n", ret);
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +/* Dequeue a buffer */
> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (buf->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +/* Export DMA buffer */
> +static int vidioc_expbuf(struct file *file, void *priv,
> +                        struct v4l2_exportbuffer *eb)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (eb->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_expbuf(&ctx->vq_src, eb);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_expbuf(&ctx->vq_dst, eb);
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +/* Stream on */
> +static int vidioc_streamon(struct file *file, void *priv,
> +                          enum v4l2_buf_type type)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_streamon(&ctx->vq_src, type);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_streamon(&ctx->vq_dst, type);
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +/* Stream off, which equals to a pause */
> +static int vidioc_streamoff(struct file *file, void *priv,
> +                           enum v4l2_buf_type type)
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +       int ret;
> +
> +       vpu_debug_enter();
> +
> +       switch (type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               ret = vb2_streamoff(&ctx->vq_src, type);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               ret = vb2_streamoff(&ctx->vq_dst, type);
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int rockchip_vpu_dec_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct rockchip_vpu_ctx *ctx = ctrl_to_ctx(ctrl);
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       int ret = 0;
> +
> +       vpu_debug_enter();
> +
> +       vpu_debug(4, "ctrl id %d\n", ctrl->id);
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
> +               /* These controls are used directly. */
> +               break;
> +
> +       default:
> +               v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
> +                        ctrl->id, ctrl->val);
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops rockchip_vpu_dec_ctrl_ops = {
> +       .s_ctrl = rockchip_vpu_dec_s_ctrl,
> +};
> +
> +static const struct v4l2_ioctl_ops rockchip_vpu_dec_ioctl_ops = {
> +       .vidioc_querycap = vidioc_querycap,
> +       .vidioc_enum_framesizes = vidioc_enum_framesizes,
> +       .vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> +       .vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> +       .vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
> +       .vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
> +       .vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt,
> +       .vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt,
> +       .vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt,
> +       .vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt,
> +       .vidioc_reqbufs = vidioc_reqbufs,
> +       .vidioc_querybuf = vidioc_querybuf,
> +       .vidioc_qbuf = vidioc_qbuf,
> +       .vidioc_dqbuf = vidioc_dqbuf,
> +       .vidioc_expbuf = vidioc_expbuf,
> +       .vidioc_streamon = vidioc_streamon,
> +       .vidioc_streamoff = vidioc_streamoff,
> +};
> +
> +static int rockchip_vpu_queue_setup(struct vb2_queue *vq,
> +                                 const void *parg,
> +                                 unsigned int *buf_count,
> +                                 unsigned int *plane_count,
> +                                 unsigned int psize[], void *allocators[])
> +{
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
> +       int ret = 0;
> +
> +       vpu_debug_enter();
> +
> +       switch (vq->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               *plane_count = ctx->vpu_src_fmt->num_planes;
> +
> +               if (*buf_count < 1)
> +                       *buf_count = 1;
> +
> +               if (*buf_count > VIDEO_MAX_FRAME)
> +                       *buf_count = VIDEO_MAX_FRAME;
> +
> +               psize[0] = ctx->src_fmt.plane_fmt[0].sizeimage;
> +               allocators[0] = ctx->dev->alloc_ctx;
> +               vpu_debug(0, "output psize[%d]: %d\n", 0, psize[0]);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               *plane_count = ctx->vpu_dst_fmt->num_planes;
> +
> +               if (*buf_count < 1)
> +                       *buf_count = 1;
> +
> +               if (*buf_count > VIDEO_MAX_FRAME)
> +                       *buf_count = VIDEO_MAX_FRAME;
> +
> +               psize[0] = round_up(ctx->dst_fmt.plane_fmt[0].sizeimage, 8);
> +               allocators[0] = ctx->dev->alloc_ctx;
> +
> +               vpu_debug(0, "capture psize[%d]: %d\n", 0, psize[0]);
> +               break;
> +
> +       default:
> +               vpu_err("invalid queue type: %d\n", vq->type);
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int rockchip_vpu_buf_init(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
> +
> +       vpu_debug_enter();
> +
> +       if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +               ctx->dst_bufs[vb->index] = vb;
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static void rockchip_vpu_buf_cleanup(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
> +
> +       vpu_debug_enter();
> +
> +       if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +               ctx->dst_bufs[vb->index] = NULL;
> +
> +       vpu_debug_leave();
> +}
> +
> +static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
> +       int ret = 0;
> +       int i;
> +
> +       vpu_debug_enter();
> +
> +       switch (vq->type) {
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               vpu_debug(4, "plane size: %ld, dst size: %d\n",
> +                               vb2_plane_size(vb, 0),
> +                               ctx->src_fmt.plane_fmt[0].sizeimage);
> +
> +               if (vb2_plane_size(vb, 0)
> +                   < ctx->src_fmt.plane_fmt[0].sizeimage) {
> +                       vpu_err("plane size is too small for output\n");
> +                       ret = -EINVAL;
> +               }
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               for (i = 0; i < ctx->vpu_dst_fmt->num_planes; ++i) {
> +                       vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n", i,
> +                                       vb2_plane_size(vb, i),
> +                                       ctx->dst_fmt.plane_fmt[i].sizeimage);
> +
> +                       if (vb2_plane_size(vb, i)
> +                           < ctx->dst_fmt.plane_fmt[i].sizeimage) {
> +                               vpu_err("size of plane %d is too small for capture\n",
> +                                       i);
> +                               break;
> +                       }
> +               }
> +
> +               if (i != ctx->vpu_dst_fmt->num_planes)
> +                       ret = -EINVAL;
> +               break;
> +
> +       default:
> +               vpu_err("invalid queue type: %d\n", vq->type);
> +               ret = -EINVAL;
> +       }
> +
> +       vpu_debug_leave();
> +
> +       return ret;
> +}
> +
> +static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +       int ret = 0;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(q->drv_priv);
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       bool ready = false;
> +
> +       vpu_debug_enter();
> +
> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +               ret = rockchip_vpu_init(ctx);
> +               if (ret < 0) {
> +                       vpu_err("rockchip_vpu_init failed\n");
> +                       return ret;
> +               }
> +
> +               ready = vb2_is_streaming(&ctx->vq_src);
> +       } else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +               ready = vb2_is_streaming(&ctx->vq_dst);
> +       }
> +
> +       if (ready)
> +               rockchip_vpu_try_context(dev, ctx);
> +
> +       vpu_debug_leave();
> +
> +       return 0;
> +}
> +
> +static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
> +{
> +       unsigned long flags;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(q->drv_priv);
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       struct rockchip_vpu_buf *b;
> +       LIST_HEAD(queue);
> +       int i;
> +
> +       vpu_debug_enter();
> +
> +       spin_lock_irqsave(&dev->irqlock, flags);
> +
> +       list_del_init(&ctx->list);
> +
> +       switch (q->type) {
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               list_splice_init(&ctx->dst_queue, &queue);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               list_splice_init(&ctx->src_queue, &queue);
> +               break;
> +
> +       default:
> +               break;
> +       }
> +
> +       spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +       wait_event(dev->run_wq, dev->current_ctx != ctx);
> +
> +       while (!list_empty(&queue)) {
> +               b = list_first_entry(&queue, struct rockchip_vpu_buf, list);
> +               for (i = 0; i < b->b.vb2_buf.num_planes; i++)
> +                       vb2_set_plane_payload(&b->b.vb2_buf, i, 0);
> +               vb2_buffer_done(&b->b.vb2_buf, VB2_BUF_STATE_ERROR);
> +               list_del(&b->list);
> +       }
> +
> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +               rockchip_vpu_deinit(ctx);
> +
> +       vpu_debug_leave();
> +}
> +
> +static void rockchip_vpu_buf_queue(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *vq = vb->vb2_queue;
> +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
> +       struct rockchip_vpu_dev *dev = ctx->dev;
> +       struct rockchip_vpu_buf *vpu_buf;
> +       unsigned long flags;
> +
> +       vpu_debug_enter();
> +
> +       switch (vq->type) {
> +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +               vpu_buf = vb_to_buf(vb);
> +
> +               /* Mark destination as available for use by VPU */
> +               spin_lock_irqsave(&dev->irqlock, flags);
> +
> +               list_add_tail(&vpu_buf->list, &ctx->dst_queue);
> +
> +               spin_unlock_irqrestore(&dev->irqlock, flags);
> +               break;
> +
> +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +               vpu_buf = vb_to_buf(vb);
> +
> +               spin_lock_irqsave(&dev->irqlock, flags);
> +
> +               list_add_tail(&vpu_buf->list, &ctx->src_queue);
> +
> +               spin_unlock_irqrestore(&dev->irqlock, flags);
> +               break;
> +
> +       default:
> +               vpu_err("unsupported buffer type (%d)\n", vq->type);
> +       }
> +
> +       if (vb2_is_streaming(&ctx->vq_src) && vb2_is_streaming(&ctx->vq_dst))
> +               rockchip_vpu_try_context(dev, ctx);
> +
> +       vpu_debug_leave();
> +}
> +
> +static struct vb2_ops rockchip_vpu_dec_qops = {
> +       .queue_setup = rockchip_vpu_queue_setup,
> +       .wait_prepare = vb2_ops_wait_prepare,
> +       .wait_finish = vb2_ops_wait_finish,
> +       .buf_init = rockchip_vpu_buf_init,
> +       .buf_prepare = rockchip_vpu_buf_prepare,
> +       .buf_cleanup = rockchip_vpu_buf_cleanup,
> +       .start_streaming = rockchip_vpu_start_streaming,
> +       .stop_streaming = rockchip_vpu_stop_streaming,
> +       .buf_queue = rockchip_vpu_buf_queue,
> +};
> +
> +struct vb2_ops *get_dec_queue_ops(void)
> +{
> +       return &rockchip_vpu_dec_qops;
> +}
> +
> +const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void)
> +{
> +       return &rockchip_vpu_dec_ioctl_ops;
> +}
> +
> +static void rockchip_vpu_dec_prepare_run(struct rockchip_vpu_ctx *ctx)
> +{
> +       struct vb2_v4l2_buffer *src =
> +               to_vb2_v4l2_buffer(&ctx->run.src->b.vb2_buf);
> +
> +       v4l2_ctrl_apply_request(&ctx->ctrl_handler, src->request);
> +
> +}
> +
> +static void rockchip_vpu_dec_run_done(struct rockchip_vpu_ctx *ctx,
> +                                   enum vb2_buffer_state result)
> +{
> +       struct v4l2_plane_pix_format *plane_fmts = ctx->dst_fmt.plane_fmt;
> +       struct vb2_buffer *dst = &ctx->run.dst->b.vb2_buf;
> +       int i;
> +
> +       if (result != VB2_BUF_STATE_DONE) {
> +               /* Assume no payload after failed run. */
> +               for (i = 0; i < dst->num_planes; ++i)
> +                       vb2_set_plane_payload(dst, i, 0);
> +               return;
> +       }
> +
> +       for (i = 0; i < dst->num_planes; ++i)
> +               vb2_set_plane_payload(dst, i, plane_fmts[i].sizeimage);
> +}
> +
> +static const struct rockchip_vpu_run_ops rockchip_vpu_dec_run_ops = {
> +       .prepare_run = rockchip_vpu_dec_prepare_run,
> +       .run_done = rockchip_vpu_dec_run_done,
> +};
> +
> +int rockchip_vpu_dec_init(struct rockchip_vpu_ctx *ctx)
> +{
> +
> +       ctx->run_ops = &rockchip_vpu_dec_run_ops;
> +
> +       return rockchip_vpu_ctrls_setup(ctx, &rockchip_vpu_dec_ctrl_ops,
> +                                       controls, ARRAY_SIZE(controls), NULL);
> +}
> +
> +void rockchip_vpu_dec_exit(struct rockchip_vpu_ctx *ctx)
> +{
> +       rockchip_vpu_ctrls_delete(ctx);
> +}
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
> new file mode 100644
> index 0000000..267a089
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
> @@ -0,0 +1,33 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Rockchip Electronics Co., Ltd.
> + *     Hertz Wong <hertz.wong@rock-chips.com>
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ROCKCHIP_VPU_DEC_H_
> +#define ROCKCHIP_VPU_DEC_H_
> +
> +struct vb2_ops *get_dec_queue_ops(void);
> +const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
> +struct rockchip_vpu_fmt *get_dec_def_fmt(bool src);
> +int rockchip_vpu_dec_init(struct rockchip_vpu_ctx *ctx);
> +void rockchip_vpu_dec_exit(struct rockchip_vpu_ctx *ctx);
> +
> +#endif /* ROCKCHIP_VPU_DEC_H_ */
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
> new file mode 100644
> index 0000000..dc7abc7
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
> @@ -0,0 +1,278 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "rockchip_vpu_common.h"
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +
> +#include <asm/dma-iommu.h>
> +
> +/**
> + * struct rockchip_vpu_codec_ops - codec mode specific operations
> + *
> + * @init:      Prepare for streaming. Called from VB2 .start_streaming()
> + *             when streaming from both queues is being enabled.
> + * @exit:      Clean-up after streaming. Called from VB2 .stop_streaming()
> + *             when streaming from first of both enabled queues is being
> + *             disabled.
> + * @run:       Start single {en,de)coding run. Called from non-atomic context
> + *             to indicate that a pair of buffers is ready and the hardware
> + *             should be programmed and started.
> + * @done:      Read back processing results and additional data from hardware.
> + * @reset:     Reset the hardware in case of a timeout.
> + */
> +struct rockchip_vpu_codec_ops {
> +       int (*init)(struct rockchip_vpu_ctx *);
> +       void (*exit)(struct rockchip_vpu_ctx *);
> +
> +       int (*irq)(int, struct rockchip_vpu_dev *);
> +       void (*run)(struct rockchip_vpu_ctx *);
> +       void (*done)(struct rockchip_vpu_ctx *, enum vb2_buffer_state);
> +       void (*reset)(struct rockchip_vpu_ctx *);
> +};
> +
> +/*
> + * Hardware control routines.
> + */
> +
> +void rockchip_vpu_power_on(struct rockchip_vpu_dev *vpu)
> +{
> +       vpu_debug_enter();
> +
> +       /* TODO: Clock gating. */
> +
> +       pm_runtime_get_sync(vpu->dev);
> +
> +       vpu_debug_leave();
> +}
> +
> +static void rockchip_vpu_power_off(struct rockchip_vpu_dev *vpu)
> +{
> +       vpu_debug_enter();
> +
> +       pm_runtime_mark_last_busy(vpu->dev);
> +       pm_runtime_put_autosuspend(vpu->dev);
> +
> +       /* TODO: Clock gating. */
> +
> +       vpu_debug_leave();
> +}
> +
> +/*
> + * Interrupt handlers.
> + */
> +
> +static irqreturn_t vdpu_irq(int irq, void *dev_id)
> +{
> +       struct rockchip_vpu_dev *vpu = dev_id;
> +       struct rockchip_vpu_ctx *ctx = vpu->current_ctx;
> +
> +       if (!ctx->hw.codec_ops->irq(irq, vpu)) {
> +               rockchip_vpu_power_off(vpu);
> +               cancel_delayed_work(&vpu->watchdog_work);
> +
> +               ctx->hw.codec_ops->done(ctx, VB2_BUF_STATE_DONE);
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void rockchip_vpu_watchdog(struct work_struct *work)
> +{
> +       struct rockchip_vpu_dev *vpu = container_of(to_delayed_work(work),
> +                                       struct rockchip_vpu_dev, watchdog_work);
> +       struct rockchip_vpu_ctx *ctx = vpu->current_ctx;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&vpu->irqlock, flags);
> +
> +       ctx->hw.codec_ops->reset(ctx);
> +
> +       spin_unlock_irqrestore(&vpu->irqlock, flags);
> +
> +       vpu_err("frame processing timed out!\n");
> +
> +       rockchip_vpu_power_off(vpu);
> +       ctx->hw.codec_ops->done(ctx, VB2_BUF_STATE_ERROR);
> +}
> +
> +/*
> + * Initialization/clean-up.
> + */
> +
> +#if defined(CONFIG_ROCKCHIP_IOMMU)
> +static int rockchip_vpu_iommu_init(struct rockchip_vpu_dev *vpu)
> +{
> +       int ret;
> +
> +       vpu->mapping = arm_iommu_create_mapping(&platform_bus_type,
> +                                               0x10000000, SZ_2G);
> +       if (IS_ERR(vpu->mapping)) {
> +               ret = PTR_ERR(vpu->mapping);
> +               return ret;
> +       }
> +
> +       vpu->dev->dma_parms = devm_kzalloc(vpu->dev,
> +                               sizeof(*vpu->dev->dma_parms), GFP_KERNEL);
> +       if (!vpu->dev->dma_parms)
> +               goto err_release_mapping;
> +
> +       dma_set_max_seg_size(vpu->dev, 0xffffffffu);
> +
> +       ret = arm_iommu_attach_device(vpu->dev, vpu->mapping);
> +       if (ret)
> +               goto err_release_mapping;
> +
> +       return 0;
> +
> +err_release_mapping:
> +       arm_iommu_release_mapping(vpu->mapping);
> +
> +       return ret;
> +}
> +
> +static void rockchip_vpu_iommu_cleanup(struct rockchip_vpu_dev *vpu)
> +{
> +       arm_iommu_detach_device(vpu->dev);
> +       arm_iommu_release_mapping(vpu->mapping);
> +}
> +#else
> +static inline int rockchip_vpu_iommu_init(struct rockchip_vpu_dev *vpu)
> +{
> +       return 0;
> +}
> +
> +static inline void rockchip_vpu_iommu_cleanup(struct rockchip_vpu_dev *vpu) { }
> +#endif
> +
> +int rockchip_vpu_hw_probe(struct rockchip_vpu_dev *vpu)
> +{
> +       struct resource *res;
> +       int irq_dec;
> +       int ret;
> +
> +       pr_info("probe device %s\n", dev_name(vpu->dev));
> +
> +       INIT_DELAYED_WORK(&vpu->watchdog_work, rockchip_vpu_watchdog);
> +
> +       vpu->aclk = devm_clk_get(vpu->dev, "aclk");
> +       if (IS_ERR(vpu->aclk)) {
> +               dev_err(vpu->dev, "failed to get aclk\n");
> +               return PTR_ERR(vpu->aclk);
> +       }
> +
> +       vpu->hclk = devm_clk_get(vpu->dev, "hclk");
> +       if (IS_ERR(vpu->hclk)) {
> +               dev_err(vpu->dev, "failed to get hclk\n");
> +               return PTR_ERR(vpu->hclk);
> +       }
> +
> +       /*
> +        * Bump ACLK to max. possible freq. (400 MHz) to improve performance.
> +        */
> +       clk_set_rate(vpu->aclk, 400*1000*1000);
> +
> +       res = platform_get_resource(vpu->pdev, IORESOURCE_MEM, 0);
> +       vpu->base = devm_ioremap_resource(vpu->dev, res);
> +       if (IS_ERR(vpu->base))
> +               return PTR_ERR(vpu->base);
> +
> +       clk_prepare_enable(vpu->aclk);
> +       clk_prepare_enable(vpu->hclk);
> +
> +       vpu->dec_base = vpu->base + vpu->variant->dec_offset;
> +
> +       ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
> +       if (ret) {
> +               dev_err(vpu->dev, "could not set DMA coherent mask\n");
> +               goto err_power;
> +       }
> +
> +       ret = rockchip_vpu_iommu_init(vpu);
> +       if (ret)
> +               goto err_power;
> +
> +       irq_dec = platform_get_irq_byname(vpu->pdev, "vdpu");
> +       if (irq_dec <= 0) {
> +               dev_err(vpu->dev, "could not get vdpu IRQ\n");
> +               ret = -ENXIO;
> +               goto err_iommu;
> +       }
> +
> +       ret = devm_request_threaded_irq(vpu->dev, irq_dec, NULL, vdpu_irq,
> +                                       IRQF_ONESHOT, dev_name(vpu->dev), vpu);
> +       if (ret) {
> +               dev_err(vpu->dev, "could not request vdpu IRQ\n");
> +               goto err_iommu;
> +       }
> +
> +       pm_runtime_set_autosuspend_delay(vpu->dev, 100);
> +       pm_runtime_use_autosuspend(vpu->dev);
> +       pm_runtime_enable(vpu->dev);
> +
> +       return 0;
> +
> +err_iommu:
> +       rockchip_vpu_iommu_cleanup(vpu);
> +err_power:
> +       clk_disable_unprepare(vpu->hclk);
> +       clk_disable_unprepare(vpu->aclk);
> +
> +       return ret;
> +}
> +
> +void rockchip_vpu_hw_remove(struct rockchip_vpu_dev *vpu)
> +{
> +       rockchip_vpu_iommu_cleanup(vpu);
> +
> +       pm_runtime_disable(vpu->dev);
> +
> +       clk_disable_unprepare(vpu->hclk);
> +       clk_disable_unprepare(vpu->aclk);
> +}
> +
> +static const struct rockchip_vpu_codec_ops mode_ops[0];
> +
> +void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx)
> +{
> +       ctx->hw.codec_ops->run(ctx);
> +}
> +
> +int rockchip_vpu_init(struct rockchip_vpu_ctx *ctx)
> +{
> +       enum rockchip_vpu_codec_mode codec_mode;
> +
> +       codec_mode = ctx->vpu_src_fmt->codec_mode; /* Decoder */
> +
> +       ctx->hw.codec_ops = &mode_ops[codec_mode];
> +
> +       return ctx->hw.codec_ops->init(ctx);
> +}
> +
> +void rockchip_vpu_deinit(struct rockchip_vpu_ctx *ctx)
> +{
> +       ctx->hw.codec_ops->exit(ctx);
> +}
> diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
> new file mode 100644
> index 0000000..975357da
> --- /dev/null
> +++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
> @@ -0,0 +1,78 @@
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *     Tomasz Figa <tfiga@chromium.org>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ROCKCHIP_VPU_HW_H_
> +#define ROCKCHIP_VPU_HW_H_
> +
> +#include <media/videobuf2-core.h>
> +
> +#define ROCKCHIP_HEADER_SIZE           1280
> +#define ROCKCHIP_HW_PARAMS_SIZE                5487
> +#define ROCKCHIP_RET_PARAMS_SIZE       488
> +
> +struct rockchip_vpu_dev;
> +struct rockchip_vpu_ctx;
> +struct rockchip_vpu_buf;
> +
> +/**
> + * enum rockchip_vpu_type - vpu type.
> + * @RK_VPU_NONE:       No vpu type. Used for RAW video formats.
> + * @RK3288_VPU:                Vpu on rk3288 soc.
> + * @RK3229_VPU:                Vpu on rk3229 soc.
> + * @RKVDEC:            Rkvdec.
> + */
> +enum rockchip_vpu_type {
> +       RK_VPU_NONE     = -1,
> +       RK3288_VPU,
> +       RK3229_VPU,
> +};
> +
> +#define ROCKCHIP_VPU_MATCHES(type1, type2) \
> +       (type1 == RK_VPU_NONE || type2 == RK_VPU_NONE || type1 == type2)
> +
> +/**
> + * struct rockchip_vpu_aux_buf - auxiliary DMA buffer for hardware data
> + * @cpu:       CPU pointer to the buffer.
> + * @dma:       DMA address of the buffer.
> + * @size:      Size of the buffer.
> + */
> +struct rockchip_vpu_aux_buf {
> +       void *cpu;
> +       dma_addr_t dma;
> +       size_t size;
> +};
> +
> +/**
> + * struct rockchip_vpu_hw_ctx - Context private data of hardware code.
> + * @codec_ops:         Set of operations associated with current codec mode.
> + */
> +struct rockchip_vpu_hw_ctx {
> +       const struct rockchip_vpu_codec_ops *codec_ops;
> +
> +       /* Specific for particular codec modes. */
> +};
> +
> +int rockchip_vpu_hw_probe(struct rockchip_vpu_dev *vpu);
> +void rockchip_vpu_hw_remove(struct rockchip_vpu_dev *vpu);
> +
> +int rockchip_vpu_init(struct rockchip_vpu_ctx *ctx);
> +void rockchip_vpu_deinit(struct rockchip_vpu_ctx *ctx);
> +
> +void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
> +
> +void rockchip_vpu_power_on(struct rockchip_vpu_dev *vpu);
> +
> +#endif /* RK3288_VPU_HW_H_ */
> --
> 1.9.1
>
