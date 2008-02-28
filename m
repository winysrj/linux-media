Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JUogk-0003rH-Lj
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 20:45:06 +0100
From: Nicolas Will <nico@youplala.net>
To: Philip Pemberton <lists@philpem.me.uk>
In-Reply-To: <47C7076B.6060903@philpem.me.uk>
References: <47A98F3D.9070306@raceme.org>
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>
	<1202330097.4825.3.camel@anden.nu> <47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk>
Date: Thu, 28 Feb 2008 19:43:52 +0000
Message-Id: <1204227832.21493.11.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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


On Thu, 2008-02-28 at 19:11 +0000, Philip Pemberton wrote:
> philpem@dragon:~$ uptime
>   19:06:28 up 23:42,  3 users,  load average: 1.19, 1.22, 1.18
> 
> And the log is full of this crap:
> Feb 28 06:29:13 dragon syslogd 1.5.0#1ubuntu1: restart.
> Feb 28 06:29:13 dragon kernel: [39865.332785] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.333946] cx24123_readreg:
> reg=0x20 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.432586] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.433733] cx24123_readreg:
> reg=0x20 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.532380] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.533473] cx24123_readreg:
> reg=0x20 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.632210] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.633301] cx24123_readreg:
> reg=0x20 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.731998] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:13 dragon kernel: [39865.733092] cx24123_readreg:
> reg=0x20 
> (error=-121)
> Feb 28 06:29:14 dragon kernel: [39865.831820] cx24123_readreg:
> reg=0x14 
> (error=-121)
> Feb 28 06:29:14 dragon kernel: [39866.374256] mt2060 I2C write failed
> (len=2)
> Feb 28 06:29:14 dragon kernel: [39866.374262] mt2060 I2C write failed
> (len=6)
> Feb 28 06:29:14 dragon kernel: [39866.374264] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.382298] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.390210] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.398195] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.406181] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.414175] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.422213] mt2060 I2C read failed
> Feb 28 06:29:14 dragon kernel: [39866.430162] mt2060 I2C read failed
> 
> And the tuner is utterly shot. It worked for most of one recording,
> then 
> promptly died.
> 
> *sigh*
> 
> Patrik, just out of curiosity, what kernel are you running?
> I'm running 2.6.24-8-generic on Mythbuntu 8.04 alpha 2 and thinking
> about 
> downgrading to an earlier kernel.

You do know that the cx24123 module has nothing to do with the
Nova-t-500, don't you?

Would you have a DVB-S card in the system as well?

I do, and I have this module loaded too,  zero error message involving
it, and I'm not really losing any tuner in normal use.

I have
      * 1 Hauppauge Nova-t-500
      * 1 KWorld DVB-S 100
      * Gutsy 64-bit system
      * Ubuntu 2.6.22 kernel
      * Ubuntu updates+backports
      * Medibuntu
      * Mythbuntu's 0.20.2-fixes updates
      * a recent v4l-dvb tree compiles against the Ubuntu headers.

The only other USB device I am using is an RF transmitter for my
keyboard.

All (and I like documenting) details there:

http://www.youplala.net/linux/home-theater-pc




Other than this issue, how's the stability of 0.21 in Hardy?
I'm itching... After al,l I ran Gutsy since alpha 2, for hardware
support reasons, but I have no real motivation apart from "I want to try
the latest and greatest" today.

nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
