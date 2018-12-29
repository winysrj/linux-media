Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE3CC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 16:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75E62087F
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 16:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJBB+hz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbeL2QLt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 11:11:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38115 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbeL2QLs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 11:11:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19-v6so20916031lja.5;
        Sat, 29 Dec 2018 08:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JJk/MpfvM0ioAb5108EsfYUUovY6oCjKZh6SKbXoUBo=;
        b=TJBB+hz/MKp6vNA+CH5wLArLONVMNNcG9Lef3DRwj1vu4sxMIzxrtKGssVNKuQW+Vn
         F6i8CEpUO/B5VyBwylcygErvaLCXR+gN85jWqt9aXDhQjeFnPlcR8yjhQnWu7ow400PZ
         lDdRN/AYUK9msrIukILI3gWEn1wASxTjbmOZIJIeUluB3NT5Vm9ojhLfhkAHyRVss3Uq
         exfkEDtYAJEkW8lEb8e2VY/xMgqxEwSmUGnYmxzYHuOfRRsYChFpIVqqwbZmdFdWtpvq
         /XEQqnrsVLLBFrM+ObDpzjkMyHEDypcqX5hjgcZ8wlSO+BpeQzxkXtFoOkWC8AmwBMRp
         jTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JJk/MpfvM0ioAb5108EsfYUUovY6oCjKZh6SKbXoUBo=;
        b=aVemSFSgXHl2Jb0Xx8hDtwcmTyKyvdn1Z+e9v5CWVr7YANXXGpMHmwhpLdr/ysxaMi
         6wPLWY5xGE9KpDONDZZDDYbYEJCa4XNV3JzMhBEiAl5qGnBqJsYLMXNB9hzHUAZk4v0W
         TQkCMQUgrMYMb05kryofBjYvpJqiZ3X0IGmyHVDtyckqDgk9cCqc1oS0/EnYXGLqZ5fA
         iU8XzBLwW4zkXxkadKnrs+hTyiP0MfifwDyDD4H4+h9KxlMf6Q1U/lVQDI+3ZDGpoexu
         CaFdw11CFCM4tGUPYiunmBL7fKy0c+2pa6DXheAng9G7aN40ieKwfBbC2iOn78nXVoPI
         7QRQ==
X-Gm-Message-State: AJcUukfz7ob9SO2eQ/ZQoxZ5GQ0oWPn/VYc1n4xVFpQSwgKaO+6phIOM
        BD+zZwSUbwc/6r55Oe9JPct7z1yg
X-Google-Smtp-Source: AFSGD/XvediXFLshpEjhGxuSYn3NiQssph9j4UWJiI9+1+UxLkNYipnq8D6ANukYsdRHVfvaMhOHrQ==
X-Received: by 2002:a2e:3603:: with SMTP id d3-v6mr18164949lja.46.1546099905800;
        Sat, 29 Dec 2018 08:11:45 -0800 (PST)
Received: from [192.168.1.18] (dkj55.neoplus.adsl.tpnet.pl. [83.24.13.55])
        by smtp.gmail.com with ESMTPSA id j18-v6sm9096828ljc.52.2018.12.29.08.11.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 08:11:45 -0800 (PST)
Subject: Re: [PATCH] media: s5p-jpeg: Check for fmt_ver_flag when doing fmt
 enumeration
To:     =?UTF-8?Q?Pawe=c5=82_Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        andrzej.p@samsung.com
Cc:     mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
References: <20181229154602.25693-1-pawel.mikolaj.chmiel@gmail.com>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <e6a63771-8238-1822-d7bb-960649e8e359@gmail.com>
Date:   Sat, 29 Dec 2018 17:11:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181229154602.25693-1-pawel.mikolaj.chmiel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Paweł,

Thank you for the patch.

On 12/29/18 4:46 PM, Paweł Chmiel wrote:
> Previously when doing format enumeration, it was returning all
>   formats supported by driver, even if they're not supported by hw.
> Add missing check for fmt_ver_flag, so it'll be fixed and only those
>   supported by hw will be returned. Similar thing is already done
>   in s5p_jpeg_find_format.
> 
> It was found by using v4l2-compliance tool and checking result
>   of VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS test
> and using v4l2-ctl to get list of all supported formats.
> 
> Tested on s5pv210-galaxys (Samsung i9000 phone).
> 
> Fixes: bb677f3ac434 ("[media] Exynos4 JPEG codec v4l2 driver")
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 3f9000b70385..232b75cf209f 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1293,13 +1293,16 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
>   	return 0;
>   }
>   
> -static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
> +static int enum_fmt(struct s5p_jpeg_ctx *ctx,
> +		    struct s5p_jpeg_fmt *sjpeg_formats, int n,
>   		    struct v4l2_fmtdesc *f, u32 type)
>   {
>   	int i, num = 0;
> +	unsigned int fmt_ver_flag = ctx->jpeg->variant->fmt_ver_flag;
>   
>   	for (i = 0; i < n; ++i) {
> -		if (sjpeg_formats[i].flags & type) {
> +		if (sjpeg_formats[i].flags & type &&
> +			sjpeg_formats[i].flags & fmt_ver_flag) {
>   			/* index-th format of type type found ? */
>   			if (num == f->index)
>   				break;
> @@ -1326,10 +1329,10 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
>   	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>   
>   	if (ctx->mode == S5P_JPEG_ENCODE)
> -		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
> +		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
>   				SJPEG_FMT_FLAG_ENC_CAPTURE);
>   
> -	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
> +	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
>   					SJPEG_FMT_FLAG_DEC_CAPTURE);
>   }
>   
> @@ -1339,10 +1342,10 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
>   	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>   
>   	if (ctx->mode == S5P_JPEG_ENCODE)
> -		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
> +		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
>   				SJPEG_FMT_FLAG_ENC_OUTPUT);
>   
> -	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
> +	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
>   					SJPEG_FMT_FLAG_DEC_OUTPUT);
>   }
>   
> 

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
