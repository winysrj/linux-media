Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46359 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756647AbdGLHVs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 03:21:48 -0400
Date: Wed, 12 Jul 2017 08:21:46 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Trying to use IR driver for my SoC
Message-ID: <20170712072145.vohhcqbzmwvnwxnx@gofer.mess.org>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
 <204a429c-b886-63a7-4d59-522864f05030@free.fr>
 <20170629194405.GA15901@gofer.mess.org>
 <0e2089ae-23cf-33fc-7c3d-68b7ab43ef57@free.fr>
 <20170711183557.ir4h7nqx2rrr3mbf@gofer.mess.org>
 <e26579c0-6f4f-7e4f-e9ad-b2998121aac4@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e26579c0-6f4f-7e4f-e9ad-b2998121aac4@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 11:51:02PM +0200, Mason wrote:
> On 11/07/2017 20:35, Sean Young wrote:
> 
> > Mason wrote:
> >
> >> Repeating the test (pressing '1' for one second) with ir-keytable:
> >>
> >> # ir-keytable -p all -t -v
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
> >> Opening /dev/input/event0
> >> Input Protocol version: 0x00010001
> >> /sys/class/rc/rc0//protocols: Invalid argument
> >> Couldn't change the IR protocols
> >> Testing events. Please, press CTRL-C to abort.
> >> 1296.124872: event type EV_MSC(0x04): scancode = 0x4cb41
> >> 1296.124872: event type EV_SYN(0x00).
> >> 1296.178753: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.178753: event type EV_SYN(0x00).
> >> 1296.286526: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.286526: event type EV_SYN(0x00).
> >> 1296.394303: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.394303: event type EV_SYN(0x00).
> >> 1296.502081: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.502081: event type EV_SYN(0x00).
> >> 1296.609857: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.609857: event type EV_SYN(0x00).
> >> 1296.717635: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.717635: event type EV_SYN(0x00).
> >> 1296.825412: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.825412: event type EV_SYN(0x00).
> >> 1296.933189: event type EV_MSC(0x04): scancode = 0x00
> >> 1296.933189: event type EV_SYN(0x00).
> >> 1297.040967: event type EV_MSC(0x04): scancode = 0x00
> >> 1297.040967: event type EV_SYN(0x00).
> >> 1297.148745: event type EV_MSC(0x04): scancode = 0x00
> >> 1297.148745: event type EV_SYN(0x00).
> >> 1297.256522: event type EV_MSC(0x04): scancode = 0x00
> >> 1297.256522: event type EV_SYN(0x00).
> >>
> >> It looks like scancode 0x00 means "REPEAT" ?
> > 
> > This looks like nec repeat to me; nec repeats are sent every 110ms;
> > however when a repeat occurs, the driver should call rc_repeat(),
> > sending a scancode of 0 won't work.
> 
> IIUC, the driver requires some fixup, to behave as user-space
> would expect; is that correct?

Yes, it does.

> Are you the reviewer for rc drivers?

Yes, I am. However there is plenty of knowledge on rc on this list. :)

> >> And 0x4cb41 would be '1' then?
> >>
> >> If I compile the legacy driver (which is much more cryptic)
> >> it outputs 04 cb 41 be
> > 
> > ~0xbe = 0x41. The code in tangox_ir_handle_nec() has decoded this
> > into extended nec (so the driver should send RC_TYPE_NECX), see
> > https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c#L68
> 
> Another required fixup IIUC, right?

Yes, there is.

> Thank you so much for all the insight you've provided.

np. It's nice to see this driver mainlined.

Thanks,
Sean
