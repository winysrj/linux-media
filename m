Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1JXc2j-0007yi-Jj
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 13:51:22 +0100
From: timf <timf@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Fri, 07 Mar 2008 21:51:21 +0900
Message-Id: <1204894281.10536.8.camel@ubuntu>
Mime-Version: 1.0
Subject: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Hi Hartmut,
I noticed you had a bit to do with implementing this card.

With a fresh install of ubuntu 7.10 (kernel i386 2.6.22-14-generic),
the card is auto recognised as: Kworld DVB-T 210 (card=114)

However, tda1004 firmware does not load.
Used download-firmware, placed dvb-fe-tda10046.fw
into /lib/firmware/2.6.22-14-generic

Rebooted.

Now, again card is recognised, firmware recognised as version 20.
Here is the strange part:
- using dvb-utils scan, each time I run that I get a different result in
channels.
- I try to scan with Kaffeine - nothing
- I try to scan with Me-tv - nothing
- I try to scan with tvtime - all channels obtained ( no audio).

Now, after reboot, if I first start tvtime (analog tv), view a channel,
turn tvtime off, and then :
- if I place a previously good channels.dvb in Kaffeine - it plays all
channels.
- if I place a previously good channels.conf in Me-tv - it plays all
channels. 

Would it be correct to say that the "switch" is not working for DVB
after boot?

I have studied the code, but I need your help to point me in the right
direction.

Thanks,
Tim


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
