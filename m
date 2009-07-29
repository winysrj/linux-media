Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:50704 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZG2Dak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 23:30:40 -0400
Received: by qyk9 with SMTP id 9so484823qyk.33
        for <linux-media@vger.kernel.org>; Tue, 28 Jul 2009 20:30:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090728003548.1a99224a@pedra.chehab.org>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
	<20090728003548.1a99224a@pedra.chehab.org>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 29 Jul 2009 12:30:19 +0900
Message-ID: <5e9665e10907282030i7d25c6e4se1d52eff321da8e3@mail.gmail.com>
Subject: Re: How to save number of times using memcpy?
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
	jm105.lee@samsung.com,
	=?UTF-8?B?7J207IS466y4?= <semun.lee@samsung.com>,
	=?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Jul 28, 2009 at 12:35 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Hi Dongsoo,
>
> Em Tue, 28 Jul 2009 09:56:05 +0900
> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:
>
>> Hello everyone,
>>
>> What I'm gonna ask might be quite a bit tough couple of questions, but
>> definitely necessary in multimedia device driver area.
>>
>> My first question is "Is any driver using using continuous physical
>> memory has any chance to be adopted in main line kernel?"
>> Because I'm afraid what I'm talking about is all about multimedia,
>> which is consuming plenty of memory.
>> But please note that in this case all the drivers I take care of are
>> ARM SoC's peripheral device drivers.(ie. camera interface driver in
>> Samsung CPU). And whenever we choose to use continuous physical
>> memory, then current videobuf cannot be used in those kind of device
>> drivers because of the io-remapping.
>>
>>
>> And the other one is about how to handle the buffer used between
>> couple of multimedia devices.
>> Let me take an example of a camcorder scenario which takes series of
>> pictures and encode them in some sort of multimedia encoded format.
>> And let's assume that we are using a device of a SoC H/W which has
>> it's own camera and multimedia encoder device as well.
>>
>> The scenario might be going like following order ordinarily.
>> 1. User application: open camera device node and tries to mmap
>> buffer(A) to be used.
>> 2. Camera interface: try to allocate memory in kernel space and creates mapping.
>> 3. User application: open encoder device node and tries to mmap
>> buffer(B) as input buffer and buffer(C) as output buffer to be used.
>> 4. Start streaming
>> 5. Camera interface: fetch data from external camera module and writes
>> to the allocated buffer in kernel space and give back the memory
>> address to user application through dqbuf
>> 6. User application: memcpy(1st) returned buffer(A) to frame buffer
>> therefore we can see as preview
>> 7. User application: memcpy(2nd) returned buffer(A) to buffer(B) of
>> encoder device.
>> 7. Encoder device: encodes the data copied into buffer(B) and returns
>> to user application through buffer(C)
>> 8. User application: memcpy(3nd) encoded data from buffer(C) and save as file
>> 9. do loop from 5 to 8 as long as you want to keep recording
>>
>> As you see above, at least three times of memcpy per frame are
>> necessary to make the recording and preview happened. Of course I took
>> a worst case for example because we can even take in-place thing for
>> encoder buffer, but I jut wanted to consider of drivers not capable to
>> take care of in-place algorithm for some reasons.
>>
>> Now let's imagine that we are recording 1920*1080 sized frame. can you
>> draw the picture in your mind how it might be inefficient?
>>
>
> I'm not sure if I understood your problem. Videobuf consists of 2 separate parts:
>        a common core part, responsible for controlling the buffers;
>        a memory allocation specific part.
>
> There are currently 3 different implementations for the memory-specific one:
>        - dma scatter/gather buffers;
>        - dma contiguous buffer;
>        - vmalloc buffer.
>
> The first two are currently used by PCI devices (although they probably work
> with other buses), while the third one is used on USB devices, where we need to
> remove the USB transport data from the stream, so, data needs to be copied.
>
> If you use one of the dma implementations, a stream is received from the
> capture device, and can be directly mapped at the userspace application, via
> mmap() ioctl. In this case, there's no memory copy between userspace and
> kernelspace. The application will directly see the data.
>

Sorry my bad. I missed something very important to explain my issue clear.
The thing is, I want to reserve specific amount of continuous physical
memory on machine initializing time. Therefor some multimedia
peripherals can be using this memory area exclusively.
That's what I was afraid of could not being adopted in main line kernel.

And if I use reserved memory on purpose, I might have problem using
videobuf because it uses dma_alloc_coherent() anyway.


> There's also an special type of transfer called overlay mode. On the overlay
> mode, the DMA transfers are mapped directly into the output device.
>
> In general, the drivers that implement overlay mode also mmap(), but this is
> done, on those drivers, via a separate DMA transfer.
>
> The applications that benefit with overlay mode, uses overlay for display and
> mmap for record, and may have different resolutions on each mode.
>

Yes I think if I'm getting right, I have similar feature which is
transferring data from camera interface to frame buffer with FIFO
pipeline.
And I consider this as an overlay feature.

>>
>> So, my second question is "Is V4L2 covering the best practice of video
>> recording for embedded system?"
>> As you know, embedded systems are running out of memories..and don't
>> have much enough memory bandwidth either.
>> I'm not seeing any standard way for "device to device" buffer handling
>> in V4L2 documents. If nobody has been considering this issue, can I
>> bring it on the table for make it in a unified way, therefor we can
>> make any improvement in opensource multimedia middlewares and drivers
>> as well.
>
> Nothing stops you from proposing newer modules, but there are several embedded
> systems using it.
>>
>>
>> By the way.. among the examples above I mentioned, I took an example
>> of codec device. right? How far are we with codec devices in V4L2
>> community? Thanks to the ultimate H/W in these days, we are facing
>> tremendous issues as well.
>
> It depends. When vendor helps, then Linux can have the bleeding edge drivers. For
> example, the first O. S. with USB 3.0 is Linux, since the vendor supported the
> development of the kernel driver for it. Each time, more vendors are interested
> on supporting Linux. This happens on all areas of the kernel, including V4L.
>

I hope I could participate in cutting edge Linux technology with my works.
As far as I know, there are plenty of areas need to be improved for
camera devices in Linux kernel.
Cheers,

Nate
> Cheers,
> Mauro
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
