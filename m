Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41302 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbeKMT3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:29:25 -0500
Received: by mail-oi1-f194.google.com with SMTP id g188-v6so9707650oif.8
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 01:32:11 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id q65-v6sm5728040oif.6.2018.11.13.01.32.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 01:32:10 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id 40so10713420oth.4
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 01:32:10 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-6-git-send-email-sgorle@codeaurora.org> <a331a717-199d-6d6c-c88d-54f911b942d4@linaro.org>
 <CAPBb6MVio_kYK-P+eASFMzdxbvBMWwQC7-ZjPxP3aaqpMsnEdA@mail.gmail.com> <3097b9b9-e065-e42f-5b19-849313df38c2@linaro.org>
In-Reply-To: <3097b9b9-e065-e42f-5b19-849313df38c2@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 13 Nov 2018 18:31:58 +0900
Message-ID: <CAPBb6MWS9aDMTVwG3cdSq-p=tU-1qhTSj5seXFwDBFROpDrhRw@mail.gmail.com>
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

On Mon, Nov 12, 2018 at 9:20 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 11/12/18 10:12 AM, Alexandre Courbot wrote:
> > Hi Stan,
> >
> > On Thu, Nov 8, 2018 at 7:16 PM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> Hi,
> >>
> >> On 9/29/18 3:00 PM, Srinu Gorle wrote:
> >>> - In video decoder session, update number of bytes used for
> >>>   yuv buffers appropriately for EOS buffers.
> >>>
> >>> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> >>> ---
> >>>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> NACK, that was already discussed see:
> >>
> >> https://patchwork.kernel.org/patch/10630411/
> >
> > I believe you are referring to this discussion?
> >
> > https://lkml.org/lkml/2018/10/2/302
> >
> > In this case, with https://patchwork.kernel.org/patch/10630411/
> > applied, I am seeing the troublesome case of having the last (empty)
> > buffer being returned with a payload of obs_sz, which I believe is
> > incorrect. The present patch seems to restore the correct behavior.
>
> Sorry, I thought that this solution was suggested (and tested on Venus
> v4) by you, right?

That's correct. >_< Looks like I overlooked this case.

>
> >
> > An alternative would be to set the payload as follows:
> >
> > vb2_set_plane_payload(vb, 0, bytesused);
> >
> > This works for SDM845, but IIRC we weren't sure that this would
> > display the correct behavior with all firmware versions?
>
> OK if you are still seeing issues I think we can switch to
> vb2_set_plane_payload(vb, 0, bytesused); for all buffers? I.e. not only
> for buffers with flag V4L2_BUF_FLAG_LAST set.

That's the fix I am currently using in my source tree and it indeed
seems to be ok. I also agree it is better than special-casing EOS
buffers. I have sent a patch for this.

Thanks and sorry for the confusion.
