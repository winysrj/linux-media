Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:63312 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752074AbdBRLfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Feb 2017 06:35:17 -0500
Message-ID: <58A8316E.9060709@bfs.de>
Date: Sat, 18 Feb 2017 12:35:10 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] staging: bcm2835-camera: fix error handling in init
References: <20170217232015.GA26717@mwanda>
In-Reply-To: <20170217232015.GA26717@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

looks more readable now :)

Acked-by: wharms@bfs.de

Am 18.02.2017 00:20, schrieb Dan Carpenter:
> The unwinding here isn't right.  We don't free gdev[0] and instead
> free 1 step past what was allocated.  Also we can't allocate "dev" then
> we should unwind instead of returning directly.
> 
> Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Change the style to make Walter Harms happy.  Fix some additional
>     bugs I missed in the first patch.
> 
> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> index ca15a698e018..c4dad30dd133 100644
> --- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> @@ -1901,6 +1901,7 @@ static int __init bm2835_mmal_init(void)
>  	unsigned int num_cameras;
>  	struct vchiq_mmal_instance *instance;
>  	unsigned int resolutions[MAX_BCM2835_CAMERAS][2];
> +	int i;
>  
>  	ret = vchiq_mmal_init(&instance);
>  	if (ret < 0)
> @@ -1914,8 +1915,10 @@ static int __init bm2835_mmal_init(void)
>  
>  	for (camera = 0; camera < num_cameras; camera++) {
>  		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
> -		if (!dev)
> -			return -ENOMEM;
> +		if (!dev) {
> +			ret = -ENOMEM;
> +			goto cleanup_gdev;
> +		}
>  
>  		dev->camera_num = camera;
>  		dev->max_width = resolutions[camera][0];
> @@ -1998,9 +2001,10 @@ static int __init bm2835_mmal_init(void)
>  free_dev:
>  	kfree(dev);
>  
> -	for ( ; camera > 0; camera--) {
> -		bcm2835_cleanup_instance(gdev[camera]);
> -		gdev[camera] = NULL;
> +cleanup_gdev:
> +	for (i = 0; i < camera; i++) {
> +		bcm2835_cleanup_instance(gdev[i]);
> +		gdev[i] = NULL;
>  	}
>  	pr_info("%s: error %d while loading driver\n",
>  		BM2835_MMAL_MODULE_NAME, ret);
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
