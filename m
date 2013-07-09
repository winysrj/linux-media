Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:39969 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3GILaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 07:30:20 -0400
Received: by mail-vb0-f50.google.com with SMTP id w16so4267748vbb.23
        for <linux-media@vger.kernel.org>; Tue, 09 Jul 2013 04:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306260913.36975.hverkuil@xs4all.nl>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-8-git-send-email-arun.kk@samsung.com>
	<201306260913.36975.hverkuil@xs4all.nl>
Date: Tue, 9 Jul 2013 17:00:19 +0530
Message-ID: <CALt3h79eQ77EJo-Or671_-OecqL4=62Nat2upeOYP+apuGeycQ@mail.gmail.com>
Subject: Re: [RFC v2 07/10] exynos5-fimc-is: Adds scaler subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Wed, Jun 26, 2013 at 12:43 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri May 31 2013 15:03:25 Arun Kumar K wrote:
>> FIMC-IS has two hardware scalers named as scaler-codec and
>> scaler-preview. This patch adds the common code handling the
>> video nodes and subdevs of both the scalers.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> ---
>>  drivers/media/platform/exynos5-is/fimc-is-scaler.c |  492 ++++++++++++++++++++
>>  drivers/media/platform/exynos5-is/fimc-is-scaler.h |  107 +++++
>>  2 files changed, 599 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.c
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-scaler.c b/drivers/media/platform/exynos5-is/fimc-is-scaler.c
>> new file mode 100644
>> index 0000000..b4f3f5c
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-scaler.c
>> @@ -0,0 +1,492 @@
>> +/*
>> + * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + *  Arun Kumar K <arun.kk@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include "fimc-is.h"
>> +
>> +#define IS_SCALER_DRV_NAME "fimc-is-scaler"
>> +
>> +static const struct fimc_is_fmt formats[] = {
>> +     {
>> +             .name           = "YUV 4:2:0 3p MultiPlanar",
>> +             .fourcc         = V4L2_PIX_FMT_YUV420M,
>> +             .depth          = {8, 2, 2},
>> +             .num_planes     = 3,
>> +     },
>> +     {
>> +             .name           = "YUV 4:2:0 2p MultiPlanar",
>> +             .fourcc         = V4L2_PIX_FMT_NV12M,
>> +             .depth          = {8, 4},
>> +             .num_planes     = 2,
>> +     },
>> +     {
>> +             .name           = "YUV 4:2:2 1p MultiPlanar",
>> +             .fourcc         = V4L2_PIX_FMT_NV16,
>> +             .depth          = {16},
>> +             .num_planes     = 1,
>> +     },
>> +};
>> +#define NUM_FORMATS ARRAY_SIZE(formats)
>> +
>> +static struct fimc_is_fmt *find_format(struct v4l2_format *f)
>> +{
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < NUM_FORMATS; i++) {
>> +             if (formats[i].fourcc == f->fmt.pix_mp.pixelformat)
>> +                     return (struct fimc_is_fmt *) &formats[i];
>> +     }
>> +     return NULL;
>> +}
>> +
>> +static int scaler_video_capture_start_streaming(struct vb2_queue *vq,
>> +                                     unsigned int count)
>> +{
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     int ret;
>> +
>> +     /* Scaler start */
>> +     ret = fimc_is_pipeline_scaler_start(ctx->pipeline,
>> +                     ctx->scaler_id,
>> +                     (unsigned int **)ctx->buf_paddr,
>> +                     ctx->num_buffers,
>> +                     ctx->fmt->num_planes);
>> +     if (ret) {
>> +             pr_err("Scaler start failed.\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     set_bit(STATE_RUNNING, &ctx->capture_state);
>> +     return 0;
>> +}
>> +
>> +static int scaler_video_capture_stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     int ret;
>> +
>> +     /* Scaler stop */
>> +     ret = fimc_is_pipeline_scaler_stop(ctx->pipeline, ctx->scaler_id);
>> +     if (ret)
>> +             pr_debug("Scaler already stopped.\n");
>> +
>> +     clear_bit(STATE_RUNNING, &ctx->capture_state);
>> +     return 0;
>> +}
>> +
>> +static int scaler_video_capture_queue_setup(struct vb2_queue *vq,
>> +                     const struct v4l2_format *pfmt,
>> +                     unsigned int *num_buffers, unsigned int *num_planes,
>> +                     unsigned int sizes[], void *allocators[])
>> +{
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     struct fimc_is_fmt *fmt = ctx->fmt;
>> +     unsigned int wh;
>> +     int i;
>> +
>> +     if (!fmt)
>> +             return -EINVAL;
>> +
>> +     *num_planes = fmt->num_planes;
>> +     wh = ctx->width * ctx->height;
>> +
>> +     for (i = 0; i < *num_planes; i++) {
>> +             allocators[i] = ctx->alloc_ctx;
>> +             sizes[i] = (wh * fmt->depth[i]) / 8;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int scaler_video_capture_buffer_init(struct vb2_buffer *vb)
>> +{
>> +     struct vb2_queue *vq = vb->vb2_queue;
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     struct fimc_is_buf *buf;
>> +     struct fimc_is_fmt *fmt;
>> +     int i;
>> +
>> +     buf = &ctx->capture_bufs[vb->v4l2_buf.index];
>> +     /* Initialize buffer */
>> +     buf->vb = vb;
>> +     fmt = ctx->fmt;
>> +     for (i = 0; i < fmt->num_planes; i++)
>> +             buf->paddr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
>> +
>> +     ctx->cap_buf_cnt++;
>> +     return 0;
>> +}
>> +
>> +static void scaler_video_capture_buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     struct vb2_queue *vq = vb->vb2_queue;
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     struct fimc_is_buf *buf;
>> +
>> +     buf = &ctx->capture_bufs[vb->v4l2_buf.index];
>> +
>> +     /* Add buffer to the wait queue */
>> +     pr_debug("Add buffer %d in Scaler %d\n",
>> +                     vb->v4l2_buf.index, ctx->scaler_id);
>> +     fimc_is_pipeline_buf_lock(ctx->pipeline);
>> +     fimc_is_scaler_wait_queue_add(ctx, buf);
>> +     fimc_is_pipeline_buf_unlock(ctx->pipeline);
>> +}
>> +
>> +static void scaler_lock(struct vb2_queue *vq)
>> +{
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     mutex_lock(&ctx->video_lock);
>> +}
>> +
>> +static void scaler_unlock(struct vb2_queue *vq)
>> +{
>> +     struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
>> +     mutex_unlock(&ctx->video_lock);
>> +}
>> +
>> +static const struct vb2_ops scaler_video_capture_qops = {
>> +     .queue_setup            = scaler_video_capture_queue_setup,
>> +     .buf_init               = scaler_video_capture_buffer_init,
>> +     .buf_queue              = scaler_video_capture_buffer_queue,
>> +     .wait_prepare           = scaler_unlock,
>> +     .wait_finish            = scaler_lock,
>> +     .start_streaming        = scaler_video_capture_start_streaming,
>> +     .stop_streaming         = scaler_video_capture_stop_streaming,
>> +};
>> +
>> +static int scaler_video_capture_open(struct file *file)
>> +{
>> +     struct fimc_is_scaler *ctx = video_drvdata(file);
>> +     int ret = 0;
>> +
>> +     /* Check if opened before */
>> +     if (ctx->refcount >= FIMC_IS_MAX_INSTANCES) {
>> +             pr_err("All instances are in use.\n");
>> +             return -EBUSY;
>> +     }
>> +
>> +     INIT_LIST_HEAD(&ctx->wait_queue);
>> +     ctx->wait_queue_cnt = 0;
>> +     INIT_LIST_HEAD(&ctx->run_queue);
>> +     ctx->run_queue_cnt = 0;
>> +
>> +     ctx->fmt = NULL;
>> +     ctx->refcount++;
>> +
>> +     return ret;
>> +}
>> +
>> +static int scaler_video_capture_close(struct file *file)
>> +{
>> +     struct fimc_is_scaler *ctx = video_drvdata(file);
>> +     int ret = 0;
>> +
>> +     ctx->refcount--;
>> +     ctx->capture_state = 0;
>> +     vb2_fop_release(file);
>> +
>> +     return ret;
>> +}
>> +
>> +static const struct v4l2_file_operations scaler_video_capture_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = scaler_video_capture_open,
>> +     .release        = scaler_video_capture_close,
>> +     .poll           = vb2_fop_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap           = vb2_fop_mmap,
>> +};
>> +
>> +/*
>> + * Video node ioctl operations
>> + */
>> +static int scaler_querycap_capture(struct file *file, void *priv,
>> +                                     struct v4l2_capability *cap)
>> +{
>> +     strncpy(cap->driver, IS_SCALER_DRV_NAME, sizeof(cap->driver) - 1);
>> +     strncpy(cap->card, IS_SCALER_DRV_NAME, sizeof(cap->card) - 1);
>> +     strncpy(cap->bus_info, IS_SCALER_DRV_NAME, sizeof(cap->bus_info) - 1);
>
> bus_info for a platform device must be prefixed with "platform:"
>
>> +     cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
>
> You are missing V4L2_CAP_DEVICE_CAPS.
>
> It's easier to write:
>
>         cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>

Ok will change.

>> +     cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
>> +     return 0;
>> +}
>> +
>> +static int scaler_enum_fmt_mplane(struct file *file, void *priv,
>> +                                  struct v4l2_fmtdesc *f)
>> +{
>> +     const struct fimc_is_fmt *fmt;
>> +
>> +     if (f->index >= NUM_FORMATS)
>> +             return -EINVAL;
>> +
>> +     fmt = &formats[f->index];
>> +     strlcpy(f->description, fmt->name, sizeof(f->description));
>> +     f->pixelformat = fmt->fourcc;
>> +     return 0;
>> +}
>> +
>> +static int scaler_g_fmt_mplane(struct file *file, void *priv,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct fimc_is_scaler *ctx = video_drvdata(file);
>> +     struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
>> +     struct v4l2_plane_pix_format *plane_fmt = &pixm->plane_fmt[0];
>> +     const struct fimc_is_fmt *fmt = ctx->fmt;
>> +
>> +     plane_fmt->bytesperline = (ctx->width * fmt->depth[0]) / 8;
>> +     plane_fmt->sizeimage = plane_fmt->bytesperline * ctx->height;
>> +
>> +     pixm->num_planes = fmt->num_planes;
>> +     pixm->pixelformat = fmt->fourcc;
>> +     pixm->width = ctx->width;
>> +     pixm->height = ctx->height;
>> +     pixm->field = V4L2_FIELD_NONE;
>> +     pixm->colorspace = V4L2_COLORSPACE_JPEG;
>
> priv must be zeroed: pixm->priv = 0;
>

Ok.

>> +
>> +     return 0;
>> +}
>> +
>> +static int scaler_try_fmt_mplane(struct file *file, void *priv,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct fimc_is_fmt *fmt;
>> +
>> +     if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +             return -EINVAL;
>
> Not necessary, checked by the core for you.
>

Ok.

>> +
>> +     fmt = find_format(f);
>> +     if (!fmt) {
>> +             fmt = (struct fimc_is_fmt *) &formats[0];
>> +             f->fmt.pix_mp.pixelformat = fmt->fourcc;
>> +     }
>> +
>> +     if (fmt->num_planes != f->fmt.pix_mp.num_planes)
>> +             f->fmt.pix_mp.num_planes = fmt->num_planes;
>
> try_fmt must also set field, colorspace, priv and calculate bytesperline
> and sizeimage. Note: if the DMA supports strides > width then a
> bytesperline value > width * depth must be honoured.
>

Ok.

>> +
>> +     return 0;
>> +}
>> +
>> +static int scaler_s_fmt_mplane(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     struct fimc_is_scaler *ctx = video_drvdata(file);
>> +     struct fimc_is_fmt *fmt;
>> +     int ret;
>> +
>> +     ret = scaler_try_fmt_mplane(file, priv, f);
>> +     if (ret)
>> +             return ret;
>> +
>> +     /* Get format type */
>> +     fmt = find_format(f);
>> +     if (!fmt) {
>> +             fmt = (struct fimc_is_fmt *) &formats[0];
>> +             f->fmt.pix_mp.pixelformat = fmt->fourcc;
>> +             f->fmt.pix_mp.num_planes = fmt->num_planes;
>> +     }
>> +
>> +     /* Check width & height */
>> +     if (f->fmt.pix_mp.width > ctx->pipeline->sensor_width ||
>> +             f->fmt.pix_mp.height > ctx->pipeline->sensor_height) {
>> +             f->fmt.pix_mp.width = ctx->pipeline->sensor_width;
>> +             f->fmt.pix_mp.height = ctx->pipeline->sensor_height;
>> +     }
>> +
>> +     /* Save values to context */
>> +     ctx->fmt = fmt;
>> +     ctx->width = f->fmt.pix_mp.width;
>> +     ctx->height = f->fmt.pix_mp.height;
>> +     ctx->pipeline->scaler_width[ctx->scaler_id] = ctx->width;
>> +     ctx->pipeline->scaler_height[ctx->scaler_id] = ctx->height;
>> +     set_bit(STATE_INIT, &ctx->capture_state);
>> +     return 0;
>> +}
>> +
>> +static int scaler_reqbufs(struct file *file, void *priv,
>> +             struct v4l2_requestbuffers *reqbufs)
>> +{
>> +     struct fimc_is_scaler *ctx = video_drvdata(file);
>> +     int ret;
>> +
>> +     if (reqbufs->memory != V4L2_MEMORY_MMAP &&
>> +                     reqbufs->memory != V4L2_MEMORY_DMABUF) {
>> +             pr_err("Memory type not supported\n");
>> +             return -EINVAL;
>> +     }
>
> No need for this, vb2 checks this already.
>

Ok.

>> +
>> +     if (!ctx->fmt) {
>> +             pr_err("Set format not done\n");
>> +             return -EINVAL;
>> +     }
>
> This should never happen, ctx->fmt must always be set to something.
> On driver load a default format should be selected to ensure this.
>

Ok.

>> +
>> +     /* Check whether buffers are already allocated */
>> +     if (test_bit(STATE_BUFS_ALLOCATED, &ctx->capture_state)) {
>> +             pr_err("Buffers already allocated\n");
>> +             return -EINVAL;
>> +     }
>
> vb2 also takes care of this: vb2_is_busy()
>

Ok.

>> +
>> +     ret = vb2_reqbufs(&ctx->vbq, reqbufs);
>> +     if (ret) {
>> +             pr_err("vb2 req buffers failed\n");
>> +             return ret;
>> +     }
>> +
>> +     ctx->num_buffers = reqbufs->count;
>
> vb2 stores this in q->num_buffers, no need to keep track of this.
>

Ok will remove that.

>> +     ctx->cap_buf_cnt = 0;
>> +     set_bit(STATE_BUFS_ALLOCATED, &ctx->capture_state);
>> +     return 0;
>> +}
>
> Frankly I see no reason why you can't use vb2_ioctl_reqbufs instead.
>

