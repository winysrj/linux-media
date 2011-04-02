Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38730 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1DBLPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 07:15:31 -0400
Received: by pvg12 with SMTP id 12so855087pvg.19
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 04:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Uq=bLgNo6uNHTast4DRM+ZVLF0g@mail.gmail.com>
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
Date: Sat, 2 Apr 2011 12:15:31 +0100
Message-ID: <BANLkTim=qVBd81AwOmZYmFjJGjsTidRPzA@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/4/2 adq <adq@lidskialf.net>:
> 2011/4/2 Antti Palosaari <crope@iki.fi>:
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
>
> I have an MXL5005R tuner apparently - id 30 - BTW.

Forgot to mention - its the tuner attached to the internal af9013
(fe0) that is having the problem. The one attached to the external one
(fe1) is still fine. I don't know if this is always the case though.

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
>
