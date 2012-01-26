Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36828 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab2AZLrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 06:47:01 -0500
Received: by lagu2 with SMTP id u2so255264lag.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 03:46:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2117D6.20702@iki.fi>
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
	<4F2117D6.20702@iki.fi>
Date: Thu, 26 Jan 2012 12:46:58 +0100
Message-ID: <CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
Subject: Re: 290e locking issue
From: Claus Olesen <ceolesen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the dmesg output from inplug of 290e until usb mem stick mount timeout
with a cut marked "--- cut similar ---" between mount and timeout for
less output is

>inplug 290e
[  112.367345] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[  112.482773] usb 2-3: New USB device found, idVendor=2013, idProduct=024f
[  112.482783] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  112.482790] usb 2-3: Product: PCTV 290e
[  112.482796] usb 2-3: Manufacturer: PCTV Systems
[  112.482801] usb 2-3: SerialNumber: 00000006VEJQ
[  112.988850] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[  112.988929] em28xx #0: chip ID is em28174
[  113.284694] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[  113.340323] Registered IR keymap rc-pinnacle-pctv-hd
[  113.340594] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1/input19
[  113.341677] rc1: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1
[  113.342411] em28xx #0: v4l2 driver version 0.1.3
[  113.348855] em28xx #0: V4L2 video device registered as video1
[  113.350562] usbcore: registered new interface driver em28xx
[  113.350568] em28xx driver loaded
[  113.480057] tda18271 17-0060: creating new instance
[  113.485221] TDA18271HD/C2 detected @ 17-0060
[  113.724218] tda18271 17-0060: attaching existing instance
[  113.724227] DVB: registering new adapter (em28xx #0)
[  113.724235] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
(DVB-T/T2))...
[  113.724763] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
[  113.728614] em28xx #0: Successfully loaded em28xx-dvb
[  113.728617] Em28xx: Initialized (Em28xx dvb Extension) extension
>inplug usb mem stick
[  136.177341] usb 2-1: new high-speed USB device number 3 using ehci_hcd
[  136.308531] usb 2-1: New USB device found, idVendor=0bda, idProduct=0120
[  136.308541] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  136.308548] usb 2-1: Product: USB2.0-CRW
[  136.308554] usb 2-1: Manufacturer: Generic
[  136.308559] usb 2-1: SerialNumber: 20060413092100000
[  136.630379] Initializing USB Mass Storage driver...
[  136.630764] scsi6 : usb-storage 2-1:1.0
[  136.631270] usbcore: registered new interface driver usb-storage
[  136.631275] USB Mass Storage support registered.
[  137.636863] scsi 6:0:0:0: Direct-Access     Generic- Card Reader
  1.00 PQ: 0 ANSI: 0 CCS
