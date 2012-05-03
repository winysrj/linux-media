Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41472
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315Ab2ECJf1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 05:35:27 -0400
Received: from mail181-va3 (localhost [127.0.0.1])	by
 mail181-va3-R.bigfish.com (Postfix) with ESMTP id 1764C4E03E9	for
 <linux-media@vger.kernel.org>; Thu,  3 May 2012 09:35:17 +0000 (UTC)
Received: from VA3EHSMHS001.bigfish.com (unknown [10.7.14.251])	by
 mail181-va3.bigfish.com (Postfix) with ESMTP id B20A338006D	for
 <linux-media@vger.kernel.org>; Thu,  3 May 2012 09:35:15 +0000 (UTC)
From: Tiziano Olivieri <tiziano.olivieri@ita.sas.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: R: Problem with Creative Technology, Ltd Live! Cam Optia AF
Date: Thu, 3 May 2012 09:35:20 +0000
Message-ID: <417F202528196749A3DF1F1CF40693793CFB58@ITAMBX01.emea.SAS.com>
References: <417F202528196749A3DF1F1CF40693793CFB40@ITAMBX01.emea.SAS.com>
In-Reply-To: <417F202528196749A3DF1F1CF40693793CFB40@ITAMBX01.emea.SAS.com>
Content-Language: it-IT
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 
I've installed kubuntu 12.04 on my desktop (from kubuntu 10.04) and now the webcam doesn't work, below the are some command

lsusb
Bus 001 Device 002: ID 041e:4058 Creative Technology, Ltd Live! Cam Optia AF
Bus 002 Device 003: ID 07ca:850a AVerMedia Technologies, Inc. AverTV Volar Black HD (A850)
Bus 005 Device 002: ID 045e:0734 Microsoft Corp. Wireless Optical Desktop 700

~$ dmesg | grep usb
[    0.575334] usbcore: registered new interface driver usbfs
[    0.575334] usbcore: registered new interface driver hub
[    0.575334] usbcore: registered new device driver usb
[    2.164030] usb 1-4: new high speed USB device number 2 using ehci_hcd
[    2.728040] usb 2-3: new high speed USB device number 3 using ehci_hcd
[    3.128067] usb 5-1: new low speed USB device number 2 using ohci_hcd
[    3.318195] input: Liteon Microsoft® Wireless Receiver 700 v2.0 as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/input/input2
[    3.318255] generic-usb 0003:045E:0734.0001: input,hidraw0: USB HID v1.11 Keyboard [Liteon Microsoft® Wireless Receiver 700 v2.0] on usb-0000:00:13.0-1/input0
[    3.332228] input: Liteon Microsoft® Wireless Receiver 700 v2.0 as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.1/input/input3
[    3.332297] generic-usb 0003:045E:0734.0002: input,hidraw1: USB HID v1.11 Mouse [Liteon Microsoft® Wireless Receiver 700 v2.0] on usb-0000:00:13.0-1/input1
[    3.332309] usbcore: registered new interface driver usbhid
[    3.332310] usbhid: USB HID core driver
[  15.113133] usbcore: registered new interface driver snd-usb-audio
[  15.120717] input: UVC Camera (041e:4058) as /devices/pci0000:00/0000:00:12.2/usb1/1-4/1-4:1.0/input/input6
[  15.120816] usbcore: registered new interface driver uvcvideo
[  15.488022] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will try to load a firmware
[  15.530772] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[  15.598250] dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
[  15.598289] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[  15.606392] dvb-usb: AverMedia AVerTV Volar Black HD (A850) successfully initialized and connected.
[  15.612650] usbcore: registered new interface driver dvb_usb_af9015

$ dmesg | grep UVC
[  15.117016] uvcvideo: Found UVC 1.00 device (041e:4058)
[  15.120717] input: UVC Camera (041e:4058) as /devices/pci0000:00/0000:00:12.2/usb1/1-4/1-4:1.0/input/input6


$ lsmod | grep uvcvideo
uvcvideo              72711  0 
videodev              93004  1 uvcvideo

$ ls -l /dev/video*
crw-rw----+ 1 root video 81, 0 2011-11-02 19:28 /dev/video0

the webcam doesn't work with any software, in the google search I found the same problem on fedora on link https://bugzilla.redhat.com/show_bug.cgi?id=739448

If I downgrade the kernel to 2.6.38.12 the webcam work fine !! 
I think that the problem is on the UVC driver on the kernel after 2.6.38.12 to latest kernel 
Thanks

Tiziano
