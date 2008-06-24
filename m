Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ftw.at ([213.235.244.131])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hyytia@ftw.at>) id 1KB9uX-0002UV-Jj
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 16:54:22 +0200
From: Esa Hyytia <esa@ftw.at>
To: linux-dvb@linuxtv.org
Date: Tue, 24 Jun 2008 16:54:07 +0200
Message-Id: <1214319247.28856.9.camel@ceres>
Mime-Version: 1.0
Subject: [linux-dvb] Problems with Terratec Cinergy Piranha
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

Hello list,

I bought today this USB stick (187f:0010) and tried to get it work in 32-bit Ubuntu 8.04:

 - Driver snapshot from today (http://linuxtv.org/hg/~mkrufky/siano)
 - Firmware is extracted from driver-cd (same as from terratec.net)
 - I also changed 'default_mode' to 0 in smscoreapi.c
 - make && make install seems to work properly
 - plugging the stick in a USB port gives the following error(s):

[ 2104.988097] smsdvb_hotplug: line: 330: SMS Device mode is not set for DVB operation.

Any hints what I could try to get further?

Thanks in advance,

Esa



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
