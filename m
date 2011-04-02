Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:37255 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1DBIUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 04:20:16 -0400
Message-ID: <4D96DC3A.8040005@iki.fi>
Date: Sat, 02 Apr 2011 11:20:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: adq <adq@lidskialf.net>
CC: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>	<AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>	<AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>	<AANLkTimUAKjx81Z1GF=ceG33zHhLX1r-HfykWWyNpay-@mail.gmail.com>	<AANLkTinZVRjZEHDhi1Q0d4jfyTk5E7HhBP2U08ymW=BG@mail.gmail.com>	<4D837E4E.7010105@iki.fi> <AANLkTi=Dz-cQ6bUUw7FG=z-6OKSt0a=ytvcimnOXqaMK@mail.gmail.com>
In-Reply-To: <AANLkTi=Dz-cQ6bUUw7FG=z-6OKSt0a=ytvcimnOXqaMK@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/02/2011 04:24 AM, adq wrote:
> Hi, just been trying it out, with no success. On my test machine, FE0
> no longer tunes, but FE1 is still fine, so I've just been testing FE0.

You try to say other frontend / tuner is physically dead? Which one?

> I've tried your suggestions, mainly concentrating on the af9013's
> GPIOs, but I also tried your power management suggestion.
>
> Since I was just using FE0, I've just been setting all the GPIOs at
> the start of af9013.c's set_frontend() implementation; I've tried
> turning them all off, all on, on->mdelay->off, and also
> off->mdelay->on. Nothing works.

So GPIOs are blocked out.

I wonder if someone can ran similar many day tuning stress test using 
Windows drivers to see if that happen.

Antti

-- 
http://palosaari.fi/
