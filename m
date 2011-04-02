Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:53992 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1DBMSJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 08:18:09 -0400
Message-ID: <4D9713FE.7050001@iki.fi>
Date: Sat, 02 Apr 2011 15:18:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: adq <adq@lidskialf.net>
CC: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>	<AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>	<AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>	<AANLkTimUAKjx81Z1GF=ceG33zHhLX1r-HfykWWyNpay-@mail.gmail.com>	<AANLkTinZVRjZEHDhi1Q0d4jfyTk5E7HhBP2U08ymW=BG@mail.gmail.com>	<4D837E4E.7010105@iki.fi>	<AANLkTi=Dz-cQ6bUUw7FG=z-6OKSt0a=ytvcimnOXqaMK@mail.gmail.com>	<4D96DC3A.8040005@iki.fi> <BANLkTi=Uq=bLgNo6uNHTast4DRM+ZVLF0g@mail.gmail.com>
In-Reply-To: <BANLkTi=Uq=bLgNo6uNHTast4DRM+ZVLF0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/02/2011 02:06 PM, adq wrote:
> 2011/4/2 Antti Palosaari<crope@iki.fi>:
>> On 04/02/2011 04:24 AM, adq wrote:
>>>
>>> Hi, just been trying it out, with no success. On my test machine, FE0
>>> no longer tunes, but FE1 is still fine, so I've just been testing FE0.
>>
>> You try to say other frontend / tuner is physically dead? Which one?
>
> No no - I can revive it by simply unplugging and replugging the
> device, but I was avoiding doing that to see if we could either track
> down something erroneous, or be able to reset it from software.
>
> It'd be /really/ handy if they'd connected that reset tuner GPIO :(
> There isn't a way to completely reset the device from software I take
> it? Or any other GPIOs hanging about I could test with?

There is few I know, USB command 0x13 boots AF9015 somehow, USB command 
0x5a reconnects it from USB bus. But most interesting one is demodulator 
reset register 0xe205, write 1 to that reg should reset it.

> I have an MXL5005R tuner apparently - id 30 - BTW.

I suspect it is demod which hangs since I have feeling it happens every 
tuner used.

>>> I've tried your suggestions, mainly concentrating on the af9013's
>>> GPIOs, but I also tried your power management suggestion.
>>>
>>> Since I was just using FE0, I've just been setting all the GPIOs at
>>> the start of af9013.c's set_frontend() implementation; I've tried
>>> turning them all off, all on, on->mdelay->off, and also
>>> off->mdelay->on. Nothing works.
>>
>> So GPIOs are blocked out.
>>
>> I wonder if someone can ran similar many day tuning stress test using
>> Windows drivers to see if that happen.
>
> Might be hard to script under windows I suppose...

I am not aware any good commandline BDA tuning app for Windows. Only one 
I know is ScanChannelsBDA.exe which is rather buggy - but works.

Antti
-- 
http://palosaari.fi/
