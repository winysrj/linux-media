Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35257 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbdIKVMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:12 -0400
Date: Mon, 11 Sep 2017 22:12:10 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Subject: Re: IR driver support for tango platforms
Message-ID: <20170911211210.a7a2st4hfn7leec3@gofer.mess.org>
References: <6076a18d-c5ba-cb83-ac36-8eda965c7eb8@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6076a18d-c5ba-cb83-ac36-8eda965c7eb8@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mason,

On Mon, Sep 11, 2017 at 04:37:42PM +0200, Mason wrote:
> Hello Sean,
> 
> After a long hiatus, I can now work again on the IR driver support
> for tango platforms. I'm still using this driver:
> 
> https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c
> 
> There are two nits I'd like to discuss.
> 
> A) When I hold a key on the RC, ir-keytable reports scancode = 0x00
> instead of the scancode for the repeated key.
> 
> # ir-keytable -t -v
> [   70.561432] show_protocols: allowed - 0x4204, enabled - 0x0
> Found device /sys/class/rc/rc0/
> Input sysfs node is /sys/class/rc/rc0/input0/
> Event sysfs node is /sys/class/rc/rc0/input0/event0/
> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
> Parsing uevent /sys/class/rc/rc0/uevent
> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
> input device is /dev/input/event0
> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
> /sys/class/rc/rc0/protocols protocol nec (disabled)
> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
> Opening /dev/input/event0
> Input Protocol version: 0x00010001
> Testing events. Please, press CTRL-C to abort.
> [  227.977324] rc_keydown: keycode=0
> 227.980533: event type EV_MSC(0x04): scancode = 0x4cb41
> 227.980533: event type EV_SYN(0x00).
> 228.031069: event type EV_MSC(0x04): scancode = 0x00
> 228.031069: event type EV_SYN(0x00).
> 228.138834: event type EV_MSC(0x04): scancode = 0x00
> 228.138834: event type EV_SYN(0x00).
> 228.246603: event type EV_MSC(0x04): scancode = 0x00
> 228.246603: event type EV_SYN(0x00).
> 228.354373: event type EV_MSC(0x04): scancode = 0x00
> 228.354373: event type EV_SYN(0x00).
> 228.462143: event type EV_MSC(0x04): scancode = 0x00
> 228.462143: event type EV_SYN(0x00).
> 228.569913: event type EV_MSC(0x04): scancode = 0x00
> 228.569913: event type EV_SYN(0x00).
> 
> This behavior is caused by ir_do_keydown() not recording the keypress
> when keycode == KEY_RESERVED

That's interesting. I think happens. First, scancode 0x4cb1 is received
using extended nec; the scancode is reported via rc_keydown() by the
driver; no keycode is matched. so dev->last_scancode is not set.

Next a nec repeat is received; this is reported via rc_repeat(). This
function reports the last_scancode. Which is set to 0, since it was
never set to anything.

Note that this behaviour changed since commit 265a2988d202 ("media:
rc-core: consistent use of rc_repeat()"). Since then, the scancode is only
reported on rc_repeat() if the scancode translated to a key.

> If I apply the following patch, then the repeated scancode works
> as I would expect.
> 
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -687,6 +687,10 @@ void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 togg
>         unsigned long flags;
>         u32 keycode = rc_g_keycode_from_table(dev, scancode);
> +       printk("%s: keycode=%x\n", __func__, keycode);
> +       if (keycode == KEY_RESERVED)
> +               keycode = KEY_UNKNOWN;
> +
>         spin_lock_irqsave(&dev->keylock, flags);
>         ir_do_keydown(dev, protocol, scancode, keycode, toggle);
> 
> 
> # ir-keytable -t -v
> [   68.192161] show_protocols: allowed - 0x4204, enabled - 0x0
> Found device /sys/class/rc/rc0/
> Input sysfs node is /sys/class/rc/rc0/input0/
> Event sysfs node is /sys/class/rc/rc0/input0/event0/
> Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
> /sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
> /sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
> /sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
> Parsing uevent /sys/class/rc/rc0/uevent
> /sys/class/rc/rc0/uevent uevent NAME=rc-empty
> input device is /dev/input/event0
> /sys/class/rc/rc0/protocols protocol rc-5 (disabled)
> /sys/class/rc/rc0/protocols protocol nec (disabled)
> /sys/class/rc/rc0/protocols protocol rc-6 (disabled)
> Opening /dev/input/event0
> Input Protocol version: 0x00010001
> Testing events. Please, press CTRL-C to abort.
> [   92.739308] rc_keydown: keycode=0
> [   92.742650] tango-ir: key down event, key 0x00f0, protocol 0x0009, scancode 0x0004cb41
> 92.749621: event type EV_MSC(0x04): scancode = 0x4cb41
> 92.749621: event type EV_SYN(0x00).
> 92.792201: event type EV_MSC(0x04): scancode = 0x4cb41
> 92.792201: event type EV_SYN(0x00).
> 92.899966: event type EV_MSC(0x04): scancode = 0x4cb41
> 92.899966: event type EV_SYN(0x00).
> 93.007734: event type EV_MSC(0x04): scancode = 0x4cb41
> 93.007734: event type EV_SYN(0x00).
> 93.115501: event type EV_MSC(0x04): scancode = 0x4cb41
> 93.115501: event type EV_SYN(0x00).
> 93.223269: event type EV_MSC(0x04): scancode = 0x4cb41
> 93.223269: event type EV_SYN(0x00).
> 93.331039: event type EV_MSC(0x04): scancode = 0x4cb41
> 93.331039: event type EV_SYN(0x00).
> [   93.600995] keyup key 0x00f0
> 
> 
> I'm confused. Does this mean a keymap is mandatory?
> I thought it was possible to handle the "scancode to keycode"
> stepin user-space?

The handling could be better here, but for nec repeats, yes a matching
keycode is required here.


> B) Currently, the driver doesn't seem to allow selective protocol
> enabling/disabling. It just silently enables all protocols at init.
> 
> It would seem useful to add support for that, so that the HW
> doesn't fire spurious RC5 interrupts for NEC events.
> 
> What do you think?

That could be useful. In order to that, have to implement the 
rc_dev->change_protocol function; in that function, you have to tell
the hardware to not generate interrupts for protocols which aren't
disabled. So, in order to implement that you'll need to know how
to do that. Is there a datasheet available?

Thanks,

Sean
