Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0FJHdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 03:33:53 -0400
Received: by fxm8 with SMTP id 8so4037539fxm.19
        for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 00:33:51 -0700 (PDT)
Date: Thu, 10 Jun 2010 17:33:53 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [REGRESSION] saa7134 + ir
Message-ID: <20100610173353.2a75a35f@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have regression with our TV cards + I2C r/c and new IR subsystem.
modules crashed

[  148.461819] Linux video capture interface: v2.00
[  148.462768] IR NEC protocol handler initialized
[  148.482886] saa7130/34: v4l2 driver version 0.2.16 loaded
[  148.482925] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  148.482931] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[  148.482936] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[  148.482949] saa7133[0]: board init: gpio is 200000
[  148.482955] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  148.483938] IR RC5(x) protocol handler initialized
[  148.491808] IR RC6 protocol handler initialized
[  148.499804] IR JVC protocol handler initialized
[  148.507796] IR Sony protocol handler initialized
[  148.632009] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[  148.632028] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632045] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632061] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632078] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632094] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632110] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632127] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632143] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632159] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632176] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632197] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632205] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632212] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632220] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[  148.632227] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[  148.652048] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[  148.763651] xc5000 1-0061: creating new instance
[  148.772018] xc5000: Successfully identified at address 0x61
[  148.772021] xc5000: Firmware has not been loaded previously
[  177.112011] Registered IR keymap rc-behold
[  177.112046] BUG: unable to handle kernel NULL pointer dereference at (null)
[  177.112052] IP: [<f80589d0>] ir_register_class+0x3d/0x14e [ir_core]
[  177.112063] *pde = 00000000 
[  177.112067] Oops: 0000 [#1] SMP 
[  177.112072] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/resource
[  177.112076] Modules linked in: rc_behold ir_kbd_i2c(+) xc5000 tuner ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder saa7134(+) v4l2_common ir_nec_decoder videodev v4l1_compat videobuf_dma_sg videobuf_core ir_common ir_core tveeprom ppdev lp ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod sha1_generic arc4 ecb ppp_mppe ppp_generic slhc loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd parport_pc parport soundcore i2c_i801 tpm_tis tpm psmouse snd_page_alloc intel_agp i2c_core processor button tpm_bios serio_raw agpgart rng_core pcspkr evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic ehci_hcd uhci_hcd ide_core r8169 mii usbcore nls_base thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[  177.112185] 
[  177.112194] Pid: 3062, comm: modprobe Not tainted 2.6.33-tm6000 #7 G31M-S2L/G31M-ES2L
[  177.112196] EIP: 0060:[<f80589d0>] EFLAGS: 00010246 CPU: 0
[  177.112199] EIP is at ir_register_class+0x3d/0x14e [ir_core]
[  177.112201] EAX: f8059a68 EBX: fffffff4 ECX: 00000000 EDX: 00000000
[  177.112203] ESI: f5cfa600 EDI: f5e24000 EBP: f5e24000 ESP: f5ea5e88
[  177.112205]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  177.112207] Process modprobe (pid: 3062, ti=f5ea4000 task=f721d100 task.ti=f5ea4000)
[  177.112208] Stack:
[  177.112209]  00000000 fffffff4 00000000 f5cfa600 f5e24000 f8058590 00000000 f8219044
[  177.112214] <0> f5cfa6b4 f5cfa6d0 00000282 00000000 f5e24000 f8219044 f5f923e4 f81f1478
[  177.112218] <0> f81f1b24 f66a1580 f81c0d5a f81c0d51 f5e24000 f6bd0174 002d0000 f5f92380
[  177.112224] Call Trace:
[  177.112227]  [<f8058590>] ? __ir_input_register+0x258/0x2d7 [ir_core]
[  177.112231]  [<f81f1478>] ? ir_probe+0x452/0x50f [ir_kbd_i2c]
[  177.112234]  [<f81f1026>] ? ir_probe+0x0/0x50f [ir_kbd_i2c]
[  177.112240]  [<f83b3226>] ? i2c_device_probe+0x72/0x8d [i2c_core]
[  177.112244]  [<c1198d11>] ? driver_probe_device+0x76/0xfe
[  177.112247]  [<c1198dd9>] ? __driver_attach+0x40/0x5b
[  177.112250]  [<c1198755>] ? bus_for_each_dev+0x37/0x5f
[  177.112253]  [<c1198bf8>] ? driver_attach+0x11/0x13
[  177.112255]  [<c1198d99>] ? __driver_attach+0x0/0x5b
[  177.112257]  [<c11981da>] ? bus_add_driver+0xd6/0x201
[  177.112260]  [<c1198ff3>] ? driver_register+0x87/0xe0
[  177.112263]  [<f8213000>] ? ir_init+0x0/0xf [ir_kbd_i2c]
[  177.112267]  [<f83b3cc1>] ? i2c_register_driver+0x35/0x71 [i2c_core]
[  177.112270]  [<c100112d>] ? do_one_initcall+0x44/0x120
[  177.112274]  [<c1055e0e>] ? sys_init_module+0xa7/0x1d7
[  177.112276]  [<c10026ec>] ? sysenter_do_call+0x12/0x22
[  177.112279]  [<c103007b>] ? wait_consider_task+0x677/0x914
[  177.112282]  [<c103007b>] ? wait_consider_task+0x677/0x914
[  177.112283] Code: 14 c9 ba 00 01 00 00 89 c6 b8 54 9c 05 f8 e8 ab 05 0d c9 85 c0 89 c1 89 04 24 0f 88 14 01 00 00 8b 96 d8 00 00 00 b8 68 9a 05 f8 <83> 3a 00 ba 80 9a 05 f8 c7 86 a4 00 00 00 34 9a 05 f8 0f 45 c2 
[  177.112310] EIP: [<f80589d0>] ir_register_class+0x3d/0x14e [ir_core] SS:ESP 0068:f5ea5e88
[  177.112314] CR2: 0000000000000000
[  177.112316] ---[ end trace b8010262eab7e040 ]---
[  177.112480] saa7133[0]: registered device video0 [v4l2]
[  177.112499] saa7133[0]: registered device vbi0
[  177.112525] saa7133[0]: registered device radio0
[  177.165066] xc5000: I2C write failed (len=4)
[  177.190531] dvb_init() allocating 1 frontend
[  177.242149] zl10353_read_register: readreg error (reg=127, ret==-5)
[  177.242193] saa7133[0]/dvb: frontend initialization failed
[  177.257664] saa7134 ALSA driver for DMA sound loaded
[  177.257675] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  177.257692] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1
[  177.268545] xc5000: I2C write failed (len=4)
[  177.272051] xc5000: I2C read failed
[  177.272592] xc5000: I2C read failed
[  177.272594] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  177.272597] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[  177.318514] xc5000: firmware read 12401 bytes.
[  177.318518] xc5000: firmware uploading...
[  180.648009] xc5000: firmware upload complete...

I found place of this crashe
The pointer ir_dev->props is NULL

int ir_register_class(struct input_dev *input_dev)
{
	int rc = -EINVAL;
	const char *path;
	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
	int devno = find_first_zero_bit(&ir_core_dev_number,
					IRRCV_NUM_DEVICES);

	if (unlikely(devno < 0))
		return devno;

	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ crash place

		ir_dev->dev.type = &rc_dev_type;
	else
		ir_dev->dev.type = &ir_raw_dev_type;

For fast solve this problem we can use:
	int rc = -EINVAL;

	if ((!ir_dev) || (!ir_dev->props))
		return rc;


With my best regards, Dmitry.
