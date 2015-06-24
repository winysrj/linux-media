Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48472 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbFXFx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 01:53:57 -0400
Message-id: <558A45F0.2010601@samsung.com>
Date: Wed, 24 Jun 2015 07:53:52 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Antonio Borneo <borneo.antonio@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] [media] s5c73m3: Remove redundant spi driver bus
 initialization
References: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
 <1435071199-24630-1-git-send-email-borneo.antonio@gmail.com>
In-reply-to: <1435071199-24630-1-git-send-email-borneo.antonio@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2015 04:53 PM, Antonio Borneo wrote:
> In ancient times it was necessary to manually initialize the bus
> field of an spi_driver to spi_bus_type. These days this is done in
> spi_register_driver(), so we can drop the manual assignment.
>
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> To: Kyungmin Park <kyungmin.park@samsung.com>
> To: Andrzej Hajda <a.hajda@samsung.com>
> To: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

Regards
Andrzej
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-spi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> index 63eb190..fa4a5eb 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> @@ -149,7 +149,6 @@ int s5c73m3_register_spi_driver(struct s5c73m3 *state)
>  	spidrv->remove = s5c73m3_spi_remove;
>  	spidrv->probe = s5c73m3_spi_probe;
>  	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
> -	spidrv->driver.bus = &spi_bus_type;
>  	spidrv->driver.owner = THIS_MODULE;
>  	spidrv->driver.of_match_table = s5c73m3_spi_ids;
>  

