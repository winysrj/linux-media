Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from proxima.lp0.eu ([85.158.45.36] ident=exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@fire.lp0.eu>) id 1KHjWK-0001dV-VH
	for linux-dvb@linuxtv.org; Sat, 12 Jul 2008 20:08:35 +0200
Message-ID: <4878F314.6090608@simon.arlott.org.uk>
Date: Sat, 12 Jul 2008 19:08:20 +0100
From: Simon Arlott <simon@fire.lp0.eu>
MIME-Version: 1.0
To: Linux DVB <linux-dvb@linuxtv.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [linux-dvb] bug: saa7134_init run before v4l2_i2c_drv_init
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

(Hardware: SAA7134, TDA9887, MT2050, MT352)

tuner-core.c:tuner_probe doesn't auto-detect the MT20xx tuner
saa7134-cards.c:saa7134_board_init2 sets the tuner type for any unknown tuner

Normally when saa7134_init runs it calls for the tuner module before calling 
saa7134_board_init2, but if compiled in it will silently fail to set the tuner 
type because it is run before tuner_probe is called.

This used to work ok in 2.6.24, but doesn't in 2.6.26-rc9. I think 
c117d05cd4c09342f97ba1c6ef63f0bae3239a39 looks like it could have caused this, 
but I haven't tried reverting it.

I've tried to use subsys_init for v4l2_i2c_drv_init in include/media/v4l2-i2c-drv.h,
but it seems to have no effect and it's still loaded after saa7134.

If I rmmod tuner and modprobe it then it fails to work because saa7134_board_init2 
isn't there to set the tuner type - ideally the type should be stored during the 
init of saa7134 in such a way that tuner can refer to it when probing for devices 
(and saa7134 should still prod tuner for the situation where it's loaded later).


Kernel log with both compiled in:
(I've inserted a WARN_ON at the point where saa7134 is about to call 
saa7134_i2c_call_clients.)
[    1.716916] calling  videodev_init+0x0/0x7d
[    1.717030] Linux video capture interface: v2.00
[    1.717091] initcall videodev_init+0x0/0x7d returned 0 after 0 msecs

[    1.717091] calling  ir_init+0x0/0x14
[    1.717972] initcall ir_init+0x0/0x14 returned 0 after 0 msecs

[    1.718095] calling  saa7134_init+0x0/0x4a
[    1.718095] saa7130/34: v4l2 driver version 0.2.14 loaded
[    1.718095] ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [LNED] -> GSI 19 (level, low) -> IRQ 19
[    1.718095] saa7134[0]: found at 0000:05:00.0, rev: 1, irq: 19, latency: 64, mmio: 0xfeaffc00
[    1.718095] saa7134[0]: subsystem: 11bd:002d, board: Pinnacle PCTV 300i DVB-T + PAL [card=50,autodetected]
[    1.718104] saa7134[0]: board init: gpio is c806000
[    1.859741] saa7134[0]: i2c eeprom 00: bd 11 2d 00 f8 f8 1c 00 43 43 a9 1c 55 d2 b2 92
[    1.860128] saa7134[0]: i2c eeprom 10: 00 f0 04 04 ff 20 ff ff ff ff ff ff ff ff ff ff
[    1.860338] saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 01 08 ff 00 25 ff ff ff ff
[    1.860725] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.861108] saa7134[0]: i2c eeprom 40: ff 16 00 c0 86 3c 01 01 ff ff ff ff ff ff ff ff
[    1.861374] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.861793] saa7134[0]: i2c eeprom 60: 0c 22 17 44 03 11 e1 a1 ff ff ff ff ff ff ff ff
[    1.862177] saa7134[0]: i2c eeprom 70: 00 30 8d 18 3b 02 ff ff 74 50 ff ff ff ff ff ff
[    1.862851] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.863234] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.863608] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.864015] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.864389] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.864849] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.865222] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.865606] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    1.866770] ------------[ cut here ]------------
[    1.866770] WARNING: at drivers/media/video/saa7134/saa7134-cards.c:5659 saa7134_tuner_setup+0xc3/0x17a()
[    1.871794] Modules linked in:
[    1.871930] Pid: 1, comm: swapper Not tainted 2.6.26-rc9 #89
[    1.872035] 
[    1.872036] Call Trace:
[    1.872238]  [<ffffffff80230ffc>] warn_on_slowpath+0x58/0x86
[    1.872348]  [<ffffffff8023fde3>] ? call_usermodehelper_exec+0xb2/0xc2
[    1.872461]  [<ffffffff80240139>] ? request_module+0x14b/0x162
[    1.872802]  [<ffffffff80231b50>] ? printk+0x67/0x69
[    1.872802]  [<ffffffff803e0747>] saa7134_tuner_setup+0xc3/0x17a
[    1.872802]  [<ffffffff803e0e61>] ? saa7134_tuner_callback+0x0/0x182
[    1.872802]  [<ffffffff803e0e54>] saa7134_board_init2+0x656/0x663
[    1.872802]  [<ffffffff80499ef7>] ? i2c_master_recv+0x3c/0x4b
[    1.872802]  [<ffffffff803e291c>] ? saa7134_i2c_register+0x144/0x1bd
[    1.872806]  [<ffffffff805b7879>] saa7134_initdev+0x594/0x8ad
[    1.873037]  [<ffffffff8034b6f2>] pci_device_probe+0xb3/0x10c
[    1.873147]  [<ffffffff803b7054>] driver_probe_device+0xd9/0x169
[    1.873893]  [<ffffffff803b7133>] __driver_attach+0x4f/0x79
[    1.873893]  [<ffffffff803b70e4>] ? __driver_attach+0x0/0x79
[    1.873893]  [<ffffffff803b66c6>] bus_for_each_dev+0x4a/0x7b
[    1.873893]  [<ffffffff803b6e85>] driver_attach+0x1c/0x1e
[    1.873893]  [<ffffffff803b6b3c>] bus_add_driver+0xb7/0x20b
[    1.873893]  [<ffffffff803b730f>] driver_register+0x93/0x10a
[    1.873896]  [<ffffffff8034b975>] __pci_register_driver+0x50/0x8b
[    1.874037]  [<ffffffff803e1e96>] ? saa7134_init+0x0/0x4a
[    1.874133]  [<ffffffff803e1ede>] saa7134_init+0x48/0x4a
[    1.874910]  [<ffffffff807c1940>] kernel_init+0x147/0x29d
[    1.874910]  [<ffffffff8020c118>] child_rip+0xa/0x12
[    1.874910]  [<ffffffff807c17f9>] ? kernel_init+0x0/0x29d
[    1.874910]  [<ffffffff8020c10e>] ? child_rip+0x0/0x12
[    1.874910] 
[    1.874910] ---[ end trace d510dd024e67e971 ]---
[    1.876873] saa7134[0]: registered device video0 [v4l2]
[    1.876873] saa7134[0]: registered device vbi0
[    1.876873] initcall saa7134_init+0x0/0x4a returned 0 after 149 msecs

