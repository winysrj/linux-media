Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73DBC169C4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7347120881
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="aYg5cO5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfA3D2T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:28:19 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44123 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfA3D2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:28:18 -0500
Received: by mail-qt1-f196.google.com with SMTP id n32so24754232qte.11
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fIPU2IKg2fXrm0JSCPOV2UQ20i/t4e7FNw+eyeIX/kE=;
        b=aYg5cO5UtjYMhsjRNGSbrvLxjw8VhaaJgRRVLiUKPS8mYyPFtE1/cgGWezIya0oSTr
         Ailr4kt0Qgnt6XCmTGstaWIzw4pPYh5MtCflF7FTLAnjsmOu6U1L/D4+Tc81WnxNdjNX
         S1jKSIa7HsaYNCjbieUXWQhc5kxBXxn8eMQSFD21Dl8i8s5cTbhgWrzIroTac+3Qk3he
         5NoANCJlJcjZuD0+zqY/AaII9M4EsvbuDVch4Vkd4AdmR985gguQsHEIg3moGhBD2F31
         Zc+KGvs+ESWqrN6ZaL91CxAbOa8OBY3HvEBM99atYv5Oj4baXV2GzVSo0KxPlg+LL1BW
         Y1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fIPU2IKg2fXrm0JSCPOV2UQ20i/t4e7FNw+eyeIX/kE=;
        b=rrPZTfd2axGek7AisGuihQxwE1LKWNoPn1jsMrRgnVH6CM4vb6z5p0LbjdQUIJ0heN
         51mx+vH/CMdmgq5Raw7flhe0dD4lHbvTyAGUy1pXs0DgfYnryelVX7K5Mbt1qrVhdEAf
         wiPhKCDW2D8FNbBS4GXlohvX+wblY7ZQAopIRG52zh+KaPEoLu4m3GlvbKw7lRDp/azo
         3VA503iXCH++gZ1+ga2JrHFqPdYKPZqVCwHlpovS6ko6RiCSkNVXdATnsbeTpesd5jcM
         VCbtUErbqB2QA/sV1q+EyFO7wOe0tXwAYPpcmX9IltbR6Gs+Lki1qcsUxZDCsD5qx7B1
         43Kg==
X-Gm-Message-State: AJcUukcz/GVUZn6XsudFJM4iStuFX/rzCOEj5Zxuej8tfRS6GLZERy+R
        1UQfW/GKArneJ6uyoJtYR04zvw==
X-Google-Smtp-Source: ALg8bN6v7/RI8N9FmFDNS8XaEdHeC7Gf0WqDcSKw/VyPqt5LSGMx124hEIjNMW2E12uWEnMtZ1BHIA==
X-Received: by 2002:a0c:d0d7:: with SMTP id b23mr26557412qvh.67.1548818897708;
        Tue, 29 Jan 2019 19:28:17 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id e29sm175298qtc.74.2019.01.29.19.28.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 19:28:16 -0800 (PST)
Message-ID: <9651c01bf3f2adcc405963bfab48b7e7a5656494.camel@ndufresne.ca>
Subject: Re: [PATCH v2] venus: enc: fix enum_frameintervals
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Jan 2019 22:28:15 -0500
In-Reply-To: <20190122105322.22096-1-stanimir.varbanov@linaro.org>
References: <20190122105322.22096-1-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mardi 22 janvier 2019 à 12:53 +0200, Stanimir Varbanov a écrit :
> This ixes an issue when setting the encoder framerate because of

ixes -> fixes

> missing precision. Now the frameinterval type is changed to
> TYPE_CONTINUOUS and step = 1. Also the math is changed when
> framerate property is called - the firmware side expects that
> the framerate one is 1 << 16 units.

Note sure, maybe you didn't mean to add 'one' here ? Why not just say
that that firmware expect values in Q16 ?

> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

Looking toward testing it, but I had the bad luck of using an USB
storage rootfs, and apparently USB no longer works on 5.0rc+, if you
have a baseline tree to suggest, I'll take it. Thanks for this patch.

> ---
> v2: replace DIV_ROUND_UP with do_div and make roundup manually
> 
>  drivers/media/platform/qcom/venus/venc.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 32cff294582f..99c94b155b46 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -31,6 +31,7 @@
>  #include "venc.h"
>  
>  #define NUM_B_FRAMES_MAX	4
> +#define FRAMERATE_FACTOR	(1 << 16)
>  
>  /*
>   * Three resons to keep MPLANE formats (despite that the number of planes
> @@ -581,7 +582,7 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
>  	struct venus_inst *inst = to_inst(file);
>  	const struct venus_format *fmt;
>  
> -	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>  
>  	fmt = find_format(inst, fival->pixel_format,
>  			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> @@ -604,12 +605,12 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
>  	    fival->height < frame_height_min(inst))
>  		return -EINVAL;
>  
> -	fival->stepwise.min.numerator = 1;
> +	fival->stepwise.min.numerator = FRAMERATE_FACTOR;
>  	fival->stepwise.min.denominator = frate_max(inst);
> -	fival->stepwise.max.numerator = 1;
> +	fival->stepwise.max.numerator = FRAMERATE_FACTOR;
>  	fival->stepwise.max.denominator = frate_min(inst);
>  	fival->stepwise.step.numerator = 1;
> -	fival->stepwise.step.denominator = frate_max(inst);
> +	fival->stepwise.step.denominator = 1;
>  
>  	return 0;
>  }
> @@ -654,6 +655,7 @@ static int venc_set_properties(struct venus_inst *inst)
>  	struct hfi_quantization quant;
>  	struct hfi_quantization_range quant_range;
>  	u32 ptype, rate_control, bitrate, profile = 0, level = 0;
> +	u64 framerate;
>  	int ret;
>  
>  	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
> @@ -664,9 +666,16 @@ static int venc_set_properties(struct venus_inst *inst)
>  	if (ret)
>  		return ret;
>  
> +	framerate = inst->timeperframe.denominator * FRAMERATE_FACTOR;
> +	/* next line is to round up */
> +	framerate += inst->timeperframe.numerator - 1;
> +	do_div(framerate, inst->timeperframe.numerator);
> +
>  	ptype = HFI_PROPERTY_CONFIG_FRAME_RATE;
>  	frate.buffer_type = HFI_BUFFER_OUTPUT;
> -	frate.framerate = inst->fps * (1 << 16);
> +	frate.framerate = framerate;
> +	if (frate.framerate > frate_max(inst))
> +		frate.framerate = frate_max(inst);
>  
>  	ret = hfi_session_set_property(inst, ptype, &frate);
>  	if (ret)

