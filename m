Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50896 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1FTVUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:20:35 -0400
Received: by qyk29 with SMTP id 29so1736678qyk.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 14:20:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFFB56B.3000802@iki.fi>
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
	<4DF49E2A.9030804@iki.fi>
	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>
	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>
	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
	<4DFFB56B.3000802@iki.fi>
Date: Mon, 20 Jun 2011 23:20:34 +0200
Message-ID: <BANLkTikYWVU814UWNAZFTTC9dX43Ydy4sA@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Rune Evjen <rune.evjen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Antti Palosaari <crope@iki.fi>:
> On 06/20/2011 11:55 PM, Rune Evjen wrote:
>>
>> 2011/6/20 Markus Rechberger<mrechberger@gmail.com>:
>>>
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
>
> LNA is controlled by demod GPIO line. I don't remember if it is on or off
> for DVB-C currently. Look em28xx-dvb.c file, you can disable or enable it
> from there (needs re-compiling driver).
>
> I also saw BER counter running some muxes during development, but I think
> all channels I have are still working. And I didn't even have time to
> optimal parameters for tuner / demod. I will try to examine those later...
>
Thank you Antti,

I will test with lna disabled in the em28xx-dvb module

In line 349 of the code, I see this:
        /* enable LNA for DVB-T2 and DVB-C */
	.gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
	.gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,

I suspect I should modify line 351, what should it be changed to ?

Best regards,

Rune
