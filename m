Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:36377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab0LOUPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 15:15:13 -0500
Message-ID: <4D0921C9.1050509@redhat.com>
Date: Wed, 15 Dec 2010 21:15:05 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge USB Live 2
References: <4D073F83.8010301@redhat.com> <AANLkTimuS+O1rv1GL_ujj4D=gSXw+VLKh0vMc2mXx1Cd@mail.gmail.com> <4D0779A7.5090807@redhat.com> <4D079B30.3010605@redhat.com> <4D07A82B.6050205@redhat.com>
In-Reply-To: <4D07A82B.6050205@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020600030400060108080704"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------020600030400060108080704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/14/10 18:23, Gerd Hoffmann wrote:
>>> $ git log --oneline --no-merges 4270c3ca.. drivers/media/video/cx231xx
>>> f5db33f [media] cx231xx: stray unlock on error path
>>
>> Using that commit directly looks better. I still see the
>> UsbInterface::sendCommand failures, but the driver seems to finish the
>> initialization and looks for the firmware. So it seems something between
>> -rc2 and -rc5 in mainline made it regress ...
>
> Uhm, no. Looks like the difference is actually the .config

No, isn't.  Running vanilla 2.6.37-rc5 now, seeing both success and 
failure with the very same kernel.

The driver is compiled statically into the kernel now.  Booting with the 
device plugged works, it seems to initialize the device largely 
sucessfully, although some errors are sprinkled in.  The firmware one is 
probably just a matter of making sure the firmware is in the initramfs, 
didn't look at that yet.

Trying to fix the firmware issue by just unplugging and re-plugging the 
device once the system is fully  up'n'running (and thus /lib/firmware 
available) results in a failure which looks pretty much like the 
original report.

Any idea?  Initialization order issue?  Timing issue?

cheers,
   Gerd

PS: attached log was created using "dmesg | egrep '(cx|usb 1-2)'".

--------------020600030400060108080704
Content-Type: text/plain;
 name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log"

[    1.954715] cx231xx v4l2 driver loaded.
[    1.954741] usbcore: registered new interface driver cx231xx
[    2.171811] usb 1-2: new high speed USB device using ehci_hcd and address 2
[    2.291875] usb 1-2: New USB device found, idVendor=2040, idProduct=c200
[    2.293621] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.297065] usb 1-2: Product: Hauppauge Device
[    2.298805] usb 1-2: Manufacturer: Hauppauge
[    2.298807] usb 1-2: SerialNumber: 0013566174
[    2.305647] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
[    2.307548] cx231xx #0: registering interface 1
[    2.309498] cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
[    2.311374] cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
[    2.313248] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[    2.337247] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[    2.339250] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[    2.342754] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[    2.373011] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[    2.382006] cx231xx #0: Changing the i2c master port to 3
[    2.386252] cx25840 15-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[    2.412085] cx25840 15-0044:  Firmware download size changed to 16 bytes max length
[    2.415597] cx25840 15-0044: unable to open firmware v4l-cx231xx-avcore-01.fw
[    2.448841] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
[    2.468502] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[    2.516996] cx231xx #0: video_mux : 0
[    2.518927] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[    2.521745] cx231xx #0: do_mode_ctrl_overrides NTSC
[    2.530728] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[    2.532972] cx231xx #0: cx231xx #0/0: registered device vbi0
[    2.534857] cx231xx #0: V4L2 device registered as video0 and vbi0
[    2.537056] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
[    2.549992] cx231xx #0: Alternate setting 0, max size= 512
[    2.552147] cx231xx #0: Alternate setting 1, max size= 184
[    2.554244] cx231xx #0: Alternate setting 2, max size= 728
[    2.556181] cx231xx #0: Alternate setting 3, max size= 2892
[    2.558023] cx231xx #0: Alternate setting 4, max size= 1800
[    2.559827] cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
[    2.583025] cx231xx #0: Alternate setting 0, max size= 512
[    2.584811] cx231xx #0: Alternate setting 1, max size= 512
[    2.586602] cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
[    2.598406] cx231xx #0: Alternate setting 0, max size= 512
[    2.600058] cx231xx #0: Alternate setting 1, max size= 576
[   13.304543] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[   13.314640] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
[   29.289535] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[   29.299602] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
[  180.241409] usb 1-2: USB disconnect, address 2
[  184.261061] usb 1-2: new high speed USB device using ehci_hcd and address 6
[  184.377920] usb 1-2: New USB device found, idVendor=2040, idProduct=c200
[  184.377928] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  184.377934] usb 1-2: Product: Hauppauge Device
[  184.377939] usb 1-2: Manufacturer: Hauppauge
[  184.377944] usb 1-2: SerialNumber: 0013566174
[  184.381595] cx231xx #1: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
[  184.381603] cx231xx #1: registering interface 1
[  184.381784] cx231xx #1: can't change interface 3 alt no. to 3: Max. Pkt size = 0
[  184.381906] cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
[  184.382057] cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
[  184.400418] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.400788] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.401167] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.401539] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.401907] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.402293] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.402782] cx231xx #1: UsbInterface::sendCommand, failed with status --32
[  184.402788] cx231xx #1: cx231xx_dev_init: cx231xx_afe init super block - errCode [-32]!
[  184.402966] cx231xx #1: cx231xx_init_dev: cx231xx_i2c_register - errCode [-32]!
[  184.402981] cx231xx: probe of 1-2:1.1 failed with error -32

--------------020600030400060108080704--
