Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:60618 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbeG3Vgh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 17:36:37 -0400
Date: Mon, 30 Jul 2018 21:59:58 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, VDR User <user.vdr@gmail.com>
Subject: Re: [PATCH v3 0/5] Add BPF decoders to ir-keytable
Message-ID: <20180730195958.x7mnoqpbpahhv3j6@lenny.lan>
References: <cover.1531491415.git.sean@mess.org>
 <20180721181327.llrx2zqpindohrkt@camel2.lan>
 <20180728092930.wbokwgdfze7dyfa5@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180728092930.wbokwgdfze7dyfa5@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Sat, Jul 28, 2018 at 10:29:31AM +0100, Sean Young wrote:
> Hi Hias,
> 
> On Sat, Jul 21, 2018 at 08:13:27PM +0200, Matthias Reichl wrote:
> > Hi Sean,
> > 
> > thanks a lot, this is a really nice new feature!
> 
> Thank you for testing it and finding all those issues, it has become much
> better from your testing.
> 
> > On Fri, Jul 13, 2018 at 03:30:06PM +0100, Sean Young wrote:
> > > Once kernel v4.18 is released with IR BPF decoding, this can be merged
> > > to v4l-utils.
> > > 
> > > The idea is that IR decoders can be written in C, compiled to BPF relocatable
> > > object file. Any global variables can overriden, so we can supports lots
> > > of variants of similiar protocols (just like in the lircd.conf file).
> > > 
> > > The existing rc_keymap file format can't be used for variables, so I've
> > > converted the format to toml. An alternative would be to use the existing
> > > lircd.conf file format, but it's a very awkward file to parse in C and it
> > > contains many features which are irrelevant to us.
> > > 
> > > We use libelf to load the bpf relocatable object file.
> > > 
> > > After loading our example grundig keymap with bpf decoder, the output of
> > > ir-keytable is:
> > > 
> > > Found /sys/class/rc/rc0/ (/dev/input/event8) with:
> > >         Name: Winbond CIR
> > >         Driver: winbond-cir, table: rc-rc6-mce
> > >         LIRC device: /dev/lirc0
> > >         Attached BPF protocols: grundig
> > >         Supported kernel protocols: lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp imon
> > >         Enabled protocols: lirc
> > >         bus: 25, vendor/product: 10ad:00f1, version: 0x0004
> > >         Repeat delay = 500 ms, repeat period = 125 ms
> > > 
> > > Alternatively, you simply specify the path to the object file on the command
> > > line:
> > > 
> > > $ ir-keytable -e header_pulse=9000,header_space=4500 -p ./pulse_distance.o
> > > 
> > > Derek, please note that you can now convert the dish lircd.conf to toml
> > > and load the keymap; it should just work. It would be great to have your
> > > feedback, thank you.
> > 
> > I did a few tests with one of my RC-5 remotes, this lircd.conf file
> > https://github.com/PiSupply/JustBoom/blob/master/LIRC/lircd.conf
> > and kernel 4.18-rc5 on RPi2, with the 32bit ARM kernel and
> > gpio-ir-recv, and on LePotato / aarch64 with meson-ir.
> > 
> > lircd2toml.py did a really good job on converting it, the only
> > thing missing was the toggle_bit.
> 
> Right, there was a bug in lirc2html.py. I've added a fix to my bpf branch:
> 
> https://git.linuxtv.org/syoung/v4l-utils.git/log/?h=bpf

Thanks a lot, lircd2toml.py now also seems to detect that the lircd.conf
uses the rc-5 protocol and uses the rc-5 decoder - that's really nice!

> > When testing the converted toml (with "toggle_bit = 11" added
> > and the obvious volume keycode fixes) I noticed a couple of issues:
> > 
> > Buttons seem to be "stuck". The scancode is decoded, key_down
> > event is generated, but after release the key_down events repeat
> > indefinitely - with the built-in rc-5 decoder this works fine.
> > 
> > root@upstream:/home/hias/ir-test# ir-keytable -c -w justboom.toml -t
> > Old keytable cleared
> > Wrote 12 keycode(s) to driver
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Testing events. Please, press CTRL-C to abort.
> > 29.065820: lirc protocol(66): scancode = 0x141b
> > 29.065890: event type EV_MSC(0x04): scancode = 0x141b
> > 29.065890: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 29.065890: event type EV_SYN(0x00).
> > 29.570059: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 29.570059: event type EV_SYN(0x00).
> > 29.710062: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 29.710062: event type EV_SYN(0x00).
> > 29.850057: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 29.850057: event type EV_SYN(0x00).
> > 29.990057: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 29.990057: event type EV_SYN(0x00).
> > 30.130055: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
> > 30.130055: event type EV_SYN(0x00).
> > ...
> 
> Thanks, I had not seen this yet either. There is a fix here:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133813.html

Thanks, the patch seems to fix it, I posted a small nit in the thread.

> > Even scancodes, eg KEY_UP / scancode 0x141a, aren't decoded at
> > all, only odd scancodes work. My guess is the manchester decoder
> > could have a problem when the last bit is zero and the message
> > doesn't end with a pulse, but a (rather long) timeout.
> 
> Yep, yet another bug! I'v added a fix here:
> 
> https://git.linuxtv.org/syoung/v4l-utils.git/log/?h=bpf

Thanks, using the manchester decoder with rc-5 looks fine now!

> > (Re-)loading a bpf decoder only works 8 times. The 9th attempt
> > gives an error message.
> > 
> > # for i in `seq 1 9` ; do ir-keytable -p manchester ; done
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > Loaded BPF protocol manchester
> > Protocols changed to
> > failed to create a map: 1 Operation not permitted
> > Loaded BPF protocol manchester
> 
> There was a bug where bpf programs were leaked on detach. Unfortunately
> the fix had not made it to the branch when you were testing.
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133273.html

Thanks, this fixed worked, too!

Work is keeping me busy ATM but I'll see if I find some time to do
a few more tests. So far it's already looking very good!

so long,

Hias
