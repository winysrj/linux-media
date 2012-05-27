Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45824 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108Ab2E0SrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 14:47:20 -0400
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <4FC260C2.3060802@redhat.com> <201205271925.51967.hverkuil@xs4all.nl>
In-Reply-To: <201205271925.51967.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 27 May 2012 14:47:28 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c44caeff-5966-4faa-ab3d-5e7be5ad38fd@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Sun May 27 2012 19:13:38 Mauro Carvalho Chehab wrote:
>> Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
>> > The Kconfig building system is improperly selecting some drivers,
>> > like analog TV tuners even when this is not required.
>> > 
>> > Rearrange the Kconfig in a way to prevent that.
>> > 
>> > Mauro Carvalho Chehab (3):
>> >   media: reorganize the main Kconfig items
>> >   media: Remove VIDEO_MEDIA Kconfig option
>> >   media: only show V4L devices based on device type selection
>> > 
>> >  drivers/media/Kconfig               |  114
>+++++++++++++++++++++++------------
>> >  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
>> >  drivers/media/dvb/frontends/Kconfig |    1 +
>> >  drivers/media/radio/Kconfig         |    1 +
>> >  drivers/media/rc/Kconfig            |   29 ++++-----
>> >  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
>> >  drivers/media/video/m5mols/Kconfig  |    1 +
>> >  drivers/media/video/pvrusb2/Kconfig |    1 -
>> >  drivers/media/video/smiapp/Kconfig  |    1 +
>> >  9 files changed, 181 insertions(+), 107 deletions(-)
>> > 
>> 
>> The organization between DVB only, V4L only and hybrid devices are
>somewhat
>> confusing on our tree. From time to time, someone proposes changing
>one driver
>> from one place to another or complains that "his device is DVB only
>but it is
>> inside the V4L tree" (and other similar requests). This sometimes
>happen because
>> the same driver can support analog only, digital only or hybrid
>devices.
>> 
>> Also, one driver may start as a DVB only or as a V4L only and then 
>> it can be latter be converted into an hybrid driver.
>> 
>> So, the better is to rearrange the drivers tree, in order to fix this
>issue,
>> removing them from /video and /dvb, and storing them on a better
>place.
>> 
>> So, my proposal is to move all radio, analog TV, digital TV, webcams
>and grabber
>> bridge drivers to this arrangement:
>> 
>> drivers/media/isa - ISA drivers
>> drivers/media/usb - USB drivers
>> drivers/media/pci - PCI/PCIe drivers
>> drivers/media/platform - platform drivers
>
>drivers/media/parport
>drivers/media/i2c
>
>Also, if we do this then I would really like to separate the sub-device
>drivers
>from the main drivers. I find it very messy that those are mixed.
>
>So: drivers/media/subdevs
>
>We might subdivide /subdevs even further (sensors, encoders, decoders,
>etc.) but
>I am not sure if that is worthwhile.
>
>Frankly, the current directory structure (other than the lack of a
>subdevs
>directory) doesn't bother me. But your proposal is a bit cleaner.
>
>Regards,
>
>	Hans
>
>> 
>> Comments?
>> 
>> Regards,
>> Mauro
>> 
>> -
>> 
>> PS.: for now, I don't intend to touch at I2C/ancillary drivers. We
>may latter move
>> the i2c drivers that aren't frontend/tuners to media/i2c or to
>media/common.
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Also

cx2341x and tveeprom

are oddballs.  I can't think of any other exceptions at the moment.

Regards,
Andy 
