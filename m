Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38998 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2GRHMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 03:12:23 -0400
Received: by wgbdr13 with SMTP id dr13so1090709wgb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 00:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342459273.2535.665.camel@pizza.hi.pengutronix.de>
References: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
	<1342459273.2535.665.camel@pizza.hi.pengutronix.de>
Date: Wed, 18 Jul 2012 09:12:21 +0200
Message-ID: <CACKLOr3rOPgwMCRdj3ARR+0655Qp=BfEXq0TsB7TU-hO4NSsqg@mail.gmail.com>
Subject: Re: [PATCH v3] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pilipp,

On 16 July 2012 19:21, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Javier,
>
> I'm trying to use this driver (on i.MX53) with GStreamer, with two
> buffers on the encoded bitstream side. I'm getting negative bytesused
> values calculated in coda_isr().
>
> The CODA_REG_BIT_WR_PTR address, which is initialized in
> coda_start_streaming() only moves around in the first buffer (so far
> attempts to set it from device_run() have failed). This causes negative
> bytesused values to be calculated in coda_isr() if the second buffer
> (which has a higher BB_START address than WR_PTR) is active.
> I'll repeat my observations inline below.
>
> Are you using just one buffer for encoded frames? Does your firmware
> behave differently?

Apparently, it does; see an example where I am using two frames:

get_frame: (0) bytesused = 3579
get_frame: (1) bytesused = 3834
get_frame: (0) bytesused = 14925
get_frame: (1) bytesused = 4493
get_frame: (0) bytesused = 3977
get_frame: (1) bytesused = 3855
get_frame: (0) bytesused = 3853
get_frame: (1) bytesused = 3646
get_frame: (0) bytesused = 3797
get_frame: (1) bytesused = 3695
get_frame: (0) bytesused = 3653
get_frame: (1) bytesused = 3770
get_frame: (0) bytesused = 3418
get_frame: (1) bytesused = 3749
get_frame: (0) bytesused = 3621
get_frame: (1) bytesused = 3743
get_frame: (0) bytesused = 3506
get_frame: (1) bytesused = 3523
get_frame: (0) bytesused = 14844

As you can see I don't get any negative values. Furthermore, the
values seem rather correct since as gop_size is 16. There are 15
smaller P frames between two larger I frames.

> I see there is a comment about the expected register setting not working
> for CODA_REG_BIT_STREAM_CTRL in start_streaming(). Could this be
> related?

I don't think so. This means that the following line:

coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);

should be:

coda_write(dev, (CODADX6_STREAM_BUF_PIC_RESET |
CODADX6_STREAM_BUF_PIC_FLUSH), CODA_REG_BIT_STREAM_CTRL);

But the latter does not work.

> Also, I've missed two problems with platform device removal and module
> autoloading before, see below.

Fine.