Yes will use vb2_ioctl_reqbufs

>> +
>> +static const struct v4l2_ioctl_ops scaler_video_capture_ioctl_ops = {
>> +     .vidioc_querycap                = scaler_querycap_capture,
>> +     .vidioc_enum_fmt_vid_cap_mplane = scaler_enum_fmt_mplane,
>> +     .vidioc_try_fmt_vid_cap_mplane  = scaler_try_fmt_mplane,
>> +     .vidioc_s_fmt_vid_cap_mplane    = scaler_s_fmt_mplane,
>> +     .vidioc_g_fmt_vid_cap_mplane    = scaler_g_fmt_mplane,
>> +     .vidioc_reqbufs                 = scaler_reqbufs,
>> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
>> +     .vidioc_expbuf                  = vb2_ioctl_expbuf,
>> +     .vidioc_streamon                = vb2_ioctl_streamon,
>> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
>> +};
>> +
>> +static int scaler_subdev_registered(struct v4l2_subdev *sd)
>> +{
>> +     struct fimc_is_scaler *ctx = v4l2_get_subdevdata(sd);
>> +     struct vb2_queue *q = &ctx->vbq;
>> +     struct video_device *vfd = &ctx->vfd;
>> +     int ret;
>> +
>> +     mutex_init(&ctx->video_lock);
>> +
>> +     memset(vfd, 0, sizeof(*vfd));
>> +     if (ctx->scaler_id == SCALER_SCC)
>> +             snprintf(vfd->name, sizeof(vfd->name), "fimc-is-scaler.codec");
>> +     else
>> +             snprintf(vfd->name, sizeof(vfd->name),
>> +                             "fimc-is-scaler.preview");
>> +
>> +     vfd->fops = &scaler_video_capture_fops;
>> +     vfd->ioctl_ops = &scaler_video_capture_ioctl_ops;
>> +     vfd->v4l2_dev = sd->v4l2_dev;
>> +     vfd->minor = -1;
>
> No need to set this.
>

Ok

>> +     vfd->release = video_device_release_empty;
>> +     vfd->lock = &ctx->video_lock;
>> +     vfd->queue = q;
>> +     vfd->vfl_dir = VFL_DIR_RX;
>
> In order to provide G/S_PRIORITY support and for supporting control events
> you need to use struct v4l2_fh and set the PRIO flag in vfd->flags. See e.g.
> vivi.c.
>
> Please run the v4l2-compliance tool over any video nodes you make to check
> that the driver implements everything correctly! Always use the latest version
> from the v4l-utils.git repository as this utility is continuously improved.
>
> Most if not all comments I made would have been found with that utility.
> Don't leave home without it :-)
>

Sure will run the tool and correct issues in the next version.

> Regards,
>
>         Hans
>

Thanks and regards
Arun
