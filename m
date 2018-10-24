Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43758 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbeJXXA4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 19:00:56 -0400
Received: by mail-yw1-f68.google.com with SMTP id j75-v6so2141112ywj.10
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2018 07:32:35 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id p7-v6sm2617581ywd.75.2018.10.24.07.32.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 07:32:33 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id j9-v6so2208326ybj.6
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2018 07:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <1540389162-30358-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1540389162-30358-1-git-send-email-mgottam@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 24 Oct 2018 23:32:19 +0900
Message-ID: <CAAFQd5CaYH-kxj+9cquObTHiRyA1VoEYHQmiQAGjdZm6J1ACfg@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: add support for key frame
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

On Wed, Oct 24, 2018 at 10:52 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> When client requests for a keyframe, set the property
> to hardware to generate the sync frame.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..6c2655d 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>         struct venus_inst *inst = ctrl_to_inst(ctrl);
>         struct venc_controls *ctr = &inst->controls.enc;
> +       struct hfi_enable en = { .enable = 1 };
>         u32 bframes;
>         int ret;
> +       u32 ptype;
>
>         switch (ctrl->id) {
>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> @@ -173,6 +175,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>
>                 ctr->num_b_frames = bframes;
>                 break;
> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> +               if (inst->streamon_out && inst->streamon_cap) {
> +                       ptype = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
> +                       ret = hfi_session_set_property(inst, ptype, &en);
> +
> +                       if (ret)
> +                               return ret;
> +               }
> +               break;

This is still not the right way to handle this.

Please see the documentation of this control [1]:

"V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME (button)
Force a key frame for the next queued buffer. Applicable to encoders.
This is a general, codec-agnostic keyframe control."

Even if the driver is not streaming, it must remember that the
keyframe was requested for next buffer. The next time userspace QBUFs
an OUTPUT buffer, it should ask the hardware to encode that OUTPUT
buffer into a keyframe.

[1] https://www.kernel.org/doc/html/latest/media/uapi/v4l/extended-controls.html?highlight=v4l2_cid_mpeg_video_force_key_frame

But generally, the proper modern way for the userspace to request a
keyframe is to set the V4L2_BUF_FLAG_KEYFRAME flag in the
vb2_buffer_flag when queuing an OUTPUT buffer. It's the only
guaranteed way to ensure that the keyframe will be encoded exactly for
the selected frame. (The V4L2 control API doesn't guarantee any
synchronization between controls and buffers itself.)

Best regards,
Tomasz
