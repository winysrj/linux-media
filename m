Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33184 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbeJPRbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 13:31:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id y140-v6so24897142wmd.0
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2018 02:41:49 -0700 (PDT)
Subject: Re: [PATCH] media: venus: add support for selection rectangles
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1539071603-1588-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <0e0f689e-f6e3-73a6-e145-deb2ef7cafc8@linaro.org>
Date: Tue, 16 Oct 2018 12:41:45 +0300
MIME-Version: 1.0
In-Reply-To: <1539071603-1588-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On 10/09/2018 10:53 AM, Malathi Gottam wrote:
> Handles target type crop by setting the new active rectangle
> to hardware. The new rectangle should be within YUV size.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 3f50cd0..754c19a 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -478,16 +478,31 @@ static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
>  {
>  	struct venus_inst *inst = to_inst(file);
> +	int ret;
> +	u32 buftype;
>  
>  	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		return -EINVAL;
>  
>  	switch (s->target) {
>  	case V4L2_SEL_TGT_CROP:
> -		if (s->r.width != inst->out_width ||
> -		    s->r.height != inst->out_height ||
> +		if (s->r.width > inst->out_width ||
> +		    s->r.height > inst->out_height ||
>  		    s->r.top != 0 || s->r.left != 0)
>  			return -EINVAL;
> +		if (s->r.width != inst->width ||
> +		    s->r.height != inst->height) {
> +			buftype = HFI_BUFFER_OUTPUT;
> +			ret = venus_helper_set_output_resolution(inst,
> +								 s->r.width,
> +								 s->r.height,
> +								 buftype);

I'm afraid that set_output_resolution cannot be called at any time. Do
you think we can set it after start_session?

-- 
regards,
Stan
