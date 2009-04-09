Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rvf16@yahoo.gr>) id 1LrutQ-0001l6-AH
	for linux-dvb@linuxtv.org; Thu, 09 Apr 2009 16:06:13 +0200
Message-ID: <49DE00B0.4060509@yahoo.gr>
Date: Thu, 09 Apr 2009 17:05:36 +0300
From: rvf16 <rvf16@yahoo.gr>
MIME-Version: 1.0
To: Linux-DVB Mailing List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Multiple em28xx devices
Reply-To: linux-media@vger.kernel.org
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

Hello.

I am trying to use two Terratec Cinergy Hybrid T USB XS FM tuners, at 
the same time, on the same system.
Both work great when used solely.
When used simultaneously the second one gives the following error :

v4l2: unable to open '/dev/video1': No space left on device

I am using the em28xx-new-b2e841c05e94 driver from 
http://mcentral.de/hg/~mrec/em28xx-new on a Fedora 6 system.
I have opened this topic in the em28xx mailing list 
http://mcentral.de/pipermail/em28xx/ but it seems it is not maintained 
any more.

According to comments on relevant problems (the following is for spca5xx 
driver for cameras with same problem) :
-----------------------
When other USB devices are present on the same host controller bus as 
the camera, the bandwidth requirements of the spca5xx driver are not 
being met, with some hardware configurations.
The spca5xx driver is asking for more bandwidth than is available which 
results in these error messages.
-----------------------

We are, under these circumstances, advised to either insert the device 
in another USB socket or even install a PCI card with extra USB sockets 
so that the device ends up in different bus.
I tried to insert the second device in another usb socket but it always 
ends up at the same bus with the first one :

#lsusb
Bus 005 Device 014: ID 0ccd:0072 TerraTec Electronic GmbH
Bus 005 Device 015: ID 0ccd:0072 TerraTec Electronic GmbH
Bus 005 Device 001: ID 0000:0000 Bus 002 Device 006: ID 046d:c50e 
Logitech, Inc. MX-1000 Cordless Mouse Receiver
Bus 002 Device 001: ID 0000:0000 Bus 004 Device 001: ID 0000:0000 Bus 
003 Device 001: ID 0000:0000 Bus 001 Device 001: ID 0000:0000
which happens to a lot of people from what i have seen.

As this is a laptop with 4 USB sockets :

# lspci | grep USB
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01)

i cannot install a PCI card with extra USB sockets so there goes 
workaround number two.

In spca5xx case a developer patched the driver so that the bandwidth was 
throttled in such a way that two devices used simultaneously would never 
exceed maximum.

Can that be done with em28xx?
If not, is there any other workaround to this problem?

Thank you.
Regards.



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
