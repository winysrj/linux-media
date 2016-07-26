Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33532 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbcGZMiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 08:38:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so1476707wme.0
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2016 05:38:07 -0700 (PDT)
Received: from [192.168.178.21] (p549C4AE3.dip0.t-ipconnect.de. [84.156.74.227])
        by smtp.googlemail.com with ESMTPSA id x203sm32715167wmg.0.2016.07.26.05.38.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jul 2016 05:38:05 -0700 (PDT)
From: "Oliver O." <oliver.o456i@gmail.com>
Subject: dvb-usb/dw2102: frontend initialization missing when dvb_usb
 disable_rc_polling=1
To: linux-media@vger.kernel.org
Message-ID: <f997920b-4126-d256-2189-0ff6b84f6c0c@gmail.com>
Date: Tue, 26 Jul 2016 14:38:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with kernel 4.4 (Ubuntu 4.4.0-28.47-generic 4.4.13), this option setting 
in /etc/modprobe.d/*.conf seems to block proper initialization:

options dvb_usb disable_rc_polling=1

Without this option, firmware for the frontend 'm88ds3103' is loaded on 
first access (see second log below). When the above option is set, this 
initialization is missing (see first log below).

Hardware used:

# lsusb | grep TechnoTrend
Bus 003 Device 011: ID 0b48:3011 TechnoTrend AG TT-connect S2-4600

Steps to reproduce:

* Disable software accessing the tuner.
* Unplug the tuner's usb connection.
* Add options dvb_usb disable_rc_polling=1 in /etc/modprobe.d/*.conf.
* Reboot.
* Plug in the tuner's usb connection.
* Tune to a transponder (w_scan -fs -I w_scan-initial-tuning.txt)

The faulty initialization sequence is:

Jul 23 16:08:16 Hotel kernel: usb 3-9.2: new high-speed USB device 
number 11 using xhci_hcd
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: New USB device found, 
idVendor=0b48, idProduct=3011
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: Product: dvb-s2
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: Manufacturer: geniatech
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: SerialNumber: 000000000232
Jul 23 16:08:16 Hotel kernel: dw2102: su3000_identify_state
Jul 23 16:08:16 Hotel kernel: dvb-usb: found a 'TechnoTrend TT-connect 
S2-4600' in warm state.
Jul 23 16:08:16 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 0
Jul 23 16:08:16 Hotel kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Jul 23 16:08:16 Hotel kernel: DVB: registering new adapter (TechnoTrend 
TT-connect S2-4600)
Jul 23 16:08:16 Hotel kernel: dvb-usb: MAC address: bc:ea:2b:46:14:e5
Jul 23 16:08:16 Hotel kernel: i2c i2c-1: Added multiplexed i2c bus 9
Jul 23 16:08:16 Hotel kernel: ts2020 9-0060: Montage Technology TS2022 
successfully identified
Jul 23 16:08:16 Hotel kernel: usb 3-9.2: DVB: registering adapter 3 
frontend 0 (Montage Technology M88DS3103)...
Jul 23 16:08:16 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1
Jul 23 16:08:16 Hotel kernel: dvb-usb: TechnoTrend TT-connect S2-4600 
successfully initialized and connected.
Jul 23 16:08:27 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 1
Jul 23 16:08:29 Hotel kernel: dvb-usb: recv bulk message failed: -110
Jul 23 16:08:29 Hotel kernel: dw2102: i2c transfer failed.
Jul 23 16:08:29 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1
Jul 23 16:08:29 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 1
Jul 23 16:08:29 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1

Without the disable_rc_polling option, the correct initialization 
sequence is:

Jul 23 16:12:15 Hotel kernel: usb 3-9.2: new high-speed USB device 
number 11 using xhci_hcd
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: New USB device found, 
idVendor=0b48, idProduct=3011
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: Product: dvb-s2
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: Manufacturer: geniatech
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: SerialNumber: 000000000232
Jul 23 16:12:15 Hotel kernel: dw2102: su3000_identify_state
Jul 23 16:12:15 Hotel kernel: dvb-usb: found a 'TechnoTrend TT-connect 
S2-4600' in warm state.
Jul 23 16:12:15 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 0
Jul 23 16:12:15 Hotel kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Jul 23 16:12:15 Hotel kernel: DVB: registering new adapter (TechnoTrend 
TT-connect S2-4600)
Jul 23 16:12:15 Hotel kernel: dvb-usb: MAC address: bc:ea:2b:46:14:e5
Jul 23 16:12:15 Hotel kernel: i2c i2c-3: Added multiplexed i2c bus 9
Jul 23 16:12:15 Hotel kernel: ts2020 9-0060: Montage Technology TS2022 
successfully identified
Jul 23 16:12:15 Hotel kernel: usb 3-9.2: DVB: registering adapter 3 
frontend 0 (Montage Technology M88DS3103)...
Jul 23 16:12:15 Hotel kernel: Registered IR keymap rc-tt-1500
Jul 23 16:12:15 Hotel kernel: input: IR-receiver inside an USB DVB 
receiver as /devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.2/rc/rc1/input8
Jul 23 16:12:15 Hotel kernel: rc1: IR-receiver inside an USB DVB 
receiver as /devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.2/rc/rc1
Jul 23 16:12:15 Hotel kernel: dvb-usb: schedule remote query interval to 
250 msecs.
Jul 23 16:12:15 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1
Jul 23 16:12:15 Hotel kernel: dvb-usb: TechnoTrend TT-connect S2-4600 
successfully initialized and connected.
Jul 23 16:12:17 Hotel kernel: dvb-usb: recv bulk message failed: -110
Jul 23 16:12:17 Hotel kernel: dw2102: i2c transfer failed.
Jul 23 16:12:24 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 1
Jul 23 16:12:24 Hotel kernel: m88ds3103 3-0068: found a 'Montage 
Technology M88DS3103' in cold state
Jul 23 16:12:24 Hotel kernel: m88ds3103 3-0068: downloading firmware 
from file 'dvb-demod-m88ds3103.fw'
Jul 23 16:12:25 Hotel kernel: m88ds3103 3-0068: found a 'Montage 
Technology M88DS3103' in warm state
Jul 23 16:12:25 Hotel kernel: m88ds3103 3-0068: firmware version: 3.B
Jul 23 16:12:25 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1
Jul 23 16:12:25 Hotel kernel: dw2102: su3000_power_ctrl: 1, initialized 1
Jul 23 16:12:30 Hotel kernel: dw2102: su3000_power_ctrl: 0, initialized 1

Best regards,

Oliver
