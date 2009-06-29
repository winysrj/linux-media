Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51706 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZF2Tg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 15:36:56 -0400
Received: by bwz9 with SMTP id 9so3477552bwz.37
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2009 12:36:58 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 21:36:57 +0200
Message-ID: <46b649e60906291236y6cb6d719x1d627b8168fadaa4@mail.gmail.com>
Subject: Gigabyte U7000 remote control problems, driver dvb_usb_dib0700
From: Miha Furlan <miha@furlan.biz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I own Gigabyte U7000 DVB-T receiver with integrated remote IR
receiver. Receiver is working but I have problems with IR receiver.

Dmesg reports:


[15276.779498] usb 5-3: new high speed USB device using ehci_hcd and address 8
[15276.913366] usb 5-3: configuration #1 chosen from 1 choice
[15276.913592] usb 5-3: New USB device found, idVendor=1044, idProduct=7001
[15276.913596] usb 5-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[15276.913598] usb 5-3: Product: U7000
[15276.913599] usb 5-3: Manufacturer: GIGABYTE
[15276.913601] usb 5-3: SerialNumber: 000000000000001
[15277.065012] dib0700: loaded with support for 9 different device-types
[15277.068972] dvb-usb: found a 'Gigabyte U7000' in cold state, will
try to load a firmware
[15277.068972] firmware: requesting dvb-usb-dib0700-1.20.fw
[15277.080974] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[15277.290166] dib0700: firmware started successfully.
[15277.801546] dvb-usb: found a 'Gigabyte U7000' in warm state.
[15277.801583] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[15277.801803] DVB: registering new adapter (Gigabyte U7000)
[15278.160819] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[15278.164724] MT2060: successfully identified (IF1 = 1220)
[15278.658557] input: IR-receiver inside an USB DVB receiver as
/class/input/input15
[15278.673297] dvb-usb: schedule remote query interval to 50 msecs.
[15278.673302] dvb-usb: Gigabyte U7000 successfully initialized and connected.
[15278.673491] usbcore: registered new interface driver dvb_usb_dib0700

When I press key on remote:

[15089.153588] dib0700: Unknown remote controller key:  D 78  1  0

By the way, I use firmware version 1.1 because there are problems with
v. 1.2 (keys are simply not detected, even if I use
force_lna_activation=1).

In source code of module dvb_usb_dib0700 I can see that my remote
control is not supported. Supported remotes have hardcoded key maping.

I could manually add keymap to driver, but I would like to do mapping
in userspace with LIRC. I have seen a lot of howto's telling me to use
proper /dev/input/event? socket but driver only sends resolved keys to
it. If remote controller key is not recognized I only get "Unknown
remote key.." line in kernel log, /dev/input/eventX stays silent.

What should I do to get key codes directly to /dev/input/eventX socket
without mapping them in dvb_usb_dib0700? Or is there any other way to
make remote controller work?

Thanks and best regards,
Miha Furlan
