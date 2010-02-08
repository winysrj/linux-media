Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0BHLXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 06:23:13 -0500
Message-ID: <4B6FF418.3000303@redhat.com>
Date: Mon, 08 Feb 2010 09:23:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 6/12] tm6000: tuner reset timeing optimation
References: <1265411060-12125-6-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265411060-12125-6-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-cards.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index 1167b01..5cf5d58 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -271,11 +271,14 @@ static int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
>  		switch (arg) {
>  		case 0:
>  			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
> +					dev->tuner_reset_gpio, 0x01);
> +			msleep(60);
> +			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
>  					dev->tuner_reset_gpio, 0x00);
> -			msleep(130);
> +			msleep(75);
>  			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
>  					dev->tuner_reset_gpio, 0x01);
> -			msleep(130);
> +			msleep(60);
>  			break;
>  		case 1:
>  			tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
> @@ -288,10 +291,10 @@ static int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
>  						TM6000_GPIO_CLK, 0);
>  			if (rc<0)
>  				return rc;
> -			msleep(100);
> +			msleep(10);
>  			rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
>  						TM6000_GPIO_CLK, 1);
> -			msleep(100);
> +			msleep(10);
>  			break;
>  		}
>  	}

This sequence and the timeouts are board-specific. Please add a switch(dev->model) and
test for your specific board, since your sequence will break for example 10moons, where
you really need a longer delay to work.

-- 

Cheers,
Mauro
