Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38352 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbeKLSEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:04:25 -0500
Received: by mail-ot1-f67.google.com with SMTP id u3so2087680ota.5
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 00:12:20 -0800 (PST)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id w12-v6sm7066975oiw.10.2018.11.12.00.12.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 00:12:18 -0800 (PST)
Received: by mail-oi1-f173.google.com with SMTP id w66-v6so6462133oiw.4
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 00:12:18 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-6-git-send-email-sgorle@codeaurora.org> <a331a717-199d-6d6c-c88d-54f911b942d4@linaro.org>
In-Reply-To: <a331a717-199d-6d6c-c88d-54f911b942d4@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 12 Nov 2018 17:12:06 +0900
Message-ID: <CAPBb6MVio_kYK-P+eASFMzdxbvBMWwQC7-ZjPxP3aaqpMsnEdA@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] media: venus: update number of bytes used field
 properly for EOS frames
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: sgorle@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

On Thu, Nov 8, 2018 at 7:16 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi,
>
> On 9/29/18 3:00 PM, Srinu Gorle wrote:
> > - In video decoder session, update number of bytes used for
> >   yuv buffers appropriately for EOS buffers.
> >
> > Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> > ---
> >  drivers/media/platform/qcom/venus/vdec.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> NACK, that was already discussed see:
>
> https://patchwork.kernel.org/patch/10630411/

I believe you are referring to this discussion?

https://lkml.org/lkml/2018/10/2/302

In this case, with https://patchwork.kernel.org/patch/10630411/
applied, I am seeing the troublesome case of having the last (empty)
buffer being returned with a payload of obs_sz, which I believe is
incorrect. The present patch seems to restore the correct behavior.

An alternative would be to set the payload as follows:

vb2_set_plane_payload(vb, 0, bytesused);

This works for SDM845, but IIRC we weren't sure that this would
display the correct behavior with all firmware versions?

>
> >
> > diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> > index 311f209..a48eed1 100644
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -978,7 +978,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
> >
> >               if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
> >                       const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> > -
> > +                     vb->planes[0].bytesused = bytesused;
> >                       v4l2_event_queue_fh(&inst->fh, &ev);
> >               }
> >       } else {
> >
>
> --
> regards,
> Stan
