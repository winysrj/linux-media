Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joe.mail.tiscali.it ([213.205.33.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1Jawem-0005kY-4k
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 18:28:28 +0100
Received: from localhost (78.12.42.113) by joe.mail.tiscali.it (7.3.132)
	id 47D64A6C00400119 for linux-dvb@linuxtv.org;
	Sun, 16 Mar 2008 18:27:48 +0100
Date: Sun, 16 Mar 2008 18:26:18 +0100
From: insomniac <insomniac@slackware.it>
To: linux-dvb@linuxtv.org
Message-ID: <20080316182618.2e984a46@slackware.it>
Mime-Version: 1.0
Subject: [linux-dvb] New unsupported device
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

Hi to everyone on the list,
this is my first post on the mailing list. I landed here after a lot of
searching for a working driver for my DVB-T USB stick. I bought a
Pinnacle PCTV Nano Stick (code: 73e) with HD capabilities, and I
discovered that it came on the market very recently (less than one month
ago).
As long as no google search, nor post search on linux-dvb mailing list
had success, it looks this is my last chance to get my card working on
GNU/Linux.

Here is the (actually useless) output I get from dmesg:
usb 1-1: new high speed USB device using ehci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice

and here is my lsusb -v output about the card:
http://insomniac.slackware.it/lsusb.pinnacle.txt

In the hope that there's a light at the end of the tunnel, I thank you
all for your patience and your work.

Best regards,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
