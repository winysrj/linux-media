Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:44800 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbdBOMsB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 07:48:01 -0500
Message-ID: <58A44DFB.6090105@bfs.de>
Date: Wed, 15 Feb 2017 13:47:55 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] staging: bcm2835-camera: free first element in array
References: <20170215122523.GA12198@mwanda>
In-Reply-To: <20170215122523.GA12198@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 15.02.2017 13:25, schrieb Dan Carpenter:
> We should free gdev[0] so the > should be >=.
> 
> Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> index ca15a698e018..9bcd8e546a14 100644
> --- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> @@ -1998,7 +1998,7 @@ static int __init bm2835_mmal_init(void)
>  free_dev:
>  	kfree(dev);
>  
> -	for ( ; camera > 0; camera--) {
> +	for ( ; camera >= 0; camera--) {
>  		bcm2835_cleanup_instance(gdev[camera]);
>  		gdev[camera] = NULL;
>  	}

since we already know that programmers are bad in counting backwards ...

is is possible to change that into std. loop like:

 for(i=0, i< camera; i++ {
	bcm2835_cleanup_instance(gdev[i]);
	gdev[i] = NULL;
  	}

this is way a much more common pattern.


just my 2 cents,
re,
 wh
