Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2E1LDt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:03:49 -0400
Message-ID: <4FC35B8E.5060102@redhat.com>
Date: Mon, 28 May 2012 08:03:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve
 Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <c44caeff-5966-4faa-ab3d-5e7be5ad38fd@email.android.com> <4FC28B4C.7050901@redhat.com> <201205281142.20565.hverkuil@xs4all.nl>
In-Reply-To: <201205281142.20565.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 06:42, Hans Verkuil escreveu:
> On Sun May 27 2012 22:15:08 Mauro Carvalho Chehab wrote:
>> Em 27-05-2012 15:47, Andy Walls escreveu:
>>> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>
>>>> On Sun May 27 2012 19:13:38 Mauro Carvalho Chehab wrote:
>>>>> Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
>>>>>> The Kconfig building system is improperly selecting some drivers,
>>>>>> like analog TV tuners even when this is not required.
>>>>>>
>>>>>> Rearrange the Kconfig in a way to prevent that.
>>>>>>
>>>>>> Mauro Carvalho Chehab (3):
>>>>>>   media: reorganize the main Kconfig items
>>>>>>   media: Remove VIDEO_MEDIA Kconfig option
>>>>>>   media: only show V4L devices based on device type selection
>>>>>>
>>>>>>  drivers/media/Kconfig               |  114
>>>> +++++++++++++++++++++++------------
>>>>>>  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
>>>>>>  drivers/media/dvb/frontends/Kconfig |    1 +
>>>>>>  drivers/media/radio/Kconfig         |    1 +
>>>>>>  drivers/media/rc/Kconfig            |   29 ++++-----
>>>>>>  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
>>>>>>  drivers/media/video/m5mols/Kconfig  |    1 +
>>>>>>  drivers/media/video/pvrusb2/Kconfig |    1 -
>>>>>>  drivers/media/video/smiapp/Kconfig  |    1 +
>>>>>>  9 files changed, 181 insertions(+), 107 deletions(-)
>>>>>>
>>>>>
>>>>> The organization between DVB only, V4L only and hybrid devices are
>>>> somewhat
>>>>> confusing on our tree. From time to time, someone proposes changing
>>>> one driver
>>>>> from one place to another or complains that "his device is DVB only
>>>> but it is
>>>>> inside the V4L tree" (and other similar requests). This sometimes
>>>> happen because
>>>>> the same driver can support analog only, digital only or hybrid
>>>> devices.
>>>>>
>>>>> Also, one driver may start as a DVB only or as a V4L only and then 
>>>>> it can be latter be converted into an hybrid driver.
>>>>>
>>>>> So, the better is to rearrange the drivers tree, in order to fix this
>>>> issue,
>>>>> removing them from /video and /dvb, and storing them on a better
>>>> place.
>>>>>
>>>>> So, my proposal is to move all radio, analog TV, digital TV, webcams
>>>> and grabber
>>>>> bridge drivers to this arrangement:
>>>>>
>>>>> drivers/media/isa - ISA drivers
>>>>> drivers/media/usb - USB drivers
>>>>> drivers/media/pci - PCI/PCIe drivers
>>>>> drivers/media/platform - platform drivers
>>>>
>>>> drivers/media/parport
>>>> drivers/media/i2c
>>>>
>>>> Also, if we do this then I would really like to separate the sub-device
>>>> drivers
>>> >from the main drivers. I find it very messy that those are mixed.
>>>>
>>>> So: drivers/media/subdevs
>>>>
>>>> We might subdivide /subdevs even further (sensors, encoders, decoders,
>>>> etc.) but
>>>> I am not sure if that is worthwhile.
>>>>
>>>> Frankly, the current directory structure (other than the lack of a
>>>> subdevs
>>>> directory) doesn't bother me. But your proposal is a bit cleaner.
>>>>
>>>> Regards,
>>>>
>>>> 	Hans
>>>>
>>>>>
>>>>> Comments?
>>>>>
>>>>> Regards,
>>>>> Mauro
>>>>>
>>>>> -
>>>>>
>>>>> PS.: for now, I don't intend to touch at I2C/ancillary drivers. We
>>>> may latter move
>>>>> the i2c drivers that aren't frontend/tuners to media/i2c or to
>>>> media/common.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> Also
>>>
>>> cx2341x and tveeprom
>>
>> cx2341x is a sub-device module. So, it can go to drivers/media/subdevs
>> (ok, it has other problems, but solving them is not as simple as moving
>> things from one place to the other - so let's not mix it here).
> 
> It's not a subdev. It's a helper module, so it should go to common (or 'helpers').
> 
>> The case of tveeprom is different, because it is not really a sub-device.
>>
>> Btw, this file is bad named - it should be called hauppauge-eeprom or
>> something like that. Yet, I wouldn't move it out of drivers/media/video
>> (or at least on this first step).
>>
>> There are other similar cases. for example, btcx-risc is a common module
>> used by both cx88 and bttv drivers to handle the RISC processor that
>> exists on both. This is not a sub-device, so it won't fit on the above
>> structure. . 
>>
>> Maybe we can create a drivers/media/v4l2-core and move everything that
>> belongs to the core into it, and the things that won't fit elsewhere
>> can be moved into drivers/media/common.
> 
> Ack.
> 
>> I would also move tuner, dvb-core and frontend to an upper level:
>>
>> So, in summary, the final structure would be:
>>
>> drivers/media
>> 	/common		- drivers that are "common" to several ones, like tveeprom and btcx-risc
> 
> And saa7146 sources in /common/saa7146. That will (finally!) make sense.
> 
> What can go in here:
> 
> - saa7146
> - tveeprom
> - cx2341x
> - btcx-risc
> - radio-isa
> - smiapp-pll (?)
>
> We should probably also try and get tea575x-tuner.c in here. But that can be
> done in a separate step.
> 
>> 	/dvb-core	- what is already at dvb/dvb-core
>> 	/frontends	- what is already at dvb/frontends
>> 	/isa		- all ISA drivers
>> 	/parport	- all parallel port drivers
> 
> I propose to replace /parport with a /others directory for things of which we
> have only a very few (parport, i2c) or are hard to classify (si470x, vivi,
> mem2mem_testdev).

It makes sense to group those drivers that use other buses together.
However, the term 'other' could have other meanings than "other bus"
or "other drivers".

I think "other-bus" could be an appropriate name for that.

> 
>> 	/pci		- all PCI/PCIe drivers
>> 	/platform	- all platform drivers
>> 	/subdevice	- all sub-device drivers
> 
> Either /subdevices or /subdevs. It should definitely be plural.

I prefer to put all names in singular, but as "frontends" and "tuners" are already
in plural, "subdevices" should follow it.

>> 	/tuner		- what's currently at common/tuners
> 
> Ditto: /tuners
> 
>> 	/usb		- all USB drivers
>> 	/v4l2-core	- V4L2 core
> 
> /media-core for the media*.c sources.


"media-core" is a very bad name, as "media" is the name of the subsystem. maybe
"media-ctrl-core" or something similar.

>>
>> After doing that, the Kconfig options at isa, parport, pci, platform and usb
>> can be optimized further, based on the media support "filters":
>>
>> <m>  Multimedia support  --->
>>     [ ]   Webcams and video grabbers support
>>     [ ]   Analog TV support
>>     [ ]   Digital TV support
>>     [ ]   AM/FM radio receivers/transmitters support
>>     [ ]   Remote Controller support 
> 
> One thing wasn't clear to me: if I have a hybrid device I gathered that it be enabled
> only if both analog and digital are set, right? But is that also true for radio and RC
> support? So if I have a card with all of the above, will it be enabled only if I check
> all four items?

No.

The tendency is to break drivers into RC support, analog TV support and DVB support.
There are several requirements for that, and it actually makes sense to allow disabling
what's not needed.

So, the idea here is that, if only analog TV is selected, only the analog part of a board
will be enabled. For example, if you select only analog TV, this is how the USB menu will
show, for em28xx:

--- V4L USB devices
  *** Webcam and/or TV USB devices ***
  < >   Empia EM28xx USB video capture support (NEW)

(em28xx has the RC part and the DTV part as separate Kconfig options)

Currently, radio will be enabled together with em28xx, but it would be easy to add a logic
inside em28xx-video to disable radio, if RADIO_SUPPORT is disabled.

Unfortunately, all hybrid drivers currently require analog TV, although most of them
implements the analog support on a separate file (foo-video.c). It shouldn't be hard
and it makes sense to split hybrid drivers into a core driver, an analog driver, rc driver
and a dvb driver. I don't think it makes sense to split radio into a separate driver,
but it shouldn't be hard to do that too.

This is actually one of the issues I want to solve: there are several em28xx devices that
don't support analog TV at all. Yet, V4L2 is not selected, the driver won't even appear
to the user.

Of course, just renaming the directories won't help with hybrid cards itself. A further
work is required on each hybrid drivers.

> That doesn't really make sense to me. I think the average end-user just cares about the
> hardware that he wants to enable, and if a hybrid device is selected, then that should
> select all the various core configs that it needs. Not the other way around.

We can add an option for "hybrid TV support" that would enable all 4 cores, in order to
help the average end-user, although I don't think he would have any troubles to understand
that, if his board has analog TV, digital TV and Remote Controller, that all those 3 options
need to be selected, for full device support.

> Another thing: I would move 'video grabber' away from webcams and to 'Analog TV/Video support'.
> And rename 'Digital TV' to 'Digital TV/Video' as well. A video grabber driver has much more to
> do with TV then it does with webcams.

>From the Kconfig perspective, the difference between the 3 video categories is that:

- analog TV: tuner-core is required, and 10 other tuner drivers that are listed inside
  tuner core;

- digital TV: tuners are needed, but those are either customised or auto-selected;

- camera/grabber: no tuner is needed.

Also, there are several professional camera devices at bttv, cx88, saa7134 and cx25821
that don't require tuners, and support for them can be compiled without tuner support.

In other words, a camera driver and a grabber driver are very similar. Of course, a webcam 
will also require a sensor (on several drivers, the sensor is internal to the driver, so
no extra modules are needed). Of course, a platform camera driver will also require
"media controller", "subdev API", but those features are already enabled via other config options.

So, from tuners' perspective, and from Kconfig's perspective, a video grabber is just 
like a professional camera driver, a cellphone camera or a webcam driver.

> But basically I would do away with filters altogether and just present a menu with bus
> type (usb/pci/platform/isa/others) and subdivide each bus either by captions:
> 
> *** Webcams ***
> *** Analog TV/Video Capture ***
> 
> or corresponding submenus. This could be decided based on the number of devices in each
> category.

The Kconfig logic for doing that would be a nightmare, as "select" doesn't auto-select
the dependencies, and a logic using "depends on" would be very hard to maintain.

So, assuming for example, the em28xx Kconfig, the logic would need to be something like:

config VIDEO_EM28XX
	select VIDEO_DEV
	select MEDIA_TUNER

config VIDEO_EM28XX_DVB
	select DVB_CORE

config VIDEO_EM28XX_RC
	select RC_CORE
	
But MEDIA_TUNER selects 11 drivers, so the above won't work, as select doesn't do
dependency check.

Moving all tuner-core dependencies to all analog drivers will be a big and hard-to-maintain
patch, as new tuners are added all the times, and they may require changes for all
boards.

A reverse depends on might be used for it, but then:

config MEDIA_TUNER
	depends on VIDEO_EM28XX || VIDEO_BTTV || ...

would be counter-intuitive for developers and that would bring a long list of dependencies.

Also, if RC_CORE is selected, the RC hardware decoders drivers list
should appear, but the list will only appear after selecting the hardware,
with will look weird and counter-intuitive for the end-user.

So, I don't think we can get rid of asking the user about what core features are
needed by the driver he wants to compile.

Regards,
Mauro

