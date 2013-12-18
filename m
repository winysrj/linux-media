Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab3LRGFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 01:05:38 -0500
Message-ID: <52B13B2B.4040401@gentoo.org>
Date: Wed, 18 Dec 2013 07:05:31 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: =?UTF-8?B?U3ZlbiBNw7xsbGVy?= <xpert-reactos@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: Aw: Re:  Re: Card with si2165
References: <trinity-3c856476-f7bf-4d9b-b00d-707bcf956c5b-1387066356197@3capp-gmx-bs46>, <52AE1020.9020908@gentoo.org> <trinity-3abf9a2f-d1ae-4948-b124-7d2aa566b28c-1387182406449@3capp-gmx-bs08>, <52AF6075.7030202@gentoo.org> <trinity-694fffe1-2ff0-46db-9cd8-ec08b156703e-1387230575663@3capp-gmx-bs08>
In-Reply-To: <trinity-694fffe1-2ff0-46db-9cd8-ec08b156703e-1387230575663@3capp-gmx-bs08>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.12.2013 22:49, "Sven Müller" wrote:
> 
> 
>> Gesendet: Montag, 16. Dezember 2013 um 21:20 Uhr
>> Von: "Matthias Schwarzott" <zzam@gentoo.org>
>> An: "Sven Müller" <xpert-reactos@gmx.de>, linux-media@vger.kernel.org
>> Betreff: Re: Aw: Re: Card with si2165
>>
>> On 16.12.2013 09:26, "Sven Müller" wrote:
>>>
>>> I have a Hauppauge WINTV HVR 5500-HD.
>>>
>>
>> Hi
>>
>> I think first you should check if this is exactly the same card as you
>> have: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-5500
>>
> 
> It's the same card.

So could you please check if the information is up to date.

* Add missing components, e.g. si2165
* What about the tuner for DVB-C/T - it could be a tda18271 - can you
verify this?
* Maybe add a picture if you can take one.
* Add dmesg of the cx23885 driver if it at least tries to do stuff with
the card.
* You can pass cx23885 the parameter i2c_scan, but I think it will not
differ from your i2cdetect calls.

> i2c-9	i2c       	cx23885[0]                      	I2C adapter
> i2c-10	i2c       	cx23885[0]                      	I2C adapter
> i2c-11	i2c       	cx23885[0]                      	I2C adapter
> 
>From cx23885 sources I guess bus 9 and 10 are the external buses:

> # i2cdetect -y 9
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- 05 -- -- -- -- -- 0b -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                         
> # i2cdetect -y 10
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 
> 60: 60 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                         
Here could be a tuner at 0x60.

> # i2cdetect -y 11
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- 44 -- -- -- -- -- -- -- 4c -- -- -- 
> 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --            
> 
Compare to cx23885-i2c.c:
At 0x44 is the internal cx25837
At 0x4c is the flatiron

To detect more you need the correct GPIO configuration I think, so that
all components are out of reset state.

If dmesg also shows the tda18271, most likely this is also used for DVB-C/T.
Now you need to find out how to set the GPIOs so that you can talk to
si2165 via i2c.

And second, how this type of cards handle the multiple frontend stuff.

I wonder if the subdevice id of your card is really identical to
HVR4400, if yes, the eeprom is necessary to detect the exact used
components.

Regards
Matthias

