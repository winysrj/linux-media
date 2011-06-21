Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46173 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1FUChD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 22:37:03 -0400
Received: by yxi11 with SMTP id 11so2341298yxi.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 19:37:02 -0700 (PDT)
Message-ID: <4E0003C9.7030508@gmail.com>
Date: Mon, 20 Jun 2011 23:36:57 -0300
From: Antonio Carlos Ribeiro Nogueira <nogueira13@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: KAIOMY ISDB-T Hybrid USB Dongle Receiver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I bought a KAIOMY ISDB-T Hybrid USB Dongle Receiver to use with my Dell 
Inspiron 15 Laptop under Ubuntu 11.04 Linux. But I connect it in the USB 
port and it doesn't recognises it. The kernel version I am using is the 
2.6.38-8-generic. I opened the menuconfig of the kernel and I could saw 
that all modules in the especific section "Device Drivers --> Multimedia 
support --> DVB/ATSC Adapters" are all set to <M>. I was thinking that 
the driver v2l already was buit in this modules. But when I connected 
the device in the USB port I got the following autputs to the lsusb and 
dmesg commands in the console:

Without the device connected

nogueira@nogueira-Inspiron-1545:~$ lsusb
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub 
(part of BCM2046 Bluetooth)
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 0c45:63ee Microdia
Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0 
multicard reader
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
nogueira@nogueira-Inspiron-1545:~$


With the device connected

nogueira@nogueira-Inspiron-1545:~$ lsusb
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub 
(part of BCM2046 Bluetooth)
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 014: ID 1554:5019 Prolink Microsystems Corp.
Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 0c45:63ee Microdia
Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0 
multicard reader
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
nogueira@nogueira-Inspiron-1545:~$

I guess that the device pointed is Device 014, Prolink Microsystems Corp.

Here the output of the last lines of "dmesg":

[21677.320057] usb0: no IPv6 routers present
[24094.384020] input: Navigator 905BT Mouse as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.3/3-1.3:1.0/bluetooth/hci0/hci0:12/input15
[24094.384377] generic-bluetooth 0005:0458:00A7.0005: input,hidraw1: 
BLUETOOTH HID v1.00 Mouse [Navigator 905BT Mouse] on 00:26:5E:E0:61:18
[24622.528358] usb 2-3: USB disconnect, address 11
[24622.528559] rndis_host 2-3:1.0: usb0: unregister 'rndis_host' 
usb-0000:00:1d.7-3, RNDIS device
[24622.970104] usb 2-3: new high speed USB device using ehci_hcd and 
address 12
[24623.125469] scsi14 : usb-storage 2-3:1.0
[24624.121792] scsi 14:0:0:0: Direct-Access     SAMSUNG  GT-I5500 Card 
   0000 PQ: 0 ANSI: 2
[24624.123433] sd 14:0:0:0: Attached scsi generic sg4 type 0
[24624.128097] sd 14:0:0:0: [sdd] Attached SCSI removable disk
[24633.138586] usb 2-3: USB disconnect, address 12
[24649.596828] wlan0: authenticate with 00:1a:3f:4b:50:8b (try 1)
[24649.599160] wlan0: authenticated
[24649.599226] wlan0: associate with 00:1a:3f:4b:50:8b (try 1)
[24649.602074] wlan0: RX AssocResp from 00:1a:3f:4b:50:8b (capab=0x451 
status=0 aid=4)
[24649.602082] wlan0: associated
[29210.660319] usb 2-3: new high speed USB device using ehci_hcd and 
address 13

I am not an expert in linux but I can't see anything that could indicate 
that it recognised it in dmesg. I would like if you may help me in order 
I could use this device in Linux (in windows 7 it is working properly...).
I would like you send me the routine that I must to follow (step by 
step, please because I am not an expert as I already said).
Hopping you help me I would like to tanks in advantage.

Sincerely

Antonio Carlos Ribeiro Nogueira
