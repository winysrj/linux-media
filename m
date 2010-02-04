Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab0BDOEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 09:04:45 -0500
Message-ID: <4B6AD3DB.8090801@redhat.com>
Date: Thu, 04 Feb 2010 12:04:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pekka Sarnila <sarnila@adit.fi>
CC: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi>
In-Reply-To: <4B6ACA4B.2030906@adit.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pekka Sarnila wrote:

> The problem using vendor class is that there is no standard. Each vendor
> can define its own way using endpoints (and has done so e.g Logitech
> joysticks). Thus each usb ir receiver must have its own specific driver.
>  However then you get the raw ir codes. When using HID class, generic
> HID driver can do the job. But then you get HID key codes directly not
> ir codes.

We started writing an abstraction layer for IR, using the input. The idea
is to allow the IR receivers to work with different IR's, as several users
prefer to use universal IR's to control their devices, instead of the original
one. This is already used by all V4L drivers and I intend to port most of
the DVB drivers to use it as well soon.

> Also this should not be seen at all as dvb question. First, not all the
> world uses dvb standard (including USA) but uses very similar tv-sticks
> with identical ir receivers and remotes. 

Despiste its name, the DVB subsystem is not specific for DVB standards, but
it is meant to be used by all DTV standards (and almost all DTV standards
are already supported).

> Second there are many other
> type of usb devices with ir receiver. So dvb layer should not be
> involved at all. There maybe would be need for hid-ir-remote layer (your
> code suggestion moved there). However even there IMHO better would be
> just to improve HID <-> input layer interface so that input layer could
> divert the remotes input to generic remotes layer instead of keyboard
> layer. IMHO this would be the real linux way.

This is already happening.

See drivers/media/IR on linux-next for the IR common code. The ir-core is
provided by ir-keytable.c and ir-sysfs.c, and it is not DVB or V4L specific.

The ir-common module were developed for V4L drivers and will probably be
changed into a more generic way, with the integration with lirc.

> However linux usb layer has been build so that it was technically
> impossible to put it there without completely redesigning usb <-> higher
> layer (including HID) interface. But I'm of the opinion that that
> redesign should be done anyway. 

Feel free to submit patches. My plan is to integrate the DVB devices soon
into the new ir-core. I should start with dvb-usb-remote, where most of the
DVB USB devices use to attach their IR's. Unfortunately, af9015 doesn't 
rely on the dvb-usb-remote, so, it will require some specific changes.
As I don't have any af9015 device, I'll likely postpone it or wait for
someone to do the job.

> Now the question is, how much all usb based ir receivers have in common,
> and how much they differ. This should determine on what level and in
> which way they should be handled. How much and on what level there
> should be common code and where device specific driver code would be
> needed and where and how the ir-to-code translate should take place.

There are several different ways for IR receivers, and, at least for 
vendor class, no standard way to handle. They can use GPIO polling,
they can use i2c layer, they can use IRQ (on PCI devices) and the data
may be provided in parallel or on a serial interface.

The idea of the ir-core is to provide support for all those options.

> IMHO all that have HID endpoint that works (either as such or with some
> generic quirk) should be handled by HID first and then conveyed to
> generic remotes layer that handles all remote controllers what ever the
> lower layers (and does translate per remote not per ir receiver). Vendor
> class should be avoided unless that's the only way to make it work
> right. But using HID is not without problems either.

Almost all chipsets only provide IR via vendor class. I agree that using 
standard HID class is the better way for doing it.

> Now with the two receivers that need the quirk. If they don't have
> vendor class bulk endpoint for reading ir codes, then specific driver is
> out anyway. However then changes to HID driver would be needed to make
> the translate work. The quirk just makes them work as generic usb
> keyboard with no remote specific translate. With afatech, driver loads
> the translate table to the device, different for different remotes. I
> don't know if one table could handle them all. Maybe this table should
> be loaded from a user space file. Nor do I know how it is with other
> receivers: can the table be loaded or is it fixed. In any case a generic
> secondary per remote user configurable translate would be highly
> desirable. And I don't mean lircd. This job is IMHO kernel level job and
> lircd won't work here anyway. It does ir code to key code or function
> translate not key code to key code translate. How nice it would be if
> there would be a generic usb ir receiver class that all vendors used.
> There seems to be no way to  make this well and clean.

The ir-core provides standard ways to replace the IR keycode and IR protocols.
The IR protocol change is already working with vendor class with em28xx driver.

Cheers,
Mauro
