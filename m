Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45677 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZK3At6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 19:49:58 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <m3ocml6ppt.fsf@intrepid.localdomain>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259450815.3137.19.camel@palomino.walls.org>
	 <m3ocml6ppt.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 19:48:17 -0500
Message-Id: <1259542097.5231.78.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-29 at 21:27 +0100, Krzysztof Halasa wrote:
> 1. Do we agree that a lirc (-style) kernel-user interface is needed at
>    least?

Yes.  Honestly, I'm just waiting on lirc_dev for the IR devices I work
with.  With that I can get those new devices supported for both IR Rx
and Tx right now.  I was holding off building a lirc_v4l module to see
if lirc_dev makes it in kernel.

However, because of the desire by V4L supporters wanting IR to just work
for remotes bundled with video capture cards, I have already added:

1. cx23885-input.c support with RC-5, and soon NEC support, in kernel.

2. new configurations for ir-kbd-i2c.c, due to IR hardware on some cx18
and ivtv supported cards. 

So at least IR Rx works for the cheap bundled remote.  I still think
input subsystem will never be able to rpovide a feature complete
interface though.  I don't mind putting enough work in for the "Just
works" part with the bundled remote with -input, but not more.


> 2. Is there any problem with lirc kernel-user interface?

Here's my list

1. Unused transmit mode defines/enums.  It's not a big deal really, but
I had a hard time figuring out the differences between CODE, MODE2,
PULSE since some are not well documented and some of those are not even
used for Tx.

2. The LIRC ioctls() wanting to change one parameter at a time will
cause me some thought/work.  It would be better, I think, if LIRC would
do a get/set of all the parameters in one go.

That's what I do internally here:

http://linuxtv.org/hg/v4l-dvb/file/e0cd9a337600/linux/include/media/v4l2-subdev.h#l283
http://linuxtv.org/hg/v4l-dvb/file/e0cd9a337600/linux/drivers/media/video/cx23885/cx23888-ir.c#l746
http://linuxtv.org/hg/v4l-dvb/file/e0cd9a337600/linux/drivers/media/video/cx23885/cx23885-input.c#l269

The idea is that you set up the IR hardware infrequently and spend most
of the time letting it run.  I'd have to think, if setting up the
hardware one parameter at a time may have it operating in a strange
mode, until the sequence of configuration ioctl() is complete.

I was planning on a lirc_v4l module aggregating all the lirc_dev ioctl
requests somehow to possibly avoid that potential problem.

Maybe an additional ioctl() from LIRC userspace and lirc_dev saying it
was done with the current IR device configuration sequence would be
another way to mitigate the problem for me.




> If the answer for #1 is "yes" and for #2 is "no" then perhaps we merge
> the Jarod's lirc patches (at least the core) so at least the
> non-controversial part is done?
> 
> Doing so doesn't block improving input layer IR interface, does it?

It never has AFAICT.

A current related problem is that i2c based devices can only be bound to
only one of ir-kbd-i2c *or* lirc_i2c *or* lirc_zilog at any one time.
Currently it is somewhat up to the bridge driver which binding is
preferred.  Discussion about this for the pvrusb2 module had the biggest
email churn IIRC.

This will be a general problem to fix for all the V4L-DVB drivers where
both LIRC and input can handle the device. A reasonable default
assumption  *may* be that the user who bothers to configure LIRC wants
LIRC to override handling by input.  That's a detail though...

Regards,
Andy

