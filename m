Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53009 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2BGQBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 11:01:48 -0500
Received: by eaah12 with SMTP id h12so2872660eaa.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 08:01:47 -0800 (PST)
Message-ID: <4F314AE7.90308@gmail.com>
Date: Tue, 07 Feb 2012 17:01:43 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>	<4F2ADDCB.4060200@gmail.com>	<CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>	<4F2B16DF.3040400@gmail.com>	<CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>	<4F310091.80107@gmail.com> <CAGoCfiwXj58Men1Yi3OoH7CYAbiB7-KXs9fV8QkEnn3Y8Qe=sw@mail.gmail.com>
In-Reply-To: <CAGoCfiwXj58Men1Yi3OoH7CYAbiB7-KXs9fV8QkEnn3Y8Qe=sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/02/2012 16:18, Devin Heitmueller ha scritto:
> On Tue, Feb 7, 2012 at 5:44 AM, Gianluca Gennari <gennarone@gmail.com> wrote:
>> 1) dvb-usb drivers allocate the URBs when the device is connected, and
>> they are never freed/reallocated until the device is disconnected; on
>> the other hand, the em28xx driver allocates the URBs only when the data
>> starts streaming and frees them when the stream stops, so the URBs are
>> freed/reallocated every time the user zaps to a new channel;
> 
> Correct, the current strategy is to optimized to minimize memory use
> when the device is not active, as opposed to tying up the memory when
> it's not in use (obviously at the cost of the memory possibly not
> being available on certain ARM/MIPS platforms).

Ok, that's clear.

>> 2) dvb-usb drivers typically allocate 10 URBs each with a 4k buffer (but
>> the exact size of the buffer is board dependent); instead, em28xx
>> allocates 5 URBs with buffers of size 64xMaxPacketSize (which is 940
>> byte for the PCTV 290e).
>>
>> This means a typical dvb-usb driver uses about 40k of coherent memory,
>> while the PCTV 290e takes about 300k! And this 300k of coherent memory
>> are freed/reallocated each time the user selects a new channel.
>>
>> I played a bit with the size of the buffers; I found out that both the
>> PCTV 290e and the Terratec Hybrid XS work perfectly fine with 4k
>> buffers, just like the usb-dvb drivers. So the PCTV 290e only needs 20k
>> of coherent memory instead of the 300k currently allocated (this is
>> equivalent to set EM28XX_DVB_MAX_PACKETS to just 4 instead of 64).
> 
> This one is a bit harder to speculate on.  Are you actually capturing
> all the packets and ensuring there are no packets being dropped (e.g.
> looking for discontinuities)?  Have you tried it with modulation types
> that are high bandwidth?  Have you tried capturing an entire stream
> with PID filtering disabled?  The change you described may "appear" to
> be working when in fact it's only working for a subset of real-world
> use cases.

On the MIPS STB, PID filtering is always disabled. The highest bandwidth
modulation I have available in my area is a QAM256 DVB-T2 multiplex, and
it appears to be working fine.

Lowering the buffer size below 4k, I can see some image corruption
(green stripes of macro-blocks). So 4k must be on the edge.

I have not tried to capture the entire stream yet. So far, I'm basically
just using the devices.

> Also, the buffer management may be appropriate for the em2874/em2884,
> but be broken for other devices such as the em288[0123].  Testing
> would be required to ensure it's not introducing regressions.  In
> particular, the 2874/2884 had architecture changes which may result in
> differences in behavior (the register map is significantly different,
> for example).

Of course, I'm not proposing to force all existing drivers to use 4k
buffers instead of 60k. What I want to show is that there is room for
optimization in this area. In fact I like the idea of the kernel module
parameter to set the buffer size: the default behavior is unchanged, but
users can test lower values.

>> Also, I prepared a proof-of-concept patch to mimic the usb-dvb URB
>> management; this means the URBs are allocated when the USB device is
>> probed, and are freed when the device is disconnected (the patch code
>> checks for changes in the requested buffer size, but this can never
>> happen in digital mode).
> 
> I don't have any specific problem with such a change assuming it is
> properly vetted against other devices.

Ok.

>> I've tested the patch (with 4k buffers) with both my em28xx sticks and
>> both work perfectly fine on my PC as well as on my MIPS set-top-box.
>> Analog mode is not tested.
> 
> Again, the big question here is surrounding your testing methodology.
> If you could expand on how you're testing, that would be helpful in
> assessing how well the patch will really work.

Please note that the buffer size and the buffer allocation strategy (at
runtime or at driver initialization) are two completely different
topics. The first can cause regressions, the second should not produce
any functional change (bugs excluded).

Regards,
Gianluca
