Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43642 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeKMTLA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:11:00 -0500
Received: by mail-yw1-f68.google.com with SMTP id u202-v6so2414067ywg.10
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 01:13:50 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id h62-v6sm4927158ywa.53.2018.11.13.01.13.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 01:13:48 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id p144-v6so5049291yba.11
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 01:13:48 -0800 (PST)
MIME-Version: 1.0
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5BcFr11Hpngpn6hNL91OibAxUv25yh2qMohgfxsKusACw@mail.gmail.com>
 <8fe1d205-c5e7-01a0-9569-d3268911cddd@linaro.org> <38dfc098517b3ddb5d96195f2e27429d@codeaurora.org>
 <86714c89-20ec-07c8-2569-65e78e8d584d@linaro.org>
In-Reply-To: <86714c89-20ec-07c8-2569-65e78e8d584d@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 13 Nov 2018 18:13:36 +0900
Message-ID: <CAAFQd5DXWUCB7HvsLyVYU+h=2j6y1v3kcsTtHfNZYjfbHEgWGw@mail.gmail.com>
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
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

On Tue, Nov 13, 2018 at 5:12 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Malathi,
>
> On 11/13/18 9:28 AM, mgottam@codeaurora.org wrote:
> > On 2018-11-12 18:04, Stanimir Varbanov wrote:
> >> Hi Tomasz,
> >>
> >> On 10/23/2018 05:50 AM, Tomasz Figa wrote:
> >>> Hi Malathi,
> >>>
> >>> On Tue, Oct 9, 2018 at 4:58 PM Malathi Gottam
> >>> <mgottam@codeaurora.org> wrote:
> >>>>
> >>>> For lower resolutions, incase of encoder, the compressed
> >>>> frame size is more than half of the corresponding input
> >>>> YUV. Keep the size as same as YUV considering worst case.
> >>>>
> >>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >>>> ---
> >>>>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/media/platform/qcom/venus/helpers.c
> >>>> b/drivers/media/platform/qcom/venus/helpers.c
> >>>> index 2679adb..05c5423 100644
> >>>> --- a/drivers/media/platform/qcom/venus/helpers.c
> >>>> +++ b/drivers/media/platform/qcom/venus/helpers.c
> >>>> @@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32
> >>>> width, u32 height)
> >>>>         }
> >>>>
> >>>>         if (compressed) {
> >>>> -               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
> >>>> +               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;
> >>>>                 return ALIGN(sz, SZ_4K);
> >>>>         }
> >>>
> >>> Note that the driver should not enforce one particular buffer size for
> >>> bitstream buffers unless it's a workaround for broken firmware or
> >>> hardware. The userspace should be able to select the desired size.
> >>
> >> Good point! Yes, we have to extend set_fmt to allow bigger sizeimage for
> >> the compressed buffers (not only for encoder).
> >
> > So Stan you meant to say that we should allow s_fmt to accept client
> > specified size?
>
> yes but I do expect:
>
> new_sizeimage = max(user_sizeimage, venus_helper_get_framesz)
>
> and also user_sizeimage should be sanitized.
>
> > If so should we set the inst->input_buf_size here in venc_s_fmt?
> >
> > @@ -333,10 +333,10 @@static const struct venus_format *
> > venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
> >
> >         pixmp->num_planes = fmt->num_planes;
> >         pixmp->flags = 0;
> > -
> > -       pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
> > -                                                    pixmp->width,
> > -                                                    pixmp->height);
> > +       if (!pfmt[0].sizeimage)
> > +               pfmt[0].sizeimage =
> > venus_helper_get_framesz(pixmp->pixelformat,
> > +                                                            pixmp->width,
> > +
> > pixmp->height);
>
> yes, but please make
>
> pfmt[0].sizeimage = max(pfmt[0].sizeimage, venus_helper_get_framesz)
>
> and IMO this should be only for CAPTURE queue i.e. inst->output_buf_size
>
> I'm still not sure do we need it for OUTPUT encoder queue.
>

This would be indeed only for the queues that operate on a coded
bitstream, i.e. both encoder CAPTURE and decoder OUTPUT.

For image formats, sizeimage should be calculated by the driver based
on the bytesperline and height. (Bytesperline may be fixed, if the
hardware doesn't support flexible strides, but if it does, it's
strongly recommended to use the bytesperline coming from the
application as the stride +/- any necessary sanity checks.)

Best regards,
Tomasz
