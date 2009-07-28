Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3745 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZG1GyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 02:54:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: How to save number of times using memcpy?
Date: Tue, 28 Jul 2009 08:54:12 +0200
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
	jm105.lee@samsung.com,
	=?utf-8?q?=EC=9D=B4=EC=84=B8=EB=AC=B8?= <semun.lee@samsung.com>,
	=?utf-8?q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
In-Reply-To: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280854.12708.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 28 July 2009 02:56:05 Dongsoo, Nathaniel Kim wrote:
> Hello everyone,
>
> What I'm gonna ask might be quite a bit tough couple of questions, but
> definitely necessary in multimedia device driver area.
>
> My first question is "Is any driver using using continuous physical
> memory has any chance to be adopted in main line kernel?"
> Because I'm afraid what I'm talking about is all about multimedia,
> which is consuming plenty of memory.
> But please note that in this case all the drivers I take care of are
> ARM SoC's peripheral device drivers.(ie. camera interface driver in
> Samsung CPU). And whenever we choose to use continuous physical
> memory, then current videobuf cannot be used in those kind of device
> drivers because of the io-remapping.

Why not? This happens all the time, including in the new omap and davinci 
drivers from TI.

What typically happens is that the memory is allocated when the v4l driver 
is loaded and not at first use. Due to memory fragmentation it becomes 
almost impossible to allocate these buffers later so it has to be done as 
early as possible.

>
>
> And the other one is about how to handle the buffer used between
> couple of multimedia devices.
> Let me take an example of a camcorder scenario which takes series of
> pictures and encode them in some sort of multimedia encoded format.
> And let's assume that we are using a device of a SoC H/W which has
> it's own camera and multimedia encoder device as well.
>
> The scenario might be going like following order ordinarily.
> 1. User application: open camera device node and tries to mmap
> buffer(A) to be used.
> 2. Camera interface: try to allocate memory in kernel space and creates
> mapping. 

Wrong, this should have been point 1 because by this time it's pretty 
unlikely you can allocate the buffers needed due to memory fragmentation.

> 3. User application: open encoder device node and tries to mmap 
> buffer(B) as input buffer and buffer(C) as output buffer to be used.
> 4. Start streaming
> 5. Camera interface: fetch data from external camera module and writes
> to the allocated buffer in kernel space and give back the memory
> address to user application through dqbuf
> 6. User application: memcpy(1st) returned buffer(A) to frame buffer
> therefore we can see as preview

Unavoidable memcpy, unless there is some sort of hardware support to DMA 
directly into the framebuffer.

> 7. User application: memcpy(2nd) returned buffer(A) to buffer(B) of
> encoder device.

So this is copying between two v4l2 video nodes, right?

> 7. Encoder device: encodes the data copied into buffer(B) and returns
> to user application through buffer(C)
> 8. User application: memcpy(3nd) encoded data from buffer(C) and save as
> file 
> 9. do loop from 5 to 8 as long as you want to keep recording 
>
> As you see above, at least three times of memcpy per frame are
> necessary to make the recording and preview happened. Of course I took
> a worst case for example because we can even take in-place thing for
> encoder buffer, but I jut wanted to consider of drivers not capable to
> take care of in-place algorithm for some reasons.
>
> Now let's imagine that we are recording 1920*1080 sized frame. can you
> draw the picture in your mind how it might be inefficient?
>
>
> So, my second question is "Is V4L2 covering the best practice of video
> recording for embedded system?"
> As you know, embedded systems are running out of memories..and don't
> have much enough memory bandwidth either.
> I'm not seeing any standard way for "device to device" buffer handling
> in V4L2 documents. If nobody has been considering this issue, can I
> bring it on the table for make it in a unified way, therefor we can
> make any improvement in opensource multimedia middlewares and drivers
> as well.

It's been considered, see this RFC:

http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html

A lot of the work done in the past year was actually to lay the foundation 
for implementing media controllers and media processors.

But with a framework like this it should be possible to tell the v4l2 driver 
to link the output of the camera module to the input of the encoder. 
Functionality like that is currently missing in the API.

I plan on reworking this RFC during this year's Plumbers conference in 
September (http://linuxplumbersconf.org/2009/). You should consider 
attending if you want to join these discussions. It would be very valuable 
to have your input.

>
>
> By the way.. among the examples above I mentioned, I took an example
> of codec device. right? How far are we with codec devices in V4L2
> community?

Not far. If I'm not mistaken Mauro preferred to implement this with what is 
basically a media processor node, and those are not yet in place.

> Thanks to the ultimate H/W in these days, we are facing 
> tremendous issues as well.

I know. As the RFC shows (even though it's a bit out of date) I do have a 
good idea on how to implement it on a high level. The devil is in the 
details, though. And in the time it takes to implement.

Regards,

	Hans

> Cheers,
>
> Nate



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
