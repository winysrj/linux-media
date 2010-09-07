Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:55628 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0IGUCV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 16:02:21 -0400
Date: Tue, 7 Sep 2010 22:15:38 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Jarkko Nikula <jhnikula@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 1/2] V4L/DVB: radio-si4713: Release i2c adapter in
 driver cleanup paths
Message-ID: <20100907191538.GB10360@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Jarkko and Mauro,

Apologies for the long delay.

On Sun, Jun 13, 2010 at 08:09:27PM +0200, Jarkko Nikula wrote:
> Call to i2c_put_adapter was missing in radio_si4713_pdriver_probe and
> radio_si4713_pdriver_remove.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>

Acked-by: Eduardo Valentin <eduardo.valentin@nokia.com>

> ---
>  drivers/media/radio/radio-si4713.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index 13554ab..0a9fc4d 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -296,14 +296,14 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>  	if (!sd) {
>  		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
>  		rval = -ENODEV;
> -		goto unregister_v4l2_dev;
> +		goto put_adapter;
>  	}
>  
>  	rsdev->radio_dev = video_device_alloc();
>  	if (!rsdev->radio_dev) {
>  		dev_err(&pdev->dev, "Failed to alloc video device.\n");
>  		rval = -ENOMEM;
> -		goto unregister_v4l2_dev;
> +		goto put_adapter;
>  	}
>  
>  	memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
> @@ -320,6 +320,8 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>  
>  free_vdev:
>  	video_device_release(rsdev->radio_dev);
> +put_adapter:
> +	i2c_put_adapter(adapter);
>  unregister_v4l2_dev:
>  	v4l2_device_unregister(&rsdev->v4l2_dev);
>  free_rsdev:
> @@ -335,8 +337,12 @@ static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
>  	struct radio_si4713_device *rsdev = container_of(v4l2_dev,
>  						struct radio_si4713_device,
>  						v4l2_dev);
> +	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
> +					    struct v4l2_subdev, list);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	video_unregister_device(rsdev->radio_dev);
> +	i2c_put_adapter(client->adapter);
>  	v4l2_device_unregister(&rsdev->v4l2_dev);
>  	kfree(rsdev);
>  
> -- 
> 1.7.1

-- 
---
Eduardo Valentin
