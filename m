Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab0CERwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 12:52:47 -0500
Message-ID: <4B9144E6.5000109@redhat.com>
Date: Fri, 05 Mar 2010 14:52:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: tm6000 and Hauppauge HVR-900H
References: <4B913F2E.1080703@arcor.de>
In-Reply-To: <4B913F2E.1080703@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan,

Stefan Ringel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Hi Mauro, Devin,
> 
> I study the tm6000 source and I have any questions.
> 
> 1. I tested my stick (terratec cinery hybrid) with the windows driver
> from the Hauppauge HVR-900H and it's work. So I think that have the
> same driver setting. 

It is very likely that the original driver has some code to probe the devices
and to read certain configurations at the board's eeprom. At least on the USB
sniffs I've saw, some probing is noticed, and several eeprom addresses are
read. So, the fact that both devices work with the same driver doesn't mean that
both use the same GPIO's.

> In the board struct is setting tuner reset gpio
> with label TM6000_GPIO_2, but is that not a tm6010? Then it must set
> to TM6010_GPIO_2. And can I add  the setting from terratec cinery
> hybrid for the Hauppauge HVR-900H?

It should be noticed that all GPIO addresses that exists for tm6000 also
exists for tm6010, but with different names:

#define TM6000_GPIO_1           0x102
#define TM6000_GPIO_2           0x103
#define TM6000_GPIO_3           0x104
#define TM6000_GPIO_4           0x300
#define TM6000_GPIO_5           0x301
#define TM6000_GPIO_6           0x304
#define TM6000_GPIO_7           0x305

#define TM6010_GPIO_0      0x0102
#define TM6010_GPIO_1      0x0103
#define TM6010_GPIO_2      0x0104
#define TM6010_GPIO_3      0x0105
#define TM6010_GPIO_4      0x0106
#define TM6010_GPIO_5      0x0107
#define TM6010_GPIO_6      0x0300
#define TM6010_GPIO_7      0x0301
#define TM6010_GPIO_9      0x0305

So, maybe there are some issues there.

AFAIK, this device uses those addresses:

	GPIO_1 MT352_Reset
	GPIO_2 XC3028 Tuner_Reset
	GPIO_4 MT352_Sleep 

Anyway, the better is to double-check those addresses, trying the driver
with both TM6000 and TM6010 addresses to be sure.

> 2. In the board struct have not all a tuner reset gpio.
> 3. Is it better when we implemented the firmware value in the board
> struct?

Sorry, but I didn't understand your questions.

-- 

Cheers,
Mauro
