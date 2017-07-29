Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53511 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752516AbdG2KXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 06:23:24 -0400
Date: Sat, 29 Jul 2017 11:23:22 +0100
From: Sean Young <sean@mess.org>
To: Szabolcs Andrasi <andrasi.szabolcs@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable question [Ubuntu 17.04]
Message-ID: <20170729102322.7p6ipsszmvryqubs@gofer.mess.org>
References: <CAM1CkLU6gTj2zDS-9cu_POOVpByitEyi26XhKZ1W3j9AbTTK-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM1CkLU6gTj2zDS-9cu_POOVpByitEyi26XhKZ1W3j9AbTTK-Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Jul 16, 2017 at 10:26:14PM -0700, Szabolcs Andrasi wrote:
> Hi,
> 
> I'm using Ubuntu 17.04 and I installed the ir-keytable tool. The
> output of the ir-keytable command is as follows:
> 
> 
> 
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
> Driver ite-cir, table rc-rc6-mce
> Supported protocols: unknown other lirc rc-5 rc-5-sz jvc sony nec
> sanyo mce_kbd rc-6 sharp xmp
> Enabled protocols: lirc rc-6
> Name: ITE8708 CIR transceiver
> bus: 25, vendor/product: 1283:0000, version: 0x0000
> Repeat delay = 500 ms, repeat period = 125 ms
> 
> 
> 
> I'm trying to enable the supported mce_kbd protocol in addition to the
> lirc and rc-6 protocols with the
> 
> $ sudo ir-keytable -p lirc -p rc-6 -p mce_kbd
> 
> command which works as expected. If, however, I reboot my computer,
> ir-keytable forgets this change and only the lirc and rc-6 protocols
> are enabled. Is there a configuration file I can edit so that after
> the boot my IR remote still works? Or is that so that the only way to
> make it work is to write a start-up script that runs the above command
> to enable the needed protocol?

So what we have today is /etc/rc_maps.cfg, where you can select the default
keymap for a particular driver; unfortunately, you can only select one
keymap and one keymap can only have one protocol.

Ideally we could either have more than one protocol per keymap, which
would be helpful for the MCE Keyboard, or we could allow multiple keymaps
which would be great for supporting different remotes at the same time.

For now, you could add a udev rule to also enable the mce_kbd protocol.


Sean
