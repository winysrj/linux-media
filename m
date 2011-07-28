Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50484 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1G1OeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 10:34:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCHv2] adp1653: check error code of adp1653_init_controls
Date: Thu, 28 Jul 2011 16:34:23 +0200
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
References: <20110727081522.GH32629@valkosipuli.localdomain> <4db811899ccd7b5315080790a627974e3569c7cc.1311839940.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <4db811899ccd7b5315080790a627974e3569c7cc.1311839940.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107281634.24288.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Thursday 28 July 2011 09:59:38 Andy Shevchenko wrote:
> Potentially the adp1653_init_controls could return an error. In our case
> the error was ignored, meanwhile it means incorrect initialization of V4L2
> controls. Additionally we have to free control handler structures in case
> of apd1653_init_controls or media_entity_init failure.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/adp1653.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 8ad89ff..279d75d 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -429,12 +429,19 @@ static int adp1653_probe(struct i2c_client *client,
>  	flash->subdev.internal_ops = &adp1653_internal_ops;
>  	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
> -	adp1653_init_controls(flash);
> +	ret = adp1653_init_controls(flash);
> +	if (ret)
> +		goto free_and_quit;
> 
>  	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
>  	if (ret < 0)
> -		kfree(flash);
> +		goto free_and_quit;
> 
> +	return 0;
> +
> +free_and_quit:
> +	v4l2_ctrl_handler_free(&flash->ctrls);
> +	kfree(flash);
>  	return ret;

What about

        ret = adp1653_init_controls(flash);
        if (ret)
                goto done;

        ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);

done:
        if (ret < 0) {
                v4l2_ctrl_handler_free(&flash->ctrls);
                kfree(flash);
        }

        return ret;
>  }

-- 
Regards,

Laurent Pinchart
