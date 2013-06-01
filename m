Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34383 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3FAQ0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jun 2013 12:26:52 -0400
Received: by mail-ob0-f170.google.com with SMTP id ef5so5005425obb.29
        for <linux-media@vger.kernel.org>; Sat, 01 Jun 2013 09:26:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Jun 2013 12:26:51 -0400
Message-ID: <CAHd=XUxC0jf8FPCKOXc4uuE74-7tqR3+MYii_FjDWsOEiy723g@mail.gmail.com>
Subject: Hauppauge WinTV-HVR-950q Ubuntu 13.04
From: Anthony Calabro <anthony.calabro@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

I just bought a Hauppauge WinTV-HVR-950q USB Tuner and I cant get it
to work in Ubuntu.  I started with Mythbuntu 12.04.2 with no luck,
moved backwards and forwards in kernel versions and right now I'm
using Ubuntu 13.04 with the 3.8.0-23-generic (x86_64).

Below is the error messages I'm seeing (dmesg):

[  123.516077] usb 1-2: new high-speed USB device number 4 using ehci-pci
[  123.670562] usb 1-2: New USB device found, idVendor=2040, idProduct=7200
[  123.670574] usb 1-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=10
[  123.670583] usb 1-2: Product: WinTV HVR-950
[  123.670590] usb 1-2: Manufacturer: Hauppauge
[  123.670596] usb 1-2: SerialNumber: 4035521349
[  124.028265] au0828: i2c bus registered
[  124.224269] tveeprom 6-0050: Hauppauge model 72001, rev E1H3, serial# 8989509
[  124.224283] tveeprom 6-0050: MAC address is 00:0d:fe:89:2b:45
[  124.224290] tveeprom 6-0050: tuner model is Xceive XC5000C (idx 173, type 88)
[  124.224298] tveeprom 6-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[  124.224304] tveeprom 6-0050: audio processor is AU8522 (idx 44)
[  124.224309] tveeprom 6-0050: decoder processor is AU8522 (idx 42)
[  124.224315] tveeprom 6-0050: has no radio, has IR receiver, has no
IR transmitter
[  124.224320] hauppauge_eeprom: hauppauge eeprom: model=72001
[  124.248596] au8522 6-0047: creating new instance
[  124.248608] au8522_decoder creating new instance...
[  124.285066] tuner 6-0061: Tuner -1 found with type(s) Radio TV.
[  124.285125] xc5000 6-0061: creating new instance
[  124.290005] xc5000: Device not found at addr 0x61 (0x1000)
[  124.290016] xc5000 6-0061: destroying instance
[  124.290530] au8522 6-0047: attaching existing instance
[  124.299170] xc5000 6-0061: creating new instance
[  124.304004] xc5000: Device not found at addr 0x61 (0x1000)
[  124.304048] xc5000 6-0061: destroying instance
[  124.304081] DVB: registering new adapter (au0828)
[  124.304099] usb 1-2: DVB: registering adapter 0 frontend 0 (Auvitek
AU8522 QAM/8VSB Frontend)...
[  124.305332] Registered device AU0828 [Hauppauge HVR950Q]

Any help, thoughts, or advice?

Thanks in advance!
