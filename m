Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab0G2RSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 13:18:07 -0400
Date: 29 Jul 2010 19:17:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: awalls@md.metrocast.net
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: maximlevitsky@gmail.com
Cc: mchehab@redhat.com
Message-ID: <BTlN7d7ZjFB@christoph>
In-Reply-To: <1280417934.15757.20.camel@morgan.silverblock.net>
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

on 29 Jul 10 at 11:38, Andy Walls wrote:
> On Thu, 2010-07-29 at 17:41 +0300, Maxim Levitsky wrote:
>> On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote:
>>> Hi Maxim,
>>>
>>> on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
>>> [...]
>>>> In addition to comments, I changed helper function that processes samples
>>>> so it sends last space as soon as timeout is reached.
>>>> This breaks somewhat lirc, because now it gets 2 spaces in row.
>>>> However, if it uses timeout reports (which are now fully supported)
>>>> it will get such report in middle.
>>>>
>>>> Note that I send timeout report with zero value.
>>>> I don't think that this value is importaint.
>>>
>>> This does not sound good. Of course the value is important to userspace
>>> and 2 spaces in a row will break decoding.
>>>
>>> Christoph
>>
>> Could you explain exactly how timeout reports work?
>>
>> Lirc interface isn't set to stone, so how about a reasonable compromise.
>> After reasonable long period of inactivity (200 ms for example), space
>> is sent, and then next report starts with a pulse.
>> So gaps between keypresses will be maximum of 200 ms, and as a bonus I
>> could rip of the logic that deals with remembering the time?
>>
>> Best regards,
>> Maxim Levitsky

> Just for some context, the Conexant hardware generates such reports on
> it's hardware Rx FIFO:

>> From section 3.8.2.3 of

> http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf
>
> "When the demodulated input signal no longer transitions, the RX pulse
> width timer overflows, which indicates the end of data transmission.
> When this occurs, the timer value contains all 1s. This value can be
> stored to the RX FIFO, to indicate the end of the transmission [...].
> Additionally, a status bit is set which can interrupt the
> microprocessor, [...]".
>
> So the value in the hardware RX FIFO is the maximum time measurable
> given the current hardware clock divider settings, plus a flag bit
> indicating overflow.
>
> The CX2388[58] IR implementation currently translates that hardware
> notification into V4L2_SUBDEV_IR_PULSE_RX_SEQ_END:
>
> http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=drivers/media/video/cx238
> 85/cx23888-ir.c;h=51f21636e639330bcf528568c0f08c7a4a674f42;hb=094fc94360cf01
> 960da3311698fedfca566d4712#l678
>
> which is defined here:
>
> http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=include/media/v4l2-subdev
> .h;h=bacd52568ef9fd17787554aa347f46ca6f23bdb2;hb=094fc94360cf01960da3311698f
> edfca566d4712#l366
>
> as
>
> #define V4L2_SUBDEV_IR_PULSE_RX_SEQ_END         0xffffffff
>
>
> I didn't look too hard at it, but IIRC the in kernel decoders would have
> interpreted this value incorrectly (the longest possible mark).
> Instead, I just pass along the longest possible space:
>
> http://git.linuxtv.org/awalls/v4l-dvb.git?a=blob;f=drivers/media/video/cx238
> 85/cx23885-input.c;h=3f924e21b9575f7d67d99d71c8585d41828aabfe;hb=094fc94360c
> f01960da3311698fedfca566d4712#l49
>
> so it acts as in band signaling if anyone is looking for it, and the in
> kernel decoders happily treat it like a long space.
>
> With a little work, I could pass the actual time it took for the Rx
> timer to timeout as well (Provide the space measurement *and* the in
> band signal), if needed.

The value for LIRC_MODE2_TIMEOUT needs to be the exact value of the acutal  
time passed since the last pulse. When you just send the longest possible  
space instead, you'll make repeat detection impossible.

Christoph

