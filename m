Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46859 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeK0VHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:07:37 -0500
Received: by mail-yb1-f195.google.com with SMTP id i17-v6so8790323ybp.13
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 02:10:13 -0800 (PST)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id n142-v6sm842382ywd.75.2018.11.27.02.10.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 02:10:11 -0800 (PST)
Received: by mail-yw1-f44.google.com with SMTP id g75so8900184ywb.1
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 02:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20181121195907.23752-1-ezequiel@collabora.com>
 <CAAFQd5ArFG0hU6MgcyLd+_UOP3+T_U-aw2FXv6sE7fGqVCVGqw@mail.gmail.com> <c36f68773cec5aca0509d8af5172812110df73a5.camel@collabora.com>
In-Reply-To: <c36f68773cec5aca0509d8af5172812110df73a5.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 27 Nov 2018 19:09:59 +0900
Message-ID: <CAAFQd5Ds=NGfXeEQDkF40-ZPisLah_Bc2j4s4oRp75dKxGr05g@mail.gmail.com>
Subject: Re: [PATCH v10 4/4] media: add Rockchip VPU JPEG encoder driver
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 23, 2018 at 5:24 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
[snip]
> > > +const struct rockchip_vpu_variant rk3288_vpu_variant = {
> > > +       .enc_offset = 0x0,
> > > +       .enc_fmts = rk3288_vpu_enc_fmts,
> > > +       .num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
> > > +       .codec_ops = rk3288_vpu_codec_ops,
> > > +       .codec = RK_VPU_CODEC_JPEG,
> > > +       .vepu_irq = rk3288_vepu_irq,
> > > +       .init = rk3288_vpu_hw_init,
> > > +       .clk_names = {"aclk", "hclk"},
> >
> > nit: Spaces inside the brackets.
> >
>
> You mean you this style is prefered?
>
> .clk_names = { "aclk", "hclk" },
>
> Grepping thru sources, it seems there is no convention on this,
> so it's your call.
>

I thought this is a part of CodingStyle, but it doesn't seem to
mention it. I personally prefer to have the spaces there, but we can
go with your personal preferences here. :)
[snip]
> > > +        * by .vidioc_s_fmt_vid_cap_mplane() callback
> > > +        */
> > > +       reg = VEPU_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width);
> > > +       vepu_write_relaxed(vpu, reg, VEPU_REG_INPUT_LUMA_INFO);
> > > +
> > > +       reg = VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(0) |
> > > +             VEPU_REG_IN_IMG_CTRL_OVRFLB(0);
> >
> > For reference, this register controls the input crop, as the offset
> > from the right/bottom within the last macroblock. The offset from the
> > right must be divided by 4 and so the crop must be aligned to 4 pixels
> > horizontally.
> >
>
> OK, I'll add a comment.
>

I meant to refer to the comment Hans had, about input images of
resolutions that are not of full macroblocks, so the comment would
probably go to the TODO file together with Hans's note.
[snip]
> > > +static inline u32 vepu_read(struct rockchip_vpu_dev *vpu, u32 reg)
> > > +{
> > > +       u32 val = readl(vpu->enc_base + reg);
> > > +
> > > +       vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
> >
> > I remember seeing this "MARK" in the logs when debugging. I don't
> > think it's desired here.
> >
> > How about printing "%s(%03d) = %08x\n" for reads and "%s(%08x,
> > %03d)\n" for writes?

Actually, I missed the 0x prefix for hex values and possibly also
changing the decimal register offset to hexadecimal:
"%s(0x%04x) = 0x%08x\n"

> >
>
> Makes sense, but why a %s string format?
>

For __func__, so that we end up with messages like:

vepu_write(0x12345678, 0x0123)
vepu_read(0x0123) = 0x12345678

[snip]
> > > +       dst->field = src->field;
> > > +       dst->timecode = src->timecode;
> >
> > Time code is only valid if the buffer has V4L2_BUF_FLAG_TIMECODE set.
> > I don't think there is any use case for mem2mem devices for it.
> >
>
> Right. Other mem2mem drivers seem to pass thru the timecode like this:
>
>         if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
>                 out_vb->timecode = in_vb->timecode;
>
> It fails a v4l2-compliance test without it.
>