[    1.876873] calling  empress_register+0x0/0x12
[    1.876873] initcall empress_register+0x0/0x12 returned 0 after 0 msecs

[    1.876873] calling  saa6752hs_init_module+0x0/0x14
[    1.876873] initcall saa6752hs_init_module+0x0/0x14 returned 0 after 0 msecs

[    1.876873] calling  dvb_register+0x0/0x12
[    1.888880] DVB: registering new adapter (saa7134[0])
[    1.888991] DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
[    1.927841] initcall dvb_register+0x0/0x12 returned 0 after 39 msecs

[    1.927961] calling  v4l2_i2c_drv_init+0x0/0x104
[    1.930083] tda829x_probe: driver disabled by Kconfig
[    1.930193] tuner' 0-0043: chip found @ 0x86 (saa7134[0])
[    1.933311] tda9887 0-0043: creating new instance
[    1.933416] tda9887 0-0043: tda988[5/6/7] found
[    1.933521] tuner' 0-0043: type set to tda9887
[    1.933523] tuner' 0-0043: tv freq set to 0.00
[    1.933526] tuner' 0-0043: TV freq (0.00) out of range (44-958)
[    1.936050] tuner' 0-0043: saa7134[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
[    1.938047] tea5767_autodetection: not probed - driver disabled by Kconfig
[    1.938158] tuner' 0-0060: Setting mode_mask to 0x0e
[    1.938159] tuner' 0-0060: chip found @ 0xc0 (saa7134[0])
[    1.941516] tuner' 0-0060: tuner 0x60: Tuner type absent
[    1.944080] initcall v4l2_i2c_drv_init+0x0/0x104 returned 0 after 14 msecs


