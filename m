Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JvDHd-0000im-Dw
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 17:16:17 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JvDHV-0002lK-RV
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 15:16:09 +0000
Received: from 213-140-22-66.fastres.net ([213.140.22.66])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 15:16:09 +0000
Received: from kaboom by 213-140-22-66.fastres.net with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 15:16:09 +0000
To: linux-dvb@linuxtv.org
From: Francesco Schiavarelli <kaboom@tiscalinet.it>
Date: Sun, 11 May 2008 17:15:56 +0200
Message-ID: <g072jh$h25$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] dvbnet not working anymore with 2.6.25
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

Hello,

I'm using debian/testing and dvbnet included in dvb-utils with in-kernel 
v4l/dvb modules.
I am able to receive IP datagrams with stock kernel 2.6.22-3-686.
After upgrading to 2.6.25-1-686 I have an error message whenever I try 
to bring up the dvb virtual network interface.
Here is what I try:

# dvbnet -p 775

DVB Network Interface Manager
Version 1.1.0-TVF (Build Mon Aug 06 21:44:42 2007)
Copyright (C) 2003, TV Files S.p.A

Device: /dev/dvb/adapter0/net0
Status: device dvb0_0 for pid 775 created successfully.

# ifconfig dvb0_0 up
SIOCSIFFLAGS: Cannot assign requested address

and RX bytes stays to zero:

# ifconfig dvb0_0
dvb0_0    Link encap:Ethernet  HWaddr 00:00:00:00:00:00
           BROADCAST NOARP MULTICAST  MTU:4096  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
           Base address:0x307

Even if I assign an IP address ther result is the same.
Using dvb_net_debug=1 with dvb-core didn't give me any useful message.

Any help would be appreciated.

thanks,
Francesco


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
