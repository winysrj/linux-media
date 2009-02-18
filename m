Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:53943 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZBRPID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:08:03 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF9002G6OOPS0M0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 18 Feb 2009 10:07:38 -0500 (EST)
Date: Wed, 18 Feb 2009 10:07:37 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-reply-to: <Pine.LNX.4.58.0902171820320.24268@shell2.speakeasy.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	linux-dvb@linuxtv.org
Message-id: <499C2439.5040102@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4986507C.1050609@googlemail.com>
 <200902151336.17202@orion.escape-edv.de>
 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
 <20090216153148.6f2aa408@pedra.chehab.org> <4999BADF.6070106@linuxtv.org>
 <Pine.LNX.4.58.0902161611300.24268@shell2.speakeasy.net>
 <499AD4E7.1030306@linuxtv.org>
 <Pine.LNX.4.58.0902171820320.24268@shell2.speakeasy.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho wrote:
> On Tue, 17 Feb 2009, Steven Toth wrote:
>> Trent Piepho wrote:
>>> On Mon, 16 Feb 2009, Steven Toth wrote:
>>>>> Hartmut, Oliver and Trent: Thanks for helping with this issue. I've just
>>>>> reverted the changeset. We still need a fix at dm1105, au0828-dvb and maybe
>>>>> other drivers that call the filtering routines inside IRQ's.
>>>> Fix the demux, add a worker thread and allow drivers to call it directly.
>>>>
>>>> I'm not a big fan of videobuf_dvb or having each driver do it's own thing as an
>>>> alternative.
>>>>
>>>> Fixing the demux... Would this require and extra buffer copy? probably, but it's
>>>> a trade-off between  the amount of spent during code management on a driver by
>>>> driver basis vs wrestling with videobuf_dvb and all of problems highlighted on
>>>> the ML over the last 2 years.
>>> Have the driver copy the data into the demuxer from the interrupt handler
>>> with irqs disabled?  That's still too much.
>>>
>>> The right way to do it is to have a queue of DMA buffers.  In the interrupt
>>> handler the driver takes the completed DMA buffer off the "to DMA" queue
>>> and puts it in the "to process" queue.  The driver should not copy and
>>> cetainly not demux the data from the interrupt handler.
>> I know what the right way is Trent (see cx23885) although thank you for
>> reminding me. videobuf_dvb hasn't convinced people like me to bury myself in its
>> mess or complexity during retro fits cases. Retro fitting videobuf_dvb into cx18
>> (at the time) was way too much effort.
>>
>> Retro fitting it into existing drivers can be painful and I haven't seen any
>> volunteers stand up over the last 24 months to get this done.
>>
>> My suggestion? For the most part we're talking about very low data rates for
>> DVB, coupled with fast memory buses for memcpy's. If the group doesn't want
>> calls to the sw_filter methods then implement a half-way-house replacement for
>> those drivers - as I mentioned above - with the memcpy. Either this approach, or
> 
> The problem is holding a spin lock with irqs disabled for a long amount of
> time.  What exactly is your plan that will remove this, yet allow drivers
> to process their buffers from an irq handler?

That's not what I was suggesting. I was suggesting adding some ring buffer code 
and a worker thread for each driver context (done in a mythical demux->register 
func). This means that each driver get's it's own worker and ringbuffer. Driver 
mutex on your own ring buffer is localized to your instance of the driver. It 
would be up to your drivers worker thread (instantiated and managed incidentally 
by the demux core, not at irq level), to acquire the long term spinlock via 
sw_filter_n (already in demux core) underdiscussion and NOT block a driver 
calling demux->feedMyPersonalRingBuffer().

> 
>> A general question to the group: Who wants to volunteer to retro fit
>> videobuf_dvb into the current drivers so we can avoid calls to sw_filter_...n()
>> directly?
> 
> I don't see why videobuf_dvb is needed.

That was the point I was trying to make. IE. Push videobuf_dvb like behavior 
into the demux core, having drivers register, give each driver it's own worker 
thread and have that thread, running not in the interrupt context, feed the 
existing sw_filter_n() functions. The price is the cost of doing a memcpy of a 
low bitrate low frequency buffer into your demux's personal ring buffer. That 
has to be more efficient than the current drivers that feed sw_filter_n() 
directly, but not ideal. It's a half-way-house solution that consolidates 
complicated code into code, and keeps the drivers clean and easier to manage.

Trade off an infrequent memcpy on a low volume stream in < 50% of the drivers 
for a simplified approach. You don't have to do this for every driver, 
especially drivers that already implement videobuf_dvb, do it for the current 
problematic drivers...... or, have a volunteer add videobuf_dvb to all of the 
existing drivers.

- Steve
