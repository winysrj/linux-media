Return-path: <mchehab@pedra>
Received: from vs0507.your-vserver.de ([78.46.240.243]:49559 "EHLO
	vigh-molnar.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab1AOVzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 16:55:23 -0500
Received: from tamasws (94-227-129-93.access.telenet.be [94.227.129.93])
	by vigh-molnar.hu (Postfix) with ESMTP id 4778F4608E
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 22:49:00 +0100 (CET)
From: benefici@fastmail.fm
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV-NOVA-HD-S2 with differenct PCI ID
Date: Sat, 15 Jan 2011 22:48:59 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201101152248.59542.benefici@fastmail.fm>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've bought a Hauppauge WinTV-NOVA-HD-S2 card, which theoretically
should be supported in the stock Linux kernel since version 2.6.28. However, 
my card is not detected, there are apparently no kernel modules loaded for 
the card and no message appears in dmesg during booting. I tried the card 
under both openSUSE 11.2 and 11.3, with identical results. The card is listed 
by lspci as:

# lspci -vnn -s 01:07
01:07.0 Multimedia video controller [0400]: Conexant Systems, Inc. Device 
[14f1:0800] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6906]
        Flags: bus master, medium devsel, latency 32, IRQ 12
        Memory at 21000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:07.1 Multimedia controller [0480]: Conexant Systems, Inc. Device 
[14f1:0801] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6906]
        Flags: bus master, medium devsel, latency 32, IRQ 12
        Memory at 22000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

01:07.2 Multimedia controller [0480]: Conexant Systems, Inc. Device 
[14f1:0802] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6906]
        Flags: bus master, medium devsel, latency 32, IRQ 12
        Memory at 23000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

01:07.4 Multimedia controller [0480]: Conexant Systems, Inc. Device 
[14f1:0804] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6906]
        Flags: bus master, medium devsel, latency 32, IRQ 12
        Memory at 24000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

One thing I found suspicious is the PCI ID of the card: 14f1:0800.
Based on http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
I think this is expected to be 14f1:8800.
As a quick hack, I changed the device id from 0x8800 to 0x0800 in 
cx88/cx88-video.c and in cx88/cx88-reg.h

After this, the card is detected, but the module tveeprom fails:
[    4.916902] cx8800 0000:01:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.917629] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000
(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[    4.917751] cx88[0]: TV tuner type -1, Radio tuner type -1
[    5.083308] tveeprom 1-0050: Huh, no eeprom present (err=-6)?
[    5.083390] tveeprom 1-0050: Encountered bad packet header [00]. Corrupt or 
not a Hauppauge eeprom.
[    5.083501] cx88[0]: warning: unknown hauppauge model #0
[    5.083574] cx88[0]: hauppauge eeprom: model=0
[    5.083757] input: cx88 IR (Hauppauge WinTV-HVR400 
as /devices/pci0000:00/0000:00:1e.0/0000:01:07.0/input/input3
[    5.083955] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 19, latency: 32, 
mmio: 0x21000000
[    5.084097] IRQ 19/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.084233] cx88[0]/0: registered device video0 [v4l2]
[    5.084343] cx88[0]/0: registered device vbi0

I found one guy with the same problem on a Mandriva forum (back in April 2009) 
but no solution. Any ideas?

Best regards,
Tom
