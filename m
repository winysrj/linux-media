Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4265 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaE1I5f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 04:57:35 -0400
Message-ID: <5385A4D3.5090409@xs4all.nl>
Date: Wed, 28 May 2014 10:56:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Richie Gress <searchfgold67899@live.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 1d6b:0001 [MSI A55M-P33] No webcam functionality with Zoran Microelectronics,
 Ltd Digital Camera EX-20 DSC
References: <BLU436-SMTP93884884267098D387F74FF23A0@phx.gbl>,<538438C5.1090600@xs4all.nl> <BAY177-W35986CA25EA77648947BDDF23A0@phx.gbl>
In-Reply-To: <BAY177-W35986CA25EA77648947BDDF23A0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/14 19:55, Richie Gress wrote:
> 
> 
>> Date: Tue, 27 May 2014 09:03:33 +0200
>> From: hverkuil@xs4all.nl
>> To: searchfgold67899@live.com; linux-usb@vger.kernel.org; linux-media@vger.kernel.org
>> Subject: Re: 1d6b:0001 [MSI A55M-P33] No webcam functionality with Zoran Microelectronics, Ltd Digital Camera EX-20 DSC
>>
>> On 05/27/2014 03:34 AM, Richie wrote:
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1322380
>>>
>>> [1.] One line summary of the problem:
>>>
>>> 1d6b:0001 [MSI A55M-P33] No webcam functionality with Zoran Microelectronics, 
>>> Ltd Digital Camera EX-20 DSC
>>>
>>> [2.] Full description of the problem/report: 
>>>
>>> No software recognizes the webcam and this is not a regression. dmesg reports 
>>> the following additional output after plugging the camera. You can see where I 
>>> change the camera to "PC Mode" (in order to use the webcam, users must do this 
>>> from the camera) at [ 691.147589]. The device is turned off at [ 1094.746444]:
>>>
>>> [ 688.796908] usb 4-2: new full-speed USB device number 2 using ohci-pci
>>> [ 688.965802] usb 4-2: New USB device found, idVendor=0595, idProduct=2002
>>> [ 688.965807] usb 4-2: New USB device strings: Mfr=4, Product=5, 
>>> SerialNumber=6
>>> [ 688.965809] usb 4-2: Product: COACH DSC
>>> [ 688.965811] usb 4-2: Manufacturer: ZORAN
>>> [ 688.965813] usb 4-2: SerialNumber: ZORAN01234567
>>> [ 689.012630] usb-storage 4-2:1.0: USB Mass Storage device detected
>>> [ 689.021168] scsi6 : usb-storage 4-2:1.0
>>> [ 689.021266] usbcore: registered new interface driver usb-storage
>>> [ 690.030971] scsi 6:0:0:0: Direct-Access ZORAN COACH6 (I62) 1.10 PQ: 0 ANSI: 
>>> 0 CCS
>>> [ 690.036147] sd 6:0:0:0: Attached scsi generic sg3 type 0
>>> [ 690.044964] sd 6:0:0:0: [sdc] 3962629 512-byte logical blocks: (2.02 GB/1.88 
>>> GiB)
>>> [ 690.054977] sd 6:0:0:0: [sdc] Write Protect is off
>>> [ 690.054984] sd 6:0:0:0: [sdc] Mode Sense: 00 06 00 00
>>> [ 690.064965] sd 6:0:0:0: [sdc] No Caching mode page found
>>> [ 690.064971] sd 6:0:0:0: [sdc] Assuming drive cache: write through
>>> [ 690.108960] sd 6:0:0:0: [sdc] No Caching mode page found
>>> [ 690.108966] sd 6:0:0:0: [sdc] Assuming drive cache: write through
>>> [ 690.156970] sdc:
>>> [ 690.210974] sd 6:0:0:0: [sdc] No Caching mode page found
>>> [ 690.210980] sd 6:0:0:0: [sdc] Assuming drive cache: write through
>>> [ 690.210985] sd 6:0:0:0: [sdc] Attached SCSI removable disk
>>> [ 691.147589] usb 4-2: USB disconnect, device number 2
>>> [ 691.793364] usb 4-2: new full-speed USB device number 3 using ohci-pci
>>> [ 691.962202] usb 4-2: New USB device found, idVendor=0595, idProduct=4343
>>> [ 691.962207] usb 4-2: New USB device strings: Mfr=7, Product=8, 
>>> SerialNumber=9
>>> [ 691.962209] usb 4-2: Product: COACH DSC
>>> [ 691.962211] usb 4-2: Manufacturer: ZORAN
>>> [ 691.962213] usb 4-2: SerialNumber: ZORAN00000001
>>> [ 691.964262] usb-storage 4-2:1.0: USB Mass Storage device detected
>>> [ 691.965410] usb-storage: probe of 4-2:1.0 failed with error -5
>>> [ 692.053929] Linux video capture interface: v2.00
>>> [ 692.091447] zr364xx 4-2:1.0: Zoran 364xx compatible webcam plugged
>>> [ 692.091453] zr364xx 4-2:1.0: model 0595:4343 detected
>>> [ 692.091461] usb 4-2: 320x240 mode selected
>>> [ 692.094356] usb 4-2: Zoran 364xx controlling device video0
>>
>> Clearly the webcam is recognized and a /dev/video0 node is created.
>> Please check that /dev/video0 exists. Try e.g. v4l2-ctl -D -d /dev/video0,
>> it should list it as using the zr364xx driver.
>>
>> So what exactly doesn't work?
>>
>> Regards,
>>
>> 	Hans
>>
>>> [ 692.094672] usbcore: registered new interface driver zr364xx
>>> [ 1094.746444] hub 4-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
>>> [ 1094.746451] usb 4-2: USB disconnect, device number 3
>>> [ 1094.747395] zr364xx 4-2:1.0: Zoran 364xx webcam unplugged
>>
> 
> Yes, it does seem to be using the zr364xx driver:
> 
> $ v4l2-ctl -D -d /dev/video0
> Driver Info (not using libv4l2):
>         Driver name   : Zoran 364xx
>         Card type     : COACH DSC
>         Bus info      : 4-1
>         Driver version: 3.15.0
>         Capabilities  : 0x85000001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Device Capabilities
>         Device Caps   : 0x05000001
>                 Video Capture
>                 Read/Write
>                 Streaming
> 
> The exact problem is that while the camera is recognized as a camera by software like Skype, Kamoso, and Cheese, there is no picture, just black. A "320x240 mode" was mentioned... perhaps that resolution is just too small to use by the software?

Try using qv4l2. If that doesn't work, then it is likely to be a driver issue.
I have one zr364xx based camera and I can try it tomorrow or during the weekend.
It used to work, but it's been a long time since I tried it. On the other hand,
nobody did any work on that driver for a long time.

Regards,

	Hans
