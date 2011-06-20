Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38280 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1FTVK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:10:58 -0400
Received: by yia27 with SMTP id 27so2257516yia.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 14:10:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFFB56B.3000802@iki.fi>
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
	<4DF49E2A.9030804@iki.fi>
	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>
	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>
	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
	<4DFFB56B.3000802@iki.fi>
Date: Mon, 20 Jun 2011 23:10:57 +0200
Message-ID: <BANLkTinJUg0YA9k=xVmNZ_X8+quDqbYtVg@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Markus Rechberger <mrechberger@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Rune Evjen <rune.evjen@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 20, 2011 at 11:02 PM, Antti Palosaari <crope@iki.fi> wrote:
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

sure things can be optimized forward and backward but unsupported features won't
be better. DVB-C is disabled on purpose, the reason is not that it's
not allowed in
UK with some providers. In Germany some providers don't want
alternative boxes either
but no one can check that anyway.
The LNA is for DVB-T2 not for DVB-C, PCTV sells it like that because
they designed it for that purpose
the rest is out of spec.

Markus
