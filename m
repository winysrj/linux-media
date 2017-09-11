Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:4834 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbdIKOh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 10:37:57 -0400
To: Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
From: Mason <slash.tmp@free.fr>
Subject: IR driver support for tango platforms
Message-ID: <6076a18d-c5ba-cb83-ac36-8eda965c7eb8@free.fr>
Date: Mon, 11 Sep 2017 16:37:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sean,

After a long hiatus, I can now work again on the IR driver support
for tango platforms. I'm still using this driver:

https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c

There are two nits I'd like to discuss.

A) When I hold a key on the RC, ir-keytable reports scancode = 0x00
instead of the scancode for the repeated key.

# ir-keytable -t -v
[   70.561432] show_protocols: allowed - 0x4204, enabled - 0x0
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input0/
Event sysfs node is /sys/class/rc/rc0/input0/event0/
Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
/sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
/sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
/sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-empty
input device is /dev/input/event0
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (disabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Opening /dev/input/event0
Input Protocol version: 0x00010001
Testing events. Please, press CTRL-C to abort.
[  227.977324] rc_keydown: keycode=0
227.980533: event type EV_MSC(0x04): scancode = 0x4cb41
227.980533: event type EV_SYN(0x00).
228.031069: event type EV_MSC(0x04): scancode = 0x00
228.031069: event type EV_SYN(0x00).
228.138834: event type EV_MSC(0x04): scancode = 0x00
228.138834: event type EV_SYN(0x00).
228.246603: event type EV_MSC(0x04): scancode = 0x00
228.246603: event type EV_SYN(0x00).
228.354373: event type EV_MSC(0x04): scancode = 0x00
228.354373: event type EV_SYN(0x00).
228.462143: event type EV_MSC(0x04): scancode = 0x00
228.462143: event type EV_SYN(0x00).
228.569913: event type EV_MSC(0x04): scancode = 0x00
228.569913: event type EV_SYN(0x00).

This behavior is caused by ir_do_keydown() not recording the keypress
when keycode == KEY_RESERVED

If I apply the following patch, then the repeated scancode works
as I would expect.

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -687,6 +687,10 @@ void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 togg
         unsigned long flags;
         u32 keycode = rc_g_keycode_from_table(dev, scancode);
  
+       printk("%s: keycode=%x\n", __func__, keycode);
+       if (keycode == KEY_RESERVED)
+               keycode = KEY_UNKNOWN;
+
         spin_lock_irqsave(&dev->keylock, flags);
         ir_do_keydown(dev, protocol, scancode, keycode, toggle);
  


# ir-keytable -t -v
[   68.192161] show_protocols: allowed - 0x4204, enabled - 0x0
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input0/
Event sysfs node is /sys/class/rc/rc0/input0/event0/
Parsing uevent /sys/class/rc/rc0/input0/event0/uevent
/sys/class/rc/rc0/input0/event0/uevent uevent MAJOR=13
/sys/class/rc/rc0/input0/event0/uevent uevent MINOR=64
/sys/class/rc/rc0/input0/event0/uevent uevent DEVNAME=input/event0
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-empty
input device is /dev/input/event0
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (disabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Opening /dev/input/event0
Input Protocol version: 0x00010001
Testing events. Please, press CTRL-C to abort.
[   92.739308] rc_keydown: keycode=0
[   92.742650] tango-ir: key down event, key 0x00f0, protocol 0x0009, scancode 0x0004cb41
92.749621: event type EV_MSC(0x04): scancode = 0x4cb41
92.749621: event type EV_SYN(0x00).
92.792201: event type EV_MSC(0x04): scancode = 0x4cb41
92.792201: event type EV_SYN(0x00).
92.899966: event type EV_MSC(0x04): scancode = 0x4cb41
92.899966: event type EV_SYN(0x00).
93.007734: event type EV_MSC(0x04): scancode = 0x4cb41
93.007734: event type EV_SYN(0x00).
93.115501: event type EV_MSC(0x04): scancode = 0x4cb41
93.115501: event type EV_SYN(0x00).
93.223269: event type EV_MSC(0x04): scancode = 0x4cb41
93.223269: event type EV_SYN(0x00).
93.331039: event type EV_MSC(0x04): scancode = 0x4cb41
93.331039: event type EV_SYN(0x00).
[   93.600995] keyup key 0x00f0


I'm confused. Does this mean a keymap is mandatory?
I thought it was possible to handle the "scancode to keycode"
stepin user-space?


B) Currently, the driver doesn't seem to allow selective protocol
enabling/disabling. It just silently enables all protocols at init.

It would seem useful to add support for that, so that the HW
doesn't fire spurious RC5 interrupts for NEC events.

What do you think?

Regards.


Archives of previous threads:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg114854.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg115316.html
