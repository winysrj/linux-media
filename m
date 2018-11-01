Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52111 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbeKAVVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 17:21:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id w7-v6so1205584wmc.1
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 05:18:47 -0700 (PDT)
Subject: Re: [PATCH] media: venus: dynamic handling of bitrate
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1540971728-26789-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <3ff2c3dd-434d-960b-6806-f4bb8ec0d954@linaro.org>
Date: Thu, 1 Nov 2018 14:18:43 +0200
MIME-Version: 1.0
In-Reply-To: <1540971728-26789-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 10/31/18 9:42 AM, Malathi Gottam wrote:
> Any request for a change in bitrate after both planes
> are streamed on is handled by setting the target bitrate
> property to hardware.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..54f310c 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -79,7 +79,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct venus_inst *inst = ctrl_to_inst(ctrl);
>  	struct venc_controls *ctr = &inst->controls.enc;
> +	struct hfi_bitrate brate;
>  	u32 bframes;
> +	u32 ptype;
>  	int ret;
>  
>  	switch (ctrl->id) {
> @@ -88,6 +90,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_BITRATE:
>  		ctr->bitrate = ctrl->val;
> +		if (inst->streamon_out && inst->streamon_cap) {

Hmm, hfi_session_set_property already checks the instance state so I
don't think those checks are needed. Another thing is that we need to
take the instance mutex to check the instance state.

> +			ptype = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
> +			brate.bitrate = ctr->bitrate;
> +			brate.layer_id = 0;
> +
> +			ret = hfi_session_set_property(inst, ptype, &brate);
> +			if (ret)
> +				return ret;
> +		}
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
>  		ctr->bitrate_peak = ctrl->val;
> 

-- 
regards,
Stan
