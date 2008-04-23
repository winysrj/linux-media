Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <luca.i@gmx.net>) id 1JoeF2-0003LX-IP
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 14:38:29 +0200
From: Luca Ingianni <luca.i@gmx.net>
To: "Henrik Beckman" <henrik.list@gmail.com>
Date: Wed, 23 Apr 2008 14:37:58 +0200
References: <200804181939.39153.luca.i@gmx.net>
	<200804230732.40813.luca.i@gmx.net>
	<af2e95fa0804230223l4800884ch145fdcd22f5013a7@mail.gmail.com>
In-Reply-To: <af2e95fa0804230223l4800884ch145fdcd22f5013a7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804231437.58967.luca.i@gmx.net>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge Nova-TD trouble: still or again?
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Mittwoch 23 April 2008 11:23:03 schrieb Henrik Beckman:
> Working ok for me on Gutsy, Abit 630i motherboard.
> About the kernel, the bug is fixed in 2.6.24-14 for ubuntu, are you running
> an Ubuntu kernel or your own ?

THanks for your reply Hendrik.

I'm running the stock Ubuntu hardy kernel
luca@godzilla:~$ uname -a
Linux godzilla 2.6.24-16-generic #1 SMP Thu Apr 10 12:47:45 UTC 2008 x86_64 
GNU/Linux
and according to the Ubuntu bugtracker it should have been fixed for 2.6.24-14 
in ubuntu, as you say. I've also checked, the fix *is* in the sources, so 
everything *should* be right.

Right at this moment I'm compiling from Ubuntu sources using a stock 
Ubuntu .config, just to make sure the fix actually made it into the kernel 
binary.
I'll report back after I've tried the new kernel, but if this doesn't help I'm 
kind of stumped.

Have fun,
Luca

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
