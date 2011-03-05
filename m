Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:47012 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1CEJ4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2011 04:56:33 -0500
Message-ID: <4D7208CF.6020505@iki.fi>
Date: Sat, 05 Mar 2011 11:56:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: adq <adq@lidskialf.net>
CC: linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com> <AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>
In-Reply-To: <AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/05/2011 03:51 AM, adq wrote:
>> As you say though. its just the tuners, so adding the locking into the
>> gate ctrl as you suggested makes perfect sense. Attached is v3
>> implementing this; it seems to be working fine here.
>>
>
> Unfortunately even with this fix, I'm still seeing the problem I was
> trying to fix to begin with.
>
> Although I no longer get any i2c errors (or *any* reported errors),
> after a bit, one of the frontends just.. stops working. All attempts
> to tune it fail. I can even unload and reload the driver module, and
> its stuck in the same state, indicating its a problem with the
> hardware. :(

How easily you can re-produce this? Does it work using your first patch?

Could try some changes for GPIOs, LEDs are not important but tuner 
GPIOs? Here is instructions how GPIOs should be done:

FE0 START
FE0 READ EEPROM
FE0 GPIO RESET and ENABLE FE1?
// set_gpio(0, 3);
// msleep(40)
// set_gpio(0, 7);
FE0 DOWNLOAD FW
FE0 enable POWER LED ???
// wr_reg(0xd734,  upper nibble 3)

FE1 set power management (0xd731)

FE0 tuner OFF
// set_gpio(3, 7);
FE0 LOCK LED OFF

FE1 tuner OFF
// set_gpio(0, 7);
FE1 LOCK LED OFF
*** DEVICE is NOW IN SLEEP ***

*** TUNE REQ for FE1 **
FE1 tuner ON
// set_gpio(0, b);
FE1 LOCK LED ON
*** now streaming **
FE1 tuner OFF
// set_gpio(0, 7);
FE1 LOCK LED OFF
*** DEVICE is NOW IN SLEEP ***

*** TUNE REQ for FE0 **
FE0 tuner ON
// set_gpio(3, b);
FE0 LOCK LED ON
*** now streaming **
FE0 tuner OFF
// set_gpio(3, 7);
FE0 LOCK LED OFF
*** DEVICE is NOW IN SLEEP ***

Also configure some power management for FE1, write register 0xd731 
value 0x47. Do that in af9013_init() before OFSM init (since it changes 
some bits in same register).

And this is list of used GPIOs, it is my latest understanding. I have 
ensured many of those by just testing.

AF9015 GPIO0 AF9013 reset
AF9015 GPIO1 NC (note: on MC44S803 device tuner reset)
AF9015 GPIO2 NC
AF9015 GPIO3 TUNER
AF9015 GPIO_LOCK1 LOCK LED
AF9015 GPIO_LOCK2 POWER LED (not sure, I don't have any device having 
power LED, but it looks like it could be)

AF9013 GPIO0 TUNER
AF9013 GPIO1 NC
AF9013 GPIO2 LOCK LED
AF9013 GPIO3 HW power down?
AF9013 GPIO_LOCK1 LOCK LED
AF9013 GPIO_LOCK2 NC

-- 
http://palosaari.fi/
