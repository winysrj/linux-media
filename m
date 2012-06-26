Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab2FZBzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 21:55:54 -0400
Message-ID: <4FE9169D.5020300@redhat.com>
Date: Mon, 25 Jun 2012 22:55:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>
Subject: Re: Need of an ".async_probe()" type of callback at driver's core
 - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
In-Reply-To: <20120625223306.GA2764@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-06-2012 19:33, Greg KH escreveu:
> On Mon, Jun 25, 2012 at 05:49:25PM -0300, Mauro Carvalho Chehab wrote:
>> Greg,
>>
>> Basically, the recent changes at request_firmware() exposed an issue that
>> affects all media drivers that use firmware (64 drivers).
> 
> What change was that?  How did it break anything?

https://bugzilla.redhat.com/show_bug.cgi?id=827538

Basically, userspace changes and some pm-related patches, mainly this one [1]:

@@ -613,7 +606,14 @@ request_firmware(const struct firmware **firmware_p, const char *name,
	if (ret <= 0)
		return ret;
 
-	ret = _request_firmware(*firmware_p, name, device, true, false);
+	ret = usermodehelper_read_trylock();
+	if (WARN_ON(ret)) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+	} else {
+		ret = _request_firmware(*firmware_p, name, device, true, false,
+				        firmware_loading_timeout());
+		usermodehelper_read_unlock();
+	}
	if (ret)
		_request_firmware_cleanup(firmware_p);
 
[1] at git commit 9b78c1da60b3c62ccdd1509f0902ad19ceaf776b

