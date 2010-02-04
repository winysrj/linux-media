Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0BDROM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 12:14:12 -0500
Message-ID: <4B6B0039.7010206@redhat.com>
Date: Thu, 04 Feb 2010 15:13:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pekka Sarnila <sarnila@adit.fi>
CC: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi> <4B6AD3DB.8090801@redhat.com> <4B6AE241.6090900@adit.fi>
In-Reply-To: <4B6AE241.6090900@adit.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pekka Sarnila wrote:

> The problem here is that at least afatech ir receiver has the ir code to
> key code build in, so trough HID you can use only the remote whose ir to
> key translate table has been loaded to the aftech device. Unless that
> can be easily controlled by the user HID is no good for this.

The ir-core allows a driver to start with a built in table, that can be
dynamically replaced in userspace by a different table, and even with a
different protocol, if supported by the driver/device.

> But most of the world still uses analog (they can not afford yet the
> transfer). Those tv-sticks have identical receivers. And there are usb
> ir receivers not embedded to tv-sticks. Conceptually and technically it
> has nothing to do with any tv or any other audiovisual system system
> (e.g. a remote controlled weather station).
> 
> So dvb is both as a place and a name misleading.

It happens that almost all tv products (analog or digital) come with some 
IR support. But you can find also some products that are just IR.

That's why we're moving it to be outside the V4L and the DVB directory.
For now, it is at /drivers/media/IR (since it helps us to move the code, while
there are still some dependencies at ir-common). But the better is to move it
later to /drivers/IR or /drivers/input/IR.
 
>> See drivers/media/IR on linux-next for the IR common code. The ir-core is
>> provided by ir-keytable.c and ir-sysfs.c, and it is not DVB or V4L
>> specific.
> 
> Well I was talking about HID remotes that don't give ir codes but key
> codes. What to do with them?

What happens if you use it to receive keycodes from a different IR using
the same protocol?

Maybe it can still be valid to keep allowing keycode translation.

>> As I don't have any af9015 device, I'll likely postpone it or wait for
>> someone to do the job.
> 
> Well that was the original point of my involvement. It can support both
> the dvb-usb-remote and HID. The problem with af9015/dvb-usb-remote is
> that it uses usb vendor class endpoint (all trough I have used 'vendor
> class' to specifically mean usb vendor class). Usb vendor classes have
> no standard. But af9015 can also use USB HID class (remote as keyboard)
> in a standard manner. That would avoid using special device  based driver.

Well, as HID, you may loose the capability of using a different IR than the
one shipped with the af9015. It may make sense to just disable HID and use
USB Vendor Class.
 
> Well the thing is that even with usb each device can have non standard
> user vendor endpoint. In case of af9015 it can provide the ir code.

It doesn't matter how the IR code is get, kernel needs to translate it into
a linux key. That's where the ir-core enters: instead of registering the device
directly at input event, the driver registers via ir_input_register():

int ir_input_register(struct input_dev *input_dev,
                      const struct ir_scancode_table *rc_tab,
                      const struct ir_dev_props *props)

The arguments are the input device, the keycode->scancode table and an optional
argument that specifies the IR supported protocols, and a callback function
to be called when a different protocol is requested.

The IR subsystem will do a dynamic allocation for the keytable and will take 
care of EVIOCGKEY/EVIOCSKEY events. It will increase/decrease the keytable size
if needed.

This way, userspace may replace the scancode/keycode table and even the IR protocol,
without needing to add any specific code at the driver.

It will also create some sysfs nodes that will help udev to identify when a new IR
device driver is loaded, allowing the keycode replacement during device hotplug.

The only needed change, at the driver, is to replace input_register_device/input_unregister_device
by ir_input_register/ir_input_unregister.

> 
>> The idea of the ir-core is to provide support for all those options.
> 
> Even for those that do provide key codes trough standard HID layer
> instead of ir codes trough specific device drivers?

It basically depends on what the HID layer receives from the IR. Yet, it is possible to
use the ir-core layer in order to use an IR keycode to produce a different code. It is
not always clear what certain remote keys are supposed to do.

For example, should the <POWER> key turn off the PC, or just quit the application?

>> The ir-core provides standard ways to replace the IR keycode and IR
>> protocols.
>> The IR protocol change is already working with vendor class with
>> em28xx driver.
> 
> The thing is that remote controller trough HID layer does not provide IR
> keycode but standard keyboard key code. And HID layer does not know that
> it is a remote controller but sees it as an ordinary usb keyboard. The
> question is that how can it tell the upper layer that it really is a
> remote controller so that the event would end up to generic ir-core.

For HID remote controllers, the only way I see is to have an USB ID list of devices
that are known to be remote controllers and register them via ir_input_register,
instead of input_register_device.

Cheers,
Mauro
