Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:50770 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZHQOug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 10:50:36 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1000440qwh.37
        for <linux-media@vger.kernel.org>; Mon, 17 Aug 2009 07:50:37 -0700 (PDT)
Message-ID: <4A896E37.5010104@gmail.com>
Date: Mon, 17 Aug 2009 16:50:31 +0200
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: video4linux-list@redhat.com,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: framebuffer overlay
References: <4A827C70.4090500@gmail.com> <5e9665e10908120143h268a7210kb6bfa215cbfbe6de@mail.gmail.com> 	<4A8283C9.6020105@gmail.com> <5e9665e10908120344v668331a9g3c470971a5da3ef0@mail.gmail.com>
In-Reply-To: <5e9665e10908120344v668331a9g3c470971a5da3ef0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have another question.

Has there been any discussion on any type of generic framebuffer v4l2 
device (output device), like a gstreamer sink (like the soc_camera)?

 From this perspective, when the frame buffer registers itself, it could 
just *add* the capabilities, and allow the fb.c to handle many of the 
logistics.

I am developing for a system where we do not use X and use the 
framebuffer directly (E17). It would be nice to fit any of the 
framebuffers into a *neat* v4l2 package for any app to use (gstreamer, 
mplayer).

And with our camera, gstreamer, etc. could just be a command line away 
from live streaming :)



Thanks,
Ryan

Dongsoo, Nathaniel Kim wrote:
> On Wed, Aug 12, 2009 at 5:56 PM, Ryan Raasch<ryan.raasch@gmail.com> wrote:
>> Thanks for the reply!
>>
>> Dongsoo, Nathaniel Kim wrote:
>>> On Wed, Aug 12, 2009 at 5:25 PM, Ryan Raasch<ryan.raasch@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> I am trying to write a driver for a camera using the new soc_camera in
>>>> the
>>>> mainline kernel the output is the overlay framebuffer (pxa270) and i
>>>> would
>>>> like to use the overlay output feature of v4l2 framework, but the
>>>> framebuffer does not expose itself as a output device (not yet).
>>>>
>>> Hi Ryan,
>>>
>>> As far as I know the framebuffer of PXA2 even PXA3 can't be
>>> categorized in a overlay device.
>> The pxa2 and pxa3 both have 3 framebuffers (4 if hardware curser included).
>> There is the main fb, and 2 overlay framebuffers.
>>
>> The overlay 2 has hardware accelerated ycbcr decoding (which i use now with
>> a camera using dma). And the overlay 1 can be used only with the various
>> types of RGB.
>>
>> We have a solution which uses dma to copy the captured video from the camera
>> sensor (mmap'd), directly to the mmap'd memory of the overlay. All occuring
>> without user intervention.
>>
>>
>>> To be able to get used as overlay device by camera interface, I think
>>> there should be a direct FIFO between camera and framebuffer which
>>> means there is no need to copy memory from camera to fb. But
>>> unfortunately PXA architecture is not supporting this kind of feature.
>> With the above there is no need for FIFO, the dma is directly copying the
>> received camera data to the selected framebuffer.
>>
>> Ryan
>>
> 
> Cool.
> So, that means you need a SoC hardware based reference code right?
> (because pxa is also a SoC)
> I think there is not so many choices that you can put on the table.
> In my experience, OMP3 camera interface is supporting overlay feature
> through omap_vout I guess. I think it is not obvious in SoC H/W
> platform about *what is overlay device* and *how to use* them.
> 
> And about omap3 camera interface driver, it is not in the mainline
> kernel yet. For the camera interface code you need to look into
> Sakari's gitorious repository and for omap_vout you need to look for
> Hardik's repository or any repository he is working on..I guess.
> I'm also trying to figure out the best way to use overlay feature on
> samsung's new cpu named S5PC1XX.
> 
> The most complicated part of this job is the whole thing is happening
> in a single piece of chip and need to figure out the standardized way
> for compatibility. I wish you luck :-)
> Cheers,
> 
> Nate
> 
>>> Cheers,
>>>
>>
>>> Nate
>>>
>>>> Are there any fb that i can use as an example for this?
>>>>
>>>> From looking at the driver code, it seems like the generic code of
>>>> fbmem.c
>>>> needs a v4l2 device. Is this in the right ballpark?
>>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>> --
>>>> video4linux-list mailing list
>>>> Unsubscribe
>>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>>
>>>
>>>
> 
> 
> 
