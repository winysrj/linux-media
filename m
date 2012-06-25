Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab2FYUrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 16:47:17 -0400
Message-ID: <4FE8CE48.3050508@redhat.com>
Date: Mon, 25 Jun 2012 17:47:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>
Subject: Need of an ".async_probe()" type of callback at driver's core - Was:
 Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
In-Reply-To: <4FE8C4C4.1050901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg,

Basically, the recent changes at request_firmware() exposed an issue that
affects all media drivers that use firmware (64 drivers).

Driver's documentation at Documentation/driver-model/driver.txt says that the
.probe() callback should "bind the driver to a given device.  That includes 
verifying that the device is present, that it's a version the driver can handle, 
that driver data structures can be allocated and initialized, and that any
hardware can be initialized".

All media device drivers are complaint with that, returning 0 on success
(meaning that the device was successfully probed) or an error otherwise.

Almost all media devices are made by a SoC or a RISC CPU that works
as a DMA engine and exposes a set of registers to allow I2C access to the
device's internal and/or external I2C buses. Part of them have an internal
EEPROM/ROM that stores firmware internally at the board, but others require
a firmware to be loaded before being able to init/control the device and to
export the I2C bus interface.

The media handling function is then implemented via a series of I2C devices[1]:
	- analog video decoders;
	- TV tuners;
	- radio tuners;
	- I2C remote controller decoders;
	- DVB frontends;
	- mpeg decoders;
	- mpeg encoders;
	- video enhancement devices;
	...

[1] several media chips have part of those function implemented internally,
but almost all require external I2C components to be probed.

In order to properly refer to each component, we call the "main" kernel module
that talks with the media device via USB/PCI bus is called "bridge driver", 
and the I2C components are called as "sub-devices".

Different vendors use the same bridge driver to work with different sub-devices.

It is a .probe()'s task to detect what sub-devices are there inside the board.

There are several cases where the vendor switched the sub-devices without
changing the PCI ID/USB ID.

So, drivers do things like the code below, inside the .probe() callback:

static int check_if_dvb_frontend_is_supported_and_bind()
{
	switch (device_model) {
	case VENDOR_A_MODEL_1:
		if (test_and_bind_frontend_1())	/* Doesn't require firmware */
			return 0;
		if (test_and_bind_frontend_2())	/* requires firmware "foo" */
			return 0;
		if (test_and_bind_frontend_3())	/* requires firmware "bar" */
			return 0;
		if (test_and_bind_frontend_4()) /* doesn't require firmware */
			return 0;
		break;
	case VENDOR_A_MODEL_2:
		/* Analog device - no DVB frontend on it */
		return 0;
	...
	}
	return -ENODEV;
}

On several devices, before being able to register the bus and do the actual
probe, the kernel needs to load a firmware.

Also, during the I2C device probing time, firmware may be required, in order
to properly expose the device's internal models and their capabilities. 

For example, drx-k sub-device can have support for either DVB-C or DVB-T or both,
depending on the device model. That affects the frontend properties exposed 
to the user and might affect the bridge driver's initialization task.

In practice, a driver like em28xx have a few devices like HVR-930C that require
the drx-k sub-device. For those devices, a firmware is required; for other
devices, a firmware is not required.

What's happening is that newer versions of request_firmware and udev are being
more pedantic (for a reason) about not requesting firmwares during module_init
or PCI/USB register's probe callback.

Worse than that, the same device driver may require a firmware or not, depending on
the I2C devices inside it. One such example is em28xx: for the great majority of
the supported devices, no firmware is needed, but devices like HVR-930C require
a firmware, because it uses a frontend that needs firmware.

After some discussions, it seems that the best model would be to add an async_probe()
callback to be used by devices similar to media ones. The async_probe() should be
not probed during the module_init; the probe() will be deferred to happen later,
when firmware's usermodehelper_disabled is false, allowing those drivers to load their
firmwares if needed.

What do you think?

Regards,
Mauro

Em 25-06-2012 17:06, Mauro Carvalho Chehab escreveu:
> Em 25-06-2012 16:15, Antti Palosaari escreveu:
>> On 06/21/2012 10:10 PM, Mauro Carvalho Chehab wrote:
>>> Em 21-06-2012 10:36, Mauro Carvalho Chehab escreveu:
>>>> The firmware blob may not be available when the driver probes.
>>>>
>>>> Instead of blocking the whole kernel use request_firmware_nowait() and
>>>> continue without firmware.
>>>>
>>>> This shouldn't be that bad on drx-k devices, as they all seem to have an
>>>> internal firmware. So, only the firmware update will take a little longer
>>>> to happen.
>>>
>>> While thinking on converting another DVB frontend driver, I just realized
>>> that a patch like that won't work fine.
>>>
>>> As most of you know, there are _several_ I2C chips that don't tolerate any
>>> usage of the I2C bus while a firmware is being loaded (I dunno if this is the
>>> case of drx-k, but I won't doubt).
>>>
>>> The current approach makes the device probe() logic is serialized. So, there's
>>> no chance that two different I2C drivers to try to access the bus at the same
>>> time, if the bridge driver is properly implemented.
>>>
>>> However, now that firmware is loaded asynchronously, several other I2C drivers
>>> may be trying to use the bus at the same time. So, events like IR (and CI) polling,
>>> tuner get_status, etc can happen during a firmware transfer, causing the firmware
>>> to not load properly.
>>>
>>> A fix for that will require to lock the firmware load I2C traffic into a single
>>> transaction.
>>
>> How about deferring registration or probe of every bus-interface (usb, pci, firewire) drivers we have.
>> If we defer interface driver using work or some other trick we don't need to touch any other chip-drivers
>> that are chained behind interface driver. Demodulator, tuner, decoder, remote and all the other peripheral
>> drivers can be left as those are currently because those are deferred by bus interface driver.
> 
> There are some issues with regards to it:
> 
> 1) Currently, driver core doesn't allow a deferred probe. Drivers might implement
> that, but they'll lie to the core that the driver were properly supported even when
> probe fails. So, driver's core need an .async_probe() method;
> 
> 2) The firmware load issue will still happen at resume. So, a lock like that is
> still needed;
> 
> 3) It can make some sense to async load the firmware for some drivers, especially
> when the device detection may not be dependent on a firmware load.
> 
> I'm not fully convinced about (3), as the amount of changes are significant for
> not much gain.
> 
> There's also another related issue: On devices where both bridge and sub-devices (like frontend)
> needs firmware to be loaded, the load order is important at resume(), as the bridge
> requires to get the firmware before the sub-devices.
> 
> That's said, IMO, the best approach is to do:
> 
> 1) add support for asynchronous probe at device core, for devices that requires firmware
> at probe(). The async_probe() will only be active if !usermodehelper_disabled.
> 
> 2) export the I2C i2c_lock_adapter()/i2c_unlock_adapter() interface.
> 
> We can postpone or get rid of changing the I2C drivers to use request_firmware_async(),
> if the request_firmware() core is not pedantic enough to complain and it is not gonna
> to be deprecated.
> 
> Anyway, I'll open a thead c/c Greg KH (driver's core maintainer) with regards to the need
> of an async_probe() callback.
