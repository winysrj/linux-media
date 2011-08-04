Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1HDTLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 15:11:41 -0400
Message-ID: <4E3AEEE3.8080704@redhat.com>
Date: Thu, 04 Aug 2011 16:11:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <alpine.LNX.2.00.1108031750241.16520@banach.math.auburn.edu> <4E3A91D1.1040000@redhat.com> <alpine.LNX.2.00.1108041255070.17533@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108041255070.17533@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 15:37, Theodore Kilgore escreveu:
>>> Yes, that kind of thing is an obvious problem. Actually, though, it may be 
>>> that this had just better not happen. For some of the hardware that I know 
>>> of, it could be a real problem no matter what approach would be taken. For 
>>> example, certain specific dual-mode cameras will delete all data stored on 
>>> the camera if the camera is fired up in webcam mode. To drop Gphoto 
>>> suddenly in order to do the videoconf call would, on such cameras, result 
>>> in the automatic deletion of all photos on the camera even if those photos 
>>> had not yet been downloaded. Presumably, one would not want to do that. 
>>
> 
> Some of the sq905 cameras in particular will do this. It depends upon the 
> firmware version. Indeed, for those which do, the same USB command which 
> starts streaming is exploited in the Gphoto driver for deletion of all 
> photos stored on the camera. For the other firmware versions, there is in 
> fact no way to delete all the photos, except to push buttons on the camera 
> case. This is by the way a typical example of the very rudimentary, 
> minimalist interface of some of these cheap cameras.
> 
>> So, in other words, the Kernel driver should return -EBUSY if on such
>> cameras, if there are photos stored on them, and someone tries to stream.
> 
> Probably, this should work the other way around, too. If not, then there 
> is the question of closing the streaming in some kind of orderly fashion.

Yes.

>>>> IMO, the right solution is to work on a proper snapshot mode, in kernelspace,
>>>> and moving the drivers that have already a kernelspace out of Gphoto.
>>>
>>> Well, the problem with that is, a still camera and a webcam are entirely 
>>> different beasts. Still photos stored in the memory of an external device, 
>>> waiting to be downloaded, are not snapshots. Thus, access to those still 
>>> photos is not access to snapshots. Things are not that simple.
>>
>> Yes, stored photos require a different API, as Hans pointed. 
> 
> Yes again. His observations seem to me to be saying exactly the same thing 
> that I did.
> 
>> I think that some cameras
>> just export them as a USB storage. For those, we may eventually need some sort of locking
>> between the USB storage and V4L.
> 
> I can imagine that this could be the case. Also, to be entirely logical, 
> one might imagine that a PTP camera could be fired up in streaming mode, 
> too. I myself do not know of any cameras which are both USB storage and 
> streaming cameras. In fact, as I understand the USB classes, such a thing 
> would be in principle forbidden.

It is possible to use a single USB ID, and having two (or more) interfaces
there, each belonging to a different USB class. Anyway, while abstracting
the proper solution, it is safer to consider it as a possible scenario.

> However, the practical consequence could 
> be that sooner or later someone is going to do just that and that deviant 
> hardware is going to sell like hotcakes and we are going to get pestered. 

Yes.

>>
>>>> That's said, there is a proposed topic for snapshot buffer management. Maybe
>>>> it may cover the remaining needs for taking high quality pictures in Kernel.
>>>
>>> Again, when downloading photo images which are _stored_ on the camera one 
>>> is not "taking high quality pictures." Different functionality is 
>>> involved. This may involve, for example, a different Altsetting for the 
>>> USB device and may also require the use of Bulk transport instead of 
>>> Isochronous transport. 
>>
>> Ok. The gspca driver supports it already. All we need to do is to implement a
>> proper API for retrieving still photos.
> 
> Yes, I believe that Hans has some idea to do something like this:
> 
> 1. kernel module creates a stillcam device as well as a /dev/video, for 
> those cameras for which it is appropriate
> 
> 2. libgphoto2 driver is modified so as to access /dev/camera through the 
> kernel, instead of talking to the camera through libusb.
> 
> Hans has written some USB Mass Storage digital picture frame drivers for 
> Gphoto, which do something similar. 

The above strategy seems OK for me.

