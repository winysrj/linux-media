Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42175 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754210AbdG3SA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 14:00:29 -0400
Date: Sun, 30 Jul 2017 19:00:27 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Szabolcs Andrasi <andrasi.szabolcs@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: ir-keytable question [Ubuntu 17.04]
Message-ID: <20170730180026.2bdup5v7kk5pgurx@gofer.mess.org>
References: <CAM1CkLU6gTj2zDS-9cu_POOVpByitEyi26XhKZ1W3j9AbTTK-Q@mail.gmail.com>
 <20170729102322.7p6ipsszmvryqubs@gofer.mess.org>
 <20170729114607.2536ekbn6wzhbzpn@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170729114607.2536ekbn6wzhbzpn@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 29, 2017 at 01:46:07PM +0200, Matthias Reichl wrote:
> On Sat, Jul 29, 2017 at 11:23:22AM +0100, Sean Young wrote:
> > Hi,
> > 
> > On Sun, Jul 16, 2017 at 10:26:14PM -0700, Szabolcs Andrasi wrote:
> > > Hi,
> > > 
> > > I'm using Ubuntu 17.04 and I installed the ir-keytable tool. The
> > > output of the ir-keytable command is as follows:
> > > 
> > > 
> > > 
> > > Found /sys/class/rc/rc0/ (/dev/input/event5) with:
> > > Driver ite-cir, table rc-rc6-mce
> > > Supported protocols: unknown other lirc rc-5 rc-5-sz jvc sony nec
> > > sanyo mce_kbd rc-6 sharp xmp
> > > Enabled protocols: lirc rc-6
> > > Name: ITE8708 CIR transceiver
> > > bus: 25, vendor/product: 1283:0000, version: 0x0000
> > > Repeat delay = 500 ms, repeat period = 125 ms
> > > 
> > > 
> > > 
> > > I'm trying to enable the supported mce_kbd protocol in addition to the
> > > lirc and rc-6 protocols with the
> > > 
> > > $ sudo ir-keytable -p lirc -p rc-6 -p mce_kbd
> > > 
> > > command which works as expected. If, however, I reboot my computer,
> > > ir-keytable forgets this change and only the lirc and rc-6 protocols
> > > are enabled. Is there a configuration file I can edit so that after
> > > the boot my IR remote still works? Or is that so that the only way to
> > > make it work is to write a start-up script that runs the above command
> > > to enable the needed protocol?
> > 
> > So what we have today is /etc/rc_maps.cfg, where you can select the default
> > keymap for a particular driver; unfortunately, you can only select one
> > keymap and one keymap can only have one protocol.
> >
> > Ideally we could either have more than one protocol per keymap, which
> > would be helpful for the MCE Keyboard, or we could allow multiple keymaps
> > which would be great for supporting different remotes at the same time.
> 
> Having more than one protocol in the keymap file works fine here,
> we have been using that feature in LibreELEC for a long time now.
> Maybe it was just forgotten to document it?
> 
> $ git show 42511eb505
> commit 42511eb505b46b125652d37e764e5c8d1eb99e6b
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Sat Apr 10 21:55:28 2010 -0300
> 
>     ir-keytable: add support for more than one protocol in a table
> 
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Quick test with ir-keytable 1.12.3 from Debian Stretch:

-snip-

Yes, you're right. I was wrong.

So, first of all, in recent kernels the "lirc" protocol is always enabled
and cannot be disabled. So there is no reason to explicitly enable it.

Now if you want to enable both rc-6 and mce_kbd, is that because you want
to use the Microsoft MCE IR keyboard? It uses both rc-6 and mce_kbd
protocol.

We should really have a keymap for this device; the only difference
with the rc6_mce keyboard is that mce_kbd protocol is also used.

Would that work?


Sean
