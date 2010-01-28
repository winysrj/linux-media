Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:29009 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0A1CEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 21:04:02 -0500
Received: by fg-out-1718.google.com with SMTP id l26so115476fgb.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 18:04:00 -0800 (PST)
Date: Thu, 28 Jan 2010 11:09:41 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and =?UTF-8?B?w4PCjsOCwrxQRDYxMTUx?= MPEG2 coder
Message-ID: <20100128110941.47fda876@glory.loctelecom.ru>
In-Reply-To: <201001271214.01837.hverkuil@xs4all.nl>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	<201001130838.23949.hverkuil@xs4all.nl>
	<20100127143637.26465503@glory.loctelecom.ru>
	<201001271214.01837.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HIi Hans

> Hi Dmitri,
> 
> Just a quick note: the video4linux mailinglist is obsolete, just use
> linux-media.

OK

> On Wednesday 27 January 2010 06:36:37 Dmitri Belimov wrote:
> > Hi Hans.
> > 
> > I finished saa7134 part of SPI. Please review saa7134-spi.c and
> > diff saa7134-core and etc. I wrote config of SPI to board
> > structure. Use this config for register master and slave devices.
> > 
> > SPI other then I2C, do not need call request_module. Udev do it. 
> > I spend 10 days for understanding :(  
> 
> I'm almost certain that spi works the same way as i2c and that means
> that you must call request_module. Yes, udev will load it for you,
> but that is a delayed load: i.e. the module may not be loaded when we
> need it. The idea behind this is that usually i2c or spi modules are
> standalone, but in the context of v4l such modules are required to be
> present before the bridge can properly configure itself.
> 
> The easiest way to ensure the correct load sequence is to do a
> request_module at the start.
> 
> Now, I haven't compiled this, but I think this will work:
> 
> struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
>                struct spi_master *master, struct spi_board_info *info)
> {
> 	struct v4l2_subdev *sd = NULL;
>         struct spi_device *spi;
> 	
> 	BUG_ON(!v4l2_dev);
> 
> 	if (module_name)
>         	request_module(module_name);
> 
> 	spi = spi_new_device(master, info);
> 
> 	if (spi == NULL || spi->dev.driver == NULL)
> 		goto error;
> 
>        if (!try_module_get(spi->dev.driver->owner))
>                goto error;
> 
>        sd = spi_get_drvdata(spi);
> 
>        /* Register with the v4l2_device which increases the module's
>           use count as well. */
> 
>        if (v4l2_device_register_subdev(v4l2_dev, sd))
>                sd = NULL;
> 
>        /* Decrease the module use count to match the first
> try_module_get. */ module_put(spi->dev.driver->owner);
> 
> error:
>        /* If we have a client but no subdev, then something went
> wrong and we must unregister the client. */
> 
>        if (spi && sd == NULL)
>                spi_unregister_device(spi);
> 
>        return sd;
> }
> EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);

Not work

[    6.048195] Linux video capture interface: v2.00
[    6.112987] saa7130/34: v4l2 driver version 0.2.15 loaded
[    6.113067] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.113117] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[    6.113176] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[    6.113241] saa7133[0]: board init: gpio is 200000
[    6.113292] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.264512] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    6.265136] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.265731] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.266327] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.266922] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.267517] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.268113] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.268718] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.269313] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.269908] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.270503] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.271098] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.271693] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.272289] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.272895] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[    6.273490] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[    6.360023] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[    6.401952] xc5000 1-0061: creating new instance
[    6.412005] xc5000: Successfully identified at address 0x61
[    6.412054] xc5000: Firmware has not been loaded previously
[    6.477742] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.477816] HDA Intel 0000:00:1b.0: setting latency timer to 64

[   34.752763] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[   34.752823] saa7133[0]: found muPD61151 MPEG encoder
[   34.752883] befor request_module

