Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36907 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbeK2VJe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 16:09:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id j10so1242225wru.4
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 02:04:46 -0800 (PST)
Subject: Re: [PATCH] media: venus: Support V4L2 QP parameters in Venus encoder
To: Kelvin Lawson <klawson@lisden.com>, linux-media@vger.kernel.org
References: <CADZgX3xfzqU3BLu2sc7R=TSJWwKE8bLTUprDvyVn3GcVGKYtDA@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <96b0d248-8719-e637-63f7-3468948f1c78@linaro.org>
Date: Thu, 29 Nov 2018 12:04:41 +0200
MIME-Version: 1.0
In-Reply-To: <CADZgX3xfzqU3BLu2sc7R=TSJWwKE8bLTUprDvyVn3GcVGKYtDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kelvin,

Thanks for the patch!

On 11/12/18 12:59 PM, Kelvin Lawson wrote:
> Support V4L2 QP parameters in Venus encoder:
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP
>  * V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP
>  * V4L2_CID_MPEG_VIDEO_H264_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_MAX_QP
> 
> Signed-off-by: Kelvin Lawson <klawson@lisden.com>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

As functional changes the patch is fine, but it has many coding style
issues. Did you read [1]?

> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c
> b/drivers/media/platform/qcom/venus/venc.c
> index ce85962..321d612 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -651,6 +651,8 @@ static int venc_set_properties(struct venus_inst *inst)
>   struct hfi_framerate frate;
>   struct hfi_bitrate brate;
>   struct hfi_idr_period idrp;
> + struct hfi_quantization quant;
> + struct hfi_quantization_range quant_range;
>   u32 ptype, rate_control, bitrate, profile = 0, level = 0;
>   int ret;
> 
> @@ -770,6 +772,23 @@ static int venc_set_properties(struct venus_inst *inst)
>   if (ret)
>   return ret;
> 
> + ptype = HFI_PROPERTY_PARAM_VENC_SESSION_QP;
> + quant.qp_i = ctr->h264_i_qp;
> + quant.qp_p = ctr->h264_p_qp;
> + quant.qp_b = ctr->h264_b_qp;
> + quant.layer_id = 0;
> + ret = hfi_session_set_property(inst, ptype, &quant);
> + if (ret)
> + return ret;

please fix the indentation according to coding style
> +
> + ptype = HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE;
> + quant_range.min_qp = ctr->h264_min_qp;
> + quant_range.max_qp = ctr->h264_max_qp;
> + quant_range.layer_id = 0;
> + ret = hfi_session_set_property(inst, ptype, &quant_range);
> + if (ret)
> + return ret;

ditto

> +
>   if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
>   profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>      ctr->profile.h264);
> 

Maybe your mail server is mangling the patches, but also please run
checkpatch before sending patches.

-- 
regards,
Stan

[1] https://www.kernel.org/doc/html/v4.19/process/submitting-patches.html
