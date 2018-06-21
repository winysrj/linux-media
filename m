Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49188 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933115AbeFUVkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 17:40:52 -0400
Date: Fri, 22 Jun 2018 06:40:32 +0900
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: <Mario.Limonciello@dell.com>
Cc: <pavel@ucw.cz>, <nicolas@ndufresne.ca>,
        <linux-media@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <niklas.soderlund@ragnatech.se>, <jerry.w.hu@intel.com>,
        <jian.xu.zheng@intel.com>
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180622064032.550f24cb@vela.lan>
In-Reply-To: <20180622060850.3941d9a7@vela.lan>
References: <20180620203838.GA13372@amd>
        <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
        <20180620211144.GA16945@amd>
        <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
        <20180622034946.2ae51f1e@vela.lan>
        <db8d91a47971417da424df7bf67a5cca@ausx13mpc120.AMER.DELL.COM>
        <20180622060850.3941d9a7@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Jun 2018 06:08:50 +0900
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Thu, 21 Jun 2018 18:58:37 +0000
> <Mario.Limonciello@dell.com> escreveu:
> 
> > > -----Original Message-----
> > > From: Mauro Carvalho Chehab [mailto:mchehab+samsung@kernel.org]
> > > Sent: Thursday, June 21, 2018 1:50 PM
> > > To: Limonciello, Mario
> > > Cc: pavel@ucw.cz; nicolas@ndufresne.ca; linux-media@vger.kernel.org;
> > > sakari.ailus@linux.intel.com; niklas.soderlund@ragnatech.se;
> > > jerry.w.hu@intel.com
> > > Subject: Re: Software-only image processing for Intel "complex" cameras
> > > 
> > > Em Thu, 21 Jun 2018 13:41:37 +0000
> > > <Mario.Limonciello@dell.com> escreveu:
> > >   
> > > > > -----Original Message-----
> > > > > From: Pavel Machek [mailto:pavel@ucw.cz]
> > > > > Sent: Wednesday, June 20, 2018 4:12 PM
> > > > > To: Nicolas Dufresne
> > > > > Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> > > > > niklas.soderlund@ragnatech.se; jerry.w.hu@intel.com; Limonciello, Mario
> > > > > Subject: Re: Software-only image processing for Intel "complex" cameras
> > > > >
> > > > > Hi!
> > > > >  
> > > > > > > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> > > > > > >
> > > > > > > Meeting notes say that pure software implementation is not fast
> > > > > > > enough, but that it may be useful for debugging. It would be also
> > > > > > > useful for me on N900, and probably useful for processing "raw"
> > > > > > > images
> > > > > > > from digital cameras.
> > > > > > >
> > > > > > > There is sensor part, and memory-to-memory part, right? What is
> > > > > > > the format of data from the sensor part? What operations would be
> > > > > > > expensive on the CPU? If we did everthing on the CPU, what would be
> > > > > > > maximum resolution where we could still manage it in real time?  
> > > > > >
> > > > > > The IPU3 sensor produce a vendor specific form of bayer. If we manage
> > > > > > to implement support for this format, it would likely be done in
> > > > > > software. I don't think anyone can answer your other questions has no
> > > > > > one have ever implemented this, hence measure performance.  
> > > > >
> > > > > I believe Intel has some estimates.
> > > > >
> > > > > What is the maximum resolution of camera in the current Dell systems?
> > > > >  
> > > >
> > > > 5M camera sensor HW spec:
> > > > 2592x1944
> > > >
> > > > 8M camera sensor HW spec:
> > > > 3264x2448  
> > > 
> > > Looking at the ipu3 driver, I'm wandering how the library would identify
> > > the system components. The way VIDIOC_QUERYCAP is currently implemented
> > > doesn't help at all:
> > > 
> > > static int cio2_v4l2_querycap(struct file *file, void *fh,
> > > 			      struct v4l2_capability *cap)
> > > {
> > > 	struct cio2_device *cio2 = video_drvdata(file);
> > > 
> > > 	strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
> > > 	strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
> > > 	snprintf(cap->bus_info, sizeof(cap->bus_info),
> > > 		 "PCI:%s", pci_name(cio2->pci_dev));
> > > 
> > > 	return 0;
> > > }
> > > 
> > > In order to allow the library to know more about the hardware, it
> > > would likely need to expose some model number to userspace. Ok, userspace
> > > could always call dmidecode, but that requires root privileges. We
> > > really don't want media apps to require root.
> > > 
> > > So, perhaps caps->cap (or a MC caps equivalent call) should, instead be filled
> > > with values obtained from the BIOS DMI tables with some logic based on
> > > enum dmi_field:
> > > 
> > > enum dmi_field {
> > > 	DMI_NONE,
> > > 	DMI_BIOS_VENDOR,
> > > 	DMI_BIOS_VERSION,
> > > 	DMI_BIOS_DATE,
> > > 	DMI_SYS_VENDOR,
> > > 	DMI_PRODUCT_NAME,
> > > 	DMI_PRODUCT_VERSION,
> > > 	DMI_PRODUCT_SERIAL,
> > > 	DMI_PRODUCT_UUID,
> > > 	DMI_PRODUCT_FAMILY,
> > > 	DMI_BOARD_VENDOR,
> > > 	DMI_BOARD_NAME,
> > > 	DMI_BOARD_VERSION,
> > > 	DMI_BOARD_SERIAL,
> > > 	DMI_BOARD_ASSET_TAG,
> > > 	DMI_CHASSIS_VENDOR,
> > > 	DMI_CHASSIS_TYPE,
> > > 	DMI_CHASSIS_VERSION,
> > > 	DMI_CHASSIS_SERIAL,
> > > 	DMI_CHASSIS_ASSET_TAG,
> > > 	DMI_STRING_MAX,
> > > };
> > > 
> > > e. g. something like:
> > > 
> > > 	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
> > > 	board_name = dmi_get_system_info(DMI_BOARD_NAME);
> > > 	board_version = dmi_get_system_info(DMI_BOARD_NAME);
> > > 	product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
> > > 	product_version = dmi_get_system_info(DMI_PRODUCT_VERSION);
> > > 
> > > 	sprintf(dev->cap, "%s:%s:%s:%s", board_vendor, board_name,
> > > board_version, product_name, product_version);
> > > 
> > > (the real code should check if the values are filled, as not all BIOS vendors use the
> > > same DMI fields)
> > > 
> > > With that, the library can auto-adjust without needing to run anything as
> > > root.
> > >   
> > Well actually most of those fields you're interested in are already exposed to userspace
> > through sysfs /sys/class/dmi/id/
> > 
> > Can't the library just pull them from there?
> 
> Good point. Yeah, the library could use them.
> 
> > The one field that isn't exposed is actually the one I think you should key off of though:
> > Product SKU number.  So I would propose as part of this change that should start to get
> > exposed to userspace too.
> > 
> > The reasoning is I'm a little concerned in taking an approach that goes off of marketing model number
> > specifically because it's creating an assumption that all systems with that model number
> > have the exact same components.
> > 
> > It's possible for two systems to have the same model number but to second source for
> > example.  This might not affect complex cameras, but I just want to make sure it's taken
> > into consideration.  At least going off of Product SKU will better narrow it down.
> 
> Yeah, the library should be able to uniquely match whatever components are
> inside a system, and just the marketing model number might not be enough.
> 
> Right now, only dmidecode seems to get SKU number.
> 
> On a quick look, it seems that a patch adding support for it was already
> proposed:
> 	https://lkml.org/lkml/2018/4/24/1166
> 
> And got accepted:
> 	https://lkml.org/lkml/2018/4/27/96 
> 
> So, it seems we'll be covered for newer Kernel versions.

Just occurred to me that this is a major difference about how complex
camera hardware detection should happen. On ARM-based devices, the
hardware topology comes from Open Firmware. It uniquely describes how
the board is wired. That reflects the way the media controller exposes
the hardware, as each platform driver reads a set of properties via
of_property_foo() functions.

On "normal" PCI drivers (bttv, cx88, ...), there's a PCI table filled with
PCI vendor IDs and some complex logic with uses that in order to identify
the hardware components and to load the associated drivers.

With IPU3, the device appears as a PCI device. The driver doesn't do
any of_property_foo() call, nor it has a device table with would be used to
identify what sensor is associated to what device.

So, on a quick look there, I was unable to see how it detects what sensors
are connected to an specific hardware instance and how it would load the
associated sensor drivers.

For us to be able to stick with an example, let's assume the Dell Latitude 5285
laptop [1]. What sensors are present on it? What's its PCI ID?

[1] https://www.spinics.net/lists/linux-usb/msg167478.html
    https://www.spinics.net/lists/linux-usb/msg163617.html


Jerry/Jian,

Could you please shed a light about how a Dell 5285 hardware would be
detected by the IPU3 driver and what MC graph is created by the current
driver?

Cheers,
Mauro
