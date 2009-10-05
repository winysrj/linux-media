Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60152 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751045AbZJEHwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 03:52:41 -0400
Received: from x2.grafnetz ([192.168.0.4])
	by duron.grafnetz with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <grafgrimm77@gmx.de>)
	id 1MuiMD-0004LY-R6
	for linux-media@vger.kernel.org; Mon, 05 Oct 2009 09:51:52 +0200
Date: Mon, 5 Oct 2009 09:51:44 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
To: linux-media@vger.kernel.org
Subject: dib3000mb dvb-t with kernel 2.6.32-rc3 do not work
Message-ID: <20091005095144.3551deb3@x2.grafnetz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there, 

with kernel 2.6.30.8 my "TwinhanDTV USB-Ter USB1.1 / Magic Box I"
worked. 

Now with kernel 2.6.32-rc3 (and 2.6.31.1) the modules seems to be
loaded fine, but tzap/kaffeine/mplayer can not tune to a channel:

dmesg says:
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 16).
DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device)
DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
dibusb: This device has the Thomson Cable onboard. Which is default.
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input5
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dibusb_mb

grep DVB .config says (no chaanges between 2.6.30.8 and 2.6.32-rc3):
CONFIG_DVB_CORE=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_USB=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_PLL=m

lsmod |grep dvb
dvb_usb_dibusb_mb      16715  0 
dvb_usb_dibusb_common     3559  1 dvb_usb_dibusb_mb
dvb_pll                 8604  1 dvb_usb_dibusb_mb
dib3000mb              10969  1 dvb_usb_dibusb_mb
dvb_usb                13737  2 dvb_usb_dibusb_mb,dvb_usb_dibusb_common
dvb_core               85727  1 dvb_usb

tzap arte -r
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/grafrotz/.tzap/channels.conf'
tuning to 602000000 Hz
video pid 0x00c9, audio pid 0x00ca
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 00b2 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 

and so on. The signal-values are zero or near zero, but when i boot the old kernel 2.6.30.8, t can tune without problems. 

kaffeine DVB says:
Using DVB device 0:0 "DiBcom 3000M-B DVB-T"
tuning DVB-T to 602000000 Hz
inv:2 bw:0 fecH:2 fecL:9 mod:1 tm:1 gi:3 hier:0
................

Not able to lock to the signal on the given frequency
Frontend closed
Tuning delay: 2611 ms

mplayer dvb://arte   says:
MPlayer SVN-r29699-4.4.1 (C) 2000-2009 MPlayer Team

Spiele dvb://arte.
dvb_tune Freq: 602000000
Not able to lock to the signal on the given frequency, timeout: 30
dvb_tune, TUNING FAILED
ERROR, COULDN'T SET CHANNEL  13: Konnte 'dvb://arte' nicht öffnen.


Beenden... (Dateiende erreicht)


Greetings
Mario
