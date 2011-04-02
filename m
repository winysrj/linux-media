Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50157 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1DBBYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 21:24:40 -0400
Received: by pvg12 with SMTP id 12so790149pvg.19
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2011 18:24:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D837E4E.7010105@iki.fi>
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
Date: Sat, 2 Apr 2011 02:24:40 +0100
Message-ID: <AANLkTi=Dz-cQ6bUUw7FG=z-6OKSt0a=ytvcimnOXqaMK@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/18 Antti Palosaari <crope@iki.fi>:
> On 03/08/2011 12:12 AM, adq wrote:
>>
>> Ah well, so its definitely /not/ conflicting i2c writes that cause the
>> tuner problem as it has finally just died. The festats for a "crashed"
>> tuner are:
>>   Sig: 50933  SNR: 50  BER: 0  UBLK: 5370554  Stat: 0x01 [SIG ]
>> (no other error messages)
>>
>> For the other tuner, it  is:
>>   Sig: 55703  SNR: 120  BER: 0  UBLK: 919  Stat: 0x1f [SIG CARR VIT SYNC
>> LOCK ]
>>
>> Note the /massive/ difference in ubclocks; the tuner that died always
>> had a massively larger UCBLOCKS count even when it was working fine.
>>
>> Antii, I'll try out your GPIO suggestions today or tomorrow, and I'll
>> try and snag an i2c register dump to see if that sheds any light...
>
> Any new findings?

Hi, just been trying it out, with no success. On my test machine, FE0
no longer tunes, but FE1 is still fine, so I've just been testing FE0.

I've tried your suggestions, mainly concentrating on the af9013's
GPIOs, but I also tried your power management suggestion.

Since I was just using FE0, I've just been setting all the GPIOs at
the start of af9013.c's set_frontend() implementation; I've tried
turning them all off, all on, on->mdelay->off, and also
off->mdelay->on. Nothing works.