> Am Donnerstag, den 12.07.2012, 09:11 +0200 schrieb Javier Martin:
>> Coda is a range of video codecs from Chips&Media that
>> support H.264, H.263, MPEG4 and other video standards.
>>
>> Currently only support for the codadx6 included in the
>> i.MX27 SoC is added. H.264 and MPEG4 video encoding
>> are the only supported capabilities by now.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>> Changes since v2:
>>  - Make hex constants lower case.
>>  - Fix bytesperline.
>>  - Make some functions and variables static.
>>  - Fix logical &&
>>  - Remove get_qops()
>> ---
> [...]
>> +static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
>> +{
>> +     struct vb2_queue *vq;
>> +     struct coda_q_data *q_data;
>> +
>> +     vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +     if (!vq)
>> +             return -EINVAL;
>> +
>> +     q_data = get_q_data(ctx, f->type);
>> +
>> +     f->fmt.pix.field        = V4L2_FIELD_NONE;
>> +     f->fmt.pix.pixelformat  = q_data->fmt->fourcc;
>> +     if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +             f->fmt.pix.width        = q_data->width;
>> +             f->fmt.pix.height       = q_data->height;
>> +             f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
>> +     } else { /* encoded formats h.264/mpeg4 */
>> +             f->fmt.pix.width        = 0;
>> +             f->fmt.pix.height       = 0;
>> +             f->fmt.pix.bytesperline = 0;
>> +     }
>> +     f->fmt.pix.sizeimage    = q_data->sizeimage;
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     return vidioc_g_fmt(fh_to_ctx(priv), f);
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     return vidioc_g_fmt(fh_to_ctx(priv), f);
>> +}
>> +
>> +static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
>> +{
>> +     enum v4l2_field field;
>> +
>> +     if (!find_format(dev, f))
>> +             return -EINVAL;
>> +
>> +     field = f->fmt.pix.field;
>> +     if (field == V4L2_FIELD_ANY)
>> +             field = V4L2_FIELD_NONE;
>> +     else if (V4L2_FIELD_NONE != field)
>> +             return -EINVAL;
>> +
>> +     /* V4L2 specification suggests the driver corrects the format struct
>> +      * if any of the dimensions is unsupported */
>> +     f->fmt.pix.field = field;
>> +
>> +     if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +             v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
>> +                                   W_ALIGN, &f->fmt.pix.height,
>> +                                   MIN_H, MAX_H, H_ALIGN, S_ALIGN);
>> +             f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
>> +             f->fmt.pix.sizeimage = f->fmt.pix.height *
>> +                                     f->fmt.pix.bytesperline;
>> +     } else { /*encoded formats h.264/mpeg4 */
>> +             f->fmt.pix.bytesperline = CODA_MAX_FRAME_SIZE;
>
> I failed to point this out specifically, but I think if G_FMT returns
> zero in bytesperline, so should TRY_FMT.

Of course, this is my fault too. I'll fix it in a new patch.

>> +             f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct coda_fmt *fmt;
>> +     struct coda_ctx *ctx = fh_to_ctx(priv);
>> +
>> +     fmt = find_format(ctx->dev, f);
>> +     /*
>> +      * Since decoding support is not implemented yet do not allow
>> +      * CODA_FMT_RAW formats in the capture interface.
>> +      */
>> +     if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
>> +             v4l2_err(&ctx->dev->v4l2_dev,
>> +                      "Fourcc format (0x%08x) invalid.\n",
>> +                      f->fmt.pix.pixelformat);
>> +             return -EINVAL;
>> +     }
>> +
>> +     return vidioc_try_fmt(ctx->dev, f);
>> +}
> [...]
>> +/*
>> + * Mem-to-mem operations.
>> + */
>> +
>> +static int coda_isr(struct coda_dev *dev)
>> +{
>> +     struct coda_ctx *ctx;
>> +     struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
>> +     u32 wr_ptr, start_ptr;
>> +
>> +     ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
>> +     if (ctx == NULL) {
>> +             v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
>> +             return IRQ_HANDLED;
>> +     }
>> +
>> +     if (ctx->aborting) {
>> +             v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                      "task has been aborted\n");
>> +             return IRQ_HANDLED;
>> +     }
>> +
>> +     if (coda_isbusy(ctx->dev)) {
>> +             v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                      "coda is still busy!!!!\n");
>> +             return IRQ_NONE;
>> +     }
>> +
>> +     src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
>> +     dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> +
>> +     /* Get results from the coda */
>> +     coda_read(dev, CODA_RET_ENC_PIC_TYPE);
>> +     start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
>> +     wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
>
> Here CODA_REG_BIT_WR_PTR is read, and it always contains a pointer into
> the first destination buffer that was set during start_streaming()
> below, even if I try to set it before starting the PIC_RUN command in
> device_run().
>
> start_ptr contains the correct buffer address as set in device_run().
>

I don't get the same behaviour in i.MX27 with firmware 2.2.5. See this log:

coda coda-imx27.0: (seq=0, idx=0) wr_ptr=0xa2603bf9,
start_ptr=0xa2600015 bytesused=15353
coda coda-imx27.0: (seq=1, idx=1) wr_ptr=0xa2700fd9,
start_ptr=0xa2700000 bytesused=4057
coda coda-imx27.0: (seq=2, idx=0) wr_ptr=0xa2600e62,
start_ptr=0xa2600000 bytesused=3682
coda coda-imx27.0: (seq=3, idx=1) wr_ptr=0xa2700e32,
start_ptr=0xa2700000 bytesused=3634
coda coda-imx27.0: (seq=4, idx=0) wr_ptr=0xa2600c8e,
start_ptr=0xa2600000 bytesused=3214
...

>> +     /* Calculate bytesused field */
>> +     if (dst_buf->v4l2_buf.sequence == 0) {
>> +             dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
>> +                                             ctx->vpu_header_size[0] +
>> +                                             ctx->vpu_header_size[1] +
>> +                                             ctx->vpu_header_size[2];
>> +     } else {
>> +             dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);
>
> So it is possible to have wr_ptr < start_ptr here.
>

