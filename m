Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:55542 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZHLI4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 04:56:44 -0400
Received: by ewy10 with SMTP id 10so4382034ewy.37
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 01:56:44 -0700 (PDT)
Message-ID: <4A8283C9.6020105@gmail.com>
Date: Wed, 12 Aug 2009 10:56:41 +0200
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: video4linux-list@redhat.com,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: framebuffer overlay
References: <4A827C70.4090500@gmail.com> <5e9665e10908120143h268a7210kb6bfa215cbfbe6de@mail.gmail.com>
In-Reply-To: <5e9665e10908120143h268a7210kb6bfa215cbfbe6de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the reply!

Dongsoo, Nathaniel Kim wrote:
> On Wed, Aug 12, 2009 at 5:25 PM, Ryan Raasch<ryan.raasch@gmail.com> wrote:
>> Hello,
>>
>> I am trying to write a driver for a camera using the new soc_camera in the
>> mainline kernel the output is the overlay framebuffer (pxa270) and i would
>> like to use the overlay output feature of v4l2 framework, but the
>> framebuffer does not expose itself as a output device (not yet).
>>
> Hi Ryan,
> 
> As far as I know the framebuffer of PXA2 even PXA3 can't be
> categorized in a overlay device.

The pxa2 and pxa3 both have 3 framebuffers (4 if hardware curser 
included). There is the main fb, and 2 overlay framebuffers.

The overlay 2 has hardware accelerated ycbcr decoding (which i use now 
with a camera using dma). And the overlay 1 can be used only with the 
various types of RGB.

We have a solution which uses dma to copy the captured video from the 
camera sensor (mmap'd), directly to the mmap'd memory of the overlay. 
All occuring without user intervention.


> To be able to get used as overlay device by camera interface, I think
> there should be a direct FIFO between camera and framebuffer which
> means there is no need to copy memory from camera to fb. But
> unfortunately PXA architecture is not supporting this kind of feature.

With the above there is no need for FIFO, the dma is directly copying 
the received camera data to the selected framebuffer.

Ryan

> Cheers,
> 


> Nate
> 
>> Are there any fb that i can use as an example for this?
>>
>> From looking at the driver code, it seems like the generic code of fbmem.c
>> needs a v4l2 device. Is this in the right ballpark?
>>
>> Thanks,
>> Ryan
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
> 
> 
> 
