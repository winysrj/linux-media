Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45113 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3DWMN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 08:13:26 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so217860ead.14
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 05:13:25 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Apr 2013 13:13:25 +0100
Message-ID: <CAOS+5GGVt7Zsr1jJz=kC=98meQ3D+LYnNwoWDg1PWbwCaij2QA@mail.gmail.com>
Subject: Elgato DTT Deluxe V2
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently picked up one of these very cheap and am trying to load it into 'nix.

According to this

http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT_deluxe_v2

It should be recognised and load, and indeed when plugged in dmesg
correctly reports it being detected and lsusb sees the device and the
correctly reports the device ID.

However there's no DVB section loading and I'm not sure why.

I've copied the two .hex files to firmware and dmesg is not reporting
any other outstanding requirements, however it's just not
partying........

Installed into a windows machine the drivers load and it reports OK
(it's not tuning but I'm pretty sure that's a location issue at the
moment).

any ideas anyone?


section from dmesg

[88238.662053] usb 2-1: new high-speed USB device number 6 using ehci-pci
[88238.777869] usb 2-1: New USB device found, idVendor=0fd9, idProduct=002c
[88238.777881] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[88238.777888] usb 2-1: Product: EyeTV DTT Dlx
[88238.777895] usb 2-1: Manufacturer: Elgato
[88238.777902] usb 2-1: SerialNumber: 0000xxxxxxxxxxxxxx
[88554.865760] usb 2-1: USB disconnect, device number 6
