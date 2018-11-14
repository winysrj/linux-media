Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37699 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbeKNVFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 16:05:11 -0500
Received: by mail-yb1-f193.google.com with SMTP id d18-v6so6720551yba.4
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 03:02:25 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id r5-v6sm6987750ywr.80.2018.11.14.03.02.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 03:02:23 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id u103-v6so6715891ybi.5
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 03:02:23 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-4-git-send-email-sgorle@codeaurora.org> <d8cb0c47-a3f7-314b-c65d-3c8eca724e6a@linaro.org>
In-Reply-To: <d8cb0c47-a3f7-314b-c65d-3c8eca724e6a@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 20:02:10 +0900
Message-ID: <CAAFQd5BYVpTZ3sUhLPtaGV7tVNQirW79RY0pPLWYCt3ygVxJBg@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] media: venus: do not destroy video session during
 queue setup
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: sgorle@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 9, 2018 at 7:00 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Srinu,
>
> On 9/29/18 3:00 PM, Srinu Gorle wrote:
> > - open and close video sessions for plane properties is incorrect.
>
> Could you rephrase this statement? I really don't understand what you mean.
>
> > - add check to ensure, same instance persist from driver open to close.
>
> This assumption is wrong. The v4l client can change the codec by SFMT
> without close the device node, in that case we have to destroy and
> create a new session with new codec.

Right.

[snip]
> > +
> >       inst->hfi_codec = to_codec_type(pixfmt);
> >       reinit_completion(&inst->done);
> >
> > diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> > index afe3b36..0035cf2 100644
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -700,6 +700,8 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
> >
> >       *out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> >
> > +     return 0;
>
> OK in present implementation I decided that the codec is settled when
> streamon on both queues is called (i.e. the final session_init is made
> in streamon). IMO the correct one is to init the session in
> reqbuf(output) and deinit session in reqbuf(output, count=0)?
>

Depending on what you mean by "settled" that could be fine.

Generally for initialization, one would typically use REQBUFS(OUTPUT,
>0) (since it's not possible to change the format after the
allocation) or STREAMON(OUTPUT) (to defer the hardware operations
until really necessary).

Since STREAMOFF(OUTPUT) is expected to just trigger a seek,
termination should be done in REQBUFS(OUTPUT, 0) indeed and after that
one should be able to switch to another codec (OUTPUT format).

Best regards,
Tomasz
