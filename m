Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:56647 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935537Ab0BZIJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 03:09:39 -0500
Message-ID: <4B8781BE.1090601@linuxstation.net>
Date: Fri, 26 Feb 2010 00:09:34 -0800
From: Dean <red1@linuxstation.net>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: OnAir USB HDTV Creator
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to use an 'OnAir USB HDTV Creator' (from autumnwave.com).  According to
http://www.linuxtv.org/wiki/index.php/OnAir_USB_HDTV_Creator
This device is supported, however it's not working for me.  Following the instructions at above link, I tried this:
modprobe pvrusb2 initusbreset=0

The result:
FATAL: Error inserting pvrusb2 (/lib/modules/2.6.31.12-desktop586-1mnb/kernel/drivers/media/video/pvrusb2/pvrusb2.ko.gz): Unknown symbol in module, or unknown parameter (see dmesg)

When connecting the unit, dmesg shows only these six lines.

usb 1-3: new high speed USB device using ehci_hcd and address 10
usb 1-3: New USB device found, idVendor=11ba, idProduct=1101
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-3: Product: USB HDTV-GT(1.1)
usb 1-3: Manufacturer: OnAirSolution
usb 1-3: configuration #1 chosen from 1 choice

Anyone know what to do?
