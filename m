Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L3K4Y-0004SP-Ax
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 01:40:35 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 3C1A11C81B7
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 19:40:30 -0500 (EST)
Message-Id: <1227228030.18353.1285952745@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "Linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
In-Reply-To: <412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
Date: Fri, 21 Nov 2008 00:40:30 +0000
Subject: Re: [linux-dvb] dib0700 remote control support fixed
Reply-To: linuxtv@hotair.fastmail.co.uk
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

OK it is working on the Nova-T 500 but it is throwing up "Unknown remote
controller key" messages in dmesg in amongst correctly processing the
correct key presses.  I'll try using irrecord to work on a new
lircd.conf and see if it goes away.


On Thu, 20 Nov 2008 15:46:56 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> On Thu, Nov 20, 2008 at 3:39 PM, petercarm
> <linuxtv@hotair.fastmail.co.uk> wrote:
> > I'll do a test build in the next hour or so and confirm behaviour with:
> >
> > - a Hauppauge Nova-T 500 (PCI)
> > - a Hauppauge Nova-TD USB stick
> >
> > This will be my test gentoo system built from scratch with 2.6.25.
> > Everything apart from remote was working correctly until I pulled a
> > recent version down from mercurial.  My last build, based on Mercurial
> > from a few days ago has got my Nova-T 500 bitching away with i2c errors
> > if I stop of the lirc daemon.
> 
> The fix only went in on Sunday evening, so it's not surprising if you
> had the issue with a relatively recent build.
> 
> Please do report back regarding how your testing goes.  Note that you
> should not have any module options setup when you do the testing.
> 
> Thanks,
> 
> Devin
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