>>
>>>> The hole idea is to allocate additional buffers for snapshots, imagining that
>>>> the camera may be streaming in low quality/low resolution, and, once snapshot
>>>> is requested, it will take one high quality/high resolution picture.
>>>
>>> The ability to "take" a photo is present on some still cameras and not on 
>>> others. "Some still cameras" includes some dual-mode cameras. For 
>>> dual-mode cameras which can be requested to "take" a photo while running 
>>> in webcam mode, the ability to do so is, generally speaking, present in 
>>> the kernel driver.
>>>
>>> To present the problem more simply, a webcam is, essentially, a device of 
>>> USB class Video (even if the device uses proprietary protocols, this is at 
>>> least conceptually true). This is true because a webcam streams 
>>> video data. However, a still camera is, in its essence as a 
>>> computer peripheral, a USB mass storage device (even if the device has a 
>>> proprietary protocol and even if it will not do everything one would 
>>> expect from a normal mass storage device). That is, a still camera can be 
>>> considered as a device which contains data, and one needs to get the data 
>>> from there to the computer, and then to process said data. It is when the 
>>> two different kinds of device are married together in one piece of 
>>> physical hardware, with the same USB Vendor:Product code, that trouble 
>>> follows. 
>>
>> We'll need to split the problem on all possible alternatives, as the solution
>> may be different for each.
> 
> That, I think, is true.
> 
>>
>> If I understood you well, there are 4 possible ways:
>>
>> 1) UVC + USB mass storage;
>> 2) UVC + Vendor Class mass storage;
> 
> The two above are probably precluded by the USB specs. Which might mean 
> that somebody is going to do that anyway, of course. So far, in the rare 
> cases that such a thing has come up, the device itself is a "good citizen" 
> in that it has two Vendor:Product codes, not just one, and something has 
> to be done (pushing physical buttons, or so) to make it be seen as the 
> "other kind of device" when it is plugged to the computer. 

Some of the em28xx devices export Audio Vendor Class and Vendor Class for video
both using the same USB ID (but on different interfaces). Kernel handles such
devices fine: for each interface, it probes the driver again. So, snd-usb-audio
handles the audio device, and em28xx handles the video part. In this specific
example, the devices are well behaviored, as the USB driver doesn't need to share
any kind of resource locking with the video driver. The cx231xx chips use a
similar approach, except that one device is for Remote Controller (an HID-like MCE
vendor class interface), and the other one is for video and audio.

Yet, I don't doubt that we may find bad behaviored citizens there.

>> 3) Vendor Class video + USB mass storage;
> 
> Probably the same as the two items above.
> 
>> 4) Vendor Class video + Vendor Class mass storage.
> 
> This one is where practically all of the trouble occurs. Vendor Class 
> means exactly that the manufacturer can do whatever seems clever, or 
> cheap, and they do.

So, we need to solve this problem first.

>> For (1) and (3), it doesn't make sense to re-implement USB mass storage 
>> on V4L. We may just need some sort of resource locking, if the device 
>> can't provide both ways at the same time.
>>
>> For (2) and (4), we'll need an extra API like what Hans is proposing, 
>> plus a resource locking schema.
> 
> As I said, it is difficult for me to imagine how all four cases can or 
> will come up in practice. But it probably is good to include them, at 
> least conceptually.

Yes.

>>
>> That's said, "resource locking" is currently one big problem we need to 
>> solve on the media subsystem.
>>
>> We have already some problems like that on devices that implement both 
>> V4L and DVB API's. For example, you can't use the same tuner to watch 
>> analog and digital TV at the same time. Also, several devices have I2C 
>> switches. You can't, for example, poll for a RC code while the I2C 
>> switch is opened for tuner access.
>>
>> This is the same kind of problem, for example, that happens with 3G 
>> modems that can work either as USB storage or as modem.
> 
> Yes. It does. And the matter has given similar headaches to the 
> mass-storage people, which, I understand, are at least partially 
> addressed.

Yes, but I'm not sure if it was properly addressed. I have one device here
that has 3 different functions: USB mass storage, 3G modem and ISDB-T digital
TV. Currently, it has no Linux Driver, so, I'm not sure what are the common
resources, but this probably means that some manufacturers are integrating
more functions into a single device. I won't doubt that the current approach
will fail with more devices.

> But this underscores one of my original points: this 
> is a general problem, not exclusively confined to cameras or to media 
> support. The fundamental problem is to deal with hardware which sits in 
> two categories and does two different things. 

Yes.

>>
>> This sounds to be a good theme for the Workshop, or even to KS/2011.
> 
> Thanks. Do you recall when and where is KS/2011 going to take place?

The media workshop happens together with the KS/2011. Sunday is an
exclusive day for the workshops, Monday is an exclusive day for KS/2011,
and Tuesday is a joint day for both KS and the KS workshops.

Regards,
Mauro
