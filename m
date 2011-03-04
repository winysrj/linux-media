Return-path: <mchehab@pedra>
Received: from mx3.wp.pl ([212.77.101.7]:20732 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDK5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 05:57:08 -0500
Received: from dnt237.neoplus.adsl.tpnet.pl (HELO [192.168.2.5]) (laurentp@[83.24.101.237])
          (envelope-sender <laurentp@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 4 Mar 2011 11:57:05 +0100
Message-ID: <4D70C581.1090600@wp.pl>
Date: Fri, 04 Mar 2011 11:57:05 +0100
From: "W.P." <laurentp@wp.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [partially solved] Re: Big ptoblem with small webcam
References: <4D6E68D1.6050209@wp.pl> <201103031114.39286.laurent.pinchart@ideasonboard.com> <4D6FB394.8020908@wp.pl>
In-Reply-To: <4D6FB394.8020908@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Użytkownik W.P. napisał:
> Użytkownik Laurent Pinchart napisał:
>   
>> Hi,
>>
>> On Wednesday 02 March 2011 16:57:05 W.P. wrote:
>>   
>>     
>>> Hi there,
>>> I just got an Creative VGA (640x480) USB Live Webcam, VF0520.
>>>
>>> lsusb (partial):
>>>
>>> Bus 003 Device 007: ID 041e:406c Creative Technology, Ltd
>>> Device Descriptor:
>>>   bLength                18
>>>   bDescriptorType         1
>>>   bcdUSB               2.00
>>>   bDeviceClass          239 Miscellaneous Device
>>>   bDeviceSubClass         2 ?
>>>   bDeviceProtocol         1 Interface Association
>>>   bMaxPacketSize0        64
>>>   idVendor           0x041e Creative Technology, Ltd
>>>   idProduct          0x406c
>>>   bcdDevice           10.19
>>>   iManufacturer           1 Creative Labs
>>>   iProduct                3 VF0520 Live! Cam Sync
>>>   iSerial                 0
>>>   bNumConfigurations      1
>>>
>>> lsmod | grep vid:
>>> uvcvideo               50184  0
>>> compat_ioctl32          5120  1 uvcvideo
>>> videodev               32000  1 uvcvideo
>>> v4l1_compat            15876  2 uvcvideo,videodev
>>>
>>> uname -a (kernel from Fedora 10):
>>> [root@laurent-home ~]# uname -a
>>> Linux laurent-home 2.6.27.5-117.fc10.i686 #1 SMP Tue Nov 18 12:19:59 EST
>>> 2008 i686 athlon i386 GNU/Linux
>>>
>>> Problem: device nodes are created, but NO video in gmplayer, tvtime
>>> complains: can't open /dev/video0.
>>>
>>> Only trace in syslog is:
>>>
>>> Mar  2 16:26:56 laurent-home kernel: uvcvideo: Failed to submit URB 0
>>> (-28).
>>>     
>>>       
>> This means the webcam requires more USB bandwidth than available. Another 
>> device probably uses USB bandwidth (it could be another webcam, an audio 
>> device, ...).
>>
>>   
>>     
> It is the only USB 2.0 device connected (rest are keyboard, mouse, 2x
> PL2303 converters, BT, and WiFi (unused). But what is strange: it seems
> device runs in 1.1 mode:
>
> Mar  3 15:54:46 laurent-home kernel: usb 3-1.4: new full speed USB
> device using
>  uhci_hcd and address 24
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: *not running at top
> speed*; conne
> ct to a high speed hub
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: configuration #1 chosen
> from 1
> choice
> Mar  3 15:54:47 laurent-home kernel: uvcvideo: Found UVC 1.00 device
> VF0520 Liv
> e! Cam Sync (041e:406c)
> Mar  3 15:54:47 laurent-home kernel: uvcvideo: Found a valid video chain
> (1 ->
> 2).
> Mar  3 15:54:47 laurent-home kernel: input: VF0520 Live! Cam Sync as
> /devices/p
> ci0000:00/0000:00:0b.1/usb3/3-1/3-1.4/3-1.4:1.0/input/input19
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: New USB device found,
> idVendor=
> 041e, idProduct=406c
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: New USB device strings:
> Mfr=1,
> Product=3, SerialNumber=0
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: Product: VF0520 Live!
> Cam Sync
> Mar  3 15:54:47 laurent-home kernel: usb 3-1.4: Manufacturer: Creative Labs
>
> But I have tested it with 2 hubs on different controller ports, same.
>   
>>> Webcam is connected to VIA USB 2.0 controller through a USB 2.0 hub.
>>>
>>> What is strange, two days ago I tried apparently the same (model VFxxxx)
>>> with SUCCESS.
>>> Device seems working in Windoze (Ekiga).
>>>
>>> What should I check/ do?
>>>     
>>>       
> Only switching OS (for test) and it works. WTF?
>
>   
Connecting to controller directly -> detected as high speed and works.
Again, question is WTF?

> W.P.
>   

