Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:47002 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753345AbdBUWw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 17:52:28 -0500
Date: Tue, 21 Feb 2017 23:52:24 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: Bug: decoders referenced in kernel rc-keymaps not loaded on boot
Message-ID: <20170221225224.GA5099@camel2.lan>
References: <20170221184929.GA2590@camel2.lan>
 <20170221193438.GA4394@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221193438.GA4394@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 21, 2017 at 07:34:39PM +0000, Sean Young wrote:
> On Tue, Feb 21, 2017 at 07:49:29PM +0100, Matthias Reichl wrote:
> > There seems to be a bug in on-demand loading of IR protocol decoders.
> > 
> > After bootup the protocol referenced in the in-kernel rc keymap shows
> > up as enabled (in sysfs and ir-keytable) but the protocol decoder
> > is not loaded and thus no rc input events will be generated.
> > 
> > For example, RPi3 with kernel 4.10 and gpio-ir-recv configured to use
> > the rc-hauppauge keymap in devicetree:
> > 
> > # lsmod | grep '^\(ir\|rc_\)'
> > ir_lirc_codec           5590  0
> > rc_hauppauge            2422  0
> > rc_core                24320  5 rc_hauppauge,ir_lirc_codec,lirc_dev,gpio_ir_recv
> > 
> > # cat /sys/class/rc/rc0/protocols
> > other unknown [rc-5] nec rc-6 jvc sony rc-5-sz sanyo sharp mce_kbd xmp cec [lirc]
> > 
> > # dmesg | grep "IR "
> > [    4.506728] Registered IR keymap rc-hauppauge
> > [    4.554651] lirc_dev: IR Remote Control driver registered, major 242
> > [    4.576490] IR LIRC bridge handler initialized
> > 
> > The same happens with other IR receivers, eg the streamzap receiver,
> > which uses the rc-5-sz protocol / ir_rc5_decoder, on x86.
> > 
> > Reverting the on-demand-loading patches
> > 
> > [media] media: rc: remove unneeded code
> > commit c1500ba0b61e9abf95e0e7ecd3c4ad877f019abe
> > 
> > [media] media: rc: move check whether a protocol is enabled to the core
> > commit d80ca8bd71f0b01b2b12459189927cb3299cfab9
> > 
> > [media] media: rc: load decoder modules on-demand
> > commit acc1c3c688ed8cc862ddc007eab0dcef839f4ec8
> > 
> > restores the previous behaviour, all decoders are enabled and IR
> > events can be generated immediately after boot without having to
> > manually trigger loading of a protocol decoder.
> 
> Hmm this seems to be working fine for me. If you write to the protocols
> file, eg. "echo +nec > /sys/class/rc/rc0/protocols", is ir-nec-decoder
> loaded and do you get any messages in dmesg (you should).
> 
> What's your config?

When I do an "echo +nec > /sys/class/rc/rc0/protocols" it triggers
the load of both rc5 and nec decoder modules:

root@rpi3:~# cat /sys/class/rc/rc0/protocols
other unknown [rc-5] nec rc-6 jvc sony rc-5-sz sanyo sharp mce_kbd xmp cec [lirc]
root@rpi3:~# echo +nec > /sys/class/rc/rc0/protocols
root@rpi3:~# cat /sys/class/rc/rc0/protocols
other unknown [rc-5] [nec] rc-6 jvc sony rc-5-sz sanyo sharp mce_kbd xmp cec [lirc]
root@rpi3:~# dmesg | grep "IR "
[    3.565061] Registered IR keymap rc-hauppauge
[    3.613031] lirc_dev: IR Remote Control driver registered, major 242
[    3.641423] IR LIRC bridge handler initialized
[   41.877263] IR RC5(x/sz) protocol handler initialized
[   41.931575] IR NEC protocol handler initialized

I'm currently testing with downstream RPi kernel 4.9 on Raspbian Jessie
(a Debian derivate).

Kernel config is here:
https://github.com/raspberrypi/linux/blob/rpi-4.9.y/arch/arm/configs/bcm2709_defconfig

To reproduce the issue it's important to disable the udev rule that
runs ir-keytable -a as that can trigger a load of the kernel keytable
via the userspace keymap/protocol.

We ran accross the issue via a bugreport from a LibreELEC user,
his streamzap remote wasn't working anymore on x86 in the beta
releases:
https://forum.libreelec.tv/thread-4873.html

Kernel-config for LibreELEC x86 is here:
https://github.com/LibreELEC/LibreELEC.tv/blob/libreelec-8.0/projects/Generic/linux/linux.x86_64.conf

Our analysis (I hope it's not completely off) is about this:

In the previous version (with kernel 4.4) it worked because
the kernel loaded the keymap and protocol decoders. The udev
rule probably failed as ir-keytable -a couldn't cope with the RC5_SZ
protocol - but that went unnoticed as everything was setup fine
by the kernel.

In current beta (with kernel 4.9) the kernel only loaded the
keymap but didn't enable the decoder. Since ir-keytable -a again
failed to setup the protocol the user was left with a non-functioning
remote.

I then could reproduce this on RPi with Raspbian and LibreELEC
using gpio-ir-recv. With udev/ir-keytable -a working the protocol
decoder is loaded, without that it isn't.

so long,

Hias
