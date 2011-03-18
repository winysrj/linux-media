Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:46191 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1CRPq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2011 11:46:26 -0400
Message-ID: <4D837E4E.7010105@iki.fi>
Date: Fri, 18 Mar 2011 17:46:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: adq <adq@lidskialf.net>
CC: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>	<AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>	<AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>	<AANLkTimUAKjx81Z1GF=ceG33zHhLX1r-HfykWWyNpay-@mail.gmail.com> <AANLkTinZVRjZEHDhi1Q0d4jfyTk5E7HhBP2U08ymW=BG@mail.gmail.com>
In-Reply-To: <AANLkTinZVRjZEHDhi1Q0d4jfyTk5E7HhBP2U08ymW=BG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/08/2011 12:12 AM, adq wrote:
> Ah well, so its definitely /not/ conflicting i2c writes that cause the
> tuner problem as it has finally just died. The festats for a "crashed"
> tuner are:
>    Sig: 50933  SNR: 50  BER: 0  UBLK: 5370554  Stat: 0x01 [SIG ]
> (no other error messages)
>
> For the other tuner, it  is:
>    Sig: 55703  SNR: 120  BER: 0  UBLK: 919  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
>
> Note the /massive/ difference in ubclocks; the tuner that died always
> had a massively larger UCBLOCKS count even when it was working fine.
>
> Antii, I'll try out your GPIO suggestions today or tomorrow, and I'll
> try and snag an i2c register dump to see if that sheds any light...

Any new findings?

Antti

-- 
http://palosaari.fi/
