Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp05.msg.oleane.net ([62.161.4.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1JlSBq-0007lK-3R
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 19:10:02 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp05.msg.oleane.net (MTA) with ESMTP id m3EH9kaX004575
	for <linux-dvb@linuxtv.org>; Mon, 14 Apr 2008 19:09:47 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 14 Apr 2008 19:09:31 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAANsZv/muTGEuiz4XGPuu+agEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Nova-T stick: device descriptor read/64, error -71
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

I had a Hauppauge Nova-T Stick that worked with kernel 2.6.24 (and previous)
with all recent hg trees and firmware dvb-usb-dib0700-1.10.fw.

I now have a new Nova-T Stick which does not work.

The first one was bought about one year ago, the second one a couple of months ago.
The first one was identified as 70001, the second one as 70009.

Front sticker: "WinTV NOVA-T digital terrestrial TV stick"
Rear sticker:  "M/R:70009/C1B5 #4807"

When pluging the device, dmesg reports errors:

    usb 6-1: device descriptor read/64, error -71
    usb 6-1: device descriptor read/64, error -71
    usb 6-1: new full speed USB device using uhci_hcd and address 43
    usb 6-1: device descriptor read/64, error -71
    usb 6-1: device descriptor read/64, error -71
    usb 6-1: new full speed USB device using uhci_hcd and address 44
    usb 6-1: device not accepting address 44, error -71
    usb 6-1: new full speed USB device using uhci_hcd and address 45
    usb 6-1: device not accepting address 45, error -71

How should I interpret this?

lsusb does not report anything. Specifically on device 6-1:

    Bus 006 Device 001: ID 0000:0000

Kernel version: 2.6.24.4-64.fc8 (Fedora 8 latest kernel)
V4L source tree: updated Apr 14 2008 (+ make & install & reboot)
Firmware file /lib/firmware/dvb-usb-dib0700-1.10.fw present
Note: a PCI Nova-T 500 in the same system is working OK.

On a Windows XP system, without Hauppauge drivers, the device is seen
as "unknown device" with identification "USB\VID_0000&PID_0000\5&54F4B9C&0&2".
I have no idea what it means but vendor id 0000 and product id 0000 seem suspect.

Shall I assume that the device is simply broken? Any other idea?
-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
