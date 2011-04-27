Return-path: <mchehab@pedra>
Received: from smtprelay03.ispgateway.de ([80.67.29.28]:41821 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab1D0Ui4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 16:38:56 -0400
Date: Wed, 27 Apr 2011 22:38:28 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110427223828.15e0264f@darkstar>
In-Reply-To: <20110427222855.2e3a3a4d@darkstar>
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
 <20110427222855.2e3a3a4d@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Wed, 27 Apr 2011 22:28:55 +0200
schrieb Heiko Baums <lists@baums-on-web.de>:

> It already said "type: NEC". But I ran `sed -i
> "s:x14:x4eb:g" /etc/rc_keymaps/nec_terratec_cinergy_xs` so that it
> says e.g. 0x4eb02 KEY_1 instead of 0x1402 KEY_1.
> 
> And now it spits out a bit more, but I'm still getting scancodes only
> very randomly.
> 
> When pressing the "1" key, ir-keytable -t now gives me:
> 
> Testing events. Please, press CTRL-C to abort.
> 1303935368.238345: event MSC: scancode = 4eb02
> 1303935368.238373: event key down: KEY_1 (0x0002)
> 1303935368.238376: event sync
> 11303935368.278350: event MSC: scancode = 4eb02
> 1303935368.294324: event MSC: scancode = 4eb02
> 1303935368.390373: event MSC: scancode = 4eb02
> 1303935368.398335: event MSC: scancode = 4eb02
> 1303935368.648245: event key up: KEY_1 (0x0002)
> 1303935368.648258: event sync
> 
> But, like I said before, it doesn't react always. Let's say, if I
> press the keys about 10 times I only get 2 or 3 scancodes, if not
> less.

Now I tried to only activate the nec protocol, and the reaction is
still not good, but slightly better.

Heiko
