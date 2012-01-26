Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34705 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2AZL6l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 06:58:41 -0500
Message-ID: <4F213FEF.8030309@iki.fi>
Date: Thu, 26 Jan 2012 13:58:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Claus Olesen <ceolesen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: 290e locking issue
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>	<4F2117D6.20702@iki.fi> <CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
In-Reply-To: <CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2012 01:46 PM, Claus Olesen wrote:
> the dmesg output from inplug of 290e until usb mem stick mount timeout
> with a cut marked "--- cut similar ---" between mount and timeout for
> less output is

I think it is maybe some incapability of em28xx driver. Maybe it could 
be something to do with USB HCI too...


Could you test latest drivers using media_build.git ?


>
>> inplug 290e
> [  112.367345] usb 2-3: new high-speed USB device number 2 using ehci_hcd
> [  112.482773] usb 2-3: New USB device found, idVendor=2013, idProduct=024f
> [  112.482783] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  112.482790] usb 2-3: Product: PCTV 290e
> [  112.482796] usb 2-3: Manufacturer: PCTV Systems
> [  112.482801] usb 2-3: SerialNumber: 00000006VEJQ
> [  112.988850] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
> (2013:024f, interface 0, class 0)
> [  112.988929] em28xx #0: chip ID is em28174
> [  113.284694] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
> [  113.340323] Registered IR keymap rc-pinnacle-pctv-hd
> [  113.340594] input: em28xx IR (em28xx #0) as
> /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1/input19
> [  113.341677] rc1: em28xx IR (em28xx #0) as
> /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1
> [  113.342411] em28xx #0: v4l2 driver version 0.1.3
> [  113.348855] em28xx #0: V4L2 video device registered as video1
> [  113.350562] usbcore: registered new interface driver em28xx
> [  113.350568] em28xx driver loaded
> [  113.480057] tda18271 17-0060: creating new instance
> [  113.485221] TDA18271HD/C2 detected @ 17-0060
> [  113.724218] tda18271 17-0060: attaching existing instance
> [  113.724227] DVB: registering new adapter (em28xx #0)
> [  113.724235] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
> (DVB-T/T2))...
> [  113.724763] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
> [  113.728614] em28xx #0: Successfully loaded em28xx-dvb
> [  113.728617] Em28xx: Initialized (Em28xx dvb Extension) extension
>> inplug usb mem stick
> [  136.177341] usb 2-1: new high-speed USB device number 3 using ehci_hcd
> [  136.308531] usb 2-1: New USB device found, idVendor=0bda, idProduct=0120
> [  136.308541] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  136.308548] usb 2-1: Product: USB2.0-CRW
> [  136.308554] usb 2-1: Manufacturer: Generic
> [  136.308559] usb 2-1: SerialNumber: 20060413092100000
> [  136.630379] Initializing USB Mass Storage driver...
> [  136.630764] scsi6 : usb-storage 2-1:1.0
> [  136.631270] usbcore: registered new interface driver usb-storage
> [  136.631275] USB Mass Storage support registered.
> [  137.636863] scsi 6:0:0:0: Direct-Access     Generic- Card Reader
>    1.00 PQ: 0 ANSI: 0 CCS
> [  137.639519] sd 6:0:0:0: Attached scsi generic sg3 type 0
> [  138.446467] sd 6:0:0:0: [sdc] 15661056 512-byte logical blocks:
> (8.01 GB/7.46 GiB)
> [  138.447282] sd 6:0:0:0: [sdc] Write Protect is off
> [  138.447291] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
> [  138.448138] sd 6:0:0:0: [sdc] No Caching mode page present
> [  138.448147] sd 6:0:0:0: [sdc] Assuming drive cache: write through
> [  138.451639] sd 6:0:0:0: [sdc] No Caching mode page present
> [  138.451647] sd 6:0:0:0: [sdc] Assuming drive cache: write through
> [  138.452729]  sdc: sdc1
>> mount usb mem stick sdc1
> [  168.838133] usb 2-1: reset high-speed USB device number 3 using ehci_hcd

[... removed lot of similar USB errors ...]

> driverbyte=DRIVER_SENSE
> [  478.342504] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
> [  478.342510] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
> [  478.342517] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 01 00
> [  478.342528] end_request: I/O error, dev sdc, sector 8192
> [  478.342545] FAT-fs (sdc1): unable to read boot sector
>
>
>
> On Thu, Jan 26, 2012 at 10:07 AM, Antti Palosaari<crope@iki.fi>  wrote:
>> On 01/26/2012 12:16 AM, Claus Olesen wrote:
>>>
>>> just got 3.2.1-3.fc16.i686.PAE
>>> the issue that the driver had to be removed for the 290e to work after
>>> a replug is gone.
>>> the issue that a usb mem stick cannot be mounted while the 290e is
>>> plugged in still lingers.
>>> one workaround is to unplug the 290e and wait a little (no need to
>>> also remove the driver).
>>
>>
>> What it prints to the system log? Use tail -f /var/log/messages or dmesg.
>>
>>
>> Antti
>> --
>> http://palosaari.fi/


-- 
http://palosaari.fi/
