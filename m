Return-path: <mchehab@pedra>
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:53798 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1ECUWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 16:22:00 -0400
Date: Tue, 3 May 2011 22:16:44 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110503221644.1b5f3490@darkstar>
In-Reply-To: <63E3BF90-BF19-43E3-B8DD-6D6F4896F2E7@wilsonet.com>
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
	<63E3BF90-BF19-43E3-B8DD-6D6F4896F2E7@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Tue, 3 May 2011 11:40:06 -0400
schrieb Jarod Wilson <jarod@wilsonet.com>:

> So there are really two issues here. First up, the default keymap
> isn't correct for this device, and second, the behavior of the
> hardware and/or driver is terrible, as only ~20% of keypresses
> are getting though. The first is easy enough to remedy. The second
> probably requires someone with the hardware to dig into its IR
> handling routines in the kernel. (I haven't got the hardware).

It's most likely the driver or the cx88xx kernel module, because the
remote control has worked perfectly for many years.

Heiko
