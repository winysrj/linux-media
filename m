Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52050 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeK2FHp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 00:07:45 -0500
Message-ID: <a3c12459e08b64ac374d7bd477aff3079590c5d4.camel@collabora.com>
Subject: Re: [PATCH v10 4/4] media: add Rockchip VPU JPEG encoder driver
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr
Date: Wed, 28 Nov 2018 15:05:01 -0300
In-Reply-To: <CAAFQd5Ds=NGfXeEQDkF40-ZPisLah_Bc2j4s4oRp75dKxGr05g@mail.gmail.com>
References: <20181121195907.23752-1-ezequiel@collabora.com>
         <CAAFQd5ArFG0hU6MgcyLd+_UOP3+T_U-aw2FXv6sE7fGqVCVGqw@mail.gmail.com>
         <c36f68773cec5aca0509d8af5172812110df73a5.camel@collabora.com>
         <CAAFQd5Ds=NGfXeEQDkF40-ZPisLah_Bc2j4s4oRp75dKxGr05g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-11-27 at 19:09 +0900, Tomasz Figa wrote:
> On Fri, Nov 23, 2018 at 5:24 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> [snip]
> > > > +const struct rockchip_vpu_variant rk3288_vpu_variant = {
> > > > +       .enc_offset = 0x0,
> > > > +       .enc_fmts = rk3288_vpu_enc_fmts,
> > > > +       .num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
> > > > +       .codec_ops = rk3288_vpu_codec_ops,
> > > > +       .codec = RK_VPU_CODEC_JPEG,
> > > > +       .vepu_irq = rk3288_vepu_irq,
> > > > +       .init = rk3288_vpu_hw_init,
> > > > +       .clk_names = {"aclk", "hclk"},
> > > 
> > > nit: Spaces inside the brackets.
> > > 
> > 
> > You mean you this style is prefered?
> > 
> > .clk_names = { "aclk", "hclk" },
> > 
> > Grepping thru sources, it seems there is no convention on this,
> > so it's your call.
> > 
> 
> I thought this is a part of CodingStyle, but it doesn't seem to
> mention it. I personally prefer to have the spaces there, but we can
> go with your personal preferences here. :)

OK.

> [snip]
> > > > +        * by .vidioc_s_fmt_vid_cap_mplane() callback
> > > > +        */
> > > > +       reg = VEPU_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width);
> > > > +       vepu_write_relaxed(vpu, reg, VEPU_REG_INPUT_LUMA_INFO);
> > > > +
> > > > +       reg = VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(0) |
> > > > +             VEPU_REG_IN_IMG_CTRL_OVRFLB(0);
> > > 
> > > For reference, this register controls the input crop, as the offset
> > > from the right/bottom within the last macroblock. The offset from the
> > > right must be divided by 4 and so the crop must be aligned to 4 pixels
> > > horizontally.
> > > 
> > 
> > OK, I'll add a comment.
> > 
> 
> I meant to refer to the comment Hans had, about input images of
> resolutions that are not of full macroblocks, so the comment would
> probably go to the TODO file together with Hans's note.

Got it.

> [snip]
> > > > +static inline u32 vepu_read(struct rockchip_vpu_dev *vpu, u32 reg)
> > > > +{
> > > > +       u32 val = readl(vpu->enc_base + reg);
> > > > +
> > > > +       vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
> > > 
> > > I remember seeing this "MARK" in the logs when debugging. I don't
> > > think it's desired here.
> > > 
> > > How about printing "%s(%03d) = %08x\n" for reads and "%s(%08x,
> > > %03d)\n" for writes?
> 
> Actually, I missed the 0x prefix for hex values and possibly also
> changing the decimal register offset to hexadecimal:
> "%s(0x%04x) = 0x%08x\n"
> 
> > 
> > Makes sense, but why a %s string format?
> > 
> 
> For __func__, so that we end up with messages like:
> 
> vepu_write(0x12345678, 0x0123)
> vepu_read(0x0123) = 0x12345678
> 

vepu_debug already uses __func__, so it would look like this:

