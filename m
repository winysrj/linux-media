Return-path: <linux-media-owner@vger.kernel.org>
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92]:40343 "HELO
	n7.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757781AbZDIPRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 11:17:30 -0400
Message-ID: <49DE0377.2060708@yahoo.gr>
Date: Thu, 09 Apr 2009 17:17:27 +0300
From: rvf16 <rvf16@yahoo.gr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Multiple em28xx devices
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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



