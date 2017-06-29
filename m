Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37069 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdF2ToI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 15:44:08 -0400
Date: Thu, 29 Jun 2017 20:44:05 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Trying to use IR driver for my SoC
Message-ID: <20170629194405.GA15901@gofer.mess.org>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
 <204a429c-b886-63a7-4d59-522864f05030@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <204a429c-b886-63a7-4d59-522864f05030@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 09:12:48PM +0200, Mason wrote:
> On 29/06/2017 19:50, Sean Young wrote:
> 
> > On Thu, Jun 29, 2017 at 06:25:55PM +0200, Mason wrote:
> >
> >> $ ir-keytable -v -t
> >> Found device /sys/class/rc/rc0/
> >> Input sysfs node is /sys/class/rc/rc0/input0/
> >> Event sysfs node is /sys/class/rc/rc0/input0/event0/
> >> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
> >> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
> >> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
> >> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
> >> Parsing uevent /sys/class/rc/rc0/uevent
> >> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
> >> input device is /dev/input/event0
> >> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
> >> /sys/class/rc/rc0/protocols protocol nec (disabled)
> >> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
> 
> I had overlooked this. Is it expected for these protocols
> to be marked as "disabled"?

Ah, good point, I forgot about that. :/

"ir-keytable -p all -t -v" should enable all protocols and test.

> >> Opening /dev/input/event0
> >> Input Protocol version: 0x00010001
> >> Testing events. Please, press CTRL-C to abort.
> >> ^C
> >>
> >> Is rc-empty perhaps not the right choice?
> > 
> > rc-empty means there is no mapping from scancode to keycode. When you
> > run "ir-keytable -v -t" you should at see scancodes when the driver
> > generates them with rc_keydown().
> 
> So the mapping can be done either in the kernel, or in
> user-space by the application consuming the scancodes,
> right?

That's right, although I do not know of any user-space application that does
this; scancodes are mostly useful for debugging.

> > From a cursory glance at the driver I can't see anything wrong.
> > 
> > The only thing that stands out is RC5_TIME_BASE. If that is the bit
> > length or shortest pulse/space? In the latter case it should be 888 usec.
> 
> Need to locate some docs.
> 
> > It might be worth trying nec, rc5 and rc6_0 and seeing if any of them decode.
> 
> What do you mean? How do I try them?

Well, presumably you're using a remote control for testing. It would be 
useful if you had remotes which could do all protocols that the IR 
receiver supports, so you can try all three of them.

Another way of doing this is using an IR transmitter and using ir-ctl to
send scancodes.


Sean
