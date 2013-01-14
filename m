Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57443 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3ANSBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 13:01:08 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2360659pad.33
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 10:01:08 -0800 (PST)
Message-ID: <50F447E0.4060009@gmail.com>
Date: Tue, 15 Jan 2013 02:01:04 +0800
From: "nise.design" <nise.design@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem between DMB-TH USB dongle drivers and Frontend broken (DVBv3
 migrate to DVBv5)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
          I'm a Ubuntu and DMB-TH digital TV USB dongle user.  The USB 
dongle working flawlessly in Ubuntu 10.XX, but it failed after migrate 
to latest Ubuntu 12.10.  Then I using google to find out the problem and 
suspect the problem come from DVBv3 migrate to DVBv5.  Because of 
creator of original DMB-TH drivers passed away so I wanted to continue 
his work to migrate DMB-TH drivers to new DVBv5 system.  I need some 
help to perform this task and the situation as below:

I plugged the USB dongle to USB port and it init normally:
[103542.354826] usb 2-1.7: new high-speed USB device number 9 using ehci_hcd
[103542.448349] usb 2-1.7: New USB device found, idVendor=0572, 
idProduct=d811
[103542.448353] usb 2-1.7: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[103542.448356] usb 2-1.7: Product: USB Stick
[103542.448358] usb 2-1.7: Manufacturer: Geniatech
[103542.448360] usb 2-1.7: SerialNumber: 080116
[103542.449395] dvb-usb: found a 'Mygica D689 DMB-TH' in warm state.
[103542.790351] dvb-usb: will pass the complete MPEG2 transport stream 
to the software demuxer.
[103542.790666] DVB: registering new adapter (Mygica D689 DMB-TH)
[103543.038504] usb 2-1.7: DVB: registering adapter 0 frontend 0 
(AltoBeam ATBM8830/8831 DMB-TH)...
[103543.055041] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/input/input18
[103543.055119] dvb-usb: schedule remote query interval to 100 msecs.
[103543.055215] dvb-usb: Mygica D689 DMB-TH successfully initialized and 
connected.

It failed after issued scan or any other command with messages:
[103835.202015] usb 2-1.7: dtv_property_cache_sync: doesn't know how to 
handle a DVBv3 call to delivery system 0

Its alway show xxxx: doesn't know how to handle a DVBv3 call to delivery 
system 0.  I have two dongles using altobeam 8830 chip and LG8GXX chip 
but both had same issued.

After google search I think the problem may be come from connection 
between DMB-TH drivers and dvb_frontend.c broken. I wanted to know any 
example code or instruction about DVBv3 driver connect to 
dvb_frontend.c.  Thank you for any advice.

KP Lee.

google search attached:

[PATCHv2 00/94] Only use DVBv5 internally on frontend drivers

     Subject: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
     From: Mauro Carvalho Chehab <mchehab@xxxxxxxxxx>
     Date: Fri, 30 Dec 2011 13:06:57 -0200
     Cc: Mauro Carvalho Chehab <mchehab@xxxxxxxxxx>, Linux Media Mailing 
List <linux-media@xxxxxxxxxxxxxxx>

This patch series comes after the previous series of 47 patches. 
Basically, changes all DVB frontend drivers to work directly with the 
DVBv5 structure. This warrants that all drivers will be getting/setting 
frontend parameters on a consistent way, and opens space for improving 
the DVB core, in order to avoid copying data from/to the DVBv3 structs 
without need. Most of the patches on this series are trivial changes. 
Yet, it would be great to test them, in order to be sure that nothing 
broke. The last patch in this series hide the DVBv3 parameters struct 
from the frontend drivers, keeping them visible only to the dvb_core. 
This helps to warrant that everything were ported, and that newer 
patches won't re-introduce DVBv3 structs by mistake. There aren't many 
cleanups inside the dvb_frontend.c yet. Before cleaning up the core, I 
intend to do some tests with a some devices, in order to be sure that 
nothing broke with all those changes. Test reports are welcome.

[media] atbm8830: convert set_fontend to new way and fix delivery system
[media] lgs8gl5: convert set_fontend to use DVBv5 parameters
[media] lgs8gxx: convert set_fontend to use DVBv5 parameters

drivers/media/dvb/frontends/atbm8830.c | 24 ++--
drivers/media/dvb/frontends/lgs8gl5.c | 26 ++--
drivers/media/dvb/frontends/lgs8gxx.c | 23 ++--
