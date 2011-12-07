Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39399 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745Ab1LGNbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 08:31:41 -0500
Received: by lagp5 with SMTP id p5so206345lag.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 05:31:40 -0800 (PST)
Message-ID: <4EDF6AB8.5050201@gmail.com>
Date: Wed, 07 Dec 2011 14:31:36 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <4EDF6262.2000209@redhat.com>
In-Reply-To: <4EDF6262.2000209@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/11 13:56, Mauro Carvalho Chehab wrote:
> On 02-12-2011 17:41, Fredrik Lingvall wrote:
>> Hi ,
>>
>> I noticed that HVR 930C support was added 21-11-2011.
>>
>> I have build the new driver and installed the firmware but I'm 
>> struggling to get it working.
>
>> 4) DVB scanning
>>
>> # w_scan -c NO -f c
>
> ...
>
>> 602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
>> QAM_256 f = 602000 kHz S6900C999
>
> This means that it detected a QAM_256 carrier, at 602000 kHz, with 
> 6.900 Kbauds symbol rate.
>
>> start_filter:1415: ERROR: ioctl DMX_SET_FILTER failed: 28 No space 
>> left on device
>
> -ENOSPC error is generally associated with the lack of USB bandwidth 
> support.
> This means that the USB bus doesn't have enough free slots for the 
> traffic
> required in order to support your stream.
>
> It generally means that your device is connected into a USB 1.1 hub or 
> port.
> There are some new USB interfaces that are known to have troubles with 
> the
> Linux USB 2.0 implementation, as they internally use some USB hubs.
> It could be your case, as the driver detects it on an USB 2.0 port:
>
>> [90072.073832] em28xx: New device WinTV HVR-930C @ 480 Mbps 
>> (2040:1605, interface 0, class 0)
>
> Please do a:
>
> # mount usbfs /proc/bus/usb -t usbfs
> $ cat /proc/bus/usb/devices
>
> It should see you something like:
>
> T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc= 29/900 us ( 3%), #Int=  2, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1d.2
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=08 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5  MxCh= 0
> D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=2101 ProdID=020f Rev= 0.01
> C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
>
> T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1d.1
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1d.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1a.2
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1a.1
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1a.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
>
> T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
> B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0002 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 ehci_hcd
> S:  Product=EHCI Host Controller
> S:  SerialNumber=0000:00:1d.7
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms
>
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
> B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0002 Rev= 3.01
> S:  Manufacturer=Linux 3.1.1-2.fc16.x86_64 ehci_hcd
> S:  Product=EHCI Host Controller
> S:  SerialNumber=0000:00:1a.7
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms
>
> T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#=  6 Spd=480  MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=2040 ProdID=1605 Rev= 1.00
> S:  Product=WinTV HVR-930C
> S:  SerialNumber=4034508088
> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
> I:  If#= 0 Alt= 1 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 2 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=1440 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 3 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=2048 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 4 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=2304 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 5 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=2688 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 6 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=2880 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
> I:  If#= 0 Alt= 7 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
> E:  Ad=82(I) Atr=01(Isoc) MxPS=3072 Ivl=125us
> E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
> E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
>
> In the above example, my HVR-930C is connected to Bus=01. The available
> bandwidth at the USB bus is given by:
>
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
> B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
>
> (in the above example, device is not used)
>
> Tuning into a channel spends 19% of the USB bandwidth (e. g. 152
> ISOC slots), as shown at:
>
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
> B:  Alloc=152/800 us (19%), #Int=  0, #Iso=  5
>
> The same bandwidth is required by w_scan/scan.
>
> You can also try to put your device on another bus and see if this would
> fix the issue.
>
> Regards,
> Mauro

Mauro,

This was interesting information! Here's the output while I'm doing a 
w_scan:

lin-tv ~ # cat /proc/bus/usb/devices | grep -50 "Bus=02"

<snip>

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.02
S:  Manufacturer=Linux 3.2.0-rc3+ ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  8 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2040 ProdID=1605 Rev= 1.00
S:  Product=WinTV HVR-930C
S:  SerialNumber=4034210708
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
I:  If#= 0 Alt= 1 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 2 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=1440 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 3 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2048 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 4 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2304 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 5 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2688 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 6 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2880 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us
I:  If#= 0 Alt= 7 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=3072 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 940 Ivl=125us

<snip>

Bus 2 doesn't seem to do anything [Alloc=  0/800 us ( 0%)] while I'm 
scanning!?

BTW: I'm running Gentoo x86_64 (amd64) on a Dell M2400 laptop with an 
SSD disk.

Other hardware connected is a 200 GB disk using the eSata slot, a 1TB WD 
disk connected using another USB slot, a RME Multiface II soundcard 
using the expresscard slot.

Regards,

/Fredrik


