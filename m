Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FAAC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF992147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t+oZa3nZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfBTLV4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:21:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40182 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfBTLVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:21:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id t15so5969120wmi.5
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 03:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=r74IpOf9/ShDVX1VNl7RyQzvzNVrJn3CJYaLd7TU1Dw=;
        b=t+oZa3nZDmJFb8re+8Z427PflMFECcVyQXCvyCzppAJdHERF/lXU1cRFdSSpXRb4vu
         mx2+BD+AUU4s7GQUU85mYASBlfg7o3okZoq4hfRByw5JFSuhAUZptKnW6c2KxsEBjxfp
         of5bZ152UPSKa04lvT6bWGqIg5eGrc3gwHwQR+pG5eFoG5rfOBJr00mKxNAbygtzI1cE
         jB1V5bswKNyO9B2/lgwWisJPEGrM06bhbPJRUc3UeSWmajzytfbUfEd1L8e7W6kM1cH5
         2qDE4GGFITKQVsiO2bgEe/duw+jXzTbIwMKsknk5to8Q4W+bPWb0qRA5ySNAK4BpcWex
         sAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=r74IpOf9/ShDVX1VNl7RyQzvzNVrJn3CJYaLd7TU1Dw=;
        b=VgU87eRvDWTqwmP6nfsx2mJfyLb3tRH3PTlBF9NPyqbClre95EsLba3qvPWEPk47LI
         QgVCFac9cbEikJShCck7kAEkgpeX62C/LTMC/pgqc/iSnqoygTaoc6L1d1EHzAZ91nq3
         26Y0YXOhKlvhYm6QAvTzHfA8D8AVnOilV1APJQCiJyUxTYHhVpHDMa1C5y112Nfsg6I5
         3Lk9hw2G5py1XH+ZoZz16+fAYhropcGGwHnZt04oOjKOz5aSvBQyANLkZxtAZIi4aK48
         N4a7pTa/WUWcwbUeAao7I2ToQulX+++dKGWewMTAFQI9I+NYaPsW9pgbCPROL/5VZWfx
         NL+Q==
X-Gm-Message-State: AHQUAuY/jV+ReRw8N+aGU1t3d1Wjyi+yIypM3j4TVGZ0DXWxY+GsKTpa
        FWLMDhFKhuNZN+YH7G2xuyY=
X-Google-Smtp-Source: AHgI3IbWx0Ipo4+lo0NyX5FnR9MFoa8C/tH4x984W9FbQjzlB2SjZlIgjn+VAqeqEQ/9cFPM7nBjtA==
X-Received: by 2002:a1c:be11:: with SMTP id o17mr6348720wmf.141.1550661714151;
        Wed, 20 Feb 2019 03:21:54 -0800 (PST)
Received: from arch-late ([87.196.73.87])
        by smtp.gmail.com with ESMTPSA id f13sm4852942wmh.41.2019.02.20.03.21.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 03:21:53 -0800 (PST)
References: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] media: imx7-media-csi: don't store a floating pointer
In-reply-to: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org>
Date:   Wed, 20 Feb 2019 11:21:50 +0000
Message-ID: <m3a7iqu2lt.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Oi Mauro,
On Tue 19 Feb 2019 at 13:24, Mauro Carvalho Chehab wrote:
> if imx7_csi_try_fmt() fails, outcc variable won't be
> initialized and csi->cc[IMX7_CSI_PAD_SRC] would be pointing
> to a random location.
>
> Signed-off-by: Mauro Carvalho Chehab 
> <mchehab+samsung@kernel.org>

Thanks for this, looks good.
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui

> ---
>  drivers/staging/media/imx/imx7-media-csi.c | 18 
>  +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx7-media-csi.c 
> b/drivers/staging/media/imx/imx7-media-csi.c
> index d775e259fece..0b1788d79ce9 100644
> --- a/drivers/staging/media/imx/imx7-media-csi.c
> +++ b/drivers/staging/media/imx/imx7-media-csi.c
> @@ -980,10 +980,10 @@ static int imx7_csi_get_fmt(struct 
> v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static void imx7_csi_try_fmt(struct imx7_csi *csi,
> -			     struct v4l2_subdev_pad_config *cfg,
> -			     struct v4l2_subdev_format *sdformat,
> -			     const struct imx_media_pixfmt **cc)
> +static int imx7_csi_try_fmt(struct imx7_csi *csi,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat,
> +			    const struct imx_media_pixfmt **cc)
>  {
>  	const struct imx_media_pixfmt *in_cc;
>  	struct v4l2_mbus_framefmt *in_fmt;
> @@ -992,7 +992,7 @@ static void imx7_csi_try_fmt(struct imx7_csi 
> *csi,
>  	in_fmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SINK,
>  				     sdformat->which);
>  	if (!in_fmt)
> -		return;
> +		return -EINVAL;
>  
>  	switch (sdformat->pad) {
>  	case IMX7_CSI_PAD_SRC:
> @@ -1023,8 +1023,10 @@ static void imx7_csi_try_fmt(struct 
> imx7_csi *csi,
>  						   false);
>  		break;
>  	default:
> +		return -EINVAL;
>  		break;
>  	}
> +	return 0;
>  }
>  
>  static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
> @@ -1067,8 +1069,10 @@ static int imx7_csi_set_fmt(struct 
> v4l2_subdev *sd,
>  		format.pad = IMX7_CSI_PAD_SRC;
>  		format.which = sdformat->which;
>  		format.format = sdformat->format;
> -		imx7_csi_try_fmt(csi, cfg, &format, &outcc);
> -
> +		if (imx7_csi_try_fmt(csi, cfg, &format, &outcc)) {
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		}
>  		outfmt = imx7_csi_get_format(csi, cfg, 
>  IMX7_CSI_PAD_SRC,
>  					     sdformat->which);
>  		*outfmt = format.format;

