Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23246 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab0ICBgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 21:36:19 -0400
Subject: Re: cx23885: Message Signaled Interrupts issue
From: Andy Walls <awalls@md.metrocast.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201008310122.09742.liplianin@me.by>
References: <201008310122.09742.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 21:36:09 -0400
Message-ID: <1283477769.17527.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 2010-08-31 at 01:22 +0300, Igor M. Liplianin wrote:
> I was wondering, if someone tried 2.6.36-rc kernels with PCIe MSI enabled.
> With TeVii s470 after rmmod cx23885 && insmod cx23885 then szap some channel I have 'No irq 
> handler for vector' message. After reboot it's OK.
> I think it's A/V core interrupts involved.

Hmm.  A/V core interrupts aren't turned on for IR by default for the
TeVii S470 (you have to use a module option to turn on the IR for the
TeVii S470).  I can't recall if Steven's changes enabled A/V core
interrupts.

I'll have to look sometime this weekend, if the hurricane doesn't knock
out the electricity.

Regards,
Andy

> igor@useri:~$ szap -l10750 bridge-tv -p
> reading channels from file '/home/igor/.szap/channels.conf'
> zapping to 5 'bridge-tv':
> sat 1, frequency = 12303 MHz H, symbolrate 27500000, vpid = 0x0134, apid = 0x0100 sid = 0x003b
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> 
> Message from syslogd@localhost at Tue Aug 31 00:55:32 2010 ...
> localhost kernel: do_IRQ: 1.137 No irq handler for vector (irq -1)
> 
> Message from syslogd@localhost at Tue Aug 31 00:55:33 2010 ...
> localhost kernel: do_IRQ: 0.137 No irq handler for vector (irq -1)
> 
> Message from syslogd@localhost at Tue Aug 31 00:55:34 2010 ...
> localhost kernel: do_IRQ: 1.137 No irq handler for vector (irq -1)
> 
> Message from syslogd@localhost at Tue Aug 31 00:55:35 2010 ...
> localhost kernel: do_IRQ: 0.137 No irq handler for vector (irq -1)
> 
> 
> It is similar issue with NetUP DVB-S2 , but CI involved through GPIO interrupts.
> Compro e650f works well, though it uses neither A/V core interrupts nor GPIO interrupts.
> 
> 


