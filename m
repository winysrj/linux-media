Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:38933 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933274AbeGFRJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 13:09:32 -0400
Received: by mail-it0-f66.google.com with SMTP id p185-v6so18089254itp.4
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 10:09:32 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id o64-v6sm4687054ioe.30.2018.07.06.10.09.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jul 2018 10:09:30 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id l14-v6so1515621iob.7
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 10:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUBi+Dn5v4PKngxztFgKd6CA7bC1pKvWd1GMY9NJFoyZQ@mail.gmail.com> <b26cb8df-fac3-5941-9941-a6b3ca8af62e@linaro.org>
In-Reply-To: <b26cb8df-fac3-5941-9941-a6b3ca8af62e@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Sat, 7 Jul 2018 02:09:17 +0900
Message-ID: <CAPBb6MW0RryRBHCNMS71MJy7Dy6wyiJMoPRwPCQOK3Ui8CfKOg@mail.gmail.com>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: vgarodia@codeaurora.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 7, 2018, 00:12 Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 07/02/2018 11:51 AM, Alexandre Courbot wrote:
> > On Mon, Jul 2, 2018 at 4:44 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
> >>
> >> Exisiting code returns the max of the decoded
> >
> > s/Exisiting/Existing
> >
> > Also the lines of your commit message look pretty short - I think the
> > standard for kernel log messges is 72 chars?
> >
> >> size and buffer size. It turns out that buffer
> >> size is always greater due to hardware alignment
> >> requirement. As a result, payload size given to
> >> client is incorrect. This change ensures that
> >> the bytesused is assigned to actual payload size.
> >>
> >> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
> >> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> >> index d079aeb..ada1d2f 100644
> >> --- a/drivers/media/platform/qcom/venus/vdec.c
> >> +++ b/drivers/media/platform/qcom/venus/vdec.c
> >> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
> >>
> >>                 vb = &vbuf->vb2_buf;
> >>                 vb->planes[0].bytesused =
> >> -                       max_t(unsigned int, opb_sz, bytesused);
> >> +                       min_t(unsigned int, opb_sz, bytesused);
> >
> > Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> > Tested-by: Alexandre Courbot <acourbot@chromium.org>
> >
> > This indeed reports the correct size to the client. If bytesused were
> > larger than the size of the buffer we would be having some trouble
> > anyway.
> >
> > Actually in my tree I was using the following patch:
> >
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -924,13 +924,12 @@ static void vdec_buf_done(struct venus_inst
> > *inst, unsigned int buf_type,
> >
> >                vb = &vbuf->vb2_buf;
> >                vb->planes[0].bytesused =
> > -                       max_t(unsigned int, opb_sz, bytesused);
> > +                       min_t(unsigned int, opb_sz, bytesused);
> >                vb->planes[0].data_offset = data_offset;
> >                vb->timestamp = timestamp_us * NSEC_PER_USEC;
> >                vbuf->sequence = inst->sequence_cap++;
> >                if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
> >                        const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> > -                       vb->planes[0].bytesused = bytesused;
>
> Actually this line doesn't exist in mainline driver. And I don't see a
> reason why to set bytesused twice.

Apologies for being careless - this came from an out-of-tree patch.

>
> >                        v4l2_event_queue_fh(&inst->fh, &ev);
> >
> > Given that we are now taking the minimum of these two values, it seems
> > to me that we don't need to set bytesused again in case we are dealing
> > with the last buffer? Stanimir, what do you think?
> >
>
> --
> regards,
> Stan
