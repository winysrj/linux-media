Return-path: <mchehab@gaivota>
Received: from smtp1.mtw.ru ([93.95.97.34]:50977 "EHLO smtp1.mtw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab1ELJ5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 05:57:42 -0400
Date: Thu, 12 May 2011 13:57:36 +0400
From: Andrew Junev <a-j@a-j.ru>
Reply-To: Andrew Junev <a-j@a-j.ru>
Message-ID: <89519611.20110512135736@a-j.ru>
To: linux-media@vger.kernel.org
CC: Josu Lazkano <josu.lazkano@gmail.com>
Subject: Re: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
In-Reply-To: <925086505.20110509193909@a-j.ru>
References: <1908281867.20110505213806@a-j.ru> <BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com> <16110382789.20110506010009@a-j.ru> <BANLkTimGEL4YvXRJsFM10NfyHPOn-JsA_g@mail.gmail.com> <157285607.20110508122321@a-j.ru> <925086505.20110509193909@a-j.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Monday, May 9, 2011, 7:39:09 PM, you wrote:

> I still have this very annoying issue. I see no obvious reason, but
> my DVB-S card just stops locking the signal, I get really a lot of
> these errors in my syslog:

> May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
> May  9 19:04:33 localhost kernel: ds3000_writereg: writereg
> error(err == -5, reg == 0x03, value == 0x12)
> May  9 19:04:33 localhost kernel: ds3000_tuner_readreg: reg=0x3d(error=-5)
> May  9 19:04:33 localhost kernel: ds3000_writereg: writereg
> error(err == -5, reg == 0x03, value == 0x12)
> May  9 19:04:33 localhost kernel: ds3000_tuner_readreg: reg=0x21(error=-5)
> May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0x8c(error=-5)
> May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0x8d(error=-5)

> and then the machine just freezes. Could it be some buffer overflow?

> How could I track it?


> The machine is perfectly stable when S470 card is out...


Sorry for replying to my own's post, as I just want to make this
information available in case someone would find this mail thread
later.

The issue appear to be related to S470 overheating. I discovered that
my S470 became very-very hot right after I power the machine up, and
recently it started to freeze right after the boot. So the board was
shipped to the dealer for tests / exchange, and my machine is back to
normal operation (without a DVB-S2 card, temporarily).

My friend's board is slightly cooler - so putting a fan blowing
directly on the board seem to solve the problem for him completely
(no freezes for three days now).

So it's very likely to be hardware-related, and not a driver /
configuration issue.


-- 
Best regards,
 Andrew             

