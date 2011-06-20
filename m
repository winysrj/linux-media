Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:39084 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1FTVCh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:02:37 -0400
Message-ID: <4DFFB56B.3000802@iki.fi>
Date: Tue, 21 Jun 2011 00:02:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rune Evjen <rune.evjen@gmail.com>
CC: linux-media@vger.kernel.org,
	Markus Rechberger <mrechberger@gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>	<4DF49E2A.9030804@iki.fi>	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com> <BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
In-Reply-To: <BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/20/2011 11:55 PM, Rune Evjen wrote:
> 2011/6/20 Markus Rechberger<mrechberger@gmail.com>:
>> to tell the difference the amplifier is for DVB-T2, DVB-C is disabled
>> in windows because it's not reliable.
>> Technically the chip supports it but the LNA decreases the quality.
>> There are already some other PCI boards
>> out there with that chip which do not use that LNA which should have a
>> better performance with that Sony chip.
>
> Is it possible to work around this by disabling the lna or is the
> quality decreased permanently as part of the hardware design,
> independently of whether the lna is enabled or not ?
>
> I searched the linux-media list and it seems that an lna option was
> discussed as a module parameter, but modinfo for the module I use [1]
> (using the media_build git repository) doesn't show a lna parameter.
> Can the lna be disabled in another way ?

LNA is controlled by demod GPIO line. I don't remember if it is on or 
off for DVB-C currently. Look em28xx-dvb.c file, you can disable or 
enable it from there (needs re-compiling driver).

I also saw BER counter running some muxes during development, but I 
think all channels I have are still working. And I didn't even have time 
to optimal parameters for tuner / demod. I will try to examine those 
later...

regards
Antti



-- 
http://palosaari.fi/
