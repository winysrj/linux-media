Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33309 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbbEAJjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 05:39:46 -0400
Received: by qkx62 with SMTP id 62so48244348qkx.0
        for <linux-media@vger.kernel.org>; Fri, 01 May 2015 02:39:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 May 2015 11:39:45 +0200
Message-ID: <CAEk3jHjE0ufT_CqqTSxsZ0XSxQW5D9GnVh7cQHQuFGL_KLz6RQ@mail.gmail.com>
Subject: issue with TechnoTrend CT2-4650 CI
From: Michal B <developer.m3@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

i bought new TechnoTrend  CT2-4650 CI ,
i tried to use it on wind* , successfuly also with encrypted channels with CAM,
then i tried on linux with kernel 3.19.6, and i got two behaviors:
when CAM is unplugged i'm able to watch unencrypted channels correctly,
but when i plugged in CAM i'm unable to find any channel during scan
with w_scan,
and also i'm unable to tune any channel previously found,

and i have second issue: when i have CAM plugged and i unplug
TechnoTrend from USB on my computer - my computer freezes - so i have
to reset by button on the case,

please somebody could help me to get it running with CAM to watch
encrypted channels ?

here is output when CAM is unplugged:

[ 1381.807428] usb 3-10: new high-speed USB device number 4 using xhci_hcd
[ 1381.935870] usb 3-10: New USB device found, idVendor=0b48, idProduct=3012
[ 1381.935872] usb 3-10: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 1381.935874] usb 3-10: Product: TechnoTrend USB2.0
[ 1381.935874] usb 3-10: Manufacturer: CityCom GmbH
[ 1381.935875] usb 3-10: SerialNumber: 20130422
[ 1382.222836] usb 3-10: dvb_usb_v2: found a 'TechnoTrend TT-connect
CT2-4650 CI' in warm state
[ 1382.222868] usb 3-10: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[ 1382.222875] DVB: registering new adapter (TechnoTrend TT-connect CT2-4650 CI)
[ 1382.224114] usb 3-10: dvb_usb_v2: MAC address: bc:ea:2b:65:00:ad
[ 1382.245403] i2c i2c-7: Added multiplexed i2c bus 8
[ 1382.245406] si2168 7-0064: Silicon Labs Si2168 successfully attached
[ 1382.259984] si2157 8-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[ 1382.273787] sp2 7-0040: CIMaX SP2 successfully attached
[ 1382.273794] usb 3-10: DVB: registering adapter 0 frontend 0
(Silicon Labs Si2168)...
[ 1382.310693] Registered IR keymap rc-tt-1500
[ 1382.310744] input: TechnoTrend TT-connect CT2-4650 CI as
/devices/pci0000:00/0000:00:14.0/usb3/3-10/rc/rc0/input23
[ 1382.310827] rc0: TechnoTrend TT-connect CT2-4650 CI as
/devices/pci0000:00/0000:00:14.0/usb3/3-10/rc/rc0
[ 1382.310831] usb 3-10: dvb_usb_v2: schedule remote query interval to 300 msecs
[ 1382.310832] usb 3-10: dvb_usb_v2: 'TechnoTrend TT-connect CT2-4650
CI' successfully initialized and connected
[ 1382.310847] usbcore: registered new interface driver dvb_usb_dvbsky

when i start vlc:
[ 1485.824805] si2168 7-0064: found a 'Silicon Labs Si2168' in cold state
[ 1485.835991] si2168 7-0064: downloading firmware from file
'dvb-demod-si2168-a20-01.fw'
[ 1491.074442] si2168 7-0064: found a 'Silicon Labs Si2168' in warm state
[ 1491.083144] si2157 8-0060: found a 'Silicon Labs
Si2146/2147/2148/2157/2158' in cold state
[ 1491.090486] si2157 8-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'


Kind regards,
