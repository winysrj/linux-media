Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38832 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbeJYQCn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Oct 2018 12:02:43 -0400
Received: by mail-yb1-f195.google.com with SMTP id v92-v6so3271553ybi.5
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2018 00:31:12 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id q11-v6sm1755836ywb.44.2018.10.25.00.31.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Oct 2018 00:31:10 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id e16-v6so3262394ybk.8
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2018 00:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <1540389162-30358-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5CaYH-kxj+9cquObTHiRyA1VoEYHQmiQAGjdZm6J1ACfg@mail.gmail.com> <86344762e1eeab8fe8a940a1bfffa2c1@codeaurora.org>
In-Reply-To: <86344762e1eeab8fe8a940a1bfffa2c1@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 25 Oct 2018 16:30:58 +0900
Message-ID: <CAAFQd5BhVdnmaVriBHEEvqKqO1Aiky0RpTyKWuh4+r0tPovsCA@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: add support for key frame
To: vgarodia@codeaurora.org
Cc: mgottam@codeaurora.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 25, 2018 at 4:23 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> On 2018-10-24 20:02, Tomasz Figa wrote:
> > On Wed, Oct 24, 2018 at 10:52 PM Malathi Gottam
> > <mgottam@codeaurora.org> wrote:
> >>
> >> When client requests for a keyframe, set the property
> >> to hardware to generate the sync frame.
> >>
> >> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/venc_ctrls.c | 16 +++++++++++++++-
> >>  1 file changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> index 45910172..6c2655d 100644
> >> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> @@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>  {
> >>         struct venus_inst *inst = ctrl_to_inst(ctrl);
> >>         struct venc_controls *ctr = &inst->controls.enc;
> >> +       struct hfi_enable en = { .enable = 1 };
> >>         u32 bframes;
> >>         int ret;
> >> +       u32 ptype;
> >>
> >>         switch (ctrl->id) {
> >>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> >> @@ -173,6 +175,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>
> >>                 ctr->num_b_frames = bframes;
> >>                 break;
> >> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> >> +               if (inst->streamon_out && inst->streamon_cap) {
> >> +                       ptype =
> >> HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
> >> +                       ret = hfi_session_set_property(inst, ptype,
> >> &en);
> >> +
> >> +                       if (ret)
> >> +                               return ret;
> >> +               }
> >> +               break;
> >
> > This is still not the right way to handle this.
> >
> > Please see the documentation of this control [1]:
> >
> > "V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME (button)
> > Force a key frame for the next queued buffer. Applicable to encoders.
> > This is a general, codec-agnostic keyframe control."
> >
> > Even if the driver is not streaming, it must remember that the
> > keyframe was requested for next buffer. The next time userspace QBUFs
> > an OUTPUT buffer, it should ask the hardware to encode that OUTPUT
> > buffer into a keyframe.
>
> That's correct. Driver can cache the client request and set it when the
> hardware
> is capable of accepting the property.
> Still the issue having the requested OUTPUT buffer to be encoded as sync
> frame will
> be there. If there are few frames queued before streamon, driver will
> only keep a
> note that it has to set the request for keyframe, but not the exact one
> which was
> requested.

The description (quoted above) specifies exactly that the control
applies only to the next queued buffer. It's a "button" control, so
when the application sets it (to 1), it triggers a call to driver's
s_ctrl callback and then resets to 0 automatically.

>
> > [1]
> > https://www.kernel.org/doc/html/latest/media/uapi/v4l/extended-controls.html?highlight=v4l2_cid_mpeg_video_force_key_frame
> >
> > But generally, the proper modern way for the userspace to request a
> > keyframe is to set the V4L2_BUF_FLAG_KEYFRAME flag in the
> > vb2_buffer_flag when queuing an OUTPUT buffer. It's the only
> > guaranteed way to ensure that the keyframe will be encoded exactly for
> > the selected frame. (The V4L2 control API doesn't guarantee any
> > synchronization between controls and buffers itself.)
>
> This is a better way to handle it to ensure exact buffer gets encoded as
> sync frame.

It was created later to solve this problem. For compatibility, we have
to keep supporting the control too.

Best regards,
Tomasz