Hmm, I don't see the spec defining it to be copied by a mem2mem device
and I wonder if it's actually of any use for those. Hans, could you
comment on this?

> > > +       dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
> > > +       dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > > +       dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> >
> > Not V4L2_BUF_FLAG_TIMESTAMP_COPY?
> >
>
> I believe v4l core should take care of it in __fill_v4l2_buffer,
> as timestamp_flags is set when the vb2_queue structs are init'ed.
>

Ah, okay, I confused this with V4L2_BUF_FLAG_TIMESTAMP_MASK.

> > > +
> > > +       if (bytesused) {
> >
> > Should we check whether bytesused (read from hardware) is not bigger
> > than size of the buffer?
> >
>
> Good catch, makes sense. OTOH, if bytesused is bigger than the dst
> buffer, it is also bigger than the bounce buffer. I guess the IOMMU
> helps prevents nasty issues?
>

Yes, in that case it would likely trigger an IOMMU fault.

Another thing is whether there isn't some special bit somewhere high
in the register we're reading from that we're not aware of, which
would make the bytesused bigger than the buffer.

[snip]
> > > +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu,
> > > +                          unsigned int bytesused,
> > > +                          enum vb2_buffer_state result)
> > > +{
> > > +       struct rockchip_vpu_ctx *ctx =
> > > +               (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> >
> > I don't think we need to cast from void *?
> >
>
> Right.
>
> > > +
> > > +       /* Atomic watchdog cancel. The worker may still be
> > > +        * running after calling this.
> > > +        */
> >
> > Wrong multi-line comment style.
> >
>
> Right.
>
> > > +       cancel_delayed_work(&vpu->watchdog_work);
> > > +       if (ctx)
> > > +               rockchip_vpu_job_finish(vpu, ctx, bytesused, result);
> > > +}
> > > +
> > > +void rockchip_vpu_watchdog(struct work_struct *work)
> > > +{
> > > +       struct rockchip_vpu_dev *vpu;
> > > +       struct rockchip_vpu_ctx *ctx;
> > > +
> > > +       vpu = container_of(to_delayed_work(work),
> > > +                          struct rockchip_vpu_dev, watchdog_work);
> > > +       ctx = (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> >
> > Ditto.
> >
> > > +       if (ctx) {
> >
> > Is !ctx possible here?
> >
>
> Yes, it's possible because cancel_delayed_work doesn't flush
> the worker, so the top-half competes with the watchdog delayed
> worker.
>

Ah, right. What prevents a race between rockchip_vpu_irq_done() and
rockchip_vpu_watchdog() and both running rockchip_job_finish() on the
same context?

Perhaps in rockchip_vpu_irq_done() we could check the return value of
cancel_delayed_work() and if it's false, just give up and let the
watchdog handle the current ctx?

> > > +               vpu_err("frame processing timed out!\n");
> > > +               ctx->codec_ops->reset(ctx);
> > > +               rockchip_vpu_job_finish(vpu, ctx, 0, VB2_BUF_STATE_ERROR);
> > > +       }
> > > +}
> > > +
> > > +static void device_run(void *priv)
> > > +{
> > > +       struct rockchip_vpu_ctx *ctx = priv;
> > > +
> > > +       pm_runtime_get_sync(ctx->dev->dev);
> >
> > Shouldn't we handle errors here?
> >
>
> Yes, definitely.
>
> > > +
> > > +       ctx->codec_ops->run(ctx);
> > > +}
> > > +
> > > +static struct v4l2_m2m_ops vpu_m2m_ops = {
> > > +       .device_run = device_run,
> > > +};
> > > +
> > > +static int
> > > +enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> > > +{
> > > +       struct rockchip_vpu_ctx *ctx = priv;
> > > +       int ret;
> > > +
> > > +       src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > > +       src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> > > +       src_vq->drv_priv = ctx;
> > > +       src_vq->ops = &rockchip_vpu_enc_queue_ops;
> > > +       src_vq->mem_ops = &vb2_dma_contig_memops;
> > > +       src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
> > > +                           DMA_ATTR_NO_KERNEL_MAPPING;
> > > +       src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > > +       src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > > +       src_vq->lock = &ctx->dev->vpu_mutex;
> > > +       src_vq->dev = ctx->dev->v4l2_dev.dev;
> > > +
> > > +       ret = vb2_queue_init(src_vq);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       /* The CAPTURE queue doesn't need dma memory,
> > > +        * as the CPU needs to create the JPEG frames,
> > > +        * from the hardware-produced JPEG payload.
> > > +        *
> > > +        * For the DMA destination buffer, we use
> > > +        * a bounce buffer.
> >
> > Alternatively we could use a normal buffer and memmove() the payload
> > to make space for the headers, as we used to do in the VP8 encoder on
> > rk3288. Either is fine and perhaps we could even do away without that
> > with some smart trick. Something for the TODO list I guess.
> >
>
> Perhaps we can re-discuss this in IRC? Anyway, it's a nice optimization
> to keep in mind.
>

Yeah, just some ideas for the follow up patches.

[snip]
> > > +static int __maybe_unused rockchip_vpu_runtime_resume(struct device *dev)
> > > +{
> > > +       struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> > > +
> > > +       return clk_bulk_enable(vpu->variant->num_clocks, vpu->clocks);
> >
> > Something for the TODO list: We should disable the clocks as soon as
> > the hardware becomes idle, because it's super cheap and the delay
> > between the idle and autosuspend is quite significant.
> >
>
> You mean getting rid of autosuspend, right?
>

Not exactly. The autosuspend is to avoid too frequent *power*
transitions, which could be costly. Actually, even if we get rid of
it, the genpd code will still throttle runtime suspends based on the
PM domain suspend/resume latency it measured.

The only way to control the clocks without throttling is managing them
explicitly, just before the call to pm_runtime_put_autosuspend() or
after pm_runtime_get_sync().

[snip]
> > > +static int
> > > +vidioc_try_fmt_cap_mplane(struct file *file, void *priv, struct v4l2_format *f)
> > > +{
> > > +       struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > > +       struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > > +       const struct rockchip_vpu_fmt *fmt;
> > > +
> > > +       vpu_debug(4, "%c%c%c%c\n",
> > > +                 (pix_mp->pixelformat & 0x7f),
> > > +                 (pix_mp->pixelformat >> 8) & 0x7f,
> > > +                 (pix_mp->pixelformat >> 16) & 0x7f,
> > > +                 (pix_mp->pixelformat >> 24) & 0x7f);
> > > +
> > > +       fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
> > > +       if (!fmt) {
> > > +               fmt = rockchip_vpu_get_default_fmt(ctx, true);
> > > +               f->fmt.pix.pixelformat = fmt->fourcc;
> > > +       }
> > > +
> > > +       pix_mp->num_planes = 1;
> > > +       pix_mp->field = V4L2_FIELD_NONE;
> > > +       pix_mp->width = clamp(pix_mp->width,
> > > +                             fmt->frmsize.min_width,
> > > +                             fmt->frmsize.max_width);
> > > +       pix_mp->height = clamp(pix_mp->height,
> > > +                              fmt->frmsize.min_height,
> > > +                              fmt->frmsize.max_height);
> >
> > Don't we also need to align to macroblocks?
> >
> > > +       pix_mp->plane_fmt[0].sizeimage = fmt->header_size +
> > > +               pix_mp->width * pix_mp->height * fmt->max_depth;
> >
> > I suppose this is a hint for the potential maximum compressed size?
> >
>
> Indeed.
>
> > I don't like the idea of enforcing one particular size on the user
> > space. Or even a minimum size. For example, the user may know that the
> > image is well-compressible and want to use smaller buffers. Or may
> > want to try with a smaller buffer first and reallocate to a bigger one
> > if it turns out to be too small.
> >
> > I'd just leave this kind of logic to the user space.
> >
>
> Right. However, it seems to me we still need to set a value,
> and return it to userspace when userspace doesn't provide any.
>

There was another discussion about this wrt the venus driver and the
conclusion is to specify this for codecs as follows:

    For compressed formats (and only those!) userspace can set sizeimage to a
    proposed value. The driver may either ignore it and just set its own value,
    or modify it to satisfy HW requirements. The returned value will be used
    by REQBUFS when it allocates buffers.

So I guess the driver could reset it to default if it doesn't sound
reasonable (0?).

[snip]
> > > +void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
> > > +                                   struct rockchip_vpu_ctx *ctx)
> > > +{
> > > +       struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> > > +       unsigned int width, height;
> > > +
> > > +       ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(ctx, false);
> > > +
> > > +       memset(fmt, 0, sizeof(*fmt));
> > > +
> > > +       width = clamp(fmt->width, ctx->vpu_dst_fmt->frmsize.min_width,
> > > +                     ctx->vpu_dst_fmt->frmsize.max_width);
> > > +       height = clamp(fmt->height, ctx->vpu_dst_fmt->frmsize.min_height,
> > > +                      ctx->vpu_dst_fmt->frmsize.max_height);
> > > +       fmt->field = V4L2_FIELD_NONE;
> > > +       fmt->colorspace = ctx->colorspace;
> > > +       fmt->ycbcr_enc = ctx->ycbcr_enc;
> > > +       fmt->xfer_func = ctx->xfer_func;
> > > +       fmt->quantization = ctx->quantization;
> >
> > Ditto.
> >
> > > +
> > > +       fill_pixfmt_mp(fmt, ctx->vpu_src_fmt->fourcc, width, height);
> > > +}
> >
> > These two don't seem to be very encoder-specific. In particular,
> > rockchip_vpu_enc_reset_dst_fmt() is not even used by the encoder after
> > the context is initialized, but it's going to be used by the decoder
> > to reset the raw format when the coded format changes (similarly to
> > rockchip_vpu_enc_reset_src_fmt() for encoder).
> >
>
> Yeah, I'm aware there might be some commong logic here, but since
> the driver is an encoder only for now, I decided to let it be.
>
> However, I've made sure the driver is ready to support
> decoding and other variants, with fairly simple changes.
>

Fair enough.

[snip]
> > > +void rockchip_vpu_jpeg_render(struct rockchip_vpu_jpeg_ctx *ctx)
> >
> > nit: I'm not sure "render" is the right word here. Maybe it's just me,
> > but I associate it with rendering of visible graphics. Perhaps
> > "assemble" would be better?
> >
>
> I don't think render is gfx only, but.. it might be confusing, so
> how about "rockchip_vpu_jpeg_header_prepare" or "rockchip_vpu_jpeg_header_set" ?
>
> This function might be moved to lib/jpeg.c, so getting the name
> right is not that much of a nitpick.
>

rockchip_vpu_jpeg_header_assemble()? (My preference for "assemble"
comes from building the header from the pieces as the function does.)

> > > +{
> > > +       char *buf = ctx->buffer;
> > > +
> > > +       memcpy(buf, rockchip_vpu_jpeg_header,
> > > +              sizeof(rockchip_vpu_jpeg_header));
> > > +
> > > +       buf[HEIGHT_OFF + 0] = ctx->height >> 8;
> > > +       buf[HEIGHT_OFF + 1] = ctx->height;
> > > +       buf[WIDTH_OFF + 0] = ctx->width >> 8;
> > > +       buf[WIDTH_OFF + 1] = ctx->width;
> > > +
> > > +       memcpy(buf + HUFF_LUMA_DC_OFF, luma_dc_table, sizeof(luma_dc_table));
> > > +       memcpy(buf + HUFF_LUMA_AC_OFF, luma_ac_table, sizeof(luma_ac_table));
> > > +       memcpy(buf + HUFF_CHROMA_DC_OFF, chroma_dc_table,
> > > +              sizeof(chroma_dc_table));
> > > +       memcpy(buf + HUFF_CHROMA_AC_OFF, chroma_ac_table,
> > > +              sizeof(chroma_ac_table));
> > > +
> > > +       jpeg_set_quality(buf, ctx->quality);
> > > +}
> > > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> > > new file mode 100644
> > > index 000000000000..ebe34071851e
> > > --- /dev/null
> > > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> > > @@ -0,0 +1,14 @@
> > > +/* SPDX-License-Identifier: GPL-2.0+ */
> > > +
> > > +#define JPEG_HEADER_SIZE       601
> >
> > Could we just use ARRAY_SIZE() instead?
> >
> >
>
> We can, just not sure how easily.
>
> Thanks a lot for the review!

You're welcome.

Best regards,
Tomasz
