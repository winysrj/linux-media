Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49171 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaLGMlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 07:41:11 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so2506861wiw.3
        for <linux-media@vger.kernel.org>; Sun, 07 Dec 2014 04:41:10 -0800 (PST)
Received: from trt2 (chello089173176125.chello.sk. [89.173.176.125])
        by mx.google.com with ESMTPSA id cp4sm52436154wjb.16.2014.12.07.04.41.09
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Dec 2014 04:41:09 -0800 (PST)
Date: Sun, 7 Dec 2014 13:41:07 +0100
From: Pavol Domin <pavol.domin@gmail.com>
To: linux-media@vger.kernel.org
Subject: TT-connect CT2-4650 CI: DVB-C: no signal, no QAM
Message-ID: <20141207124107.GA7271@trt2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently purchased "TechnoTrend TT-connect CT2-4650 CI" in order to
watch DVB-C cable TV. I have obtained CAM and smart card from my cable
TV provider.

Initially, I tried the closed-source driver from the manufacturer; I have
scanned (w_scan) over hundred of channels and I was able to watch few channels (vlc
or xine) for several minutes. After couple of channels switches however,
xine started to report 'DVB Signal Lost' for any channel. The w_scan
founds nothing anymore - tried multiple kernels on different machines,
during several days, nothing ;)

Manufacturer is not providing linux support and directed me to
linux_media instead.

The situation with linux_media is not better however (tried recent
media_build on ubuntu 3.16 and fedora 3.17 kernels)

1. the device is detected without any problems, no single error reported:
[ 1957.068871] dvb-usb: found a 'TechnoTrend TT-connect CT2-4650 CI' in warm state.
[ 1957.068999] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 1957.069182] DVB: registering new adapter (TechnoTrend TT-connect CT2-4650 CI)
[ 1957.070518] dvb-usb: MAC address: bc:ea:2b:65:02:3b
[ 1957.283195] i2c i2c-9: Added multiplexed i2c bus 10
[ 1957.283205] si2168 9-0064: Silicon Labs Si2168 successfully attached
[ 1957.287689] si2157 10-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[ 1957.498312] sp2 9-0040: CIMaX SP2 successfully attached
[ 1957.498348] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[ 1957.498835] Registered IR keymap rc-tt-1500
[ 1957.499038] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input23
[ 1957.499408] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
[ 1957.499413] dvb-usb: schedule remote query interval to 150 msecs.
[ 1957.499419] dvb-usb: TechnoTrend TT-connect CT2-4650 CI successfully initialized and connected.
[ 1963.755553] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 2016.342642] si2168 9-0064: found a 'Silicon Labs Si2168' in cold state
[ 2016.342910] si2168 9-0064: downloading firmware from file 'dvb-demod-si2168-a20-01.fw'
[ 2017.729882] si2168 9-0064: found a 'Silicon Labs Si2168' in warm state
[ 2017.739725] si2157 10-0060: found a 'Silicon Labs Si2146/2147/2148/2157/2158' in cold state
[ 2017.739805] si2157 10-0060: downloading firmware from file 'dvb-tuner-si2158-a20-01.fw'

2. yet, the full dvb-c w_scan founds zero channels (after 20+ minutes of
scanning)

3. an attempt to tune a channel (czap) using the channel list scanned
the first time returns:
$ czap -r -c channels.xine.conf 'Eurosport HD'
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file 'channels.xine.conf'
141 Eurosport
HD:562000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256:3000:3201:14001
141 Eurosport HD: f 562000000, s 6900000, i 2, fec 0, qam 5, v 0xbb8, a 0xc81, s 0x36b1 
ERROR: frontend device is not a QAM (DVB-C) device


Any advice, please, what can be done to make this working? The device
works without any problems from windows.

Two additional notes:
1. The md5sum 0276023ce027bab05c2e7053033e2182 for the firmware linked at
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400#Firmware 
does not match: 

$ wget http://www.tt-downloads.de/bda-treiber_4.2.0.0.zip
...
2014-12-07 13:12:25 (1.06 MB/s) - ‘bda-treiber_4.2.0.0.zip’ saved
[352188/352188]
$ unzip bda-treiber_4.2.0.0.zip 
Archive:  bda-treiber_4.2.0.0.zip
  inflating: ttTVStick4400.inf       
  inflating: ttTVStick4400.sys       
  inflating: ttTVStick4400_64.sys    
  inflating: tttvstick4400.cat       
$ md5sum ttTVStick4400_64.sys
7ac2029e1db41b8942691df270e0f84f  ttTVStick4400_64.sys

I copied firmwares from OpenELEC

2. I am getting this, with w_scan, with the media_build driver:
$ cat w_scan
using DVB API 5.a
frontend 'Silicon Labs Si2168' supports
INVERSION_AUTO
QAM_AUTO
FEC_AUTO
FREQ (110.00MHz ... 862.00MHz)
This dvb driver is *buggy*: the symbol rate limits are undefined -
please report to linuxtv.org
...

3. Manufacturer driver displays no w_scan "no QAM" errors, even czap seems
fine:
$ czap -r -c channels.xine.conf 'Eurosport HD'
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file 'channels.xine.conf'
141 Eurosport
HD:562000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256:3000:3201:14001
141 Eurosport HD: f 562000000, s 6900000, i 2, fec 0, qam 5, v 0xbb8, a 0xc81, s 0x36b1
Version: 5.10       FE_CAN { DVB-C (A) }
status 1f | signal 5453 | snr 0003 | ber 8e8dead8 | unc 000f00ed | FE_HAS_LOCK
status 1f | signal 5453 | snr 0003 | ber 00000000 | unc 000f00ed | FE_HAS_LOCK
...

Yet, the application reports no signal.


Regards,
Pavol

