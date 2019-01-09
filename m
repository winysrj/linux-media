Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBE1C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C788206BA
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FH9Uo33w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfAITVQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:21:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33288 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfAITVP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 14:21:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so11655787wmh.0
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 11:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TpeB+ej2pJwjnx5oCCgWYHo4nV9ZeyEjbrFcXLux9/0=;
        b=FH9Uo33whmHTyUP9W+eG+1oi7GDquUMx8IpnwiFr+FnWdq3xtcIPEwWZe4rIWv4FhS
         Vph+xAicbu7WT7QTw/FSIjsxHFvN8MfUkUU6JIsX28ntVf4wbJ7ZdkRsv00D+JT7ksSE
         SpaMJ8oRxVTVsrMXVwLbQXn5pBeqKhmcSD7y4RZMDza6UdZM0AJbKUl4VerEDfTdh+ea
         SUPk+KG9Dbh/ZV8LPNabLmWlKlOQsKwTyZROJE4otJyKs00Dv6ITBhBMj+fuMO8FtRvL
         M+amoYNHxO0eyIdjVVbSCWGL5K7q3b8PqQl/b2uQGslhc6M60SiWrPmLB6xsbzjtJx16
         BMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TpeB+ej2pJwjnx5oCCgWYHo4nV9ZeyEjbrFcXLux9/0=;
        b=Z/6tB2moS44u6uCEbj8ffJwmjGOCyrA0bzASruxfpqWgtmswVc6hThfp0+fldF9IwP
         1mfM4I2hT430I6bwNxkMrUiskC31UpGgBNwv3j1chyxQjdNTk1WSzadSsi9BTd7yklm2
         dj1FvdC4L+LT/y4f04gUnsgxYREpYsJUjyh+KtrZGuPZb6PwHqlAsX8ptvIWcyHZu3QZ
         uZBL8Qp1X3Y7kkWjS4ZBx1pZCDQr47BBYoWo+/Qt2GmjTgA3rk0W/j/21YU8yAbKl9To
         4KZgyc+sqohNTs6iPNp+m4FtefD6j30Alj+C/o2wMxuqfkmn7LIrDl7X/vv8YYtKmqnc
         //wQ==
X-Gm-Message-State: AJcUukdkczOurH/qDZhTDjGlLmfbgAoqDDC/MAmRNvhLrGcrpih8Wms6
        GxZHR1ayWr/UKIM9Pzon3WaTQtaJ
X-Google-Smtp-Source: ALg8bN6sX0dvl+SNraNv/G5CCT1obLEzQn3D0jOATQ9FN1TbKUdmAJK+Cu5UWdQ5eh1QiRtdnMjmzw==
X-Received: by 2002:a1c:f319:: with SMTP id q25mr6888705wmq.151.1547061672447;
        Wed, 09 Jan 2019 11:21:12 -0800 (PST)
Received: from [172.30.90.141] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id x10sm65718690wrn.29.2019.01.09.11.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 11:21:11 -0800 (PST)
Subject: Re: [PATCH v2 3/3] media: imx: lift CSI and PRP ENC/VF width
 alignment restriction
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
 <20190109110831.23395-3-p.zabel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <fe63e40b-08ae-5ff1-c222-f5a624b83569@gmail.com>
Date:   Wed, 9 Jan 2019 11:21:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190109110831.23395-3-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/9/19 3:08 AM, Philipp Zabel wrote:
> The CSI, PRP ENC, and PRP VF subdevices shouldn't have to care about
> IDMAC line start address alignment. With compose rectangle support in
> the capture driver, they don't have to anymore.
> If the direct CSI -> IC path is enabled, the CSI output width must
> still be aligned to 8 pixels (IC burst length).
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>   - Relax PRP ENC and PRP VF source pad width alignment as well
>   - Relax CSI crop width alignment to 2 pixels if direct CSI -> IC path
>     is not enabled
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c |  2 +-
>   drivers/staging/media/imx/imx-media-csi.c   | 21 +++++++++++++++++++--
>   drivers/staging/media/imx/imx-media-utils.c | 15 ++++++++++++---
>   3 files changed, 32 insertions(+), 6 deletions(-)
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
> index c4523afe7b48..1b4962b8b192 100644
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
> @@ -1130,6 +1130,20 @@ __csi_get_compose(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
>   		return &priv->compose;
>   }
>   
> +static bool csi_src_pad_enabled(struct media_pad *pad)
> +{
> +	struct media_link *link;
> +
> +	list_for_each_entry(link, &pad->entity->links, list) {
> +		if (link->source->entity == pad->entity &&
> +		    link->source->index == pad->index &&
> +		    link->flags & MEDIA_LNK_FL_ENABLED)
> +			return true;
> +	}
> +
> +	return false;
> +}

I don't think this function is needed, first it is basically equivalent to
media_entity_remote_pad(), but also...

> +
>   static void csi_try_crop(struct csi_priv *priv,
>   			 struct v4l2_rect *crop,
>   			 struct v4l2_subdev_pad_config *cfg,
> @@ -1141,7 +1155,10 @@ static void csi_try_crop(struct csi_priv *priv,
>   		crop->left = infmt->width - crop->width;
>   	/* adjust crop left/width to h/w alignment restrictions */
>   	crop->left &= ~0x3;
> -	crop->width &= ~0x7;
> +	if (csi_src_pad_enabled(&priv->pad[CSI_SRC_PAD_DIRECT]))

why not just use "if (priv->active_output_pad == CSI_SRC_PAD_DIRECT) ..." ?

Steve

> +		crop->width &= ~0x7; /* multiple of 8 pixels (IC burst) */
> +	else
> +		crop->width &= ~0x1; /* multiple of 2 pixels */
>   
>   	/*
>   	 * FIXME: not sure why yet, but on interlaced bt.656,
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

