Return-path: <linux-media-owner@vger.kernel.org>
Received: from dougal.woof94.com ([125.63.57.136]:37477 "EHLO
	dougal.woof94.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIYMkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 08:40:47 -0400
Received: from c220-239-45-10.eburwd6.vic.optusnet.com.au ([220.239.45.10] helo=[192.168.42.2])
	by dougal.woof94.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <hamish@cloud.net.au>)
	id 1XX7vC-0000Jq-JS
	for linux-media@vger.kernel.org; Thu, 25 Sep 2014 12:13:18 +0000
Message-ID: <542406DE.10403@cloud.net.au>
Date: Thu, 25 Sep 2014 22:13:18 +1000
From: Hamish Moffatt <hamish@cloud.net.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problem with second tuner on Leadtek DTV dongle dual
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a new Leadtek DTV dongle dual (usb 0413:6a05). With linux 3.16.3 
the first adapter tunes and works fine, but the second tuner will only 
tune to the one UHF multiplex in our area. The other five multiplexes 
are all VHF and it won't lock on any of those.

Here's the kernel log from inserting the device;

[  125.030689] usb 5-1.1: new high-speed USB device number 3 using ehci-pci
[  125.126691] usb 5-1.1: New USB device found, idVendor=0413, 
idProduct=6a05
[  125.126695] usb 5-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[  125.126698] usb 5-1.1: Product: WinFast DTV Dongle Dual
[  125.126700] usb 5-1.1: Manufacturer: Leadtek
[  125.221407] usb 5-1.1: dvb_usb_af9035: prechip_version=83 
chip_version=02 chip_type=9135
[  125.221813] usb 5-1.1: dvb_usb_v2: found a 'Leadtek WinFast DTV 
Dongle Dual' in cold state
[  125.232168] usb 5-1.1: dvb_usb_v2: downloading firmware from file 
'dvb-usb-it9135-02.fw'
[  127.157506] usb 5-1.1: dvb_usb_af9035: firmware version=3.39.1.0
[  127.157517] usb 5-1.1: dvb_usb_v2: found a 'Leadtek WinFast DTV 
Dongle Dual' in warm state
[  127.159469] usb 5-1.1: dvb_usb_af9035: [0] overriding tuner from 38 to 60
[  127.160971] usb 5-1.1: dvb_usb_af9035: [1] overriding tuner from 38 to 60
[  127.162547] usb 5-1.1: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[  127.162571] DVB: registering new adapter (Leadtek WinFast DTV Dongle 
Dual)
[  127.180119] i2c i2c-11: af9033: firmware version: LINK=0.0.0.0 
OFDM=3.9.1.0
[  127.180127] usb 5-1.1: DVB: registering adapter 2 frontend 0 (Afatech 
AF9033 (DVB-T))...
[  127.193146] i2c i2c-11: tuner_it913x: ITE Tech IT913X successfully 
attached
[  127.193152] usb 5-1.1: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[  127.193173] DVB: registering new adapter (Leadtek WinFast DTV Dongle 
Dual)
[  127.205374] i2c i2c-11: af9033: firmware version: LINK=0.0.0.0 
OFDM=3.9.1.0
[  127.205381] usb 5-1.1: DVB: registering adapter 3 frontend 0 (Afatech 
AF9033 (DVB-T))...
[  127.205521] i2c i2c-11: tuner_it913x: ITE Tech IT913X successfully 
attached
[  127.218475] Registered IR keymap rc-empty
[  127.218568] input: Leadtek WinFast DTV Dongle Dual as 
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/rc/rc1/input18
[  127.218669] rc1: Leadtek WinFast DTV Dongle Dual as 
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/rc/rc1
[  127.218674] usb 5-1.1: dvb_usb_v2: schedule remote query interval to 
500 msecs
[  127.218677] usb 5-1.1: dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual' 
successfully initialized and connected
[  127.218827] usbcore: registered new interface driver dvb_usb_af9035

Here's an attempt to tune a VHF station with tzap; w_scan only finds the 
UHF multiplex. Note it's adapter 2 and 3, as I have a leadtek PCI card 
at adapters 0 and 1.

[ 9:44PM] hamish@quokka:~ $ tzap -a3 ABC
using '/dev/dvb/adapter3/frontend0' and '/dev/dvb/adapter3/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00fa797a | unc 00073f4b |
status 07 | signal ffff | snr 0000 | ber 00fa797a | unc 000765d0 |
status 00 | signal ffff | snr 0000 | ber 00fa797a | unc 00078c55 |
status 07 | signal ffff | snr 0000 | ber 00fa797a | unc 0007b2da |
status 00 | signal ffff | snr 0000 | ber 00e45fb3 | unc 0007d95f |
status 07 | signal ffff | snr 0000 | ber 00e45fb3 | unc 0007ffe4 |
^C
[ 9:44PM] hamish@quokka:~ $
[ 9:44PM] hamish@quokka:~ $ tzap -a2 ABC
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file '/home/hamish/.tzap/channels.conf'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0122 | ber 00000000 | unc 00000000 |
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ffff | snr 0122 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK


Is this a known problem, and is there a solution?

Thanks,

Hamish

