Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbFFJKr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 05:10:47 -0400
Message-ID: <5572B915.5080102@iki.fi>
Date: Sat, 06 Jun 2015 12:10:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] saa7164: change Si2168 reglen to 0 bit
References: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 10:44 AM, Olli Salonen wrote:
> The i2c_reg_len for Si2168 should be 0 for correct I2C communication.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

PS. As I mentioned few times already, that kind I2C client register map 
layout information does not belongs to adapter level at all. I wonder 
why it is here. Likely some further clean-ups are possible.

regards
Antti


> ---
>   drivers/media/pci/saa7164/saa7164-cards.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
> index 8a6455d..c2b7382 100644
> --- a/drivers/media/pci/saa7164/saa7164-cards.c
> +++ b/drivers/media/pci/saa7164/saa7164-cards.c
> @@ -621,7 +621,7 @@ struct saa7164_board saa7164_boards[] = {
>   			.name		= "SI2168-1",
>   			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
>   			.i2c_bus_addr	= 0xc8 >> 1,
> -			.i2c_reg_len	= REGLEN_8bit,
> +			.i2c_reg_len	= REGLEN_0bit,
>   		}, {
>   			.id		= 0x25,
>   			.type		= SAA7164_UNIT_TUNER,
> @@ -635,7 +635,7 @@ struct saa7164_board saa7164_boards[] = {
>   			.name		= "SI2168-2",
>   			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
>   			.i2c_bus_addr	= 0xcc >> 1,
> -			.i2c_reg_len	= REGLEN_8bit,
> +			.i2c_reg_len	= REGLEN_0bit,
>   		} },
>   	},
>   };
>

-- 
http://palosaari.fi/
