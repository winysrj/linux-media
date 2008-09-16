Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tuc.ic3s.de ([80.146.164.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@ic3s.de>) id 1Kfa25-0007E6-QE
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 14:51:55 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by tuc.ic3s.de (Postfix) with ESMTP id 0C24014401F
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 14:51:49 +0200 (CEST)
Received: from tuc.ic3s.de ([127.0.0.1])
	by localhost (tuc.ic3s.de [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 13474-07 for <linux-dvb@linuxtv.org>;
	Tue, 16 Sep 2008 14:51:36 +0200 (CEST)
Received: from [172.17.33.64] (thomasws2.dhcp.ic3s.de [172.17.33.64])
	by tuc.ic3s.de (Postfix) with ESMTP id EA53D14401E
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 14:51:35 +0200 (CEST)
Message-ID: <48CFABD7.8000202@ic3s.de>
Date: Tue, 16 Sep 2008 14:51:35 +0200
From: Thomas <thomas@ic3s.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problems compiling af9015 on fedora 9
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

Hi List,

i get this error:

#make

....
  CC [M]  /root/af9015/v4l/pluto2.o
  LD [M]  /root/af9015/v4l/sms1xxx.o
  LD [M]  /root/af9015/v4l/snd-bt87x.o
  LD [M]  /root/af9015/v4l/snd-tea575x-tuner.o
  Building modules, stage 2.
  MODPOST 273 modules
WARNING: "__udivdi3" [/root/af9015/v4l/af9013.ko] undefined!
  CC      /root/af9015/v4l/adv7170.mod.o
  LD [M]  /root/af9015/v4l/adv7170.ko
  CC      /root/af9015/v4l/adv7175.mod.o
  LD [M]  /root/af9015/v4l/adv7175.ko
.....


after connecting the device i have no frontend :(

kernel: dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
kernel: usb 2-5: USB disconnect, address 3
kernel: dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
kernel: usb 2-5: new high speed USB device using ehci_hcd and address 4
kernel: usb 2-5: configuration #1 chosen from 1 choice
kernel: input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.1/input/input10
kernel: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-5
kernel: usb 2-5: New USB device found, idVendor=15a4, idProduct=9016
kernel: usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
kernel: usb 2-5: Product: DVB-T 2
kernel: usb 2-5: Manufacturer: Afatech
kernel: usb 2-5: SerialNumber: 010101010600001
kernel: dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
kernel: af9013: Unknown symbol __udivdi3
modprobe: FATAL: Error inserting af9013 (/lib/modules/2.6.25.14-108.fc9.i686/kernel/drivers/media/dvb/frontends/af9013.ko): Unknown symbol in module, or unknown parameter (see dmesg)
kernel: DVB: Unable to find symbol af9013_attach()
kernel: dvb-usb: no frontend was attached by 'Afatech AF9015 DVB-T USB2.0 stick'
kernel: dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_af9015


can someone explain whats going wrong?



Best Regards

Thomas


-- 
[:O]###[O:]



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
