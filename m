Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53702 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbeKOT0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 14:26:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id f10-v6so18003832wme.3
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 01:19:15 -0800 (PST)
Subject: Re: [PATCH v2] media: venus: dynamic handling of bitrate
To: Malathi Gottam <mgottam@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1541162476-20770-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <43bf0d2b-0b3e-9d83-5ffe-3e2250c7fa0c@linaro.org>
Date: Thu, 15 Nov 2018 11:19:12 +0200
MIME-Version: 1.0
In-Reply-To: <1541162476-20770-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 11/2/18 2:41 PM, Malathi Gottam wrote:
> Any request for a change in bitrate after both planes
> are streamed on is handled by setting the target bitrate
> property to hardware.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

> 
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..f90a34e 100644
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
> @@ -88,6 +90,19 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_BITRATE:
>  		ctr->bitrate = ctrl->val;
> +		mutex_lock(&inst->lock);
> +		if (inst->streamon_out && inst->streamon_cap) {
> +			ptype = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
> +			brate.bitrate = ctr->bitrate;
> +			brate.layer_id = 0;
> +
> +			ret = hfi_session_set_property(inst, ptype, &brate);
> +			if (ret) {
> +				mutex_unlock(&inst->lock);
> +				return ret;
> +			}
> +		}
> +		mutex_unlock(&inst->lock);
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
>  		ctr->bitrate_peak = ctrl->val;
> 

-- 
regards,
Stan
