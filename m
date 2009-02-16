Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZBPPUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 10:20:24 -0500
Message-ID: <49998527.3000707@redhat.com>
Date: Mon, 16 Feb 2009 16:24:23 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
References: <53216.62.70.2.252.1234775259.squirrel@webmail.xs4all.nl>	<49993563.80607@redhat.com>	<20090216081143.05dafb14@pedra.chehab.org>	<499959E3.3030903@redhat.com> <20090216120010.6eac2cc5@pedra.chehab.org>
In-Reply-To: <20090216120010.6eac2cc5@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Mauro Carvalho Chehab wrote:
> On Mon, 16 Feb 2009 13:19:47 +0100
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
> Hans,
> 
>> Mauro Carvalho Chehab wrote:
>>> On Mon, 16 Feb 2009 10:44:03 +0100
>>> Hans de Goede <hdegoede@redhat.com> wrote:
>>>
>>>> I've discussed this with Laurent Pinchart (and other webcam driver authors) and 
>>>> the conclusion was that having a table of USB-ID's + DMI strings in the driver, 
>>>> and design an API to tell userspace to sensor is upside down and have code for 
>>>> all this both in the driver and in userspace makes no sense. Esp since such a 
>>>> table will probably be more easy to update in userspace too. So the conclusion 
>>>> was to just put the entire table of cams with known upside down mounted sensors 
>>>> in userspace. This is currently in libv4l and making many philips webcam users 
>>>> happy (philips has a tendency to mount the sensor upside down).
>>> Are you saying that you have a table at libv4l for what cameras have sensors
>>> flipped? 
>> Yes.
>>
>>> This is really ugly and proofs that the api is broken. No userspace
>>> application or library should need to do any special hack based on usb id,
>>> driver name or querycap names.
>> Well libv4l is already pretty full of cam specific knowledge in the form of 
>> decompression algorithm's etc.
> 
> That's bad. Not all approaches use libv4l, unfortunately. It will take time to
> port all userspace apps to use it

Quite a bit of work has been done there in F-10, all applications are ported 
except for kopete. And kopete is being worked on.

> and maybe some driver authors will never
> accept libv4l.

So far all I've had contact with have been cheering about it. They are all very 
happy there is a solution to move decompression out of kernelspace. Remember 
this all started to move decompression out of userspace.

 > We are too late with the userspace library. This should have been
> released together with the first V4L2 API, in order to have a broad acceptance.

As we do more and more stuff in libv4l applications will have to use libv4l, 
for example to work with a lot of the webcams supported by the new gspca, they 
need to either reimplement the decompression code for pac207 pac73100 spca501 
spca505 spca507 spca561 and others I forget, or use libv4l.

Also currently I've patches pending to add support for software whitebalance 
correction for cams which need this.

> Due to that, instead of having the info on just one place (at kernel), we will
> split this info on other places. This will lead to inconsistent support,
> depending on what app you're using.

Apps not using libv4l will in general not work with many many cams. For example 
quite a few cheaper UVC cams produce YUYV packed pixel format data many apps 
cannot handle this.

> Since those info are about the hardware characteristics, IMO, kernel driver
> should provide such info.
> 

That is something I agree with, and was my first way of looking at this too, 
but Laurent managed to convince me that there is little use of having a table 
in kernelspace if all that is done with it is export it to userspace and 
kernelspace does nothing with it. Thats just obfuscation for no good reasons 
and added (kernel!) code for no good reasons.

<snip>

>> I've discussed this with Laurent Pinchart, and it really makes the most sense 
>> to do this in userspace.
>>
>> Userspace approach:
>> 1 table is in userspace, libv4l reads it directly, done.
>>
>> Kernelspace approach:
>> 1 add a (smaller) table to *each* driver (which the driver has 0 use for)
>> 2 add code to *each* driver to export this info
>> 3 add code to libv4l to read this
>>
>> You've just created a kernel round trip for no good reason at all, and added a 
>> significant amount of code to the kernel, which can live in userspace just as 
>> well. The userspace approach is the KISS way. Also it is far easier for people 
>> to upgrade libv4l, then it is to upgrade a kernel. Given that this table will 
>> most likely change regulary the ease of updating is another argument for doing 
>> this in userspace.
> 
> I don't agree. Having an userspace library so closely bound to the kernelspace
> counterpart just increases overall support troubles. 
> 
> For example, consider adding support for camera FOO, that is mounted with 180
> degrees at the kernel driver, on the trivial case where the new cam is just a
> new USB ID to an existing driver/chipset.
> 

The trivial case now a days is its a UVC cam, which works by USB class so no 
changes to the kernel are needed at all, unless the table of upside down 
devices lives in the kernel. See why it is a bad idea to have this in the kernel ?

> With a combined userspace/kernelspace, you will need to upgrade both
> kernelspace AND userspace, in order to properly support this cam.
> 

Nope, only libv4l will need to be updated. Now one can argue that the table 
should move from libv4l to a config file, then only a config file would need to 
be updated.

> This also means more work to distro, since libv4l should depend on the kernel
> version, and it will need to check, at runtime, for each driver specific
> version, complaining if libv4l finds a kernel driver newer than libv4l or a
> unknown kernel driver, and providing backport support for older kernels.
> 

Huh? The only match between libv4l and kernel there needs to be is that if the 
webcam produces exotic pixel format foo, you need a libv4l which supports 
exotic pixel format foo, and that is something which we cannot change. Besides 
that there is little need to match libv4l and kernel versions.

> With a kernel only approach, you only need to set the rotation flag at the
> kernel driver. Userspace will work fine with the older and newer kernel
> versions, since all info that userspace needs are the capability flags (or
> controls) for that device.
> 

And support to decompress the data if compressed, which is a much bigger issue.

>> Also can we please STOP with coming up of new and novel ways of abusing the 
>> control API, the control API's purpose is for userspace to control v4l device 
>> settings. It is way overkill for things like communicating a few simple flags 
>> to userspace (and is a pain to use for things like that both on the kernel and 
>> the userspace side).
> 
> In the case of sensors mounted rotated or flipped, I agree that the control API
> is not the better approach. This is better fitted by a capability flag. Hans
> proposal to connect it to the input information seems interesting.
> 
> What would be the other capabilities flag that we need, in order to provide
> enough info to libv4l for it to not need to check for USB ID codes?

At the moment, nothing only rotation info is used, in the future a lot, things 
like "could benefit from software whitebalance" and other flags for future 
image enhancement algorithms come to mind.

Note that this is another argument for having the table in libv4l, as libv4l 
grows new (much asked for) functions, it is very beneficial to have the table 
with flags deciding which functions to enable on which cams inside the lib, 
this way I can push an update to Fedora of just libv4l and all users all of a 
sudden stop getting very blue or green ish pictures from their (cheap) webcam.

Regards,

Hans