Not in i.MX27.

>> +     }
>> +
>> +     v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
>> +              wr_ptr - start_ptr);
>> +
>> +     coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
>> +     coda_read(dev, CODA_RET_ENC_PIC_FLAG);
>> +
>> +     if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
>> +             dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
>> +             dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
>> +     } else {
>> +             dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
>> +             dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
>> +     }
>> +
>> +     /* Free previous reference picture if available */
>> +     if (ctx->reference) {
>> +             v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
>> +             ctx->reference = NULL;
>> +     }
>> +
>> +     /*
>> +      * For the last frame of the gop we don't need to save
>> +      * a reference picture.
>> +      */
>> +     v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
>> +     tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
>> +     if (ctx->gopcounter == 0)
>> +             v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>> +     else
>> +             ctx->reference = tmp_buf;
>> +
>> +     v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
>> +
>> +     ctx->gopcounter--;
>> +     if (ctx->gopcounter < 0)
>> +             ctx->gopcounter = ctx->params.gop_size - 1;
>> +
>> +     v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
>> +             "job finished: encoding frame (%d) (%s)\n",
>> +             dst_buf->v4l2_buf.sequence,
>> +             (dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
>> +             "KEYFRAME" : "PFRAME");
>> +
>> +     v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static void coda_device_run(void *m2m_priv)
>> +{
>> +     struct coda_ctx *ctx = m2m_priv;
>> +     struct coda_q_data *q_data_src, *q_data_dst;
>> +     struct vb2_buffer *src_buf, *dst_buf;
>> +     struct coda_dev *dev = ctx->dev;
>> +     int force_ipicture;
>> +     int quant_param = 0;
>> +     u32 picture_y, picture_cb, picture_cr;
>> +     u32 pic_stream_buffer_addr, pic_stream_buffer_size;
>> +     u32 dst_fourcc;
>> +
>> +     src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
>> +     dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> +     q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>> +     q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>> +     dst_fourcc = q_data_dst->fmt->fourcc;
>> +
>> +     src_buf->v4l2_buf.sequence = ctx->isequence;
>> +     dst_buf->v4l2_buf.sequence = ctx->isequence;
>> +     ctx->isequence++;
>> +
>> +     /*
>> +      * Workaround coda firmware BUG that only marks the first
>> +      * frame as IDR. This is a problem for some decoders that can't
>> +      * recover when a frame is lost.
>> +      */
>> +     if (src_buf->v4l2_buf.sequence % ctx->params.gop_size) {
>> +             src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
>> +             src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
>> +     } else {
>> +             src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
>> +             src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
>> +     }
>> +
>> +     /*
>> +      * Copy headers at the beginning of the first frame for H.264 only.
>> +      * In MPEG4 they are already copied by the coda.
>> +      */
>> +     if (src_buf->v4l2_buf.sequence == 0) {
>> +             pic_stream_buffer_addr =
>> +                     vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
>> +                     ctx->vpu_header_size[0] +
>> +                     ctx->vpu_header_size[1] +
>> +                     ctx->vpu_header_size[2];
>> +             pic_stream_buffer_size = CODA_MAX_FRAME_SIZE -
>> +                     ctx->vpu_header_size[0] -
>> +                     ctx->vpu_header_size[1] -
>> +                     ctx->vpu_header_size[2];
>> +             memcpy(vb2_plane_vaddr(dst_buf, 0),
>> +                    &ctx->vpu_header[0][0], ctx->vpu_header_size[0]);
>> +             memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
>> +                    &ctx->vpu_header[1][0], ctx->vpu_header_size[1]);
>> +             memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
>> +                     ctx->vpu_header_size[1], &ctx->vpu_header[2][0],
>> +                     ctx->vpu_header_size[2]);
>> +     } else {
>> +             pic_stream_buffer_addr =
>> +                     vb2_dma_contig_plane_dma_addr(dst_buf, 0);
>> +             pic_stream_buffer_size = CODA_MAX_FRAME_SIZE;
>> +     }
>> +
>> +     if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
>> +             force_ipicture = 1;
>> +             switch (dst_fourcc) {
>> +             case V4L2_PIX_FMT_H264:
>> +                     quant_param = ctx->params.h264_intra_qp;
>> +                     break;
>> +             case V4L2_PIX_FMT_MPEG4:
>> +                     quant_param = ctx->params.mpeg4_intra_qp;
>> +                     break;
>> +             default:
>> +                     v4l2_warn(&ctx->dev->v4l2_dev,
>> +                             "cannot set intra qp, fmt not supported\n");
>> +                     break;
>> +             }
>> +     } else {
>> +             force_ipicture = 0;
>> +             switch (dst_fourcc) {
>> +             case V4L2_PIX_FMT_H264:
>> +                     quant_param = ctx->params.h264_inter_qp;
>> +                     break;
>> +             case V4L2_PIX_FMT_MPEG4:
>> +                     quant_param = ctx->params.mpeg4_inter_qp;
>> +                     break;
>> +             default:
>> +                     v4l2_warn(&ctx->dev->v4l2_dev,
>> +                             "cannot set inter qp, fmt not supported\n");
>> +                     break;
>> +             }
>> +     }
>> +
>> +     /* submit */
>> +     coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
>> +     coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
>> +
>> +
>> +     picture_y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
>> +     picture_cb = picture_y + q_data_src->width * q_data_src->height;
>> +     picture_cr = picture_cb + q_data_src->width / 2 *
>> +                     q_data_src->height / 2;
>> +
>> +     coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
>> +     coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
>> +     coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
>> +     coda_write(dev, force_ipicture << 1 & 0x2,
>> +                CODA_CMD_ENC_PIC_OPTION);
>> +
>> +     coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
>> +     coda_write(dev, pic_stream_buffer_size / 1024,
>> +                CODA_CMD_ENC_PIC_BB_SIZE);
>
> If I set CODA_REG_BIT_WR_PTR to pic_stream_buffer_addr here, and
> pic_stream_buffer_addr points to the second destination buffer, after
> the PIC_RUN command finishes, CODA_REG_BIT_WR_PTR again points into the
> first destination buffer, as set in start_streaming().

