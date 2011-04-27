Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51027 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1D0TTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 15:19:14 -0400
Received: by wya21 with SMTP id 21so1515855wya.19
        for <linux-media@vger.kernel.org>; Wed, 27 Apr 2011 12:19:13 -0700 (PDT)
References: <20110423005412.12978e29@darkstar> <20110424163530.2bc1b365@darkstar> <BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com> <20110425201835.0fbb84ee@darkstar> <A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com> <20110425230658.22551665@darkstar> <59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com> <20110427151621.5ac73e12@darkstar> <1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com> <20110427204725.2923ac99@darkstar>
In-Reply-To: <20110427204725.2923ac99@darkstar>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: "mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Date: Wed, 27 Apr 2011 15:19:16 -0400
To: Heiko Baums <lists@baums-on-web.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 27, 2011, at 2:47 PM, Heiko Baums wrote:

> Am Wed, 27 Apr 2011 14:28:41 -0400
> schrieb Jarod Wilson <jarod@wilsonet.com>:
...
>> Hrm, ok, so *something* is resulting in scancodes... This is progress!
>> (I think...) :)
> 
> I'm not too optimistic. ;-)

Heh, we'll get there...

>>> This is one line of the ir-keytable -t output:
>>> 1303909988.799949: event MSC: scancode = 4eb02
>> 
>> With rc-core debugging, there ought to be a line in all that dmesg
>> spew that contains that scancode, which would also give us the
>> protocol decoder that came up with that scancode. Based on the
>> default protocol listed for your board and the length of the
>> scancode, I'd guess that it is NEC Extended, but it could also be
>> RC-5X or maybe Sony...
> 
> This is what dmesg says:

I meant dmesg output after pressing the button that results in the
ir-keytable 4eb02 output... If I had to guess though, that was from
the "1" key on your remote, and the issue here we're facing is that
the keymap only has the last part of the scancode for lookup...

However, I think I do at least see why you have no active protocols.
It looks like the v4l-utils ir-keytable rule is loading a new map
(probably the terratec_cinergy_xs one), which doesn't have a specific
protocol listed, so no protocols get enabled.

Mauro, what's the expected behavior of ir-keytable when it loads a
keymap that says "type: UNKNOWN"?

Heiko, here's something to try:

Make a backup copy of /etc/rc_keymaps/terratec_cinergy_xs, and then
alter the original, so that it says "type: NEC" and prefix each of
the scancodes with 4eb (i.e., 0x41 KEY_HOME -> 0x4eb41 KEY_HOME).
Then load that, and see if things start actually working... (I'm
sort of shooting in the dark here, but I think its worth a try).

-- 
Jarod Wilson
jarod@wilsonet.com



