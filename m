Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55245 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZEWNs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 09:48:27 -0400
Received: by bwz22 with SMTP id 22so2150071bwz.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 06:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905231436.58072.gernot@pansy.at>
References: <200905230810.39344.jarhuba2@poczta.onet.pl>
	 <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
	 <200905231436.58072.gernot@pansy.at>
Date: Sat, 23 May 2009 17:48:27 +0400
Message-ID: <1a297b360905230648v7ef5e77bn88539e047f937749@mail.gmail.com>
Subject: Re: Question about driver for Mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: Gernot Pansy <gernot@pansy.at>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/5/23 Gernot Pansy <gernot@pansy.at>:
> hy,
>
> On Saturday 23 May 2009 08:41:48 Manu Abraham wrote:
>> On Sat, May 23, 2009 at 10:10 AM, Jaros³aw Huba <jarhuba2@poczta.onet.pl>
> wrote:
>> > Hi.
>> > Is driver for Mantis chipset are currently developed somewhere?
>> > I'm owner of Azurewave AD SP400 CI (VP-1041) and I'm waiting for support
>> > for this card for quite long time. Even partly working driver in mainline
>> > kernel would be great (without remote, CI, S2 support, with some tuning
>> > bugs). This question is mainly for Manu Abraham who developed this driver
>> > some time ago.
>>
>> The latest development snapshot for the mantis based devices can be found
>> here: http://jusst.de/hg/mantis-v4l
>>
>> Currently CI is unsupported, though very preliminary code support for
>> it exists in it.
>> S2 works, pretty much. Or do you have other results ?
>
> will CI be supported and are you willing to finish development and merge it to
> mainline anytime?


The CI code is out there in it itself commented out, but is a bit
unstable. I haven't
spent too much time on it these last 2 months, due to lack of time


> i think i was one of the first SP400 owner but i had to sold my card for a Nova
> HD2 because the driver was not reliable (some i2c errors, slow tunning,
> sometimes tunning failed). And now i need a dvb-s2 card with ci working. so
> i'm searching again for a new card. their seems to be only the tt-3200 out,
> which seems to work - no newer card.


The issue with the I2C errors have been fixed in the
jusst.de/hg/mantis-v4l tree.
It had been a bit hard to fix, but i am almost certain, that issue is
gone for good.

There were quite a lot of fixes to the stb0899 module, so maybe some of the
issues what you looked at might've been fixed.

Regards,
Manu
