Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:41386 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbZKJRN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 12:13:28 -0500
Received: by pxi3 with SMTP id 3so164275pxi.22
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 09:13:33 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 12:13:33 -0500
Message-ID: <ddfe20800911100913l2ebe777dya3ef47fc944e6897@mail.gmail.com>
Subject: Hauppauge HVR-1600 cx18 loading problem
From: John Nuszkowski <john.nuszkowski@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My new Hauppauge HVR-1600 does not load the firmware.  The driver was
built using the source from over the weekend.  I am using mythbuntu.

Below is a "modprobe cx18 debug=511" command

Any help would greatly be appreciated.

[43594.063182] cx18:  Start initialization, version 1.2.0
[43594.063306] cx18-0: Initializing card 0
[43594.063312] cx18-0: Autodetected Hauppauge card
[43594.063447] cx18-0:  info: base addr: 0xdc000000
[43594.063450] cx18-0:  info: Enabling pci device
[43594.063478] cx18 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 10
(level, low) -> IRQ 10
[43594.063493] cx18-0:  info: cx23418 (rev 0) at 00:0c.0, irq: 10,
latency: 64, memory: 0xdc000000
[43594.063498] cx18-0:  info: attempting ioremap at 0xdc000000 len 0x04000000
[43594.065656] cx18-0: cx23418 revision 01010000 (B)
[43594.246946] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
00003001/00000000
[43594.246970] cx18-0:  info: activating i2c...
[43594.246973] cx18-0:  i2c: i2c init
[43594.362969] tveeprom 5-0050: Hauppauge model 74041, rev C6B2, serial# 6380357
[43594.362976] tveeprom 5-0050: MAC address is 00-0D-FE-61-5B-45
[43594.362981] tveeprom 5-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
[43594.362987] tveeprom 5-0050: TV standards NTSC(M) (eeprom 0x08)
[43594.362991] tveeprom 5-0050: audio processor is CX23418 (idx 38)
[43594.362995] tveeprom 5-0050: decoder processor is CX23418 (idx 31)
[43594.363000] tveeprom 5-0050: has no radio, has IR receiver, has IR
transmitter
[43594.363004] cx18-0: Autodetected Hauppauge HVR-1600
[43594.363008] cx18-0:  info: NTSC tuner detected
[43594.363011] cx18-0: Simultaneous Digital and Analog TV capture supported
[43594.542552] IRQ 10/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
[43594.551681] tuner 6-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[43594.554867] cs5345 5-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[43594.557430] tuner-simple 6-0061: creating new instance
[43594.557436] tuner-simple 6-0061: type set to 50 (TCL 2002N)
[43594.558186] cx18-0:  info: Allocate encoder MPEG stream: 64 x 32768
buffers (2048kB total)
[43594.558268] cx18-0:  info: Allocate TS stream: 32 x 32768 buffers
(1024kB total)
[43594.558310] cx18-0:  info: Allocate encoder YUV stream: 16 x 131072
buffers (2048kB total)
[43594.558351] cx18-0:  info: Allocate encoder VBI stream: 20 x 51984
buffers (1015kB total)
[43594.558389] cx18-0:  info: Allocate encoder PCM audio stream: 256 x
4096 buffers (1024kB total)
[43594.558570] cx18-0:  info: Allocate encoder IDX stream: 32 x 32768
buffers (1024kB total)
[43594.558732] cx18-0: Registered device video1 for encoder MPEG (64 x 32 kB)
[43594.558738] DVB: registering new adapter (cx18)
[43594.594104] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
[43594.607124] cx18-0: Mismatch at offset 0
[43594.607137] cx18-0: Retry loading firmware
[43594.608161] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
[43594.649832] cx18-0: Mismatch at offset 0
[43594.649848] cx18-0: Failed to initialize on minor 3
[43594.682215] cx18-0: Failed to initialize on minor 3
[43594.691048] MXL5005S: Attached at address 0x63
[43594.691063] DVB: registering adapter 0 frontend 0 (Samsung S5H1409
QAM/8VSB Frontend)...
[43594.708643] cx18-0: DVB Frontend registered
[43594.708651] cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
[43594.708711] cx18-0: Registered device video33 for encoder YUV (16 x 128 kB)
[43594.708749] cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
[43594.708785] cx18-0: Registered device video25 for encoder PCM audio
(256 x 4 kB)
[43594.708790] cx18-0: Initialized card: Hauppauge HVR-1600
[43594.708829] cx18:  End initialization
[43594.716719] cx18-0: Failed to initialize on minor 4
[43594.723793] cx18-0: Failed to initialize on minor 5
[43594.726277] cx18-0: Failed to initialize on minor 6
[43594.736339] cx18-0: Failed to initialize on minor 6
[43594.757957] cx18-0: Failed to initialize on minor 4
[43594.784206] cx18-0: Failed to initialize on minor 5


Thanks,

John
