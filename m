Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54241 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2AZRKB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 12:10:01 -0500
Received: by lagu2 with SMTP id u2so450211lag.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 09:09:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F213FEF.8030309@iki.fi>
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
	<4F2117D6.20702@iki.fi>
	<CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
	<4F213FEF.8030309@iki.fi>
Date: Thu, 26 Jan 2012 18:09:59 +0100
Message-ID: <CAGa-wNO5GihQcxBF88yXC7B=PO3upw-pN5YGzJ5Rm_+Sji9iBg@mail.gmail.com>
Subject: Re: 290e locking issue
From: Claus Olesen <ceolesen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the behavior with the latest media_build.git is the same as that which
was with fedora stock.
the dmesg is

>inplug 290e
[  112.284350] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[  112.399774] usb 2-3: New USB device found, idVendor=2013, idProduct=024f
[  112.399783] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  112.399790] usb 2-3: Product: PCTV 290e
[  112.399796] usb 2-3: Manufacturer: PCTV Systems
[  112.399802] usb 2-3: SerialNumber: 00000006VEJQ
[  112.920507] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[  112.920515] em28xx: DVB interface 0 found
[  112.920647] em28xx #0: chip ID is em28174
[  113.216668] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[  113.258309] Registered IR keymap rc-pinnacle-pctv-hd
[  113.258579] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1/input19
[  113.259685] rc1: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1
[  113.260303] em28xx #0: v4l2 driver version 0.1.3
[  113.265485] em28xx #0: V4L2 video device registered as video1
[  113.266619] usbcore: registered new interface driver em28xx
[  113.301706] WARNING: You are using an experimental version of the
media stack.
[  113.301709] 	As the driver is backported to an older kernel, it doesn't offer
[  113.301710] 	enough quality for its usage in production.
[  113.301711] 	Use it with care.
[  113.301712] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  113.301713] 	59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[  113.301714] 	72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[  113.301715] 	46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[  113.382193] tda18271 17-0060: creating new instance
[  113.386895] TDA18271HD/C2 detected @ 17-0060
[  113.629529] DVB: registering new adapter (em28xx #0)
[  113.629541] DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...
[  113.632902] em28xx #0: Successfully loaded em28xx-dvb
[  113.632910] Em28xx: Initialized (Em28xx dvb Extension) extension
>inplug usb mem stick
[  152.204343] usb 2-1: new high-speed USB device number 3 using ehci_hcd
[  152.336629] usb 2-1: New USB device found, idVendor=0bda, idProduct=0120
[  152.336639] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  152.336646] usb 2-1: Product: USB2.0-CRW
[  152.336652] usb 2-1: Manufacturer: Generic
[  152.336657] usb 2-1: SerialNumber: 20060413092100000
[  152.655077] Initializing USB Mass Storage driver...
[  152.655230] scsi6 : usb-storage 2-1:1.0
[  152.655334] usbcore: registered new interface driver usb-storage
[  152.655336] USB Mass Storage support registered.
[  153.659503] scsi 6:0:0:0: Direct-Access     Generic- Card Reader
  1.00 PQ: 0 ANSI: 0 CCS
