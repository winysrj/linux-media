Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALLKWLN007090
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:20:32 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALLKHaT011535
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:20:17 -0500
Message-ID: <49272762.80304@hhs.nl>
Date: Fri, 21 Nov 2008 22:25:54 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
	<49253004.4010504@hhs.nl>
	<Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
	<4925BC94.7090008@hhs.nl>
	<Pine.LNX.4.64.0811202306360.3930@banach.math.auburn.edu>
	<49269369.90805@hhs.nl>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

kilgota@banach.math.auburn.edu wrote:
> 
<snip>

>> Uhg, with 352x288 @ 30 fps (and yes some cams can do 30 fps at 
>> 352x288) this translates to 792 ms of each second being used just for 
>> the demosaic phase.
> 
> Yes, I know that some cameras can do 30 fps. I would also assume there 
> are cameras which can do much more than that. So one needs to be more 
> clever.

Well assuming 352x288 @ 30 fps for cams *which send raw bayer* seems like a 
good assumption, anything higher resolution usually uses jpg.

<snip>

>>
>>> Relative image quality of the methods:
>>>
>>> 1. straight bilinear interpolation is lousy on this image. Lots of 
>>> zippering.
>>>
>>
>> Ok, then maybe we do need to get something better.
> 
> If you want to see the results of this on the same photo that I was 
> using for the test, then you should go to my web page 
> www.auburn.edu/~kilgota and look at the comparison photos and also have 
> a look at the article which has done comparisons of the various methods 
> on the same photos, too.
> 

Ok, I went and looked at the article, I do see there is a huge difference 
between plain bi-linear and bi-linear with acrue edge detection. I must say the 
difference between bi-linear with acrue edge detection, and ahd is less 
convincing though.

>> It might just be that your system is slow, but if it turns out that 
>> bayer.c from libv4l is much faster then the bilinear code from 
>> libgphoto2, then IMHO going to AHD is speedwise not a good idea.
> 
> My system is an AMD Sempron 2600+ or 2800+ (forget which, and I am at 
> work, not at home) with 1 M of RAM. Not the fastest thing around, but 
> not slow at all, actually. We will just have to see what the libv4l code 
> does. I don't know yet.

Ok, that should actually be pretty comparable to one of the 2 cores of my dual 
core amd64 when clocked at 1Ghz (the default setting when not more is required, 
yeah for speedstep). So I think that libv4l's bilinear is much faster than, but 
that is not strange as it was written with speed in mind.


> Where I am coming from is, libgphoto2 uses libusb. When a kernel module 
> has "taken over" the device, then as things currently stand, or have 
> stood until recently, libgphoto2 has no access to the device unless and 
> until the kernel module has been rmmod-ed. I understand that there is a 
> partial solution for this. I am trying to figure out how there is a 
> complete solution which would make everyone happy, including users who 
> just want to plug in their cameras.
> 

I understand, but I'm afraid I don't have any answers here, I'm not familiar 
enough with the relevant usb stuff.

>> Basicly whenever we have a video input device, we want to have a 
>> kernel driver, so as to present a standard /dev/videoX device to 
>> userspace, so that all apps written for v4l can use the device.
> 
> Yes, that is quite clear. But insofar as the act of loading the kernel 
> module which creates that device causes the still camera functionality 
> of the same camera to be simultaneously inaccessible to the usual apps 
> which deal with stillcam mode stuff, we have a problem. The worst aspect 
> of the problem is, of course, that we have a bunch of people whom we 
> would like to convince to use our nice operating system, and they do not 
> understand why there has to be a problem because they do not face that 
> kind of problem if they are not using Linux.
> 

All I can say is: again I understand.

>>
>> However we do not want to do video format conversion (let alone 
>> decompression) in kernel space, so if the data is in an exotic format 
>> we simply indicate this in the pixelformat member of the exchanged 
>> structs, and let userspace deal with it.
>>
>> This is where libv4l comes in into play, libv4l is a convenience lib 
>> for applications, which can do conversion for them so that the app 
>> writers do not have to add support for each exotic webcam format 
>> themselves.
> 
> This is obviously a good idea. I can't imagine that anyone would have a 
> problem with it. Certainly, I don't. But my questions were about how to 
> address the userspace-kernelspace conflict which takes place when we try 
> to support dual-purpose devices, in which one of the modes requires 
> kernel support and the other mode does not.
> 

All I can say is: again I understand.

>> libusb does not interact with a kernel module for a specific device, 
>> it interacts directly with the device through the usb subsystem,
> 
> Indeed. The two lines above capture precisely what needs to be 
> addressed. The current situation certainly is described by 'does not.' I 
> am well aware of the 'does not.' Otherwise, I probably would not ask 
> 'why not' or, more precisely, 'what prevents.' So, back to the original 
> problem:
> 
> For a dual-mode device such as most of the cameras that I support in 
> libgphoto2 in stillcam mode, and you are trying to support in webcam 
> mode, this 'does not' causes nasty problems for the user, doesn't it?

Agreed.

> So 
> we should not ignore such difficulties but try to figure out how to 
> avoid them or work around them.

Agreed.

> Thus, possible solutions (at least so I 
> could imagine) are that libusb is changed, so that it is willing to 
> interact with the kernel module, or that the kernel module is so 
> constructed that it can run in some kind of 'pass-through' mode and 
> libusb can go ahead and access the device anyway, or libgphoto2 camera 
> drivers are changed so as to address a kernel module if it is present 
> instead of addressing the device directly through libusb.

I agree (and still understand) but I'm not aware of a way for a device driver 
to give up his claim on an usb device, perhaps such an option exists in the 
kernel usb subsystem, then adding an API to ask v4l to release the device 
should be possible, although IMHO not the best way forward, how I envision this 
to work is:

usb-drivers get 2 new optional driver callbacks which the usb-subsystem can 
call, called :

1) release_device() this returns 0 if the device is not in use, and disallows 
any new users from using the device through the driver (iow disallow new open's 
of /dev/videoX in our case).

2) reclaim_device(), the driver may now use the device again and allow users to 
open it.


The usb kernel<->userspace API used by libusb gets a new API, which makes it 
possible for libusb to send a release request to a driver holding a device

If the driver has release_device implemented and returns 0, the usb subsystem 
will allow libusb to use the device even though there is a driver for it,

When libusb is done with the device (closes the relevant filedescriptors, the 
drivers resume_access() method gets called.

Notes:
1 this is all a figment of my imagination / vaporware.
2 I think we must come up with something more KISS


Ok, so looking for a simpler solution, there is an kernel usb subsystem method 
called:
usb_driver_release_interface()

And another called :
usb_driver_claim_interface()

Using these 2 a driver could release a device when requested and then later 
(when told to) reclaim it.

No idea how well this will work though, and when we solve this completely at 
the driver level we will need some (none generic) driver API for libgphoto2 to 
ask us to release the device (and tell us whem it is ok to reclaim it).

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
