Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:50036 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1FTVKv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:10:51 -0400
Message-ID: <4DFFB75A.8050808@iki.fi>
Date: Tue, 21 Jun 2011 00:10:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Rune Evjen <rune.evjen@gmail.com>, linux-media@vger.kernel.org
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>	<4DF49E2A.9030804@iki.fi>	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com> <BANLkTikDCbQUwW_mAdMHAxQGE0AGp+1ebQ@mail.gmail.com>
In-Reply-To: <BANLkTikDCbQUwW_mAdMHAxQGE0AGp+1ebQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/21/2011 12:04 AM, Markus Rechberger wrote:
> On Mon, Jun 20, 2011 at 10:55 PM, Rune Evjen<rune.evjen@gmail.com>  wrote:
>> 2011/6/20 Markus Rechberger<mrechberger@gmail.com>:
>>> to tell the difference the amplifier is for DVB-T2, DVB-C is disabled
>>> in windows because it's not reliable.
>>> Technically the chip supports it but the LNA decreases the quality.
>>> There are already some other PCI boards
>>> out there with that chip which do not use that LNA which should have a
>>> better performance with that Sony chip.
>>
>> Is it possible to work around this by disabling the lna or is the
>> quality decreased permanently as part of the hardware design,
>> independently of whether the lna is enabled or not ?
>>
>> I searched the linux-media list and it seems that an lna option was
>> discussed as a module parameter, but modinfo for the module I use [1]
>> (using the media_build git repository) doesn't show a lna parameter.
>> Can the lna be disabled in another way ?
>>
>
> no, otherwise it would be sold as full hybrid device. DVB-T2 is weak
> that's why it was added.
> Failing DVB-C would increase the device return rate, that's why it is
> sold as DVB-T2 only.

How the others have resolved that problem? Is that signal strength only 
issue when TDA18271 tuner is used?


Antti

-- 
http://palosaari.fi/
