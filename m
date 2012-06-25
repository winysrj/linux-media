Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2FYUGr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 16:06:47 -0400
Message-ID: <4FE8C4C4.1050901@redhat.com>
Date: Mon, 25 Jun 2012 17:06:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi>
In-Reply-To: <4FE8B8BC.3020702@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-06-2012 16:15, Antti Palosaari escreveu:
> On 06/21/2012 10:10 PM, Mauro Carvalho Chehab wrote:
>> Em 21-06-2012 10:36, Mauro Carvalho Chehab escreveu:
>>> The firmware blob may not be available when the driver probes.
>>>
>>> Instead of blocking the whole kernel use request_firmware_nowait() and
>>> continue without firmware.
>>>
>>> This shouldn't be that bad on drx-k devices, as they all seem to have an
>>> internal firmware. So, only the firmware update will take a little longer
>>> to happen.
>>
>> While thinking on converting another DVB frontend driver, I just realized
>> that a patch like that won't work fine.
>>
>> As most of you know, there are _several_ I2C chips that don't tolerate any
>> usage of the I2C bus while a firmware is being loaded (I dunno if this is the
>> case of drx-k, but I won't doubt).
>>
>> The current approach makes the device probe() logic is serialized. So, there's
>> no chance that two different I2C drivers to try to access the bus at the same
>> time, if the bridge driver is properly implemented.
>>
>> However, now that firmware is loaded asynchronously, several other I2C drivers
>> may be trying to use the bus at the same time. So, events like IR (and CI) polling,
>> tuner get_status, etc can happen during a firmware transfer, causing the firmware
>> to not load properly.
>>
>> A fix for that will require to lock the firmware load I2C traffic into a single
>> transaction.
> 
> How about deferring registration or probe of every bus-interface (usb, pci, firewire) drivers we have.
> If we defer interface driver using work or some other trick we don't need to touch any other chip-drivers
> that are chained behind interface driver. Demodulator, tuner, decoder, remote and all the other peripheral
> drivers can be left as those are currently because those are deferred by bus interface driver.

There are some issues with regards to it:

1) Currently, driver core doesn't allow a deferred probe. Drivers might implement
that, but they'll lie to the core that the driver were properly supported even when
probe fails. So, driver's core need an .async_probe() method;

2) The firmware load issue will still happen at resume. So, a lock like that is
still needed;

3) It can make some sense to async load the firmware for some drivers, especially
when the device detection may not be dependent on a firmware load.

I'm not fully convinced about (3), as the amount of changes are significant for
not much gain.

There's also another related issue: On devices where both bridge and sub-devices (like frontend)
needs firmware to be loaded, the load order is important at resume(), as the bridge
requires to get the firmware before the sub-devices.

That's said, IMO, the best approach is to do:

1) add support for asynchronous probe at device core, for devices that requires firmware
at probe(). The async_probe() will only be active if !usermodehelper_disabled.

2) export the I2C i2c_lock_adapter()/i2c_unlock_adapter() interface.

We can postpone or get rid of changing the I2C drivers to use request_firmware_async(),
if the request_firmware() core is not pedantic enough to complain and it is not gonna
to be deprecated.

Anyway, I'll open a thead c/c Greg KH (driver's core maintainer) with regards to the need
of an async_probe() callback.

Regards,
Mauro

> 
> regards
> Antti
> 


