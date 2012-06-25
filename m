Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab2FYT3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 15:29:53 -0400
Message-ID: <4FE8BC2D.9030902@redhat.com>
Date: Mon, 25 Jun 2012 16:29:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/12] saa7164: Use i2c_rc properly to store i2c register
 status
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-06-2012 16:23, Ezequiel Garcia escreveu:
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   drivers/media/video/saa7164/saa7164-i2c.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
> index 26148f7..536f7dc 100644
> --- a/drivers/media/video/saa7164/saa7164-i2c.c
> +++ b/drivers/media/video/saa7164/saa7164-i2c.c
> @@ -123,7 +123,7 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
>   	bus->i2c_algo.data = bus;
>   	bus->i2c_adap.algo_data = bus;
>   	i2c_set_adapdata(&bus->i2c_adap, bus);
> -	i2c_add_adapter(&bus->i2c_adap);
> +	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
>   
>   	bus->i2c_client.adapter = &bus->i2c_adap;
>   
> 

-ENODESCRIPTION.

What are you intending with this change? AFAICT, i2c_add_bus_adapter()
returns 0 on success and a negative value otherwise. Why should it be
stored at bus->i2c_rc?

The same applies to the entire patch series.

Regards,
Mauro
