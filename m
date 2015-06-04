Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38022 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbFDM5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 08:57:46 -0400
Received: by igblz2 with SMTP id lz2so38388295igb.1
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 05:57:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557048EF.3040703@iki.fi>
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
	<557048EF.3040703@iki.fi>
Date: Thu, 4 Jun 2015 14:57:45 +0200
Message-ID: <CAAZRmGw7NcDo8YJtYN5gC6DM23jtgqmGhhJUAa6VaEovX+qNdA@mail.gmail.com>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll test it with my old code I should have hanging around still
somewhere. I'm sure the chip on my card has been previously been
identified as Si2168-B40 by the code (I posted the logs already
earlier) and it definitely has not turned into a Si2168-D40 chip
somehow.

I don't think there's version D here. The third byte in the answer
from the demod indicates which Si21xx chip is being used. For Si2168
there should be decimal value 68, for Si2157 there's value 57, etc.
This how every single Silabs chip I've seen so far indicates it. I
think it is just the fact that the ASCII value of letter D is 68 that
caused you to assume that there's revision D now.

In addition there's the firmware version numbering that Antti points
out. I do have Si2168 devices that have the A20, A30 and B40
firmwares. Also, for all these chips I can find some references in the
internet. There's nothing regarding a Si2168-D40 (which is not a
conclusive proof that one would not exist, of course).

Cheers,
-olli


On 4 June 2015 at 14:47, Antti Palosaari <crope@iki.fi> wrote:
> On 06/04/2015 03:38 PM, Steven Toth wrote:
>>
>> We're seeing a mix of SI2168 demodulators appearing on HVR2205 and
>> HVR2215 cards, the chips are stamped with different build dates,
>> verified on my cards.
>>
>> The si2168 driver detects some cards fine, others not at all. I can
>> reproduce the working and non-working case. The fix, if we detect a
>> newer card (D40) load the B firmware.
>>
>> This fix works well for me and properly enables DVB-T tuning behavior
>> using tzap.
>>
>> Thanks to Peter Faulkner-Ball for describing his workaround.
>
>
> hymm, I am not sure that patch at all. It is Olli who has been responsible
> adding support for multiple chip revisions, so I will leave that for Olli. I
> have only 2 Si2168 devices and both are B40 version.
>
> Anyhow, for me it looks like firmware major version is always increased when
> new major revision of chip is made. Due to that I expected 5.0 after B
> version 5.0.
> A 1.0
> A 2.0
> A 3.0
> B 4.0
> C 5.0 ?
> D 6.0 ?
>
>
> And how we could explain situation Olli has device that had been working
> earlier, but now it does not? Could you Olli look back you old git tree and
> test if it still works? One possible reason could be also PCIe interface I2C
> adapter bug. Or timing issue.
>
>
> regards
> Antti
>
>
> --
> http://palosaari.fi/
