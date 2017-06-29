Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36763 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdF2Ruj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 13:50:39 -0400
Date: Thu, 29 Jun 2017 18:50:37 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Trying to use IR driver for my SoC
Message-ID: <20170629175037.GA14390@gofer.mess.org>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 06:25:55PM +0200, Mason wrote:
> On 29/06/2017 17:55, Sean Young wrote:
> 
> > On Thu, Jun 29, 2017 at 05:29:01PM +0200, Mason wrote:
> > 
> >> I'm trying to use an IR driver written for my SoC:
> >> https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c
> >>
> >> I added these options to my defconfig:
> >>
> >> +CONFIG_MEDIA_SUPPORT=y
> >> +CONFIG_MEDIA_RC_SUPPORT=y
> >> +CONFIG_RC_DEVICES=y
> >> +CONFIG_IR_TANGO=y
> >>
> >> (I don't think I need the RC decoders, because the HW is supposed
> >> to support HW decoding of NEC, RC5, RC6).
> > 
> > I haven't seen this driver before, what hardware is this for?
> 
> Sigma Designs tango3/tango4 (SMP86xx and SMP87xx)
> 
> >> These are the logs printed at boot:
> >>
> >> [    1.827842] IR NEC protocol handler initialized
> >> [    1.832407] IR RC5(x/sz) protocol handler initialized
> >> [    1.837491] IR RC6 protocol handler initialized
> >> [    1.842049] IR JVC protocol handler initialized
> >> [    1.846606] IR Sony protocol handler initialized
> >> [    1.851248] IR SANYO protocol handler initialized
> >> [    1.855979] IR Sharp protocol handler initialized
> >> [    1.860708] IR MCE Keyboard/mouse protocol handler initialized
> >> [    1.866575] IR XMP protocol handler initialized
> >> [    1.871232] tango-ir 10518.ir: SMP86xx IR decoder at 0x10518/0x105e0 IRQ 21
> >> [    1.878241] Registered IR keymap rc-empty
> >> [    1.882457] input: tango-ir as /devices/platform/soc/10518.ir/rc/rc0/input0
> >> [    1.889473] tango_ir_open
> >> [    1.892105] rc rc0: tango-ir as /devices/platform/soc/10518.ir/rc/rc0
> >>
> >>
> >> I was naively expecting some kind of dev/input/event0 node
> >> I could cat to grab all the remote control key presses.
> >>
> >> But I don't see anything relevant in /dev
> > 
> > Do you have CONFIG_INPUT_EVDEV set? Is udev setup to create the devices?
> 
> I was indeed missing CONFIG_INPUT_EVDEV.
> 
> As for udev:
> [    2.199642] udevd[960]: starting eudev-3.2.1
> 
> $ ls -l /dev/input/
> total 0
> drwxr-xr-x    2 root     root            60 Jan  1 00:00 by-path
> crw-rw----    1 root     input      13,  64 Jan  1 00:00 event0
> 
> But still no cookie:
> $ cat /dev/input/event0
> remains mute :-(
> 
> $ ir-keytable -v -t
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
> ^C
> 
> Is rc-empty perhaps not the right choice?

rc-empty means there is no mapping from scancode to keycode. When you
run "ir-keytable -v -t" you should at see scancodes when the driver
generates them with rc_keydown().

> > By opening the /dev/input/event0 device, tango_ir_open() gets called which
> > presumably enables interrupts or IR decoding for the device. It's hard to
> > say without knowing anything about the soc.
> 
> Actually tango_ir_open() is called at boot, before any process
> has a chance to open /dev/input/event0
> 
> [    1.926730] [<c03cd9a4>] (tango_ir_open) from [<c03c8554>] (rc_open+0x44/0x6c)
> [    1.933994] [<c03c8554>] (rc_open) from [<c03be890>] (input_open_device+0x74/0xac)
> [    1.941610] [<c03be890>] (input_open_device) from [<c032f96c>] (kbd_connect+0x64/0x80)
> [    1.949570] [<c032f96c>] (kbd_connect) from [<c03bf0dc>] (input_attach_handler+0x1bc/0x1f4)
> [    1.957965] [<c03bf0dc>] (input_attach_handler) from [<c03bf58c>] (input_register_device+0x3b4/0x42c)
> [    1.967234] [<c03bf58c>] (input_register_device) from [<c03c9be8>] (rc_register_device+0x2d8/0x52c)
> [    1.976327] [<c03c9be8>] (rc_register_device) from [<c03cdcfc>] (tango_ir_probe+0x328/0x3a4)
> [    1.984815] [<c03cdcfc>] (tango_ir_probe) from [<c03508b0>] (platform_drv_probe+0x34/0x6c)
> [    1.993124] [<c03508b0>] (platform_drv_probe) from [<c034f360>] (really_probe+0x1c4/0x250)

Ah, that's interesting. The vt console taking a feed from the device, that
makes sense.

> But I have a printk in the ISR, and it's obviously not called.

>From a cursory glance at the driver I can't see anything wrong.

The only thing that stands out is RC5_TIME_BASE. If that is the bit
length or shortest pulse/space? In the latter case it should be 888 usec.

It might be worth trying nec, rc5 and rc6_0 and seeing if any of them decode.

Failing that some documentation would be great :)

> > It would be nice to see this driver merged to mainline.
> 
> +1 (especially if I can get it to work)


Sean
