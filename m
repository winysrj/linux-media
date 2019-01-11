Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFE4C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD22420870
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RX2IrBGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbfAKSNf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 13:13:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56249 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfAKSNe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 13:13:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id y139so3238578wmc.5
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2019 10:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AGdZ4Q9gyneuP3bmfPwXOhdSm9Kl2uiKrlfg8vwRFr4=;
        b=RX2IrBGKR1B1k9sIMde+OzFR9+WLLJdE6gS6f1P7ZuHmq3Nheurqckhsf3aPIMgJza
         AfYFd5Eg3r6bWxK3vZ0pw4jJQWJ5Q+Hb8eUOmCSH5xwrtTj3KGz1cgSNhqQkslC+E/DB
         tklv+BP8yv9me9h1JsqiXBb1OGuNPltmFuowHdGhPGaHZUoMju1ptvBw74kHjilz+Khl
         MKmE3TAsguLFpFhSXDCWCvWS69EO5jIGsXoMUTJWz7P6pffnUJ2H3nKKumhWoGhDZr1A
         Sv73XYxAFg70UH8AZh7Uq0JJIHbMNGFQVN8affWIboawVAcYPXXbvtTS7YUtCYunxrjT
         Pwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AGdZ4Q9gyneuP3bmfPwXOhdSm9Kl2uiKrlfg8vwRFr4=;
        b=IkUO0gY2QA6UN+bDySqv7NVoVXG4+nM2JulzknPD6TG6b5Pzoimh37X07kbcEA/IdL
         j3ERIM/mAOB1tksq5iAQf+Y4PPjd4OC+F6bV5ZWxhmVWUz/WQvEfDc2MHqv9cfbqfgOz
         lcGpA85GhDMR0bx8BBNSezNj2HeuSTv6R2W6YAMFXXz1cEWC2S3DMKfExJB+GecJDlFI
         DfGndvfZ/9CU2nqb30WhoxE+gnpwesnW0IjhoK05V7n31CsXDI8heHzzUQwMeCb5OBhB
         HMsdXiw0bzdSMMlYrGg2nQYb8aZoAPjN5ho19oAisaC9USiZkKPx0i8cH4vexxng8+ML
         zeFQ==
X-Gm-Message-State: AJcUukdcA25KrXmFOfvvAHZXy6yr0yuIr340AWlivcb9FA72JxUn1n9c
        edPZFENmVroPTjCHeqc89qs=
X-Google-Smtp-Source: ALg8bN6AOyGRKRoo92/nA/KZqiodTxFKeKtUnM7p3xgFYE3PWnnn+8RBsQ1gsJ8b36ZcVM2MloRwIw==
X-Received: by 2002:a1c:4e08:: with SMTP id g8mr3167547wmh.46.1547230411928;
        Fri, 11 Jan 2019 10:13:31 -0800 (PST)
Received: from [172.30.90.140] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id s1sm93295013wro.9.2019.01.11.10.13.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 10:13:31 -0800 (PST)
Subject: Re: [PATCH v3 3/3] media: imx: lift CSI and PRP ENC/VF width
 alignment restriction
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190111111053.12551-1-p.zabel@pengutronix.de>
 <20190111111053.12551-3-p.zabel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <cbb85fa4-92bd-006e-2edd-45cc548824c1@gmail.com>
Date:   Fri, 11 Jan 2019 10:13:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190111111053.12551-3-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>

