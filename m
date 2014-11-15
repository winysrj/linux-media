Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59760 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaKOLCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 06:02:23 -0500
Message-ID: <546732BA.8010008@iki.fi>
Date: Sat, 15 Nov 2014 13:02:18 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, CrazyCat <crazycat69@narod.ru>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
References: <1918522.5V5b9CGsli@computer>	<5466A606.8030805@iki.fi>	<525911416014537@web7h.yandex.ru> <CAAZRmGw=uLyS+enctwq0To8Gc1dAeG6EZgE+t0v80gBEXg=H5A@mail.gmail.com>
In-Reply-To: <CAAZRmGw=uLyS+enctwq0To8Gc1dAeG6EZgE+t0v80gBEXg=H5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2014 12:41 PM, Olli Salonen wrote:
> What about defining the firmware for Si2148-A20, but since the file is
> the same as Si2158-A20 just point to the same file?
>
> #define SI2148_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
>
> Then if Si2158-A20 would in the future get a new firmware that would
> not work with Si2148, this would not break Si2148.

Assuming you rename possible new firmware:
dvb-tuner-si2158-a20-01.fw
dvb-tuner-si2158-a20-02.fw ?

Basically, you would not like to rename firmware when it is updated if 
it is compatible with the driver. Lets say firmware gets bug fixes, just 
introduce new firmware with same name. If driver changes are needed, 
then you have to rename it. These firmware changes are always 
problematic as you have to think possible regression - it is regression 
from the user point of view if kernel driver updates but it does not 
work as firmware incompatibility.

How about Si2146 firmware you are working?

All-in-all, with the current situation and knowledge I have, I see it is 
better to define new firmware name for that chip model and revision like 
the others. Just to make life it easier in a case Si2148-A20 and 
Si2158-A20 firmwares will be different on some case on some day. So lets 
implement it that way or explain some possible problem we could meet 
when defining own firmware file name.

> Another point that came to my mind is that we start to have quite a
> list of chips there in the printouts (Si2147/Si2148/Si2157/Si2158) and
> more is coming - I'm working with an Si2146 device currently. Should
> we just say "Si214x/Si215x" there or something?

I have no opinion.

regards
Antti

>
> Cheers,
> -olli
>
> On 15 November 2014 03:22, CrazyCat <crazycat69@narod.ru> wrote:
>> 2148 is 2158 without analog support. Same firmware.
>>
>> 15.11.2014, 03:02, "Antti Palosaari" <crope@iki.fi>:
>>> I wonder if we should define own firmware for Si2148-A20 just for sure.
>>> Olli?

-- 
http://palosaari.fi/
