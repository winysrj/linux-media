Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab1JFVsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 17:48:15 -0400
Received: by wyg34 with SMTP id 34so3299471wyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 14:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <kQmOmyBaqgjOFweZ@echelon.upsilon.org.uk>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
	<kQmOmyBaqgjOFweZ@echelon.upsilon.org.uk>
Date: Thu, 6 Oct 2011 23:48:14 +0200
Message-ID: <CAL9G6WXb9zkgu++__LzW4nBBoAQYBvWWNCJkm_nRqiJEg+VE1A@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Josu Lazkano <josu.lazkano@gmail.com>
To: dave cunningham <ml@upsilon.org.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/10/6 dave cunningham <ml@upsilon.org.uk>:
> In message
> <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>, Josu
> Lazkano wrote
>
> <snip>
>>
>> I get this I2C messages:
>>
>> # tail -f /var/log/messages
>> Oct  5 20:16:44 htpc kernel: [  534.168957] af9013: I2C read failed
>> reg:d330
>> Oct  5 20:16:49 htpc kernel: [  538.626152] af9013: I2C read failed
>> reg:d330
>> Oct  5 21:22:15 htpc kernel: [ 4464.930734] af9013: I2C write failed
>> reg:d2e2 len:1
>> Oct  5 21:40:46 htpc kernel: [ 5576.241897] af9013: I2C read failed
>> reg:d2e6
>> Oct  5 23:07:33 htpc kernel: [10782.852522] af9013: I2C read failed
>> reg:d2e6
>> Oct  5 23:20:11 htpc kernel: [11540.824515] af9013: I2C read failed
>> reg:d07c
>> Oct  6 00:11:41 htpc kernel: [14631.122384] af9013: I2C read failed
>> reg:d2e6
>> Oct  6 00:26:13 htpc kernel: [15502.900549] af9013: I2C read failed
>> reg:d2e6
>> Oct  6 00:39:58 htpc kernel: [16328.273015] af9013: I2C read failed
>> reg:d330
>>
>
> I have two af9013 sticks in my mythtv backend. One is a KWorld 399U, the
> other a single tuner Tevion stick.
>
> When I originally setup this system I had major problems with these sticks
> and also a pair of Freecom WT-220U (which worked perfectly in an older
> system - I've since disposed of these).
>
> I was seeing I2C read fails similar to the above.
>
> The system in question has an AMD760G southbridge.
>
> After a lot of googling I came across a post somewhere which said that the
> USB host controller on the 760G is problematic and suggested getting a NEC
> or VIA hub and using this between the DVB sticks and the root hub.
>
> I bought a cheap hub with an NEC chip on and since then (6 months maybe)
> I've had no problems with the system. Having said this I probably don't use
> all three frontends that often (I also have a DVB-S card and this takes
> precedence) though I certainly have on occasion and don't recall any
> problems.
>
> --
> Dave Cunningham                                  PGP KEY ID: 0xA78636DC
>

Thanks Dave, I have a MCP79 nvidia USB controller:

$ lspci | grep USB
00:04.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:04.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0
Controller (rev b1)
00:06.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:06.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0
Controller (rev b1)

When I add a USB hub it can not boot, the system stop on boot. I can
not change the system board. Need I some extra configuration on BIOS?
I will appreciate any help, I have no experience on system
performance.

Thanks for all your help.

Regards.

-- 
Josu Lazkano
