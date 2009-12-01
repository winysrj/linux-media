Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAOPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 09:15:05 -0500
Message-ID: <4B1524DD.3080708@redhat.com>
Date: Tue, 01 Dec 2009 12:14:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
In-Reply-To: <4B14EDE3.5050201@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:
>   Hi,
> 
>>> The point is that for simple usage, like an user plugging his new USB
>>> stick
>>> he just bought, he should be able to use the shipped IR without
>>> needing to
>>> configure anything or manually calling any daemon. This currently works
>>> with the existing drivers and it is a feature that needs to be kept.
>>
>> Admittedly, LIRC is way behind when it comes to plug'n'play.
> 
> Should not be that hard to fixup.
> 
> When moving the keytable loading from kernel to userspace the kernel
> drivers have to inform userspace anyway what kind of hardware the IR
> device is, so udev can figure what keytable it should load.  A sysfs
> attribute is the way to go here I think.
> 
> lirc drivers can do the same, and lircd can startup with a reasonable
> (default) configuration.
> 
> Of course evdev and lirc subsytems/drivers should agree on which
> attributes should be defined and how they are filled.

Yes, a sysfs attribute seems appropriate in this case.

This is the attributes that are currently available via sysfs:

  looking at device '/class/input/input13/event5':
    KERNEL=="event5"
    SUBSYSTEM=="input"
    SYSFS{dev}=="13:69"

  looking at parent device '/class/input/input13':
    ID=="input13"
    BUS=="input"
    DRIVER==""
    SYSFS{name}=="em28xx IR _em28xx #0_"
    SYSFS{phys}=="usb-0000:00:1d.7-8/input0"
    SYSFS{uniq}==""

For the currently used attributes, we have:

The name attribute. If we do some effort to standardize it, it could be an option.
However, on several drivers, this attribute is filled with something that is generic
for the entire driver, and on several cases like the above, it adds a device number. 

The phys attribute has to do only with the bus address. Btw, the lirc drivers need
to follow the conventions here. We did a great effort at 2.6.30 or 2.6.31 to standardize
the phys attribute, as some drivers were using different conventions for it.

The uniq attribute is meant to be used as a serial number (no driver seems to use
it currently, from my tests with git grep).

By looking on other subsystems, ALSA defines two name attributes: a shortname and a longname.

The current board naming schema at the V4L drivers are a long name. For example:
"Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker"

The rationale is that they should be user-friendly.

Maybe a similar concept could be used here: we can add a sort of shortname string
that will uniquely describe a device and will have a rule to describe them unically.

For example, the above device is a Hauppauge HVR950 usb stick, that is supported
by em28xx driver.

We may call it as "EM28xxHVR950-00" (the last 2 chars is to allow having board revisions, 
as some devices may have more than one variant).

Another alternative would be to create an integer SYSFS atribute and use some rule to
associate the device number with the driver.

The big issue here is: how do we document that "EM28xxHVR950-00" is the Hauppauge Grey IR that
is shipped with their newer devices.

A third approach would be to identify, instead, the Remote Controller directly. So, we would
add a sysfs field like ir_type.

There are two issues here:
	1) What's the name for this IR? We'll need to invent names for the existing IR's, as
those devices don't have a known brand name;
	2) there are cases where the same device is provided with two or more different IR
types. If we identify the board type instead of the IR type, userspace can better handle
it, by providing a list of the possibilities.

---

No matter how we map, we'll still need to document it somehow to userspace. What would be
the better? A header file? A set of keymaps from the default IR's that will be added
on some directory at the Linux tree? A Documentation/IR ?

I'm for having the keymaps on some file at the kernel tree, maybe at Documentation/IR,
but this is just my 2 cents. We need to think more about that.

Comments?

Anyway, we shouldn't postpone lirc drivers addition due to that. There are still lots of work
to do before we'll be able to split the tables from the kernel drivers.

Cheers,
Mauro.
