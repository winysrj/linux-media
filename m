Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from krauklis.latnet.lv ([92.240.66.73])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <blondais@latnet.lv>) id 1NA3JJ-0008RH-PM
	for linux-dvb@linuxtv.org; Mon, 16 Nov 2009 16:16:10 +0100
Received: from localhost (localhost [127.0.0.1])
	by krauklis.latnet.lv (Postfix) with ESMTP id F137F140D1
	for <linux-dvb@linuxtv.org>; Mon, 16 Nov 2009 17:16:05 +0200 (EET)
Received: from krauklis.latnet.lv ([127.0.0.1])
	by localhost (krauklis.latnet.lv [127.0.0.1]) (amavisd-new, port 11141)
	with ESMTP id kyt0Io+TNcDc for <linux-dvb@linuxtv.org>;
	Mon, 16 Nov 2009 17:16:01 +0200 (EET)
Received: from localhost (clients.latnet.lv [92.240.64.12])
	by krauklis.latnet.lv (Postfix) with ESMTP id B7EBD140AD
	for <linux-dvb@linuxtv.org>; Mon, 16 Nov 2009 17:13:45 +0200 (EET)
Message-ID: <1258384425.4b016c29afaf2@online.sigmanet.lv>
Date: Mon, 16 Nov 2009 17:13:45 +0200
From: blondais@latnet.lv
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] kworld 380u, qt1010, em28xx
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi,

There's a lot of mails can be found on internet about my problem but hardly any
gives answer for subj.
Year ago, this was ok, there where ~mrec dvb-kernel available. Now it is gone,
and my problem raised again - cannot find the way to get my kworld 380u to work
properly, even by changing idProduct=e359 for somehow working kworld355u in file
linux/drivers/media/video/em28xx/em28xx-cards.c:
==
	{ USB_DEVICE(0xeb1a, 0xe359),
			.driver_info = EM2870_BOARD_KWORLD_355U },
==

Can anyone lead me where to look or change next?


Specs:
Box: Slackware 13.0, Linux 2.6.29.6-smp.
Item: Kworld 380U DVB-T USB stick
Dmesg before compiling dvb kernel from linuxtv.org:
Nov 16 16:54:04 dtv kernel: usb 1-1: new high speed USB device using ehci_hcd
and address 4
Nov 16 16:54:04 dtv kernel: usb 1-1: New USB device found, idVendor=eb1a,
idProduct=e359
Nov 16 16:54:04 dtv kernel: usb 1-1: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
Nov 16 16:54:04 dtv kernel: usb 1-1: Product: USB 2870 Device
Nov 16 16:54:04 dtv kernel: usb 1-1: configuration #1 chosen from 1 choice


Modules made from http://linuxtv.org/hg/v4l-dvb/ do not create devices in
/dev/dvb/ probably because of qt1010 firmware?


--
blondais



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
