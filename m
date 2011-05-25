Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47227 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1EYUl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 16:41:29 -0400
Received: by qwk3 with SMTP id 3so53351qwk.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 13:41:28 -0700 (PDT)
References: <20110423005412.12978e29@darkstar> <20110424163530.2bc1b365@darkstar> <BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com> <20110425201835.0fbb84ee@darkstar> <A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com> <20110425230658.22551665@darkstar> <59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com> <20110427151621.5ac73e12@darkstar> <1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com> <20110427204725.2923ac99@darkstar> <91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com> <20110427222855.2e3a3a4d@darkstar> <63E3BF90-BF19-43E3-B8DD-6D6F4896F2E7@wilsonet.com> <BANLkTik+gYRfhDBy9JWgvo+GWJk5Uz7RMQ@mail.gmail.com> <14961B2E-36D9-4CD2-87E7-629F115055F2@wilsonet.com> <20110503222149.1ce726d9@darkstar>
In-Reply-To: <20110503222149.1ce726d9@darkstar>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <8706FD7A-A020-4357-867E-BF6FBA818C3B@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Date: Wed, 25 May 2011 16:41:35 -0400
To: Heiko Baums <lists@baums-on-web.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 3, 2011, at 4:21 PM, Heiko Baums wrote:

> Am Tue, 3 May 2011 13:16:57 -0400
> schrieb Jarod Wilson <jarod@wilsonet.com>:
> 
>> A quick look at the code suggests the 800i should indeed behave
>> more or less the same, barring any hardware-specific implementation
>> differences. Sure, might as well send one my way and I'll see what
>> I can see.
> 
> This RC indeed has the same issue.
> 
> See this forums posting:
> https://bbs.archlinux.org/viewtopic.php?pid=924385#p924385
> And this bug report:
> https://bugs.archlinux.org/task/23894

So... I have the card finally up and running in a test rig, but I
don't yet have the necessary IR receiver cable. A glance at cx88-input.c
and the default key table for the 800i gives some clues as to what is
wrong though -- this is another case where the cx88 driver was only
passing along the last byte of the remote's scancode, after the raw IR
was decoded in cx88's private decoder. Now, we should be delivering the
raw IR to the generic in-kernel IR decoders, which are then going to be
passing along full scancodes for lookup table matching.

If someone with the 800i (and/or the Terratec card) can load rc-core with
debug=2, and provide dmesg output after punching a few buttons, it might
be possible to get this squared away even before I have the necessary
receiver cable. :)

-- 
Jarod Wilson
jarod@wilsonet.com



