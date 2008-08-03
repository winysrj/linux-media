Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailgk@xs4all.nl>) id 1KPbuY-0000hv-2Q
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 13:38:09 +0200
From: Gerard <mailgk@xs4all.nl>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Sun, 03 Aug 2008 13:37:57 +0200
Message-Id: <1217763477.3847.14.camel@gk-sem3.gkall.nl>
Mime-Version: 1.0
Subject: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
Reply-To: mailgk@xs4all.nl
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

Just bought and searched for support for the Pinnacle pctv hybrid pro
stick 340e, not found.

I have placed the lsusb -v output on
http://www.gkall.nl/pinnacle-pctv-hybrid-pro-stick-340e.html

information is in pinnacle-pctv-hybrid-pro-stick-340e.txt


output from kernel.log

Aug  2 16:48:25 gk-sem3 kernel: [26398.325169] usb 2-3: new high speed
USB device using ehci_hcd and address 7
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: configuration #1
chosen from 1 choice
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
found, idVendor=2304, idProduct=023d
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Product: PCTV
340e
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: Manufacturer:
YUANRD
Aug  2 16:48:25 gk-sem3 kernel: [26398.482055] usb 2-3: SerialNumber:
060096D0F0

I can do some test, intention is to get it working on a acer aspire one
netbook.

According to an other lsusb -v output it could be a dibcom chip??

Question is if there is already some driver information?

-- 
--------
m.vr.gr.
Gerard Klaver


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
