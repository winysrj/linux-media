Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:57087 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdG2LqK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 07:46:10 -0400
Date: Sat, 29 Jul 2017 13:46:07 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Szabolcs Andrasi <andrasi.szabolcs@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: ir-keytable question [Ubuntu 17.04]
Message-ID: <20170729114607.2536ekbn6wzhbzpn@camel2.lan>
References: <CAM1CkLU6gTj2zDS-9cu_POOVpByitEyi26XhKZ1W3j9AbTTK-Q@mail.gmail.com>
 <20170729102322.7p6ipsszmvryqubs@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170729102322.7p6ipsszmvryqubs@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 29, 2017 at 11:23:22AM +0100, Sean Young wrote:
> Hi,
> 
> On Sun, Jul 16, 2017 at 10:26:14PM -0700, Szabolcs Andrasi wrote:
> > Hi,
> > 
> > I'm using Ubuntu 17.04 and I installed the ir-keytable tool. The
> > output of the ir-keytable command is as follows:
> > 
> > 
> > 
> > Found /sys/class/rc/rc0/ (/dev/input/event5) with:
> > Driver ite-cir, table rc-rc6-mce
> > Supported protocols: unknown other lirc rc-5 rc-5-sz jvc sony nec
> > sanyo mce_kbd rc-6 sharp xmp
> > Enabled protocols: lirc rc-6
> > Name: ITE8708 CIR transceiver
> > bus: 25, vendor/product: 1283:0000, version: 0x0000
> > Repeat delay = 500 ms, repeat period = 125 ms
> > 
> > 
> > 
> > I'm trying to enable the supported mce_kbd protocol in addition to the
> > lirc and rc-6 protocols with the
> > 
> > $ sudo ir-keytable -p lirc -p rc-6 -p mce_kbd
> > 
> > command which works as expected. If, however, I reboot my computer,
> > ir-keytable forgets this change and only the lirc and rc-6 protocols
> > are enabled. Is there a configuration file I can edit so that after
> > the boot my IR remote still works? Or is that so that the only way to
> > make it work is to write a start-up script that runs the above command
> > to enable the needed protocol?
> 
> So what we have today is /etc/rc_maps.cfg, where you can select the default
> keymap for a particular driver; unfortunately, you can only select one
> keymap and one keymap can only have one protocol.
>
> Ideally we could either have more than one protocol per keymap, which
> would be helpful for the MCE Keyboard, or we could allow multiple keymaps
> which would be great for supporting different remotes at the same time.

Having more than one protocol in the keymap file works fine here,
we have been using that feature in LibreELEC for a long time now.
Maybe it was just forgotten to document it?

$ git show 42511eb505
commit 42511eb505b46b125652d37e764e5c8d1eb99e6b
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Apr 10 21:55:28 2010 -0300

    ir-keytable: add support for more than one protocol in a table

    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Quick test with ir-keytable 1.12.3 from Debian Stretch:

$ sudo ir-keytable -c -p lirc,rc-6 -s rc1
Old keytable cleared
Protocols changed to lirc rc-6

$ sudo ir-keytable -r -s rc1
Enabled protocols: lirc rc-6

$ cat /etc/rc_keymaps/rc6_mce_kbd_test
# table test, type:rc-6,mce_kbd
0x01    KEY_1

$ cat test-map.cfg
* * rc6_mce_kbd_test

$ sudo ir-keytable -a test-map.cfg -s rc1
Old keytable cleared
Wrote 1 keycode(s) to driver
Protocols changed to mce_kbd rc-6

$ sudo ir-keytable -r -s rc1
scancode 0x0001 = KEY_1 (0x02)
Enabled protocols: lirc mce_kbd rc-6

so long,

Hias

> 
> For now, you could add a udev rule to also enable the mce_kbd protocol.
> 
> 
> Sean
