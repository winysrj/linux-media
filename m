Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:20170 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3EIPFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:05:24 -0400
Message-ID: <518BBB33.9050402@libertysurf.fr>
Date: Thu, 09 May 2013 17:05:23 +0200
From: pierre <pdurand13@libertysurf.fr>
Reply-To: pdurand13@libertysurf.fr
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: webcam 0ac8:0332 dont work on wheezy
References: <20130509150132.A5CAE8A1216@zimbra65-e11.priv.proxad.net>
In-Reply-To: <20130509150132.A5CAE8A1216@zimbra65-e11.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Problem on my webcam usb Bus 001 Device 006: ID 0ac8:0332 Z-Star 
Microelectronics Corp. on wheezy.
computer:
product: Inspiron 620
vendor: Dell Inc.
version: 00
serial: D9V135J
width: 64 bits

On Squeeze, it was fine.
On thirst boot after installing Wheezy the webcam is right:

May  6 12:57:21 retraite kernel: [    6.740090] uvcvideo: Found UVC 1.00 
device USB 2.0 Camera (0ac8:0332)
May  6 12:57:21 retraite kernel: [    6.741938] input: USB 2.0 Camera as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input7
May  6 12:57:21 retraite kernel: [    6.741992] usbcore: registered new 
interface driver uvcvideo
May  6 12:57:21 retraite kernel: [    6.741994] USB Video Class driver 
(1.1.1)
May  6 12:57:21 retraite kernel: [    6.853610] usbcore: registered new 
interface driver snd-usb-audio

after the webcam don't work it seems like uvcvideo module is no more 
present.

May  9 14:46:53 retraite kernel: [    3.211564] usb 1-1.1.2: new 
high-speed USB device number 6 using ehci_hcd
May  9 14:46:53 retraite kernel: [    3.397406] usb 1-1.1.2: New USB 
device found, idVendor=0ac8, idProduct=0332
May  9 14:46:53 retraite kernel: [    3.397411] usb 1-1.1.2: New USB 
device strings: Mfr=1, Product=2, SerialNumber=0
May  9 14:46:53 retraite kernel: [    3.397414] usb 1-1.1.2: Product: 
USB 2.0 Camera
May  9 14:46:53 retraite kernel: [    3.397417] usb 1-1.1.2: 
Manufacturer: Vimicro Corp.
May  9 14:46:53 retraite kernel: [    3.402393] usb 2-1.2: USB 
disconnect, device number 3

Hoping theese informations can help you ... and me.

Thanks.

Pierre.