[  153.661960] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  154.551529] sd 6:0:0:0: [sdc] 15661056 512-byte logical blocks:
(8.01 GB/7.46 GiB)
[  154.552415] sd 6:0:0:0: [sdc] Write Protect is off
[  154.552424] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  154.553309] sd 6:0:0:0: [sdc] No Caching mode page present
[  154.553318] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  154.556786] sd 6:0:0:0: [sdc] No Caching mode page present
[  154.556793] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  154.557864]  sdc: sdc1
>mount usb mem stick sdc1
[  184.838198] usb 2-1: reset high-speed USB device number 3 using ehci_hcd
[  184.959925] sd 6:0:0:0: [sdc] No Caching mode page present
[  184.959936] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  184.959944] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[  215.878053] usb 2-1: reset high-speed USB device number 3 using ehci_hcd
[  215.998116] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  215.998123] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  215.998128] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  215.998135] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  215.998147] end_request: I/O error, dev sdc, sector 15660928
[  215.998152] Buffer I/O error on device sdc, logical block 1957616
[  215.999614] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  215.999619] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  215.999623] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  215.999629] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  215.999639] end_request: I/O error, dev sdc, sector 15660928
[  215.999642] Buffer I/O error on device sdc, logical block 1957616
[  216.000987] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  216.000992] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  216.000996] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  216.001045] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  216.001055] end_request: I/O error, dev sdc, sector 15661040
[  216.001058] Buffer I/O error on device sdc, logical block 1957630
[  216.002119] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  216.002124] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  216.002129] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  216.002135] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  216.002145] end_request: I/O error, dev sdc, sector 15660928
[  216.002149] Buffer I/O error on device sdc1, logical block 1956592
[  216.003238] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  216.003243] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  216.003247] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  216.003253] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  216.003263] end_request: I/O error, dev sdc, sector 15661040
[  216.003266] Buffer I/O error on device sdc, logical block 1957630
[  216.004365] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  216.004370] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  216.004374] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  216.004380] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  216.004390] end_request: I/O error, dev sdc, sector 15660928
[  216.004394] Buffer I/O error on device sdc1, logical block 1956592
[  216.005490] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  216.005495] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  216.005499] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  216.005505] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  216.005515] end_request: I/O error, dev sdc, sector 0
[  216.005518] Buffer I/O error on device sdc, logical block 0
[  219.880502] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  219.880507] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  219.880511] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  219.880516] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  219.880524] end_request: I/O error, dev sdc, sector 15661040
[  219.880528] Buffer I/O error on device sdc1, logical block 1956606
[  219.881999] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  219.882015] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  219.882020] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  219.882028] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  219.882047] end_request: I/O error, dev sdc, sector 0
[  219.882052] Buffer I/O error on device sdc, logical block 0
[  219.883480] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  219.883484] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  219.883487] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  219.883492] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  219.883499] end_request: I/O error, dev sdc, sector 15661040
[  219.884732] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  219.884736] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  219.884739] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  219.884743] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  219.884750] end_request: I/O error, dev sdc, sector 8192
--- cut similar ---
[  219.932609] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  219.932614] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  219.932618] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  219.932624] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  219.932633] end_request: I/O error, dev sdc, sector 8192
[  222.265999] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  222.266017] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  222.266022] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  222.266030] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  222.266049] end_request: I/O error, dev sdc, sector 8192
[  222.266055] quiet_error: 31 callbacks suppressed
[  222.266059] Buffer I/O error on device sdc1, logical block 0
[  222.267359] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  222.267365] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  222.267370] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  222.267375] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 08 00 00 08 00
[  222.267385] end_request: I/O error, dev sdc, sector 8200
[  222.267389] Buffer I/O error on device sdc1, logical block 1
[  222.276618] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  222.276632] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  222.276642] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  222.276654] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 10 00
[  222.276675] end_request: I/O error, dev sdc, sector 8192
[  222.276686] Buffer I/O error on device sdc1, logical block 0
[  222.276701] Buffer I/O error on device sdc1, logical block 1
[  222.277987] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  222.277992] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  222.277997] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  222.278014] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  222.278031] end_request: I/O error, dev sdc, sector 8192
[  222.278036] Buffer I/O error on device sdc1, logical block 0
--- cut similar ---
[  314.433818] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  314.433829] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  314.433840] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  314.433853] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 02 00 00 02 00
[  314.433874] end_request: I/O error, dev sdc, sector 8194
[  314.433905] EXT4-fs (sdc1): unable to read superblock
[  314.438939] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  314.438950] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  314.438960] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  314.438972] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 40 00 00 02 00
[  314.438994] end_request: I/O error, dev sdc, sector 8256
[  314.439027] isofs_fill_super: bread failed, dev=sdc1, iso_blknum=16, block=32
[  314.481436] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  314.481443] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  314.481449] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  314.481456] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 01 00
[  314.481467] end_request: I/O error, dev sdc, sector 8192
[  314.481485] FAT-fs (sdc1): unable to read boot sector