In i.MX27 I don't even need to set CODA_REG_BIT_WR_PTR here to get the
expected result.

>> +     coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
>> +}
>> +
>> +static int coda_job_ready(void *m2m_priv)
>> +{
>> +     struct coda_ctx *ctx = m2m_priv;
>> +
>> +     /*
>> +      * For both 'P' and 'key' frame cases 1 picture
>> +      * and 1 frame are needed.
>> +      */
>> +     if (!(v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) >= 1) ||
>> +             !(v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) >= 1)) {
>> +             v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                      "not ready: not enough video buffers.\n");
>> +             return 0;
>> +     }
>> +
>> +     /* For P frames a reference picture is needed too */
>> +     if ((ctx->gopcounter != (ctx->params.gop_size - 1)) &&
>> +        (!ctx->reference)) {
>> +             v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                      "not ready: reference picture not available.\n");
>> +             return 0;
>> +     }
>> +
>> +     if (coda_isbusy(ctx->dev)) {
>> +             v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                      "not ready: coda is still busy.\n");
>> +             return 0;
>> +     }
>> +
>> +     v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>> +                     "job ready\n");
>> +     return 1;
>> +}
> [...]
>> +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +     struct coda_ctx *ctx = vb2_get_drv_priv(q);
>> +     struct coda_dev *dev = ctx->dev;
>> +     u32 bitstream_buf, bitstream_size;
>> +
>> +     if (count < 1)
>> +             return -EINVAL;
>> +
>> +     if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +             ctx->rawstreamon = 1;
>> +     else
>> +             ctx->compstreamon = 1;
>> +
>> +     if (ctx->rawstreamon & ctx->compstreamon) {
>> +             struct coda_q_data *q_data_src, *q_data_dst;
>> +             u32 dst_fourcc;
>> +             struct vb2_buffer *buf;
>> +             struct vb2_queue *src_vq;
>> +             u32 value;
>> +             int i = 0;
>> +
>> +             ctx->gopcounter = ctx->params.gop_size - 1;
>> +
>> +             q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
>> +             buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> +             bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
>> +             q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>> +             bitstream_size = q_data_dst->sizeimage;
>> +             dst_fourcc = q_data_dst->fmt->fourcc;
>> +
>> +             /* Find out whether coda must encode or decode */
>> +             if (q_data_src->fmt->type == CODA_FMT_RAW &&
>> +                 q_data_dst->fmt->type == CODA_FMT_ENC) {
>> +                     ctx->inst_type = CODA_INST_ENCODER;
>> +             } else if (q_data_src->fmt->type == CODA_FMT_ENC &&
>> +                        q_data_dst->fmt->type == CODA_FMT_RAW) {
>> +                     ctx->inst_type = CODA_INST_DECODER;
>> +                     v4l2_err(&ctx->dev->v4l2_dev, "decoding not supported.\n");
>> +                     return -EINVAL;
>> +             } else {
>> +                     v4l2_err(&ctx->dev->v4l2_dev, "couldn't tell instance type.\n");
>> +                     return -EINVAL;
>> +             }
>> +
>> +             if (!coda_is_initialized(dev)) {
>> +                     v4l2_err(&ctx->dev->v4l2_dev, "coda is not initialized.\n");
>> +                     return -EFAULT;
>> +             }
>> +             coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
>> +             coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
>> +             coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
>
> Here CODA_REG_BIT_WR_PTR is set to the beginning of bitstream_buf, which
> is the first destination buffer.

Right.

>> +             switch (dev->devtype->product) {
>> +             case CODA_DX6:
>> +                     /*
>> +                      * We should use (CODADX6_STREAM_BUF_PIC_RESET |
>> +                      * CODADX6_STREAM_BUF_PIC_FLUSH) but it doesn't work
>> +                      * with firmware 2.2.5.
>> +                      */
>> +                     coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
>> +                     break;
>> +             default:
>> +                     coda_write(dev, CODA7_STREAM_BUF_PIC_RESET |
>> +                             CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
>> +             }
>> +
>> +             /* Configure the coda */
>> +             coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
>> +
>> +             /* Could set rotation here if needed */
[snip]
>> +enum coda_platform {
>> +     CODA_IMX27,
>> +};
>> +
>> +static struct coda_devtype coda_devdata[] = {
>> +     [CODA_IMX27] = {
>> +             .firmware    = "v4l-codadx6-imx27.bin",
>> +             .product     = CODA_DX6,
>> +             .formats     = codadx6_formats,
>> +             .num_formats = ARRAY_SIZE(codadx6_formats),
>> +     },
>> +};
>> +
>> +static struct platform_device_id coda_platform_ids[] = {
>> +     { .name = "coda-imx27", .driver_data = CODA_IMX27 },
>> +     { /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(platform, coda_platform_ids);
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id coda_dt_ids[] = {
>> +     { .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
>> +     { /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(platform, coda_dt_ids);
>
> Should be
> MODULE_DEVICE_TABLE(of, coda_dt_ids);
>
> I completely missed this before, but today it was pointed out to me that
> module autoloading doesn't work.

OK, let me fix it in a new patch.

> [...]
>> +static int coda_remove(struct platform_device *pdev)
>> +{
>> +     struct coda_dev *dev = platform_get_drvdata(pdev);
>> +     unsigned int bufsize;
>> +
>> +     switch (dev->devtype->product) {
>> +     case CODA_DX6:
>> +             bufsize = CODADX6_WORK_BUF_SIZE;
>> +             break;
>> +     default:
>> +             bufsize = CODA7_WORK_BUF_SIZE;
>> +     }
>> +
>> +     video_unregister_device(dev->vfd);
>> +     v4l2_m2m_release(dev->m2m_dev);
>> +     vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>> +     video_device_release(dev->vfd);
>
> -+       video_device_release(dev->vfd);
> ++       v4l2_device_unregister(&dev->v4l2_dev);
>
> video_device_release is already called by kobj refcounting.
> With this change I can cleanly rmmod/insmod the coda.ko module.
>

Fine, let me fix it.

>> +     if (dev->codebuf.vaddr)
>> +             dma_free_coherent(&pdev->dev, dev->codebuf_size,
>> +                               &dev->codebuf.vaddr, dev->codebuf.paddr);
>> +     dma_free_coherent(&pdev->dev, bufsize, &dev->workbuf.vaddr,
>> +                       dev->workbuf.paddr);
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver coda_driver = {
>> +     .probe  = coda_probe,
>> +     .remove = __devexit_p(coda_remove),
>> +     .driver = {
>> +             .name   = CODA_NAME,
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table = of_match_ptr(coda_dt_ids),
>> +     },
>> +     .id_table = coda_platform_ids,
>> +};
>> +
>> +module_platform_driver(coda_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
>> +MODULE_DESCRIPTION("Coda multi-standard codec V4L2 driver");
> [...]
>
> regards
> Philipp


I will send a new v4 with the 'platform' and 'bytesused' issues fixed.
Regarding your i.MX53 problems I suppose they should be addressed
conditionally in a patch on top of this one where i.MX53 support is
added too.
What do you think?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
