Return-path: <mchehab@gaivota>
Received: from smtp1.mtw.ru ([93.95.97.34]:47660 "EHLO smtp1.mtw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1EIPjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 11:39:15 -0400
Received: from 8MYHG4J.512bytes.com (unknown [81.200.112.228])
	(Authenticated sender: aj-a-j)
	by smtp1.mtw.ru (Postfix) with ESMTPA id 8894044BD33
	for <linux-media@vger.kernel.org>; Mon,  9 May 2011 19:35:07 +0400 (MSD)
Date: Mon, 9 May 2011 19:39:09 +0400
From: Andrew Junev <a-j@a-j.ru>
Reply-To: Andrew Junev <a-j@a-j.ru>
Message-ID: <925086505.20110509193909@a-j.ru>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
In-Reply-To: <157285607.20110508122321@a-j.ru>
References: <1908281867.20110505213806@a-j.ru> <BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com> <16110382789.20110506010009@a-j.ru> <BANLkTimGEL4YvXRJsFM10NfyHPOn-JsA_g@mail.gmail.com> <157285607.20110508122321@a-j.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sunday, May 8, 2011, 12:23:21 PM, you wrote:

> I installed the latest s2-liplianin drivers, but I still seem to have
> the same issue. The card works fine for some time after reboot, then I
> am starting to get the following errors in the system log:

> May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
> May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
> May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
> May  8 11:11:38 localhost kernel: ds3000_writereg: writereg
> error(err == -5, reg == 0xa1, value == 0x7b)
> May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa2(error=-5)
> May  8 11:11:38 localhost kernel: ds3000_writereg: writereg
> error(err == -5, reg == 0xa2, value == 0xbb)

> And then my machine just stops responding - even on the ssh sessions.


> A friend of mine installed the same S470 card a few days ago. He's
> using Fedora 14 (kernel 2.6.35) and he says his machine started to
> 'hang' sporadically, too... I guess he might have a similar issue...

> How could I track what is going on?


Dear All,

I still have this very annoying issue. I see no obvious reason, but
my DVB-S card just stops locking the signal, I get really a lot of
these errors in my syslog:

May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  9 19:04:33 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0x03, value == 0x12)
May  9 19:04:33 localhost kernel: ds3000_tuner_readreg: reg=0x3d(error=-5)
May  9 19:04:33 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0x03, value == 0x12)
May  9 19:04:33 localhost kernel: ds3000_tuner_readreg: reg=0x21(error=-5)
May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0x8c(error=-5)
May  9 19:04:33 localhost kernel: ds3000_readreg: reg=0x8d(error=-5)

and then the machine just freezes. Could it be some buffer overflow?

How could I track it?


The machine is perfectly stable when S470 card is out...


-- 
Best regards,
 Andrew             

