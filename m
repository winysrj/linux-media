Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40327 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbeKAW5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 18:57:12 -0400
Received: by mail-yb1-f194.google.com with SMTP id g9-v6so8126122ybh.7
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 06:54:08 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id o3-v6sm7148016ywe.79.2018.11.01.06.54.05
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 06:54:05 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id l2-v6so3400867ywb.9
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 06:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <1540971728-26789-1-git-send-email-mgottam@codeaurora.org>
 <3ff2c3dd-434d-960b-6806-f4bb8ec0d954@linaro.org> <3364115421e89c7710725c06b820f8c6@codeaurora.org>
In-Reply-To: <3364115421e89c7710725c06b820f8c6@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 1 Nov 2018 22:53:53 +0900
Message-ID: <CAAFQd5A+9GWmn4aD4D2JMf1e1m-6Dtc3xUdMZsf8fPtgi34QVQ@mail.gmail.com>
Subject: Re: [PATCH] media: venus: dynamic handling of bitrate
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

On Thu, Nov 1, 2018 at 10:01 PM <mgottam@codeaurora.org> wrote:
>
> On 2018-11-01 17:48, Stanimir Varbanov wrote:
> > Hi Malathi,
> >
> > Thanks for the patch!
> >
> > On 10/31/18 9:42 AM, Malathi Gottam wrote:
> >> Any request for a change in bitrate after both planes
> >> are streamed on is handled by setting the target bitrate
> >> property to hardware.
> >>
> >> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/venc_ctrls.c | 11 +++++++++++
> >>  1 file changed, 11 insertions(+)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> index 45910172..54f310c 100644
> >> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> >> @@ -79,7 +79,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>  {
> >>      struct venus_inst *inst = ctrl_to_inst(ctrl);
> >>      struct venc_controls *ctr = &inst->controls.enc;
> >> +    struct hfi_bitrate brate;
> >>      u32 bframes;
> >> +    u32 ptype;
> >>      int ret;
> >>
> >>      switch (ctrl->id) {
> >> @@ -88,6 +90,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> >>              break;
> >>      case V4L2_CID_MPEG_VIDEO_BITRATE:
> >>              ctr->bitrate = ctrl->val;
> >> +            if (inst->streamon_out && inst->streamon_cap) {
> >
> > Hmm, hfi_session_set_property already checks the instance state so I
> > don't think those checks are needed. Another thing is that we need to
> > take the instance mutex to check the instance state.
>
> Yes Stan, "hfi_session_set_property" this property check the instance
> state,
> but returns EINVAL if this is set at UNINIT instance state.
>
> Controls initialization happens much earlier than session init and
> instance init.
> So the instance is still in UNINIT state which causes failure while
> setting.
>
> Through this patch we try to meet the client request of changing bitrate
> only
> when both planes are streamed on.

Where does this requirement come from? It should be possible to set
the control at any time and it should apply to any encoding happening
after the control is set.

Best regards,
Tomasz
