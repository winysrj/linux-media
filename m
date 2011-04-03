Return-path: <mchehab@pedra>
Received: from blu0-omc2-s11.blu0.hotmail.com ([65.55.111.86]:14936 "EHLO
	blu0-omc2-s11.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab1DCSPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2011 14:15:48 -0400
Message-ID: <BLU0-SMTP19940292858BBA657A1973DD8A00@phx.gbl>
To: linux-media@vger.kernel.org
Subject: dibusb device with lock problems
CC: pb@linuxtv.org, grafgrimm77@gmx.de, castet.matthieu@free.fr
From: Mr Tux <tuxoholic@hotmail.de>
Date: Sun, 3 Apr 2011 20:15:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hello Patrick,

On Sunday 03 April 2011 17:37:00 Patrick Boettcher wrote:

>
>I think this line is not normal in your case:
>
> dibusb: This device has the Thomson Cable onboard. Which is default.
>

Here's the output of dmesg in Lenny (kernel 2.6.26-1) where the tuning was 
fine:

usb 2-1: new full speed USB device using ohci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=1822, idProduct=3201
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T 
device' in cold state, will try to load a firmware
firmware: requesting dvb-usb-dibusb-5.0.0.11.fw
dvb-usb: downloading firmware from file 'dvb-usb-dibusb-5.0.0.11.fw'
usbcore: registered new interface driver dvb_usb_dibusb_mb
usb 2-1: USB disconnect, address 3
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 2-1: new full speed USB device using ohci_hcd and address 4
usb 2-1: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T 
device' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 16).
DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA 
USB1.1 DVB-T device)
DVB: registering frontend 0 (DiBcom 3000M-B DVB-T)...
dibusb: This device has the Thomson Cable onboard. Which is default.
input: IR-receiver inside an USB DVB receiver as /class/input/input5
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device 
successfully initialized and connected.                    
usb 2-1: New USB device found, idVendor=1822, idProduct=3202                                                                           
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0                                                                      
usb 2-1: Product: VP7041                                                                                                               
usb 2-1: Manufacturer: TwinHan


The Thomson line was there, nevertheless the locking was fine back then:

1st consecutive test run using tzap:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 690000000 Hz
video pid 0x00a0, audio pid 0x0050
status 00 | signal 1d37 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 1a | signal 2161 | snr 0046 | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 0044 | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 0046 | ber 00008a18 | unc 00000038 | FE_HAS_LOCK
status 1b | signal ffff | snr 004b | ber 00004d60 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 003a | ber 00003ee4 | unc 00000000 | FE_HAS_LOCK

2nd consecutive test run using tzap:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 690000000 Hz
video pid 0x00a0, audio pid 0x0050
status 02 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 1a | signal 9bd0 | snr 0043 | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 0040 | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal f4dd | snr 0044 | ber 00008754 | unc 0000002e | FE_HAS_LOCK
status 1b | signal ffff | snr 0042 | ber 000094a4 | unc 00000000 | FE_HAS_LOCK
status 1b | signal ffff | snr 003a | ber 000187e8 | unc 00000000 | FE_HAS_LOCK

3rd consecutive test run using tzap:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 690000000 Hz
video pid 0x00a0, audio pid 0x0050
status 1e | signal 858e | snr 0058 | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 004c | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 0042 | ber 00005b18 | unc 0000000c | FE_HAS_LOCK
status 1b | signal ffff | snr 0044 | ber 0000697c | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 004e | ber 00005f20 | unc 00000000 | FE_HAS_LOCK
status 1b | signal ffff | snr 0055 | ber 00005f20 | unc 00000000 | FE_HAS_LOCK
status 1b | signal ffff | snr 0037 | ber 00005400 | unc 00000000 | FE_HAS_LOCK


So even with a poorly aligned antenna I get some BER, but I always have the 
instant lock as expected.

This changed with with the eeprom protection you introduced in 2.6.31, and the 
patch for Mario Bachmann never fixed it for my dib3000mb device.