[  240.476013] INFO: task modprobe:1404 blocked for more than 120 seconds.
[  240.476016] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.476018] modprobe      D f6b913c0     0  1404      1
[  240.476021]  c200f0c0 00000086 00989680 f6b913c0 c011b1fd c043f0c0 00000003 00000000
[  240.476027]  f711faa0 f711fc54 00000000 0001ecac 176f9ddf 00000008 f711facc f711faa0
[  240.476031]  f7070490 c011cc8e 00000000 c200f0c0 c02ff658 00000001 f7070490 00000046
[  240.476036] Call Trace:
[  240.476042]  [<c011b1fd>] ? wakeup_preempt_entity+0xf0/0x110
[  240.476046]  [<c011cc8e>] ? check_preempt_wakeup+0x139/0x173
[  240.476050]  [<c02f6984>] ? schedule+0x5/0x13
[  240.476052]  [<c02f6ab0>] ? schedule_timeout+0x15/0x16a
[  240.476055]  [<c011bba4>] ? __wake_up_common+0x34/0x59
[  240.476057]  [<c011c477>] ? __wake_up+0x29/0x39
[  240.476060]  [<c02f6069>] ? wait_for_common+0xba/0x115
[  240.476063]  [<c0122170>] ? default_wake_function+0x0/0x8
[  240.476067]  [<c0133e10>] ? call_usermodehelper_exec+0x6e/0xae
[  240.476069]  [<c0133fd5>] ? __request_module+0xdb/0xee
[  240.476076]  [<f847c647>] ? spi_bitbang_setup+0xe7/0xfb [spi_bitbang]
[  240.476082]  [<f84c8f3b>] ? v4l2_spi_new_subdev_board+0x2e/0x35 [v4l2_common]
[  240.476086]  [<f84c8fa6>] ? v4l2_spi_new_subdev+0x64/0x6c [v4l2_common]
[  240.476099]  [<f852c0b5>] ? saa7134_initdev+0x6dd/0xa96 [saa7134]
[  240.476103]  [<c0213045>] ? local_pci_probe+0xb/0xc
[  240.476105]  [<c02139bd>] ? pci_device_probe+0x41/0x63
[  240.476109]  [<c026d03c>] ? driver_probe_device+0x76/0xfe
[  240.476112]  [<c026d104>] ? __driver_attach+0x40/0x5b
[  240.476115]  [<c026cad8>] ? bus_for_each_dev+0x37/0x5f
[  240.476117]  [<c026cf23>] ? driver_attach+0x11/0x13
[  240.476120]  [<c026d0c4>] ? __driver_attach+0x0/0x5b
[  240.476122]  [<c026c56a>] ? bus_add_driver+0xcb/0x1ee
[  240.476131]  [<f854b000>] ? saa7134_init+0x0/0x3b [saa7134]
[  240.476134]  [<c026d31f>] ? driver_register+0x87/0xe0
[  240.476143]  [<f854b000>] ? saa7134_init+0x0/0x3b [saa7134]
[  240.476146]  [<c0213cf5>] ? __pci_register_driver+0x33/0x8a
[  240.476154]  [<f854b000>] ? saa7134_init+0x0/0x3b [saa7134]
[  240.476157]  [<c010112d>] ? do_one_initcall+0x44/0x111
[  240.476160]  [<c016107f>] ? tracepoint_module_notify+0x21/0x24
[  240.476164]  [<c013a5b6>] ? notifier_call_chain+0x2a/0x47
[  240.476167]  [<c013a80b>] ? __blocking_notifier_call_chain+0x3f/0x49
[  240.476171]  [<c0147a67>] ? sys_init_module+0x87/0x187
[  240.476173]  [<c0102f74>] ? sysenter_do_call+0x12/0x28
[  240.476177] INFO: task modprobe:1705 blocked for more than 120 seconds.
[  240.476178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.476180] modprobe      D f6a54040     0  1705   1704
[  240.476182]  c200f0c0 00000082 c0202b29 f6a54040 c04b8eb0 c043f0c0 c019c7f4 00000001
[  240.476187]  f7188450 f7188604 00000000 c04b8ea0 1894fb69 00000008 00000001 f7020774
[  240.476192]  c0202998 f68e7e68 c04b8ea0 00000006 00000001 00000000 ffffffc1 00000001
[  240.476196] Call Trace:
[  240.476199]  [<c0202b29>] ? ida_get_new_above+0xd4/0x178
[  240.476203]  [<c019c7f4>] ? find_inode+0x1b/0x56
[  240.476205]  [<c0202998>] ? idr_get_empty_slot+0x145/0x202
[  240.476208]  [<c0202b29>] ? ida_get_new_above+0xd4/0x178
[  240.476211]  [<c02f6984>] ? schedule+0x5/0x13
[  240.476213]  [<c02f6ab0>] ? schedule_timeout+0x15/0x16a
[  240.476216]  [<c019c44c>] ? iput+0x21/0x4a
[  240.476219]  [<c01cad13>] ? sysfs_addrm_finish+0x46/0x1a6
[  240.476221]  [<c01caa40>] ? sysfs_add_one+0x10/0xad
[  240.476224]  [<c02f761e>] ? __down+0x4e/0x73
[  240.476227]  [<c013a54c>] ? down+0x1f/0x2a
[  240.476229]  [<c026d0eb>] ? __driver_attach+0x27/0x5b
[  240.476232]  [<c026cad8>] ? bus_for_each_dev+0x37/0x5f
[  240.476234]  [<c026cf23>] ? driver_attach+0x11/0x13
[  240.476237]  [<c026d0c4>] ? __driver_attach+0x0/0x5b
[  240.476239]  [<c026c56a>] ? bus_add_driver+0xcb/0x1ee
[  240.476243]  [<f874f000>] ? init_upd61151+0x0/0xa [upd61151]
[  240.476245]  [<c026d31f>] ? driver_register+0x87/0xe0
[  240.476248]  [<f874f000>] ? init_upd61151+0x0/0xa [upd61151]
[  240.476250]  [<c010112d>] ? do_one_initcall+0x44/0x111
[  240.476253]  [<c016107f>] ? tracepoint_module_notify+0x21/0x24
[  240.476256]  [<c013a5b6>] ? notifier_call_chain+0x2a/0x47
[  240.476259]  [<c013a80b>] ? __blocking_notifier_call_chain+0x3f/0x49
[  240.476261]  [<c0147a67>] ? sys_init_module+0x87/0x187
[  240.476264]  [<c0102f74>] ? sysenter_do_call+0x12/0x28
[  240.476267]  [<c013007b>] ? prepare_signal+0x10f/0x184
[  240.476269]  [<c0130000>] ? prepare_signal+0x94/0x184