If saa7134 and tuner are modules then everything works ok:
(I've inserted a WARN_ON at the point where the tuner type is set, showing that 
it originates from saa7134_board_init2.)
[   15.408138] Linux video capture interface: v2.00
[   15.505111] saa7130/34: v4l2 driver version 0.2.14 loaded
[   15.506990] ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [LNED] -> GSI 19 (level, low) -> IRQ 19
[   15.506990] saa7134[0]: found at 0000:05:00.0, rev: 1, irq: 19, latency: 64, mmio: 0xfeaffc00
[   15.506990] saa7134[0]: subsystem: 11bd:002d, board: Pinnacle PCTV 300i DVB-T + PAL [card=50,autodetected]
[   15.506990] saa7134[0]: board init: gpio is c806000
[   15.666434] saa7134[0]: i2c eeprom 00: bd 11 2d 00 f8 f8 1c 00 43 43 a9 1c 55 d2 b2 92
[   15.666443] saa7134[0]: i2c eeprom 10: 00 f0 04 04 ff 20 ff ff ff ff ff ff ff ff ff ff
[   15.666450] saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 01 08 ff 00 25 ff ff ff ff
[   15.666460] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666466] saa7134[0]: i2c eeprom 40: ff 16 00 c0 86 3c 01 01 ff ff ff ff ff ff ff ff
[   15.666472] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666478] saa7134[0]: i2c eeprom 60: 0c 22 17 44 03 11 e1 a1 ff ff ff ff ff ff ff ff
[   15.666484] saa7134[0]: i2c eeprom 70: 00 30 8d 18 3b 02 ff ff 74 50 ff ff ff ff ff ff
[   15.666491] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666497] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666506] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666512] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666522] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666528] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666538] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.666544] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.721796] tda829x_probe: driver disabled by Kconfig
[   15.721801] tuner' 2-0043: chip found @ 0x86 (saa7134[0])
[   15.721805] tda9887 2-0043: creating new instance
[   15.721807] tda9887 2-0043: tda988[5/6/7] found
[   15.721809] tuner' 2-0043: type set to tda9887
[   15.721811] tuner' 2-0043: tv freq set to 0.00
[   15.721813] tuner' 2-0043: TV freq (0.00) out of range (44-958)
[   15.723788] tuner' 2-0043: saa7134[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
[   15.725786] tea5767_autodetection: not probed - driver disabled by Kconfig
[   15.725788] tuner' 2-0060: Setting mode_mask to 0x0e
[   15.725790] tuner' 2-0060: chip found @ 0xc0 (saa7134[0])
[   15.725792] tuner' 2-0060: tuner 0x60: Tuner type absent
[   15.728089] ------------[ cut here ]------------
[   15.728089] WARNING: at drivers/media/video/tuner-core.c:769 tuner_command+0x10c/0x1063 [tuner]()
[   15.728089] Modules linked in: tuner tda9887 mt20xx saa7134(+) compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c ir_common fglrx(P) tveeprom
[   15.728089] Pid: 1869, comm: modprobe Tainted: P          2.6.26-rc9 #86
[   15.728089] 
[   15.728089] Call Trace:
[   15.728089]  [<ffffffff8022fdb9>] warn_on_slowpath+0x51/0x79
[   15.728089]  [<ffffffff8057ac1c>] schedule_timeout+0x1e/0xad
[   15.728089]  [<ffffffff8024173e>] autoremove_wake_function+0x9/0x2e
[   15.728089]  [<ffffffff80226666>] __wake_up_common+0x41/0x74
[   15.728089]  [<ffffffff80226d62>] __wake_up+0x38/0x4f
[   15.728089]  [<ffffffffa023c465>] :tuner:tuner_command+0x10c/0x1063
[   15.728089]  [<ffffffff8023e093>] call_usermodehelper_exec+0xac/0xba
[   15.728089]  [<ffffffff8045c836>] i2c_cmd+0x0/0x3e
[   15.728089]  [<ffffffff8045c86d>] i2c_cmd+0x37/0x3e
[   15.728089]  [<ffffffff803a4d71>] device_for_each_child+0x22/0x4d
[   15.728089]  [<ffffffff80230851>] printk+0x4e/0x56
[   15.728089]  [<ffffffff8045b101>] i2c_clients_command+0x1f/0x24
[   15.728089]  [<ffffffffa020d0ca>] :saa7134:saa7134_tuner_setup+0xca/0x175
[   15.728089]  [<ffffffffa020d7ff>] :saa7134:saa7134_tuner_callback+0x0/0x178
[   15.728089]  [<ffffffffa020d7f4>] :saa7134:saa7134_board_init2+0x67f/0x68a
[   15.728089]  [<ffffffff8045baf3>] i2c_master_recv+0x3a/0x46
[   15.728089]  [<ffffffffa020f216>] :saa7134:saa7134_i2c_register+0x135/0x1ad
[   15.728089]  [<ffffffff8057ac83>] schedule_timeout+0x85/0xad
[   15.728089]  [<ffffffffa02161d7>] :saa7134:saa7134_initdev+0x59d/0x8dc
[   15.728089]  [<ffffffff8033fdc4>] pci_device_probe+0xa9/0xf8
[   15.728089]  [<ffffffff803a71c3>] driver_probe_device+0xd7/0x164
[   15.728089]  [<ffffffff803a7296>] __driver_attach+0x46/0x6d
[   15.728089]  [<ffffffff803a7250>] __driver_attach+0x0/0x6d
[   15.728089]  [<ffffffff803a68ab>] bus_for_each_dev+0x44/0x6f
[   15.728089]  [<ffffffffa01ed458>] :videobuf_core:videobuf_mmap_free+0x0/0x2b
[   15.728089]  [<ffffffff803a6ce1>] bus_add_driver+0xb4/0x203
[   15.728089]  [<ffffffff803a7447>] driver_register+0x8d/0x101
[   15.728089]  [<ffffffff80340025>] __pci_register_driver+0x47/0x7a
[   15.728089]  [<ffffffff80250208>] sys_init_module+0x9b/0x1a9
[   15.728089]  [<ffffffff8020b14b>] system_call_after_swapgs+0x7b/0x80
[   15.728089] 
[   15.728089] ---[ end trace dbce26c647b7fcc0 ]---
[   15.728089] tuner' 2-0043: Calling set_type_addr for type=33, addr=0xff, mode=0x0e, config=0x00
[   15.728089] tuner' 2-0043: set addr discarded for type 74, mask e. Asked to change tuner at addr 0xff, with mask e
[   15.728089] ------------[ cut here ]------------
[   15.728089] WARNING: at drivers/media/video/tuner-core.c:769 tuner_command+0x10c/0x1063 [tuner]()
[   15.728089] Modules linked in: tuner tda9887 mt20xx saa7134(+) compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c ir_common fglrx(P) tveeprom
[   15.728089] Pid: 1869, comm: modprobe Tainted: P        W 2.6.26-rc9 #86
[   15.728089] 
[   15.728089] Call Trace:
[   15.728089]  [<ffffffff8022fdb9>] warn_on_slowpath+0x51/0x79
[   15.728089]  [<ffffffff80230851>] printk+0x4e/0x56
[   15.728089]  [<ffffffff8057ac1c>] schedule_timeout+0x1e/0xad
[   15.728089]  [<ffffffff80226d62>] __wake_up+0x38/0x4f
[   15.728089]  [<ffffffffa023c465>] :tuner:tuner_command+0x10c/0x1063
[   15.728089]  [<ffffffff8045c836>] i2c_cmd+0x0/0x3e
[   15.728089]  [<ffffffff8045c86d>] i2c_cmd+0x37/0x3e
[   15.728089]  [<ffffffff803a4d71>] device_for_each_child+0x22/0x4d
[   15.728089]  [<ffffffff80230851>] printk+0x4e/0x56
[   15.728089]  [<ffffffff8045b101>] i2c_clients_command+0x1f/0x24
[   15.728089]  [<ffffffffa020d0ca>] :saa7134:saa7134_tuner_setup+0xca/0x175
[   15.728089]  [<ffffffffa020d7ff>] :saa7134:saa7134_tuner_callback+0x0/0x178
[   15.728089]  [<ffffffffa020d7f4>] :saa7134:saa7134_board_init2+0x67f/0x68a
[   15.728089]  [<ffffffff8045baf3>] i2c_master_recv+0x3a/0x46
[   15.728089]  [<ffffffffa020f216>] :saa7134:saa7134_i2c_register+0x135/0x1ad
[   15.728089]  [<ffffffff8057ac83>] schedule_timeout+0x85/0xad
[   15.728089]  [<ffffffffa02161d7>] :saa7134:saa7134_initdev+0x59d/0x8dc
[   15.728089]  [<ffffffff8033fdc4>] pci_device_probe+0xa9/0xf8
[   15.728089]  [<ffffffff803a71c3>] driver_probe_device+0xd7/0x164
[   15.728089]  [<ffffffff803a7296>] __driver_attach+0x46/0x6d
[   15.728089]  [<ffffffff803a7250>] __driver_attach+0x0/0x6d
[   15.728089]  [<ffffffff803a68ab>] bus_for_each_dev+0x44/0x6f
[   15.728089]  [<ffffffffa01ed458>] :videobuf_core:videobuf_mmap_free+0x0/0x2b
[   15.728089]  [<ffffffff803a6ce1>] bus_add_driver+0xb4/0x203
[   15.728089]  [<ffffffff803a7447>] driver_register+0x8d/0x101
[   15.728089]  [<ffffffff80340025>] __pci_register_driver+0x47/0x7a
[   15.728089]  [<ffffffff80250208>] sys_init_module+0x9b/0x1a9
[   15.728089]  [<ffffffff8020b14b>] system_call_after_swapgs+0x7b/0x80
[   15.728089] 
[   15.728089] ---[ end trace dbce26c647b7fcc0 ]---
[   15.728089] tuner' 2-0060: Calling set_type_addr for type=33, addr=0xff, mode=0x0e, config=0x00
[   15.728089] tuner' 2-0060: defining GPIO callback
[   15.739273] mt20xx 2-0060: microtune: companycode=3cbf part=42 rev=22
[   15.747800] mt20xx 2-0060: microtune MT2050 found, OK
[   15.747803] tuner' 2-0060: type set to MT2050
[   15.747806] tuner' 2-0060: tv freq set to 400.00
[   15.752795] tuner' 2-0060: saa7134[0] tuner' I2C addr 0xc0 with type 33 used for 0x0e
[   15.754532] tuner' 2-0043: switching to v4l2
[   15.754534] tuner' 2-0060: switching to v4l2
[   15.754536] tuner' 2-0060: tv freq set to 400.00
[   15.759525] tuner' 2-0060: tv freq set to 400.00
[   15.765272] saa7134[0]: registered device video0 [v4l2]
[   15.765272] saa7134[0]: registered device vbi0
[   15.765272] tuner' 2-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
[   15.768097] tuner' 2-0060: Cmd TUNER_SET_STANDBY accepted for analog TV
[   15.836381] DVB: registering new adapter (saa7134[0])
[   15.836386] DVB: registering frontend 0 (Zarlink MT352 DVB-T)...

