Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:50917 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbbDCKLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 06:11:32 -0400
Date: Fri, 3 Apr 2015 11:11:30 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150403101129.GA568@gofer.mess.org>
References: <cover.1426801061.git.sean@mess.org>
 <20150330211819.GA18426@hardeman.nu>
 <20150331204716.6795177d@concha.lan>
 <20150401221941.GC4721@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150401221941.GC4721@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 02, 2015 at 12:19:41AM +0200, David Härdeman wrote:
> On Tue, Mar 31, 2015 at 08:47:16PM -0300, Mauro Carvalho Chehab wrote:
> >Em Mon, 30 Mar 2015 23:18:19 +0200
> >David Härdeman <david@hardeman.nu> escreveu:
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

LIRC is IR specific, yes. If something else comes along we can think
about something new, but not before that.

> I'm not saying we should throw away the lirc module/device, it'll have
> to stay around for a long time. But we should design a v2.

What is wrong with lirc that requires a redesign?

> If you've looked at my patches the idea is basically:
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

lirc uses feature bits. As we know from filesystems features are much
better than versioning. I'm sure there are other examples.

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

lirc_zilog can send both raw IR and scancodes (although I don't know how
to do raw IR yet). So with lirc you would do:

	unsigned features;

	ioctl(fd, LIRC_GET_FEATURES, &features);

	if (features & LIRC_CAN_SEND_MODE2) 
		// can send raw IR

	if (features & LIRC_CAN_SEND_SCANCODE) // needs my patches
		// can send scancodes


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

Putting everything in one big struct isn't really future-proof, and it
doesn't tell you which parts are supported by the hardware.

> * RCIOCSIRTX
> 	same as RCIOCSIRRX but for TX

That would have to be a different struct for RX and TX.

RX is different from TX. You want to set a carrier range for RX, and 
a specific carrier for TX. You want a duty cycle for TX but not for RX,
carrier reports for RX but that makes no sense for TX.

> * RCIOCGIRRX
> 	get all RX parameters
> * RCIOCGIRTX
> 	get all TX parameters
> 
> These ioctls only work with RC_DRIVER_IR_RAW hardware. Others can be
> defined for other kinds of hardware.

The cec patches going round at the moment create their own character 
devices. rc-core is only a side note in that system; IR and CEC are
so widely different it doesn't really make sense to share character
devices.

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

That would be very nice thing to have, but that is a separate from this.


Sean
