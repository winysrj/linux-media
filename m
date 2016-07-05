Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36705 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbcGERso (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 13:48:44 -0400
Received: by mail-wm0-f45.google.com with SMTP id f126so146585518wma.1
        for <linux-media@vger.kernel.org>; Tue, 05 Jul 2016 10:48:43 -0700 (PDT)
Subject: Re: [PATCH] media: rc: nuvoton: decrease size of raw event fifo
To: Sean Young <sean@mess.org>
References: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
 <20160704201338.GA28620@gofer.mess.org>
 <fa0d5ad8-961d-60f2-f2e4-eeb7407e0210@gmail.com>
 <20160704210650.GA29388@gofer.mess.org>
 <6d3a95cb-c082-d3f2-6e91-dfadafedf631@gmail.com>
 <20160705091704.GA32736@gofer.mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d1cb52a8-db01-9bef-87e2-362f2908f72b@gmail.com>
Date: Tue, 5 Jul 2016 19:48:34 +0200
MIME-Version: 1.0
In-Reply-To: <20160705091704.GA32736@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.07.2016 um 11:17 schrieb Sean Young:
> On Tue, Jul 05, 2016 at 08:05:16AM +0200, Heiner Kallweit wrote:
>> Am 04.07.2016 um 23:06 schrieb Sean Young:
>>> On Mon, Jul 04, 2016 at 10:51:50PM +0200, Heiner Kallweit wrote:
>>>> Am 04.07.2016 um 22:13 schrieb Sean Young:
>>>>> On Wed, May 18, 2016 at 10:29:41PM +0200, Heiner Kallweit wrote:
>>>>>> This chip has a 32 byte HW FIFO only. Therefore the default fifo size
>>>>>> of 512 raw events is not needed and can be significantly decreased.
>>>>>>
>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>
>>>>> The 32 byte hardware queue is read from an interrupt handler and added
>>>>> to the kfifo. The kfifo is read by the decoders in a seperate kthread
>>>>> (in ir_raw_event_thread). If we have a long IR (e.g. nec which has 
>>>>> 66 edges) and the kthread is not scheduled in time (e.g. high load), will
>>>>> we not end up with an overflow in the kfifo and unable to decode it?
>>>>>
>>>> The interrupt handler is triggered latest when 24 bytes have been read.
>>>> (at least that's how the chip gets configured at the moment)
>>>> This gives the decoder thread at least 8 bytes time to process the
>>>> kfifo. This should be sufficient even under high load.
>>>
>>> No, it gives the interrupt handler at least 8 bytes time to read the
>>> hardware fifo (and add it to the kfifo). There are no guarantees about
>>> when the decoder kthread runs (which reads the kfifo).
>>>
>>> To put it another way, in the nuvoton interrupt handler, you call 
>>> ir_raw_event_handle() which does a wake_up_process(). That puts the
>>> decoder process (it has a pid) in a runnable state and it will run at
>>> some future time.
>>>
>> You're right, that's the more precise description.
>> These 8 bytes time give the decoder process few msec's to start.
>> (Not sure wheter there's any protocol resulting in much shorter time.)
>> At least during my tests this was always sufficient.
> 
> So worst case scenario with NEC IR (I have not checked all ir protocols).
> 1. 32 bytes of IR read from hardware fifo.
> 2. IR in the middle of series of 1s (two edges, 1.125ms each)
> 3. After 13.5ms interrupt is triggered again as 12 new bits generated 24 edges
> 4. Decoder thread has not run and emptied the fifo.
> 5. kfifo overflow and IR cannot be decoded; key lost
> 
At least in the nuvoton driver the decoder thread is started whenever
something was read from the hw fifo and written to kfifo.
-> call to ir_raw_event_handle() at the end of nvt_process_rx_ir_data
It doesn't wait for the end of an IR packet.
Means in your example the decoder thread would be started after step 1
and whenever the hw fifo reaches the threshold to generate an irq.

>> However if you think 32 bytes might be too small as kfifo size I'd
>> also be fine with increasing it. The result should still be better
>> than the default size of 512.
> 
> So this depends on how many edges an remote could possible generate and
> how often the kthread will be scheduled to read it. For example I have
> a remote which repeats the entire nec code after 20ms if you hold a
> button down. That's about 800 edges per second, so with a kfifo of 512
> the kthread would have to be scheduled twice a second.
> 
> I think we should stick to the default of 512.
> 
> 
> Sean
> 

