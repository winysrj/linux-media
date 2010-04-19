Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:41006 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0DSGe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 02:34:57 -0400
Received: by ywh32 with SMTP id 32so2571820ywh.33
        for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 23:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <u2wc58d1d9d1004171056t879761f9n5acb957d5bfa9a4@mail.gmail.com>
References: <u2wc58d1d9d1004171056t879761f9n5acb957d5bfa9a4@mail.gmail.com>
Date: Mon, 19 Apr 2010 14:34:56 +0800
Message-ID: <u2qc58d1d9d1004182334k912a9d90vb4c5c6a370f87b2d@mail.gmail.com>
Subject: Problem in USB DVB devices: dvb-usb: recv bulk message failed: -110
From: Halu Wong <waichai@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I got a Mygica D689 which already have driver in v4l-dvb.
But i can only get it work in VM (VMware player) but not in a real machine.
Both using the same distribution/kernel/v4l-dvb etc.
- Fedora 11 (32 bits)
- Standard installation with the default kernel: 2.6.29.4-167.fc11.i686.PAE
- with development tools/libraries installed
download the latest v4l-dvb
#hg clone http://www.linuxtv.org/hg/v4l-dvb
#cd v4l-dvb
#make
- remove all the things in
"/lib/modules/2.6.29.4-167.fc11.i686.PAE/kernel/drivers/media"
# make install
plug the Mygica D689,
message in real machine:
Apr 18 09:23:06 localhost kernel: usb 1-7: new high speed USB device
using ehci_hcd and address 3
Apr 18 09:23:06 localhost kernel: usb 1-7: New USB device found,
idVendor=0572, idProduct=d811
Apr 18 09:23:06 localhost kernel: usb 1-7: New USB device strings:
Mfr=1, Product=2, SerialNumber=3
Apr 18 09:23:06 localhost kernel: usb 1-7: Product: USB Stick
Apr 18 09:23:06 localhost kernel: usb 1-7: Manufacturer: Geniatech
Apr 18 09:23:06 localhost kernel: usb 1-7: SerialNumber: 080116
Apr 18 09:23:06 localhost kernel: usb 1-7: configuration #1 chosen from 1 choice
Apr 18 09:23:06 localhost kernel: dvb-usb: found a 'Mygica D689
DMB-TH' in warm state.
Apr 18 09:23:06 localhost kernel: dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Apr 18 09:23:06 localhost kernel: DVB: registering new adapter (Mygica
D689 DMB-TH)
Apr 18 09:23:07 localhost kernel: DVB: registering adapter 0 frontend
0 (AltoBeam ATBM8830/8831 DMB-TH)...
Apr 18 09:23:07 localhost kernel: input: IR-receiver inside an USB DVB
receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/input/input6
Apr 18 09:23:07 localhost kernel: dvb-usb: schedule remote query
interval to 100 msecs.
Apr 18 09:23:07 localhost kernel: dvb-usb: Mygica D689 DMB-TH
successfully initialized and connected.
Apr 18 09:23:07 localhost kernel: usbcore: registered new interface
driver dvb_usb_cxusb
Apr 18 09:23:09 localhost kernel: dvb-usb: recv bulk message failed: -110
message in VM:
Apr 18 09:51:51 f11vm kernel: usb 1-1: new high speed USB device using
ehci_hcd and address 2
Apr 18 09:51:51 f11vm kernel: usb 1-1: New USB device found,
idVendor=0572, idProduct=d811
Apr 18 09:51:51 f11vm kernel: usb 1-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Apr 18 09:51:51 f11vm kernel: usb 1-1: Product: USB Stick
Apr 18 09:51:51 f11vm kernel: usb 1-1: Manufacturer: Geniatech
Apr 18 09:51:51 f11vm kernel: usb 1-1: SerialNumber: 080116
Apr 18 09:51:52 f11vm kernel: usb 1-1: configuration #1 chosen from 1 choice
Apr 18 09:51:52 f11vm kernel: dvb-usb: found a 'Mygica D689 DMB-TH' in
warm state.
Apr 18 09:51:52 f11vm kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Apr 18 09:51:52 f11vm kernel: DVB: registering new adapter (Mygica D689 DMB-TH)
Apr 18 09:51:53 f11vm kernel: DVB: registering adapter 0 frontend 0
(AltoBeam ATBM8830/8831 DMB-TH)...
Apr 18 09:51:54 f11vm kernel: input: IR-receiver inside an USB DVB
receiver as /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/input/input5
Apr 18 09:51:54 f11vm kernel: dvb-usb: schedule remote query interval
to 100 msecs.
Apr 18 09:51:54 f11vm kernel: dvb-usb: Mygica D689 DMB-TH successfully
initialized and connected.
Apr 18 09:51:54 f11vm kernel: usbcore: registered new interface driver
dvb_usb_cxusb
i can do w_scan with 11 services in VM but not ZERO in real machine!!
Did the following log message imply sth!?!?
Apr 18 09:23:09 localhost kernel: dvb-usb: recv bulk message failed: -110
I have tried to install in another real machine but also with the same result!
Can anyone give me a hint on how to check/solve this issue!!

Thanks,
Halu Wong
