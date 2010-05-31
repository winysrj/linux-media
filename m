Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32711 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab0EaTiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 15:38:22 -0400
Subject: Re: ir-core multi-protocol decode and mceusb
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
In-Reply-To: <4C0408A9.4040904@redhat.com>
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
	 <1275136793.2260.18.camel@localhost>
	 <AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>
	 <1275163295.17477.143.camel@localhost>
	 <AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>
	 <4C02700A.9040807@redhat.com>
	 <AANLkTimYjc0reLHV6RtGFIMFz1bbjyZiTYGj1TcacVzT@mail.gmail.com>
	 <AANLkTik_-6Z12G8rz0xkjbLkpWvfRHorGtD_LbsPr_11@mail.gmail.com>
	 <1275308142.2227.16.camel@localhost>  <4C0408A9.4040904@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:38:19 -0400
Message-ID: <1275334699.2261.45.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-05-31 at 16:06 -0300, Mauro Carvalho Chehab wrote:
> Hi Andy,
> 
> Em 31-05-2010 09:15, Andy Walls escreveu:
> >> I've now got an ir-lirc-codec bridge passing data over to a completely
> >> unmodified lirc_dev, with the data then making its way out to the
> >> lircd userspace where its even getting properly decoded. I don't have
> >> the transmit side of things in ir-lirc-codec wired up just yet, but
> >> I'd like to submit what I've got (after some cleanup) tomorrow, and
> >> will then incrementally work on transmit. I'm pretty sure wiring up
> >> transmit is going to require some of the bits we'd be using for native
> >> transmit as well, so there may be some discussion required. Will give
> >> a look at setting enabled/disabled decoders tomorrow too, hopefully.
> > 
> > 
> > Since you're looking at Tx, please take a look at the v4l2_subdev
> > interface for ir devices.  See 
> > 
> > linux/include/media/v4l2-subdev.h: struct v4l2_subdev_ir_ops 
> > 
> > I was wondering how this interface could be modified to interface nicely
> > to lirc (or I guess ir-lirc-codec) for transmit functionality.
> 
> > Right now, only the cx23885 driver uses it:
> > 
> > linux/drivers/media/video/cx23885/cx23888-ir.[ch]
> > 
> > I have the skeleton of transmit for the device implemented (it does need
> > some fixing up).
> > 
> > (The CX23888 hardware is nice in that it only deals with raw pulses so
> > one can decode any protocol and transmit any protocols.  The hardware
> > provides hardware counter/timers for measuring incoming pulses and
> > sending outgoing pulses.)
> 
> This interface is bound to V4L needs. As the Remote Controller subsystem
> is meant to support not only V4L or DVB IR's, but also other kinds of remote
> controllers that aren't associated to media devices, it makes no sense on
> binding TX to this interface. 
> 
> The biggest advantage of V4L subdev interface is that a command, like VIDIOC_S_STD
> could be sent to several devices that may need to know what's the current standard,
> in order to configure audio, video, etc. It also provides a nice way to access
> devices on a device-internal bus. In the case of RC, I don't see any similar
> need. So, IMO, the better is to use an in interface similar to RX for TX, e. g.,
> something like:
> 	rc_register_tx()
> 	rc_unregister_tx()
> 	rc_send_code()

Right, I agree.  The v4l2_subdev ir_ops is a detail hidden by the bridge
driver and the bridge driver needs to deal with that.  A registration
process seems to be the proper way to do things.

BTW, maybe

	rc_set_tx_parameters()

is needed as well to set up the parameters for the transmitter.

I haven't looked very hard at rc_register_rx() and related functions so
I will soon.  

Regards,
Andy

