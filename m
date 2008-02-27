Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ptsekov@gmx.net>) id 1JUV5G-0001zR-6t
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 23:49:06 +0100
Date: Thu, 28 Feb 2008 00:37:51 +0200
From: Pavel Tsekov <ptsekov@gmx.net>
Message-ID: <1325876011.20080228003751@gmx.net>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Skystar 2 stops producing TS data after some time
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

I've searched the mailing list and found the following references
regarding a problem that occurs after several hours of reading TS
data off a SkyStar 2 DVB-S PCI card:

http://www.linuxtv.org/pipermail/linux-dvb/2005-June/002875.html
http://www.linuxtv.org/pipermail/linux-dvb/2006-October/013335.html
http://www.linuxtv.org/pipermail/linux-dvb/2005-February/000123.html

I am using several SkyStar 2 cards on Ubuntu LTS 6.06 (kernel
2.6.15-51-server) and still experience the problem described above.
Now, my question is - is this problem fixed in newer (2.6.16+) kernels ?
I've read every kernel changelog file for kernel > 2.6.15 and didn't find
any reference about a fix for this particular issue - perhaps I wasn't
looking at the right place ? If the problem is not fixed - is someone working
to fix it ? I have enabled the debug log for the flexcop driver and
have a log from its output as the problem occurs. I can post it if it
is interesting for someone.

Thanks!

P.S. Please, CC me since I am not subscribed to the list.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
