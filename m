Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40737 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbeKLS2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:28:01 -0500
Received: by mail-oi1-f194.google.com with SMTP id u130-v6so6497665oie.7
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 00:35:52 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id t84-v6sm8533125oib.3.2018.11.12.00.35.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 00:35:50 -0800 (PST)
Received: by mail-ot1-f44.google.com with SMTP id u3so2138623ota.5
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 00:35:50 -0800 (PST)
MIME-Version: 1.0
References: <1541749141-6989-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5CwhPTmh4kF6O23Os2tihaWEez1SM=Th6BGkf_wo_LYDA@mail.gmail.com>
 <be2906d9d9c3f4618d21d4adef662d75@codeaurora.org> <CAAFQd5DE4ajq6HxHhKjYFHaqFpBXJdWNcv3Qr95B9dBP=zGsJQ@mail.gmail.com>
In-Reply-To: <CAAFQd5DE4ajq6HxHhKjYFHaqFpBXJdWNcv3Qr95B9dBP=zGsJQ@mail.gmail.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 12 Nov 2018 17:35:37 +0900
Message-ID: <CAPBb6MUWieRTvrYR_UacVe-EAD1_VjTMehL7J2P=Ni8W7ELsXw@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: add support for selection rectangles
To: Tomasz Figa <tfiga@chromium.org>
Cc: mgottam@codeaurora.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 9, 2018 at 7:31 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Malathi,
>
> On Fri, Nov 9, 2018 at 6:20 PM <mgottam@codeaurora.org> wrote:
> >
> > On 2018-11-09 07:56, Tomasz Figa wrote:
> > > Hi Malathi,
> > >
> > > On Fri, Nov 9, 2018 at 4:39 PM Malathi Gottam <mgottam@codeaurora.org>
> > > wrote:
> > >>
> > >> Handles target type crop by setting the new active rectangle
> > >> to hardware. The new rectangle should be within YUV size.
> > >>
> > >> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> > >> ---
> > >>  drivers/media/platform/qcom/venus/venc.c | 26
> > >> ++++++++++++++++++++++----
> > >>  1 file changed, 22 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/drivers/media/platform/qcom/venus/venc.c
> > >> b/drivers/media/platform/qcom/venus/venc.c
> > >> index ce85962..d26c129 100644
> > >> --- a/drivers/media/platform/qcom/venus/venc.c
> > >> +++ b/drivers/media/platform/qcom/venus/venc.c
> > >> @@ -478,16 +478,34 @@ static int venc_g_fmt(struct file *file, void
> > >> *fh, struct v4l2_format *f)
> > >>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection
> > >> *s)
> > >>  {
> > >>         struct venus_inst *inst = to_inst(file);
> > >> +       int ret;
> > >> +       u32 buftype;

Looks like these two variables are not used anymore?

> > >>
> > >>         if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > >>                 return -EINVAL;
> > >>
> > >>         switch (s->target) {
> > >>         case V4L2_SEL_TGT_CROP:
> > >> -               if (s->r.width != inst->out_width ||
> > >> -                   s->r.height != inst->out_height ||
> > >> -                   s->r.top != 0 || s->r.left != 0)
> > >> -                       return -EINVAL;
> > >> +               if (s->r.left != 0) {
> > >> +                       s->r.width += s->r.left;
> > >> +                       s->r.left = 0;
> > >> +               }
> > >> +
> > >> +               if (s->r.top != 0) {
> > >> +                       s->r.height += s->r.top;
> > >> +                       s->r.top = 0;
> > >> +               }
> > >> +
> > >> +               if (s->r.width > inst->width)
> > >> +                       s->r.width = inst->width;
> > >> +               else
> > >> +                       inst->width = s->r.width;
> > >> +
> > >> +               if (s->r.height > inst->height)
> > >> +                       s->r.height = inst->height;
> > >> +               else
> > >> +                       inst->height = s->r.height;
> > >> +
> > >
> > > From semantic point of view, it looks fine, but where is the rectangle
> > > actually set to the hardware?
> > >
> > > Best regards,
> > > Tomasz
> >
> > As this set selection call occurs before the hfi session initialization,
> > for now we are holding these values in driver.
> >
> > As this call is followed by VIDIOC_REQBUFS(), as a part of this
> > we have venc_init_session
> >
> > static int venc_init_session(struct venus_inst *inst)
> > {
> >         int ret;
> >
> >         ret = hfi_session_init(inst, inst->fmt_cap->pixfmt);
> >         if (ret)
> >                 return ret;
> >
> >         ret = venus_helper_set_input_resolution(inst, inst->width,
> >                                                 inst->height);
> >         if (ret)
> >                 goto deinit;
> >
> >         ret = venus_helper_set_output_resolution(inst, inst->width,
> >                                                  inst->height,
> >                                                  HFI_BUFFER_OUTPUT);
>
> Something sounds not right here. Shouldn't one of the width/height be
> the OUPUT format and the other the selection CROP target rectangle?

Yeah, I don't see where the stride of the input (from HFI perspective)
buffer is set, so unless I missed something that would not capture the
correct part of the buffer.

Also doesn't Venus support non-zero left and top parameters for the
selection rectangle?
