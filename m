Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1Jy8NA-0005Dr-Pw
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 18:38:05 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jy8N1-0000GQ-Qm
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 16:37:55 +0000
Received: from 213-140-22-66.fastres.net ([213.140.22.66])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 16:37:55 +0000
Received: from kaboom by 213-140-22-66.fastres.net with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 16:37:55 +0000
To: linux-dvb@linuxtv.org
From: Francesco Schiavarelli <kaboom@tiscalinet.it>
Date: Mon, 19 May 2008 18:37:44 +0200
Message-ID: <g0sact$e6d$1@ger.gmane.org>
References: <g072jh$h25$1@ger.gmane.org>
Mime-Version: 1.0
In-Reply-To: <g072jh$h25$1@ger.gmane.org>
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

I've done a bit of testing and seems like the problem it's related to 
kernel version and not v4l-dvb.
I've managed to compile actual v4l-dvb (rev7901) against debian kernel 
2.6.18-4-486 and everything works.
Next step is checking every kernel between 2.6.22-3 and 2.6.25-1 trying 
to isolate the problem.

Anyone guessing which change in the kernel tree may have broken dvbnet?
Suggestions are more than welcome.

Francesco


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
