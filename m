Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23207.mail.ird.yahoo.com ([217.146.189.62]:29646 "HELO
	web23207.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753304AbZLVQ3O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 11:29:14 -0500
Message-ID: <647222.75232.qm@web23207.mail.ird.yahoo.com>
Date: Tue, 22 Dec 2009 16:29:12 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: AW: [linux-dvb] Kernel oops with Technotrend S2-3200
To: linux-media@vger.kernel.org
In-Reply-To: <BLU141-W328C060CAFF6A5A445B0A5DC830@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

it seems problem has been fixed.

kind regards

Newsy


--- Oliver Holler <oholler@live.com> schrieb am So, 20.12.2009:

> Von: Oliver Holler <oholler@live.com>
> Betreff: [linux-dvb] Kernel oops with Technotrend S2-3200
> An: linux-dvb@linuxtv.org
> Datum: Sonntag, 20. Dezember 2009, 19:26
> 
> 
> 
> 
>  
> Hello,
> 
> I am trying to get a new Technotrend S2-3200 to run.
> I am using changeset 13992:77a5248e92b5 of s2-liplianin and
> kernel 2.6.31.8 and 2.6.32.1.
> 
> When I try to load the module with modprobe budget_ci
> I am getting a kernel: Oops: 0000 [#1] PREEMPT.
> 
> I appreciate any help.
> 
> Here is the syslog:
> Dec 20 15:27:37 fs1 kernel: saa7146: register extension
> 'budget_ci dvb'.
> Dec 20 15:27:37 fs1 kernel: budget_ci dvb 0000:01:01.0: PCI
> INT A -> GSI 20 (level, low) -> IRQ 20
> Dec 20 15:27:37 fs1 kernel: IRQ 20/: IRQF_DISABLED is not
> guaranteed on shared IRQs
> Dec 20 15:27:37 fs1 kernel: saa7146: found saa7146 @ mem
> f8210c00 (revision 1, irq 20) (0x13c2,0x1019).
> Dec 20 15:27:37 fs1 kernel: saa7146 (0): dma buffer size
> 192512
> Dec 20 15:27:37 fs1 kernel: DVB: registering new adapter
> (TT-Budget S2-3200 PCI)
> Dec 20 15:27:37 fs1 kernel: adapter has MAC addr =
> 00:d0:5c:64:99:e6
> Dec 20 15:27:37 fs1 kernel: input: Budget-CI dvb ir
> receiver saa7146 (0) as /class/input/input2
> Dec 20 15:27:37 fs1 kernel: Creating IR device irrcv0
> Dec 20 15:27:37 fs1 kernel: BUG: unable to handle kernel
> paging request at 72727563
> Dec 20 15:27:37 fs1 kernel: IP: [<c1111f36>]
> strcmp+0x7/0x19
> Dec 20 15:27:37 fs1 kernel: *pde = 00000000 
> Dec 20 15:27:37 fs1 kernel: Oops: 0000 [#1] PREEMPT 
> Dec 20 15:27:37 fs1 kernel: last sysfs file:
> /sys/class/net/lo/operstate
> Dec 20 15:27:37 fs1 kernel: Modules linked in: budget_ci(+)
> ir_common budget_core dvb_core saa7146 ttpci_eeprom ir_core
> fuse evdev atl1 iTCO_wdt iTCO_vendor_support i2c_i801
> ehci_hcd uhci_hcd thermal processor button thermal_sys
> usbcore
> Dec 20 15:27:37 fs1 kernel: 
> Dec 20 15:27:37 fs1 kernel: Pid: 10958, comm: modprobe Not
> tainted (2.6.31.8 #1) System Product Name
> Dec 20 15:27:37 fs1 kernel: EIP: 0060:[<c1111f36>]
> EFLAGS: 00010282 CPU: 0
> Dec 20 15:27:37 fs1 kernel: EIP is at strcmp+0x7/0x19
> Dec 20 15:27:37 fs1 kernel: EAX: c12b2475 EBX: f662e534
> ECX: 00000001 EDX: 72727563
> Dec 20 15:27:37 fs1 kernel: ESI: c12b24bb EDI: 72727563
> EBP: f662e560 ESP: f6bffdcc
> Dec 20 15:27:37 fs1 kernel:  DS: 007b ES: 007b FS:
> 0000 GS: 0033 SS: 0068
> Dec 20 15:27:37 fs1 kernel: Process modprobe (pid: 10958,
> ti=f6bfe000 task=f70eb1b0 task.ti=f6bfe000)
> Dec 20 15:27:37 fs1 kernel: Stack:
> Dec 20 15:27:37 fs1 kernel:  72727563 f6bffe08
> c1092f33 f814fcb0 f662e458 c1093018 f814fcb0 f662e458
> Dec 20 15:27:37 fs1 kernel: <0> f6bffe08 c10930c2
> f814fcb0 f662e458 fffffff4 f662e560 c1092c0a f662e560
> Dec 20 15:27:37 fs1 kernel: <0> 00000000 00000000
> 00000000 00000001 00000000 f81507f4 f684d488 c109460e
> Dec 20 15:27:37 fs1 kernel: Call Trace:
> Dec 20 15:27:37 fs1 kernel:  [<c1092f33>] ?
> sysfs_find_dirent+0x13/0x23
> Dec 20 15:27:37 fs1 kernel:  [<c1093018>] ?
> __sysfs_add_one+0x11/0x81
> Dec 20 15:27:37 fs1 kernel:  [<c10930c2>] ?
> sysfs_add_one+0xd/0x70
> Dec 20 15:27:37 fs1 kernel:  [<c1092c0a>] ?
> sysfs_add_file_mode+0x3f/0x66
> Dec 20 15:27:37 fs1 kernel:  [<c109460e>] ?
> internal_create_group+0xd0/0x140
> Dec 20 15:27:37 fs1 kernel:  [<f814f7b4>] ?
> ir_register_class+0x64/0x92 [ir_core]
> Dec 20 15:27:37 fs1 kernel:  [<f814f32b>] ?
> ir_input_register+0x133/0x176 [ir_core]
> Dec 20 15:27:37 fs1 kernel:  [<f8206d08>] ?
> budget_ci_attach+0x1fa/0xb0c [budget_ci]
> Dec 20 15:27:37 fs1 kernel:  [<f81642ea>] ?
> saa7146_init_one+0x4ea/0x6cb [saa7146]
> Dec 20 15:27:37 fs1 kernel:  [<c10930c2>] ?
> sysfs_add_one+0xd/0x70
> Dec 20 15:27:37 fs1 kernel:  [<c111a55d>] ?
> local_pci_probe+0xb/0xc
> Dec 20 15:27:37 fs1 kernel:  [<c111aba1>] ?
> pci_device_probe+0x41/0x63
> Dec 20 15:27:37 fs1 kernel:  [<c115f5d2>] ?
> driver_probe_device+0x75/0xfc
> Dec 20 15:27:37 fs1 kernel:  [<c115f699>] ?
> __driver_attach+0x40/0x5b
> Dec 20 15:27:37 fs1 kernel:  [<c115f055>] ?
> bus_for_each_dev+0x37/0x5f
> Dec 20 15:27:37 fs1 kernel:  [<c115f4ba>] ?
> driver_attach+0x11/0x13
> Dec 20 15:27:37 fs1 kernel:  [<c115f659>] ?
> __driver_attach+0x0/0x5b
> Dec 20 15:27:37 fs1 kernel:  [<c115eaea>] ?
> bus_add_driver+0x99/0x1bc
> Dec 20 15:27:37 fs1 kernel:  [<c115f8b3>] ?
> driver_register+0x87/0xe0
> Dec 20 15:27:37 fs1 kernel:  [<c111aeea>] ?
> __pci_register_driver+0x2c/0x82
> Dec 20 15:27:37 fs1 kernel:  [<f820d000>] ?
> budget_ci_init+0x0/0xa [budget_ci]
> Dec 20 15:27:37 fs1 kernel:  [<c100112b>] ?
> do_one_initcall+0x43/0x11f
> Dec 20 15:27:37 fs1 kernel:  [<c1036773>] ?
> sys_init_module+0xa7/0x1b4
> Dec 20 15:27:37 fs1 kernel:  [<c10028f4>] ?
> sysenter_do_call+0x12/0x26
> Dec 20 15:27:37 fs1 kernel: Code: 04 31 db 89 0c 24 89 d8
> 89 d1 f2 ae 4f 8b 0c 24 49 78 06 ac aa 84 c0 75 f7 31 c0 aa
> 5b 89 e8 5b 5e 5f 5d c3 57 89 d7 56 89 c6 ac <ae> 75
> 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f c3 57 89 d7 
> Dec 20 15:27:37 fs1 kernel: EIP: [<c1111f36>]
> strcmp+0x7/0x19 SS:ESP 0068:f6bffdcc
> Dec 20 15:27:37 fs1 kernel: CR2: 0000000072727563
> Dec 20 15:27:37 fs1 kernel: ---[ end trace 858b357512ea7e44
> ]---  
>  		 	   		  
> Windows Live: Make it easier for
> your friends to see  what
> you’re up to on Facebook. 
> 
> -----Integrierter Anhang folgt-----
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
