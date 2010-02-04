Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:51989 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab0BDPDz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 10:03:55 -0500
Message-ID: <4B6AE241.6090900@adit.fi>
Date: Thu, 04 Feb 2010 17:05:37 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi> <4B6AD3DB.8090801@redhat.com>
In-Reply-To: <4B6AD3DB.8090801@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Mauro Carvalho Chehab wrote:
> Pekka Sarnila wrote:
> 
>>The problem using vendor class is that there is no standard. Each vendor
>>can define its own way using endpoints (and has done so e.g Logitech
>>joysticks). Thus each usb ir receiver must have its own specific driver.
>> However then you get the raw ir codes. When using HID class, generic
>>HID driver can do the job. But then you get HID key codes directly not
>>ir codes.
> 
> We started writing an abstraction layer for IR, using the input. The idea
> is to allow the IR receivers to work with different IR's, as several users
> prefer to use universal IR's to control their devices, instead of the original
> one. This is already used by all V4L drivers and I intend to port most of
> the DVB drivers to use it as well soon.

This is very good.

The problem here is that at least afatech ir receiver has the ir code to 
key code build in, so trough HID you can use only the remote whose ir to 
key translate table has been loaded to the aftech device. Unless that 
can be easily controlled by the user HID is no good for this.

> 
>>Also this should not be seen at all as dvb question. First, not all the
>>world uses dvb standard (including USA) but uses very similar tv-sticks
>>with identical ir receivers and remotes. 
> 
> Despiste its name, the DVB subsystem is not specific for DVB standards, but
> it is meant to be used by all DTV standards (and almost all DTV standards
> are already supported).

But most of the world still uses analog (they can not afford yet the 
transfer). Those tv-sticks have identical receivers. And there are usb 
ir receivers not embedded to tv-sticks. Conceptually and technically it 
has nothing to do with any tv or any other audiovisual system system 
(e.g. a remote controlled weather station).

So dvb is both as a place and a name misleading.

>>Second there are many other
>>type of usb devices with ir receiver. So dvb layer should not be
>>involved at all. There maybe would be need for hid-ir-remote layer (your
>>code suggestion moved there). However even there IMHO better would be
>>just to improve HID <-> input layer interface so that input layer could
>>divert the remotes input to generic remotes layer instead of keyboard
>>layer. IMHO this would be the real linux way.
>  
> This is already happening.
> 
> See drivers/media/IR on linux-next for the IR common code. The ir-core is
> provided by ir-keytable.c and ir-sysfs.c, and it is not DVB or V4L specific.

Well I was talking about HID remotes that don't give ir codes but key 
codes. What to do with them?

> The ir-common module were developed for V4L drivers and will probably be
> changed into a more generic way, with the integration with lirc.
> 
> 
>>However linux usb layer has been build so that it was technically
>>impossible to put it there without completely redesigning usb <-> higher
>>layer (including HID) interface. But I'm of the opinion that that
>>redesign should be done anyway. 
> 
> Feel free to submit patches. My plan is to integrate the DVB devices soon

Yes, I have thought of it. But it is a big job, I'm quite busy, and 
after all mostly the benefit is more esthetical than practical. A lot of 
other usb strandard and vendor class interrupt endpoint drivers beside 
HID should be rewritten. Writing new ones would be easier though.

> into the new ir-core. I should start with dvb-usb-remote, where most of the
> DVB USB devices use to attach their IR's. Unfortunately, af9015 doesn't 
> rely on the dvb-usb-remote, so, it will require some specific changes.
> As I don't have any af9015 device, I'll likely postpone it or wait for
> someone to do the job.

Well that was the original point of my involvement. It can support both 
the dvb-usb-remote and HID. The problem with af9015/dvb-usb-remote is 
that it uses usb vendor class endpoint (all trough I have used 'vendor 
class' to specifically mean usb vendor class). Usb vendor classes have 
no standard. But af9015 can also use USB HID class (remote as keyboard) 
in a standard manner. That would avoid using special device  based driver.

>>Now the question is, how much all usb based ir receivers have in common,
>>and how much they differ. This should determine on what level and in
>>which way they should be handled. How much and on what level there
>>should be common code and where device specific driver code would be
>>needed and where and how the ir-to-code translate should take place.
> 
> 
> There are several different ways for IR receivers, and, at least for 
> vendor class, no standard way to handle. They can use GPIO polling,
> they can use i2c layer, they can use IRQ (on PCI devices) and the data
> may be provided in parallel or on a serial interface.

Well the thing is that even with usb each device can have non standard 
user vendor endpoint. In case of af9015 it can provide the ir code.

> The idea of the ir-core is to provide support for all those options.

Even for those that do provide key codes trough standard HID layer 
instead of ir codes trough specific device drivers?

>>IMHO all that have HID endpoint that works (either as such or with some
>>generic quirk) should be handled by HID first and then conveyed to
>>generic remotes layer that handles all remote controllers what ever the
>>lower layers (and does translate per remote not per ir receiver). Vendor
>>class should be avoided unless that's the only way to make it work
>>right. But using HID is not without problems either.
> 
> Almost all chipsets only provide IR via vendor class. I agree that using 
> standard HID class is the better way for doing it.

Yes, but look below.

>>Now with the two receivers that need the quirk. If they don't have
>>vendor class bulk endpoint for reading ir codes, then specific driver is
>>out anyway. However then changes to HID driver would be needed to make
>>the translate work. The quirk just makes them work as generic usb
>>keyboard with no remote specific translate. With afatech, driver loads
>>the translate table to the device, different for different remotes. I
>>don't know if one table could handle them all. Maybe this table should
>>be loaded from a user space file. Nor do I know how it is with other
>>receivers: can the table be loaded or is it fixed. In any case a generic
>>secondary per remote user configurable translate would be highly
>>desirable. And I don't mean lircd. This job is IMHO kernel level job and
>>lircd won't work here anyway. It does ir code to key code or function
>>translate not key code to key code translate. How nice it would be if
>>there would be a generic usb ir receiver class that all vendors used.
>>There seems to be no way to  make this well and clean.
> 
> 
> The ir-core provides standard ways to replace the IR keycode and IR protocols.
> The IR protocol change is already working with vendor class with em28xx driver.

The thing is that remote controller trough HID layer does not provide IR 
keycode but standard keyboard key code. And HID layer does not know that 
it is a remote controller but sees it as an ordinary usb keyboard. The 
question is that how can it tell the upper layer that it really is a 
remote controller so that the event would end up to generic ir-core.

Pekka

> Cheers,
> Mauro
