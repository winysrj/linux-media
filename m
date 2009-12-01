Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49603 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZLALus (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 06:50:48 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <4B14F3EA.4090000@redhat.com>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259450815.3137.19.camel@palomino.walls.org>
	 <m3ocml6ppt.fsf@intrepid.localdomain>
	 <1259542097.5231.78.camel@palomino.walls.org> <4B14F3EA.4090000@redhat.com>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 06:49:03 -0500
Message-Id: <1259668143.3100.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-01 at 11:46 +0100, Gerd Hoffmann wrote:
> Hi,
> 
> > A current related problem is that i2c based devices can only be bound to
> > only one of ir-kbd-i2c *or* lirc_i2c *or* lirc_zilog at any one time.
> > Currently it is somewhat up to the bridge driver which binding is
> > preferred.  Discussion about this for the pvrusb2 module had the biggest
> > email churn IIRC.
> 
> Once lirc_dev is merged you can easily fix this:  You'll have *one* 
> driver which supports *both* evdev and lirc interfaces.  If lircd opens 
> the lirc interface raw data will be sent there, keystrokes come in via 
> uinput.  Otherwise keystrokes are send directly via evdev.  Problem solved.

This will be kind of strange for lirc_zilog (aka lirc_pvr150).  It
supports IR transmit on the PVR-150, HVR-1600, and HD-PVR.  I don't know
if transmit is raw pulse timings, but I'm sure the unit provides codes
on receive.  Occasionally blocks of "boot data" need to be programmed
into the transmitter side.  I suspect lirc_zilog will likely need
rework....


> cheers,
>    Gerd
> 
> PS:  Not sure this actually makes sense for the i2c case, as far I know
>       these do decoding in hardware and don't provide access to the raw
>       samples,

True.

>  so killing the in-kernel IR limits to make ir-kbd-i2c
                  ^^^^^^^^^^^^^^^^^^^ 
>       being on par with lirc_i2c might be more useful in this case.

I didn't quite understand that.  Can you provide a little more info?


Thanks,
Andy