On 1/11/19 3:10 AM, Philipp Zabel wrote:
> The CSI, PRP ENC, and PRP VF subdevices shouldn't have to care about
> IDMAC line start address alignment. With compose rectangle support in
> the capture driver, they don't have to anymore.
> If the direct CSI -> IC path is enabled, the CSI output width must
> still be aligned to 8 pixels (IC burst length).
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v2:
>   - drop csi_src_pad_enabled(), check active_output_pad instead
>   - initialize active_output_pad and set it to CSI_SRC_PAD_IDMAC
>     while source pad links are disabled
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c |  2 +-
>   drivers/staging/media/imx/imx-media-csi.c   | 11 +++++++++--
>   drivers/staging/media/imx/imx-media-utils.c | 15 ++++++++++++---
>   3 files changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index fe5a77baa592..7bb754cb703e 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -48,7 +48,7 @@
>   
>   #define MAX_W_SRC  1024
>   #define MAX_H_SRC  1024
> -#define W_ALIGN_SRC   4 /* multiple of 16 pixels */
> +#define W_ALIGN_SRC   1 /* multiple of 2 pixels */
>   #define H_ALIGN_SRC   1 /* multiple of 2 lines */
>   
>   #define S_ALIGN       1 /* multiple of 2 */
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index c4523afe7b48..390beb61aa9b 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -41,7 +41,7 @@
>   #define MIN_H       144
>   #define MAX_W      4096
>   #define MAX_H      4096
> -#define W_ALIGN    4 /* multiple of 16 pixels */
> +#define W_ALIGN    1 /* multiple of 2 pixels */
>   #define H_ALIGN    1 /* multiple of 2 lines */
>   #define S_ALIGN    1 /* multiple of 2 */
>   
> @@ -1000,6 +1000,8 @@ static int csi_link_setup(struct media_entity *entity,
>   		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
>   		v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
>   		priv->sink = NULL;
> +		/* do not apply IC burst alignment in csi_try_crop */
> +		priv->active_output_pad = CSI_SRC_PAD_IDMAC;
>   		goto out;
>   	}
>   
> @@ -1141,7 +1143,10 @@ static void csi_try_crop(struct csi_priv *priv,
>   		crop->left = infmt->width - crop->width;
>   	/* adjust crop left/width to h/w alignment restrictions */
>   	crop->left &= ~0x3;
> -	crop->width &= ~0x7;
> +	if (priv->active_output_pad == CSI_SRC_PAD_DIRECT)
> +		crop->width &= ~0x7; /* multiple of 8 pixels (IC burst) */
> +	else
> +		crop->width &= ~0x1; /* multiple of 2 pixels */
>   
>   	/*
>   	 * FIXME: not sure why yet, but on interlaced bt.656,
> @@ -1863,6 +1868,8 @@ static int imx_csi_probe(struct platform_device *pdev)
>   	priv->csi_id = pdata->csi;
>   	priv->smfc_id = (priv->csi_id == 0) ? 0 : 2;
>   
> +	priv->active_output_pad = CSI_SRC_PAD_IDMAC;
> +
>   	timer_setup(&priv->eof_timeout_timer, csi_idmac_eof_timeout, 0);
>   	spin_lock_init(&priv->irqlock);
>   
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 0eaa353d5cb3..5f110d90a4ef 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -580,6 +580,7 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
>   				  struct v4l2_mbus_framefmt *mbus,
>   				  const struct imx_media_pixfmt *cc)
>   {
> +	u32 width;
>   	u32 stride;
>   
>   	if (!cc) {
> @@ -602,9 +603,16 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
>   		cc = imx_media_find_mbus_format(code, CS_SEL_YUV, false);
>   	}
>   
> -	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
> +	/* Round up width for minimum burst size */
> +	width = round_up(mbus->width, 8);
>   
> -	pix->width = mbus->width;
> +	/* Round up stride for IDMAC line start address alignment */
> +	if (cc->planar)
> +		stride = round_up(width, 16);
> +	else
> +		stride = round_up((width * cc->bpp) >> 3, 8);
> +
> +	pix->width = width;
>   	pix->height = mbus->height;
>   	pix->pixelformat = cc->fourcc;
>   	pix->colorspace = mbus->colorspace;
> @@ -613,7 +621,8 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
>   	pix->quantization = mbus->quantization;
>   	pix->field = mbus->field;
>   	pix->bytesperline = stride;
> -	pix->sizeimage = (pix->width * pix->height * cc->bpp) >> 3;
> +	pix->sizeimage = cc->planar ? ((stride * pix->height * cc->bpp) >> 3) :
> +			 stride * pix->height;
>   
>   	return 0;
>   }

