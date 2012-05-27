Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2E0UPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 16:15:13 -0400
Message-ID: <4FC28B4C.7050901@redhat.com>
Date: Sun, 27 May 2012 17:15:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve
 Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <4FC260C2.3060802@redhat.com> <201205271925.51967.hverkuil@xs4all.nl> <c44caeff-5966-4faa-ab3d-5e7be5ad38fd@email.android.com>
In-Reply-To: <c44caeff-5966-4faa-ab3d-5e7be5ad38fd@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-05-2012 15:47, Andy Walls escreveu:
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> On Sun May 27 2012 19:13:38 Mauro Carvalho Chehab wrote:
>>> Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
>>>> The Kconfig building system is improperly selecting some drivers,
>>>> like analog TV tuners even when this is not required.
>>>>
>>>> Rearrange the Kconfig in a way to prevent that.
>>>>
>>>> Mauro Carvalho Chehab (3):
>>>>   media: reorganize the main Kconfig items
>>>>   media: Remove VIDEO_MEDIA Kconfig option
>>>>   media: only show V4L devices based on device type selection
>>>>
>>>>  drivers/media/Kconfig               |  114
>> +++++++++++++++++++++++------------
>>>>  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
>>>>  drivers/media/dvb/frontends/Kconfig |    1 +
>>>>  drivers/media/radio/Kconfig         |    1 +
>>>>  drivers/media/rc/Kconfig            |   29 ++++-----
>>>>  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
>>>>  drivers/media/video/m5mols/Kconfig  |    1 +
>>>>  drivers/media/video/pvrusb2/Kconfig |    1 -
>>>>  drivers/media/video/smiapp/Kconfig  |    1 +
>>>>  9 files changed, 181 insertions(+), 107 deletions(-)
>>>>
>>>
>>> The organization between DVB only, V4L only and hybrid devices are
>> somewhat
>>> confusing on our tree. From time to time, someone proposes changing
>> one driver
>>> from one place to another or complains that "his device is DVB only
>> but it is
>>> inside the V4L tree" (and other similar requests). This sometimes
>> happen because
>>> the same driver can support analog only, digital only or hybrid
>> devices.
>>>
>>> Also, one driver may start as a DVB only or as a V4L only and then 
>>> it can be latter be converted into an hybrid driver.
>>>
>>> So, the better is to rearrange the drivers tree, in order to fix this
>> issue,
>>> removing them from /video and /dvb, and storing them on a better
>> place.
>>>
>>> So, my proposal is to move all radio, analog TV, digital TV, webcams
>> and grabber
>>> bridge drivers to this arrangement:
>>>
>>> drivers/media/isa - ISA drivers
>>> drivers/media/usb - USB drivers
>>> drivers/media/pci - PCI/PCIe drivers
>>> drivers/media/platform - platform drivers
>>
>> drivers/media/parport
>> drivers/media/i2c
>>
>> Also, if we do this then I would really like to separate the sub-device
>> drivers
>>from the main drivers. I find it very messy that those are mixed.
>>
>> So: drivers/media/subdevs
>>
>> We might subdivide /subdevs even further (sensors, encoders, decoders,
>> etc.) but
>> I am not sure if that is worthwhile.
>>
>> Frankly, the current directory structure (other than the lack of a
>> subdevs
>> directory) doesn't bother me. But your proposal is a bit cleaner.
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Comments?
>>>
>>> Regards,
>>> Mauro
>>>
>>> -
>>>
>>> PS.: for now, I don't intend to touch at I2C/ancillary drivers. We
>> may latter move
>>> the i2c drivers that aren't frontend/tuners to media/i2c or to
>> media/common.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Also
> 
> cx2341x and tveeprom

cx2341x is a sub-device module. So, it can go to drivers/media/subdevs
(ok, it has other problems, but solving them is not as simple as moving
things from one place to the other - so let's not mix it here).

The case of tveeprom is different, because it is not really a sub-device.

Btw, this file is bad named - it should be called hauppauge-eeprom or
something like that. Yet, I wouldn't move it out of drivers/media/video
(or at least on this first step).

There are other similar cases. for example, btcx-risc is a common module
used by both cx88 and bttv drivers to handle the RISC processor that
exists on both. This is not a sub-device, so it won't fit on the above
structure. . 

Maybe we can create a drivers/media/v4l2-core and move everything that
belongs to the core into it, and the things that won't fit elsewhere
can be moved into drivers/media/common.

I would also move tuner, dvb-core and frontend to an upper level:

So, in summary, the final structure would be:

drivers/media
	/common		- drivers that are "common" to several ones, like tveeprom and btcx-risc
	/dvb-core	- what is already at dvb/dvb-core
	/frontends	- what is already at dvb/frontends
	/isa		- all ISA drivers
	/parport	- all parallel port drivers
	/pci		- all PCI/PCIe drivers
	/platform	- all platform drivers
	/subdevice	- all sub-device drivers
	/tuner		- what's currently at common/tuners
	/usb		- all USB drivers
	/v4l2-core	- V4L2 core

After doing that, the Kconfig options at isa, parport, pci, platform and usb
can be optimized further, based on the media support "filters":

<m>  Multimedia support  --->
    [ ]   Webcams and video grabbers support
    [ ]   Analog TV support
    [ ]   Digital TV support
    [ ]   AM/FM radio receivers/transmitters support
    [ ]   Remote Controller support 

Comments?

Mauro
