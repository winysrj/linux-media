Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59662 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbbDAXK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2015 19:10:27 -0400
Date: Wed, 1 Apr 2015 20:10:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc
 interface
Message-ID: <20150401201016.616fca34@recife.lan>
In-Reply-To: <20150401221941.GC4721@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
	<20150330211819.GA18426@hardeman.nu>
	<20150331204716.6795177d@concha.lan>
	<20150401221941.GC4721@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 02 Apr 2015 00:19:41 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Tue, Mar 31, 2015 at 08:47:16PM -0300, Mauro Carvalho Chehab wrote:
> >Em Mon, 30 Mar 2015 23:18:19 +0200
> >David Härdeman <david@hardeman.nu> escreveu:
> >> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
> >> Second, if we expose protocol type (which we should, not doing so is
> >> throwing away valuable information) we should tackle the NEC scancode
> >> question. I've already explained my firm conviction that always
> >> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
> >> is of the opinion that NEC16/24/32 should be essentially different
> >> protocols.
> >
> >Changing NEC would break userspace, as existing tables won't work.
> >So, no matter what I think, changing it won't happen as we're not
> >allowed to break userspace.
> 
> I have no idea what breakage you're talking about. Sean's patches would
> introduce new API, so they can't break anything. 

Sure, but changing RX would break, and using 32 bits just for TX,
while keeping 16/24/32 for RX would be too messy.

> My patch series also
> introduced a new API for setting/getting keytable entries (with
> heuristics for the old ways to convert NEC scancodes on the fly) so it
> should (hopefully) not break anything.

I sent a review of your patch series a long time ago. Didn't receive
any answer to my review from you yet. Yet, let's not mix the subjects.
If you want to discuss that, please reply to the old thread and submit
your work on small chunks, after the approach is agreed.

> >(and yes, I think NEC16 is *the* NEC protocol; the other are just
> >variants made by some vendors to fill their needs)
> 
> We are talking about the protocol used to communicate what has been
> received/should be sent between userspace and the kernel. Simply passing
> the 32 bits that have been sent/received is the simplest, most
> straightfoward way to go.

Yes, it would be simpler. That doesn't mean that it is technically
correct. Yet, you could argue that passing 48 bits would be even
simpler, due to NEC/48 (or 64 bits, if one would ever propose a
nec-64 variant).

Ok, NEC/16/24/32 always send 32 bits at the same way, while other
"longer" variants would actually change the payload size, while
16/24/32 is just a change of the bytes meaning at the payload.
Yet, they're different.

> >> Third, we should still have a way to represent the protocol in the
> >> keymap as well.
> >
> >Not sure about that, but this is a different matter. 
> 
> Yes, it's a different matter. And what is there to be unsure about? Not
> having the protocol as part of the keymap means throwing away
> information...

The internal representation at kernelspace can always be changed.

If you're instead referring to some specific problem with the userspace
to kernelspace TX API, then please point to the specific patch for the
actual implementation, instead of discussing it in an abstract way.

