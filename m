Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0KJAGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 19:06:50 -0500
Received: by wyb36 with SMTP id 36so58692wyb.19
        for <linux-media@vger.kernel.org>; Tue, 09 Nov 2010 16:06:48 -0800 (PST)
Message-ID: <4CD9E212.1070707@gmail.com>
Date: Wed, 10 Nov 2010 01:06:42 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "jackc@RT" <jackc@realtek.com>
Subject: RTL2832U-FC0012 & AF9015-MXL5007T
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


RTL2832U-FC0012 & AF9015-MXL5007T

Setup for DVB-T devices,
Realtek RTL2832U / Fitipower FC0012 & Afatech AF9015 / MaxLinear 
MXL5007T dual tuner
on Fedora 14-x86_64 with new experimental building system.

lsusb:
Bus 002 Device 002: ID 1f4d:b803 G-Tek Electronics Group Lifeview 
LV5TDLX DVB-T [RTL2832U]
Bus 001 Device 002: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T 
USB2.0 stick

uname:
2.6.35.6-48.fc14.x86_64

modinfo:
modinfo dvb_usb_rtl2832u:
filename: 
/lib/modules/2.6.35.6-48.fc14.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2832u.ko
license:        GPL
version:        2.0.1
description:    Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device
author:         Realtek
srcversion:     BABFD424CE8A0E806A95C01
alias:          usb:v1554p5020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1554p5013d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpA803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1104d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2834d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2839d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2836d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4Dp0837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD398d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD397d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3282d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3234d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1164p6601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1680pA332d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1103d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1102d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD396d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3274d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2832d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb
vermagic:       2.6.35.6-48.fc14.x86_64 SMP mod_unload
parm:           debug:Set debugging level (1=info,xfer=2 (or-able)). (int)
parm:           demod:Set default demod type(0=dvb-t, 1=dtmb, 2=dvb-c) (int)
parm:           dtmb_err_discard:Set error packet discard type(0=not 
discard, 1=discard) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

