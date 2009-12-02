Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49618 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbZLBTDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 14:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <20091202182329.GA20530@core.coreip.homeip.net>
References: <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
	 <20091201175400.GA19259@core.coreip.homeip.net>
	 <4B1567D8.7080007@redhat.com>
	 <20091201201158.GA20335@core.coreip.homeip.net>
	 <4B15852D.4050505@redhat.com>
	 <20091202093803.GA8656@core.coreip.homeip.net>
	 <4B16614A.3000208@redhat.com>
	 <20091202171059.GC17839@core.coreip.homeip.net>
	 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	 <20091202182329.GA20530@core.coreip.homeip.net>
Date: Wed, 2 Dec 2009 13:57:37 -0500
Message-ID: <9e4733910912021057s3e4ec06an906e3fb0d32aa301@mail.gmail.com>
Subject: Re: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 2, 2009 at 1:23 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Dec 02, 2009 at 12:30:29PM -0500, Jon Smirl wrote:
>> On Wed, Dec 2, 2009 at 12:10 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Wed, Dec 02, 2009 at 10:44:58AM -0200, Mauro Carvalho Chehab wrote:
>> >> Dmitry Torokhov wrote:
>> >> > On Tue, Dec 01, 2009 at 07:05:49PM -0200, Mauro Carvalho Chehab wrote:
>> >> >> Dmitry Torokhov wrote:
>> >> >>> On Tue, Dec 01, 2009 at 05:00:40PM -0200, Mauro Carvalho Chehab wrote:
>> >> >>>> Dmitry Torokhov wrote:
>> >> >>>>> On Tue, Dec 01, 2009 at 03:29:44PM -0200, Mauro Carvalho Chehab wrote:
>> >> >>>>>> For sure we need to add an EVIOSETPROTO ioctl to allow the driver
>> >> >>>>>> to change the protocol in runtime.
>> >> >>>>>>
>> >> >>>>> Mauro,
>> >> >>>>>
>> >> >>>>> I think this kind of confuguration belongs to lirc device space,
>> >> >>>>> not input/evdev. This is the same as protocol selection for psmouse
>> >> >>>>> module: while it is normally auto-detected we have sysfs attribute to
>> >> >>>>> force one or another and it is tied to serio device, not input
>> >> >>>>> device.
>> >> >>>> Dmitry,
>> >> >>>>
>> >> >>>> This has nothing to do with the raw interface nor with lirc. This problem
>> >> >>>> happens with the evdev interface and already affects the in-kernel drivers.
>> >> >>>>
>> >> >>>> In this case, psmouse is not a good example. With a mouse, when a movement
>> >> >>>> occurs, you'll receive some data from its port. So, a software can autodetect
>> >> >>>> the protocol. The same principle can be used also with a raw pulse/space
>> >> >>>> interface, where software can autodetect the protocol.
>> >> >>> Or, in certain cases, it can not.
>> >> >>>
>> >> >>> [... skipped rationale for adding a way to control protocol (with which
>> >> >>> I agree) ...]
>> >> >>>
>> >> >>>> To solve this, we really need to extend evdev API to do 3 things: enumberate the
>> >> >>>> supported protocols, get the current protocol(s), and select the protocol(s) that
>> >> >>>> will be used by a newer table.
>> >> >>>>
>> >> >>> And here we start disagreeing. My preference would be for adding this
>> >> >>> API on lirc device level (i.e. /syc/class/lirc/lircX/blah namespace),
>> >> >>> since it only applicable to IR, not to input devices in general.
>> >> >>>
>> >> >>> Once you selected proper protocol(s) and maybe instantiated several
>> >> >>> input devices then udev (by examining input device capabilities and
>> >> >>> optionally looking up at the parent device properties) would use
>> >> >>> input evdev API to load proper keymap. Because translation of
>> >> >>> driver-specific codes into standard key definitions is in the input
>> >> >>> realm. Reading these driver-specific codes from hardware is outside of
>> >> >>> input layer domain.
>> >> >>>
>> >> >>> Just as psmouse ability to specify protocol is not shoved into evdev;
>> >> >>> just as atkbd quirks (force release key list and other driver-specific
>> >> >>> options) are not in evdev either; we should not overload evdev interface
>> >> >>> with IR-specific items.
>> >> >> I'm not against mapping those features as sysfs atributes, but they don't belong
>> >> >> to lirc, as far as I understand. From all we've discussed, we'll create a lirc
>> >> >> interface to allow the direct usage of raw IO. However, IR protocol is a property
>> >> >> that is not related to raw IO mode but, instead, to evdev mode.
>> >> >>
>> >> >
>> >> > Why would protocol relate to evdev node? Evdev does not really care what
>> >> > how the fact that a certain button was pressed was communicated to it.
>> >> > It may be deliveretd through PS/2 port, or maybe it was Bluetooth HID,
>> >> > or USB HID or USB boot protocol or some custom protocol, or RC-5, NEC or
>> >> > some custom IR protocol. It makes no difference _whatsoever_ to evdev
>> >> > nor any users of evdev care about protocol used by underlying hardware
>> >> > device to transmit the data.
>> >> >
>> >> >> We might add a /sys/class/IR and add IR specific stuff there, but it seems
>> >> >> overkill to me and will hide the fact that those parameters are part of the evdev
>> >> >> interface.
>> >> >>
>> >> >> So, I would just add the IR sysfs parameters at the /sys/class/input, if
>> >> >> the device is an IR (or create it is /sys/class/input/IR).
>> >> >>
>> >> >> I agree that the code to implement the IR specific sysfs parameter should be kept
>> >> >> oustide input core, as they're specific to IR implementations.
>> >> >>
>> >> >> Would this work for you?
>> >> >
>> >> > I am seeing a little bit differently structured subsystem for IR at the
>> >> > moment. I think we should do something like this:
>> >> >
>> >> > - receivers create /sys/class/lirc devices. These devices provide API
>> >> >   with a ring buffer (fifo) for the raw data stream coming from (and to)
>> >> >   them.
>> >>
>> >> The raw interface applies only to the devices that doesn't have a hardware decoder
>> >> (something between 40%-60% of the currently supported devices).
>> >
>> > 50% is quite a number I think. But if driver does not allow access to
>> > the raw stream - it will refuse binding to lirc_dev interface.
>> >
>> >>
>> >> > - we allow registering several data interfaces/decoders that can be bound
>> >> >   (manually or maybe automatically) to lirc devices. lirc devices may
>> >> >   provide hints as to which interface(s) better suited for handling the
>> >> >   data coming form particular receiver. Several interfaces may be bound
>> >> >   to one device at a time.
>> >> > - one of the interfaces is interface implementing current lirc_dev
>> >> > - other interfaces may be in-kernel RC-5 decoder or other decoders.
>> >> >   decoders will create instances of input devices
>> >>
>> >> I don't see why having more than one interface, especially for devices with
>> >> hardware decoders.
>> >>
>> >> On IR remote receivers, internally, there's just one interface per hardware.
>> >>
>> >> Considering the hardware decoding case, why to artificially create other
>> >> interfaces that can't be used simultaneously? No current hardware
>> >> decoders can do that (or, at least, no current implementation allows).
>> >> We're foreseen some cases where we'll have that (like Patrick's dib0700 driver),
>> >> but for now, it is not possible to offer more than one interface to userspace.
>> >> Creating an arbitrary number of artificial interfaces just to pass a parameter
>> >> to the driver (the protocol), really seems overkill to me.
>> >
>> > We need to cater to the future cases as well. I don't want to redesign
>> > it in 2 years. But for devices that have only hardware decoders I
>> > suppose we can short-curcuit "interfaces" and have a library-like module
>> > creating input devices directly.
>> >
>> >>
>> >> In the case of the cheap devices with just raw interfaces, running in-kernel
>> >> decoders, while it will work if you create one interface per protocol
>> >> per IR receiver, this also seems overkill. Why to do that? It sounds that it will
>> >> just create additional complexity at the kernelspace and at the userspace, since
>> >> now userspace programs will need to open more than one device to receive the
>> >> keycodes.
>> >
>> > _Yes_!!! You open as many event devices as there are devices you are
>> > interested in receiving data from. Multiplexing devices are bad, bad,
>> > bad. Witness /dev/input/mouse and all the attempts at working around the
>> > fact that if you have a special driver for one of your devices you
>> > receive events from the same device through 2 interfaces and all kind of
>> > "grab", "super-grab", "smart-grab" schemes are born.
>> >
>> >>
>> >> > (for each remote/substream that they can recognize).
>> >>
>> >> I'm assuming that, by remote, you're referring to a remote receiver (and not to
>> >> the remote itself), right?
>> >
>> > If we could separate by remote transmitter that would be the best I
>> > think, but I understand that it is rarely possible?
>>
>> The code I posted using configfs did that. Instead of making apps IR
>> aware it mapped the vendor/device/command triplets into standard Linux
>> keycodes.  Each remote was its own evdev device.
>>
>
> That is what I liked about the patchset.

Some major use cases:
using IR as a keyboard replacement, controlling X and apps with it in
via mouse and keyboard emulation.
using IR to control a headless embedded device possibly running
multiple apps - like audio and home automation (my app)
IR during boot when it is the only input device the box has.
multifunction remote controlling several apps
using several different remotes to control a single app

Using irrecord to train a headless embedded system is impossible.
irrecord is also beyond the capabilities of non-technical users. So
I'd like to see a scheme that eliminates it in 90% of cases. So far
the only solution I've come up with is having a few predefined maps
built in.

>
>> That scheme could be made to "just work" by building in a couple of
>> mapping tables. The driver would pre-populate configfs entries for a
>> some standard IR devices. Set the remote for Motorala DVR. Default
>> Myth to look for the evdev device associated with Motorola DVR. The
>> built-in mapping table would then map from pulse timing to Linux
>> keycodes.
>>
>> If everyone hates configfs the same mapping can be done via the set
>> keys IOCTL and making changes to the user space apps like loadkeys.
>>
>
> It is not the hate of configfs per se, but rather concern that configfs
> takes too much resources and is not normally enabled.

It adds about 35K on 64b x86. 30K on 32b powerpc. If it gets turned on
by default other subsystems might start using it too. I work on an
embedded system. These arguments about non-swapable vs swapable are
pointless. Embedded systems don't have swap devices.

Of course config can be eliminated by modifying the setkeys IOCTL and
user space tools. It will require some more mods to input to allow
multiple maps monitoring the input stream and splitting them onto
multiple evdev devices. This is an equally valid way of building the
maps.

The code I posted is just demo code. It is clearly not in shape to be
merged. Its purpose was to spark a design discussion around creating a
good long-term architecture for IR.

One feature I never got around to was making unknown IR button presses
create entries in the configfs tree. A GUI program could use inotify
on the directory to monitor these new entries.  Now Myth could have a
display of commands it supported, push the IR button to create an
icon, then drop the icon onto the command. Export a script that udev
will use to populate the configfs.

-- 
Jon Smirl
jonsmirl@gmail.com
