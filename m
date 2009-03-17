Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:51710 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbZCQV73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 17:59:29 -0400
Received: by an-out-0708.google.com with SMTP id d14so209291and.1
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 14:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d6a802e70903171326h741c51bej44bfdb670f09e25@mail.gmail.com>
References: <d6a802e70903161940t2ce9d20aw46360de23d987d29@mail.gmail.com>
	 <1237286227.3296.5.camel@palomino.walls.org>
	 <d6a802e70903171326h741c51bej44bfdb670f09e25@mail.gmail.com>
Date: Tue, 17 Mar 2009 17:59:26 -0400
Message-ID: <d6a802e70903171459gc7512a0t4d06af6f045e23df@mail.gmail.com>
Subject: Re: Strange card
From: Eduardo Kaftanski <ekaftan@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore me... I made it work. Thanks.


On Tue, Mar 17, 2009 at 4:26 PM, Eduardo Kaftanski <ekaftan@gmail.com> wrote:
> Ok card was bad.... I replaced the card and now this is detected:
>
> 01:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
> 01:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>
> BUt it only shows me one /dev/video device. Should;t it be 4?
>
> Thanks (yes, I am a total video newbie)
>
>
> On Tue, Mar 17, 2009 at 6:37 AM, Andy Walls <awalls@radix.net> wrote:
>> On Mon, 2009-03-16 at 22:40 -0400, Eduardo Kaftanski wrote:
>>> I bought today a card that was packaged as a PICO2000-compatible but I
>>> can't get it to work... I read all the archives and wikis I could find
>>> but the only one thread with the same card description but the recipe
>>> won't work for me.
>>>
>>> Here is the lspci... is this card supported?
>>>
>>> 01:0a.0 Multimedia video controller: Brooktree Corporation Unknown
>>> device 016e (    rev 11)
>>
>> That looks wrong - 016e is not valid for a BrookTree device according to
>> the PCI ID database.   A value of 036e would be correct for some Bt878
>> Video Capture devices.
>>
>> Pull out your PCI cards, blow the dust out of all the slots, reseat the
>> cards, and try again.
>>
>> Regards,
>> Andy
>>
>>
>>>         Flags: bus master, fast devsel, latency 32, IRQ 11
>>>         Memory at d9fff000 (32-bit, prefetchable) [size=4K]
>>>         Capabilities: [44] Vital Product Data
>>>         Capabilities: [4c] Power Management version 2
>>>
>>> 01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>>> Capture (rev 11    )
>>>         Flags: bus master, fast devsel, latency 32, IRQ 11
>>>         Memory at d9ffe000 (32-bit, prefetchable) [size=4K]
>>>         Capabilities: [44] Vital Product Data
>>>         Capabilities: [4c] Power Management version 2
>>>
>>>
>>> THanks.
>>>
>>>
>>>
>>
>>
>
>
>
> --
> ---
> Eduardo Kaftanski
> ekaftan@gmail.com
> eduardo@orsus.cl
>



-- 
---
Eduardo Kaftanski
ekaftan@gmail.com
eduardo@orsus.cl
