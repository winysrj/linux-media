Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33527 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752797Ab1FCP5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 11:57:54 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: since kernel 2.6.39.1 : "kernel: dib0700: tx buffer length is larger than 4. Not supported"
Date: Fri, 3 Jun 2011 17:57:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031757.49440.toralf.foerster@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I get that message with the new kernel for this card :

2011-06-03T17:29:43.861+02:00 n22 kernel: usb 1-1: new high speed USB device number 10 using ehci_hcd
2011-06-03T17:29:43.975+02:00 n22 kernel: usb 1-1: New USB device found, idVendor=0ccd, idProduct=00ab
2011-06-03T17:29:43.975+02:00 n22 kernel: usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
2011-06-03T17:29:43.975+02:00 n22 kernel: usb 1-1: Product: Cinergy T XXS
2011-06-03T17:29:43.975+02:00 n22 kernel: usb 1-1: Manufacturer: TerraTec GmbH
2011-06-03T17:29:43.975+02:00 n22 kernel: usb 1-1: SerialNumber: 0000000001
2011-06-03T17:29:43.975+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
2011-06-03T17:29:44.028+02:00 n22 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
2011-06-03T17:29:44.230+02:00 n22 kernel: dib0700: firmware started successfully.
2011-06-03T17:29:44.731+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in warm state.
2011-06-03T17:29:44.731+02:00 n22 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
2011-06-03T17:29:44.731+02:00 n22 kernel: DVB: registering new adapter (Terratec Cinergy T USB XXS (HD)/ T3)
2011-06-03T17:29:44.922+02:00 n22 kernel: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
2011-06-03T17:29:45.121+02:00 n22 kernel: DiB0070: successfully identified
2011-06-03T17:29:45.121+02:00 n22 kernel: Registered IR keymap rc-dib0700-rc5
2011-06-03T17:29:45.122+02:00 n22 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc2/input16
2011-06-03T17:29:45.122+02:00 n22 kernel: rc2: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc2
2011-06-03T17:29:45.122+02:00 n22 kernel: dvb-usb: schedule remote query interval to 50 msecs.
2011-06-03T17:29:45.122+02:00 n22 kernel: dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully initialized and connected.
2011-06-03T17:29:53.878+02:00 n22 kernel: dib0700: tx buffer length is larger than 4. Not supported.


and wonders whether this is harmless or harmfull ...

TIA

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
