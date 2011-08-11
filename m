Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55260 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1HKL3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 07:29:20 -0400
Received: by pzk37 with SMTP id 37so3523952pzk.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2011 04:29:19 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Aug 2011 13:29:19 +0200
Message-ID: <CAL9G6WXnXJwfCZY5gZ8Qph_RuP29PVDCeYT037-e=T9fCo3PVg@mail.gmail.com>
Subject: Problems with Tevii S660
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list, I just bought a Tevii S660 DVB-S2 USb tunner and I have
some problems with it. I already has the Tevii S470 card and it works
great with this configuration:

mkdir /usr/local/src/dvb
cd /usr/local/src/dvb
wget http://tevii.com/100315_Beta_linux_tevii_ds3000.rar
unrar x 100315_Beta_linux_tevii_ds3000.rar
cp *.fw /lib/firmware
tar xjvf linux-tevii-ds3000.tar.bz2
cd linux-tevii-ds3000
make && make install

I am using Debian Squeeze with stable kernel: 2.6.32-5-686

I configured the modprobe this way:

# cat /etc/modprobe.d/options.conf
#Tevii S470
options cx23885 adapter_nr=7
#Tevii S660
options dvb-usb-dw2102 adapter_nr=6
#Disable the IR
options dvb-usb disable_rc_polling=1

At first time it works well, I just pluged it and it creates a dvb
device on /dev/dvb/adapter6 and the dmesg is correct (I have not a
copy of the message). I didn't try yet to watch any channel (I am
uusing MythTV).

I reboot the machine and there are some USB error on the boot
secuence, something like this:

... device descriptor read/64, error -110

(Here is a photo of the screen: http://i53.tinypic.com/2u3z5s0.jpg)

After a long boot, I execute the dmesg and this is what I get:

[  145.909045] usb 4-2: device descriptor read/64, error -110
[  146.189073] usb 4-2: new full speed USB device using ohci_hcd and address 5
[  151.208761] usb 4-2: device descriptor read/8, error -110
[  156.329684] usb 4-2: device descriptor read/8, error -110
[  156.612043] usb 4-2: new full speed USB device using ohci_hcd and address 6
[  161.636610] usb 4-2: device descriptor read/8, error -110
[  166.756544] usb 4-2: device descriptor read/8, error -110
[  166.864081] hub 4-0:1.0: unable to enumerate USB device on port 2

And there is no device on lsusb.

Then I try to boot without the device, it start well the machine, then
plug the device and this is the dmesg:

[  162.372030] usb 1-2: new high speed USB device using ehci_hcd and address 2
[  177.484038] usb 1-2: device descriptor read/64, error -110
[  192.700039] usb 1-2: device descriptor read/64, error -110
[  192.920036] usb 1-2: new high speed USB device using ehci_hcd and address 3
[  208.028034] usb 1-2: device descriptor read/64, error -110
[  223.252028] usb 1-2: device descriptor read/64, error -110
[  223.465028] usb 1-2: new high speed USB device using ehci_hcd and address 4
[  228.484176] usb 1-2: device descriptor read/8, error -110
[  233.604097] usb 1-2: device descriptor read/8, error -110
[  233.820029] usb 1-2: new high speed USB device using ehci_hcd and address 5
[  238.840170] usb 1-2: device descriptor read/8, error -110
[  243.961092] usb 1-2: device descriptor read/8, error -110
[  244.064050] hub 1-0:1.0: unable to enumerate USB device on port 2
[  244.392034] usb 3-2: new full speed USB device using ohci_hcd and address 2
[  259.568033] usb 3-2: device descriptor read/64, error -110
[  274.848036] usb 3-2: device descriptor read/64, error -110
[  275.128035] usb 3-2: new full speed USB device using ohci_hcd and address 3

I contact with Tevii, but there is no support for this device on
Linux, they point me to go to
http://mercurial.intuxication.org/hg/s2-liplianin/

I read some users having same problem with this device, here is one
that resolve it uploading I new firmware on each boot:
http://www.gilzad.de/blog/pivot/entry.php?id=7

Can you help with this?

I am not an expert on kernel/driver/firmware, I will apreciate any help.

Thanks for your help and best regards.


-- 
Josu Lazkano
