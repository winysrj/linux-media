Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41688 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab1JFTPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 15:15:24 -0400
Received: by qadb15 with SMTP id b15so2272437qad.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 12:15:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 21:15:23 +0200
Message-ID: <CALrz3jHX8f1QtD7wiVzxrT6211FgCUWEfCHsH=jk6zBRyyWmAA@mail.gmail.com>
Subject: DVB CAM did not respond :(
From: Roger Martensson <roger.martensson@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I'm posting this in hope that someone with knowledge can respond with
something that can help me.
Mr google hasn't helped me that much.

I bought myself a DVB-C with a CI interface in which I put a Conax CAM.

The card is functioning since I can watch the not encrypted channels
with Kaffeine just fine.

I have gotten the card to actually decode and show encrypted channel
but now whenever I try to insert the cam I get the dreadful "DVB CAM
did not respond" error i dmesg.

Any help is apprecieated.

My card according lspci -v.
08:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
    Subsystem: KNC One Device 0028
    Flags: bus master, medium devsel, latency 64, IRQ 16
    Memory at fbeffc00 (32-bit, non-prefetchable) [size=512]
    Kernel driver in use: budget_av
    Kernel modules: budget-av

Dmesg with some debugoptions set:
[ 1944.581819] saa7146: register extension 'budget_av'.
[ 1944.581870] budget_av 0000:08:01.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[ 1944.581913] saa7146: found saa7146 @ mem f8142c00 (revision 1, irq
16) (0x1894,0x0028).
[ 1944.581924] saa7146 (0): dma buffer size 192512
[ 1944.581929] DVB: registering new adapter (KNC1 DVB-C MK3)
[ 1944.617865] adapter failed MAC signature check
[ 1944.617869] encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
[ 1944.819717] budget_av: saa7113_init(): saa7113 not found on KNC card
[ 1944.880021] KNC1-0: MAC addr = 00:09:d6:6d:b9:5c
[ 1945.020275] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[ 1945.020379] dvb_ca_en50221_init
[ 1945.020556] budget-av: ci interface initialised.
[ 1945.020562] dvb_ca_en50221_thread
[ 1950.006214] budget-av: cam inserted A
[ 1950.006233] budget_av: ciintf_slot_reset(): ciintf_slot_reset
[ 1950.161838] TUPLE type:0x1d length:4
[ 1950.161850]   0x00: 0x00 .
[ 1950.161860]   0x01: 0xdb .
[ 1950.161869]   0x02: 0x08 .
[ 1950.161878]   0x03: 0xff .
[ 1950.161895] TUPLE type:0x1c length:3
[ 1950.161904]   0x00: 0x00 .
[ 1950.161914]   0x01: 0x08 .
[ 1950.161923]   0x02: 0xff .
[ 1950.161940] TUPLE type:0x15 length:18
[ 1950.161949]   0x00: 0x05 .
[ 1950.161959]   0x01: 0x00 .
[ 1950.161968]   0x02: 0x4e N
[ 1950.161977]   0x03: 0x45 E
[ 1950.161986]   0x04: 0x4f O
[ 1950.161996]   0x05: 0x54 T
[ 1950.162005]   0x06: 0x49 I
[ 1950.162014]   0x07: 0x4f O
[ 1950.162023]   0x08: 0x4e N
[ 1950.162033]   0x09: 0x00 .
[ 1950.162042]   0x0a: 0x43 C
[ 1950.162051]   0x0b: 0x41 A
[ 1950.162060]   0x0c: 0x4d M
[ 1950.162070]   0x0d: 0x00 .
[ 1950.162079]   0x0e: 0x43 C
[ 1950.162088]   0x0f: 0x49 I
[ 1950.162098]   0x10: 0x00 .
[ 1950.162107]   0x11: 0xff .
[ 1950.162123] TUPLE type:0x20 length:4
[ 1950.162133]   0x00: 0xff .
[ 1950.162142]   0x01: 0xff .
[ 1950.162151]   0x02: 0x01 .
[ 1950.162161]   0x03: 0x00 .
[ 1950.162177] TUPLE type:0x1a length:21
[ 1950.162187]   0x00: 0x01 .
[ 1950.162196]   0x01: 0x0f .
[ 1950.162205]   0x02: 0xfe .
[ 1950.162214]   0x03: 0x01 .
[ 1950.162224]   0x04: 0x01 .
[ 1950.162233]   0x05: 0xc0 .
[ 1950.162242]   0x06: 0x0e .
[ 1950.162251]   0x07: 0x41 A
[ 1950.162260]   0x08: 0x02 .
[ 1950.162270]   0x09: 0x44 D
[ 1950.162279]   0x0a: 0x56 V
[ 1950.162288]   0x0b: 0x42 B
[ 1950.162298]   0x0c: 0x5f _
[ 1950.162307]   0x0d: 0x43 C
[ 1950.162316]   0x0e: 0x49 I
[ 1950.162326]   0x0f: 0x5f _
[ 1950.162335]   0x10: 0x56 V
[ 1950.162344]   0x11: 0x31 1
[ 1950.162354]   0x12: 0x2e .
[ 1950.162363]   0x13: 0x30 0
[ 1950.162372]   0x14: 0x30 0
[ 1950.162389] TUPLE type:0x1b length:14
[ 1950.162399]   0x00: 0xc2 .
[ 1950.162408]   0x01: 0x41 A
[ 1950.162417]   0x02: 0x09 .
[ 1950.162427]   0x03: 0x37 7
[ 1950.162436]   0x04: 0x55 U
[ 1950.162445]   0x05: 0x4d M
[ 1950.162454]   0x06: 0x5d ]
[ 1950.162464]   0x07: 0x56 V
[ 1950.162485]   0x08: 0x56 V
[ 1950.162496]   0x09: 0xaa .
[ 1950.162507]   0x0a: 0x60 `
[ 1950.162517]   0x0b: 0x20
[ 1950.162528]   0x0c: 0x03 .
[ 1950.162539]   0x0d: 0x03 .
[ 1950.162557] TUPLE type:0x1b length:38
[ 1950.162568]   0x00: 0xcf .
[ 1950.162579]   0x01: 0x04 .
[ 1950.162590]   0x02: 0x19 .
[ 1950.162600]   0x03: 0x37 7
[ 1950.162611]   0x04: 0x55 U
[ 1950.162622]   0x05: 0x4d M
[ 1950.162632]   0x06: 0x5d ]
[ 1950.162643]   0x07: 0x56 V
[ 1950.162654]   0x08: 0x56 V
[ 1950.162664]   0x09: 0x22 "
[ 1950.162675]   0x0a: 0x20
[ 1950.162686]   0x0b: 0xc0 .
[ 1950.162696]   0x0c: 0x09 .
[ 1950.162707]   0x0d: 0x44 D
[ 1950.162718]   0x0e: 0x56 V
[ 1950.162729]   0x0f: 0x42 B
[ 1950.162739]   0x10: 0x5f _
[ 1950.162750]   0x11: 0x48 H
[ 1950.162761]   0x12: 0x4f O
[ 1950.162771]   0x13: 0x53 S
[ 1950.162782]   0x14: 0x54 T
[ 1950.162793]   0x15: 0x00 .
[ 1950.162804]   0x16: 0xc1 .
[ 1950.162815]   0x17: 0x0e .
[ 1950.162826]   0x18: 0x44 D
[ 1950.162837]   0x19: 0x56 V
[ 1950.162848]   0x1a: 0x42 B
[ 1950.162859]   0x1b: 0x5f _
[ 1950.162870]   0x1c: 0x43 C
[ 1950.162881]   0x1d: 0x49 I
[ 1950.162892]   0x1e: 0x5f _
[ 1950.162903]   0x1f: 0x4d M
[ 1950.162914]   0x20: 0x4f O
[ 1950.162925]   0x21: 0x44 D
[ 1950.162937]   0x22: 0x55 U
[ 1950.162948]   0x23: 0x4c L
[ 1950.162959]   0x24: 0x45 E
[ 1950.162970]   0x25: 0x00 .
[ 1950.162990] TUPLE type:0x14 length:0
[ 1950.163001] END OF CHAIN TUPLE type:0xff
[ 1950.163007] Valid DVB CAM detected MANID:ffff DEVID:1
CONFIGBASE:0x1fe CONFIGOPTION:0xf
[ 1950.163013] dvb_ca_en50221_set_configoption
[ 1950.163032] Set configoption 0xf, read configoption 0xf
[ 1950.163042] DVB CAM validated successfully
[ 1960.236571] dvb_ca adapter 0: DVB CAM did not respond :(
