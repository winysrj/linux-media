Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19723 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZELHlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 03:41:24 -0400
Date: Tue, 12 May 2009 10:35:35 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Subject: Re: [PATCH v2 0/7] [RFC] FM Transmitter (si4713) and another
	changes
Message-ID: <20090512073535.GF4639@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com> <200905120903.18775.hverkuil@xs4all.nl> <20090512073331.GE4639@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512073331.GE4639@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 09:33:31AM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> On Tue, May 12, 2009 at 09:03:18AM +0200, ext Hans Verkuil wrote:
> > On Monday 11 May 2009 11:31:42 Eduardo Valentin wrote:
> > > Hello all,
> > >
> > > It took a few but I'm resending the FM transmitter driver again.
> > > Sorry for this delay, but I had another things to give attention.
> > >
> > > Anyway, after reading the API and re-writing the code I came up
> > > with the following 7 patches. Three of them are in the v4l2 API.
> > > The other 4 are for the si4713 device.
> > >
> > > It is because of the first 3 patches that I'm sending this as a RFC.
> > >
> > > The first and second patches, as suggested before, are creating another
> > > v4l2 extended controls class, the V4L2_CTRL_CLASS_FMTX. At this
> > > first interaction, I've put all si4713 device extra properties there.
> > > But I think that some of the can be moved to private class
> > > (V4L2_CID_PRIVATE_BASE). That's the case of the region related things.
> > > Comments are wellcome.
> > >
> > > The third patch came *maybe* because I've misunderstood something. But
> > > I realized that the v4l2-subdev helper functions for I2C devices assumes
> > > that the bridge device will create an I2C adaptor. And in that case, only
> > > I2C address and its type are suffient. But in this case, makes no sense
> > > to me to create an adaptor for the si4713 platform device driver. This is
> > > the case where the device (si4713) is connected to an existing adaptor.
> > > That's why I've realized that currently there is no way to pass I2C board
> > > info using the current v4l2 I2C helper functions. Other info like irq
> > > line and platform data are not passed to subdevices. So, that's why I've
> > > created that patch.
> > 
> > I've made several changes to the v4l2-subdev helpers: you now pass the i2c 
> > adapter directly. I've also fixed the unregister code to properly 
> > unregister any i2c client so you can safely rmmod and modprobe the i2c 
> > module.
> 
> Right. I will check those.
> 
> > 
> > What sort of platform data do you need to pass to the i2c driver? I have yet 
> > to see a valid use case for this that can't be handled in a different way. 
> > Remember that devices like this are not limited to fixed platforms, but can 
> > also be used in USB or PCI devices.
> 
> Yes, sure. Well, a simple "set_power" procedure is an example of things that
> I see as platform specific. Which may be passed by platform data structures.
> In some platform a set power / reset line may be done by a simple gpio. but
> in others it may be a different procedure.

Also, the IRQ line value can also be passed to device driver using the i2c
board info. That's another way of use of this i2c board info.

> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > The remaining patches are the si4713 device driver itself. As suggested,
> > > I've splited the driver into i2c driver and v4l2 radio driver. The first
> > > one is exporting it self as a v4l2 subdev as well. Now it is composed by
> > > the si4713.c and si4713-subdev.c. But in the future versions I think I'll
> > > merge both and remove the si4713.c (by reducing lots of things), because
> > > it was mainly designed to be used by the sysfs interface. I've also
> > > keeped the sysfs interface (besides the extended control interface). The
> > > v4l2 radio driver became a platform driver which is mainly a wrapper to
> > > the I2C subdevice. Again here I've found some problem with the device
> > > remove. Because, as the I2C helper function assumes the bridge device
> > > will create an adaptor, then when the bridge removes the adaptor, its
> > > devices will be removed as well. So, when re-inserting the driver,
> > > registration will be good. However, if we use an existing adaptor, then
> > > we need to remove the i2c client manually. Otherwise it will fail when
> > > re-inserting the device.
> > >
> > > As I said before, comments are wellcome. I'm mostly to be
> > > misunderstanding something from the API.
> > >
> > > BR,
> > >
> > > Eduardo Valentin (7):
> > >   v4l2: video device: Add V4L2_CTRL_CLASS_FMTX controls
> > >   v4l2: video device: Add FMTX controls default configurations
> > >   v4l2_subdev i2c: Add i2c board info to v4l2_i2c_new_subdev
> > >   FMTx: si4713: Add files to handle si4713 i2c device
> > >   FMTx: si4713: Add files to add radio interface for si4713
> > >   FMTx: si4713: Add Kconfig and Makefile entries
> > >   FMTx: si4713: Add document file
> > >
> > >  Documentation/video4linux/si4713.txt |  132 ++
> > >  drivers/media/radio/Kconfig          |   22 +
> > >  drivers/media/radio/Makefile         |    3 +
> > >  drivers/media/radio/radio-si4713.c   |  345 ++++++
> > >  drivers/media/radio/radio-si4713.h   |   48 +
> > >  drivers/media/radio/si4713-subdev.c  | 1045 ++++++++++++++++
> > >  drivers/media/radio/si4713.c         | 2250
> > > ++++++++++++++++++++++++++++++++++ drivers/media/radio/si4713.h         |
> > >  295 +++++
> > >  drivers/media/video/v4l2-common.c    |   99 ++-
> > >  include/linux/videodev2.h            |   45 +
> > >  include/media/v4l2-common.h          |    6 +
> > >  11 files changed, 4284 insertions(+), 6 deletions(-)
> > >  create mode 100644 Documentation/video4linux/si4713.txt
> > >  create mode 100644 drivers/media/radio/radio-si4713.c
> > >  create mode 100644 drivers/media/radio/radio-si4713.h
> > >  create mode 100644 drivers/media/radio/si4713-subdev.c
> > >  create mode 100644 drivers/media/radio/si4713.c
> > >  create mode 100644 drivers/media/radio/si4713.h
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > 
> > -- 
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> 
> -- 
> Eduardo Valentin

-- 
Eduardo Valentin
