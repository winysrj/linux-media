Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39881 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2E0Xkl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 19:40:41 -0400
Message-ID: <4FC2BB76.4050404@iki.fi>
Date: Mon, 28 May 2012 02:40:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVB USB: change USB stream settings dynamically
References: <4FC00C11.10403@iki.fi> <4FC227C7.3080309@iki.fi> <4FC259AC.100@gmail.com>
In-Reply-To: <4FC259AC.100@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.05.2012 19:43, Gianluca Gennari wrote:
> Hi Antti,
>
> Il 27/05/2012 15:10, Antti Palosaari ha scritto:
>> On 26.05.2012 01:47, Antti Palosaari wrote:
>>> I was planning make DVB USB be able to switch USB streaming parameters
>>> dynamically. I mean [struct usb_data_stream_properties] parameters.
>>>
>>> Currently it reserves USB streaming buffers when device is plugged. Own
>>> buffer is reserved for each frontend, which means currently 1-3
>>> streaming buffers depending on device.
>>>
>>> Basically I see USB TS as a DVB USB device property - not property of
>>> frontend. USB TS is interface between computer and USB-bridge and amount
>>> of parallel USB TS or TS configurations depends on USB-bridge
>>> capabilities. Sometimes used USB TS could be configured to fit better
>>> used stream. Smaller buffers for the narrow radio stream and biggest
>>> buffers for the wide DVB-S2 stream.
>>>
>>> I was wondering how to resolve that situation? It is not very big
>>> problem currently but I still want to make it better as there is surely
>>> coming new devices that needs better control for the USB streaming
>>> parameters. Currently there is mxl111sf driver which seems to offer 6
>>> different streaming configurations but AFAIK only three is currently
>>> used as there is 3 frontends and each one has own streaming parameters -
>>> and buffers - even only one can be used at the time.
>>>
>>> 1. Configure streaming parameters (alloc buffers) every time when
>>> streaming is started? IIRC that causes some problems lately for em28xx
>>> as memory goes dis-coherent and buffers cannot allocated.
>>>
>>> 2. Allocate buffers (streaming configuration) for all needed device use
>>> configurations at very beginning. Then add some logic to map streaming
>>> config to frontend at runtime. That is quite near what mxl111sf does
>>> currently.
>>
>> After looking existing code carefully and doing some tests I think I
>> will implement that a way it changes buffers at runtime to fit current
>> needs.
>>
>> int usb_urb_submit(struct usb_data_stream *stream) is called when
>> streaming is started. At that point it is possible to compare already
>> reserved buffers and buffers needed. If needed buffers are larger it is
>> possible to reallocate bigger buffers. Of course it is not needed to
>> decrease buffers even smaller stream configurations is asked, just to
>> avoid repetitive allocations of large chunks of coherent memory.
>
> I have a patch that enables a similar behavior on the em28xx driver (for
> digital devices). I used it to play with the buffer size in order to
> determine the minimum working size. I added a couple of parameters to
> the em28xx module that can be used to change the buffer number and size
> at runtime. If anybody is interested, I can post this patch to the list
> for comments.

Maybe there is no idea of merge it but it could be interesting to see still.

>> 1) allocate buffers at the init as now (callback to read stream
>> properties from the driver)
>> 2) re-allocate bigger buffers in runtime if needed (callback to read
>> stream properties from the driver)
>> 3) free all buffers when device is disconnected
>
> I think the deciding factor here is the ratio between the default
> initial size and the maximum buffer size. If it is something like 2X,
> then maybe it's better to keep the code simple and just allocate the
> bigger size from the beginning. If the difference is an order of
> magnitude or more, then using dynamic allocation is probably worth the
> effort.

The problem is here driver author could make buffer size calculation 
error easily :) But as it will likely crash very soon or at least some 
other effects like broken stream it should never go to the public. And 
it is cheap to add check for that too, just few lines of code that 
compares buffer sizes when streaming is started.

I think I will go to that as it is very simple.


> Another possibility is to allocate a single memory pool of coherent
> memory at the init, big enough to cover all the possible modes for the
> given device. Then it is possible to map the URB buffers into this
> memory pool at runtime, choosing the optimal size for each mode.
> The memory pool is freed when the device is disconnected.
> This approach avoids any reallocation so it's safer on ARM/MIPS hardware.

I do not see any difference to the situation largest needed buffers are 
reserved at the device initialization unless dynamically re-allocate. 
But I am going to skip it as it is easier to alloc just as big buffer as 
needed at worst case.

> For example, the as102 driver allocates a single memory pool in
> dev->stream, then it maps the URB buffers into this area (see function
> as102_alloc_usb_stream_buffer() ). In this case the URBs are mapped
> statically, but nothing prevents to dynamically remap the URB buffers at
> runtime if needed.

I should look that driver too. But it sounds a little bit more complex 
to implement than alloc own buffer in the loop for every used URB. There 
is also drawback that it needs very large, 5-6 times larger, coherent 
chunk than per URB buffer.

>> Basically those USB buffers are type of (buffer count) x (buffer size).
>> Buffer count is same as used count of URBs, typically ~5, and buffer
>> size is the payload size of one URB.
>>
>> Here is some background info (em28xx buffer alloc failures) why to avoid
>> continuous buffer allocs / frees.
>> http://www.spinics.net/lists/linux-media/msg44209.html
>
> There is also the old thread about the issue:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg42776.html

I have one remaining unclear question still. Is there any other drawback 
to use more URBs at the same time than it eats memory?

So if I have DVB-T (~22Mbit/sec) frontend which uses 5 URBs in chain and 
then I have DVB-C (~44Mbit/sec) frontend which uses same buffersize but 
there is 6 URBs in chain. In my understanding I will not lose anything 
but memory when I use more URBs in parallel to move data from the device.

regards
Antti
-- 
http://palosaari.fi/