modinfo dvb_usb_af9015:
filename: 
/lib/modules/2.6.35.6-48.fc14.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-af9015.ko
license:        GPL
description:    Driver for Afatech AF9015 DVB-T
author:         Antti Palosaari <crope@iki.fi>
srcversion:     0F2842A63411F6AF9DD4B5B
alias:          usb:v1F4Dp9016d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CAp850Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0099d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0097d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CAp815Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE39Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE383d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6A04d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE402d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE39Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pC161d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE400d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0458p4012d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pC810d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE397d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CApA805d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CAp850Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A4p901Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE395d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE39Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE396d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1462p8807d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CApA309d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v10B9p8000d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CAp8150d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1462p8801d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1AE7p0381d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07CApA815d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pC160d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0069d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3237d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3226d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE399d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p022Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6029d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A4p9016d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A4p9015d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb,i2c-core,ir-core
vermagic:       2.6.35.6-48.fc14.x86_64 SMP mod_unload
parm:           debug:set debugging level (int)
parm:           remote:select remote (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

modprobe:
/etc/modprobe.d/dvb-core.conf:
options dvb-core dvb_powerdown_on_sleep=0

firmware:
/lib/firmware/dvb-usb-af9015.fw
http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw

dmesg:
...
[    0.961014] usb 1-1: new high speed USB device using ehci_hcd and 
address 2
[    1.082169] usb 1-1: New USB device found, idVendor=15a4, idProduct=9016
[    1.082787] usb 1-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    1.083400] usb 1-1: Product: DVB-T 2
[    1.083985] usb 1-1: Manufacturer: Afatech
[    1.084587] usb 1-1: SerialNumber: 010101010600001
[    1.088591] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 
10 -> 7
[    1.089491] input: Afatech DVB-T 2 as 
/devices/pci0000:00/0000:00:02.1/usb1/1-1/1-1:1.1/input/input3
[    1.090813] generic-usb 0003:15A4:9016.0001: input,hidraw0: USB HID 
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-1/input1
[    1.194016] usb 2-1: new high speed USB device using ehci_hcd and 
address 2
[    1.323734] usb 2-1: New USB device found, idVendor=1f4d, idProduct=b803
[    1.324409] usb 2-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    1.325082] usb 2-1: Product: RTL2838UHIDIR
[    1.325753] usb 2-1: Manufacturer: Realtek
[    1.326423] usb 2-1: SerialNumber: 00000041
...
[    8.527552] dvb-usb: found a 'USB DVB-T Device' in warm state.
[    8.528398] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[    8.531397] DVB: registering new adapter (USB DVB-T Device)
...
[    8.851547] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in 
warm state.
[    8.852992] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[    8.854378] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 
stick)
...
[    9.035546] af9013: firmware version:5.1.0.0
[    9.039549] DVB: registering adapter 1 frontend 0 (Afatech AF9013 
DVB-T)...
[    9.076782] TUNER: Unable to find symbol tda829x_probe()
...
[    9.105210] mxl5007t 3-00c0: creating new instance
[    9.107871] tda9887 2-0043: creating new instance
[    9.108692] tda9887 2-0043: tda988[5/6/7] found
[    9.111301] mxl5007t_get_chip_id: unknown rev (03)
[    9.112103] mxl5007t_get_chip_id: MxL5007T detected @ 3-00c0
[    9.113423] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
...
[    9.115752] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 
stick)
...
[    9.329049] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[    9.333297] af9013: firmware version:5.1.0.0
[    9.345553] DVB: registering adapter 2 frontend 0 (Afatech AF9013 
DVB-T)...
[    9.347950] mxl5007t 4-00c0: creating new instance
[    9.351297] mxl5007t_get_chip_id: unknown rev (03)
[    9.352133] mxl5007t_get_chip_id: MxL5007T detected @ 4-00c0
[    9.354554] Registered IR keymap rc-empty
[    9.356713] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0/input5
[    9.358793] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0
[    9.360440] dvb-usb: schedule remote query interval to 500 msecs.
[    9.361265] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
initialized and connected.
[    9.377583] usbcore: registered new interface driver dvb_usb_af9015
[    9.443495] DVB: registering adapter 0 frontend 0 (Realtek DVB-T 
RTL2832)...
[    9.445656] dvb-usb: USB DVB-T Device successfully initialized and 
connected.
[    9.446541] dvb-usb: found a 'USB DVB-T Device' in warm state.
[    9.447393] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[    9.449903] DVB: registering new adapter (USB DVB-T Device)
...
[   11.230206] DVB: registering adapter 3 frontend 0 (Realtek DVB-T 
RTL2832)...
[   11.232715] dvb-usb: USB DVB-T Device successfully initialized and 
connected.
[   11.234150] usbcore: registered new interface driver dvb_usb_rtl2832u
...

femon -H -a0
FE: Realtek DVB-T RTL2832 (DVBT)
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
status SCVYL | signal  21% | snr   0% | ber 0 | unc 100 | FE_HAS_LOCK
^C

setup:
mkdir /tmp/dvbt
cd /tmp/dvbt
git clone git://linuxtv.org/mchehab/new_build.git
cd new_build/
wget http://goo.gl/CnJJu -O rtl2832u_v2.0.1-new_build-set.tar.gz
tar -xf rtl2832u_v2.0.1-new_build-set.tar.gz
./build-rtl2832u.sh

sha1sum:
c023031f3cc2cc22a1f40dc5d9fa64968af7307e  rtl2832u_v2.0.1.tar.gz
3aca8850fe118473f25b034239b3bf5648d4a08e 
rtl2832u_v2.0.1-new_build-set.tar.gz


All credit goes to Realtek, Antti Palosaari, Afatech and V4L/DVB developers.

Thank you for you efforts so far!

Kind regards,
poma

