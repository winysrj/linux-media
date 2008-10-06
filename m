Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1Kmte5-0002Qi-Cj
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 19:13:23 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kmte0-00010T-LT
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 17:13:16 +0000
Received: from 89-96-108-157.ip12.fastwebnet.it ([89.96.108.157])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 06 Oct 2008 17:13:16 +0000
Received: from kaboom by 89-96-108-157.ip12.fastwebnet.it with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 06 Oct 2008 17:13:16 +0000
To: linux-dvb@linuxtv.org
From: Francesco Schiavarelli <kaboom@tiscalinet.it>
Date: Mon, 06 Oct 2008 19:13:05 +0200
Message-ID: <gcdgv4$gsu$1@ger.gmane.org>
References: <g072jh$h25$1@ger.gmane.org> <g0sact$e6d$1@ger.gmane.org>
Mime-Version: 1.0
In-Reply-To: <g0sact$e6d$1@ger.gmane.org>
Subject: Re: [linux-dvb] dvbnet not working anymore with 2.6.25
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

Francesco Schiavarelli wrote:
> I've done a bit of testing and seems like the problem it's related to 
> kernel version and not v4l-dvb.
> I've managed to compile actual v4l-dvb (rev7901) against debian kernel 
> 2.6.18-4-486 and everything works.
> Next step is checking every kernel between 2.6.22-3 and 2.6.25-1 trying 
> to isolate the problem.
> 
> Anyone guessing which change in the kernel tree may have broken dvbnet?
> Suggestions are more than welcome.
> 
> Francesco

OK, now I have an update on the subject.
With older kernels (<2.6.24) ifconfig was happy even if the mac address 
of dvb0_0 was all zero.
With never kernel you need to supply the mac address explicitly, like this:

dvbnet -p 1909
ifconfig dvb0_0 hw ether 00:30:1D:01:02:01
ifconfig dvb0_0 10.0.0.1 netmask 255.255.255.255 promisc up allmulti

and then everything works again as expected.
Many thanks to ChengHsin Hsu for the fix.

Francesco


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
