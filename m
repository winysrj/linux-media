Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49625 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750795AbeEGKcm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 06:32:42 -0400
Subject: Re: [PATCH 15/28] venus: add a helper function to set dynamic buffer
 mode
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-16-stanimir.varbanov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <38a80abe-ba2c-c85b-f8a5-bb74245df172@xs4all.nl>
Date: Mon, 7 May 2018 12:32:38 +0200
MIME-Version: 1.0
In-Reply-To: <20180424124436.26955-16-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/04/18 14:44, Stanimir Varbanov wrote:
> Adds a new helper function to set dymaic buffer mode if it is

dymaic -> dynamic

Regards,

	Hans

> supported by current HFI version.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 22 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    | 15 +++------------
>  3 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 1eda19adbf28..824ad4d2d064 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -522,6 +522,28 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
>  
> +int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
> +{
> +	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
> +	struct hfi_buffer_alloc_mode mode;
> +	int ret;
> +
> +	if (!is_dynamic_bufmode(inst))
> +		return 0;
> +
> +	mode.type = HFI_BUFFER_OUTPUT;
> +	mode.mode = HFI_BUFFER_MODE_DYNAMIC;
> +
> +	ret = hfi_session_set_property(inst, ptype, &mode);
> +	if (ret)
> +		return ret;
> +
> +	mode.type = HFI_BUFFER_OUTPUT2;
> +
> +	return hfi_session_set_property(inst, ptype, &mode);
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
> +
>  static void delayed_process_buf_func(struct work_struct *work)
>  {
>  	struct venus_buffer *buf, *n;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 0e64aa95624a..52b961ed491e 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -40,6 +40,7 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
>  int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
>  			      unsigned int output_bufs);
>  int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
> +int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
>  void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
>  void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
>  void venus_helper_init_instance(struct venus_inst *inst);
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 0ddc2c4df934..1de9cc64cf2f 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -557,18 +557,9 @@ static int vdec_set_properties(struct venus_inst *inst)
>  			return ret;
>  	}
>  
> -	if (core->res->hfi_version == HFI_VERSION_3XX ||
> -	    inst->cap_bufs_mode_dynamic) {
> -		struct hfi_buffer_alloc_mode mode;
> -
> -		ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
> -		mode.type = HFI_BUFFER_OUTPUT;
> -		mode.mode = HFI_BUFFER_MODE_DYNAMIC;
> -
> -		ret = hfi_session_set_property(inst, ptype, &mode);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = venus_helper_set_dyn_bufmode(inst);
> +	if (ret)
> +		return ret;
>  
>  	if (ctr->post_loop_deb_mode) {
>  		ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
> 
