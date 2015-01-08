Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:19219 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbbAHLN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jan 2015 06:13:57 -0500
Message-ID: <54AE6434.4070805@bfs.de>
Date: Thu, 08 Jan 2015 12:04:20 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] coda: improve safety in coda_register_device()
References: <20150108100708.GA10597@mwanda>
In-Reply-To: <20150108100708.GA10597@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 08.01.2015 11:07, schrieb Dan Carpenter:
> The "i" variable is used as an offset into both the dev->vfd[] and the
> dev->devtype->vdevs[] arrays.  The second array is smaller so we should
> use that as a limit instead of ARRAY_SIZE(dev->vfd).  Also the original
> check was off by one.
> 
> We should use a format string as well in case the ->name has any funny
> characters and also to stop static checkers from complaining.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 39330a7..5dd6cae 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1844,10 +1844,11 @@ static int coda_register_device(struct coda_dev *dev, int i)
>  {
>  	struct video_device *vfd = &dev->vfd[i];
>  
> -	if (i > ARRAY_SIZE(dev->vfd))
> +	if (i >= dev->devtype->num_vdevs)
>  		return -EINVAL;

hi,
 just a minor question. if i can not be trusted, i feel you should move the
 array access:
   struct video_device *vfd = &dev->vfd[i];
 after the check
   i >= dev->devtype->num_vdevs
at least that would improve the readability by not trigger my internal alarm
"check after access"

re,
 wh


> -	snprintf(vfd->name, sizeof(vfd->name), dev->devtype->vdevs[i]->name);
> +	snprintf(vfd->name, sizeof(vfd->name), "%s",
> +		 dev->devtype->vdevs[i]->name);
>  	vfd->fops	= &coda_fops;
>  	vfd->ioctl_ops	= &coda_ioctl_ops;
>  	vfd->release	= video_device_release_empty,
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
