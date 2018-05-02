Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeEBG0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 02:26:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2018 11:56:19 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 10/28] venus: vdec: call session_continue in insufficient
 event
In-Reply-To: <20180424124436.26955-11-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-11-stanimir.varbanov@linaro.org>
Message-ID: <85963ca3e12f4d71f2bc2db7d601d4b2@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Stanimir,

On 2018-04-24 18:14, Stanimir Varbanov wrote:
> Call session_continue for Venus 4xx version even when the event
> says that the buffer resources are not sufficient. Leaving a
> comment with more information about the workaround.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> b/drivers/media/platform/qcom/venus/vdec.c
> index c45452634e7e..91c7384ff9c8 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -873,6 +873,14 @@ static void vdec_event_notify(struct venus_inst
> *inst, u32 event,
> 
>  			dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
>  				data->width, data->height);
> +			/*
> +			 * Workaround: Even that the firmware send and event for
> +			 * insufficient buffer resources it is safe to call
> +			 * session_continue because actually the event says that
> +			 * the number of capture buffers is lower.
> +			 */
> +			if (IS_V4(core))
> +				hfi_session_continue(inst);
>  			break;
>  		case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
>  			venus_helper_release_buf_ref(inst, data->tag);

Insufficient event from video firmware could be sent either,
1. due to insufficient buffer resources
2. due to lower capture buffers

It cannot be assumed that the event received by the host is due to lower 
capture
buffers. Incase the buffer resource is insufficient, let say there is a 
bitstream
resolution switch from 720p to 1080p, capture buffers needs to be 
reallocated.

The driver should be sending the V4L2_EVENT_SOURCE_CHANGE to client 
instead of ignoring
the event from firmware.

Thanks,
Vikash
