Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.iamnota.org ([202.173.148.127] helo=fw.iamnota.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <astfgl@iamnota.org>) id 1JflF6-0007i7-4J
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 01:17:49 +0100
Received: from m1210.iamnota.org ([10.0.1.10])
	by fw.iamnota.org with esmtp (Exim 4.63)
	(envelope-from <astfgl@iamnota.org>) id 1JflEU-0006yF-N0
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 10:17:10 +1000
Message-ID: <47EEDC08.6060402@iamnota.org>
Date: Sun, 30 Mar 2008 10:17:12 +1000
From: Glen Harris <astfgl@iamnota.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] New AverTV A800 hardware revision fails
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

I've been recommending the A800 to friends here, as it "just works". 
Well, that confidence has come back to bite me, as two friends just 
bought units and they don't work with the existing firmware and driver.

Differences are:
Board		A800-D		A800-F
DiBcom chip	DiB3000P-C112a	DiB3000P-2122a-G
Cypress chip	CY7C68013-56PVC	CY7C68013A-56PVXC
Panasonic yuner	ENV57H12D5	ENV57H12D5F

I've tested with several kernels from 2.6.18 to 2.6.24 on known working 
systems, ie I've unplugged my units and plugged theirs in, and the 
syslog shows the firmware being sent, but that's it.

Here's the syslog lines:
Mar 30 09:35:11 m1210 kernel: usb 5-1: new high speed USB device using 
ehci_hcd and address 48
Mar 30 09:35:11 m1210 kernel: usb 5-1: configuration #1 chosen from 1 choice
Mar 30 09:35:11 m1210 kernel: dvb-usb: found a 'AVerMedia AverTV DVB-T 
USB 2.0 (A800)' in cold state, will try to load a firmware
Mar 30 09:35:11 m1210 kernel: dvb-usb: downloading firmware from file 
'dvb-usb-avertv-a800-02.fw'
Mar 30 09:35:11 m1210 kernel: usbcore: registered new driver dvb_usb_a800

The driver never gets to the disconnect-reconnect stage, and the blue 
light never comes on. I've plugged in my device immediately after trying 
the new one, and it loads perfectly, so the kernel driver hasn't hung or 
anything. I suspect that there's a new firmware revision to go with the 
new board revision.

I've tried USBsnoop on a W2K host and get about 130K of data, but it's 
mostly an English description of the protocol, the actual hex data 
captured is less than 1kb. This is the problem we had last time getting 
the firmware. I've also tried via a VMWare W2K host, but the driver 
won't install correctly. I have the windows driver isolated, but I can't 
find any chunk that bears a resemblance to the existing v02 firmware 
file we're using.

The syslog above was generated after loading dvb-usb with debug=127, but 
it's no different than without the debug. Is there a trick to getting 
debug logs?

I'm not sure what to try next, can anyone suggest where I go from here?

Thanks, glen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
