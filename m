Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37293 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 13:43:29 -0500
Received: by ewy20 with SMTP id 20so1190955ewy.21
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 10:43:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 19:43:27 +0100
Message-ID: <51be034e1003031043g16f21a39hce12f030b2b5eed0@mail.gmail.com>
Subject: problem with logitech quickcam zoom
From: Jozef Riha <jose1711@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello,

the problem i have with my logitech quickcam zoom webcam is that it is
working randomly. sometimes it works after reboot and stops working
after some time, sometimes replugging works, sometimes not. if the
camera is not working i get v4l2: oops: select timeout in xawtv
output.

camera works reliably on my old dell d600 laptop. the above issue is
rendered on a pc with Gigabyte EP45-UD3LR motherboard, usb chipset is
ICH10. Both uhci and ehci modules are loaded.

$ lspci
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express
Root Port (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 1
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 5
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port
SATA IDE Controller #1
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller #2
01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce
9500 GT] (rev a1)
03:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

the behaviour is observed with kernel 2.6.32.9 and libv4l 0.6.4.

does anyone have an idea how to fix this?

thank you,

joe