On Thu, Jan 26, 2012 at 12:58 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/26/2012 01:46 PM, Claus Olesen wrote:
>>
>> the dmesg output from inplug of 290e until usb mem stick mount timeout
>> with a cut marked "--- cut similar ---" between mount and timeout for
>> less output is
>
>
> I think it is maybe some incapability of em28xx driver. Maybe it could be
> something to do with USB HCI too...
>
>
> Could you test latest drivers using media_build.git ?
>
>
>
>>
>>> inplug 290e
>>
>> [  112.367345] usb 2-3: new high-speed USB device number 2 using ehci_hcd
>> [  112.482773] usb 2-3: New USB device found, idVendor=2013,
>> idProduct=024f
>> [  112.482783] usb 2-3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  112.482790] usb 2-3: Product: PCTV 290e
>> [  112.482796] usb 2-3: Manufacturer: PCTV Systems
>> [  112.482801] usb 2-3: SerialNumber: 00000006VEJQ
>> [  112.988850] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
>> (2013:024f, interface 0, class 0)
>> [  112.988929] em28xx #0: chip ID is em28174
>> [  113.284694] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
>> [  113.340323] Registered IR keymap rc-pinnacle-pctv-hd
>> [  113.340594] input: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1/input19
>> [  113.341677] rc1: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1
>> [  113.342411] em28xx #0: v4l2 driver version 0.1.3
>> [  113.348855] em28xx #0: V4L2 video device registered as video1
>> [  113.350562] usbcore: registered new interface driver em28xx
>> [  113.350568] em28xx driver loaded
>> [  113.480057] tda18271 17-0060: creating new instance
>> [  113.485221] TDA18271HD/C2 detected @ 17-0060
>> [  113.724218] tda18271 17-0060: attaching existing instance
>> [  113.724227] DVB: registering new adapter (em28xx #0)
>> [  113.724235] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
>> (DVB-T/T2))...
>> [  113.724763] DVB: registering adapter 0 frontend 1 (Sony CXD2820R
>> (DVB-C))...
>> [  113.728614] em28xx #0: Successfully loaded em28xx-dvb
>> [  113.728617] Em28xx: Initialized (Em28xx dvb Extension) extension
>>>
>>> inplug usb mem stick
>>
>> [  136.177341] usb 2-1: new high-speed USB device number 3 using ehci_hcd
>> [  136.308531] usb 2-1: New USB device found, idVendor=0bda,
>> idProduct=0120
>> [  136.308541] usb 2-1: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  136.308548] usb 2-1: Product: USB2.0-CRW
>> [  136.308554] usb 2-1: Manufacturer: Generic
>> [  136.308559] usb 2-1: SerialNumber: 20060413092100000
>> [  136.630379] Initializing USB Mass Storage driver...
>> [  136.630764] scsi6 : usb-storage 2-1:1.0
>> [  136.631270] usbcore: registered new interface driver usb-storage
>> [  136.631275] USB Mass Storage support registered.
>> [  137.636863] scsi 6:0:0:0: Direct-Access     Generic- Card Reader
>>   1.00 PQ: 0 ANSI: 0 CCS
>> [  137.639519] sd 6:0:0:0: Attached scsi generic sg3 type 0
>> [  138.446467] sd 6:0:0:0: [sdc] 15661056 512-byte logical blocks:
>> (8.01 GB/7.46 GiB)
>> [  138.447282] sd 6:0:0:0: [sdc] Write Protect is off
>> [  138.447291] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
>> [  138.448138] sd 6:0:0:0: [sdc] No Caching mode page present
>> [  138.448147] sd 6:0:0:0: [sdc] Assuming drive cache: write through
>> [  138.451639] sd 6:0:0:0: [sdc] No Caching mode page present
>> [  138.451647] sd 6:0:0:0: [sdc] Assuming drive cache: write through
>> [  138.452729]  sdc: sdc1
>>>
>>> mount usb mem stick sdc1
>>
>> [  168.838133] usb 2-1: reset high-speed USB device number 3 using
>> ehci_hcd
>
>
> [... removed lot of similar USB errors ...]
>
>
>> driverbyte=DRIVER_SENSE
>> [  478.342504] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
>> [  478.342510] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of
>> range
>> [  478.342517] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 01
>> 00
>> [  478.342528] end_request: I/O error, dev sdc, sector 8192
>> [  478.342545] FAT-fs (sdc1): unable to read boot sector
>>
>>
>>
>> On Thu, Jan 26, 2012 at 10:07 AM, Antti Palosaari<crope@iki.fi>  wrote:
>>>
>>> On 01/26/2012 12:16 AM, Claus Olesen wrote:
>>>>
>>>>
>>>> just got 3.2.1-3.fc16.i686.PAE
>>>> the issue that the driver had to be removed for the 290e to work after
>>>> a replug is gone.
>>>> the issue that a usb mem stick cannot be mounted while the 290e is
>>>> plugged in still lingers.
>>>> one workaround is to unplug the 290e and wait a little (no need to
>>>> also remove the driver).
>>>
>>>
>>>
>>> What it prints to the system log? Use tail -f /var/log/messages or dmesg.
>>>
>>>
>>> Antti
>>> --
>>> http://palosaari.fi/
>
>
>
> --
> http://palosaari.fi/
