Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:64485 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1DBNqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 09:46:00 -0400
Received: by pxi2 with SMTP id 2so1197206pxi.10
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 06:45:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9713FE.7050001@iki.fi>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
	<4D716ECA.4060900@iki.fi>
	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>
	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
	<AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>
	<AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>
	<AANLkTimUAKjx81Z1GF=ceG33zHhLX1r-HfykWWyNpay-@mail.gmail.com>
	<AANLkTinZVRjZEHDhi1Q0d4jfyTk5E7HhBP2U08ymW=BG@mail.gmail.com>
	<4D837E4E.7010105@iki.fi>
	<AANLkTi=Dz-cQ6bUUw7FG=z-6OKSt0a=ytvcimnOXqaMK@mail.gmail.com>
	<4D96DC3A.8040005@iki.fi>
	<BANLkTi=Uq=bLgNo6uNHTast4DRM+ZVLF0g@mail.gmail.com>
	<4D9713FE.7050001@iki.fi>
Date: Sat, 2 Apr 2011 14:45:59 +0100
Message-ID: <BANLkTimW8B=Q=SvsJLsMf-YRJYH-e99zbA@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/4/2 Antti Palosaari <crope@iki.fi>:
> On 04/02/2011 02:06 PM, adq wrote:
>>
>> 2011/4/2 Antti Palosaari<crope@iki.fi>:
>>>
>>> On 04/02/2011 04:24 AM, adq wrote:
>>>>
>>>> Hi, just been trying it out, with no success. On my test machine, FE0
>>>> no longer tunes, but FE1 is still fine, so I've just been testing FE0.
>>>
>>> You try to say other frontend / tuner is physically dead? Which one?
>>
>> No no - I can revive it by simply unplugging and replugging the
>> device, but I was avoiding doing that to see if we could either track
>> down something erroneous, or be able to reset it from software.
>>
>> It'd be /really/ handy if they'd connected that reset tuner GPIO :(
>> There isn't a way to completely reset the device from software I take
>> it? Or any other GPIOs hanging about I could test with?
>
> There is few I know, USB command 0x13 boots AF9015 somehow, USB command 0x5a
> reconnects it from USB bus. But most interesting one is demodulator reset
> register 0xe205, write 1 to that reg should reset it.

Just tried writing 1 to 0xe205 - no change.

Looks like USB commands 0x13/0x5a will be done as part of a normal
module reload? (In which case it doesn't fix it).

I can actually reboot the machine completely, and the problem stays!
Only physically unplugging the device sorts it.
