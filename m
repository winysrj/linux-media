Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f205.google.com ([209.85.219.205])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miha@furlan.biz>) id 1MLanZ-0000ud-4X
	for linux-dvb@linuxtv.org; Tue, 30 Jun 2009 12:42:49 +0200
Received: by ewy1 with SMTP id 1so45776ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Jun 2009 03:42:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Jun 2009 12:42:15 +0200
Message-ID: <46b649e60906300342n59551282g79f602fceebdd4bf@mail.gmail.com>
From: Miha Furlan <miha@furlan.biz>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dib0700 questions (Gigabyte U7000 integrated IR
	receiver problems)
Reply-To: linux-media@vger.kernel.org
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

[15089.153588] dib0700: Unknown remote controller key:  D 78  1  0

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
