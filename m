Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40776 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbeKPQOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 11:14:03 -0500
Received: by mail-yw1-f68.google.com with SMTP id l66-v6so9684620ywl.7
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 22:03:04 -0800 (PST)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id l35sm3247771ywh.48.2018.11.15.22.03.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Nov 2018 22:03:02 -0800 (PST)
Received: by mail-yw1-f46.google.com with SMTP id g75so5235976ywb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 22:03:02 -0800 (PST)
MIME-Version: 1.0
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5BcFr11Hpngpn6hNL91OibAxUv25yh2qMohgfxsKusACw@mail.gmail.com>
 <8fe1d205-c5e7-01a0-9569-d3268911cddd@linaro.org> <38dfc098517b3ddb5d96195f2e27429d@codeaurora.org>
 <86714c89-20ec-07c8-2569-65e78e8d584d@linaro.org> <CAAFQd5DXWUCB7HvsLyVYU+h=2j6y1v3kcsTtHfNZYjfbHEgWGw@mail.gmail.com>
 <da2e7cef-5ade-7d43-92c1-f728644e61c9@linaro.org> <CAAFQd5AhepthKo4ShsfFQwB4=ALyRZFf6zzEf99DEEBt2gX_jw@mail.gmail.com>
 <544e62014dc3dab6c13714226157909c@codeaurora.org>
In-Reply-To: <544e62014dc3dab6c13714226157909c@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Nov 2018 15:02:50 +0900
Message-ID: <CAAFQd5BOiAd5vgxZVzP83zZ565py0ovr5hR_SqLitxPoz_8eFA@mail.gmail.com>
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
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

On Fri, Nov 16, 2018 at 1:35 PM <mgottam@codeaurora.org> wrote:
>
> On 2018-11-14 09:21, Tomasz Figa wrote:
> > On Tue, Nov 13, 2018 at 7:46 PM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> Hi Tomasz,
> >>
> >> On 11/13/18 11:13 AM, Tomasz Figa wrote:
> >> > On Tue, Nov 13, 2018 at 5:12 PM Stanimir Varbanov
> >> > <stanimir.varbanov@linaro.org> wrote:
> >> >>
> >> >> Hi Malathi,
> >> >>
> >> >> On 11/13/18 9:28 AM, mgottam@codeaurora.org wrote:
> >> >>> On 2018-11-12 18:04, Stanimir Varbanov wrote:
> >> >>>> Hi Tomasz,
> >> >>>>
> >> >>>> On 10/23/2018 05:50 AM, Tomasz Figa wrote:
> >> >>>>> Hi Malathi,
> >> >>>>>
> >> >>>>> On Tue, Oct 9, 2018 at 4:58 PM Malathi Gottam
> >> >>>>> <mgottam@codeaurora.org> wrote:
> >> >>>>>>
> >> >>>>>> For lower resolutions, incase of encoder, the compressed
> >> >>>>>> frame size is more than half of the corresponding input
> >> >>>>>> YUV. Keep the size as same as YUV considering worst case.
> >> >>>>>>
> >> >>>>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >> >>>>>> ---
> >> >>>>>>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
> >> >>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >>>>>>
> >> >>>>>> diff --git a/drivers/media/platform/qcom/venus/helpers.c
> >> >>>>>> b/drivers/media/platform/qcom/venus/helpers.c
> >> >>>>>> index 2679adb..05c5423 100644
> >> >>>>>> --- a/drivers/media/platform/qcom/venus/helpers.c
> >> >>>>>> +++ b/drivers/media/platform/qcom/venus/helpers.c
> >> >>>>>> @@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32
> >> >>>>>> width, u32 height)
> >> >>>>>>         }
> >> >>>>>>
> >> >>>>>>         if (compressed) {
> >> >>>>>> -               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
> >> >>>>>> +               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;
> >> >>>>>>                 return ALIGN(sz, SZ_4K);
> >> >>>>>>         }
> >> >>>>>
> >> >>>>> Note that the driver should not enforce one particular buffer size for
> >> >>>>> bitstream buffers unless it's a workaround for broken firmware or
> >> >>>>> hardware. The userspace should be able to select the desired size.
> >> >>>>
> >> >>>> Good point! Yes, we have to extend set_fmt to allow bigger sizeimage for
> >> >>>> the compressed buffers (not only for encoder).
> >> >>>
> >> >>> So Stan you meant to say that we should allow s_fmt to accept client
> >> >>> specified size?
> >> >>
> >> >> yes but I do expect:
> >> >>
> >> >> new_sizeimage = max(user_sizeimage, venus_helper_get_framesz)
> >> >>
> >> >> and also user_sizeimage should be sanitized.
> >> >>
> >> >>> If so should we set the inst->input_buf_size here in venc_s_fmt?
> >> >>>
> >> >>> @@ -333,10 +333,10 @@static const struct venus_format *
> >> >>> venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
> >> >>>
> >> >>>         pixmp->num_planes = fmt->num_planes;
> >> >>>         pixmp->flags = 0;
> >> >>> -
> >> >>> -       pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
> >> >>> -                                                    pixmp->width,
> >> >>> -                                                    pixmp->height);
> >> >>> +       if (!pfmt[0].sizeimage)
> >> >>> +               pfmt[0].sizeimage =
> >> >>> venus_helper_get_framesz(pixmp->pixelformat,
> >> >>> +                                                            pixmp->width,
> >> >>> +
> >> >>> pixmp->height);
> >> >>
> >> >> yes, but please make
> >> >>
> >> >> pfmt[0].sizeimage = max(pfmt[0].sizeimage, venus_helper_get_framesz)
> >> >>
> >> >> and IMO this should be only for CAPTURE queue i.e. inst->output_buf_size
> >> >>
> >> >> I'm still not sure do we need it for OUTPUT encoder queue.
> >> >>
> >> >
> >> > This would be indeed only for the queues that operate on a coded
> >> > bitstream, i.e. both encoder CAPTURE and decoder OUTPUT.
> >>
> >> Thanks for the confirmation.
>
> So in case of encoder, adhering to the above comments
>
> @@ -333,10 +333,10 @@static const struct venus_format *
> venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
>
> +       sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
>                                                       pixmp->width,
>                                                       pixmp->height);

