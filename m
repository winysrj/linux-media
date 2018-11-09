Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43358 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKIULv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 15:11:51 -0500
Received: by mail-yb1-f195.google.com with SMTP id h187-v6so827865ybg.10
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 02:31:52 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id d7-v6sm1749522ywd.54.2018.11.09.02.31.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 02:31:50 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id w17-v6so842926ybl.6
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 02:31:49 -0800 (PST)
MIME-Version: 1.0
References: <1541749141-6989-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5CwhPTmh4kF6O23Os2tihaWEez1SM=Th6BGkf_wo_LYDA@mail.gmail.com> <be2906d9d9c3f4618d21d4adef662d75@codeaurora.org>
In-Reply-To: <be2906d9d9c3f4618d21d4adef662d75@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 9 Nov 2018 19:31:35 +0900
Message-ID: <CAAFQd5DE4ajq6HxHhKjYFHaqFpBXJdWNcv3Qr95B9dBP=zGsJQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: add support for selection rectangles
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On Fri, Nov 9, 2018 at 6:20 PM <mgottam@codeaurora.org> wrote:
>
> On 2018-11-09 07:56, Tomasz Figa wrote:
> > Hi Malathi,
> >
> > On Fri, Nov 9, 2018 at 4:39 PM Malathi Gottam <mgottam@codeaurora.org>
> > wrote:
> >>
> >> Handles target type crop by setting the new active rectangle
> >> to hardware. The new rectangle should be within YUV size.
> >>
> >> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/venc.c | 26
> >> ++++++++++++++++++++++----
> >>  1 file changed, 22 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/venc.c
> >> b/drivers/media/platform/qcom/venus/venc.c
> >> index ce85962..d26c129 100644
> >> --- a/drivers/media/platform/qcom/venus/venc.c
> >> +++ b/drivers/media/platform/qcom/venus/venc.c
> >> @@ -478,16 +478,34 @@ static int venc_g_fmt(struct file *file, void
> >> *fh, struct v4l2_format *f)
> >>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection
> >> *s)
> >>  {
> >>         struct venus_inst *inst = to_inst(file);
> >> +       int ret;
> >> +       u32 buftype;
> >>
> >>         if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> >>                 return -EINVAL;
> >>
> >>         switch (s->target) {
> >>         case V4L2_SEL_TGT_CROP:
> >> -               if (s->r.width != inst->out_width ||
> >> -                   s->r.height != inst->out_height ||
> >> -                   s->r.top != 0 || s->r.left != 0)
> >> -                       return -EINVAL;
> >> +               if (s->r.left != 0) {
> >> +                       s->r.width += s->r.left;
> >> +                       s->r.left = 0;
> >> +               }
> >> +
> >> +               if (s->r.top != 0) {
> >> +                       s->r.height += s->r.top;
> >> +                       s->r.top = 0;
> >> +               }
> >> +
> >> +               if (s->r.width > inst->width)
> >> +                       s->r.width = inst->width;
> >> +               else
> >> +                       inst->width = s->r.width;
> >> +
> >> +               if (s->r.height > inst->height)
> >> +                       s->r.height = inst->height;
> >> +               else
> >> +                       inst->height = s->r.height;
> >> +
> >
> > From semantic point of view, it looks fine, but where is the rectangle
> > actually set to the hardware?
> >
> > Best regards,
> > Tomasz
>
> As this set selection call occurs before the hfi session initialization,
> for now we are holding these values in driver.
>
> As this call is followed by VIDIOC_REQBUFS(), as a part of this
> we have venc_init_session
>
> static int venc_init_session(struct venus_inst *inst)
> {
>         int ret;
>
>         ret = hfi_session_init(inst, inst->fmt_cap->pixfmt);
>         if (ret)
>                 return ret;
>
>         ret = venus_helper_set_input_resolution(inst, inst->width,
>                                                 inst->height);
>         if (ret)
>                 goto deinit;
>
>         ret = venus_helper_set_output_resolution(inst, inst->width,
>                                                  inst->height,
>                                                  HFI_BUFFER_OUTPUT);

Something sounds not right here. Shouldn't one of the width/height be
the OUPUT format and the other the selection CROP target rectangle?

>         if (ret)
>                 goto deinit;
>
>         ret = venus_helper_set_color_format(inst, inst->fmt_out->pixfmt);
>         if (ret)
>                 goto deinit;
>
>         ret = venc_set_properties(inst);
>
>
>  From here we set these values to hardware.

Okay, thanks for the explanation. In this case, we must return -EBUSY
if selection is attempted to be set after the session is initialized.

Best regards,
Tomasz
