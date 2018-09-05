Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46310 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbeIEMWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 08:22:32 -0400
Subject: Re: [PATCH 1/2] media: v4l2-common: v4l2_spi_subdev_init : generate
 unique name
To: Philippe De Muyter <phdm@macqel.be>, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com
References: <1533158457-15831-1-git-send-email-phdm@macqel.be>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <29510485-c3bb-3943-83a8-2751ad959f0b@xs4all.nl>
Date: Wed, 5 Sep 2018 09:53:29 +0200
MIME-Version: 1.0
In-Reply-To: <1533158457-15831-1-git-send-email-phdm@macqel.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/18 23:20, Philippe De Muyter wrote:
> While v4l2_i2c_subdev_init does give a unique name to the subdev, matching
> the one appearing in dmesg for messages generated by dev_info and friends
> (e.g. imx185 30-0010), v4l2_spi_subdev_init does a poor job, copying only
> the driver name, but not the dev_name(), yielding e.g. "imx185", but
> missing the "spi1.1" part, and not generating a unique name.
> 
> Fix that.
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index b518b92..5471c6d 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -255,7 +255,9 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
>  	v4l2_set_subdevdata(sd, spi);
>  	spi_set_drvdata(spi, sd);
>  	/* initialize name */
> -	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
> +	snprintf(sd->name, sizeof(sd->name), "%s %s",
> +		spi->dev.driver->name, dev_name(&spi->dev));
> +
>  }
>  EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
>  
> 
