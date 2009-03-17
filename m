Return-path: <linux-media-owner@vger.kernel.org>
Received: from rolfschumacher.eu ([195.8.233.65]:33810 "EHLO august.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbZCQUjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 16:39:04 -0400
Received: from [192.168.1.109] (HSI-KBW-078-042-086-232.hsi3.kabel-badenwuerttemberg.de [78.42.86.232])
	(Authenticated sender: rolf)
	by august.de (Postfix) with ESMTPA id 266CC43BDC
	for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 21:38:59 +0100 (CET)
Message-ID: <49C00A62.1080803@august.de>
Date: Tue, 17 Mar 2009 21:38:58 +0100
From: Rolf Schumacher <mailinglist@august.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: no video device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, dvb professionals,

I followed the advices on
http://www.linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers#Optional_Pre-Compilation_Steps

Build and Installation Instructions

downloaded the v4l sources via mercurial,
"make" and "sudo make install" finished without error messages.

rebooted the computer

dmesg shows the device:

---
usb 2-1: new high speed USB device using ehci_hcd and address 6
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=0b48, idProduct=300d
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: TT-USB2.0
usb 2-1: Manufacturer: TechnoTrend
usb 2-1: SerialNumber: LHKAMG
---

no error if I unplug and plug it on USB again

the connected box is a TechnoTrend CT 3560 CI
I googled and found chipset names like TDA8274 + TDA10023
did not find anything in wiki, so I could not determine module or driver
names to be identified with lsmod.

there is no created /dev/dvb or /dev/video device

google did not help me answering the question "do I need firmware, and
if so where to get it"

uname -a shows
Linux rolf9 2.6.28-7.slh.6-sidux-686 #1 SMP PREEMPT Sat Mar 14 02:30:40
UTC 2009 i686 GNU/Linux

for now I got stuck.

Do you know of a next step towards having tv on my laptop?

Rolf