Module not load successfull. As I see spi_register_driver in upd61151.c not finished a long long long time
and killed by kernel. I see this message last 10 days befor removing request_module from function.

> Note that you mixed up the spi master and spi client in your original
> code. So it is no wonder you experienced crashes.

Yes, this is my error you are right. :((

         struct spi_device *spi;
 	
 
 	spi = spi_new_device(master, info);

> And in v4l2_spi_subdev_init() you should use spi_set_drvdata instead
> of dev_set_drvdata.

Ok

> I hope this helps.

Thank you.
 
> Regards,
> 
> 	Hans
> 
> > 
> > I need help with v4l2-common.c -> function v4l2_spi_new_subdev_board
> > The module of SPI slave loading after some time and spi device
> > hasn't v4l2_subdev structure for v4l2_device_register_subdev.
> > 
> > Now I get kernel crash when call v4l2_device_register_subdev.
> > 
> > Need use a callback metod or other. I don't know.
> > 
> > Copy to Mauro Carvalho Chehab and mailing lists for review my code
> > too.
> > 
> > Dmesg log without call v4l2_device_register_subdev.
> > [    4.742279] Linux video capture interface: v2.00
> > [    4.816171] saa7130/34: v4l2 driver version 0.2.15 loaded
> > [    4.816253] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level,
> > low) -> IRQ 19 [    4.816304] saa7133[0]: found at 0000:04:01.0,
> > rev: 209, irq: 19, latency: 32, mmio: 0xe5100000 [    4.816363]
> > saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7
> > [card=171,autodetected] [    4.816430] saa7133[0]: board init: gpio
> > is 200000 [    4.816481] IRQ 19/saa7133[0]: IRQF_DISABLED is not
> > guaranteed on shared IRQs [    4.976010] saa7133[0]: i2c eeprom 00:
> > ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01 [    4.976635]
> > saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff ff ff [    4.977231] saa7133[0]: i2c eeprom 20: ff ff ff ff ff
> > ff ff ff ff ff ff ff ff ff ff ff [    4.977827] saa7133[0]: i2c
> > eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [    4.978423] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff ff [    4.979019] saa7133[0]: i2c eeprom 50:
> > ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff [    4.979615]
> > saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff ff ff [    4.980223] saa7133[0]: i2c eeprom 70: ff ff ff ff ff
> > ff ff ff ff ff ff ff ff ff ff ff [    4.980820] saa7133[0]: i2c
> > eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [    4.981416] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff ff [    4.982012] saa7133[0]: i2c eeprom a0:
> > ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff [    4.982608]
> > saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff ff ff [    4.983204] saa7133[0]: i2c eeprom c0: ff ff ff ff ff
> > ff ff ff ff ff ff ff ff ff ff ff [    4.983800] saa7133[0]: i2c
> > eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [    4.984437] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff
> > ff ff ff ff ff ff ff ff [    4.985033] saa7133[0]: i2c eeprom f0:
> > 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff [    5.008041]
> > tuner 1-0061: chip found @ 0xc2 (saa7133[0]) [    5.024036] HDA
> > Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > [    5.024109] HDA Intel 0000:00:1b.0: setting latency timer to 64
> > [    5.066725] xc5000 1-0061: creating new instance [    5.076009]
> > xc5000: Successfully identified at address 0x61 [    5.076060]
> > xc5000: Firmware has not been loaded previously
> > 
> > [   33.381216] saa7134 0000:04:01.0: spi master registered:
> > bus_num=32766 num_chipselect=1 [   33.381274] saa7133[0]: found
> > muPD61151 MPEG encoder [   33.381430] saa7133[0]: registered device
> > video0 [v4l2] [   33.381491] saa7133[0]: registered device vbi0
> > [   33.381551] saa7133[0]: registered device radio0
> > [   33.406256] saa7133[0]: registered device video1 [mpeg]
> > [   33.407628] upd61151_probe function
> > [   33.407672] Read test REG 0xD8 :
> > [   33.409502] REG = 0x0
> > [   33.409547] Write test 0x03 to REG 0xD8 :
> > [   33.411353] Next read test REG 0xD8 :
> > [   33.413176] REG = 0x3
> > [   33.431308] saa7134 ALSA driver for DMA sound loaded
> > [   33.431363] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed
> > on shared IRQs [   33.431425] saa7133[0]/alsa: saa7133[0] at
> > 0xe5100000 irq 19 registered as card -1
> > 
> > [   48.657067] xc5000: I2C write failed (len=4)
> > [   48.760018] xc5000: I2C write failed (len=4)
> > [   48.762960] xc5000: I2C read failed
> > [   48.763011] xc5000: I2C read failed
> > [   48.763054] xc5000: waiting for firmware upload
> > (dvb-fe-xc5000-1.6.114.fw)... [   48.763102] saa7134 0000:04:01.0:
> > firmware: requesting dvb-fe-xc5000-1.6.114.fw [   48.802473]
> > xc5000: firmware read 12401 bytes. [   48.802477] xc5000: firmware
> > uploading... [   49.328504] eth0: no IPv6 routers present
> > [   52.132007] xc5000: firmware upload complete...
> > [   53.366772] ------------[ cut here ]------------
> > [   53.366820] kernel BUG at lib/kernel_lock.c:126!
> > [   53.366865] invalid opcode: 0000 [#1] SMP 
> > [   53.366973] last sysfs
> > file: /sys/class/firmware/0000:04:01.0/loading [   53.367019]
> > Modules linked in: ipv6 dm_snapshot dm_mirror dm_region_hash dm_log
> > dm_mod loop saa7134_alsa upd61151 saa7134_empress ir_kbd_i2c
> > snd_hda_codec_realtek xc5000 snd_hda_intel snd_hda_codec tuner
> > snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
> > snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq saa7134
> > snd_timer ir_common v4l2_common videodev snd_seq_device v4l1_compat
> > videobuf_dma_sg videobuf_core spi_bitbang psmouse snd ir_core
> > serio_raw tveeprom soundcore parport_pc parport processor i2c_i801
> > button snd_page_alloc i2c_core intel_agp agpgart rng_core pcspkr
> > evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix
> > libata scsi_mod ide_pci_generic ide_core ehci_hcd uhci_hcd r8169
> > mii usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> > [   53.369624] [   53.369666] Pid: 2659, comm: hald-probe-vide Not
> > tainted (2.6.30.5 #1) G31M-ES2L [   53.369721] EIP:
> > 0060:[<c02f81e3>] EFLAGS: 00010286 CPU: 0 [   53.369770] EIP is at
> > unlock_kernel+0xd/0x24 [   53.369814] EAX: f6bc26ac EBX: f6bc2000
> > ECX: f6bc26ac EDX: f707e4d0 [   53.369860] ESI: 00000000 EDI:
> > f6aa90c0 EBP: f6bc26ac ESP: f65b1e68 [   53.369906]  DS: 007b ES:
> > 007b FS: 00d8 GS: 0033 SS: 0068 [   53.369952] Process
> > hald-probe-vide (pid: 2659, ti=f65b0000 task=f707e4d0
> > task.ti=f65b0000) [   53.370008] Stack: [   53.370049]  f873e9c9
> > 00000000 f687c804 f6aa90c0 00000000 f848e309 00000000 f6b4d680
> > [   53.370298]  f6b4d680 c0190049 f6aa90c0 f6a144e4 00000000
> > f6aa90c0 00000000 f6a144e4 [   53.370298]  c018ff24 c018c3b9
> > f701ef40 f6d11a5c f6aa90c0 f65b1f0c f65b1f0c 00008001
> > [   53.370298] Call Trace: [   53.370298]  [<f873e9c9>] ?
> > ts_open+0x8c/0x93 [saa7134_empress] [   53.370298]  [<f848e309>] ?
> > v4l2_open+0x65/0x78 [videodev] [   53.370298]  [<c0190049>] ?
> > chrdev_open+0x125/0x13c [   53.370298]  [<c018ff24>] ?
> > chrdev_open+0x0/0x13c [   53.370298]  [<c018c3b9>] ?
> > __dentry_open+0x119/0x208 [   53.370298]  [<c018c539>] ?
> > nameidata_to_filp+0x29/0x3c [   53.370298]  [<c0197338>] ?
> > do_filp_open+0x41e/0x7bc [   53.370298]  [<c017bb3c>] ?
> > handle_mm_fault+0x294/0x5fd [   53.370298]  [<c019e267>] ?
> > alloc_fd+0x52/0xb8 [   53.370298]  [<c018c1d1>] ?
> > do_sys_open+0x44/0xb4 [   53.370298]  [<c018c285>] ?
> > sys_open+0x1e/0x23 [   53.370298]  [<c0102f74>] ?
> > sysenter_do_call+0x12/0x28 [   53.370298] Code: 0f c1 05 e0 4b 3e
> > c0 38 e0 74 09 f3 90 a0 e0 4b 3e c0 eb f3 64 a1 00 b0 43 c0 89 50
> > 14 c3 64 8b 15 00 b0 43 c0 83 7a 14 00 79 04 <0f> 0b eb fe 8b 42 14
> > 48 85 c0 89 42 14 79 07 f0 fe 05 e0 4b 3e [   53.370298] EIP:
> > [<c02f81e3>] unlock_kernel+0xd/0x24 SS:ESP 0068:f65b1e68
> > [   53.374302] ---[ end trace 05965e9e089c46c7 ]---
> > 
> > 
> > With my best regards, Dmitry.
> > 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
