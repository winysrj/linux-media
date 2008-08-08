Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bikalexander@gmail.com>) id 1KRSbE-0005qW-2i
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 16:05:50 +0200
Received: by yx-out-2324.google.com with SMTP id 8so178895yxg.41
	for <linux-dvb@linuxtv.org>; Fri, 08 Aug 2008 07:05:43 -0700 (PDT)
Message-ID: <39d4b8530808080705q2e3f544apc70c7e498d5c391@mail.gmail.com>
Date: Fri, 8 Aug 2008 16:05:42 +0200
From: Bikalexander <bikalexander@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] saa7146_wait_for_debi_done_sleep
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

Hello,

have a problem when receiving the radio stations in the cable, the
sound is constantly being torn apart. Used Cinergy 1200 DVB-C:

##############################
00:0 a.0 multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: TERRATEC Electronic GmbH Unknown device 1176
         Control: I / O Mem + + BusMaster Spec Cycle
MemWINV-VGASnoop-ParErr-Stepping-SERR-FastB2B -
         Status: Cap-66MHz-UDF FastB2B + ParErr-DEVSEL = medium>
TAbort-<TAbort-<MAbort-> SERR-<PERR -
         Latency: 32 (3750ns min, 9500ns max)
         Interrupt: A pin routed to IRQ 21
         Region 0: Memory at e0001000 (32-bit, non-prefetchable) [size = 512]
##############################

This problem has been fixed times:
http://www.mail-archive.com/linux-dvb @ linuxtv.org/msg26731.html

So here's my log:
#############################
saa7146: saa7146_register_extension (): ext: dc9bfde0
saa7146: register extension 'budget_av'.
saa7146: saa7146_init_one (): pci: db929c00
ACPI: PCI interrupt 0000:00:0 a.0 [A] -> GSI 18 (level, low) -> IRQ 21
saa7146: found saa7146 @ mem dc9aa000 (revision 1, irq 21) (0x153b, 0x1176).
saa7146 (1): dma buffer size 1347584
DVB: registering new adapter (Terratec Cinergy 1200 DVB-C MK3)
saa7146: saa7146_i2c_adapter_prepare (): bitrate: 0x00000000
saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000400
saa7146: saa7146_i2c_transfer (): msg: 1 / 2
saa7146: saa7146_i2c_transfer (): msg: 2 / 2
saa7146: saa7146_i2c_writeout (): before: 0xa0cca1ec (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xa0cca1ec
saa7146: saa7146_i2c_writeout (): before: 0xc9da63a8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0xcf86dca8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0x040000a8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0x000000a8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0x000094a8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0x60c9daa8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffffa8
saa7146: saa7146_i2c_writeout (): before: 0xf4ff0090 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffff90
saa7146: saa7146_i2c_transfer (): transmission successful. (msg: 2).
Adapter failed MAC signature check
MAC encoded from EEPROM was ff: ff: ff: ff: ff: ff: ff: ff: ff: ff:
ff: ff: ff: ff: ff: ff: ff: ff: ff: ff
saa7146: saa7146_i2c_transfer (): msg: 1 / 1
saa7146: saa7146_i2c_writeout (): before: 0x4a0108e4 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): i2c unexpected status 0021
saa7146: saa7146_i2c_writeout (): error in address phase.
saa7146: saa7146_i2c_transfer (): msg: 1 / 2
saa7146: saa7146_i2c_transfer (): msg: 2 / 2
saa7146: saa7146_i2c_reset (): busy_state detected.
saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000042
saa7146: saa7146_i2c_writeout (): before: 0xa030a1ec (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0xa030a1ec
saa7146: saa7146_i2c_writeout (): before: 0x000000a8 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0x000aaca8
saa7146: saa7146_i2c_writeout (): before: 0x000000a4 (status: 0x00000000), 0
saa7146: saa7146_i2c_writeout (): after: 0x113b22a4
saa7146: saa7146_i2c_transfer (): transmission successful. (msg: 2).
KNC1-2: MAC addr = 00:0 a: ac: 11:3 b: 22
saa7146: saa7146_i2c_transfer (): msg: 1 / 2
saa7146: saa7146_i2c_transfer (): msg: 2 / 2
saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000000
saa7146: saa7146_i2c_writeout (): before: 0xa0ffa1ec (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): after: 0xa0ffa1ec
saa7146: saa7146_i2c_writeout (): before: 0xc9000040 (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): after: 0xffffa140
saa7146: saa7146_i2c_transfer (): transmission successful. (msg: 2).
saa7146: saa7146_i2c_transfer (): msg: 1 / 1
saa7146: saa7146_i2c_writeout (): before: 0x180033e4 (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): after: 0x180033e4
saa7146: saa7146_i2c_transfer (): transmission successful. (msg: 1).
..........
............

saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000742
saa7146: saa7146_i2c_writeout (): before: 0xaa0000c0 (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): i2c unexpected status 0721
saa7146: saa7146_i2c_writeout (): error in address phase.
saa7146: saa7146_i2c_transfer (): msg: 1 / 1
saa7146: saa7146_i2c_reset (): busy_state detected.
saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000742
saa7146: saa7146_i2c_writeout (): before: 0xac0000c0 (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): i2c unexpected status 0721
saa7146: saa7146_i2c_writeout (): error in address phase.
saa7146: saa7146_i2c_transfer (): msg: 1 / 1
saa7146: saa7146_i2c_reset (): busy_state detected.
saa7146: saa7146_i2c_reset (): error_state detected. Status: 0x00000742
saa7146: saa7146_i2c_writeout (): before: 0xae0000c0 (status: 0x00000700), 0
saa7146: saa7146_i2c_writeout (): i2c unexpected status 0721
saa7146: saa7146_i2c_writeout (): error in address phase.
it87: Found IT8705F chip at 0x290, revision 2
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
kjournald starting. Commit interval 5 seconds
FS EXT3 on hdd1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1

...........
...........
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0xd018d1ec (status: 0x00000000), 0
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): after: 0xd018d1ec
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0x00000040 (status: 0x00000000), 0
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): after: 0x5318d140
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer ():
transmission successful. (msg: 2).
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer (): msg: 1 / 2
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer (): msg: 2 / 2
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0xd01bd1ec (status: 0x00000000), 0
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): after: 0xd01bd1ec
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0x00000040 (status: 0x00000000), 0
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): after: 0x001bd140
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer ():
transmission successful. (msg: 2).
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_wait_for_debi_done_sleep
(): saa7146 (1): saa7146_wait_for_debi_done_sleep timed out while
waiting for transfer completion
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer (): msg: 1 / 2
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_transfer (): msg: 2 / 2
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0xd018d1ec (status: 0x00000000), 0
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): after: 0xd018d1ec
Aug 7 15:24:54 vdr kernel: saa7146: saa7146_i2c_writeout (): before:
0x00000040 (status: 0x00000000), 0
.................
............
##############################

My system:

Debian Etch
Kernel 2.6.24.4
Cinergy 1200 DVB-C
S2300 TT V 2.3 "modded" (With Full-TS-Mod)

Can there was?

Thank you.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