> >> And on a much more general level...I still think we should start from
> >> scratch with a rc specific chardev with it's own API that is generic
> >> enough to cover both scancode / raw ir / future / other protocols (not
> >> that such an undertaking would preclude adding stuff to the lirc API of
> >> course).
> >
> >Starting from scratch sounds a bad idea. We don't do that on Linux,
> >except when we really screwed everything very badly.
> 
> LIRC...IR specific....rc-core....not IR specific...and the lirc IOCTL
> API is pretty badly screwed. Have you had a closer look at it?
> 
> I'm not saying we should throw away the lirc module/device, it'll have
> to stay around for a long time. But we should design a v2. If you've
> looked at my patches the idea is basically:
> 
> RC device is plugged in, /dev/rc/rc0 is created by udev
> 
> Applications wishing to muck about with RC devices do:
> 
> 	int fd;
> 	int ver;
> 	int type;
> 
> 	fd = open("/dev/rc/rc0")
> 
> 	ver = ioctl(fd, RCIOCGVERSION);
> 	if (ver != 1)
> 		warn("New RC API version");
> 
> 	type = ioctl(fd, RCIOCGVERSION);
> 	switch (type) {
> 	case RC_DRIVER_SCANCODE:
> 		debug("Scancode hardware");
> 		break;
> 	case RC_DRIVER_IR_RAW:
> 		debug("Raw IR hardware");
> 		break;
> 	default:
> 		debug("Unknown hardware type");
> 		break;
> 	}
> 
> And then they can do further operations depending on the type of the
> device. For example, for raw IR devices you can read() raw IR
> pulse/space timings or (if the hardware supports TX) write() raw IR
> timings.
> 
> Other examples of ioctls are (all four work using structs with all the
> relevant parameters):
> 
> * RCIOCSIRRX
> 	set all RX parameters in one go (and return the result since
> 	the exact values requested might not be supported)
> * RCIOCSIRTX
> 	same as RCIOCSIRRX but for TX
> * RCIOCGIRRX
> 	get all RX parameters
> * RCIOCGIRTX
> 	get all TX parameters
> 
> These ioctls only work with RC_DRIVER_IR_RAW hardware. Others can be
> defined for other kinds of hardware.
> 
> Then there's one more thing, and that's multiple keytables per rc
> device. Each keytable has one associated input device (so there's a
> 1-to-N mapping between rc devices and input devices). Userspace can
> create/destroy additional keytables and add/remove scancode<->keycode
> mappings per keytable. The idea is that you'd be able to e.g. define one
> keytable per physical remote control (the thing you hold in your hand,
> not the receiver/transmitter), and each would get its own input device.
> Those input devices can then be used by different applications (so you
> could have that old VCR remote control the PVR software while the TV
> remote controls your Kodi frontend). An idea I borrowed from Jon Smirl
> (who posted a similar proof-of-concept based on debugfs back in the
> days).
> 
> I hope that makes things a bit clearer...?

The Jon Smirl's proposal were nacked because it was re-defining a new
input subsystem. The input maintainers complained, and they're right.
We should not create an independent input core, but, instead, use the
already existing one.

That's basically the reason why LIRC support was added as a separate
interface: we didn't want to mess up with the input layer.

Besides that, I don't see any gain on adding an IR-specific input layer.
Doing that would require not only kernel work, but someone would also need
to patch X11, Wayland, MIR, VNC, xrdp ... in order to make them to support
such new input layer. Too much work, too less benefit.

If all you want is to add the protocol type, it should be easy to add a new
input event type to reflect it. Right now, we have already events for both
keycode and scancode. Adding support for protocol type should be an easy
addition there.

> >Also, the input
> >developers already denied adding a separate chardev with its own API
> >when we started discussing about the remote controller core.
> 
> Care to provide links? I think you're talking about something else...

All those discussions happened back on 2009.

This is one of the threads:
	http://www.gossamer-threads.com/lists/linux/kernel/972130#971761

There were actually 3 or 4 different threads.
> 
> My patches are not about reimplementing the input subsystem, it is
> basically to define a replacement for the lirc dev which is IR agnostic.
> input chardevs would still exist in parallel with the "rc-core" dev
> instead of the "lirc" dev (like today).

As I said before, let's discuss this on the top of my review to your
patchset, not hijacking Sean's submission.

> >Adding a new chardev would make things very confusing, as we'll need
> >to keep reporting data on both new and old chardev.
> 
> I fail to see the confusion. My patches already handled both the "old"
> (i.e. lirc) dev and the new dev. And userspace will be written to use
> one of the two interfaces...

Actually 3 interfaces, if your proposal is to keep the input evdev.
So, yeah, is it messy to have 3 different device nodes to get the reports
for the same hardware events.

LIRC interface is meant to be used for "raw" access to the device, just
like other input devices do. So, not much confusion (at least before
Sean's patch):
	- raw data: lirc devnode
	- handled data (scancode and keycode): input/evdev devnode

> >We have this already
> >for LIRC, but with different interfaces, so, no big issue. Also, LIRC
> >can be dynamically disabled at runtime. So, it seems that this is the
> >best approach, IMO.
> 
> The whole point of having one core rc-core interface is of course
> completely orthogonal to whether lirc can be disabled...

Yeah, it should always be possible to disable raw data support.

Regards,
Mauro
