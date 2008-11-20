Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L3GJi-0008AR-MO
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 21:39:59 +0100
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 729771C8C09
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 15:39:51 -0500 (EST)
Message-Id: <1227213591.29403.1285914127@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "Linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
In-Reply-To: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
Date: Thu, 20 Nov 2008 20:39:51 +0000
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

I'll do a test build in the next hour or so and confirm behaviour with:

- a Hauppauge Nova-T 500 (PCI)
- a Hauppauge Nova-TD USB stick

This will be my test gentoo system built from scratch with 2.6.25. 
Everything apart from remote was working correctly until I pulled a
recent version down from mercurial.  My last build, based on Mercurial
from a few days ago has got my Nova-T 500 bitching away with i2c errors
if I stop of the lirc daemon.

On Thu, 20 Nov 2008 10:14:43 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> After seeing some recent edits to the LinuxTV DVB wiki, I think it is
> probably worth a more general announcement:
> 
> http://www.linuxtv.org/wiki/index.php?title=Template:Firmware:dvb-usb-dib0700&curid=3008&diff=17297&oldid=17296
> 
> The dib0700 remote control problem that people were seeing with
> firmware 1.20 has been fixed.  It was checked in at hg 9640, and will
> work "out of the box" with no need to play with modprobe options.
> 
> Those of you still having problems should update to the latest v4l-dvb
> code.  If you still have issues, please feel free to email me and I
> will investigate.
> 
> Thank you,
> 
> Devin
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
