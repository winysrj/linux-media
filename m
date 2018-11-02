Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45108 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbeKBMWF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 08:22:05 -0400
Received: by mail-yw1-f66.google.com with SMTP id i185-v6so230883ywa.12
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 20:16:31 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id r18-v6sm16025745ywa.16.2018.11.01.20.16.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 20:16:29 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id v199-v6so254410ywg.1
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 20:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <1539071603-1588-1-git-send-email-mgottam@codeaurora.org>
 <0e0f689e-f6e3-73a6-e145-deb2ef7cafc8@linaro.org> <5037ca4b0dd0de80750e35ca889d4225@codeaurora.org>
 <4ccc50dc-c819-ca49-11d2-415053c02c0a@linaro.org>
In-Reply-To: <4ccc50dc-c819-ca49-11d2-415053c02c0a@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 2 Nov 2018 12:16:17 +0900
Message-ID: <CAAFQd5AgQNZpNfAf_aoZfqzpZj7iohCKaBO0t4bntL2q1SyVhg@mail.gmail.com>
Subject: Re: [PATCH] media: venus: add support for selection rectangles
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: mgottam@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 2, 2018 at 12:02 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Malathi,
>
> On 11/1/18 3:10 PM, mgottam@codeaurora.org wrote:
> > On 2018-10-16 15:11, Stanimir Varbanov wrote:
> >> Hi Malathi,
> >>
> >> On 10/09/2018 10:53 AM, Malathi Gottam wrote:
> >>> Handles target type crop by setting the new active rectangle
> >>> to hardware. The new rectangle should be within YUV size.
> >>>
> >>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >>> ---
> >>>  drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++--
> >>>  1 file changed, 17 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/qcom/venus/venc.c
> >>> b/drivers/media/platform/qcom/venus/venc.c
> >>> index 3f50cd0..754c19a 100644
> >>> --- a/drivers/media/platform/qcom/venus/venc.c
> >>> +++ b/drivers/media/platform/qcom/venus/venc.c
> >>> @@ -478,16 +478,31 @@ static int venc_g_fmt(struct file *file, void
> >>> *fh, struct v4l2_format *f)
> >>>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
> >>>  {
> >>>      struct venus_inst *inst = to_inst(file);
> >>> +    int ret;
> >>> +    u32 buftype;
> >>>
> >>>      if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> >>>          return -EINVAL;
> >>>
> >>>      switch (s->target) {
> >>>      case V4L2_SEL_TGT_CROP:
> >>> -        if (s->r.width != inst->out_width ||
> >>> -            s->r.height != inst->out_height ||
> >>> +        if (s->r.width > inst->out_width ||
> >>> +            s->r.height > inst->out_height ||
> >>>              s->r.top != 0 || s->r.left != 0)
> >>>              return -EINVAL;

Note that returning -EINVAL is not what VIDIOC_S_SELECTION should do here.

As per the general V4L2 spec [1], VIDIOC_S_SELECTION is expected to
adjust the crop rectangle "as close as possible to the requested one".
In this case that would likely mean something like this:

if (s->r.left != 0) {
    s->r.width += s->r.left;
    s->r.left = 0;
}

if (s->r.top != 0) {
    s->r.height += s->r.top;
    s->r.top = 0;
}

if (s->r.width > inst->out_width)
    s->r.width = inst->out_width;

if (s->r.height > inst->out_height)
    s->r.height = inst->out_height;

[1] https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-selection.html

> >>> +        if (s->r.width != inst->width ||
> >>> +            s->r.height != inst->height) {
> >>> +            buftype = HFI_BUFFER_OUTPUT;
> >>> +            ret = venus_helper_set_output_resolution(inst,
> >>> +                                 s->r.width,
> >>> +                                 s->r.height,
> >>> +                                 buftype);
> >>
> >> I'm afraid that set_output_resolution cannot be called at any time. Do
> >> you think we can set it after start_session?
> >
> > Yes Stan, we can set output_resolution after the session has been
> > initialization.
> > As per the spec, this call s_selection is an optional step under
> > Initialization
> > procedure of encoder even before we request buffers.
>
> What spec you are referring to? The spec for the encoders [1] or
> something else.

For our convenience, Hans was nice enough to host a compiled version at:
https://hverkuil.home.xs4all.nl/request-api/uapi/v4l/dev-encoder.html

Best regards,
Tomasz
