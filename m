Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZBWIZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 03:25:39 -0500
Message-ID: <49A25D12.4040302@redhat.com>
Date: Mon, 23 Feb 2009 09:23:46 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu> <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu> <49A1CA5B.5000407@redhat.com> <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net> <49A1D7B2.5070601@redhat.com> <Pine.LNX.4.58.0902221504410.24268@shell2.speakeasy.net> <49A1DF50.1080903@redhat.com> <Pine.LNX.4.58.0902221603410.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902221603410.24268@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Trent Piepho wrote:
> On Mon, 23 Feb 2009, Hans de Goede wrote:
>> Trent Piepho wrote:
>>> On Sun, 22 Feb 2009, Hans de Goede wrote:
>>>> Trent Piepho wrote:
>>>>> On Sun, 22 Feb 2009, Hans de Goede wrote:
>>>>>> Yes that is what we are talking about, the camera having a gravity switch
>>>>>> (usually nothing as advanced as a gyroscope). Also the bits we are talking
>>>>>> about are in a struct which communicates information one way, from the camera
>>>>>> to userspace, so there is no way to clear the bits to make the camera do something.
>>>>> First, I'd like to say I agree with most that the installed orientation of
>>>>> the camera sensor really is a different concept than the current value of a
>>>>> gravity sensor.  It's not necessary, and maybe not even desirable, to
>>>>> handle them in the same way.
>>>>>
>>>>> I do not see the advantage of using reserved bits instead of controls.
>>>>>
>>>>> The are a limited number of reserved bits.  In some structures there are
>>>>> only a few left.  They will run out.  Then what?  Packing non-standard
>>>>> sensor attributes and camera sensor meta-data into a few reserved bits is
>>>>> not a sustainable policy.
>>>>>
>>>>> Controls on the other card are not limited and won't run out.
>>>>>
>>>> Yes but these things are *not* controls, end of discussion. The control API is
>>>> for controls, not to stuff all kind of cruft in.
>>> All kind of cruft belongs in the reserved bits of whatever field it can be
>>> stuffed in?
>> Not whatever field, these are input properties which happen to also be pretty
>> binary so putting them in the input flags field makes plenty of sense.
>>
>>> What is the difference?  Why does it matter?  Performance?  Maintenance?
>>> Is there something that's not possible?  I do not find "end of discussion"
>>> to be a very convincing argument.
>> Well they are not controls, that is the difference, the control interface is
>> for controls (and only for controls, end of discussion if you ask me). These
>> are not controls but properties, they do not have a default min and max value,
> 
> Camera pivot sensor ranges from 0 to 270.  How is that not a min and max?
> 
>> they have only one *unchanging* value, there  is nothing the application can
> 
> Camera sensors don't have an unchanging value.
> 
> And who says scan order can't change?  Suppose the camera returns raw bayer
> format data top to bottom, but if you request yuv then an image processing
> section needs to kick in and that returns the data bottom to top.
> 

Yes, because hardware designers like throwing away lots of transistors to 
memory so they are going to put memory in the controller to buffer an entire 
frame and then scan out the memory buffer in different order then the sensor 
gave them the data, so they cannot do FIFO, so they will actually need 2 frames 
of memory.

If the sensor is soldered upside down on the PCB that is a very much unchanging 
value, and an input property if you ask me.

So new proposal: use 2 bits in the input flags to indicate if the input is 
hardwired vflipped and/or hflipped.

Create a new class of controls for querying possible changing camera properties 
like pivoting and aperture.

Regards,

Hans
