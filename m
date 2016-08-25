Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59935 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbcHYSiN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 14:38:13 -0400
Received: from [192.168.178.24] ([78.54.132.120]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LzoSt-1b7WSq43nf-014xkK for
 <linux-media@vger.kernel.org>; Thu, 25 Aug 2016 20:31:36 +0200
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: DVB: Unable to find symbol dib7000p_attach()
Message-ID: <fcfb7b2b-bd98-d847-8f07-ef3d018f5c19@gmx.de>
Date: Thu, 25 Aug 2016 20:31:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whilst kernel 4.6.5 is fine, kernel 4.7.x gives at a hardened Gentoo Linux:

...

Aug 25 20:28:24 t44 kernel: usb 1-3.1: USB disconnect, device number 4
Aug 25 20:28:24 t44 acpid[1084]: input device has been disconnected, fd 10
Aug 25 20:28:24 t44 kernel: dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully deinitialized and disconnected.
Aug 25 20:28:26 t44 kernel: usb 1-3.1: new high-speed USB device number 10 using xhci_hcd
Aug 25 20:28:27 t44 kernel: usb 1-3.1: New USB device found, idVendor=0ccd, idProduct=00ab
Aug 25 20:28:27 t44 kernel: usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug 25 20:28:27 t44 kernel: usb 1-3.1: Product: Cinergy T XXS
Aug 25 20:28:27 t44 kernel: usb 1-3.1: Manufacturer: TerraTec GmbH
Aug 25 20:28:27 t44 kernel: usb 1-3.1: SerialNumber: 0000000001
Aug 25 20:28:27 t44 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
Aug 25 20:28:27 t44 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
Aug 25 20:28:27 t44 kernel: dib0700: firmware started successfully.
Aug 25 20:28:27 t44 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in warm state.
Aug 25 20:28:27 t44 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Aug 25 20:28:27 t44 kernel: DVB: registering new adapter (Terratec Cinergy T USB XXS (HD)/ T3)
Aug 25 20:28:27 t44 kernel: DVB: Unable to find symbol dib7000p_attach()
Aug 25 20:28:27 t44 kernel: dvb-usb: no frontend was attached by 'Terratec Cinergy T USB XXS (HD)/ T3'
Aug 25 20:28:27 t44 kernel: Registered IR keymap rc-dib0700-rc5
Aug 25 20:28:27 t44 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.1/rc/rc0/input18
Aug 25 20:28:27 t44 kernel: rc rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.1/rc/rc0
Aug 25 20:28:27 t44 kernel: dvb-usb: schedule remote query interval to 50 msecs.
Aug 25 20:28:27 t44 kernel: dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully initialized and connected.

and Kaffeine / smplayer / name it as you want tells me , that no device is available.

-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
