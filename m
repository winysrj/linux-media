Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56442 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1ECPr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 11:47:57 -0400
Received: by eyx24 with SMTP id 24so66492eyx.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 08:47:56 -0700 (PDT)
MIME-Version: 1.0
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
Date: Tue, 3 May 2011 11:47:55 -0400
Message-ID: <BANLkTik+gYRfhDBy9JWgvo+GWJk5Uz7RMQ@mail.gmail.com>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Heiko Baums <lists@baums-on-web.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 3, 2011 at 11:40 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> So there are really two issues here. First up, the default keymap
> isn't correct for this device, and second, the behavior of the
> hardware and/or driver is terrible, as only ~20% of keypresses
> are getting though. The first is easy enough to remedy. The second
> probably requires someone with the hardware to dig into its IR
> handling routines in the kernel. (I haven't got the hardware).

Jarod,

If this is something you have an interest in digging into, I can
probably find some cx88 hardware to loan you.  I don't have the
Terratec board in question, but I probably have a PCTV 800i which I
believe also does sampling via GPIO.

Let me know if you're interested,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
