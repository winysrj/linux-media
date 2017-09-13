Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:15017 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdIMJZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 05:25:54 -0400
Subject: Re: [PATCH] [media] s3c-camif: fix out-of-bounds array access
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <4355b20a-504c-4e83-92c8-049e6c6d6a5f@samsung.com>
Date: Wed, 13 Sep 2017 11:25:47 +0200
MIME-version: 1.0
In-reply-to: <20170912200932.3634089-1-arnd@arndb.de>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170912200932.3634089-1-arnd@arndb.de>
        <CGME20170913092551epcas1p4f84e118f364f605cb5cc6b8b669ac095@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2017 10:09 PM, Arnd Bergmann wrote:
> While experimenting with older compiler versions, I ran
> into a warning that no longer shows up on gcc-4.8 or newer:
> 
> drivers/media/platform/s3c-camif/camif-capture.c: In function '__camif_subdev_try_format':
> drivers/media/platform/s3c-camif/camif-capture.c:1265:25: error: array subscript is below array bounds
> 
> This is an off-by-one bug, leading to an access before the start of the
> array, while newer compilers silently assume this undefined behavior
> cannot happen and leave the loop at index 0 if no other entry matches.
> 
> Since the code is not only wrong, but also has no effect besides the
> out-of-bounds access, this patch just removes it.
> 
> I found an existing gcc bug for it and added a reduced version
> of the function there.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69249#c3
> Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/media/platform/s3c-camif/camif-capture.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 25c7a7d42292..c6921f6a5a6a 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1256,17 +1256,10 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
>   {
>   	const struct s3c_camif_variant *variant = camif->variant;
>   	const struct vp_pix_limits *pix_lim;
> -	int i = ARRAY_SIZE(camif_mbus_formats);
>   
>   	/* FIXME: constraints against codec or preview path ? */
>   	pix_lim = &variant->vp_pix_limits[VP_CODEC];
>   
> -	while (i-- >= 0)
> -		if (camif_mbus_formats[i] == mf->code)
> -			break;
> -
> -	mf->code = camif_mbus_formats[i];


Interesting finding... the function needs to ensure mf->code is set 
to one of supported values by the driver, so instead of removing 
how about changing the above line to:

	if (i < 0)
		mf->code = camif_mbus_formats[0];

?

-- 
Thanks,
Sylwester
