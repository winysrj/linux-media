Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:35960 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeJLM5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 08:57:22 -0400
Received: by mail-it1-f193.google.com with SMTP id c85-v6so16643005itd.1
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 22:26:40 -0700 (PDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com. [209.85.166.50])
        by smtp.gmail.com with ESMTPSA id b26-v6sm22326iod.38.2018.10.11.22.26.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Oct 2018 22:26:39 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id p4-v6so8386407iom.3
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 22:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <1539071634-1644-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1539071634-1644-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 12 Oct 2018 14:26:26 +0900
Message-ID: <CAPBb6MUt_V4zEKGcRYXRXNRVdjF2uspOvEj0T-dH6dBZ9ya9CA@mail.gmail.com>
Subject: Re: [PATCH] media: venus: add support for key frame
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2018 at 4:54 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> When client requests for a keyframe, set the property
> to hardware to generate the sync frame.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..f332c8e 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -81,6 +81,8 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>         struct venc_controls *ctr = &inst->controls.enc;
>         u32 bframes;
>         int ret;
> +       void *ptr;
> +       u32 ptype;
>
>         switch (ctrl->id) {
>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> @@ -173,6 +175,14 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>
>                 ctr->num_b_frames = bframes;
>                 break;
> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> +               ptype = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
> +               ret = hfi_session_set_property(inst, ptype, ptr);

The test bot already said it, but ptr is passed to
hfi_session_set_property() uninitialized. And as can be expected the
call returns -EINVAL on my board.

Looking at other uses of HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME I
see that the packet sent to the firmware does not have room for an
argument, so I tried to pass NULL but got the same result.

> +

This newline is unnecessary.

> +               if (ret)
> +                       return ret;
> +
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -309,6 +319,9 @@ int venc_ctrl_init(struct venus_inst *inst)
>         v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
>                 V4L2_CID_MPEG_VIDEO_H264_I_PERIOD, 0, (1 << 16) - 1, 1, 0);
>
> +       v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
> +                         V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME, 0, 0, 0, 0);
> +
>         ret = inst->ctrl_handler.error;
>         if (ret)
>                 goto err;
> --
> 1.9.1
>
