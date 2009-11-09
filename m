Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:65166 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKIDEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 22:04:08 -0500
Received: by fxm21 with SMTP id 21so12823fxm.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 19:04:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20035.64.213.30.2.1257735258.squirrel@webmail.exetel.com.au>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	 <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	 <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	 <20035.64.213.30.2.1257735258.squirrel@webmail.exetel.com.au>
Date: Sun, 8 Nov 2009 22:04:10 -0500
Message-ID: <829197380911081904o4d4d0789u6e6b2e721074f003@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: Barry Williams <bazzawill@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 9:54 PM, Robert Lowery <rglowery@exemail.com.au> wrote:
>> On Mon, Nov 9, 2009 at 12:22 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>> On Sun, Nov 8, 2009 at 8:43 PM, Barry Williams <bazzawill@gmail.com>
>>> wrote:
>>>> Hi Devin
>>>> I tried your tree and I seem to get the same problem on one box I get
>>>> the flood of 'dvb-usb: bulk message failed: -110 (1/0'.
>>> <snip>
>>>
>>> Can you please confirm the USB ID of the board you are having the
>>> problem with (by running "lsusb" from a terminal window)?
>>>
>>> Thanks,
>>>
>>> Devin
>>> --
>>
>>
>> On the first box I have
>> Bus 003 Device 003: ID 0fe9:db98 DVICO
>> Bus 003 Device 002: ID 0fe9:db98 DVICO
>>
>> on the second
>> Bus 001 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>> Bus 001 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Barry,
>
> I have the Dual Digital 4 rev1 card which corresponds to the 0fe9:db78
> card.  0fe9:db98 is the Dual Digital 4 rev2 card which I believe uses
> completely different hardware and it's behavior is unchanged by my patch
> which only targets the rev1 card.
>
> I suspect the problems you are still reporting are from the different
> cards, completely unrelated to my fix.
>
> Would you be able to retest after removing the rev2 cards from the machine?
>
> -Rob

Robert,

It's worth noting that the introduction of the i2c gate stuff in the
zl10353 broke essentially *all* cards that use that demod except for
the one that prompted the change.  I've been incrementally going
through the cards and fixing it as people report it.

Since both of his cards use the zl10353, it wouldn't surprise me that
his other board is broken for the same reason (which would require an
additional patch).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
