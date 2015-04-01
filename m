Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36203 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbDAWUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 18:20:15 -0400
Date: Thu, 2 Apr 2015 00:19:41 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150401221941.GC4721@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
 <20150330211819.GA18426@hardeman.nu>
 <20150331204716.6795177d@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150331204716.6795177d@concha.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2015 at 08:47:16PM -0300, Mauro Carvalho Chehab wrote:
>Em Mon, 30 Mar 2015 23:18:19 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
>> Second, if we expose protocol type (which we should, not doing so is
>> throwing away valuable information) we should tackle the NEC scancode
>> question. I've already explained my firm conviction that always
>> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
>> is of the opinion that NEC16/24/32 should be essentially different
>> protocols.
>
>Changing NEC would break userspace, as existing tables won't work.
>So, no matter what I think, changing it won't happen as we're not
>allowed to break userspace.

I have no idea what breakage you're talking about. Sean's patches would
introduce new API, so they can't break anything. My patch series also
introduced a new API for setting/getting keytable entries (with
heuristics for the old ways to convert NEC scancodes on the fly) so it
should (hopefully) not break anything.

>(and yes, I think NEC16 is *the* NEC protocol; the other are just
>variants made by some vendors to fill their needs)

We are talking about the protocol used to communicate what has been
received/should be sent between userspace and the kernel. Simply passing
the 32 bits that have been sent/received is the simplest, most
straightfoward way to go.

>> Third, we should still have a way to represent the protocol in the
>> keymap as well.
>
>Not sure about that, but this is a different matter. 

Yes, it's a different matter. And what is there to be unsure about? Not
having the protocol as part of the keymap means throwing away
information...

>> And on a much more general level...I still think we should start from
>> scratch with a rc specific chardev with it's own API that is generic
>> enough to cover both scancode / raw ir / future / other protocols (not
>> that such an undertaking would preclude adding stuff to the lirc API of
>> course).
>
>Starting from scratch sounds a bad idea. We don't do that on Linux,
>except when we really screwed everything very badly.

LIRC...IR specific....rc-core....not IR specific...and the lirc IOCTL
API is pretty badly screwed. Have you had a closer look at it?

I'm not saying we should throw away the lirc module/device, it'll have
to stay around for a long time. But we should design a v2. If you've
looked at my patches the idea is basically:

RC device is plugged in, /dev/rc/rc0 is created by udev

Applications wishing to muck about with RC devices do:

	int fd;
	int ver;
	int type;

	fd = open("/dev/rc/rc0")

	ver = ioctl(fd, RCIOCGVERSION);
	if (ver != 1)
		warn("New RC API version");

	type = ioctl(fd, RCIOCGVERSION);
	switch (type) {
	case RC_DRIVER_SCANCODE:
		debug("Scancode hardware");
		break;
	case RC_DRIVER_IR_RAW:
		debug("Raw IR hardware");
		break;
	default:
		debug("Unknown hardware type");
		break;
	}

And then they can do further operations depending on the type of the
device. For example, for raw IR devices you can read() raw IR
pulse/space timings or (if the hardware supports TX) write() raw IR
timings.

Other examples of ioctls are (all four work using structs with all the
relevant parameters):

* RCIOCSIRRX
	set all RX parameters in one go (and return the result since
	the exact values requested might not be supported)
* RCIOCSIRTX
	same as RCIOCSIRRX but for TX
* RCIOCGIRRX
	get all RX parameters
* RCIOCGIRTX
	get all TX parameters

These ioctls only work with RC_DRIVER_IR_RAW hardware. Others can be
defined for other kinds of hardware.

Then there's one more thing, and that's multiple keytables per rc
device. Each keytable has one associated input device (so there's a
1-to-N mapping between rc devices and input devices). Userspace can
create/destroy additional keytables and add/remove scancode<->keycode
mappings per keytable. The idea is that you'd be able to e.g. define one
keytable per physical remote control (the thing you hold in your hand,
not the receiver/transmitter), and each would get its own input device.
Those input devices can then be used by different applications (so you
could have that old VCR remote control the PVR software while the TV
remote controls your Kodi frontend). An idea I borrowed from Jon Smirl
(who posted a similar proof-of-concept based on debugfs back in the
days).

I hope that makes things a bit clearer...?

>Also, the input
>developers already denied adding a separate chardev with its own API
>when we started discussing about the remote controller core.

Care to provide links? I think you're talking about something else...

My patches are not about reimplementing the input subsystem, it is
basically to define a replacement for the lirc dev which is IR agnostic.
input chardevs would still exist in parallel with the "rc-core" dev
instead of the "lirc" dev (like today).

>Adding a new chardev would make things very confusing, as we'll need
>to keep reporting data on both new and old chardev.

I fail to see the confusion. My patches already handled both the "old"
(i.e. lirc) dev and the new dev. And userspace will be written to use
one of the two interfaces...

>We have this already
>for LIRC, but with different interfaces, so, no big issue. Also, LIRC
>can be dynamically disabled at runtime. So, it seems that this is the
>best approach, IMO.

The whole point of having one core rc-core interface is of course
completely orthogonal to whether lirc can be disabled...


-- 
David Härdeman
