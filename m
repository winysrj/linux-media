Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40273 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeK3Gqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 01:46:50 -0500
Received: by mail-yw1-f65.google.com with SMTP id r130so1264581ywg.7
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 11:40:19 -0800 (PST)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id n4sm793680ywc.89.2018.11.29.11.40.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 11:40:16 -0800 (PST)
Received: by mail-yw1-f53.google.com with SMTP id j6so1267870ywj.6
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 11:40:16 -0800 (PST)
MIME-Version: 1.0
References: <1541163476-23249-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5D=hNdkEovonE6GOaYvq9dBbQwSZ=95V9a80e-sLp7cYg@mail.gmail.com>
 <4767b56f-420b-dc0c-0ae9-44dbf6dcd0b1@linaro.org> <6d765e0d7d6b873e087a3db823cb1b29@codeaurora.org>
In-Reply-To: <6d765e0d7d6b873e087a3db823cb1b29@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 29 Nov 2018 11:40:04 -0800
Message-ID: <CAAFQd5Ask-mw+uEE0OAEabjaAAYcJyCeexaofOAg1bp2NtvpKA@mail.gmail.com>
Subject: Re: [PATCH v3] media: venus: add support for key frame
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

On Thu, Nov 29, 2018 at 3:10 AM <mgottam@codeaurora.org> wrote:
>
>
> Hi Stan,
>
> On 2018-11-29 16:01, Stanimir Varbanov wrote:
> > Hi Tomasz,
> >
> > On 11/3/18 5:01 AM, Tomasz Figa wrote:
> >> Hi Malathi,
> >>
> >> On Fri, Nov 2, 2018 at 9:58 PM Malathi Gottam <mgottam@codeaurora.org>
> >> wrote:
> >>>
> >>> When client requests for a keyframe, set the property
> >>> to hardware to generate the sync frame.
> >>>
> >>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >>> ---
> >>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 20
> >>> +++++++++++++++++++-
> >>>  1 file changed, 19 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >>> index 45910172..59fe7fc 100644
> >>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >>> @@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>>  {
> >>>         struct venus_inst *inst = ctrl_to_inst(ctrl);
> >>>         struct venc_controls *ctr = &inst->controls.enc;
> >>> +       struct hfi_enable en = { .enable = 1 };
> >>>         u32 bframes;
> >>>         int ret;
> >>> +       u32 ptype;
> >>>
> >>>         switch (ctrl->id) {
> >>>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> >>> @@ -173,6 +175,19 @@ static int venc_op_s_ctrl(struct v4l2_ctrl
> >>> *ctrl)
> >>>
> >>>                 ctr->num_b_frames = bframes;
> >>>                 break;
> >>> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> >>> +               mutex_lock(&inst->lock);
> >>> +               if (inst->streamon_out && inst->streamon_cap) {
> >>
> >> We had a discussion on this in v2. I don't remember seeing any
> >> conclusion.
> >>
> >> Obviously the hardware should generate a keyframe naturally when the
> >> CAPTURE streaming starts, which is where the encoding starts, but the
> >> state of the OUTPUT queue should not affect this.
> >>
> >> The application is free to stop and start streaming on the OUTPUT
> >> queue as it goes and it shouldn't imply any side effects in the
> >> encoded bitstream (e.g. a keyframe inserted). So:
> >> - a sequence of STREAMOFF(OUTPUT),
> >> S_CTRL(V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME), STREAMON(OUTPUT) should
> >> explicitly generate a keyframe,
> >
> > I agree with you, but presently we don't follow strictly the stateful
> > encoder spec. In this spirit I think proposed patch is applicable to
> > the
> > current state of the encoder driver, and your comment should be
> > addressed in the follow-up patches where we have to re-factor a bit
> > start/stop_streaming according to the encoder documentation.
> >
> > But until then we have to get that patch.
>
> So I can see that this patch is good implementation of forcing sync
> frame
> under current encoder state.
>
> Can you please ack the same.

Okay, assuming that when you start streaming you naturally get a
keyframe, I'm okay with this patch, since it actually fixes the
missing key frame request, so from the general encoder interface point
of view:

Acked-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
