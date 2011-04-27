Return-path: <mchehab@pedra>
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:36233 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1D0UcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 16:32:10 -0400
Date: Wed, 27 Apr 2011 22:28:55 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110427222855.2e3a3a4d@darkstar>
In-Reply-To: <91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com>
References: <20110423005412.12978e29@darkstar>
	<20110424163530.2bc1b365@darkstar>
	<BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com>
	<20110425201835.0fbb84ee@darkstar>
	<A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com>
	<20110425230658.22551665@darkstar>
	<59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com>
	<20110427151621.5ac73e12@darkstar>
	<1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com>
	<20110427204725.2923ac99@darkstar>
	<91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Wed, 27 Apr 2011 15:19:16 -0400
schrieb Jarod Wilson <jarod@wilsonet.com>:

> Heh, we'll get there...

I hope so.

> I meant dmesg output after pressing the button that results in the
> ir-keytable 4eb02 output... If I had to guess though, that was from
> the "1" key on your remote, and the issue here we're facing is that
> the keymap only has the last part of the scancode for lookup...

It indeed was the "1" key. But the last messages in dmesg are:
[26479.026437] ir_nec_decode: NEC decode failed at state 0 (17500us
space)
[26479.026447] ir_rc5_decode: RC5(x) decode failed at state 1 (17500us
space)
[26479.026454] ir_rc6_decode: RC6 decode failed at state 0 (17500us
space)
[26479.026460] ir_jvc_decode: JVC decode failed at state 0 (17500us
space)
[26479.026466] ir_sony_decode: Sony decode failed at state 0 (17500us
space)

I don't think they are related to the keystrokes.

> However, I think I do at least see why you have no active protocols.
> It looks like the v4l-utils ir-keytable rule is loading a new map
> (probably the terratec_cinergy_xs one), which doesn't have a specific
> protocol listed, so no protocols get enabled.

Judging by this feature request there doesn't seems to be any active
protocol for every device, not only for the cx88:
https://bugs.archlinux.org/task/23673

> Mauro, what's the expected behavior of ir-keytable when it loads a
> keymap that says "type: UNKNOWN"?
> 
> Heiko, here's something to try:
> 
> Make a backup copy of /etc/rc_keymaps/terratec_cinergy_xs, and then
> alter the original, so that it says "type: NEC" and prefix each of
> the scancodes with 4eb (i.e., 0x41 KEY_HOME -> 0x4eb41 KEY_HOME).
> Then load that, and see if things start actually working... (I'm
> sort of shooting in the dark here, but I think its worth a try).

It already said "type: NEC". But I ran `sed -i
"s:x14:x4eb:g" /etc/rc_keymaps/nec_terratec_cinergy_xs` so that it says
e.g. 0x4eb02 KEY_1 instead of 0x1402 KEY_1.

And now it spits out a bit more, but I'm still getting scancodes only
very randomly.

When pressing the "1" key, ir-keytable -t now gives me:

Testing events. Please, press CTRL-C to abort.
1303935368.238345: event MSC: scancode = 4eb02
1303935368.238373: event key down: KEY_1 (0x0002)
1303935368.238376: event sync
11303935368.278350: event MSC: scancode = 4eb02
1303935368.294324: event MSC: scancode = 4eb02
1303935368.390373: event MSC: scancode = 4eb02
1303935368.398335: event MSC: scancode = 4eb02
1303935368.648245: event key up: KEY_1 (0x0002)
1303935368.648258: event sync

But, like I said before, it doesn't react always. Let's say, if I press
the keys about 10 times I only get 2 or 3 scancodes, if not less.

And dmesg now says this:
[27163.270751] ir_nec_decode: NEC (Ext) scancode 0x04eb02
[27163.270759] rc_g_keycode_from_table: cx88 IR (TerraTec Cinergy
1400 : scancode 0x4eb02 keycode 0x02
[27163.270785] ir_rc5_decode: RC5(x) decode failed at state 1 (11500us
space)
[27163.270791] ir_rc6_decode: RC6 decode failed at state 0 (11500us
space)
[27163.270797] ir_jvc_decode: JVC decode failed at state 0 (11500us
space)
[27163.270802] ir_sony_decode: Sony decode failed at state 0 (11500us
space)
[27163.520656] ir_do_keyup: keyup key 0x0002

Heiko
