Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33869 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965717AbeGBLop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 07:44:45 -0400
Subject: Re: [PATCH] venus: venc: add support for ext controls
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org
References: <1530530783-9480-1-git-send-email-vgarodia@codeaurora.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b8cb593a-7102-7cf4-6101-bbf3ea83d9ee@xs4all.nl>
Date: Mon, 2 Jul 2018 13:44:42 +0200
MIME-Version: 1.0
In-Reply-To: <1530530783-9480-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 13:26, Vikash Garodia wrote:
> There is a requirement to add frame level rate control.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index a2c6a4b..eaf2fa8 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -546,6 +546,33 @@ static int venc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  	return 0;
>  }
>  
> +static int venc_s_ext_ctrls(struct file *file, void *fh,
> +				struct v4l2_ext_controls *ctrl)
> +{
> +	struct venus_inst *inst = to_inst(file);
> +	struct v4l2_ext_control *control;
> +	u32 ptype, i, ret;
> +	struct hfi_enable en = { .enable = 1 };
> +	void *pdata = NULL;
> +
> +	control = ctrl->controls;
> +	for (i = 0; i < ctrl->count; i++) {
> +		switch (control[i].id) {
> +		case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
> +			ptype = HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP;
> +			en.enable = control[i].value;
> +			pdata = &en;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +	ret = hfi_session_set_property(inst, ptype, pdata);
> +	if (ret)
> +		return ret;
> +	return 0;
> +}
> +
>  static int venc_enum_framesizes(struct file *file, void *fh,
>  				struct v4l2_frmsizeenum *fsize)
>  {
> @@ -638,6 +665,7 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
>  	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
>  	.vidioc_s_parm = venc_s_parm,
>  	.vidioc_g_parm = venc_g_parm,
> +	.vidioc_s_ext_ctrl = venc_s_ext_ctrls,

No, that's not how you do this. See venc_ctrls.c on how to handle controls.

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  	.vidioc_enum_framesizes = venc_enum_framesizes,
>  	.vidioc_enum_frameintervals = venc_enum_frameintervals,
>  	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> 
