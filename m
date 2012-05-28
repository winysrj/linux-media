Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3650 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2E1JMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 05:12:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
Date: Mon, 28 May 2012 11:12:25 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4FC24E34.3000406@redhat.com> <201205271925.51967.hverkuil@xs4all.nl> <4FC28692.9030803@redhat.com>
In-Reply-To: <4FC28692.9030803@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281112.25626.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun May 27 2012 21:54:58 Mauro Carvalho Chehab wrote:
> Em 27-05-2012 14:25, Hans Verkuil escreveu:
> > On Sun May 27 2012 19:13:38 Mauro Carvalho Chehab wrote:
> >> Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
> >>> The Kconfig building system is improperly selecting some drivers,
> >>> like analog TV tuners even when this is not required.
> >>>
> >>> Rearrange the Kconfig in a way to prevent that.
> >>>
> >>> Mauro Carvalho Chehab (3):
> >>>   media: reorganize the main Kconfig items
> >>>   media: Remove VIDEO_MEDIA Kconfig option
> >>>   media: only show V4L devices based on device type selection
> >>>
> >>>  drivers/media/Kconfig               |  114 +++++++++++++++++++++++------------
> >>>  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
> >>>  drivers/media/dvb/frontends/Kconfig |    1 +
> >>>  drivers/media/radio/Kconfig         |    1 +
> >>>  drivers/media/rc/Kconfig            |   29 ++++-----
> >>>  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
> >>>  drivers/media/video/m5mols/Kconfig  |    1 +
> >>>  drivers/media/video/pvrusb2/Kconfig |    1 -
> >>>  drivers/media/video/smiapp/Kconfig  |    1 +
> >>>  9 files changed, 181 insertions(+), 107 deletions(-)
> >>>
> >>
> >> The organization between DVB only, V4L only and hybrid devices are somewhat
> >> confusing on our tree. From time to time, someone proposes changing one driver
> >> from one place to another or complains that "his device is DVB only but it is
> >> inside the V4L tree" (and other similar requests). This sometimes happen because
> >> the same driver can support analog only, digital only or hybrid devices.
> >>
> >> Also, one driver may start as a DVB only or as a V4L only and then 
> >> it can be latter be converted into an hybrid driver.
> >>
> >> So, the better is to rearrange the drivers tree, in order to fix this issue,
> >> removing them from /video and /dvb, and storing them on a better place.
> >>
> >> So, my proposal is to move all radio, analog TV, digital TV, webcams and grabber
> >> bridge drivers to this arrangement:
> >>
> >> drivers/media/isa - ISA drivers
> >> drivers/media/usb - USB drivers
> >> drivers/media/pci - PCI/PCIe drivers
> >> drivers/media/platform - platform drivers
> > 
> > drivers/media/parport
> 
> Ok.
> 
> > drivers/media/i2c
> 
> See below.
> 
> > Also, if we do this then I would really like to separate the sub-device drivers
> > from the main drivers. I find it very messy that those are mixed.
> > 
> > So: drivers/media/subdevs
> > 
> > We might subdivide /subdevs even further (sensors, encoders, decoders, etc.) but
> > I am not sure if that is worthwhile.
> 
> I think all subdevs (being i2c or not) should be under the same directory.
> drivers/media/subdevs seems reasonable.

What I meant with media/i2c was not for subdevices but for a few drivers that are
pure i2c V4L drivers (radio-tea5764.c, radio-si470x-i2c.c).

I am not sure whether we should bother though. What might be more useful is to
have a 'others' subdirectory containing 'odds 'n ends' like parport and i2c drivers,
and also drivers like the radio-si470x which comes in a i2c (as I mentioned above)
and a usb variant and so is hard to classify (and splitting it up doesn't seem useful).

> Sub-dividing them doesn't seem a good idea, as some subdevs may have more than
> one function.

I agree (for now :-) ).

> > Frankly, the current directory structure (other than the lack of a subdevs
> > directory) doesn't bother me. But your proposal is a bit cleaner.
> 
> It doesn't bother me either[1], with regards to the existing drivers, but it
> is confusing for someone that wants to write a new driver.
> 
> [1] with exception to the saa7146 driver under media/common - that looks really
> weird.

Things like saa7146, cx2341x, tveeprom, radio-isa are all helper modules for
particular types of hardware. So they should go to a 'common' or 'helpers'
directory.

> Also, for example, Antti proposed to add V4L2 support for dvb-usb. I think he
> ended by discarding it for his GoC scope of work, but, anyway, with the current
> arrangement, that would mean that dvb-usb won't fit well at media/dvb (as all
> other hybrid cards aren't there).
> 
> So, as we're removing the explicit Kconfig logic for compiling V4L2 core/DVB
> core, it makes sense to rearrange the rest of the structure and improve the
> building system to better handle the media cards, removing the artificial
> and imperfect divisions that it is used there.

Go for it!

:-)

Regards,

	Hans
