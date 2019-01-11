Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D25C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9302084C
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQ+h45Hg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbfAKNRW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:17:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38082 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbfAKNRW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 08:17:22 -0500
Received: by mail-pl1-f195.google.com with SMTP id e5so6762397plb.5
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2019 05:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t9f/I1ALTHgUokJQRJJIY7/zmTopJ1hD7QQg87l3N28=;
        b=EQ+h45Hg1iiZMUw4StQ1+CHH75tzlAi0wxTjgHF5lC7VN8a/iCfBVgNbgKJyyRHpnx
         wf0kvHWdIG1usY6QfGQWCbgKepaKVE/GaQWXkYCQIBmqnPem5cglbkDTcn9V9pvjKnFu
         ywvNprkpHcLbGIhh/sHo14+S78dLotU3jEXl0/M+LzDZ33cFhhUyNNKMAZlQ3B29EFJ6
         /0743f1d+qrUp+ad88A9jJ9j4g+seib3ZG8LdxdHib8ZWVRHP9NQuVlO0VAIw0ZAiTvv
         bk8pgT9GbcppRsgpb+2sfQNDNH4MLrLT2uqqy5B9n/BzrsQYuo7Dq6HMdP76BCW5fhkn
         n8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t9f/I1ALTHgUokJQRJJIY7/zmTopJ1hD7QQg87l3N28=;
        b=UvjVhR34eVzrfmDGj0RINjT4ig6elfMIW01GdYjSoAl6VRC7/mf39HMBqUJ5/oM44c
         gMooGvhYZZDt0e6gydPi120ZN36CDW7Eb2FDtU3sZhOmbYzC0fRgSTbchO/e3qpLt1Ff
         USrmUnWMr8lx6gBJnQarqItuhjKRVb1PSjOfn5umCiCQyBxO4lD4A8oxysKHyy4ilPl0
         TZ3pn1EqkTapqvzVhRzVLJ5G6LVlsOe/b1oaRtxT/cuj0OBTNckvXgBd6VWljZPNRMEg
         LeMBqpaIvq0K8sC/hCKeiIX4hoSSCexH0N5S96vdJFYucwhVpWjIBMat/SIDDekr+icN
         FDMA==
X-Gm-Message-State: AJcUukdOLQTEQrvujn67jAqt/I2ZFsQCAehKU2i8EN6FSVHx5Re2knEA
        8jaBSye8id4AjNqFDnAhjcge/+QZbDgtZrOQUKBmAJkd
X-Google-Smtp-Source: ALg8bN70EMyWF8RxYJG36A/I39dTniTa+sibLqWwXY/QlmTjHBm7azduUahNHwGswY9yG6et89OMDFk7uevIcNli+Kc=
X-Received: by 2002:a17:902:24a2:: with SMTP id w31mr14376517pla.216.1547212641193;
 Fri, 11 Jan 2019 05:17:21 -0800 (PST)
MIME-Version: 1.0
References: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com> <1547134109-21449-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1547134109-21449-2-git-send-email-akinobu.mita@gmail.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Fri, 11 Jan 2019 22:17:10 +0900
Message-ID: <CAC5umygV4adR=zQzp1s+kg5gYYJvYBpt_szeR8ipz=bawRMY=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
To:     linux-media@vger.kernel.org
Cc:     Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=8811=E6=97=A5(=E9=87=91) 0:28 Akinobu Mita <akinobu.mi=
ta@gmail.com>:
</akinobu.mita@gmail.com>
>
> The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> is specified.
>
> Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Marco Felsch <m.felsch@pengutronix.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Use format->pad for the argument of v4l2_subdev_get_try_format().
>
>  drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index d639b9b..eb5bf71 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
>         if (format->pad)
>                 return -EINVAL;
>
> +       if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> +               mf =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +               format->format =3D *mf;
> +               return 0;
> +#else
> +               return -ENOTTY;
> +#endif
> +       }
> +
>         mf->width       =3D mt9m111->width;
>         mf->height      =3D mt9m111->height;
>         mf->code        =3D mt9m111->fmt->code;
> @@ -1089,6 +1099,26 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd=
, int enable)
>         return 0;
>  }
>
> +static int mt9m111_init_cfg(struct v4l2_subdev *sd,
> +                           struct v4l2_subdev_pad_config *cfg)
> +{
> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> +       struct mt9m111 *mt9m111 =3D container_of(sd, struct mt9m111, subd=
ev);
> +       struct v4l2_mbus_framefmt *format =3D
> +               v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +       format->width   =3D mt9m111->width;
> +       format->height  =3D mt9m111->height;
> +       format->code    =3D mt9m111->fmt->code;
> +       format->colorspace      =3D mt9m111->fmt->colorspace;

Oops, I made the same mistake that I did for mt9m001 driver.
This should be the default configuration instead of current one.
