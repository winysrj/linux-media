Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6862C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF1E2083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="IdZzXuhr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADF1E2083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbeLGJnZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:43:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39625 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeLGJnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 04:43:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id f81so3810561wmd.4
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 01:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8NWf/akW22NH1giUWxDHXuKvMTkl2jgSPMiSm1/G1Os=;
        b=IdZzXuhrmoWGvCgvpi/fuF0NvJtdj9v185aVmvXRWiGWW84eLBRK4c24KE+0JWk32X
         GZeF3yXAkahTeuHtnuNLyMks3HHvOG0bFThco4KHAv9GqXiftatGwcr5mLURwzCliLzd
         DpdVQ9a76MNWbs7qwjBvajd1GxB8wUXEDc938=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8NWf/akW22NH1giUWxDHXuKvMTkl2jgSPMiSm1/G1Os=;
        b=rHf1oCkNSNnrbOu3GQUQN9at5Nhm1JSGLBsH0HGIW+SS7J1F2nAtusbm+aRJOET8Vu
         065fd6WzuQxLjMKRvglAIMy6EplK4/R2y8Zf1iEx3gC8Agrmr1luMtZ1wE7ADym9d7yr
         XU1C0h2TM4F21dpzv4km/pfPvxC+DxO6Lo9FCGbtZppc48jnpQqJUa5oQfQHr3FNe/YB
         J9igGccCTx824H2ElObl1IJGpY+TUV1dBgwABA8pJjNDKRtTpLxZ+DH42TheVTYzIrlU
         1Qn8VVCDNoBHfBSKuS9ag8r0W0n6ja3jDgO4wlG5CHsHM92xajtVSkcZX3wpoIby3f1m
         VxDA==
X-Gm-Message-State: AA+aEWZxSVqsU4HM96Gmoak5nNCc3d2bY2SMl3O7JwDZQ4NKxhQtJEGJ
        lZBieUuLudhg2OX81GvaRgouMDg7J2w=
X-Google-Smtp-Source: AFSGD/X7DtF71S4HQRUX75u+o8j2UK0o0Z7/WkLD4JCCGQdsxoESMpVCQVX2yFvfeGABDln+JHx4Bw==
X-Received: by 2002:a1c:1dc6:: with SMTP id d189mr1530548wmd.112.1544175803745;
        Fri, 07 Dec 2018 01:43:23 -0800 (PST)
Received: from [192.168.27.209] (mx2.mm-sol.com. [217.18.243.227])
        by smtp.googlemail.com with ESMTPSA id 5sm4329751wmw.8.2018.12.07.01.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 01:43:22 -0800 (PST)
Subject: Re: [PATCH] media: venus: Add support for H265 controls required by
 gstreamer V4L2 H265 module
To:     Kelvin Lawson <klawson@lisden.com>, linux-media@vger.kernel.org
References: <1543599060-3776-1-git-send-email-klawson@lisden.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <19f7304f-4a88-339f-faa2-2fac5a3b6b76@linaro.org>
Date:   Fri, 7 Dec 2018 11:43:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1543599060-3776-1-git-send-email-klawson@lisden.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kelvin,

Thanks for the patch!

On 11/30/18 7:31 PM, Kelvin Lawson wrote:
> Add support for V4L2_CID_MPEG_VIDEO_HEVC_PROFILE and
> V4L2_CID_MPEG_VIDEO_HEVC_LEVEL controls required by gstreamer V4L2 H265
> encoder module.
> 
> Signed-off-by: Kelvin Lawson <klawson@lisden.com>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..ad1a4d8 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -101,6 +101,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  		ctr->profile.h264 = ctrl->val;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> +		ctr->profile.hevc = ctrl->val;
> +		break;
>  	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  		ctr->profile.vpx = ctrl->val;
>  		break;
> @@ -110,6 +113,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>  		ctr->level.h264 = ctrl->val;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> +		ctr->level.hevc = ctrl->val;
> +		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
>  		ctr->h264_i_qp = ctrl->val;
>  		break;
> @@ -217,6 +223,19 @@ int venc_ctrl_init(struct venus_inst *inst)
>  		0, V4L2_MPEG_VIDEO_MPEG4_LEVEL_0);
>  
>  	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
> +		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10,
> +		~((1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN) |
> +		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE) |
> +		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10)),
> +		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN);
> +
> +	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
> +		V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2,
> +		0, V4L2_MPEG_VIDEO_HEVC_LEVEL_1);
> +
> +	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,

you are adding two new menu controls but forgot to increment the count
of controls in v4l2_ctrl_handler_init(). Can you resend with that fixed?

>  		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>  		V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH,
>  		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
> 

-- 
regards,
Stan
