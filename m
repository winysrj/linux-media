Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0BBUas (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 15:30:48 -0500
Message-ID: <4B688B6F.2060704@redhat.com>
Date: Tue, 02 Feb 2010 18:30:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] -  tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B6888C9.40400@arcor.de>
In-Reply-To: <4B6888C9.40400@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 02.02.2010 21:03, schrieb Mauro Carvalho Chehab:
>>>> Those tuner callback initializations are board-specific. So, it is better to test
>>>> for your board model, if you need something different than what's currently done.
>>>>
>>>>   
>>>>       
>>> This tuner reset works with my stick, but I think that can test with
>>> other tm6000 based sticks and if it not works then I can say this as a
>>> board-specific.
>>>     
>> It won't work on my boards. The GPIO pin used by each board is different.
>>
>>   
> Have you the right gpio pin in the card struct. I have the
> ".gpio_addr_tun_reset" the correct gpio pin
> 
>    [TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
> +        .name         = "Terratec Cinergy Hybrid XE",
> +        .tuner_type   = TUNER_XC2028, /* has a XC3028 */
> +        .tuner_addr   = 0xc2 >> 1,
> +        .demod_addr   = 0x1e >> 1,
> +        .type         = TM6010,
> +        .caps = {
> +            .has_tuner    = 1,
> +            .has_dvb      = 1,
> +            .has_zl10353  = 1,
> +            .has_eeprom   = 1,
> +            .has_remote   = 1,
> +        },
> +        .gpio_addr_tun_reset = TM6010_GPIO_2, /* here */
> +    }
>  };
>  

Ok, this works :) All needed pins should be customized there, either individually
or via an struct similar to the one done at em28xx driver. Both ways have advantages
and disadvantages.


-- 

Cheers,
Mauro
