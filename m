Return-path: <linux-media-owner@vger.kernel.org>
Received: from er-systems.de ([46.4.18.139]:42900 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIVTdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 15:33:47 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by er-systems.de (Postfix) with ESMTP id 8FC8E352679
	for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 21:26:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by er-systems.de (Postfix) with ESMTPS id 63BDC352548
	for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 21:26:51 +0200 (CEST)
Date: Mon, 22 Sep 2014 21:26:25 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: linux-media@vger.kernel.org
Subject: saa7146: WARNING at fs/proc/generic.c, name len 0
Message-ID: <alpine.LNX.2.00.1409222115570.2699@er-systems.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

does anyone have an idea what this is?

Card is working flawless, for me it is just cosmetic.

3.17.0-rc6

[    1.793384] saa7146: register extension 'budget_av'
[    1.793393] ata1.00: ATA-8: ST31000524AS, JC4B, max UDMA/133
[    1.793394] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 
31/32)
[    1.810836] ata1.00: configured for UDMA/133
[    1.811029] ------------[ cut here ]------------
[    1.811033] WARNING: CPU: 1 PID: 1 at fs/proc/generic.c:341 
__proc_create+0x18d/0x1a0()
[    1.811033] name len 0
[    1.811035] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 
3.17.0-rc6-celeron+ #174
[    1.811036] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./C1037UN-EU, BIOS FA 02/25/2014
[    1.811039]  0000000000000009 ffff88011a8c7a88 ffffffff8148d1f9 
ffff88011a8c7ad0
[    1.811040]  ffff88011a8c7ac0 ffffffff81043ece ffff88011a8c7b78 
0000000000000002
[    1.811042]  000000000000416d 0000000000000000 0000000000000000 
ffff88011a8c7b20
[    1.811042] Call Trace:
[    1.811046]  [<ffffffff8148d1f9>] dump_stack+0x45/0x56
[    1.811049]  [<ffffffff81043ece>] warn_slowpath_common+0x6e/0x90
[    1.811051]  [<ffffffff81043f67>] warn_slowpath_fmt+0x47/0x50
[    1.811053]  [<ffffffff811582ed>] __proc_create+0x18d/0x1a0
[    1.811054]  [<ffffffff811586f5>] proc_mkdir_data+0x35/0x70
[    1.811056]  [<ffffffff81158750>] proc_mkdir+0x10/0x20
[    1.811059]  [<ffffffff810887fc>] register_handler_proc+0xdc/0x100
[    1.811061]  [<ffffffff81085351>] __setup_irq+0x3e1/0x520
[    1.811064]  [<ffffffff813b8ed0>] ? 
saa7146_i2c_adapter_prepare+0xc0/0xc0
[    1.811066]  [<ffffffff81085762>] request_threaded_irq+0xc2/0x170
[    1.811068]  [<ffffffff813b947d>] saa7146_init_one+0x11d/0x830
[    1.811072]  [<ffffffff8123132c>] pci_device_probe+0x7c/0xe0
[    1.811076]  [<ffffffff812c788b>] driver_probe_device+0x8b/0x3d0
[    1.811078]  [<ffffffff812c7c9b>] __driver_attach+0x8b/0x90
[    1.811080]  [<ffffffff812c7c10>] ? __device_attach+0x40/0x40
[    1.811083]  [<ffffffff812c5ca3>] bus_for_each_dev+0x63/0xa0
[    1.811085]  [<ffffffff812c7d59>] driver_attach+0x19/0x20
[    1.811088]  [<ffffffff812c6738>] bus_add_driver+0x168/0x230
[    1.811091]  [<ffffffff818bf68c>] ? saa7146_vv_init_module+0x8/0x8
[    1.811092]  [<ffffffff812c840f>] driver_register+0x5f/0xf0
[    1.811095]  [<ffffffff812315d6>] __pci_register_driver+0x46/0x50
[    1.811097]  [<ffffffff813ba40c>] saa7146_register_extension+0x5c/0x80
[    1.811099]  [<ffffffff818bf69c>] budget_av_init+0x10/0x12
[    1.811101]  [<ffffffff8189afb6>] do_one_initcall+0xf9/0x183
[    1.811104]  [<ffffffff8105b8d8>] ? parse_args+0x128/0x440
[    1.811106]  [<ffffffff8189b152>] kernel_init_freeable+0x112/0x198
[    1.811109]  [<ffffffff8189a8cd>] ? initcall_blacklist+0xba/0xba
[    1.811112]  [<ffffffff81485a70>] ? rest_init+0x70/0x70
[    1.811113]  [<ffffffff81485a79>] kernel_init+0x9/0xf0
[    1.811117]  [<ffffffff81492dac>] ret_from_fork+0x7c/0xb0
[    1.811118]  [<ffffffff81485a70>] ? rest_init+0x70/0x70
[    1.811122] ---[ end trace 857c2d050441921d ]---
[    1.811126] saa7146: found saa7146 @ mem ffffc9000004e000 (revision 1, 
irq 18) (0x1894,0x0021)
[    1.811128] saa7146 (0): dma buffer size 192512
[    1.811129] DVB: registering new adapter (KNC1 DVB-C Plus)
[    1.888848] adapter failed MAC signature check
[    1.888854] encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff



