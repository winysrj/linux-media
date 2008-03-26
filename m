Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JeJxR-0000oy-Tr
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 01:57:44 +0100
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JeJxF-0005it-M5
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 00:57:25 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 00:57:25 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 00:57:25 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Wed, 26 Mar 2008 01:57:16 +0100
Message-ID: <a7d0idxnqmsq.1kxbekc9wr0n1.dlg@40tude.net>
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
	<19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
Mime-Version: 1.0
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
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

On Tue, 25 Mar 2008 23:18:02 +0100, elupus wrote:

> Okey, I finally got this up and running.
> 

An update on this. I might have been wrong in the requirement of the other
firmware. What I instead found out is that if the card is in warmstate when
kernel boots, things doesn't work. (fails in the way posted first in this
thread). 
If i poweroff machine and pull the plug. It boots and then device is in
cold state. Then everything works properly.

What gives???

Regards
Joakim


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
