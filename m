Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web62108.mail.re1.yahoo.com ([69.147.74.246])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <kiwigb@yahoo.com>) id 1LDWKP-00013f-0S
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 04:47:06 +0100
Date: Thu, 18 Dec 2008 19:46:26 -0800 (PST)
From: Greg Balle <kiwigb@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <995535.96989.qm@web62108.mail.re1.yahoo.com>
Subject: [linux-dvb] Toshiba DVB (USB stick) p/n PX1256E-1TVH
Reply-To: kiwigb@yahoo.com
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

Hi all,

anybody know anything about linux driver support for this beastly thing?

kernel messages on plug-in:

Dec 19 16:32:26 yodasan kernel: [ 3667.720645] usb 1-3: new high speed USB device using ehci_hcd and address 9
Dec 19 16:32:26 yodasan kernel: [ 3667.853676] usb 1-3: configuration #1 chosen from 1 choice

lsusb relevant line:

Bus 001 Device 009: ID 04ca:f004 Lite-On Technology Corp.

It seems like there is support for previous versions (cold # vendor: 04ca:f000 and hot # vendor: 04ca:f001?) but not this chip, is that correct or is there some other history that is known about?

Cheers for any help,

Greg B.

PS: I have spent hours on it and is biggest waste of money I have ever spent on Toshiba hardware, ever, and doesn't even work properly under Windows with supplied software (not that I wanted it to).



      Get the world&#39;s best email - http://nz.mail.yahoo.com/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
