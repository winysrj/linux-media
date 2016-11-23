Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:64197 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753068AbcKWSY2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 13:24:28 -0500
Subject: Re: [PATCH] [media] DaVinci-VPFE-Capture: fix error handling
To: Arnd Bergmann <arnd@arndb.de>
References: <20161122205231.799066-1-arnd@arndb.de>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <a1677e94-24f3-c745-ca36-53b1e29955e4@users.sourceforge.net>
Date: Wed, 23 Nov 2016 19:24:11 +0100
MIME-Version: 1.0
In-Reply-To: <20161122205231.799066-1-arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> A recent cleanup had the right idea to remove the initialization
> of the error variable, but missed the actual benefit of that,
> which is that we get warnings if there is a bug in it.
> Now we get a warning about a bug that was introduced by this cleanup:
> 
> drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
> drivers/media/platform/davinci/vpfe_capture.c:1992:9: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Thanks for your information.


> This adds the missing initialization that the warning is about,

I have got the impression that an other wording would be more appropriate.


> and another one that was preexisting and that we did not get
> a warning for. That second bug has existed since the driver
> was first added.

Do you distinguish better between the setting for two return values because of either
a memory allocation failure and a failed call of the function "v4l2_i2c_new_subdev_board" here?


> Fixes: efb74461f5a6 ("[media] DaVinci-VPFE-Capture: Delete an unnecessary variable initialisation in vpfe_probe()")
> Fixes: 7da8a6cb3e5b ("V4L/DVB (12248): v4l: vpfe capture bridge driver for DM355 and DM6446")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/davinci/vpfe_capture.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 6c41782b3ba0..ee1cd79739c8 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1847,8 +1847,10 @@ static int vpfe_probe(struct platform_device *pdev)
>  
>  	/* Allocate memory for ccdc configuration */
>  	ccdc_cfg = kmalloc(sizeof(*ccdc_cfg), GFP_KERNEL);
> -	if (!ccdc_cfg)
> +	if (!ccdc_cfg) {
> +		ret = -ENOMEM;
>  		goto probe_free_dev_mem;
> +	}
>  
>  	mutex_lock(&ccdc_lock);
>  
> @@ -1964,6 +1966,7 @@ static int vpfe_probe(struct platform_device *pdev)
>  			v4l2_info(&vpfe_dev->v4l2_dev,
>  				  "v4l2 sub device %s register fails\n",
>  				  sdinfo->name);
> +			ret = -ENXIO;
>  			goto probe_sd_out;
>  		}
>  	}
> 

Thanks for your source code correction.

Regards,
Markus
