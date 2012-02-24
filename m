Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48592 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2BXKDn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 05:03:43 -0500
Received: by wicr5 with SMTP id r5so96853wic.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 02:03:41 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 11:03:41 +0100
Message-ID: <CAL9G6WVTWTZpmkaCo0G4h5f1bOXBMOpT-yOZ5m90LXUCf9iv=g@mail.gmail.com>
Subject: TeVii S470 on kernel 3.2
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all, I just upgrade from Debian Squeeze to Debian Wheezy (3.2
kernel), and the TeVii S470 DVB-S2 card doesn't work now. It doesn't
find any channels.

This is the dmesg:

...
[    9.727623] cx23885 driver version 0.0.3 loaded
[    9.728317] ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 19
[    9.728346] cx23885 0000:05:00.0: PCI INT A -> Link[LN4A] -> GSI 19
(level, low) -> IRQ 19
[    9.728981] CORE cx23885[0]: subsystem: d470:9022, board: TeVii
S470 [card=15,autodetected]
[    9.862639] cx23885_dvb_register() allocating 1 frontend(s)
[    9.863046] cx23885[0]: cx23885 based dvb card
[    9.874022] IR NEC protocol handler initialized
[    9.899672] DS3000 chip version: 0.192 attached.
[    9.899682] DVB: registering new adapter (cx23885[0])
[    9.899690] DVB: registering adapter 7 frontend 0 (Montage
Technology DS3000/TS2020)...
[    9.927578] TeVii S470 MAC= 00:18:bd:5b:31:1e
[    9.927588] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    9.927599] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 19,
latency: 0, mmio: 0xfea00000
[    9.927612] cx23885 0000:05:00.0: setting latency timer to 64
...

The device is on /dev/dvb/adapter7. I have this messages on dmesg when
it try to scan channels:

ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
ds3000_firmware_ondemand: Waiting for firmware upload(2)...

The firmware is there:

$ ls -l /lib/firmware/ | grep ds3000
-rw-r--r-- 1 root root  8192 Feb 20 22:51 dvb-fe-ds3000.fw

I have on the same machine a TeVii S660 DVB-S2 and it is working great.

I will appreciate any help. Thanks and best regards.

-- 
Josu Lazkano
