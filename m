Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:63741 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbbL0LT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 06:19:29 -0500
Received: from [192.168.1.40] ([88.69.149.15]) by smtp.web.de (mrweb103) with
 ESMTPSA (Nemesis) id 0MQNma-1ZjPgR1cr6-00Tlzi for
 <linux-media@vger.kernel.org>; Sun, 27 Dec 2015 12:19:27 +0100
To: linux-media@vger.kernel.org
From: Peter Schlaf <peter.schlaf@web.de>
Subject: Probably a new board ID for em28xx: [1b80:e349]
Message-ID: <567FC93D.7060602@web.de>
Date: Sun, 27 Dec 2015 12:19:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a small usb-device with s-vhs, composite-video and stereo-audio 
cabels attached.

The shell just says "MAGIX" and "Made in China". It has also a black 
button to push.

I plugged it in to get some video grabbed but no /dev/videoX was created.

"lsusb" output:

         Bus 003 Device 012: ID 1b80:e349 Afatech

journalctl -f output:

         kernel: usb 3-1.1: new high-speed USB device number 12 using 
ehci-pci
         kernel: usb 3-1.1: New USB device found, idVendor=1b80, 
idProduct=e349
         kernel: usb 3-1.1: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
         kernel: usb 3-1.1: Product: USB 2861 Device
         mtp-probe[7688]: checking bus 3, device 12: 
"/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1"
         mtp-probe[7688]: bus: 3, device: 12 was not an MTP device

Kernel is 4.1.13-5-default on openSuse 42.1

I opened that thing and found these chips:

       SAA7113H
       EM2860
       EMP202

I did
       modprobe em28xx
       modprobe saa7115

but still got no video-device.


(I use an application called "cheese" which works perfect with my other 
usb videograbbing device.)

Is there anything else I can do?


CU
Peter

