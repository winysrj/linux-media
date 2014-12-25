Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:57878 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaLYM1w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Dec 2014 07:27:52 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp4.pb.cz (Postfix) with ESMTPS id 99D0A80F37
	for <linux-media@vger.kernel.org>; Thu, 25 Dec 2014 13:27:48 +0100 (CET)
Message-ID: <549C02C4.3080000@mizera.cz>
Date: Thu, 25 Dec 2014 13:27:48 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvb-usb-it913x bad initialization
Content-Type: multipart/mixed;
 boundary="------------060604090404090401090002"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060604090404090401090002
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

I have find out, that my problem with

048d:9135 Integrated Technology Express, Inc. Zolid Mini DVB-T Stick

with orig. driver  dvb-usb-it913x on kernel 3.8 is in something bad by 
making the device warm.

If the device is initialized by dvb-usb-it913 - all seems to be OK:
- firmware is uploaded
- device initialized

(see attachment 1)


but by using - it does nothing:

xxxxxxxxxxxxxxxxxxx
tzap -r -c /etc/channels.conf "K41 - NOVA"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/etc/channels.conf'
tuning to 634000000 Hz
video pid 0x0065, audio pid 0x006f
status 01 | signal 170a | snr 0000 | ber 00000000 | unc 00000000 |
...
xxxxxxxxxxxxxxxxxxx

These lines
status 01 | signal 170a | snr 0000 | ber 00000000 | unc 00000000 |
comes out in very long intervals

But - if I disable the driver in /etc/modprobe.d/blacklist-custom.conf
and use this device in VirtualBox - Windows XP, then the device is in 
correct way initialized and I can (after "removing" in VBox) use it in 
Ubuntu:

-  modprobe -v dvb-usb-it913x (see attachment 2)

xxxxxxxxx
# tzap -r -c /etc/channels.conf "K41 - NOVA"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/etc/channels.conf'
tuning to 634000000 Hz
video pid 0x0065, audio pid 0x006f
status 1f | signal 2e14 | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 428f | snr 85c0 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 3851 | snr 7e5f | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 3851 | snr 7a4f | ber 000005a6 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 3851 | snr 72c4 | ber 0000114a | unc 00000000 | 
FE_HAS_LOCK
xxxxxxxxxxxxxxx


Notes:

