Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932742AbeFUSuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 14:50:21 -0400
Date: Fri, 22 Jun 2018 03:49:46 +0900
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: <Mario.Limonciello@dell.com>
Cc: <pavel@ucw.cz>, <nicolas@ndufresne.ca>,
        <linux-media@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <niklas.soderlund@ragnatech.se>, <jerry.w.hu@intel.com>
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180622034946.2ae51f1e@vela.lan>
In-Reply-To: <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
References: <20180620203838.GA13372@amd>
        <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
        <20180620211144.GA16945@amd>
        <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Jun 2018 13:41:37 +0000
<Mario.Limonciello@dell.com> escreveu:

> > -----Original Message-----
> > From: Pavel Machek [mailto:pavel@ucw.cz]
> > Sent: Wednesday, June 20, 2018 4:12 PM
> > To: Nicolas Dufresne
> > Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> > niklas.soderlund@ragnatech.se; jerry.w.hu@intel.com; Limonciello, Mario
> > Subject: Re: Software-only image processing for Intel "complex" cameras
> > 
> > Hi!
> >   
> > > > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> > > >
> > > > Meeting notes say that pure software implementation is not fast
> > > > enough, but that it may be useful for debugging. It would be also
> > > > useful for me on N900, and probably useful for processing "raw"
> > > > images
> > > > from digital cameras.
> > > >
> > > > There is sensor part, and memory-to-memory part, right? What is
> > > > the format of data from the sensor part? What operations would be
> > > > expensive on the CPU? If we did everthing on the CPU, what would be
> > > > maximum resolution where we could still manage it in real time?  
> > >
> > > The IPU3 sensor produce a vendor specific form of bayer. If we manage
> > > to implement support for this format, it would likely be done in
> > > software. I don't think anyone can answer your other questions has no
> > > one have ever implemented this, hence measure performance.  
> > 
> > I believe Intel has some estimates.
> > 
> > What is the maximum resolution of camera in the current Dell systems?
> >   
> 
> 5M camera sensor HW spec:
> 2592x1944
> 
> 8M camera sensor HW spec:
> 3264x2448

Looking at the ipu3 driver, I'm wandering how the library would identify
the system components. The way VIDIOC_QUERYCAP is currently implemented
doesn't help at all:

static int cio2_v4l2_querycap(struct file *file, void *fh,
			      struct v4l2_capability *cap)
{
	struct cio2_device *cio2 = video_drvdata(file);

	strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
	strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
	snprintf(cap->bus_info, sizeof(cap->bus_info),
		 "PCI:%s", pci_name(cio2->pci_dev));

	return 0;
}

In order to allow the library to know more about the hardware, it
would likely need to expose some model number to userspace. Ok, userspace
could always call dmidecode, but that requires root privileges. We
really don't want media apps to require root.

So, perhaps caps->cap (or a MC caps equivalent call) should, instead be filled
with values obtained from the BIOS DMI tables with some logic based on
enum dmi_field:

enum dmi_field {
	DMI_NONE,
	DMI_BIOS_VENDOR,
	DMI_BIOS_VERSION,
	DMI_BIOS_DATE,
	DMI_SYS_VENDOR,
	DMI_PRODUCT_NAME,
	DMI_PRODUCT_VERSION,
	DMI_PRODUCT_SERIAL,
	DMI_PRODUCT_UUID,
	DMI_PRODUCT_FAMILY,
	DMI_BOARD_VENDOR,
	DMI_BOARD_NAME,
	DMI_BOARD_VERSION,
	DMI_BOARD_SERIAL,
	DMI_BOARD_ASSET_TAG,
	DMI_CHASSIS_VENDOR,
	DMI_CHASSIS_TYPE,
	DMI_CHASSIS_VERSION,
	DMI_CHASSIS_SERIAL,
	DMI_CHASSIS_ASSET_TAG,
	DMI_STRING_MAX,
};

e. g. something like: 

	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
	board_name = dmi_get_system_info(DMI_BOARD_NAME);
	board_version = dmi_get_system_info(DMI_BOARD_NAME);
	product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
	product_version = dmi_get_system_info(DMI_PRODUCT_VERSION);

	sprintf(dev->cap, "%s:%s:%s:%s", board_vendor, board_name, board_version, product_name, product_version);

(the real code should check if the values are filled, as not all BIOS vendors use the same DMI fields)

With that, the library can auto-adjust without needing to run anything as
root.



Cheers,
Mauro
