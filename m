Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52634 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbeJIWeb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 18:34:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so2284044wmw.2
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 08:17:06 -0700 (PDT)
Subject: Re: [PATCH] media: venus: queue initial buffers
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1539071426-1282-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7960b369-3bb3-529b-c06c-26ea4de821c8@linaro.org>
Date: Tue, 9 Oct 2018 18:17:04 +0300
MIME-Version: 1.0
In-Reply-To: <1539071426-1282-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On 10/09/2018 10:50 AM, Malathi Gottam wrote:
> Buffers can be queued to driver before the planes are
> set to start streaming. Queue those buffers to firmware
> once start streaming is called on both the planes.

yes and this is done in venus_helper_m2m_device_run mem2mem operation
when streamon on both queues is called, thus below function just
duplicates .device_run.

Do you fix an issue with that patch?

> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 22 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/venc.c    |  5 +++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index e436385..2679adb 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -1041,6 +1041,28 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
>  
> +int venus_helper_queue_initial_bufs(struct venus_inst *inst)
> +{
> +	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +	struct v4l2_m2m_buffer *buf, *n;
> +	int ret;
> +
> +	v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n)	{
> +		ret = session_process_buf(inst, &buf->vb);
> +		if (ret)
> +			return_buf_error(inst, &buf->vb);
> +	}
> +
> +	v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
> +		ret = session_process_buf(inst, &buf->vb);
> +		if (ret)
> +			return_buf_error(inst, &buf->vb);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(venus_helper_queue_initial_bufs);
> +
>  int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>  {
>  	struct venus_core *core = inst->core;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 2475f284..f4d76ab 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -31,6 +31,7 @@ void venus_helper_buffers_done(struct venus_inst *inst,
>  int venus_helper_vb2_start_streaming(struct venus_inst *inst);
>  void venus_helper_m2m_device_run(void *priv);
>  void venus_helper_m2m_job_abort(void *priv);
> +int venus_helper_queue_initial_bufs(struct venus_inst *inst);
>  int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
>  			    struct hfi_buffer_requirements *req);
>  u32 venus_helper_get_framesz_raw(u32 hfi_fmt, u32 width, u32 height);
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index ce85962..ef11495 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -989,6 +989,11 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
>  	if (ret)
>  		goto deinit_sess;
>  
> +	ret = venus_helper_queue_initial_bufs(inst);
> +	if (ret)
> +		goto deinit_sess;
> +	}
> +
>  	mutex_unlock(&inst->lock);
>  
>  	return 0;
> 

-- 
regards,
Stan
