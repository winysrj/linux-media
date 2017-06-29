Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44147 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752378AbdF2Pz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 11:55:59 -0400
Date: Thu, 29 Jun 2017 16:55:57 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Trying to use IR driver for my SoC
Message-ID: <20170629155557.GA12980@gofer.mess.org>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thu, Jun 29, 2017 at 05:29:01PM +0200, Mason wrote:
> I'm trying to use an IR driver written for my SoC:
> https://github.com/mansr/linux-tangox/blob/master/drivers/media/rc/tangox-ir.c
> 
> I added these options to my defconfig:
> 
> +CONFIG_MEDIA_SUPPORT=y
> +CONFIG_MEDIA_RC_SUPPORT=y
> +CONFIG_RC_DEVICES=y
> +CONFIG_IR_TANGO=y
> 
> (I don't think I need the RC decoders, because the HW is supposed
> to support HW decoding of NEC, RC5, RC6).

I haven't seen this driver before, what hardware is this for?

> These are the logs printed at boot:
> 
> [    1.827842] IR NEC protocol handler initialized
> [    1.832407] IR RC5(x/sz) protocol handler initialized
> [    1.837491] IR RC6 protocol handler initialized
> [    1.842049] IR JVC protocol handler initialized
> [    1.846606] IR Sony protocol handler initialized
> [    1.851248] IR SANYO protocol handler initialized
> [    1.855979] IR Sharp protocol handler initialized
> [    1.860708] IR MCE Keyboard/mouse protocol handler initialized
> [    1.866575] IR XMP protocol handler initialized
> [    1.871232] tango-ir 10518.ir: SMP86xx IR decoder at 0x10518/0x105e0 IRQ 21
> [    1.878241] Registered IR keymap rc-empty
> [    1.882457] input: tango-ir as /devices/platform/soc/10518.ir/rc/rc0/input0
> [    1.889473] tango_ir_open
> [    1.892105] rc rc0: tango-ir as /devices/platform/soc/10518.ir/rc/rc0
> 
> 
> I was naively expecting some kind of dev/input/event0 node
> I could cat to grab all the remote control key presses.
> 
> But I don't see anything relevant in /dev

Do you have CONFIG_INPUT_EVDEV set? Is udev setup to create the devices?
 
> /sys/devices/platform/soc/10518.ir/rc/rc0/input0$ ls -l
> total 0
> drwxr-xr-x    2 root     root             0 Jan  1 00:00 capabilities
> lrwxrwxrwx    1 root     root             0 Jan  1 00:07 device -> ../../rc0
> drwxr-xr-x    2 root     root             0 Jan  1 00:07 id
> -r--r--r--    1 root     root          4096 Jan  1 00:07 modalias
> -r--r--r--    1 root     root          4096 Jan  1 00:00 name
> -r--r--r--    1 root     root          4096 Jan  1 00:07 phys
> -r--r--r--    1 root     root          4096 Jan  1 00:00 properties
> lrwxrwxrwx    1 root     root             0 Jan  1 00:07 subsystem -> ../../../../../../../class/input
> -rw-r--r--    1 root     root          4096 Jan  1 00:00 uevent
> -r--r--r--    1 root     root          4096 Jan  1 00:07 uniq
> 
> $ cat *
> cat: read error: Is a directory
> cat: read error: Is a directory
> cat: read error: Is a directory
> input:b0000v0000p0000e0000-e0,1,4,14,k98,ram4,lsfw
> tango-ir
> tango-ir/input0
> 0
> cat: read error: Is a directory
> PRODUCT=0/0/0/0
> NAME="tango-ir"
> PHYS="tango-ir/input0"
> PROP=0
> EV=100013
> KEY=1000000 0 0 0 0
> MSC=10
> MODALIAS=input:b0000v0000p0000e0000-e0,1,4,14,k98,ram4,lsfw
> 
> 
> The IR interrupt count remains at 0, even I use the RC nearby.
> (It works in a legacy system, using a different driver.)

By opening the /dev/input/event0 device, tango_ir_open() gets called which
presumably enables interrupts or IR decoding for the device. It's hard to
say without knowing anything about the soc.

It would be nice to see this driver merged to mainline.


Sean
