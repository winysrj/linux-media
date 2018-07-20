Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42667 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728830AbeGTJ0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 05:26:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id f1-v6so8824144ljc.9
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2018 01:39:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bb261d65-ef34-cac2-b05b-5c60aee95a18@xs4all.nl>
References: <20180719121353.20021-1-hverkuil@xs4all.nl> <20180720065901.56269-1-keiichiw@chromium.org>
 <bb261d65-ef34-cac2-b05b-5c60aee95a18@xs4all.nl>
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Fri, 20 Jul 2018 17:39:34 +0900
Message-ID: <CAD90VcZqHh8Zh2cuT3T+w5rAGDJyEYMbZExwwPn6spKHC8xDDA@mail.gmail.com>
Subject: Re: [PATCH 6/5] vicodec: Support multi-planar APIs
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 20, 2018 at 5:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 07/20/2018 08:59 AM, Keiichi Watanabe wrote:
>> Support multi-planar APIs in the virtual codec driver.
>> Multi-planar APIs are enabled by the module parameter 'multiplanar'.
>>
>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>
> Thank you for contributing this code! I've folded it into patch series
> (I just posted v2) and added a Co-Developed-by tag.
>
Thanks, Hans! That sounds good.

> BTW, for future reference: always run v4l2-compliance after making driver
> changes. It caught a bunch of missing checks in this code. I've fixed those,
> but you should always check V4L2 driver changes with v4l2-compliance.
>
Sorry for the inconvenience. I'll use v4l2-compliance next time.

Best regards,
Keiichi