[  137.639519] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  138.446467] sd 6:0:0:0: [sdc] 15661056 512-byte logical blocks:
(8.01 GB/7.46 GiB)
[  138.447282] sd 6:0:0:0: [sdc] Write Protect is off
[  138.447291] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  138.448138] sd 6:0:0:0: [sdc] No Caching mode page present
[  138.448147] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  138.451639] sd 6:0:0:0: [sdc] No Caching mode page present
[  138.451647] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  138.452729]  sdc: sdc1
>mount usb mem stick sdc1
[  168.838133] usb 2-1: reset high-speed USB device number 3 using ehci_hcd
[  168.959139] sd 6:0:0:0: [sdc] No Caching mode page present
[  168.959150] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  168.959159] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[  199.878136] usb 2-1: reset high-speed USB device number 3 using ehci_hcd
[  199.998075] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  199.998082] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  199.998087] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  199.998094] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  199.998106] end_request: I/O error, dev sdc, sector 15660928
[  199.998110] Buffer I/O error on device sdc, logical block 1957616
[  199.999455] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  199.999460] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  199.999465] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  199.999471] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  199.999480] end_request: I/O error, dev sdc, sector 15660928
[  199.999484] Buffer I/O error on device sdc, logical block 1957616
[  200.000570] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.000573] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.000576] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.000580] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  200.000586] end_request: I/O error, dev sdc, sector 15660928
[  200.000589] Buffer I/O error on device sdc1, logical block 1956592
[  200.001696] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.001701] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.001705] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.001711] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  200.001721] end_request: I/O error, dev sdc, sector 15661040
[  200.001724] Buffer I/O error on device sdc, logical block 1957630
[  200.002819] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.002824] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.002829] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.002835] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 80 00 00 08 00
[  200.002844] end_request: I/O error, dev sdc, sector 15660928
[  200.002848] Buffer I/O error on device sdc1, logical block 1956592
[  200.003945] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.003950] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.003955] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.003961] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  200.003970] end_request: I/O error, dev sdc, sector 15661040
[  200.003973] Buffer I/O error on device sdc, logical block 1957630
[  200.031199] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.031204] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.031209] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.031215] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  200.031225] end_request: I/O error, dev sdc, sector 15661040
[  200.031229] Buffer I/O error on device sdc1, logical block 1956606
[  200.032322] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.032327] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.032331] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.032337] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  200.032347] end_request: I/O error, dev sdc, sector 0
[  200.032350] Buffer I/O error on device sdc, logical block 0
[  200.033448] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.033452] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.033457] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.033463] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f0 00 00 08 00
[  200.033472] end_request: I/O error, dev sdc, sector 15661040
[  200.033476] Buffer I/O error on device sdc1, logical block 1956606
[  200.034603] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.034612] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.034621] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.034633] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  200.034652] end_request: I/O error, dev sdc, sector 0
[  200.034658] Buffer I/O error on device sdc, logical block 0
[  200.035709] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.035719] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.035728] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.035740] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  200.035761] end_request: I/O error, dev sdc, sector 8192
[  200.036837] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.036846] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.036855] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.036867] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 08 00 00 08 00
[  200.036886] end_request: I/O error, dev sdc, sector 8
[  200.037961] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.037970] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.037979] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.037991] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 08 00
[  200.038027] end_request: I/O error, dev sdc, sector 8192
[  200.039091] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.039101] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.039110] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.039123] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f8 00 00 01 00
[  200.039142] end_request: I/O error, dev sdc, sector 15661048
[  200.040209] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  200.040218] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  200.040227] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  200.040239] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 08 00 00 08 00
[  200.040259] end_request: I/O error, dev sdc, sector 8200
[  230.854039] usb 2-1: reset high-speed USB device number 3 using ehci_hcd
[  230.974172] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  230.974178] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  230.974184] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  230.974191] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 ee f7 f8 00 00 01 00
[  230.974202] end_request: I/O error, dev sdc, sector 15661048
[  230.974206] quiet_error: 5 callbacks suppressed
[  230.974210] Buffer I/O error on device sdc, logical block 1957631
--- cut similar ---
[  478.279628] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  478.279634] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  478.279639] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  478.279645] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 02 00 00 02 00
[  478.279656] end_request: I/O error, dev sdc, sector 8194
[  478.279675] EXT4-fs (sdc1): unable to read superblock
[  478.288033] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  478.288045] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  478.288056] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  478.288068] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 40 00 00 02 00
[  478.288090] end_request: I/O error, dev sdc, sector 8256
[  478.288124] isofs_fill_super: bread failed, dev=sdc1, iso_blknum=16, block=32
[  478.342498] sd 6:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  478.342504] sd 6:0:0:0: [sdc]  Sense Key : Illegal Request [current]
[  478.342510] sd 6:0:0:0: [sdc]  Add. Sense: Logical block address out of range
[  478.342517] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 20 00 00 00 01 00
[  478.342528] end_request: I/O error, dev sdc, sector 8192
[  478.342545] FAT-fs (sdc1): unable to read boot sector



On Thu, Jan 26, 2012 at 10:07 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/26/2012 12:16 AM, Claus Olesen wrote:
>>
>> just got 3.2.1-3.fc16.i686.PAE
>> the issue that the driver had to be removed for the 290e to work after
>> a replug is gone.
>> the issue that a usb mem stick cannot be mounted while the 290e is
>> plugged in still lingers.
>> one workaround is to unplug the 290e and wait a little (no need to
>> also remove the driver).
>
>
> What it prints to the system log? Use tail -f /var/log/messages or dmesg.
>
>
> Antti
> --
> http://palosaari.fi/
