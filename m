Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:36447 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbeJLPhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 11:37:37 -0400
Received: by mail-it1-f196.google.com with SMTP id c85-v6so17078412itd.1
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 01:06:23 -0700 (PDT)
Received: from mail-it1-f181.google.com (mail-it1-f181.google.com. [209.85.166.181])
        by smtp.gmail.com with ESMTPSA id g200-v6sm257888ita.44.2018.10.12.01.06.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 01:06:21 -0700 (PDT)
Received: by mail-it1-f181.google.com with SMTP id i76-v6so17062538ita.3
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 01:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <1539071634-1644-1-git-send-email-mgottam@codeaurora.org>
 <CAPBb6MUt_V4zEKGcRYXRXNRVdjF2uspOvEj0T-dH6dBZ9ya9CA@mail.gmail.com> <f1bb2ead-fe8e-af6a-1b96-9460a7b01f29@linaro.org>
In-Reply-To: <f1bb2ead-fe8e-af6a-1b96-9460a7b01f29@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 12 Oct 2018 17:06:09 +0900
Message-ID: <CAPBb6MXxaGMCY43fXwWYZmYmiVwDA6kdJRwWZGqUHhWOGXSz7Q@mail.gmail.com>
Subject: Re: [PATCH] media: venus: add support for key frame
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: mgottam@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2018 at 4:37 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 10/12/2018 08:26 AM, Alexandre Courbot wrote:
> > On Tue, Oct 9, 2018 at 4:54 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
> >>
> >> When client requests for a keyframe, set the property
> >> to hardware to generate the sync frame.
> >>
> >> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/venc_ctrls.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> index 45910172..f332c8e 100644
> >> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> @@ -81,6 +81,8 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>         struct venc_controls *ctr = &inst->controls.enc;
> >>         u32 bframes;
> >>         int ret;
> >> +       void *ptr;
> >> +       u32 ptype;
> >>
> >>         switch (ctrl->id) {
> >>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> >> @@ -173,6 +175,14 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>
> >>                 ctr->num_b_frames = bframes;
> >>                 break;
> >> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> >> +               ptype = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
> >> +               ret = hfi_session_set_property(inst, ptype, ptr);
> >
> > The test bot already said it, but ptr is passed to
> > hfi_session_set_property() uninitialized. And as can be expected the
> > call returns -EINVAL on my board.
> >
> > Looking at other uses of HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME I
> > see that the packet sent to the firmware does not have room for an
> > argument, so I tried to pass NULL but got the same result.
>
> yes, because pdata cannot be NULL. I'd suggest to make a pointer to
> struct hfi_enable and pass it to the set_property function.

FWIW I also tried doing this and got the same error, strange...