> Regards,
>
>         Hans
>
>> ---
>>  drivers/media/platform/vicodec/vicodec-core.c | 219 ++++++++++++++----
>>  1 file changed, 171 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
>> index 12c12cb0c1c0..1717f44e1743 100644
>> --- a/drivers/media/platform/vicodec/vicodec-core.c
>> +++ b/drivers/media/platform/vicodec/vicodec-core.c
>> @@ -29,6 +29,11 @@ MODULE_DESCRIPTION("Virtual codec device");
>>  MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
>>  MODULE_LICENSE("GPL v2");
>>
>> +static bool multiplanar;
>> +module_param(multiplanar, bool, 0444);
>> +MODULE_PARM_DESC(multiplanar,
>> +              " use multi-planar API instead of single-planar API");
>> +
>>  static unsigned int debug;
>>  module_param(debug, uint, 0644);
>>  MODULE_PARM_DESC(debug, "activates debug info");
>> @@ -135,8 +140,10 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
>>  {
>>       switch (type) {
>>       case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>               return &ctx->q_data[V4L2_M2M_SRC];
>>       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>               return &ctx->q_data[V4L2_M2M_DST];
>>       default:
>>               WARN_ON(1);
>> @@ -530,7 +537,10 @@ static int vidioc_querycap(struct file *file, void *priv,
>>       strncpy(cap->card, VICODEC_NAME, sizeof(cap->card) - 1);
>>       snprintf(cap->bus_info, sizeof(cap->bus_info),
>>                       "platform:%s", VICODEC_NAME);
>> -     cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>> +     cap->device_caps =  V4L2_CAP_STREAMING |
>> +                         (multiplanar ?
>> +                          V4L2_CAP_VIDEO_M2M_MPLANE :
>> +                          V4L2_CAP_VIDEO_M2M);
>>       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>       return 0;
>>  }
>> @@ -576,20 +586,44 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>>
>>       q_data = get_q_data(ctx, f->type);
>>
>> -     f->fmt.pix.width        = q_data->width;
>> -     f->fmt.pix.height       = q_data->height;
>> -     f->fmt.pix.field        = V4L2_FIELD_NONE;
>> -     f->fmt.pix.pixelformat  = q_data->fourcc;
>> -     if (q_data->fourcc == V4L2_PIX_FMT_FWHT)
>> -             f->fmt.pix.bytesperline = 0;
>> -     else
>> -             f->fmt.pix.bytesperline = q_data->width;
>> -     f->fmt.pix.sizeimage    = q_data->sizeimage;
>> -     f->fmt.pix.colorspace   = ctx->colorspace;
>> -     f->fmt.pix.xfer_func    = ctx->xfer_func;
>> -     f->fmt.pix.ycbcr_enc    = ctx->ycbcr_enc;
>> -     f->fmt.pix.quantization = ctx->quantization;
>> +     switch (f->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             f->fmt.pix.width        = q_data->width;
>> +             f->fmt.pix.height       = q_data->height;
>> +             f->fmt.pix.field        = V4L2_FIELD_NONE;
>> +             f->fmt.pix.pixelformat  = q_data->fourcc;
>> +             if (q_data->fourcc == V4L2_PIX_FMT_FWHT)
>> +                     f->fmt.pix.bytesperline = 0;
>> +             else
>> +                     f->fmt.pix.bytesperline = q_data->width;
>> +             f->fmt.pix.sizeimage    = q_data->sizeimage;
>> +             f->fmt.pix.colorspace   = ctx->colorspace;
>> +             f->fmt.pix.xfer_func    = ctx->xfer_func;
>> +             f->fmt.pix.ycbcr_enc    = ctx->ycbcr_enc;
>> +             f->fmt.pix.quantization = ctx->quantization;
>> +             break;
>>
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +             f->fmt.pix_mp.width     = q_data->width;
>> +             f->fmt.pix_mp.height    = q_data->height;
>> +             f->fmt.pix_mp.field     = V4L2_FIELD_NONE;
>> +             f->fmt.pix_mp.pixelformat       = q_data->fourcc;
>> +             f->fmt.pix_mp.num_planes        = 1;
>> +             if (q_data->fourcc == V4L2_PIX_FMT_FWHT)
>> +                     f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
>> +             else
>> +                     f->fmt.pix_mp.plane_fmt[0].bytesperline = q_data->width;
>> +             f->fmt.pix_mp.plane_fmt[0].sizeimage = q_data->sizeimage;
>> +             f->fmt.pix_mp.colorspace        = ctx->colorspace;
>> +             f->fmt.pix_mp.xfer_func = ctx->xfer_func;
>> +             f->fmt.pix_mp.ycbcr_enc = ctx->ycbcr_enc;
>> +             f->fmt.pix_mp.quantization      = ctx->quantization;
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>>       return 0;
>>  }
>>
>> @@ -607,16 +641,41 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>
>>  static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>>  {
>> -     struct v4l2_pix_format *pix = &f->fmt.pix;
>> -
>> -     pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
>> -     pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
>> -     pix->bytesperline = pix->width;
>> -     pix->sizeimage = pix->width * pix->height * 3 / 2;
>> -     pix->field = V4L2_FIELD_NONE;
>> -     if (pix->pixelformat == V4L2_PIX_FMT_FWHT) {
>> -             pix->bytesperline = 0;
>> -             pix->sizeimage += sizeof(struct cframe_hdr);
>> +     struct v4l2_pix_format *pix;
>> +     struct v4l2_pix_format_mplane *pix_mp;
>> +
>> +     switch (f->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             pix = &f->fmt.pix;
>> +             pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
>> +             pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
>> +             pix->bytesperline = pix->width;
>> +             pix->sizeimage = pix->width * pix->height * 3 / 2;
>> +             pix->field = V4L2_FIELD_NONE;
>> +             if (pix->pixelformat == V4L2_PIX_FMT_FWHT) {
>> +                     pix->bytesperline = 0;
>> +                     pix->sizeimage += sizeof(struct cframe_hdr);
>> +             }
>> +             break;
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +             pix_mp = &f->fmt.pix_mp;
>> +             pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
>> +             pix_mp->height =
>> +                     clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
>> +             pix_mp->plane_fmt[0].bytesperline = pix_mp->width;
>> +             pix_mp->plane_fmt[0].sizeimage =
>> +                     pix_mp->width * pix_mp->height * 3 / 2;
>> +             pix_mp->field = V4L2_FIELD_NONE;
>> +             if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT) {
>> +                     pix_mp->plane_fmt[0].bytesperline = 0;
>> +                     pix_mp->plane_fmt[0].sizeimage +=
>> +                                     sizeof(struct cframe_hdr);
>> +             }
>> +             break;
>> +     default:
>> +             return -EINVAL;
>>       }
>>
>>       return 0;
>> @@ -627,12 +686,26 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>>  {
>>       struct vicodec_ctx *ctx = file2ctx(file);
>>
>> -     f->fmt.pix.pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> -                             find_fmt(f->fmt.pix.pixelformat);
>> -     f->fmt.pix.colorspace = ctx->colorspace;
>> -     f->fmt.pix.xfer_func = ctx->xfer_func;
>> -     f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
>> -     f->fmt.pix.quantization = ctx->quantization;
>> +     switch (f->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +             f->fmt.pix.pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> +                                     find_fmt(f->fmt.pix.pixelformat);
>> +             f->fmt.pix.colorspace = ctx->colorspace;
>> +             f->fmt.pix.xfer_func = ctx->xfer_func;
>> +             f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
>> +             f->fmt.pix.quantization = ctx->quantization;
>> +             break;
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +             f->fmt.pix_mp.pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> +             find_fmt(f->fmt.pix_mp.pixelformat);
>> +             f->fmt.pix_mp.colorspace = ctx->colorspace;
>> +             f->fmt.pix_mp.xfer_func = ctx->xfer_func;
>> +             f->fmt.pix_mp.ycbcr_enc = ctx->ycbcr_enc;
>> +             f->fmt.pix_mp.quantization = ctx->quantization;
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>>
>>       return vidioc_try_fmt(ctx, f);
>>  }
>> @@ -642,10 +715,22 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
>>  {
>>       struct vicodec_ctx *ctx = file2ctx(file);
>>
>> -     f->fmt.pix.pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> -                             find_fmt(f->fmt.pix.pixelformat);
>> -     if (!f->fmt.pix.colorspace)
>> -             f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
>> +     switch (f->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             f->fmt.pix.pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> +                                     find_fmt(f->fmt.pix.pixelformat);
>> +             if (!f->fmt.pix.colorspace)
>> +                     f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
>> +             break;
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +             f->fmt.pix_mp.pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
>> +                                     find_fmt(f->fmt.pix_mp.pixelformat);
>> +             if (!f->fmt.pix_mp.colorspace)
>> +                     f->fmt.pix_mp.colorspace = V4L2_COLORSPACE_REC709;
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>>
>>       return vidioc_try_fmt(ctx, f);
>>  }
>> @@ -664,18 +749,42 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>>       if (!q_data)
>>               return -EINVAL;
>>
>> -     if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>> -             fmt_changed = q_data->fourcc != f->fmt.pix.pixelformat ||
>> -                           q_data->width != f->fmt.pix.width ||
>> -                           q_data->height != f->fmt.pix.height;
>> -
>> -     if (vb2_is_busy(vq) && fmt_changed)
>> -             return -EBUSY;
>> -
>> -     q_data->fourcc          = f->fmt.pix.pixelformat;
>> -     q_data->width           = f->fmt.pix.width;
>> -     q_data->height          = f->fmt.pix.height;
>> -     q_data->sizeimage       = f->fmt.pix.sizeimage;
>> +     switch (f->type) {
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>> +             if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>> +                     fmt_changed =
>> +                             q_data->fourcc != f->fmt.pix.pixelformat ||
>> +                             q_data->width != f->fmt.pix.width ||
>> +                             q_data->height != f->fmt.pix.height;
>> +
>> +             if (vb2_is_busy(vq) && fmt_changed)
>> +                     return -EBUSY;
>> +
>> +             q_data->fourcc          = f->fmt.pix.pixelformat;
>> +             q_data->width           = f->fmt.pix.width;
>> +             q_data->height          = f->fmt.pix.height;
>> +             q_data->sizeimage       = f->fmt.pix.sizeimage;
>> +             break;
>> +     case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +     case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +             if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
>> +                     fmt_changed =
>> +                             q_data->fourcc != f->fmt.pix_mp.pixelformat ||
>> +                             q_data->width != f->fmt.pix_mp.width ||
>> +                             q_data->height != f->fmt.pix_mp.height;
>> +
>> +             if (vb2_is_busy(vq) && fmt_changed)
>> +                     return -EBUSY;
>> +
>> +             q_data->fourcc          = f->fmt.pix_mp.pixelformat;
>> +             q_data->width           = f->fmt.pix_mp.width;
>> +             q_data->height          = f->fmt.pix_mp.height;
>> +             q_data->sizeimage       = f->fmt.pix_mp.plane_fmt[0].sizeimage;
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>>
>>       dprintk(ctx->dev,
>>               "Setting format for type %d, wxh: %dx%d, fourcc: %08x\n",
>> @@ -832,11 +941,21 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
>>       .vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
>>       .vidioc_s_fmt_vid_cap   = vidioc_s_fmt_vid_cap,
>>
>> +     .vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap,
>> +     .vidioc_g_fmt_vid_cap_mplane    = vidioc_g_fmt_vid_cap,
>> +     .vidioc_try_fmt_vid_cap_mplane  = vidioc_try_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap_mplane    = vidioc_s_fmt_vid_cap,
>> +
>>       .vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
>>       .vidioc_g_fmt_vid_out   = vidioc_g_fmt_vid_out,
>>       .vidioc_try_fmt_vid_out = vidioc_try_fmt_vid_out,
>>       .vidioc_s_fmt_vid_out   = vidioc_s_fmt_vid_out,
>>
>> +     .vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out,
>> +     .vidioc_g_fmt_vid_out_mplane    = vidioc_g_fmt_vid_out,
>> +     .vidioc_try_fmt_vid_out_mplane  = vidioc_try_fmt_vid_out,
>> +     .vidioc_s_fmt_vid_out_mplane    = vidioc_s_fmt_vid_out,
>> +
>>       .vidioc_reqbufs         = v4l2_m2m_ioctl_reqbufs,
>>       .vidioc_querybuf        = v4l2_m2m_ioctl_querybuf,
>>       .vidioc_qbuf            = v4l2_m2m_ioctl_qbuf,
>> @@ -1002,7 +1121,9 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>>       struct vicodec_ctx *ctx = priv;
>>       int ret;
>>
>> -     src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +     src_vq->type = (multiplanar ?
>> +                     V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
>> +                     V4L2_BUF_TYPE_VIDEO_OUTPUT);
>>       src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>>       src_vq->drv_priv = ctx;
>>       src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> @@ -1016,7 +1137,9 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>>       if (ret)
>>               return ret;
>>
>> -     dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     dst_vq->type = (multiplanar ?
>> +                     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
>> +                     V4L2_BUF_TYPE_VIDEO_CAPTURE);
>>       dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>>       dst_vq->drv_priv = ctx;
>>       dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> --
>> 2.18.0.233.g985f88cf7e-goog
>>
>> This is an additional patch to Hans's patch series of the new vicodec driver.
>> This patch adds multi-planar API support. I confirmed that v4l2-ctl uses
>> multi-planar APIs to decode a FWHT format video when vicodec module is loaded
>> with module parameter 'multiplanar'.
>>
>
