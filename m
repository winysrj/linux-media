Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:36390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab0J0OYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 10:24:05 -0400
Message-ID: <4CC835FF.40309@infradead.org>
Date: Wed, 27 Oct 2010 12:23:59 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: linux-media@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] cafe_ccic: fix subdev configuration
References: <20101027134532.3E0DF9D401B@zog.reactivated.net>
In-Reply-To: <20101027134532.3E0DF9D401B@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-10-2010 11:45, Daniel Drake escreveu:
> For some reason, commit 1aafeb30104a is missing one change that was
> included in the email submission.
> 
> The sensor configuration must be passed down to the ov7670 subdev.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/media/video/cafe_ccic.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> index 8a07906..21f6f06 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -2065,8 +2065,9 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  		sensor_cfg.clock_speed = 45;
>  
>  	cam->sensor_addr = 0x42;
> -	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, &cam->i2c_adapter,
> -			NULL, "ov7670", cam->sensor_addr, NULL);
> +	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
> +			"ov7670", "ov7670", 0, &sensor_cfg, cam->sensor_addr,
> +			NULL);

Sorry... that was my fault. One of the parameters of v4l2_i2c_new_subdev & friends
were removed by a previous patch (the duplicate "ov7670"). I probably didn't fix
the conflict right.

As I don't want to postpone the pull request that I'll do today, waiting for more
days at linux-next, so, I'll apply this patch and send it on a next pull request.

In the interim, could you please test if using this instead will equally work?

	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
 			NULL, "ov7670", 0, &sensor_cfg, cam->sensor_addr,
			NULL);

(you should test it against my git tree or against linux-next tree).

There's a pending patch to be applied after -rc1 release that will remove the extra
parameter, as is is not needed anymore.

Cheers,
Mauro
