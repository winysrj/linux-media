Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JUoAI-000118-9M
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 20:11:34 +0100
Message-ID: <47C7076B.6060903@philpem.me.uk>
Date: Thu, 28 Feb 2008 19:11:39 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Patrik Hansson <patrik@wintergatan.com>
References: <47A98F3D.9070306@raceme.org>
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>	<1202330097.4825.3.camel@anden.nu>
	<47AB1FC0.8000707@raceme.org>	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	<47C4661C.4030408@philpem.me.uk>	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
In-Reply-To: <8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
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

Patrik Hansson wrote:
> 20:37:40 up 1 day, 8 min ...and counting, both tuners working fine.
> 
> There are two:
> [14153.150380] mt2060 I2C read failed
> [18967.903269] mt2060 I2C read failed
> recorded in dmesg but nothing fatal.

philpem@dragon:~$ uptime
  19:06:28 up 23:42,  3 users,  load average: 1.19, 1.22, 1.18

And the log is full of this crap:
Feb 28 06:29:13 dragon syslogd 1.5.0#1ubuntu1: restart.
Feb 28 06:29:13 dragon kernel: [39865.332785] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.333946] cx24123_readreg: reg=0x20 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.432586] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.433733] cx24123_readreg: reg=0x20 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.532380] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.533473] cx24123_readreg: reg=0x20 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.632210] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.633301] cx24123_readreg: reg=0x20 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.731998] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:13 dragon kernel: [39865.733092] cx24123_readreg: reg=0x20 
(error=-121)
Feb 28 06:29:14 dragon kernel: [39865.831820] cx24123_readreg: reg=0x14 
(error=-121)
Feb 28 06:29:14 dragon kernel: [39866.374256] mt2060 I2C write failed (len=2)
Feb 28 06:29:14 dragon kernel: [39866.374262] mt2060 I2C write failed (len=6)
Feb 28 06:29:14 dragon kernel: [39866.374264] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.382298] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.390210] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.398195] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.406181] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.414175] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.422213] mt2060 I2C read failed
Feb 28 06:29:14 dragon kernel: [39866.430162] mt2060 I2C read failed

And the tuner is utterly shot. It worked for most of one recording, then 
promptly died.

*sigh*

Patrik, just out of curiosity, what kernel are you running?
I'm running 2.6.24-8-generic on Mythbuntu 8.04 alpha 2 and thinking about 
downgrading to an earlier kernel.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
