Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:12815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZI1Q7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:59:19 -0400
Received: by fg-out-1718.google.com with SMTP id 22so810124fge.1
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 09:59:23 -0700 (PDT)
Message-ID: <4AC0EB67.5010002@gmail.com>
Date: Mon, 28 Sep 2009 19:59:19 +0300
From: Folnin Vi <folnin@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Mystique SaTiX DVB-S2 [KNC ONE] - Kernel panic
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am having problems with Mystique SaTiX DVB-S2 card.

Using the latest drivers from linuxtv.org.

Every time I use the card kernel panic occurs.
For example when trying to scan transponder.

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted 
in: fb40d12f

I have tried to use kexec to make a vmcore dump, but the gdb only shows:
[root@alinux ~]# gdb ./vmlinux ./vmcore.dvb_v4l
...
(gdb) bt
#0  0xc017e781 in ?? ()
#1  0x00000000 in ?? ()
(gdb)

The card on windows works fine.

Is it a driver problem?

Is there a way I could extract more information about this issue?

Any help would be really appreciated.

Some more info:

dmesg
udget_av 0000:01:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs
saa7146: found saa7146 @ mem fb108e00 (revision 1, irq 17) (0x1894,0x0019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (KNC1 DVB-S2)
adapter failed MAC signature check
encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
budget_av: saa7113_init(): saa7113 not found on KNC card
KNC1-0: MAC addr = 00:09:d6:65:2d:92
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
stb0899_attach: Attaching STB0899
tda8261_attach: Attaching TDA8261 8PSK/QPSK tuner
DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
dvb_ca_en50221_init
budget-av: ci interface initialised.
dvb_ca_en50221_thread
budget-av: cam inserted A
budget_av: ciintf_slot_reset(): ciintf_slot_reset
dvb_ca adapter 0: DVB CAM detected and initialised successfully

lspci -vv
01:08.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: KNC One Device 0019
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (3750ns min, 9500ns max)
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at feadfe00 (32-bit, non-prefetchable) [size=512]
         Kernel driver in use: budget_av
         Kernel modules: budget-av

Thanks in advance.
Folnin Vi