- I have in past used with success this device on kernel 3.2 with newest 
driver from git. But from +- 9/2014 the driver AF9035 stops working for 
3.2 kernel (see my report here in forum: subject="AF9035 not builded 
from git")

- the AF9035 from git did not work even in 3.8 kernel  (see my report 
here in forum: subject="it913x: probe of 8-001c failed with error -22")


What does linux driver wrong ?

THX

--kapetr




--------------060604090404090401090002
Content-Type: text/x-log;
 name="1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="1.log"

Dec 25 12:52:34 zly-hugo kernel: [  827.672719] usb 1-1.4: new high-speed USB device number 15 using ehci-pci
Dec 25 12:52:34 zly-hugo kernel: [  827.766583] usb 1-1.4: New USB device found, idVendor=048d, idProduct=9135
Dec 25 12:52:34 zly-hugo kernel: [  827.766589] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Dec 25 12:52:34 zly-hugo mtp-probe: checking bus 1, device 15: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4"
Dec 25 12:52:34 zly-hugo mtp-probe: bus: 1, device: 15 was not an MTP device
Dec 25 12:52:34 zly-hugo kernel: [  827.769449] it913x: Chip Version=02 Chip Type=9135
Dec 25 12:52:34 zly-hugo kernel: [  827.770192] it913x: Dual mode=0 Tuner Type=38it913x: Unknown tuner ID applying default 0x60
Dec 25 12:52:34 zly-hugo kernel: [  827.771694] usb 1-1.4: dvb_usb_v2: found a 'ITE 9135 Generic' in cold state
Dec 25 12:52:34 zly-hugo kernel: [  827.771739] usb 1-1.4: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
Dec 25 12:52:34 zly-hugo kernel: [  827.772063] it913x: FRM Starting Firmware Download
Dec 25 12:52:34 zly-hugo kernel: [  827.990853] it913x: FRM Firmware Download Completed - Resetting Deviceit913x: Chip Version=02 Chip Type=9135
Dec 25 12:52:34 zly-hugo kernel: [  828.025809] it913x: Firmware Version 52953344<6>[  828.096399] usb 1-1.4: dvb_usb_v2: found a 'ITE 9135 Generic' in warm state
Dec 25 12:52:34 zly-hugo kernel: [  828.096461] usb 1-1.4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Dec 25 12:52:34 zly-hugo kernel: [  828.096592] DVB: registering new adapter (ITE 9135 Generic)
Dec 25 12:52:34 zly-hugo kernel: [  828.100344] it913x-fe: ADF table value	:00
Dec 25 12:52:34 zly-hugo kernel: [  828.104440] it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
Dec 25 12:52:34 zly-hugo kernel: [  828.140137] it913x-fe: Tuner LNA type :60
Dec 25 12:52:35 zly-hugo kernel: [  828.385526] usb 1-1.4: DVB: registering adapter 0 frontend 0 (ITE 9135 Generic_1)...
Dec 25 12:52:35 zly-hugo kernel: [  828.385659] Registered IR keymap rc-it913x-v1
Dec 25 12:52:35 zly-hugo kernel: [  828.385729] input: ITE 9135 Generic as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/rc/rc4/input18
Dec 25 12:52:35 zly-hugo kernel: [  828.386448] rc4: ITE 9135 Generic as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/rc/rc4
Dec 25 12:52:35 zly-hugo kernel: [  828.386454] usb 1-1.4: dvb_usb_v2: schedule remote query interval to 250 msecs
Dec 25 12:52:35 zly-hugo kernel: [  828.386458] usb 1-1.4: dvb_usb_v2: 'ITE 9135 Generic' successfully initialized and connected


--------------060604090404090401090002
Content-Type: text/x-log;
 name="2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.log"

Dec 25 12:53:08 zly-hugo kernel: [  861.670258] usb 1-1.4: new high-speed USB device number 16 using ehci-pci
Dec 25 12:53:08 zly-hugo kernel: [  861.764142] usb 1-1.4: New USB device found, idVendor=048d, idProduct=9135
Dec 25 12:53:08 zly-hugo kernel: [  861.764148] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Dec 25 12:53:08 zly-hugo mtp-probe: checking bus 1, device 16: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4"
Dec 25 12:53:08 zly-hugo mtp-probe: bus: 1, device: 16 was not an MTP device
Dec 25 12:53:15 zly-hugo ntpd_intres[3447]: host name not found: 3.ubuntu.pool.ntp.org
Dec 25 12:53:29 zly-hugo kernel: [  882.962661] usb 1-1.4: reset high-speed USB device number 16 using ehci-pci
Dec 25 12:53:40 zly-hugo kernel: [  894.171735] usbcore: registered new interface driver dvb_usb_it913x
Dec 25 12:53:40 zly-hugo kernel: [  894.172551] it913x: Chip Version=02 Chip Type=9135
Dec 25 12:53:40 zly-hugo kernel: [  894.172962] it913x: Firmware Version 52953344it913x: Dual mode=0 Tuner Type=38
Dec 25 12:53:40 zly-hugo kernel: [  894.173335] it913x: Unknown tuner ID applying default 0x60<6>[  894.173340] usb 1-1.4: dvb_usb_v2: found a 'ITE 9135 Generic' in warm state
Dec 25 12:53:40 zly-hugo kernel: [  894.173387] usb 1-1.4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Dec 25 12:53:40 zly-hugo kernel: [  894.173514] DVB: registering new adapter (ITE 9135 Generic)
Dec 25 12:53:40 zly-hugo kernel: [  894.176921] it913x-fe: ADF table value	:00
Dec 25 12:53:40 zly-hugo kernel: [  894.182234] it913x-fe: Crystal Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
Dec 25 12:53:40 zly-hugo kernel: [  894.220171] it913x-fe: Tuner LNA type :60
Dec 25 12:53:41 zly-hugo kernel: [  894.465468] usb 1-1.4: DVB: registering adapter 0 frontend 0 (ITE 9135 Generic_1)...
Dec 25 12:53:41 zly-hugo kernel: [  894.465573] Registered IR keymap rc-it913x-v1
Dec 25 12:53:41 zly-hugo kernel: [  894.465646] input: ITE 9135 Generic as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/rc/rc5/input19
Dec 25 12:53:41 zly-hugo kernel: [  894.465761] rc5: ITE 9135 Generic as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/rc/rc5
Dec 25 12:53:41 zly-hugo kernel: [  894.465766] usb 1-1.4: dvb_usb_v2: schedule remote query interval to 250 msecs
Dec 25 12:53:41 zly-hugo kernel: [  894.465770] usb 1-1.4: dvb_usb_v2: 'ITE 9135 Generic' successfully initialized and connected


--------------060604090404090401090002--
