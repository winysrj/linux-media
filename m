Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41110 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJASfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 14:35:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id j15-v6so13611017wrt.8
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 04:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180928142816.4311-1-mjourdan@baylibre.com> <20180928142816.4311-3-mjourdan@baylibre.com>
 <6fb97945-e63a-b98b-bf07-0a5088ac7232@xs4all.nl>
In-Reply-To: <6fb97945-e63a-b98b-bf07-0a5088ac7232@xs4all.nl>
From: Maxime Jourdan <mjourdan@baylibre.com>
Date: Mon, 1 Oct 2018 13:57:55 +0200
Message-ID: <CAMO6naxoXMsb=SEH8mu=7YBhFW_-6YzvR0K3mMaHD1rZ-_UJxg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] media: meson: add v4l2 m2m video decoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lun. 1 oct. 2018 =C3=A0 12:26, Hans Verkuil <hverkuil@xs4all.nl> a =C3=
=A9crit :
>
> On 09/28/2018 04:28 PM, Maxime Jourdan wrote:
> > Amlogic SoCs feature a powerful video decoder unit able to
> > decode many formats, with a performance of usually up to 4k60.
> >
> > This is a driver for this IP that is based around the v4l2 m2m framewor=
k.
> >
> > It features decoding for:
> > - MPEG 1
> > - MPEG 2
> >
> > Supported SoCs are: GXBB (S905), GXL (S905X/W/D), GXM (S912)
> >
> > There is also a hardware bitstream parser (ESPARSER) that is handled he=
re.
> >
> > Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> > ---
> >  drivers/media/platform/Kconfig                |   10 +
> >  drivers/media/platform/meson/Makefile         |    1 +
> >  drivers/media/platform/meson/vdec/Makefile    |    8 +
> >  .../media/platform/meson/vdec/codec_mpeg12.c  |  209 ++++
> >  .../media/platform/meson/vdec/codec_mpeg12.h  |   14 +
> >  drivers/media/platform/meson/vdec/dos_regs.h  |   98 ++
> >  drivers/media/platform/meson/vdec/esparser.c  |  322 ++++++
> >  drivers/media/platform/meson/vdec/esparser.h  |   32 +
> >  drivers/media/platform/meson/vdec/vdec.c      | 1024 +++++++++++++++++
> >  drivers/media/platform/meson/vdec/vdec.h      |  251 ++++
> >  drivers/media/platform/meson/vdec/vdec_1.c    |  231 ++++
> >  drivers/media/platform/meson/vdec/vdec_1.h    |   14 +
> >  .../media/platform/meson/vdec/vdec_helpers.c  |  412 +++++++
> >  .../media/platform/meson/vdec/vdec_helpers.h  |   48 +
> >  .../media/platform/meson/vdec/vdec_platform.c |  101 ++
> >  .../media/platform/meson/vdec/vdec_platform.h |   30 +
> >  16 files changed, 2805 insertions(+)
> >  create mode 100644 drivers/media/platform/meson/vdec/Makefile
> >  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
> >  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
> >  create mode 100644 drivers/media/platform/meson/vdec/dos_regs.h
> >  create mode 100644 drivers/media/platform/meson/vdec/esparser.c
> >  create mode 100644 drivers/media/platform/meson/vdec/esparser.h
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec.c
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec.h
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.c
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.h
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
> >  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h
> >
>
> <snip>
>
> > diff --git a/drivers/media/platform/meson/vdec/vdec.c b/drivers/media/p=
latform/meson/vdec/vdec.c
> > new file mode 100644
> > index 000000000000..8a7f809e6923
> > --- /dev/null
> > +++ b/drivers/media/platform/meson/vdec/vdec.c
> > @@ -0,0 +1,1024 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2018 BayLibre, SAS
> > + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> > + */
> > +
> > +#include <linux/of_device.h>
> > +#include <linux/clk.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/slab.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/v4l2-dev.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "vdec.h"
> > +#include "esparser.h"
> > +#include "vdec_helpers.h"
> > +
> > +struct dummy_buf {
> > +     struct vb2_v4l2_buffer vb;
> > +     struct list_head list;
> > +};
> > +
> > +/* 16 MiB for parsed bitstream swap exchange */
> > +#define SIZE_VIFIFO SZ_16M
> > +
> > +static u32 get_output_size(u32 width, u32 height)
> > +{
> > +     return ALIGN(width * height, SZ_64K);
> > +}
> > +
> > +u32 amvdec_get_output_size(struct amvdec_session *sess)
> > +{
> > +     return get_output_size(sess->width, sess->height);
> > +}
> > +EXPORT_SYMBOL_GPL(amvdec_get_output_size);
> > +
> > +static int vdec_codec_needs_recycle(struct amvdec_session *sess)
> > +{
> > +     struct amvdec_codec_ops *codec_ops =3D sess->fmt_out->codec_ops;
> > +
> > +     return codec_ops->can_recycle && codec_ops->recycle;
> > +}
> > +
> > +static int vdec_recycle_thread(void *data)
> > +{
> > +     struct amvdec_session *sess =3D data;
> > +     struct amvdec_core *core =3D sess->core;
> > +     struct amvdec_codec_ops *codec_ops =3D sess->fmt_out->codec_ops;
> > +     struct amvdec_buffer *tmp, *n;
> > +
> > +     while (!kthread_should_stop()) {
> > +             mutex_lock(&sess->bufs_recycle_lock);
> > +             list_for_each_entry_safe(tmp, n, &sess->bufs_recycle, lis=
t) {
> > +                     if (!codec_ops->can_recycle(core))
> > +                             break;
> > +
> > +                     codec_ops->recycle(core, tmp->vb->index);
> > +                     list_del(&tmp->list);
> > +                     kfree(tmp);
> > +             }
> > +             mutex_unlock(&sess->bufs_recycle_lock);
> > +
> > +             usleep_range(5000, 10000);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_poweron(struct amvdec_session *sess)
> > +{
> > +     int ret;
> > +     struct amvdec_ops *vdec_ops =3D sess->fmt_out->vdec_ops;
> > +
> > +     ret =3D clk_prepare_enable(sess->core->dos_parser_clk);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D clk_prepare_enable(sess->core->dos_clk);
> > +     if (ret)
> > +             goto disable_dos_parser;
> > +
> > +     ret =3D vdec_ops->start(sess);
> > +     if (ret)
> > +             goto disable_dos;
> > +
> > +     esparser_power_up(sess);
> > +
> > +     return 0;
> > +
> > +disable_dos:
> > +     clk_disable_unprepare(sess->core->dos_clk);
> > +disable_dos_parser:
> > +     clk_disable_unprepare(sess->core->dos_parser_clk);
> > +
> > +     return ret;
> > +}
> > +
> > +static void vdec_wait_inactive(struct amvdec_session *sess)
> > +{
> > +     /* We consider 50ms with no IRQ to be inactive. */
> > +     while (time_is_after_jiffies64(sess->last_irq_jiffies +
> > +                                    msecs_to_jiffies(50)))
> > +             msleep(25);
> > +}
> > +
> > +static void vdec_poweroff(struct amvdec_session *sess)
> > +{
> > +     struct amvdec_ops *vdec_ops =3D sess->fmt_out->vdec_ops;
> > +     struct amvdec_codec_ops *codec_ops =3D sess->fmt_out->codec_ops;
> > +
> > +     vdec_wait_inactive(sess);
> > +     if (codec_ops->drain)
> > +             codec_ops->drain(sess);
> > +
> > +     vdec_ops->stop(sess);
> > +     clk_disable_unprepare(sess->core->dos_clk);
> > +     clk_disable_unprepare(sess->core->dos_parser_clk);
> > +}
> > +
> > +static void
> > +vdec_queue_recycle(struct amvdec_session *sess, struct vb2_buffer *vb)
> > +{
> > +     struct amvdec_buffer *new_buf;
> > +
> > +     new_buf =3D kmalloc(sizeof(*new_buf), GFP_KERNEL);
> > +     new_buf->vb =3D vb;
> > +
> > +     mutex_lock(&sess->bufs_recycle_lock);
> > +     list_add_tail(&new_buf->list, &sess->bufs_recycle);
> > +     mutex_unlock(&sess->bufs_recycle_lock);
> > +}
> > +
> > +static void vdec_m2m_device_run(void *priv)
> > +{
> > +     struct amvdec_session *sess =3D priv;
> > +
> > +     schedule_work(&sess->esparser_queue_work);
> > +}
> > +
> > +static void vdec_m2m_job_abort(void *priv)
> > +{
> > +     struct amvdec_session *sess =3D priv;
> > +
> > +     v4l2_m2m_job_finish(sess->m2m_dev, sess->m2m_ctx);
> > +}
> > +
> > +static const struct v4l2_m2m_ops vdec_m2m_ops =3D {
> > +     .device_run =3D vdec_m2m_device_run,
> > +     .job_abort =3D vdec_m2m_job_abort,
> > +};
> > +
> > +static int vdec_queue_setup(struct vb2_queue *q,
> > +             unsigned int *num_buffers, unsigned int *num_planes,
> > +             unsigned int sizes[], struct device *alloc_devs[])
> > +{
> > +     struct amvdec_session *sess =3D vb2_get_drv_priv(q);
> > +     const struct amvdec_format *fmt_out =3D sess->fmt_out;
> > +     u32 output_size =3D amvdec_get_output_size(sess);
> > +
> > +     if (*num_planes) {
> > +             switch (q->type) {
> > +             case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +                     if (*num_planes !=3D 1 || sizes[0] < output_size)
> > +                             return -EINVAL;
> > +                     break;
> > +             case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +                     switch (sess->pixfmt_cap) {
> > +                     case V4L2_PIX_FMT_NV12M:
> > +                             if (*num_planes !=3D 2 ||
> > +                                 sizes[0] < output_size ||
> > +                                 sizes[1] < output_size / 2)
> > +                                     return -EINVAL;
> > +                             break;
> > +                     case V4L2_PIX_FMT_YUV420M:
> > +                             if (*num_planes !=3D 3 ||
> > +                                 sizes[0] < output_size ||
> > +                                 sizes[1] < output_size / 4 ||
> > +                                 sizes[2] < output_size / 4)
> > +                                     return -EINVAL;
> > +                             break;
> > +                     default:
> > +                             return -EINVAL;
> > +                     }
> > +                     break;
>
> You want to clamp *num_buffers here as well (and likely update min_buffer=
s_needed).
>
> Note that *num_buffers in this case refers to the number of buffers that
> VIDIOC_CREATE_BUFS wants to add. So the total number of buffers after thi=
s
> call is actually *num_buffers + q->num_buffers.
>

Good point, ack.

> > +             }
> > +
> > +             return 0;
> > +     }
> > +
> > +     switch (q->type) {
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +             sizes[0] =3D amvdec_get_output_size(sess);
> > +             *num_planes =3D 1;
> > +             break;
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +             switch (sess->pixfmt_cap) {
> > +             case V4L2_PIX_FMT_NV12M:
> > +                     sizes[0] =3D output_size;
> > +                     sizes[1] =3D output_size / 2;
> > +                     *num_planes =3D 2;
> > +                     break;
> > +             case V4L2_PIX_FMT_YUV420M:
> > +                     sizes[0] =3D output_size;
> > +                     sizes[1] =3D output_size / 4;
> > +                     sizes[2] =3D output_size / 4;
> > +                     *num_planes =3D 3;
> > +                     break;
> > +             default:
> > +                     return -EINVAL;
> > +             }
> > +             *num_buffers =3D min(max(*num_buffers, fmt_out->min_buffe=
rs),
> > +                                fmt_out->max_buffers);
>
> You can use clamp here. That's easier to read.
>

Ack

> > +             /* The HW needs all buffers to be configured during start=
up */
>
> Why? I kind of expected to see 'q->min_buffers_needed =3D fmt_out->min_bu=
ffers'
> here. I think some more information is needed here in the comment.
>

I'll extend the comments to reflect the following:

All codecs in the Amlogic vdec need the full available buffer list to
be configured at startup, i.e all buffer phy addrs must be written to
registers prior to decoding.
The firmwares then decide how they use those buffers and the
interrupts only tell me "the decoder has written a frame to buffer N=C2=B0
X".

fmt_out->min_buffers and fmt_out->max_buffers refer to the min/max
amount of buffers that can be setup during initialization. In the case
of MPEG2, the firmware expects 8 buffers, no more no less, so both
min_buffers and max_buffers have the value "8".

But even if those values differ (as for H.264 that will come later),
the firmware still expects all allocated buffers to be setup in
registers. As such, q->min_buffers_needed must reflect the total
amount of CAPTURE buffers.

> > +             q->min_buffers_needed =3D *num_buffers;
> > +             break;
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vdec_vb2_buf_queue(struct vb2_buffer *vb)
> > +{
> > +     struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +     struct amvdec_session *sess =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     struct v4l2_m2m_ctx *m2m_ctx =3D sess->m2m_ctx;
> > +
> > +     v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> > +
> > +     if (!sess->streamon_out || !sess->streamon_cap)
> > +             return;
> > +
> > +     if (vb->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> > +         vdec_codec_needs_recycle(sess))
> > +             vdec_queue_recycle(sess, vb);
> > +
> > +     schedule_work(&sess->esparser_queue_work);
> > +}
> > +
> > +static int vdec_start_streaming(struct vb2_queue *q, unsigned int coun=
t)
> > +{
> > +     struct amvdec_session *sess =3D vb2_get_drv_priv(q);
> > +     struct amvdec_core *core =3D sess->core;
> > +     struct vb2_v4l2_buffer *buf;
> > +     int ret;
> > +
> > +     if (core->cur_sess && core->cur_sess !=3D sess) {
> > +             ret =3D -EBUSY;
> > +             goto bufs_done;
> > +     }
> > +
> > +     if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +             sess->streamon_out =3D 1;
> > +     else
> > +             sess->streamon_cap =3D 1;
> > +
> > +     if (!sess->streamon_out || !sess->streamon_cap)
> > +             return 0;
> > +
> > +     sess->vififo_size =3D SIZE_VIFIFO;
> > +     sess->vififo_vaddr =3D
> > +             dma_alloc_coherent(sess->core->dev, sess->vififo_size,
> > +                                &sess->vififo_paddr, GFP_KERNEL);
> > +     if (!sess->vififo_vaddr) {
> > +             dev_err(sess->core->dev, "Failed to request VIFIFO buffer=
\n");
> > +             ret =3D -ENOMEM;
> > +             goto bufs_done;
> > +     }
> > +
> > +     sess->should_stop =3D 0;
> > +     sess->keyframe_found =3D 0;
> > +     sess->last_offset =3D 0;
> > +     sess->wrap_count =3D 0;
> > +     sess->pixelaspect.numerator =3D 1;
> > +     sess->pixelaspect.denominator =3D 1;
> > +     atomic_set(&sess->esparser_queued_bufs, 0);
> > +
> > +     ret =3D vdec_poweron(sess);
> > +     if (ret)
> > +             goto vififo_free;
> > +
> > +     sess->sequence_cap =3D 0;
> > +     if (vdec_codec_needs_recycle(sess))
> > +             sess->recycle_thread =3D kthread_run(vdec_recycle_thread,=
 sess,
> > +                                                "vdec_recycle");
> > +
> > +     core->cur_sess =3D sess;
> > +
> > +     return 0;
> > +
> > +vififo_free:
> > +     dma_free_coherent(sess->core->dev, sess->vififo_size,
> > +                       sess->vififo_vaddr, sess->vififo_paddr);
> > +bufs_done:
> > +     while ((buf =3D v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> > +             v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> > +     while ((buf =3D v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> > +             v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> > +
> > +     if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +             sess->streamon_out =3D 0;
> > +     else
> > +             sess->streamon_cap =3D 0;
> > +
> > +     return ret;
> > +}
> > +
> > +static void vdec_free_canvas(struct amvdec_session *sess)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < sess->canvas_num; ++i)
> > +             meson_canvas_free(sess->core->canvas, sess->canvas_alloc[=
i]);
> > +
> > +     sess->canvas_num =3D 0;
> > +}
> > +
> > +static void vdec_reset_timestamps(struct amvdec_session *sess)
> > +{
> > +     struct amvdec_timestamp *tmp, *n;
> > +
> > +     list_for_each_entry_safe(tmp, n, &sess->timestamps, list) {
> > +             list_del(&tmp->list);
> > +             kfree(tmp);
> > +     }
> > +}
> > +
> > +static void vdec_reset_bufs_recycle(struct amvdec_session *sess)
> > +{
> > +     struct amvdec_buffer *tmp, *n;
> > +
> > +     list_for_each_entry_safe(tmp, n, &sess->bufs_recycle, list) {
> > +             list_del(&tmp->list);
> > +             kfree(tmp);
> > +     }
> > +}
> > +
> > +static void vdec_stop_streaming(struct vb2_queue *q)
> > +{
> > +     struct amvdec_session *sess =3D vb2_get_drv_priv(q);
> > +     struct amvdec_core *core =3D sess->core;
> > +     struct vb2_v4l2_buffer *buf;
> > +
> > +     if (sess->streamon_out && sess->streamon_cap) {
> > +             if (vdec_codec_needs_recycle(sess))
> > +                     kthread_stop(sess->recycle_thread);
> > +
> > +             vdec_poweroff(sess);
> > +             vdec_free_canvas(sess);
> > +             dma_free_coherent(sess->core->dev, sess->vififo_size,
> > +                               sess->vififo_vaddr, sess->vififo_paddr)=
;
> > +             vdec_reset_timestamps(sess);
> > +             vdec_reset_bufs_recycle(sess);
> > +             kfree(sess->priv);
> > +             sess->priv =3D NULL;
> > +             core->cur_sess =3D NULL;
> > +     }
> > +
> > +     if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             while ((buf =3D v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> > +                     v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> > +
> > +             sess->streamon_out =3D 0;
> > +     } else {
> > +             while ((buf =3D v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> > +                     v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> > +
> > +             sess->streamon_cap =3D 0;
> > +     }
> > +}
> > +
> > +static const struct vb2_ops vdec_vb2_ops =3D {
> > +     .queue_setup =3D vdec_queue_setup,
> > +     .start_streaming =3D vdec_start_streaming,
> > +     .stop_streaming =3D vdec_stop_streaming,
> > +     .buf_queue =3D vdec_vb2_buf_queue,
> > +     .wait_prepare =3D vb2_ops_wait_prepare,
> > +     .wait_finish =3D vb2_ops_wait_finish,
> > +};
> > +
> > +static int
> > +vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap=
)
> > +{
> > +     strlcpy(cap->driver, "meson-vdec", sizeof(cap->driver));
> > +     strlcpy(cap->card, "Amlogic Video Decoder", sizeof(cap->card));
> > +     strlcpy(cap->bus_info, "platform:meson-vdec", sizeof(cap->bus_inf=
o));
>
> Replace all strlcpy/strcpy/strncpy by strscpy. That's the recommended fun=
ction.
>

Ack

> > +
> > +     return 0;
> > +}
> > +
> > +static const struct amvdec_format *
> > +find_format(const struct amvdec_format *fmts, u32 size, u32 pixfmt)
> > +{
> > +     unsigned int i;
> > +
> > +     for (i =3D 0; i < size; i++) {
> > +             if (fmts[i].pixfmt =3D=3D pixfmt)
> > +                     return &fmts[i];
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static unsigned int
> > +vdec_supports_pixfmt_cap(const struct amvdec_format *fmt_out, u32 pixf=
mt_cap)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; fmt_out->pixfmts_cap[i]; i++)
> > +             if (fmt_out->pixfmts_cap[i] =3D=3D pixfmt_cap)
> > +                     return 1;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct amvdec_format *
> > +vdec_try_fmt_common(struct amvdec_session *sess, u32 size,
> > +                 struct v4l2_format *f)
> > +{
> > +     struct v4l2_pix_format_mplane *pixmp =3D &f->fmt.pix_mp;
> > +     struct v4l2_plane_pix_format *pfmt =3D pixmp->plane_fmt;
> > +     const struct amvdec_format *fmts =3D sess->core->platform->format=
s;
> > +     const struct amvdec_format *fmt_out;
> > +
> > +     memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
> > +     memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             fmt_out =3D find_format(fmts, size, pixmp->pixelformat);
> > +             if (!fmt_out) {
> > +                     pixmp->pixelformat =3D V4L2_PIX_FMT_MPEG2;
> > +                     fmt_out =3D find_format(fmts, size, pixmp->pixelf=
ormat);
> > +             }
> > +
> > +             pfmt[0].sizeimage =3D
> > +                     get_output_size(pixmp->width, pixmp->height);
> > +             pfmt[0].bytesperline =3D 0;
> > +             pixmp->num_planes =3D 1;
> > +     } else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +             fmt_out =3D sess->fmt_out;
> > +             if (!vdec_supports_pixfmt_cap(fmt_out, pixmp->pixelformat=
))
> > +                     pixmp->pixelformat =3D fmt_out->pixfmts_cap[0];
> > +
> > +             memset(pfmt[1].reserved, 0, sizeof(pfmt[1].reserved));
> > +             if (pixmp->pixelformat =3D=3D V4L2_PIX_FMT_NV12M) {
> > +                     pfmt[0].sizeimage =3D
> > +                             get_output_size(pixmp->width, pixmp->heig=
ht);
> > +                     pfmt[0].bytesperline =3D ALIGN(pixmp->width, 64);
> > +
> > +                     pfmt[1].sizeimage =3D
> > +                           get_output_size(pixmp->width, pixmp->height=
) / 2;
> > +                     pfmt[1].bytesperline =3D ALIGN(pixmp->width, 64);
> > +                     pixmp->num_planes =3D 2;
> > +             } else if (pixmp->pixelformat =3D=3D V4L2_PIX_FMT_YUV420M=
) {
> > +                     pfmt[0].sizeimage =3D
> > +                             get_output_size(pixmp->width, pixmp->heig=
ht);
> > +                     pfmt[0].bytesperline =3D ALIGN(pixmp->width, 64);
> > +
> > +                     pfmt[1].sizeimage =3D
> > +                           get_output_size(pixmp->width, pixmp->height=
) / 4;
> > +                     pfmt[1].bytesperline =3D ALIGN(pixmp->width, 64) =
/ 2;
> > +
> > +                     pfmt[2].sizeimage =3D
> > +                           get_output_size(pixmp->width, pixmp->height=
) / 4;
> > +                     pfmt[2].bytesperline =3D ALIGN(pixmp->width, 64) =
/ 2;
> > +                     pixmp->num_planes =3D 3;
> > +             }
> > +     } else {
> > +             return NULL;
> > +     }
> > +
> > +     pixmp->width  =3D clamp(pixmp->width,  (u32)256, fmt_out->max_wid=
th);
> > +     pixmp->height =3D clamp(pixmp->height, (u32)144, fmt_out->max_hei=
ght);
> > +
> > +     if (pixmp->field =3D=3D V4L2_FIELD_ANY)
> > +             pixmp->field =3D V4L2_FIELD_NONE;
> > +
> > +     return fmt_out;
> > +}
> > +
> > +static int vdec_try_fmt(struct file *file, void *fh, struct v4l2_forma=
t *f)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +
> > +     vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format =
*f)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +     struct v4l2_pix_format_mplane *pixmp =3D &f->fmt.pix_mp;
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +             pixmp->pixelformat =3D sess->pixfmt_cap;
> > +     else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +             pixmp->pixelformat =3D sess->fmt_out->pixfmt;
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +             pixmp->width =3D sess->width;
> > +             pixmp->height =3D sess->height;
> > +             pixmp->colorspace =3D sess->colorspace;
> > +             pixmp->ycbcr_enc =3D sess->ycbcr_enc;
> > +             pixmp->quantization =3D sess->quantization;
> > +             pixmp->xfer_func =3D sess->xfer_func;
> > +     } else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             pixmp->width =3D sess->width;
> > +             pixmp->height =3D sess->height;
> > +     }
> > +
> > +     vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format =
*f)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +     struct v4l2_pix_format_mplane *pixmp =3D &f->fmt.pix_mp;
> > +     u32 num_formats =3D sess->core->platform->num_formats;
> > +     const struct amvdec_format *fmt_out;
> > +     struct v4l2_pix_format_mplane orig_pixmp;
> > +     struct v4l2_format format;
> > +     u32 pixfmt_out =3D 0, pixfmt_cap =3D 0;
> > +
> > +     orig_pixmp =3D *pixmp;
> > +
> > +     fmt_out =3D vdec_try_fmt_common(sess, num_formats, f);
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             pixfmt_out =3D pixmp->pixelformat;
> > +             pixfmt_cap =3D sess->pixfmt_cap;
> > +     } else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +             pixfmt_cap =3D pixmp->pixelformat;
> > +             pixfmt_out =3D sess->fmt_out->pixfmt;
> > +     }
> > +
> > +     memset(&format, 0, sizeof(format));
> > +
> > +     format.type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +     format.fmt.pix_mp.pixelformat =3D pixfmt_out;
> > +     format.fmt.pix_mp.width =3D orig_pixmp.width;
> > +     format.fmt.pix_mp.height =3D orig_pixmp.height;
> > +     vdec_try_fmt_common(sess, num_formats, &format);
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             sess->width =3D format.fmt.pix_mp.width;
> > +             sess->height =3D format.fmt.pix_mp.height;
> > +             sess->colorspace =3D pixmp->colorspace;
> > +             sess->ycbcr_enc =3D pixmp->ycbcr_enc;
> > +             sess->quantization =3D pixmp->quantization;
> > +             sess->xfer_func =3D pixmp->xfer_func;
> > +     }
> > +
> > +     memset(&format, 0, sizeof(format));
> > +
> > +     format.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +     format.fmt.pix_mp.pixelformat =3D pixfmt_cap;
> > +     format.fmt.pix_mp.width =3D orig_pixmp.width;
> > +     format.fmt.pix_mp.height =3D orig_pixmp.height;
> > +     vdec_try_fmt_common(sess, num_formats, &format);
> > +
> > +     sess->width =3D format.fmt.pix_mp.width;
> > +     sess->height =3D format.fmt.pix_mp.height;
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +             sess->fmt_out =3D fmt_out;
> > +     else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +             sess->pixfmt_cap =3D format.fmt.pix_mp.pixelformat;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtd=
esc *f)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +     const struct vdec_platform *platform =3D sess->core->platform;
> > +     const struct amvdec_format *fmt_out;
> > +
> > +     memset(f->reserved, 0, sizeof(f->reserved));
> > +
> > +     if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +             if (f->index >=3D platform->num_formats)
> > +                     return -EINVAL;
> > +
> > +             fmt_out =3D &platform->formats[f->index];
> > +             f->pixelformat =3D fmt_out->pixfmt;
> > +     } else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +             fmt_out =3D sess->fmt_out;
> > +             if (f->index >=3D 4 || !fmt_out->pixfmts_cap[f->index])
> > +                     return -EINVAL;
> > +
> > +             f->pixelformat =3D fmt_out->pixfmts_cap[f->index];
> > +     } else {
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_enum_framesizes(struct file *file, void *fh,
> > +                             struct v4l2_frmsizeenum *fsize)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +     const struct amvdec_format *formats =3D sess->core->platform->for=
mats;
> > +     const struct amvdec_format *fmt;
> > +     u32 num_formats =3D sess->core->platform->num_formats;
> > +
> > +     fmt =3D find_format(formats, num_formats, fsize->pixel_format);
> > +     if (!fmt || fsize->index)
> > +             return -EINVAL;
> > +
> > +     fsize->type =3D V4L2_FRMSIZE_TYPE_STEPWISE;
> > +
> > +     fsize->stepwise.min_width =3D 256;
> > +     fsize->stepwise.max_width =3D fmt->max_width;
> > +     fsize->stepwise.step_width =3D 1;
> > +     fsize->stepwise.min_height =3D 144;
> > +     fsize->stepwise.max_height =3D fmt->max_height;
> > +     fsize->stepwise.step_height =3D 1;
> > +
> > +     return 0;
> > +}
> > +
> > +static int
> > +vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_=
cmd *cmd)
> > +{
> > +     switch (cmd->cmd) {
> > +     case V4L2_DEC_CMD_STOP:
> > +             if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> > +                     return -EINVAL;
> > +             break;
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int
> > +vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd =
*cmd)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +     struct amvdec_codec_ops *codec_ops =3D sess->fmt_out->codec_ops;
> > +     struct device *dev =3D sess->core->dev;
> > +     int ret;
> > +
> > +     ret =3D vdec_try_decoder_cmd(file, fh, cmd);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!(sess->streamon_out & sess->streamon_cap))
> > +             return 0;
> > +
> > +     dev_dbg(dev, "Received V4L2_DEC_CMD_STOP\n");
> > +     sess->should_stop =3D 1;
> > +
> > +     vdec_wait_inactive(sess);
> > +
> > +     if (codec_ops->drain) {
> > +             codec_ops->drain(sess);
> > +     } else if (codec_ops->eos_sequence) {
> > +             u32 len;
> > +             const u8 *data =3D codec_ops->eos_sequence(&len);
> > +
> > +             esparser_queue_eos(sess->core, data, len);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int vdec_subscribe_event(struct v4l2_fh *fh,
> > +                             const struct v4l2_event_subscription *sub=
)
> > +{
> > +     switch (sub->type) {
> > +     case V4L2_EVENT_EOS:
> > +             return v4l2_event_subscribe(fh, sub, 2, NULL);
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
> > +
> > +static int vdec_cropcap(struct file *file, void *fh,
> > +                     struct v4l2_cropcap *crop)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +
> > +     if (crop->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +             return -EINVAL;
> > +
> > +     crop->pixelaspect =3D sess->pixelaspect;
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_ioctl_ops vdec_ioctl_ops =3D {
> > +     .vidioc_querycap =3D vdec_querycap,
> > +     .vidioc_enum_fmt_vid_cap_mplane =3D vdec_enum_fmt,
> > +     .vidioc_enum_fmt_vid_out_mplane =3D vdec_enum_fmt,
> > +     .vidioc_s_fmt_vid_cap_mplane =3D vdec_s_fmt,
> > +     .vidioc_s_fmt_vid_out_mplane =3D vdec_s_fmt,
> > +     .vidioc_g_fmt_vid_cap_mplane =3D vdec_g_fmt,
> > +     .vidioc_g_fmt_vid_out_mplane =3D vdec_g_fmt,
> > +     .vidioc_try_fmt_vid_cap_mplane =3D vdec_try_fmt,
> > +     .vidioc_try_fmt_vid_out_mplane =3D vdec_try_fmt,
> > +     .vidioc_reqbufs =3D v4l2_m2m_ioctl_reqbufs,
> > +     .vidioc_querybuf =3D v4l2_m2m_ioctl_querybuf,
> > +     .vidioc_create_bufs =3D v4l2_m2m_ioctl_create_bufs,
> > +     .vidioc_prepare_buf =3D v4l2_m2m_ioctl_prepare_buf,
> > +     .vidioc_qbuf =3D v4l2_m2m_ioctl_qbuf,
> > +     .vidioc_expbuf =3D v4l2_m2m_ioctl_expbuf,
> > +     .vidioc_dqbuf =3D v4l2_m2m_ioctl_dqbuf,
> > +     .vidioc_streamon =3D v4l2_m2m_ioctl_streamon,
> > +     .vidioc_streamoff =3D v4l2_m2m_ioctl_streamoff,
> > +     .vidioc_enum_framesizes =3D vdec_enum_framesizes,
> > +     .vidioc_subscribe_event =3D vdec_subscribe_event,
> > +     .vidioc_unsubscribe_event =3D v4l2_event_unsubscribe,
> > +     .vidioc_try_decoder_cmd =3D vdec_try_decoder_cmd,
> > +     .vidioc_decoder_cmd =3D vdec_decoder_cmd,
> > +     .vidioc_cropcap =3D vdec_cropcap,
> > +};
> > +
> > +static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> > +                       struct vb2_queue *dst_vq)
> > +{
> > +     struct amvdec_session *sess =3D priv;
> > +     int ret;
> > +
> > +     src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +     src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +     src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +     src_vq->ops =3D &vdec_vb2_ops;
> > +     src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +     src_vq->drv_priv =3D sess;
> > +     src_vq->buf_struct_size =3D sizeof(struct dummy_buf);
> > +     src_vq->min_buffers_needed =3D 1;
> > +     src_vq->dev =3D sess->core->dev;
> > +     src_vq->lock =3D &sess->lock;
> > +     ret =3D vb2_queue_init(src_vq);
> > +     if (ret)
> > +             return ret;
> > +
> > +     dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +     dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +     dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +     dst_vq->ops =3D &vdec_vb2_ops;
> > +     dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +     dst_vq->drv_priv =3D sess;
> > +     dst_vq->buf_struct_size =3D sizeof(struct dummy_buf);
> > +     dst_vq->min_buffers_needed =3D 1;
> > +     dst_vq->dev =3D sess->core->dev;
> > +     dst_vq->lock =3D &sess->lock;
> > +     ret =3D vb2_queue_init(dst_vq);
> > +     if (ret) {
> > +             vb2_queue_release(src_vq);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdec_open(struct file *file)
> > +{
> > +     struct amvdec_core *core =3D video_drvdata(file);
> > +     struct device *dev =3D core->dev;
> > +     const struct amvdec_format *formats =3D core->platform->formats;
> > +     struct amvdec_session *sess;
> > +     int ret;
> > +
> > +     sess =3D kzalloc(sizeof(*sess), GFP_KERNEL);
> > +     if (!sess)
> > +             return -ENOMEM;
> > +
> > +     sess->core =3D core;
> > +
> > +     sess->m2m_dev =3D v4l2_m2m_init(&vdec_m2m_ops);
> > +     if (IS_ERR(sess->m2m_dev)) {
> > +             dev_err(dev, "Fail to v4l2_m2m_init\n");
> > +             ret =3D PTR_ERR(sess->m2m_dev);
> > +             goto err_free_sess;
> > +     }
> > +
> > +     sess->m2m_ctx =3D v4l2_m2m_ctx_init(sess->m2m_dev, sess, m2m_queu=
e_init);
> > +     if (IS_ERR(sess->m2m_ctx)) {
> > +             dev_err(dev, "Fail to v4l2_m2m_ctx_init\n");
> > +             ret =3D PTR_ERR(sess->m2m_ctx);
> > +             goto err_m2m_release;
> > +     }
> > +
> > +     sess->pixfmt_cap =3D formats[0].pixfmts_cap[0];
> > +     sess->fmt_out =3D &formats[0];
> > +     sess->width =3D 1280;
> > +     sess->height =3D 720;
> > +     sess->pixelaspect.numerator =3D 1;
> > +     sess->pixelaspect.denominator =3D 1;
> > +
> > +     INIT_LIST_HEAD(&sess->timestamps);
> > +     INIT_LIST_HEAD(&sess->bufs_recycle);
> > +     INIT_WORK(&sess->esparser_queue_work, esparser_queue_all_src);
> > +     mutex_init(&sess->lock);
> > +     mutex_init(&sess->bufs_recycle_lock);
> > +     spin_lock_init(&sess->ts_spinlock);
> > +
> > +     v4l2_fh_init(&sess->fh, core->vdev_dec);
> > +     v4l2_fh_add(&sess->fh);
> > +     sess->fh.m2m_ctx =3D sess->m2m_ctx;
> > +     file->private_data =3D &sess->fh;
> > +
> > +     return 0;
> > +
> > +err_m2m_release:
> > +     v4l2_m2m_release(sess->m2m_dev);
> > +err_free_sess:
> > +     kfree(sess);
> > +     return ret;
> > +}
> > +
> > +static int vdec_close(struct file *file)
> > +{
> > +     struct amvdec_session *sess =3D
> > +             container_of(file->private_data, struct amvdec_session, f=
h);
> > +
> > +     v4l2_m2m_ctx_release(sess->m2m_ctx);
> > +     v4l2_m2m_release(sess->m2m_dev);
> > +     v4l2_fh_del(&sess->fh);
> > +     v4l2_fh_exit(&sess->fh);
> > +
> > +     mutex_destroy(&sess->lock);
> > +     mutex_destroy(&sess->bufs_recycle_lock);
> > +
> > +     kfree(sess);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations vdec_fops =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .open =3D vdec_open,
> > +     .release =3D vdec_close,
> > +     .unlocked_ioctl =3D video_ioctl2,
> > +     .poll =3D v4l2_m2m_fop_poll,
> > +     .mmap =3D v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static irqreturn_t vdec_isr(int irq, void *data)
> > +{
> > +     struct amvdec_core *core =3D data;
> > +     struct amvdec_session *sess =3D core->cur_sess;
> > +
> > +     sess->last_irq_jiffies =3D get_jiffies_64();
> > +
> > +     return sess->fmt_out->codec_ops->isr(sess);
> > +}
> > +
> > +static irqreturn_t vdec_threaded_isr(int irq, void *data)
> > +{
> > +     struct amvdec_core *core =3D data;
> > +     struct amvdec_session *sess =3D core->cur_sess;
> > +
> > +     return sess->fmt_out->codec_ops->threaded_isr(sess);
> > +}
> > +
> > +static const struct of_device_id vdec_dt_match[] =3D {
> > +     { .compatible =3D "amlogic,gxbb-vdec",
> > +       .data =3D &vdec_platform_gxbb },
> > +     { .compatible =3D "amlogic,gxm-vdec",
> > +       .data =3D &vdec_platform_gxm },
> > +     { .compatible =3D "amlogic,gxl-vdec",
> > +       .data =3D &vdec_platform_gxl },
> > +     {}
> > +};
> > +MODULE_DEVICE_TABLE(of, vdec_dt_match);
> > +
> > +static int vdec_probe(struct platform_device *pdev)
> > +{
> > +     struct device *dev =3D &pdev->dev;
> > +     struct video_device *vdev;
> > +     struct amvdec_core *core;
> > +     struct resource *r;
> > +     const struct of_device_id *of_id;
> > +     int irq;
> > +     int ret;
> > +
> > +     core =3D devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> > +     if (!core)
> > +             return -ENOMEM;
> > +
> > +     core->dev =3D dev;
> > +     platform_set_drvdata(pdev, core);
> > +
> > +     r =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "dos");
> > +     core->dos_base =3D devm_ioremap_resource(dev, r);
> > +     if (IS_ERR(core->dos_base)) {
> > +             dev_err(dev, "Couldn't remap DOS memory\n");
> > +             return PTR_ERR(core->dos_base);
> > +     }
> > +
> > +     r =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "esparse=
r");
> > +     core->esparser_base =3D devm_ioremap_resource(dev, r);
> > +     if (IS_ERR(core->esparser_base)) {
> > +             dev_err(dev, "Couldn't remap ESPARSER memory\n");
> > +             return PTR_ERR(core->esparser_base);
> > +     }
> > +
> > +     core->regmap_ao =3D syscon_regmap_lookup_by_phandle(dev->of_node,
> > +                                                      "amlogic,ao-sysc=
trl");
> > +     if (IS_ERR(core->regmap_ao)) {
> > +             dev_err(dev, "Couldn't regmap AO sysctrl\n");
> > +             return PTR_ERR(core->regmap_ao);
> > +     }
> > +
> > +     core->canvas =3D meson_canvas_get(dev);
> > +     if (!core->canvas)
> > +             return PTR_ERR(core->canvas);
> > +
> > +     core->dos_parser_clk =3D devm_clk_get(dev, "dos_parser");
> > +     if (IS_ERR(core->dos_parser_clk))
> > +             return -EPROBE_DEFER;
> > +
> > +     core->dos_clk =3D devm_clk_get(dev, "dos");
> > +     if (IS_ERR(core->dos_clk))
> > +             return -EPROBE_DEFER;
> > +
> > +     core->vdec_1_clk =3D devm_clk_get(dev, "vdec_1");
> > +     if (IS_ERR(core->vdec_1_clk))
> > +             return -EPROBE_DEFER;
> > +
> > +     core->vdec_hevc_clk =3D devm_clk_get(dev, "vdec_hevc");
> > +     if (IS_ERR(core->vdec_hevc_clk))
> > +             return -EPROBE_DEFER;
> > +
> > +     irq =3D platform_get_irq_byname(pdev, "vdec");
> > +     if (irq < 0)
> > +             return irq;
> > +
> > +     ret =3D devm_request_threaded_irq(core->dev, irq, vdec_isr,
> > +                                     vdec_threaded_isr, IRQF_ONESHOT,
> > +                                     "vdec", core);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D esparser_init(pdev, core);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D v4l2_device_register(dev, &core->v4l2_dev);
> > +     if (ret) {
> > +             dev_err(dev, "Couldn't register v4l2 device\n");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     vdev =3D video_device_alloc();
> > +     if (!vdev) {
> > +             ret =3D -ENOMEM;
> > +             goto err_vdev_release;
> > +     }
> > +
> > +     of_id =3D of_match_node(vdec_dt_match, dev->of_node);
> > +     core->platform =3D of_id->data;
> > +     core->vdev_dec =3D vdev;
> > +     core->dev_dec =3D dev;
> > +     mutex_init(&core->lock);
> > +
> > +     strlcpy(vdev->name, "meson-video-decoder", sizeof(vdev->name));
> > +     vdev->release =3D video_device_release;
> > +     vdev->fops =3D &vdec_fops;
> > +     vdev->ioctl_ops =3D &vdec_ioctl_ops;
> > +     vdev->vfl_dir =3D VFL_DIR_M2M;
> > +     vdev->v4l2_dev =3D &core->v4l2_dev;
> > +     vdev->lock =3D &core->lock;
> > +     vdev->device_caps =3D V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAM=
ING;
> > +
> > +     video_set_drvdata(vdev, core);
> > +
> > +     ret =3D video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +     if (ret) {
> > +             dev_err(dev, "Failed registering video device\n");
> > +             goto err_vdev_release;
> > +     }
> > +
> > +     return 0;
> > +
> > +err_vdev_release:
> > +     video_device_release(vdev);
> > +     return ret;
> > +}
> > +
> > +static int vdec_remove(struct platform_device *pdev)
> > +{
> > +     struct amvdec_core *core =3D platform_get_drvdata(pdev);
> > +
> > +     video_unregister_device(core->vdev_dec);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct platform_driver meson_vdec_driver =3D {
> > +     .probe =3D vdec_probe,
> > +     .remove =3D vdec_remove,
> > +     .driver =3D {
> > +             .name =3D "meson-vdec",
> > +             .of_match_table =3D vdec_dt_match,
> > +     },
> > +};
> > +module_platform_driver(meson_vdec_driver);
> > +
> > +MODULE_DESCRIPTION("Meson video decoder driver for GXBB/GXL/GXM");
> > +MODULE_AUTHOR("Maxime Jourdan <mjourdan@baylibre.com>");
> > +MODULE_LICENSE("GPL");
>
> <snip>
>
> Regards,
>
>         Hans

Cheers,
Maxime
