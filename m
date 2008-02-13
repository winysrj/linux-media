Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JPDTh-0003p8-Lf
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 10:00:29 +0100
Received: by fk-out-0910.google.com with SMTP id z22so6225207fkz.1
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 01:00:29 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 13 Feb 2008 10:00:29 +0100
Message-Id: <1202893229.28697.0.camel@tux>
Mime-Version: 1.0
Subject: [linux-dvb] wintv nova-t stick, dib0700 and remote controllers..
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, I've just bought a Hauppauge WinTV Nova-T Stick (model 1156 italy).
It has no remote controller bundled within but it has got a IR sensor
that works good with freshly updated mercurial drivers. So why not to
try some of my tv remotes I've got? I started pressing random keys with
evtest running but nothing happened. So I took a look at dmesg and I've
seen that keycodes are being received but classified as "unknown". So my
first question was: why does the driver process keycodes instead of
passing them raw to lirc? I've looked into the code and seen that some
commercial remote is hardcoded into the source. But since my device can
receive almost every rc-5 and rc-6 remote why limit it to some known
commercial one? I've started taking notes of keycodes outputted to
kern.log by my remotes and writing some keymap for them.

I've encountered a problem; all works well with a remote from a philipps
tv but something strange happens with my sony remote let me explain what
i've understood looking at dib0700_devices.c:

1. when a remote key is received device stores key data somewhere
2. after the key press, key data into the device does not change so
retrieving it again ends up with receiving the same key even if nothing
is being pressed!!!

Key data is an array with 3 fields (4 but field 0 is always null), two
of them identifies the keycode and one is called rc_toggle.

With philipps remote:
- i press the volume up key
- the driver retrieves key data with volume up code and toggle bit 0
- the driver stop listening to events with toggle bit 0 to prevent
retrieving the last event still stored into the device.
- i press the volume up key
- the driver retrieves key data with volume up code and toggle bit 1
- ok this is a new a event, we can be sure it's not the old one still
stored and process the event.
Pressing again the same key outputs alternatively toggle bit 0 and 1.

With sony (and with a teac dvd player) remote:
- i press the volume up key
- key data is retrieved but toggle bit is ALWAYS set to 1.
- nothing happens anymore because toggle bit never changes..

I think that this behavior is not the correct one: we limit the number
of working remotes, we cannot listen to "repeated keys" (holding a key
down toggle bit does not change so we process it as a single keypress).
A good solution would be forcing the device to reset ir data after each
event but I don't know if this is achievable. Maybe calling
dib0700_rc_setup after each poll?

Thanks
Filippo




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