>> Driver's documentation at Documentation/driver-model/driver.txt says that the
>> .probe() callback should "bind the driver to a given device.  That includes
>> verifying that the device is present, that it's a version the driver can handle,
>> that driver data structures can be allocated and initialized, and that any
>> hardware can be initialized".
> 
> Yes.
> 
>> All media device drivers are complaint with that, returning 0 on success
>> (meaning that the device was successfully probed) or an error otherwise.
> 
> Great, no probems then :)
> 
>> Almost all media devices are made by a SoC or a RISC CPU that works
>> as a DMA engine and exposes a set of registers to allow I2C access to the
>> device's internal and/or external I2C buses. Part of them have an internal
>> EEPROM/ROM that stores firmware internally at the board, but others require
>> a firmware to be loaded before being able to init/control the device and to
>> export the I2C bus interface.
>>
>> The media handling function is then implemented via a series of I2C devices[1]:
>> 	- analog video decoders;
>> 	- TV tuners;
>> 	- radio tuners;
>> 	- I2C remote controller decoders;
>> 	- DVB frontends;
>> 	- mpeg decoders;
>> 	- mpeg encoders;
>> 	- video enhancement devices;
>> 	...
>>
>> [1] several media chips have part of those function implemented internally,
>> but almost all require external I2C components to be probed.
>>
>> In order to properly refer to each component, we call the "main" kernel module
>> that talks with the media device via USB/PCI bus is called "bridge driver",
>> and the I2C components are called as "sub-devices".
>>
>> Different vendors use the same bridge driver to work with different sub-devices.
>>
>> It is a .probe()'s task to detect what sub-devices are there inside the board.
>>
>> There are several cases where the vendor switched the sub-devices without
>> changing the PCI ID/USB ID.
> 
> Hardware vendors suck, we all know that :(
> 
>> So, drivers do things like the code below, inside the .probe() callback:
>>
>> static int check_if_dvb_frontend_is_supported_and_bind()
>> {
>> 	switch (device_model) {
>> 	case VENDOR_A_MODEL_1:
>> 		if (test_and_bind_frontend_1())	/* Doesn't require firmware */
>> 			return 0;
>> 		if (test_and_bind_frontend_2())	/* requires firmware "foo" */
>> 			return 0;
>> 		if (test_and_bind_frontend_3())	/* requires firmware "bar" */
>> 			return 0;
> 
> Wait, why would these, if they require firmware, not load the firmware
> at this point in time?  Why are they saying "all is fine" here?

The above is a prototype of what happens. The "test_and_bind_frontend_n()" 
logic are, in fact, more complex than that: it tries to load the firmware
inside each frontend's code when needed.

This is a real example (taken from ttpci budget driver):

	switch(budget->dev->pci->subsystem_device) {
	case 0x1003: // Hauppauge/TT Nova budget (stv0299/ALPS BSRU6(tsa5059) OR ves1893/ALPS BSRV2(sp5659))
	case 0x1013:
		// try the ALPS BSRV2 first of all
		budget->dvb_frontend = dvb_attach(ves1x93_attach, &alps_bsrv2_config, &budget->i2c_adap);
		if (budget->dvb_frontend) {
			budget->dvb_frontend->ops.tuner_ops.set_params = alps_bsrv2_tuner_set_params;
			budget->dvb_frontend->ops.diseqc_send_master_cmd = budget_diseqc_send_master_cmd;
			budget->dvb_frontend->ops.diseqc_send_burst = budget_diseqc_send_burst;
			budget->dvb_frontend->ops.set_tone = budget_set_tone;
			break;
		}

		// try the ALPS BSRU6 now
		budget->dvb_frontend = dvb_attach(stv0299_attach, &alps_bsru6_config, &budget->i2c_adap);
		if (budget->dvb_frontend) {
			budget->dvb_frontend->ops.tuner_ops.set_params = alps_bsru6_tuner_set_params;
			budget->dvb_frontend->tuner_priv = &budget->i2c_adap;
			if (budget->dev->pci->subsystem_device == 0x1003 && diseqc_method == 0) {
				budget->dvb_frontend->ops.diseqc_send_master_cmd = budget_diseqc_send_master_cmd;
				budget->dvb_frontend->ops.diseqc_send_burst = budget_diseqc_send_burst;
				budget->dvb_frontend->ops.set_tone = budget_set_tone;
			}
			break;
		}
		break;

>> 		if (test_and_bind_frontend_4()) /* doesn't require firmware */
>> 			return 0;
>> 		break;
>> 	case VENDOR_A_MODEL_2:
>> 		/* Analog device - no DVB frontend on it */
>> 		return 0;
>> 	...
>> 	}
>> 	return -ENODEV;
>> }
>>
>> On several devices, before being able to register the bus and do the actual
>> probe, the kernel needs to load a firmware.
> 
> That's common.
> 
>> Also, during the I2C device probing time, firmware may be required, in order
>> to properly expose the device's internal models and their capabilities.
>>
>> For example, drx-k sub-device can have support for either DVB-C or DVB-T or both,
>> depending on the device model. That affects the frontend properties exposed
>> to the user and might affect the bridge driver's initialization task.
>>
>> In practice, a driver like em28xx have a few devices like HVR-930C that require
>> the drx-k sub-device. For those devices, a firmware is required; for other
>> devices, a firmware is not required.
>>
>> What's happening is that newer versions of request_firmware and udev are being
>> more pedantic (for a reason) about not requesting firmwares during module_init
>> or PCI/USB register's probe callback.
> 
> It is?  What changed to require this?  What commit id?

See above.

>> Worse than that, the same device driver may require a firmware or not, depending on
>> the I2C devices inside it. One such example is em28xx: for the great majority of
>> the supported devices, no firmware is needed, but devices like HVR-930C require
>> a firmware, because it uses a frontend that needs firmware.
>>
>> After some discussions, it seems that the best model would be to add an async_probe()
>> callback to be used by devices similar to media ones. The async_probe() should be
>> not probed during the module_init; the probe() will be deferred to happen later,
>> when firmware's usermodehelper_disabled is false, allowing those drivers to load their
>> firmwares if needed.
>>
>> What do you think?
> 
> We already have deferred probe() calls, you just need to return a
> different value (can't remember it at the moment), and your probe
> function will be called again at a later time after the rest of the
> devices in the system have been initialized.  Can that work for you?

Yeah, I think so. From what I saw, devices that require firmware could do, inside
their probe routine:

	if (usermodehelper_disabled)
		return -EPROBE_DEFER;

As usermodehelper_disabled is an static symbol at kernel/kmod.c, we would need to
either export it globally or to create a small routine that would return it to
the drivers.

For bridge drivers, a change like that would be trivial. For I2C devices, such change
can be more complex, as the probe() routine will need to be broken into some stages,
one for the bridge driver's core and another one for each I2C device that can be deferred,
keeping a record on what it was deferred, but it seems feasible to me.

Thank you for the suggestion!
 
> Or, if you "know" you are going to accept this device, just return 0
> from probe() after spawning a workqueue or thread to load the firmware
> properly and do everything else you need to do to initialize.  If
> something bad happens, unbind your device with a call to unbind things.

Not sure if this would work, as there are some USB devices with multiple
interfaces and some are handled by other drivers (like mceusb and snd-usb-audio).

IMO, the deferred probe() is the right answer for this issue.

Thanks!
Mauro