[   27.125090] vepu_write_relaxed:215: 0x001f = 0x01010101
[   27.127413] vepu_write:221: 0x0069 = 0xfc000000
[   27.129673] vepu_write_relaxed:215: 0x0036 = 0x00001000
[   27.132079] vepu_write:221: 0x0067 = 0x00f01461
[   27.135042] vepu_read:229: 0x006d = 0x00001003
[   27.137450] vepu_read:229: 0x0035 = 0x00020318
[   27.139778] vepu_write:221: 0x006d = 0x00000000
[   27.142144] vepu_write:221: 0x0036 = 0x00000000

Unless we use a different debug macro for i/o access.

> [snip]
> > > > +       dst->field = src->field;
> > > > +       dst->timecode = src->timecode;
> > > 
> > > Time code is only valid if the buffer has V4L2_BUF_FLAG_TIMECODE set.
> > > I don't think there is any use case for mem2mem devices for it.
> > > 
> > 
> > Right. Other mem2mem drivers seem to pass thru the timecode like this:
> > 
> >         if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
> >                 out_vb->timecode = in_vb->timecode;
> > 
> > It fails a v4l2-compliance test without it.
> > 
> 
> Hmm, I don't see the spec defining it to be copied by a mem2mem device
> and I wonder if it's actually of any use for those. Hans, could you
> comment on this?
> 

I asked Hans about this and he said timecode should behave as timestamp,
and be carried from the output queue to the capture queue.

This helper will take care of it: https://patchwork.linuxtv.org/patch/52961/
 
