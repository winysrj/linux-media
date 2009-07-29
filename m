Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:40790 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZG2FHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 01:07:01 -0400
Received: by qyk9 with SMTP id 9so525760qyk.33
        for <linux-media@vger.kernel.org>; Tue, 28 Jul 2009 22:07:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907280939.12017.laurent.pinchart@skynet.be>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
	<200907280854.12708.hverkuil@xs4all.nl> <200907280939.12017.laurent.pinchart@skynet.be>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 29 Jul 2009 14:06:41 +0900
Message-ID: <5e9665e10907282206i9e4b2a6hdf175ea79dba5ab4@mail.gmail.com>
Subject: Re: How to save number of times using memcpy?
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
	jm105.lee@samsung.com,
	=?UTF-8?B?7J207IS466y4?= <semun.lee@samsung.com>,
	=?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2009/7/28 Laurent Pinchart <laurent.pinchart@skynet.be>:
> On Tuesday 28 July 2009 08:54:12 Hans Verkuil wrote:
>> On Tuesday 28 July 2009 02:56:05 Dongsoo, Nathaniel Kim wrote:
> [snip]
>> > And the other one is about how to handle the buffer used between
>> > couple of multimedia devices.
>> > Let me take an example of a camcorder scenario which takes series of
>> > pictures and encode them in some sort of multimedia encoded format.
>> > And let's assume that we are using a device of a SoC H/W which has
>> > it's own camera and multimedia encoder device as well.
>> >
>> > The scenario might be going like following order ordinarily.
>> > 1. User application: open camera device node and tries to mmap
>> > buffer(A) to be used.
>> > 2. Camera interface: try to allocate memory in kernel space and creates
>> > mapping.
>>
>> Wrong, this should have been point 1 because by this time it's pretty
>> unlikely you can allocate the buffers needed due to memory fragmentation.
>>
>> > 3. User application: open encoder device node and tries to mmap
>> > buffer(B) as input buffer and buffer(C) as output buffer to be used.
>> > 4. Start streaming
>> > 5. Camera interface: fetch data from external camera module and writes
>> > to the allocated buffer in kernel space and give back the memory
>> > address to user application through dqbuf
>> > 6. User application: memcpy(1st) returned buffer(A) to frame buffer
>> > therefore we can see as preview
>>
>> Unavoidable memcpy, unless there is some sort of hardware support to DMA
>> directly into the framebuffer.
>
> Or unless you use the USERPTR method instead of MMAP, providing your graphics
> hardware provides some sort of video display capabilities (similar to Xv for
> instance). You can then allocate a video buffer and ask the camera driver to
> DMA data directly to that buffer. This requires
>
> 1. the video buffer to be contiguous in virtual memory (no stride)
> 2. the video buffer to be contiguous in physical memory, OR the camera DMA to
> support scatter-gather.
>

Actually me and other engineers are not used to use USERPTR than MMAP.
But one thing obvious is the H/W we are working on is able to send
data directly from camera interface to frame buffer through FIFO
pipeline. With this way no memcpy necessary to display preview.

>> > 7. User application: memcpy(2nd) returned buffer(A) to buffer(B) of
>> > encoder device.
>>
>> So this is copying between two v4l2 video nodes, right?
>
> Does your hardware allow chaining the camera and codec directly without going
> through memory buffers ?
>

Unfortunately no. Direct path is supported just between camera and
frame buffer. It should be better if it is supported between them but
I suppose that H/W designer wanted to make the codec device system
wide one.

>> > 7. Encoder device: encodes the data copied into buffer(B) and returns
>> > to user application through buffer(C)
>> > 8. User application: memcpy(3nd) encoded data from buffer(C) and save as
>> > file
>> > 9. do loop from 5 to 8 as long as you want to keep recording
>> >
>> > As you see above, at least three times of memcpy per frame are
>> > necessary to make the recording and preview happened. Of course I took
>> > a worst case for example because we can even take in-place thing for
>> > encoder buffer, but I jut wanted to consider of drivers not capable to
>> > take care of in-place algorithm for some reasons.
>> >
>> > Now let's imagine that we are recording 1920*1080 sized frame. can you
>> > draw the picture in your mind how it might be inefficient?
>> >
>> > So, my second question is "Is V4L2 covering the best practice of video
>> > recording for embedded system?"
>> > As you know, embedded systems are running out of memories..and don't
>> > have much enough memory bandwidth either.
>> > I'm not seeing any standard way for "device to device" buffer handling
>> > in V4L2 documents. If nobody has been considering this issue, can I
>> > bring it on the table for make it in a unified way, therefor we can
>> > make any improvement in opensource multimedia middlewares and drivers
>> > as well.
>>
>> It's been considered, see this RFC:
>>
>> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html
>>
>> A lot of the work done in the past year was actually to lay the foundation
>> for implementing media controllers and media processors.
>>
>> But with a framework like this it should be possible to tell the v4l2
>> driver to link the output of the camera module to the input of the encoder.
>> Functionality like that is currently missing in the API.
>
> There are two different use cases. The first one covers embedded hardware that
> provide a direct camera -> codec link without requiring any intervention of
> the CPU for data transfer. This is the most efficient solution if your
> hardware is clever enough. It would require additions to the v4l2 API to
> configure the links dynamically.
>
> The second one covers less clever embedded hardware, where video data has to
> go to a memory buffer between the camera interface and the codec. In that case
> it could be useful to allocate v4l2 buffers shared between the camera and
> codec v4l2 devices. This is not handled by v4l2 at the moment either.
>

I suppose that I need to approach with the second one. So you mean
that this approach is not considered in v4l2 yet? I hope that it will
be a good opportunity for a new step.
Cheers,

Nate

>> I plan on reworking this RFC during this year's Plumbers conference in
>> September (http://linuxplumbersconf.org/2009/). You should consider
>> attending if you want to join these discussions. It would be very valuable
>> to have your input.
>>
>> > By the way.. among the examples above I mentioned, I took an example
>> > of codec device. right? How far are we with codec devices in V4L2
>> > community?
>>
>> Not far. If I'm not mistaken Mauro preferred to implement this with what is
>> basically a media processor node, and those are not yet in place.
>>
>> > Thanks to the ultimate H/W in these days, we are facing tremendous issues
>> > as well.
>>
>> I know. As the RFC shows (even though it's a bit out of date) I do have a
>> good idea on how to implement it on a high level. The devil is in the
>> details, though. And in the time it takes to implement.
>
> Regards,
>
> Laurent Pinchart
>
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