If I have tuner already loaded, tuner_probe is run while initialising saa7134:
[  233.930597] saa7130/34: v4l2 driver version 0.2.14 loaded
[  233.931449] saa7134[0]: found at 0000:05:00.0, rev: 1, irq: 19, latency: 64, mmio: 0xfeaffc00
[  233.931651] saa7134[0]: subsystem: 11bd:002d, board: Pinnacle PCTV 300i DVB-T + PAL [card=50,autodetected]
[  233.931674] saa7134[0]: board init: gpio is c80e000
[  234.056662] tda829x_probe: driver disabled by Kconfig
[  234.056794] tuner' 2-0043: chip found @ 0x86 (saa7134[0])
[  234.056906] tda9887 2-0043: creating new instance
[  234.056911] tda9887 2-0043: tda988[5/6/7] found
[  234.056914] tuner' 2-0043: type set to tda9887
[  234.056918] tuner' 2-0043: tv freq set to 0.00
[  234.056922] tuner' 2-0043: TV freq (0.00) out of range (44-958)
[  234.060656] tuner' 2-0043: saa7134[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
[  234.062634] tea5767_autodetection: not probed - driver disabled by Kconfig
[  234.062762] tuner' 2-0060: Setting mode_mask to 0x0e
[  234.062866] tuner' 2-0060: chip found @ 0xc0 (saa7134[0])
[  234.063006] tuner' 2-0060: tuner 0x60: Tuner type absent
[  234.104185] saa7134[0]: i2c eeprom 00: bd 11 2d 00 f8 f8 1c 00 43 43 a9 1c 55 d2 b2 92
[  234.104654] saa7134[0]: i2c eeprom 10: 00 f0 04 04 ff 20 ff ff ff ff ff ff ff ff ff ff
[  234.104661] saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 01 08 ff 00 25 ff ff ff ff
[  234.104665] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104669] saa7134[0]: i2c eeprom 40: ff 16 00 c0 86 3c 01 01 ff ff ff ff ff ff ff ff
[  234.104673] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104678] saa7134[0]: i2c eeprom 60: 0c 22 17 44 03 11 e1 a1 ff ff ff ff ff ff ff ff
[  234.104682] saa7134[0]: i2c eeprom 70: 00 30 8d 18 3b 02 ff ff 74 50 ff ff ff ff ff ff
[  234.104686] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104690] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104694] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104698] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104702] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104706] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104711] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  234.104715] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

-- 
Simon Arlott

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
