Return-path: <linux-media-owner@vger.kernel.org>
Received: from pop1-levy.go180.net ([216.229.186.150]:60476 "EHLO
	mail.my180.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1L3HTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 02:19:55 -0500
From: Reuben Stokes <okonomiyakisan@gohighspeed.com>
To: linux-media@vger.kernel.org
Subject: em28xx: new board id [eb1a:5051]
Date: Thu, 29 Dec 2011 15:13:16 -0800
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112291513.16680.okonomiyakisan@gohighspeed.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Not nearly as linux-savvy as most of the users here, but I attempted to operate a "Raygo USB Video Recorder" (audio/video capture device). Don't know if my efforts qualify as a "test".


Model Number: 
R12-41373

Display name: 
USB 2861 Device

lsusb: 
Bus 001 Device 002: ID eb1a:5051 eMPIA Technology, Inc. 

dmesg:
[ 7182.076058] usb 1-1: new high speed USB device using ehci_hcd and address 3
[ 7182.212702] usb 1-1: New USB device found, idVendor=eb1a, idProduct=5051
[ 7182.212714] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 7182.212723] usb 1-1: Product: USB 2861 Device
[ 7182.212729] usb 1-1: SerialNumber: 0

System:
HP Pavilion dv6910 laptop
AMD Turion X2 CPU (64 bit)
Mepis 11; 64 bit( based on Debian Squeeze)


Tried
-------
* Installed em28xx drivers using instructions found at linuxtv.org.
  I note however that this particular vendor/product ID is not validated in the em28xx devices list.
* As new drivers do not automatically load, I use command: modprobe em28xx
   After this "modprobe -l | grep em28xx" yields
        kernel/drivers/media/video/em28xx/em28xx-alsa.ko
        kernel/drivers/media/video/em28xx/em28xx.ko
        kernel/drivers/media/video/em28xx/em28xx-dvb.ko
* Device comes with a driver CD for Windows which does work in Windows.

End result is the device is not recognized as a capture device option in any software tried including vlc, cheese, guvcview, kdenlive.

Any help getting this to work in Linux would be appreciated as it completely sucks in my bloated, memory-hogging, 32-bit Windows Vista.

Reuben <okonomiyakisan@gohighspeed.com>
