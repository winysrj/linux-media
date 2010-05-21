Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:3463 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934253Ab0EUSlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 14:41:35 -0400
Message-ID: <4BF6CF82.1080704@unsolicited.net>
Date: Fri, 21 May 2010 19:22:58 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Warning when loading technisat driver (2.6.34)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just upgraded my media box, and get the following warning on
startup. All seems well otherwise, so this is a FYI

Cheers


May 21 19:05:54 server kernel: [    7.950291] ------------[ cut here
]------------
May 21 19:05:54 server kernel: [    7.950296] WARNING: at
fs/proc/generic.c:317 __xlate_proc_name+0xa5/0xd0()
May 21 19:05:54 server kernel: [    7.950298] Hardware name: System
Product Name
May 21 19:05:54 server kernel: [    7.950299] name 'Technisat/B2C2
FlexCop II/IIb/III Digital TV PCI Driver'
May 21 19:05:54 server kernel: [    7.950300] Modules linked in:
b2c2_flexcop_pci(+) snd_hda_codec dvb_usb snd_pcm pl2303 ppdev crc_ccitt
tulip b2c2_flexcop snd_timer snd soundcore r8169 ohci1394 parport_pc
dvb_core shpchp mii i2c_piix4 ieee1394 parport cx24123 cx24113 s5h1420
k10temp snd_page_alloc pcspkr isdn
May 21 19:05:54 server kernel: [    7.950311] Pid: 942, comm: modprobe
Not tainted 2.6.34 #1
May 21 19:05:54 server kernel: [    7.950312] Call Trace:
May 21 19:05:54 server kernel: [    7.950316]  [<ffffffff81166865>] ?
__xlate_proc_name+0xa5/0xd0
May 21 19:05:54 server kernel: [    7.950319]  [<ffffffff81048678>]
warn_slowpath_common+0x78/0xd0
May 21 19:05:54 server kernel: [    7.950322]  [<ffffffff81048754>]
warn_slowpath_fmt+0x64/0x70
May 21 19:05:54 server kernel: [    7.950325]  [<ffffffff81263a79>] ?
snprintf+0x59/0x60
May 21 19:05:54 server kernel: [    7.950327]  [<ffffffff81166865>]
__xlate_proc_name+0xa5/0xd0
May 21 19:05:54 server kernel: [    7.950329]  [<ffffffff81166e24>]
__proc_create+0x74/0x150
May 21 19:05:54 server kernel: [    7.950331]  [<ffffffff81167739>]
proc_mkdir_mode+0x29/0x60
May 21 19:05:54 server kernel: [    7.950333]  [<ffffffff81167781>]
proc_mkdir+0x11/0x20
May 21 19:05:54 server kernel: [    7.950336]  [<ffffffff810a7914>]
register_handler_proc+0xf4/0x120
May 21 19:05:54 server kernel: [    7.950338]  [<ffffffff810a53c9>]
__setup_irq+0x1d9/0x350
May 21 19:05:54 server kernel: [    7.950341]  [<ffffffffa01bb190>] ?
flexcop_pci_isr+0x0/0x190 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950343]  [<ffffffff810a56cb>]
request_threaded_irq+0x18b/0x210
May 21 19:05:54 server kernel: [    7.950347]  [<ffffffffa01bb4ae>]
flexcop_pci_probe+0x18e/0x360 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950349]  [<ffffffff812776c2>]
local_pci_probe+0x12/0x20
May 21 19:05:54 server kernel: [    7.950351]  [<ffffffff81278790>]
pci_device_probe+0x80/0xa0
May 21 19:05:54 server kernel: [    7.950354]  [<ffffffff81305b93>] ?
driver_sysfs_add+0x63/0x90
May 21 19:05:54 server kernel: [    7.950356]  [<ffffffff81305cd2>]
driver_probe_device+0x92/0x1a0
May 21 19:05:54 server kernel: [    7.950359]  [<ffffffff81305e73>]
__driver_attach+0x93/0xa0
May 21 19:05:54 server kernel: [    7.950361]  [<ffffffff81305de0>] ?
__driver_attach+0x0/0xa0
May 21 19:05:54 server kernel: [    7.950363]  [<ffffffff81305403>]
bus_for_each_dev+0x63/0x90
May 21 19:05:54 server kernel: [    7.950365]  [<ffffffff81305b2c>]
driver_attach+0x1c/0x20
May 21 19:05:54 server kernel: [    7.950367]  [<ffffffff81304c15>]
bus_add_driver+0x1a5/0x2e0
May 21 19:05:54 server kernel: [    7.950369]  [<ffffffffa01bf000>] ?
flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950371]  [<ffffffff81306179>]
driver_register+0x79/0x160
May 21 19:05:54 server kernel: [    7.950374]  [<ffffffffa01bf000>] ?
flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950376]  [<ffffffff81278a2a>]
__pci_register_driver+0x5a/0xe0
May 21 19:05:54 server kernel: [    7.950378]  [<ffffffffa01bf000>] ?
flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950381]  [<ffffffffa01bf01e>]
flexcop_pci_module_init+0x1e/0x20 [b2c2_flexcop_pci]
May 21 19:05:54 server kernel: [    7.950383]  [<ffffffff810001d8>]
do_one_initcall+0x38/0x190
May 21 19:05:54 server kernel: [    7.950386]  [<ffffffff8108130d>]
sys_init_module+0xdd/0x260
May 21 19:05:54 server kernel: [    7.950388]  [<ffffffff81002e2b>]
system_call_fastpath+0x16/0x1b
May 21 19:05:54 server kernel: [    7.950389] ---[ end trace
da2237741ef2a8c0 ]---

