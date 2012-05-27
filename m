Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab2E0TzC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 15:55:02 -0400
Message-ID: <4FC28692.9030803@redhat.com>
Date: Sun, 27 May 2012 16:54:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve
 Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <4FC260C2.3060802@redhat.com> <201205271925.51967.hverkuil@xs4all.nl>
In-Reply-To: <201205271925.51967.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-05-2012 14:25, Hans Verkuil escreveu:
> On Sun May 27 2012 19:13:38 Mauro Carvalho Chehab wrote:
>> Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
>>> The Kconfig building system is improperly selecting some drivers,
>>> like analog TV tuners even when this is not required.
>>>
>>> Rearrange the Kconfig in a way to prevent that.
>>>
>>> Mauro Carvalho Chehab (3):
>>>   media: reorganize the main Kconfig items
>>>   media: Remove VIDEO_MEDIA Kconfig option
>>>   media: only show V4L devices based on device type selection
>>>
>>>  drivers/media/Kconfig               |  114 +++++++++++++++++++++++------------
>>>  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
>>>  drivers/media/dvb/frontends/Kconfig |    1 +
>>>  drivers/media/radio/Kconfig         |    1 +
>>>  drivers/media/rc/Kconfig            |   29 ++++-----
>>>  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
>>>  drivers/media/video/m5mols/Kconfig  |    1 +
>>>  drivers/media/video/pvrusb2/Kconfig |    1 -
>>>  drivers/media/video/smiapp/Kconfig  |    1 +
>>>  9 files changed, 181 insertions(+), 107 deletions(-)
>>>
>>
>> The organization between DVB only, V4L only and hybrid devices are somewhat
>> confusing on our tree. From time to time, someone proposes changing one driver
>> from one place to another or complains that "his device is DVB only but it is
>> inside the V4L tree" (and other similar requests). This sometimes happen because
>> the same driver can support analog only, digital only or hybrid devices.
>>
>> Also, one driver may start as a DVB only or as a V4L only and then 
>> it can be latter be converted into an hybrid driver.
>>
>> So, the better is to rearrange the drivers tree, in order to fix this issue,
>> removing them from /video and /dvb, and storing them on a better place.
>>
>> So, my proposal is to move all radio, analog TV, digital TV, webcams and grabber
>> bridge drivers to this arrangement:
>>
>> drivers/media/isa - ISA drivers
>> drivers/media/usb - USB drivers
>> drivers/media/pci - PCI/PCIe drivers
>> drivers/media/platform - platform drivers
> 
> drivers/media/parport

Ok.

> drivers/media/i2c

See below.

> Also, if we do this then I would really like to separate the sub-device drivers
> from the main drivers. I find it very messy that those are mixed.
> 
> So: drivers/media/subdevs
> 
> We might subdivide /subdevs even further (sensors, encoders, decoders, etc.) but
> I am not sure if that is worthwhile.

I think all subdevs (being i2c or not) should be under the same directory.
drivers/media/subdevs seems reasonable.

Sub-dividing them doesn't seem a good idea, as some subdevs may have more than
one function.

> Frankly, the current directory structure (other than the lack of a subdevs
> directory) doesn't bother me. But your proposal is a bit cleaner.

It doesn't bother me either[1], with regards to the existing drivers, but it
is confusing for someone that wants to write a new driver.

[1] with exception to the saa7146 driver under media/common - that looks really
weird.

Also, for example, Antti proposed to add V4L2 support for dvb-usb. I think he
ended by discarding it for his GoC scope of work, but, anyway, with the current
arrangement, that would mean that dvb-usb won't fit well at media/dvb (as all
other hybrid cards aren't there).

So, as we're removing the explicit Kconfig logic for compiling V4L2 core/DVB
core, it makes sense to rearrange the rest of the structure and improve the
building system to better handle the media cards, removing the artificial
and imperfect divisions that it is used there.

Regards,
Mauro
