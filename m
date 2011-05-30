Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1E3NEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 09:04:00 -0400
Message-ID: <4DE395BB.4070505@redhat.com>
Date: Mon, 30 May 2011 10:03:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE237D9.8090306@redhat.com> <201105300854.35246.hverkuil@xs4all.nl>
In-Reply-To: <201105300854.35246.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-05-2011 03:54, Hans Verkuil escreveu:
> On Sunday, May 29, 2011 14:11:05 Mauro Carvalho Chehab wrote:
>> Em 29-05-2011 08:19, Hans Verkuil escreveu:
>>> It's what you expect to see in an application: a list of USB/PCI/Platform
>>> devices to choose from.
>>
>> A missing function is to return the device address, but it should be easy
>> to add it if needed.
> 
> This is the v4l2-sysfs-path output for an ivtv card (PVR-350):
> 
> /sys/class/dvb: No such file or directory
> Video device: video1
>         video: video17 
>         vbi: vbi1 
>         radio: radio1 
> Video device: video17
>         video: video25 
>         vbi: vbi1 
>         radio: radio1 
> Video device: video25
>         video: video33 
>         vbi: vbi1 
>         radio: radio1 
> Video device: video33
>         video: video49 
>         vbi: vbi1 
>         radio: radio1 
> Video device: video49
>         vbi: vbi1 
>         radio: radio1
> 
> This list of 'devices' is pretty useless for apps.

Agreed. There are a few points to notice here:

1) ivtv does a very bad job with video devices, using a non-v4l2-api-compliance
   way of presenting their stuff: it requires userspace applications to know that 
   some video device ranges have special meanings. I think that there are even a few 
   mutually-exclusive video nodes;

2) v4l device namespace is messy: a "video" node can be used by video input, video
   output, webcams, etc. I think we should address that, by working into a new 
   namespace, providing some ways for udev to create aliases for the old namespace;

3) We currently lack the uevent bits at the drivers to allow grouping devices.
   The kernelspace patches are simple, but are needed to allow mapping complex
   scenarios like the ones found at ivtv;

4) Clearly, there's a bug at the library: it should be showing all video/radio/vbi 
   devices for all video nodes. E. g., a loop code like the one currently used inside
   v4l2-sysfs-path should be producing something like:

Video device: video1
        video: video17 video25 video33 video49
        vbi: vbi1 
        radio: radio1 
Video device: video17
        video: video1 video25 video33 video49
        vbi: vbi1 
        radio: radio1 
...

5) For the v4l2-sysfs-path tool itself, their internal logic should be suppressing
   the device group repetitions.

> 
> (BTW: note the initial 'No such file or dir' error at the top: it's perfectly
> fine not to have any dvb devices)

Yes. This is caused by the absence of dvb-core module. We need to suppress such error
message.

> The output of v4l2-sysfs-path -d is much more useful:
> 
> Device pci0000:00/0000:00:14.4/0000:04:05.0:
>         video1(video, dev 81:1) video17(video, dev 81:6) video25(video, dev 81:4) video33(video, dev 81:2) video49(video, dev 81:9) vbi1(vbi, dev 81:3) vbi17(vbi, dev 81:8) vbi9(vbi, dev 81:7) radio1(radio, dev 81:5) 
> 
> Here at least all devices of the PCI card are grouped together.
> 
> While it would be nice to have the device address exported, it isn't enough:
> first of all you want a more abstract API when the app iterates over the hardware
> devices, secondly such an API would map muchmore nicely to the MC, and thirdly
> doing this in the library will allow us to put more intelligence into the code.

The proposed API should work with MC also. Eventually, we'll need more stuff when
MC parser is added there through.

> For example, if I'm not mistaken cx88 devices consist of multiple PCI devices.
> It's not enough to group them by PCI address. You can however add code to this
> library that will detect that it is a cx88 device and attempt to group the
> video/audio/dvb devices together.

We'll need to add some intelligence at the sysfs parser to handle devices with
internal PCI/USB bridges, like cx88. The Sirius USB camera I have here is also
an interesting device: it has internally one USB hub, connected to several
devices:
	- an UVC webcam;
	- one USB audio output device (AVC);
	- one USB external port;
	- one USB HID device, with 3 multimedia buttons (vol up/down and play).

If I plug a V4L device at his USB port, the current code does the wrong thing [1].

[1] I never tested, but I suspect that plugging an extra camera or tv device on
it won't work anyway, due to USB bandwidth requirements, so this may not be a
real usecase, although I'd like to fix this issue later.

> 
> Regards,
> 
> 	Hans

