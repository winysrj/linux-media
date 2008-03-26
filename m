Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JeTRa-0006u1-2X
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 12:05:22 +0100
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JeTRU-0007hN-P1
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 11:05:16 +0000
Received: from ua-83-227-158-203.cust.bredbandsbolaget.se ([83.227.158.203])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 11:05:16 +0000
Received: from elupus by ua-83-227-158-203.cust.bredbandsbolaget.se with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 11:05:16 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Wed, 26 Mar 2008 11:05:07 +0000 (UTC)
Message-ID: <loom.20080326T105420-829@post.gmane.org>
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
	<a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
	<ea4209750803260338k48f25e8mf95c5734481d2da7@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb]
	=?utf-8?q?STK7700-PH_=28_dib7700_+_ConexantCX25842_+_?=
	=?utf-8?q?Xceive=09XC3028_=29?=
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

Albert Comerma <albert.comerma <at> gmail.com> writes:

So, to sum up. Using the "standard" configuration of dibcom 7700+xc3028 
> you managed to get dvb-t working. Perhaps you have some problem with your
> computer power management and it keeps power on usb while it's off.
> Albert
> 

Well I wouldn't consider that a problem with the computer. Rather a bug in the 
driver if it can't handle that situation. 

In my case it will always happen. The card isn't a standard usb card, it's a 
minipci(express) with a builtin usb-bridge to which the card is connected.

My guess is that something isn't getting inited properly when card has never 
been in cold state on bootup. Do you have a hint on where to look for this?

The patch for 7700+XC3028 haven't made it to trunk (to steal a svn term), so 
if you by "standard" means, the repo i mentioned in the first post and with 
the patch to detect this specific usb card then probably yes. 
I've not tested the 1.10 dibcom firmware with a full power off (I have to pull 
the powercord for it to coldboot). 
Since the error i'm getting now with the firmware from my windows drivers, are 
identical to what i kept getting with the firmware on linuxtv, i'd expect that 
it'd work if i just coldbooted the computer.


(I wonder if I ever will get used to the multitude of repositores available).




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