> > > > +       dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
> > > > +       dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > > > +       dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > > 
> > > Not V4L2_BUF_FLAG_TIMESTAMP_COPY?
> > > 
> > 
> > I believe v4l core should take care of it in __fill_v4l2_buffer,
> > as timestamp_flags is set when the vb2_queue structs are init'ed.
> > 
> 
> Ah, okay, I confused this with V4L2_BUF_FLAG_TIMESTAMP_MASK.
> 
> > > > +
> > > > +       if (bytesused) {
> > > 
> > > Should we check whether bytesused (read from hardware) is not bigger
> > > than size of the buffer?
> > > 
> > 
> > Good catch, makes sense. OTOH, if bytesused is bigger than the dst
> > buffer, it is also bigger than the bounce buffer. I guess the IOMMU
> > helps prevents nasty issues?
> > 
> 
> Yes, in that case it would likely trigger an IOMMU fault.
> 
> Another thing is whether there isn't some special bit somewhere high
> in the register we're reading from that we're not aware of, which
> would make the bytesused bigger than the buffer.
> 
> [snip]
> > > > +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu,
> > > > +                          unsigned int bytesused,
> > > > +                          enum vb2_buffer_state result)
> > > > +{
> > > > +       struct rockchip_vpu_ctx *ctx =
> > > > +               (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> > > 
> > > I don't think we need to cast from void *?
> > > 
> > 
> > Right.
> > 
> > > > +
> > > > +       /* Atomic watchdog cancel. The worker may still be
> > > > +        * running after calling this.
> > > > +        */
> > > 
> > > Wrong multi-line comment style.
> > > 
> > 
> > Right.
> > 
> > > > +       cancel_delayed_work(&vpu->watchdog_work);
> > > > +       if (ctx)
> > > > +               rockchip_vpu_job_finish(vpu, ctx, bytesused, result);
> > > > +}
> > > > +
> > > > +void rockchip_vpu_watchdog(struct work_struct *work)
> > > > +{
> > > > +       struct rockchip_vpu_dev *vpu;
> > > > +       struct rockchip_vpu_ctx *ctx;
> > > > +
> > > > +       vpu = container_of(to_delayed_work(work),
> > > > +                          struct rockchip_vpu_dev, watchdog_work);
> > > > +       ctx = (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> > > 
> > > Ditto.
> > > 
> > > > +       if (ctx) {
> > > 
> > > Is !ctx possible here?
> > > 
> > 
> > Yes, it's possible because cancel_delayed_work doesn't flush
> > the worker, so the top-half competes with the watchdog delayed
> > worker.
> > 
> 
> Ah, right. What prevents a race between rockchip_vpu_irq_done() and
> rockchip_vpu_watchdog() and both running rockchip_job_finish() on the
> same context?
> 

Right, missed that. It would be possible to end up calling
rockchip_job_finish twice.

> Perhaps in rockchip_vpu_irq_done() we could check the return value of
> cancel_delayed_work() and if it's false, just give up and let the
> watchdog handle the current ctx?
> 

Yes, that should work.

[..]
> > > > +static int __maybe_unused rockchip_vpu_runtime_resume(struct device *dev)
> > > > +{
> > > > +       struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> > > > +
> > > > +       return clk_bulk_enable(vpu->variant->num_clocks, vpu->clocks);
> > > 
> > > Something for the TODO list: We should disable the clocks as soon as
> > > the hardware becomes idle, because it's super cheap and the delay
> > > between the idle and autosuspend is quite significant.
> > > 
> > 
> > You mean getting rid of autosuspend, right?
> > 
> 
> Not exactly. The autosuspend is to avoid too frequent *power*
> transitions, which could be costly. Actually, even if we get rid of
> it, the genpd code will still throttle runtime suspends based on the
> PM domain suspend/resume latency it measured.
> 
> The only way to control the clocks without throttling is managing them
> explicitly, just before the call to pm_runtime_put_autosuspend() or
> after pm_runtime_get_sync().
> 

OK.

[..]
> 
> > 
> > Right. However, it seems to me we still need to set a value,
> > and return it to userspace when userspace doesn't provide any.
> > 
> 
> There was another discussion about this wrt the venus driver and the
> conclusion is to specify this for codecs as follows:
> 
>     For compressed formats (and only those!) userspace can set sizeimage to a
>     proposed value. The driver may either ignore it and just set its own value,
>     or modify it to satisfy HW requirements. The returned value will be used
>     by REQBUFS when it allocates buffers.
> 
> So I guess the driver could reset it to default if it doesn't sound
> reasonable (0?).
> 

OK.

> [snip]
> > > > +void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
> > > > +                                   struct rockchip_vpu_ctx *ctx)
> > > > +{
> > > > +       struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> > > > +       unsigned int width, height;
> > > > +
> > > > +       ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(ctx, false);
> > > > +
> > > > +       memset(fmt, 0, sizeof(*fmt));
> > > > +
> > > > +       width = clamp(fmt->width, ctx->vpu_dst_fmt->frmsize.min_width,
> > > > +                     ctx->vpu_dst_fmt->frmsize.max_width);
> > > > +       height = clamp(fmt->height, ctx->vpu_dst_fmt->frmsize.min_height,
> > > > +                      ctx->vpu_dst_fmt->frmsize.max_height);
> > > > +       fmt->field = V4L2_FIELD_NONE;
> > > > +       fmt->colorspace = ctx->colorspace;
> > > > +       fmt->ycbcr_enc = ctx->ycbcr_enc;
> > > > +       fmt->xfer_func = ctx->xfer_func;
> > > > +       fmt->quantization = ctx->quantization;
> > > 
> > > Ditto.
> > > 
> > > > +
> > > > +       fill_pixfmt_mp(fmt, ctx->vpu_src_fmt->fourcc, width, height);
> > > > +}
> > > 
> > > These two don't seem to be very encoder-specific. In particular,
> > > rockchip_vpu_enc_reset_dst_fmt() is not even used by the encoder after
> > > the context is initialized, but it's going to be used by the decoder
> > > to reset the raw format when the coded format changes (similarly to
> > > rockchip_vpu_enc_reset_src_fmt() for encoder).
> > > 
> > 
> > Yeah, I'm aware there might be some commong logic here, but since
> > the driver is an encoder only for now, I decided to let it be.
> > 
> > However, I've made sure the driver is ready to support
> > decoding and other variants, with fairly simple changes.
> > 
> 
> Fair enough.
> 
> [snip]
> > > > +void rockchip_vpu_jpeg_render(struct rockchip_vpu_jpeg_ctx *ctx)
> > > 
> > > nit: I'm not sure "render" is the right word here. Maybe it's just me,
> > > but I associate it with rendering of visible graphics. Perhaps
> > > "assemble" would be better?
> > > 
> > 
> > I don't think render is gfx only, but.. it might be confusing, so
> > how about "rockchip_vpu_jpeg_header_prepare" or "rockchip_vpu_jpeg_header_set" ?
> > 
> > This function might be moved to lib/jpeg.c, so getting the name
> > right is not that much of a nitpick.
> > 
> 
> rockchip_vpu_jpeg_header_assemble()? (My preference for "assemble"
> comes from building the header from the pieces as the function does.)
> 

OK, let's go with _assemble.

Thanks,
Ezequiel
