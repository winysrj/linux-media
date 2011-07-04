Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1GDWIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2011 18:08:36 -0400
Message-ID: <4E1239D9.8000606@redhat.com>
Date: Mon, 04 Jul 2011 19:08:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca: video0 becomes video1 after "ISOC data error"
References: <4E12297D.4040302@freemail.hu>
In-Reply-To: <4E12297D.4040302@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-07-2011 17:58, Németh Márton escreveu:
> Hi,
> 
> I'm running Debian with Linux 2.6.38-2-486 on a computer. I have a hama AC-150 webcam
> attached to this computer. The webcam works continouosly and I use mencoder to do some
> cropping and transformation and to encode the video stream to a file.
> 
> When I plug the device the following appears in the dmesg:
> 
> [439884.692090] usb 3-1: new full speed USB device using uhci_hcd and address 6
> [439884.841721] usb 3-1: New USB device found, idVendor=0c45, idProduct=6142
> [439884.841958] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [439884.842153] usb 3-1: Product: USB camera
> [439884.851327] gspca: probing 0c45:6142
> [439884.856694] sonixj: Sonix chip id: 12
> [439884.942767] sonixj: Sensor po2030n
> [439884.947226] input: sonixj as /devices/pci0000:00/0000:00:0b.0/usb3/3-1/input/input4
> [439884.968553] gspca: video0 created
> 
> The camera works and sometimes the following messages appear in dmesg:
> 
> [2992914.118137] gspca: ISOC data error: [3] len=0, status=-84
> [3020511.187726] gspca: ISOC data error: [16] len=0, status=-84
> [3071235.051448] gspca: ISOC data error: [22] len=0, status=-84
> [3178268.392602] gspca: ISOC data error: [11] len=0, status=-84
> [3195506.149353] gspca: ISOC data error: [14] len=0, status=-84
> [3200576.757068] gspca: ISOC data error: [13] len=0, status=-84
> [3242983.446235] gspca: ISOC data error: [20] len=0, status=-84
> [3242983.446406] gspca: ISOC data error: [21] len=0, status=-84
> [3242983.446526] gspca: ISOC data error: [22] len=0, status=-84
> [3242983.446638] gspca: ISOC data error: [23] len=0, status=-84
> [3242983.468410] gspca: ISOC data error: [0] len=0, status=-84
> [3242983.468578] gspca: ISOC data error: [1] len=0, status=-84
> [3242983.468709] gspca: ISOC data error: [2] len=0, status=-84
> [3242983.468827] gspca: ISOC data error: [3] len=0, status=-84
> ...
> [3242983.579375] gspca: ISOC data error: [22] len=0, status=-84
> [3242983.579375] gspca: ISOC data error: [23] len=0, status=-84
> [3242983.588379] gspca: URB error -84, resubmitting
> [3242983.591697] usb 3-1: USB disconnect, address 6
> [3242983.592489] gspca: ISOC data error: [0] len=0, status=-84
> [3242983.592630] gspca: ISOC data error: [1] len=0, status=-84
> [3242983.592744] gspca: ISOC data error: [2] len=0, status=-84
> [3242983.592856] gspca: ISOC data error: [3] len=0, status=-84
> ...
> [3242983.594935] gspca: ISOC data error: [22] len=0, status=-84
> [3242983.595044] gspca: ISOC data error: [23] len=0, status=-84
> [3242983.595149] gspca: usb_submit_urb() ret -19
> [3242983.602605] gspca: video0 disconnect
> [3242983.899568] usb 3-1: new full speed USB device using uhci_hcd and address 7
> [3242984.077146] usb 3-1: New USB device found, idVendor=0c45, idProduct=6142
> [3242984.077375] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [3242984.077563] usb 3-1: Product: USB camera
> [3242984.096020] gspca: probing 0c45:6142
> [3242984.117655] sonixj: Sonix chip id: 12
> [3242984.221778] sonixj: Sensor po2030n
> [3242984.249883] input: sonixj as /devices/pci0000:00/0000:00:0b.0/usb3/3-1/input/input5
> [3242984.258533] gspca: video1 created
> 
> At this point the user space application (mencoder) still have the /dev/video0 device open
> but the video0 device is no longer there. Instead the video1 is created.
> 
> I already saw similar behaviour in case of suspend-resume cycle, see
> Bug 13419 - gspca: /dev/video0 changes to /dev/video1 after suspend
> https://bugzilla.kernel.org/show_bug.cgi?id=13419

In suspend/resume, it seems a driver bug to me.

> 
> The error code -84 refers to EILSEQ (Illegal byte sequence) according to include/asm-generic/errno.h .
> What could be the reason for "ISO data error"?
> 
> I guess the video0 is disconnected as part of error recovery. In this case, however
> the video1 device is created so the user space application looses the original
> video streaming device. Is this how it shall work?

It seems a bug that mencoder didn't stopped streaming with EILSEQ. Maybe this erros is
not properly propagated?

In any case, if the userspace application keeps a device opened, the Kernel needs to get
the next available major/minor, as, otherwise, an OOPS or panic will happen, as the kernel
can't free the major/minor while it is in usage.

The alternative for that would be to create an alias, via udev, for example, calling it
as /dev/webcam0, and keeping the value permanent, for the same device. This way, the name
of the device won't change (but the minor will keep changing). This won't solve the
issue, except if the application would close and re-open the devnode, when such error occurs.

Cheers,
Mauro
