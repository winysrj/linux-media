Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:53442 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZKICyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 21:54:17 -0500
Message-ID: <20035.64.213.30.2.1257735258.squirrel@webmail.exetel.com.au>
In-Reply-To: <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
    <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
    <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
Date: Mon, 9 Nov 2009 13:54:18 +1100 (EST)
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Barry Williams" <bazzawill@gmail.com>
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Mon, Nov 9, 2009 at 12:22 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Sun, Nov 8, 2009 at 8:43 PM, Barry Williams <bazzawill@gmail.com>
>> wrote:
>>> Hi Devin
>>> I tried your tree and I seem to get the same problem on one box I get
>>> the flood of 'dvb-usb: bulk message failed: -110 (1/0'.
>> <snip>
>>
>> Can you please confirm the USB ID of the board you are having the
>> problem with (by running "lsusb" from a terminal window)?
>>
>> Thanks,
>>
>> Devin
>> --
>
>
> On the first box I have
> Bus 003 Device 003: ID 0fe9:db98 DVICO
> Bus 003 Device 002: ID 0fe9:db98 DVICO
>
> on the second
> Bus 001 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> Bus 001 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Barry,

I have the Dual Digital 4 rev1 card which corresponds to the 0fe9:db78
card.  0fe9:db98 is the Dual Digital 4 rev2 card which I believe uses
completely different hardware and it's behavior is unchanged by my patch
which only targets the rev1 card.

I suspect the problems you are still reporting are from the different
cards, completely unrelated to my fix.

Would you be able to retest after removing the rev2 cards from the machine?

-Rob


