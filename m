Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0302C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 00:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7241A2173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 00:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKXdOFWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfAJAJe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 19:09:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38772 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfAJAJe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 19:09:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so9461125wrw.5
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 16:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=V6CaRSgI9rgdIOv2xX+uwC4H8AUDmNYhk3Db7/8cgBc=;
        b=dKXdOFWGGwKytRLuuzN9jBKiLLlnPWA8F1dMiNCrUH52Zd7VII3Fqa8fKmfl30LxTZ
         VGM5PDQsDC5njrH46g8kAupgNyaWAPe1r+xetaCJR70scE4B5kBV/ASk9qSQM+l2zC+9
         T9ru9a0RtxwecdXVG4gtYV4dk78+TzDjQf79wJIBphLkIvchJRdKOLUMWo50tkcjMIEK
         ctKC6W840xIg4+BUMT836QqjBIPZHYHae+lEmlsP84qGtcwsPlCnU+Ui56ciS6RMywV6
         MJKDyiA1f4Rg5fEocDkHy5gU9fSHX8SFR1CUAMzUXiHK9RFEVuwZXX5hWVR9BAwfI3mP
         H0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=V6CaRSgI9rgdIOv2xX+uwC4H8AUDmNYhk3Db7/8cgBc=;
        b=k38yHQVdwJz4AnV9RYR0ZM2Ati6+asRkrYCW2jfTmtIWWRvLGqAwPAACClZr5SycYw
         f/sqhPrRHt+Kdj/5PK7elAI5CToNkJNdz+k1XWEINpDAkzOt1j31sotmD2bPn86Vrss7
         tq1+wKr4J1W5HemSZ0DBuBi6/UGZFUb7A5imPtyTGxTW/qP84QaH/GLgM3FzJZclTDxE
         qMh73WkaDqT+kryqumLf5FUtUI4fQl7mNFOFHhkfKrskFy2I9L/k2P941659ey9JUvtq
         fq2QwCqljRLn4qyQbMPo0fLfnPBs5tlKu+9ntv26UIAjHAxlEo8599a0K80s44EFYaA9
         I5Eg==
X-Gm-Message-State: AJcUukeoALwSinZO3x4oWYeMltc2DNLGsGRXJodLZWcra4beewSZ0FJX
        icF1wOV5rjP3xTin/IHtr5Heq1h3
X-Google-Smtp-Source: ALg8bN6W6xJZGeEN31c4BMuwlzBfD7fNNGx2U85NFnlYNsvAknaUrrqIuK8OTsZ9PvhC3lgaq1gPdA==
X-Received: by 2002:a5d:40c1:: with SMTP id b1mr7219699wrq.133.1547078971968;
        Wed, 09 Jan 2019 16:09:31 -0800 (PST)
Received: from [172.30.90.141] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id j8sm34576393wmd.0.2019.01.09.16.09.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 16:09:31 -0800 (PST)
Subject: Re: [PATCH v2 2/3] media: imx: set compose rectangle to mbus format
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
 <20190109110831.23395-2-p.zabel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3ae34100-006d-a9cb-234f-b4a8740d56c5@gmail.com>
Date:   Wed, 9 Jan 2019 16:09:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190109110831.23395-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>


On 1/9/19 3:08 AM, Philipp Zabel wrote:
> Prepare for mbus format being smaller than the written rectangle
> due to burst size.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>   - Typo fixups, this time applied to the correct patch.
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 56 +++++++++++++------
>   1 file changed, 38 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index fb985e68f9ab..614e335fb61c 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -203,21 +203,13 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
>   	return 0;
>   }
>   
> -static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> -				   struct v4l2_format *f)
> +static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
> +				     struct v4l2_subdev_format *fmt_src,
> +				     struct v4l2_format *f)
>   {
> -	struct capture_priv *priv = video_drvdata(file);
> -	struct v4l2_subdev_format fmt_src;
>   	const struct imx_media_pixfmt *cc, *cc_src;
> -	int ret;
>   
> -	fmt_src.pad = priv->src_sd_pad;
> -	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> -	if (ret)
> -		return ret;
> -
> -	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
> +	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
>   	if (cc_src) {
>   		u32 fourcc, cs_sel;
>   
> @@ -231,7 +223,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   			cc = imx_media_find_format(fourcc, cs_sel, false);
>   		}
>   	} else {
> -		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> +		cc_src = imx_media_find_mbus_format(fmt_src->format.code,
>   						    CS_SEL_ANY, true);
>   		if (WARN_ON(!cc_src))
>   			return -EINVAL;
> @@ -239,15 +231,32 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   		cc = cc_src;
>   	}
>   
> -	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
> +	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src->format, cc);
>   
>   	return 0;
>   }
>   
> +static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> +				   struct v4l2_format *f)
> +{
> +	struct capture_priv *priv = video_drvdata(file);
> +	struct v4l2_subdev_format fmt_src;
> +	int ret;
> +
> +	fmt_src.pad = priv->src_sd_pad;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> +	if (ret)
> +		return ret;
> +
> +	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
> +}
> +
>   static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   				 struct v4l2_format *f)
>   {
>   	struct capture_priv *priv = video_drvdata(file);
> +	struct v4l2_subdev_format fmt_src;
>   	int ret;
>   
>   	if (vb2_is_busy(&priv->q)) {
> @@ -255,7 +264,13 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   		return -EBUSY;
>   	}
>   
> -	ret = capture_try_fmt_vid_cap(file, priv, f);
> +	fmt_src.pad = priv->src_sd_pad;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
> +	if (ret)
> +		return ret;
> +
> +	ret = __capture_try_fmt_vid_cap(priv, &fmt_src, f);
>   	if (ret)
>   		return ret;
>   
> @@ -264,8 +279,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   					      CS_SEL_ANY, true);
>   	priv->vdev.compose.left = 0;
>   	priv->vdev.compose.top = 0;
> -	priv->vdev.compose.width = f->fmt.pix.width;
> -	priv->vdev.compose.height = f->fmt.pix.height;
> +	priv->vdev.compose.width = fmt_src.format.width;
> +	priv->vdev.compose.height = fmt_src.format.height;
>   
>   	return 0;
>   }
> @@ -306,9 +321,14 @@ static int capture_g_selection(struct file *file, void *fh,
>   	case V4L2_SEL_TGT_COMPOSE:
>   	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>   	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> -	case V4L2_SEL_TGT_COMPOSE_PADDED:
>   		s->r = priv->vdev.compose;
>   		break;
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = priv->vdev.fmt.fmt.pix.width;
> +		s->r.height = priv->vdev.fmt.fmt.pix.height;
> +		break;
>   	default:
>   		return -EINVAL;
>   	}

