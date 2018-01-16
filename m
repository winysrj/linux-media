Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbeAPPoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 10:44:07 -0500
Date: Tue, 16 Jan 2018 17:44:03 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] media: s3c-camif: fix out-of-bounds array access
Message-ID: <20180116154403.muqorw74ggyhz7ze@paasikivi.fi.intel.com>
References: <20180116153105.3523235-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116153105.3523235-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch. Please see my comments below.

On Tue, Jan 16, 2018 at 04:30:46PM +0100, Arnd Bergmann wrote:
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
> As Sylvester explains, we actually need to ensure that the
> value is within the range, so this reworks the loop to be
> easier to parse correctly, and an additional check to fall
> back on the first format value for any unexpected input.
> 
> I found an existing gcc bug for it and added a reduced version
> of the function there.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69249#c3
> Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: rework logic rather than removing it.
> ---
>  drivers/media/platform/s3c-camif/camif-capture.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 437395a61065..002609be1400 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1256,15 +1256,18 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
>  {
>  	const struct s3c_camif_variant *variant = camif->variant;
>  	const struct vp_pix_limits *pix_lim;
> -	int i = ARRAY_SIZE(camif_mbus_formats);
> +	int i;
>  
>  	/* FIXME: constraints against codec or preview path ? */
>  	pix_lim = &variant->vp_pix_limits[VP_CODEC];
>  
> -	while (i-- >= 0)
> +	for (i = 0; i < ARRAY_SIZE(camif_mbus_formats); i++)

Yeah, that loop was odd...

>  		if (camif_mbus_formats[i] == mf->code)
>  			break;
>  
> +	if (i == ARRAY_SIZE(camif_mbus_formats))
> +		mf->code = camif_mbus_formats[0];
> +

Either else here so that the line below is executed only if the condition
is false, or assign i = 0 above. Otherwise you'll end up with a different
off-by-one bug. :-)

i could be unsigned int, too. It'd be nicer that way actually.

>  	mf->code = camif_mbus_formats[i];

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
