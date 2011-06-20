Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47852 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab1FTVRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:17:03 -0400
Received: by gxk21 with SMTP id 21so481258gxk.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 14:17:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFFB75A.8050808@iki.fi>
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
	<4DF49E2A.9030804@iki.fi>
	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>
	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>
	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>
	<BANLkTikDCbQUwW_mAdMHAxQGE0AGp+1ebQ@mail.gmail.com>
	<4DFFB75A.8050808@iki.fi>
Date: Mon, 20 Jun 2011 23:17:02 +0200
Message-ID: <BANLkTi=Z6_aaB0ETQEETm=bbPmy2gZ+d8Q@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Markus Rechberger <mrechberger@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Rune Evjen <rune.evjen@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 20, 2011 at 11:10 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 06/21/2011 12:04 AM, Markus Rechberger wrote:
>>
>> On Mon, Jun 20, 2011 at 10:55 PM, Rune Evjen<rune.evjen@gmail.com>  wrote:
>>>
>>> 2011/6/20 Markus Rechberger<mrechberger@gmail.com>:
>>>>
>>>> to tell the difference the amplifier is for DVB-T2, DVB-C is disabled
>>>> in windows because it's not reliable.
>>>> Technically the chip supports it but the LNA decreases the quality.
>>>> There are already some other PCI boards
>>>> out there with that chip which do not use that LNA which should have a
>>>> better performance with that Sony chip.
>>>
>>> Is it possible to work around this by disabling the lna or is the
>>> quality decreased permanently as part of the hardware design,
>>> independently of whether the lna is enabled or not ?
>>>
>>> I searched the linux-media list and it seems that an lna option was
>>> discussed as a module parameter, but modinfo for the module I use [1]
>>> (using the media_build git repository) doesn't show a lna parameter.
>>> Can the lna be disabled in another way ?
>>>
>>
>> no, otherwise it would be sold as full hybrid device. DVB-T2 is weak
>> that's why it was added.
>> Failing DVB-C would increase the device return rate, that's why it is
>> sold as DVB-T2 only.
>
> How the others have resolved that problem? Is that signal strength only
> issue when TDA18271 tuner is used?
>

USB is expected to be mobile, so sensitivity is a more important
issue. The T2 tuner
in question is designed to be a little bit mobile (you can use it with
your notebook without moving at least).
If you use a PC card you can play around with the antenna and won't
move it all the time.
The sensitivity optimization is quite clear why it's there for T2. C
is clearly not the focus of that design.
We already switched away from the tda18271 for our current (and
especially upcoming) designs as well.

Markus
