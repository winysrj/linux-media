Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep19-int.chello.at ([62.179.121.39]:28307 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbZLFMwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 07:52:19 -0500
Message-ID: <4B1BA901.3080703@waechter.wiz.at>
Date: Sun, 06 Dec 2009 13:52:17 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Mantis =?UTF-8?B?4oCTIGFueW9uZT8=?=
References: <4B0E6CC0.9030207@waechter.wiz.at> <1a297b360912042154q619caa3dkf3818793f46c2c50@mail.gmail.com>
In-Reply-To: <1a297b360912042154q619caa3dkf3818793f46c2c50@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu,

Thanks for taking care.

> Please try http://jusst.de/hg/v4l-dvb
> and report the issues

It looks as if dependencies and frontends are not in line.

• dependencies for my card’s relevant frontends STB0899, STB6100, and
LNBP21 are missing from Kconfig,
• dependency for CU1216 is in, but frontend driver source missing. It’s
neither in my kernel 2.6.32 sources nor in linuxtv’s v4l-dvb.

So, mantis_core is automatically selected and compiled, hopper too, but
not mantis.

Worked around it by adding/replacing the dependencies (in fact, removing
the dependency for CU1216 should have enabled build of mantis).

Remaining issues for me:

• Can’t lock to 19.2/11303h (looks like something new, related to the
change of the transponder’s feed, but other cards – e.g. TBS 6920 and
Tevii 470 – do sync without a problem). Looks like a frontend issue to
me (STB0899/STB6100), as mantis and budget-ci cards are affected in the
same way. This correlates with perfect and quick lock of 19.2/11362h
which is about the same frequency and has the same DVB parameters
(22000/hC23M5O35S1).

• Sometimes very slow lock at transponder change, slow enough to trace
it in femon. femon first shows high BER rates and the picture is blocky,
reducing within 3 or 4 Seconds to BER=0 and perfect picture. I should be
able to repeat that and give you some logs if you need it.

• Sometimes lock to a transponder only in certain order of previous
transponder. Hard to formalize, though. Verbose module output shows 1 to
2 unsuccessful locking attempts per second by the driver.

• Still no 0x0000-0xffff SNR and STR range.

• Currently no lock on 19.2/12693h either, but this may be a signal
quality issue on my side.

• Have not yet tried it with two mantis cards in a system, but there was
a problem at least with ci handling in such a setup using s2-liplianin
for a friend of mine. Will test that next week.

• Have not tried IR (I use a radio RCU with lirc).

– Matthias
