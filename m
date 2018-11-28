Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35464 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2KaY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 05:30:24 -0500
Received: by mail-yb1-f194.google.com with SMTP id z2-v6so19068ybj.2
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 15:27:06 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id p3sm16930ywc.14.2018.11.28.15.27.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 15:27:04 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id g75so22709ywb.1
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2018 15:27:03 -0800 (PST)
MIME-Version: 1.0
References: <20181121195907.23752-1-ezequiel@collabora.com>
 <CAAFQd5ArFG0hU6MgcyLd+_UOP3+T_U-aw2FXv6sE7fGqVCVGqw@mail.gmail.com>
 <c36f68773cec5aca0509d8af5172812110df73a5.camel@collabora.com>
 <CAAFQd5Ds=NGfXeEQDkF40-ZPisLah_Bc2j4s4oRp75dKxGr05g@mail.gmail.com> <a3c12459e08b64ac374d7bd477aff3079590c5d4.camel@collabora.com>
In-Reply-To: <a3c12459e08b64ac374d7bd477aff3079590c5d4.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 28 Nov 2018 15:26:52 -0800
Message-ID: <CAAFQd5CVAtzzQbo+AFhoZkAyYE7Y+5bwavZT_tsdE1h3b_X7LA@mail.gmail.com>
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

On Wed, Nov 28, 2018 at 10:05 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> On Tue, 2018-11-27 at 19:09 +0900, Tomasz Figa wrote:
> > On Fri, Nov 23, 2018 at 5:24 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > [snip]
> > > > > +const struct rockchip_vpu_variant rk3288_vpu_variant = {
> > > > > +       .enc_offset = 0x0,
> > > > > +       .enc_fmts = rk3288_vpu_enc_fmts,
> > > > > +       .num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
> > > > > +       .codec_ops = rk3288_vpu_codec_ops,
> > > > > +       .codec = RK_VPU_CODEC_JPEG,
> > > > > +       .vepu_irq = rk3288_vepu_irq,
> > > > > +       .init = rk3288_vpu_hw_init,
> > > > > +       .clk_names = {"aclk", "hclk"},
> > > >
> > > > nit: Spaces inside the brackets.
> > > >
> > >
> > > You mean you this style is prefered?
> > >
> > > .clk_names = { "aclk", "hclk" },
> > >
> > > Grepping thru sources, it seems there is no convention on this,
> > > so it's your call.
> > >
> >
> > I thought this is a part of CodingStyle, but it doesn't seem to
> > mention it. I personally prefer to have the spaces there, but we can
> > go with your personal preferences here. :)
>
> OK.
>
> > [snip]
> > > > > +        * by .vidioc_s_fmt_vid_cap_mplane() callback
> > > > > +        */
> > > > > +       reg = VEPU_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width);
> > > > > +       vepu_write_relaxed(vpu, reg, VEPU_REG_INPUT_LUMA_INFO);
> > > > > +
> > > > > +       reg = VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(0) |
> > > > > +             VEPU_REG_IN_IMG_CTRL_OVRFLB(0);
> > > >
> > > > For reference, this register controls the input crop, as the offset
> > > > from the right/bottom within the last macroblock. The offset from the
> > > > right must be divided by 4 and so the crop must be aligned to 4 pixels
> > > > horizontally.
> > > >
> > >
> > > OK, I'll add a comment.
> > >
> >
> > I meant to refer to the comment Hans had, about input images of
> > resolutions that are not of full macroblocks, so the comment would
> > probably go to the TODO file together with Hans's note.
>
> Got it.
>
> > [snip]
> > > > > +static inline u32 vepu_read(struct rockchip_vpu_dev *vpu, u32 reg)
> > > > > +{
> > > > > +       u32 val = readl(vpu->enc_base + reg);
> > > > > +
> > > > > +       vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
> > > >
> > > > I remember seeing this "MARK" in the logs when debugging. I don't
> > > > think it's desired here.
> > > >
> > > > How about printing "%s(%03d) = %08x\n" for reads and "%s(%08x,
> > > > %03d)\n" for writes?
> >
> > Actually, I missed the 0x prefix for hex values and possibly also
> > changing the decimal register offset to hexadecimal:
> > "%s(0x%04x) = 0x%08x\n"
> >
> > >
> > > Makes sense, but why a %s string format?
> > >
> >
> > For __func__, so that we end up with messages like:
> >
> > vepu_write(0x12345678, 0x0123)
> > vepu_read(0x0123) = 0x12345678
> >
>
> vepu_debug already uses __func__, so it would look like this:
>
> [   27.125090] vepu_write_relaxed:215: 0x001f = 0x01010101
> [   27.127413] vepu_write:221: 0x0069 = 0xfc000000
> [   27.129673] vepu_write_relaxed:215: 0x0036 = 0x00001000
> [   27.132079] vepu_write:221: 0x0067 = 0x00f01461
> [   27.135042] vepu_read:229: 0x006d = 0x00001003
> [   27.137450] vepu_read:229: 0x0035 = 0x00020318
> [   27.139778] vepu_write:221: 0x006d = 0x00000000
> [   27.142144] vepu_write:221: 0x0036 = 0x00000000
>
> Unless we use a different debug macro for i/o access.
>

Okay, I missed that part of vepu_debug(). We can drop the %s and
explicit __func__ from the message then.

> > [snip]
> > > > > +       dst->field = src->field;
> > > > > +       dst->timecode = src->timecode;
> > > >
> > > > Time code is only valid if the buffer has V4L2_BUF_FLAG_TIMECODE set.
> > > > I don't think there is any use case for mem2mem devices for it.
> > > >
> > >
> > > Right. Other mem2mem drivers seem to pass thru the timecode like this:
> > >
> > >         if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
> > >                 out_vb->timecode = in_vb->timecode;
> > >
> > > It fails a v4l2-compliance test without it.
> > >
> >
> > Hmm, I don't see the spec defining it to be copied by a mem2mem device
> > and I wonder if it's actually of any use for those. Hans, could you
> > comment on this?
> >
>
> I asked Hans about this and he said timecode should behave as timestamp,
> and be carried from the output queue to the capture queue.
>
> This helper will take care of it: https://patchwork.linuxtv.org/patch/52961/
>

Fair enough.

Best regards,
Tomasz