Note that in current version of the specification the application is
not expected to provide the width and height on the CAPTURE queue for
the encoder, so you would end up with 0 here. That said, I can see a
value in setting those as a hint to the driver, so perhaps it's not a
bad idea to add it to the API.

> +       pfmt[0].sizeimage = max(ALIGN(pfmt[0].sizeimage, SZ_4K),
> sizeimage);
>
> @@ -408,8 +412,10 @@ static int venc_s_fmt(struct file *file, void *fh,
> struct v4l2_format *f)
>
>          if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>                  inst->fmt_out = fmt;
> -       else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +       else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>                  inst->fmt_cap = fmt;
> +               inst->output_buf_size = pixmp->plane_fmt[0].sizeimage;
> +       }
>
>
> >>
> >> >
> >> > For image formats, sizeimage should be calculated by the driver based
> >> > on the bytesperline and height. (Bytesperline may be fixed, if the
> >> > hardware doesn't support flexible strides, but if it does, it's
> >> > strongly recommended to use the bytesperline coming from the
> >> > application as the stride +/- any necessary sanity checks.)
> >>
> >> the hw should support stride but I'm not sure is that exposed by the
> >> firmware interface.
> >
> > After thinking a bit more on this, there is actually some redundancy
> > between format width and crop width, since one should be normally able
> > to just set the format width to the buffer stride and crop to the
> > buffer width and have arbitrary strides supported (+/- hw alignment
> > requirements, but that's something that has to always be accounted
> > for).
> >
> > Best regards,
> > Tomasz
>
> I hope the above change, takes into consideration the application
> provided format width and also uses it in calculation of sizeimage which
> is compared against application provided size aligned.
>

I think it should work +/- the one minor remark above. Thanks.

Best regards,
Tomasz
