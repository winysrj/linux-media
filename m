Return-path: <linux-media-owner@vger.kernel.org>
Received: from [86.34.125.186] ([86.34.125.186]:35932 "EHLO pa-gw.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753755AbZCGTxt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 14:53:49 -0500
Received: from pa-mx-2.embit.ro (unknown [89.32.222.3])
	by pa-gw.localdomain (Postfix) with ESMTP id 9DA2BEF14B
	for <linux-media@vger.kernel.org>; Sat,  7 Mar 2009 21:43:17 +0200 (EET)
Received: from localhost (pa-mx-2.embit.ro [127.0.0.1])
	by pa-mx-2.embit.ro (Postfix) with ESMTP id 8FBA2165806E
	for <linux-media@vger.kernel.org>; Sat,  7 Mar 2009 21:43:17 +0200 (EET)
Received: from pa-mx-2.embit.ro ([127.0.0.1])
	by localhost (pa-mx-1.embit.ro [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0ft+V1U91iqf for <linux-media@vger.kernel.org>;
	Sat,  7 Mar 2009 21:43:16 +0200 (EET)
Received: from dromi.xdev.ro (unknown [89.32.216.194])
	by pa-mx-2.embit.ro (Postfix) with ESMTPSA id 74C1F165805C
	for <linux-media@vger.kernel.org>; Sat,  7 Mar 2009 21:43:16 +0200 (EET)
Message-ID: <49B2CE51.9010002@embit.ro>
Date: Sat, 07 Mar 2009 21:43:13 +0200
From: Bogdan Timofte <bogdan@embit.ro>
Reply-To: bogdan@embit.ro
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: No success with Technisat Skystar HD2 PCI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to install a Technisat Skystar HD2 PCI ard without succes:

uname -a
Linux test 2.6.27.19-170.2.35.fc10.i686 #1 SMP Mon Feb 23 13:21:22 EST
2009 i686 i686 i386 GNU/Linux

hg clone http://mercurial.intuxication.org/hg/s2-liplianin
make
make install

lspci -vv
01:02.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0003
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 12
        Region 0: Memory at df200000 (32-bit, prefetchable) [size=4K]
        Kernel modules: mantis

modprobe mantis
Segmentation fault

dmesg output:

Mantis 0000:01:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
=== Interrupts[ffffffff/ffffffff]= [* DMA enabl ** INT IRQ-0 *<1>BUG:
unable to handle kernel NULL pointer dereference at 00000068
IP: [<c041b913>] __ticket_spin_lock+0x8/0x19
*pde = 00000000
Oops: 0002 [#1] SMP
Modules linked in: mantis(+) lnbp21 mb86a16 stb6100 tda10021 tda10023
stb0899 stv0299 dvb_core i2c_i801 i2c_core ppdev tg3 parport_pc
e752x_edac parport edac_core pcspkr serio_raw iTCO_wdt
iTCO_vendor_support i6300esb libphy floppy ata_generic pata_acpi [last
unloaded: scsi_wait_scan]

Pid: 11058, comm:
EIP: 0060:[<c041b913>] EFLAGS: 00010046 CPU: 1
EIP is at __ticket_spin_lock+0x8/0x19
EAX: 00000068 EBX: 00000068 ECX: 00000001 EDX: 00000100
ESI: 00000082 EDI: 0000009c EBP: f61f8df8 ESP: f61f8df8
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 11058, ti=f61f8000 task=f6144ce0 task.ti=f61f8000)
Stack: f61f8e08 c06aae64 00000068 00000001 f61f8e20 c0421f53 00000003
ffffffff
       f60e7800 0000009c f61f8e3c f8e2b6ed 00000000 00000000 00000202
f7803860
       f8e2b604 f61f8e5c c0465a70 00000080 00000012 01200000 df200000
f60e7800
Call Trace:
[<c06aae64>] ? _spin_lock_irqsave+0x29/0x30
[<c0421f53>] ? __wake_up+0x15/0x3b
[<f8e2b6ed>] ? mantis_pci_irq+0xe9/0x240 [mantis]
[<f8e2b604>] ? mantis_pci_irq+0x0/0x240 [mantis]
[<c0465a70>] ? request_irq+0xbb/0x10c
[<f8e2da97>] ? mantis_pci_probe+0x1a3/0x3bf [mantis]
[<c0594481>] ? get_device+0x13/0x18
[<c052a4f3>] ? pci_device_probe+0x39/0x59
[<c05969c4>] ? driver_probe_device+0xa0/0x136
[<c0596a94>] ? __driver_attach+0x3a/0x59
[<c05963ea>] ? bus_for_each_dev+0x3b/0x63
[<c0596869>] ? driver_attach+0x14/0x16
[<c0596a5a>] ? __driver_attach+0x0/0x59
[<c0595e5e>] ? bus_add_driver+0x9d/0x1ba
[<c0596c1b>] ? driver_register+0x81/0xe1
[<c043ef62>] ? autoremove_wake_function+0x0/0x33
[<c052a6b2>] ? __pci_register_driver+0x3f/0x6d
[<f8e2dcca>] ? mantis_pci_init+0x17/0x19 [mantis]
[<c0401125>] ? _stext+0x3d/0x115
[<f8e2dcb3>] ? mantis_pci_init+0x0/0x19 [mantis]
[<c044e155>] ? sys_init_module+0x87/0x178
[<c0404c8a>] ? syscall_call+0x7/0xb
=======================
Code: 84 c0 0f 95 c0 0f b6 c0 c3 55 8b 10 89 e5 5d 89 d0 c1 f8 08 29 d0
25 ff 00 00 00 48 0f 9f c0 0f b6 c0 c3 55 ba 00 01 00 00 89 e5 <f0> 66
0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 5d c3 55 89 e5 53
EIP: [<c041b913>] __ticket_spin_lock+0x8/0x19 SS:ESP 0068:f61f8df8
---[ end trace bca33cf69333abb8 ]---
lsmod output
lsmod
Module                  Size  Used by
saa7115                17840  0
v4l2_common            13440  1 saa7115
mantis                 20488  1
mantis_core            30208  1 mantis
tda665x                 7040  1 mantis
lnbp21                  5760  1 mantis
mb86a16                21120  1 mantis
stb6100                10372  1 mantis
tda10021                9348  1 mantis
tda10023                9860  1 mantis
zl10353                10376  1 mantis
stb0899                35588  1 mantis
stv0299                12680  1 mantis
dvb_core               75880  2 mantis_core,stv0299
i2c_dev                 9480  0
tg3                   107524  0
iTCO_wdt               13732  0
ppdev                  10372  0
pcspkr                  6272  0
iTCO_vendor_support     6916  1 iTCO_wdt
parport_pc             25620  0
i2c_i801               12048  0
i6300esb                8984  0
i2c_core               21396  15
saa7115,v4l2_common,mantis,mantis_core,tda665x,lnbp21,mb86a16,stb6100,tda10021,tda10023,zl10353,stb0899,stv0299,i2c_dev,i2c_i801
parport                31956  2 ppdev,parport_pc
libphy                 18560  1 tg3
e752x_edac             15244  0
serio_raw               8836  0
edac_core              36780  1 e752x_edac
floppy                 51988  0
ata_generic             8452  0
pata_acpi               7680  0


Any idea about what is wrong?


