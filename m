Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49932 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab2FYWdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 18:33:11 -0400
Received: by dady13 with SMTP id y13so5934049dad.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 15:33:10 -0700 (PDT)
Date: Mon, 25 Jun 2012 15:33:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>
Subject: Re: Need of an ".async_probe()" type of callback at driver's core -
 Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
Message-ID: <20120625223306.GA2764@kroah.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com>
 <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE8CED5.104@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 05:49:25PM -0300, Mauro Carvalho Chehab wrote:
> Greg,
> 
> Basically, the recent changes at request_firmware() exposed an issue that
> affects all media drivers that use firmware (64 drivers).

What change was that?  How did it break anything?

> Driver's documentation at Documentation/driver-model/driver.txt says that the
> .probe() callback should "bind the driver to a given device.  That includes 
> verifying that the device is present, that it's a version the driver can handle, 
> that driver data structures can be allocated and initialized, and that any
> hardware can be initialized".

Yes.

> All media device drivers are complaint with that, returning 0 on success
> (meaning that the device was successfully probed) or an error otherwise.

Great, no probems then :)

> Almost all media devices are made by a SoC or a RISC CPU that works
> as a DMA engine and exposes a set of registers to allow I2C access to the
> device's internal and/or external I2C buses. Part of them have an internal
> EEPROM/ROM that stores firmware internally at the board, but others require
> a firmware to be loaded before being able to init/control the device and to
> export the I2C bus interface.
> 
> The media handling function is then implemented via a series of I2C devices[1]:
> 	- analog video decoders;
> 	- TV tuners;
> 	- radio tuners;
> 	- I2C remote controller decoders;
> 	- DVB frontends;
> 	- mpeg decoders;
> 	- mpeg encoders;
> 	- video enhancement devices;
> 	...
> 
> [1] several media chips have part of those function implemented internally,
> but almost all require external I2C components to be probed.
> 
> In order to properly refer to each component, we call the "main" kernel module
> that talks with the media device via USB/PCI bus is called "bridge driver", 
> and the I2C components are called as "sub-devices".
> 
> Different vendors use the same bridge driver to work with different sub-devices.
> 
> It is a .probe()'s task to detect what sub-devices are there inside the board.
> 
> There are several cases where the vendor switched the sub-devices without
> changing the PCI ID/USB ID.

Hardware vendors suck, we all know that :(

> So, drivers do things like the code below, inside the .probe() callback:
> 
> static int check_if_dvb_frontend_is_supported_and_bind()
> {
> 	switch (device_model) {
> 	case VENDOR_A_MODEL_1:
> 		if (test_and_bind_frontend_1())	/* Doesn't require firmware */
> 			return 0;
> 		if (test_and_bind_frontend_2())	/* requires firmware "foo" */
> 			return 0;
> 		if (test_and_bind_frontend_3())	/* requires firmware "bar" */
> 			return 0;

Wait, why would these, if they require firmware, not load the firmware
at this point in time?  Why are they saying "all is fine" here?

> 		if (test_and_bind_frontend_4()) /* doesn't require firmware */
> 			return 0;
> 		break;
> 	case VENDOR_A_MODEL_2:
> 		/* Analog device - no DVB frontend on it */
> 		return 0;
> 	...
> 	}
> 	return -ENODEV;
> }
> 
> On several devices, before being able to register the bus and do the actual
> probe, the kernel needs to load a firmware.

That's common.

> Also, during the I2C device probing time, firmware may be required, in order
> to properly expose the device's internal models and their capabilities. 
> 
> For example, drx-k sub-device can have support for either DVB-C or DVB-T or both,
> depending on the device model. That affects the frontend properties exposed 
> to the user and might affect the bridge driver's initialization task.
> 
> In practice, a driver like em28xx have a few devices like HVR-930C that require
> the drx-k sub-device. For those devices, a firmware is required; for other
> devices, a firmware is not required.
> 
> What's happening is that newer versions of request_firmware and udev are being
> more pedantic (for a reason) about not requesting firmwares during module_init
> or PCI/USB register's probe callback.

It is?  What changed to require this?  What commit id?

> Worse than that, the same device driver may require a firmware or not, depending on
> the I2C devices inside it. One such example is em28xx: for the great majority of
> the supported devices, no firmware is needed, but devices like HVR-930C require
> a firmware, because it uses a frontend that needs firmware.
> 
> After some discussions, it seems that the best model would be to add an async_probe()
> callback to be used by devices similar to media ones. The async_probe() should be
> not probed during the module_init; the probe() will be deferred to happen later,
> when firmware's usermodehelper_disabled is false, allowing those drivers to load their
> firmwares if needed.
> 
> What do you think?

We already have deferred probe() calls, you just need to return a
different value (can't remember it at the moment), and your probe
function will be called again at a later time after the rest of the
devices in the system have been initialized.  Can that work for you?

Or, if you "know" you are going to accept this device, just return 0
from probe() after spawning a workqueue or thread to load the firmware
properly and do everything else you need to do to initialize.  If
something bad happens, unbind your device with a call to unbind things.

thanks,

greg k-h
