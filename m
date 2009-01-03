Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <izero79@gmail.com>) id 1LJAx7-0007p8-5t
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:10:26 +0100
Received: by bwz11 with SMTP id 11so14692888bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 10:09:51 -0800 (PST)
Message-Id: <6B1623AD-5F0B-479B-9574-44B87530ECF2@gmail.com>
From: Tero Siironen <izero79@gmail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Sat, 3 Jan 2009 20:09:49 +0200
Subject: [linux-dvb] Problem in 2.6.28 kernel with dvb-usb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I compiled 2.6.28 kernel to my Fedora 9 setup yesterday and my Artec  
T14BR DVB-T USB stick stopped to work properly. It is recognized  
correctly but when the stream receiver is started I get this message:

kernel: dvb-usb: could not submit URB no. 0 - get them all back

and no sound or picture is played with vdr. This happen 9 times out of  
10. And that 1/10 time the reception is very bad. My previous kernel  
compilation is 2.6.28-rc6 and the device works just fine with that  
kernel.

Here is the snippets from dmesg and /var/log/messages:

2.6.28 kernel:

dmesg:

usb 1-5: new high speed USB device using ehci_hcd and address 8
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: New USB device found, idVendor=05d8, idProduct=810f
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: ART7070
usb 1-5: Manufacturer: Ultima
usb 1-5: SerialNumber: 001
dib0700: loaded with support for 8 different device-types
dvb-usb: found a 'Artec T14BR DVB-T' in cold state, will try to load a  
firmware
usb 1-5: firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Artec T14BR DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software  
demuxer.
DVB: registering new adapter (Artec T14BR DVB-T)
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Artec T14BR DVB-T successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver dvb_usb_dibusb_mc
dvb-usb: could not submit URB no. 0 - get them all back

/var/log/messages:

Jan  3 13:38:13 dvbsystem kernel: usbcore: registered new interface  
driver dvb_usb_dibusb_mc
Jan  3 13:38:13 dvbsystem kernel: dib0700: loaded with support for 8  
different device-types
Jan  3 13:38:13 dvbsystem kernel: dvb-usb: found a 'Artec T14BR DVB-T'  
in warm state.
Jan  3 13:38:13 dvbsystem kernel: dvb-usb: will pass the complete  
MPEG2 transport stream to the software demuxer.
Jan  3 13:38:13 dvbsystem kernel: DVB: registering new adapter (Artec  
T14BR DVB-T)
Jan  3 13:38:13 dvbsystem kernel: DVB: registering adapter 0 frontend  
0 (DiBcom 7000PC)...
Jan  3 13:38:13 dvbsystem kernel: DiB0070: successfully identified
Jan  3 13:38:13 dvbsystem kernel: dvb-usb: Artec T14BR DVB-T  
successfully initialized and connected.
Jan  3 13:38:13 dvbsystem kernel: usbcore: registered new interface  
driver dvb_usb_dib0700
Jan  3 13:38:16 dvbsystem vdr: [4204] receiver on device 1 thread  
started (pid=4172, tid=4204)
Jan  3 13:38:16 dvbsystem kernel: dvb-usb: could not submit URB no. 0  
- get them all back
Jan  3 13:38:16 dvbsystem vdr: [4205] TS buffer on device 1 thread  
started (pid=4172, tid=4205)



2.6.28-rc6 kernel:

dmesg:

usb 1-5: new high speed USB device using ehci_hcd and address 6
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: New USB device found, idVendor=05d8, idProduct=810f
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: ART7070
usb 1-5: Manufacturer: Ultima
usb 1-5: SerialNumber: 001
dib0700: loaded with support for 8 different device-types
dvb-usb: found a 'Artec T14BR DVB-T' in cold state, will try to load a  
firmware
usb 1-5: firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Artec T14BR DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software  
demuxer.
DVB: registering new adapter (Artec T14BR DVB-T)
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Artec T14BR DVB-T successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver dvb_usb_dibusb_mc


/var/log/messages:

Jan  3 13:21:04 dvbsystem kernel: usb 1-5: new high speed USB device  
using ehci_hcd and address 6
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: configuration #1 chosen  
from 1 choice
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: New USB device found,  
idVendor=05d8, idProduct=810f
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: New USB device strings:  
Mfr=1, Product=2, SerialNumber=3
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: Product: ART7070
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: Manufacturer: Ultima
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: SerialNumber: 001
Jan  3 13:21:05 dvbsystem kernel: dib0700: loaded with support for 8  
different device-types
Jan  3 13:21:05 dvbsystem kernel: dvb-usb: found a 'Artec T14BR DVB-T'  
in cold state, will try to load a firmware
Jan  3 13:21:05 dvbsystem kernel: usb 1-5: firmware: requesting dvb- 
usb-dib0700-1.20.fw
Jan  3 13:21:05 dvbsystem kernel: dvb-usb: downloading firmware from  
file 'dvb-usb-dib0700-1.20.fw'
Jan  3 13:21:05 dvbsystem kernel: dib0700: firmware started  
successfully.
Jan  3 13:21:05 dvbsystem kernel: dvb-usb: found a 'Artec T14BR DVB-T'  
in warm state.
Jan  3 13:21:05 dvbsystem kernel: dvb-usb: will pass the complete  
MPEG2 transport stream to the software demuxer.
Jan  3 13:21:05 dvbsystem kernel: DVB: registering new adapter (Artec  
T14BR DVB-T)
Jan  3 13:21:06 dvbsystem kernel: DVB: registering adapter 0 frontend  
0 (DiBcom 7000PC)...
Jan  3 13:21:06 dvbsystem kernel: DiB0070: successfully identified
Jan  3 13:21:06 dvbsystem kernel: dvb-usb: Artec T14BR DVB-T  
successfully initialized and connected.
Jan  3 13:21:06 dvbsystem kernel: usbcore: registered new interface  
driver dvb_usb_dib0700

Jan  3 13:22:38 dvbsystem kernel: usbcore: registered new interface  
driver dvb_usb_dibusb_mc

Jan  3 13:22:41 dvbsystem vdr: [3021] receiver on device 1 thread  
started (pid=2990, tid=3021)
Jan  3 13:22:41 dvbsystem vdr: [3022] TS buffer on device 1 thread  
started (pid=2990, tid=3022)


-- 
Tero

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
