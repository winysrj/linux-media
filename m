Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:44571 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbZDLWR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 18:17:27 -0400
Subject: Re: Compro T750F not working yet...BUG: unable to handle kernel
	paging request at fffffff4
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrew Reay <certain@tpg.com.au>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1239530112.5408.10.camel@desktop>
References: <1239419690.7179.15.camel@desktop>
	 <1239448124.3779.25.camel@pc07.localdom.local>
	 <1239530112.5408.10.camel@desktop>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 00:13:21 +0200
Message-Id: <1239574401.5099.28.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

Am Sonntag, den 12.04.2009, 19:55 +1000 schrieb Andrew Reay:
> Hi Herman,
> 
> Thank you very much for your reply to my question.
> 
> I understand that I am to either remove the card from the gpio remotes
> in saa7134-cards.c file or try to add it to some of the other Compro
> cards in saa7134-input.c file too.
> 
> However I cannot locate either of these files. I have pasted a
> screenshot of what I believe to be the appropriate folder. Where would
> you expect to find these files in Ubuntu 9.04?

you either need the Ubuntu kernel source code, which you have to modify,
compile and install again, or a self compiled vanilla kernel from
kernel.org where you can modify the source.

The easiest resolution usually is, unfortunately not always with Ubuntu,
to install "mercurial", kernel devel environment, on Ubuntu mostly
kernel-headers, on other distributions often kernel-devel packages.

Then "hg clone http://linuxtv.org/hg/v4l-dvb".

"cd v4l-dvb" and use some editor to make the chances in related
linux/drivers/media/saa7134 source files.

"make"

"make rmmod" to unload the old modules.

Now, I suggest to delete the whole media folder where you just tried to
find the source files, but see only the binaries.

You can back it up somewhere too of course.

"make install" should provide you with the recent stuff we have
including your fixes.

"modprobe -v saa7134" should show that at least this bug is gone for
your card. I don't have it, but John.

You find more on the linuxtv.org wiki(s) and in the v4l-dvb docs, but
let us know, if you still hang somewhere.

Cheers,
Hermann

> -----Original Message-----
> From: hermann pitton <hermann-pitton@arcor.de>
> To: Andrew Reay <certain@tpg.com.au>, John Newbigin <jn@it.swin.edu.au>
> Cc: linux-media@vger.kernel.org
> Subject: Re: Compro T750F not working yet...BUG: unable to handle kernel
> paging request at fffffff4
> Date: Sat, 11 Apr 2009 13:08:44 +0200
> Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
> 
> Hi Andrew,
> 
> Am Samstag, den 11.04.2009, 13:14 +1000 schrieb Andrew Reay:
> > Hi Everyone,
> > 
> > I have a Compro VideoMate T750F which is not working under Ubuntu 9.04
> > BETA. I get the same result as davor emard <davoremard <at> gmail.com>
> > posted 2009-01-19 11:45:46 GMT. 
> > 
> > The relevant part of the dmesg below, perhaps the 'BUG: unable to handle
> > kernel paging request at fffffff4' part is part of the problem?
> > 
> > I have pasted the attached xc3028-v27.fw created in Ubuntu 8.10
> > into /lib/firmware but still no go.
> > 
> 
> the card has in saa7134-dvb.c still a "FIXME: does anyone know the
> demodulator on it" or something like that.
> 
> The oops is because the card is set in saa7134-cards.c as gpio remote.
> 
> int saa7134_board_init1(struct saa7134_dev *dev)
> {
> 	/* Always print gpio, often manufacturers encode tuner type and other info. */
> 	saa_writel(SAA7134_GPIO_GPMODE0 >> 2, 0);
> 	dev->gpio_value = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
> 	printk(KERN_INFO "%s: board init: gpio is %x\n", dev->name, dev->gpio_value);
> 
> 	switch (dev->board) {
> 	case SAA7134_BOARD_FLYVIDEO2000:
> 	case SAA7134_BOARD_FLYVIDEO3000:
> 	case SAA7134_BOARD_FLYVIDEO3000_NTSC:
> 		dev->has_remote = SAA7134_REMOTE_GPIO;
> 		board_flyvideo(dev);
> 		break;
> 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
> 
> 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
> 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
> 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
> 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
> 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
> 	case SAA7134_BOARD_VIDEOMATE_T750:
> 	case SAA7134_BOARD_MANLI_MTV001:
> 
> But in saa7134-input.c in the function below is nothing for it.
> 
> int saa7134_input_init1(struct saa7134_dev *dev)
> {
> 	struct card_ir *ir;
> 	struct input_dev *input_dev;
> 	IR_KEYTAB_TYPE *ir_codes = NULL;
> 	u32 mask_keycode = 0;
> 	u32 mask_keydown = 0;
> 	u32 mask_keyup   = 0;
> 	int polling      = 0;
> 	int rc5_gpio	 = 0;
> 	int nec_gpio	 = 0;
> 	int ir_type      = IR_TYPE_OTHER;
> 	int err;
> 
> 	if (dev->has_remote != SAA7134_REMOTE_GPIO)
> 		return -ENODEV;
> 	if (disable_ir)
> 		return -ENODEV;
> 
> 	/* detect & configure */
> 	switch (dev->board) {
> 	case SAA7134_BOARD_FLYVIDEO2000:
> 	case SAA7134_BOARD_FLYVIDEO3000:
> 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
> 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
> 		ir_codes     = ir_codes_flyvideo;
> 		mask_keycode = 0xEC00000;
> 		mask_keydown = 0x0040000;
> 		break;
> .
> .
> .
> 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
> 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
> 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
> 		ir_codes     = ir_codes_videomate_tv_pvr;
> 		mask_keycode = 0x00003F;
> 		mask_keyup   = 0x400000;
> 		polling      = 50; // ms
> 		break;
> 	case SAA7134_BOARD_PROTEUS_2309:
> 		ir_codes     = ir_codes_proteus_2309;
> 		mask_keycode = 0x00007F;
> 		mask_keyup   = 0x000080;
> 		polling      = 50; // ms
> 		break;
> 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
> 		ir_codes     = ir_codes_videomate_tv_pvr;
> 		mask_keycode = 0x003F00;
> 		mask_keyup   = 0x040000;
> 		break;
> 	case SAA7134_BOARD_FLYDVBS_LR300:
> 	case SAA7134_BOARD_FLYDVBT_LR301:
> .
> .
> .
> 		break;
> 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
> 		ir_codes     = ir_codes_kworld_plus_tv_analog;
> 		mask_keycode = 0x7f;
> 		polling = 40; /* ms */
> 		break;
> 	}
> 	if (NULL == ir_codes) {
> 		printk("%s: Oops: IR config error [card=%d]\n",
> 		       dev->name, dev->board);
> 		return -ENODEV;
> 	}
> 
> 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> 	input_dev = input_allocate_device();
> 	if (!ir || !input_dev) {
> 		err = -ENOMEM;
> 		goto err_out_free;
> 	}
> 
> This is called from saa7134-core on hardware init.
> 
> So, either remove the card from the gpio remotes in saa7134-cards.c or
> try to add it to some of the other Compro cards in saa7134-input.c too.
> 
> I can imagine it has the same IR design like the other Compro DVB cards,
> but can't tell offhand. Maybe John knows, but should also be not
> difficult to find it out.
> 
> Cheers,
> Hermann
> 
> > 
> > [   10.377283] Linux video capture interface: v2.00
> > [   10.516423] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [   10.517059] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> > [   10.517072] saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16
> > (level, low) -> IRQ 16
> > [   10.517079] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
> > latency: 32, mmio: 0xfdbfe000
> > [   10.517085] saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate
> > T750 [card=139,autodetected]
> > [   10.517237] saa7133[0]: board init: gpio is 84bf00
> > [   10.517246] saa7133[0]: Oops: IR config error [card=139]
> > [   10.580657] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
> > [   10.580663] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI 23
> > (level, low) -> IRQ 23
> > [   10.580723] HDA Intel 0000:00:10.1: setting latency timer to 64
> > [   10.668027] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43
> > a9 1c 55 d2 b2 92
> > [   10.668036] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668045] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff
> > 00 87 ff ff ff ff
> > [   10.668053] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668061] saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2
> > ff 01 c6 ff 05 ff
> > [   10.668069] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff cb
> > [   10.668077] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668085] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668093] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668101] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668108] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668116] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668124] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668132] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668140] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.668148] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff
> > [   10.685023] tuner' 2-0062: chip found @ 0xc4 (saa7133[0])
> > [   10.692029] tuner' 2-0063: chip found @ 0xc6 (saa7133[0])
> > [   10.700028] tuner' 2-0068: chip found @ 0xd0 (saa7133[0])
> > [   10.721926] xc2028 2-0062: creating new instance
> > [   10.721930] xc2028 2-0062: type set to XCeive xc2028/xc3028 tuner
> > [   10.721944] BUG: unable to handle kernel paging request at fffffff4
> > [   10.721949] IP: [<f7f822c0>] saa7134_board_init2+0x140/0x710
> > [saa7134]
> > [   10.721963] *pde = 007bd067 *pte = 00000000 
> > [   10.721967] Oops: 0000 [#1] SMP 
> > [   10.721970] last sysfs file: /sys/module/videodev/initstate
> > [   10.721973] Dumping ftrace buffer:
> > [   10.721976]    (ftrace buffer empty)
> > [   10.721978] Modules linked in: tuner_xc2028 tuner snd_hda_intel(+)
> > snd_pcm_oss snd_mixer_oss snd_pcm saa7134(+) snd_seq_dummy snd_seq_oss
> > snd_seq_midi snd_rawmidi ir_common snd_seq_midi_event snd_seq videodev
> > v4l1_compat compat_ioctl32 snd_timer snd_seq_device psmouse ppdev
> > v4l2_common videobuf_dma_sg serio_raw pcspkr snd videobuf_core soundcore
> > tveeprom k8temp snd_page_alloc i2c_nforce2 parport_pc parport 8139too
> > 8139cp mii floppy ohci1394 ieee1394 fbcon tileblit font bitblit
> > softcursor
> > [   10.722007] 
> > [   10.722011] Pid: 1531, comm: modprobe Not tainted (2.6.28-11-generic
> > #37-Ubuntu) System Product Name
> > [   10.722014] EIP: 0060:[<f7f822c0>] EFLAGS: 00010286 CPU: 1
> > [   10.722022] EIP is at saa7134_board_init2+0x140/0x710 [saa7134]
> > [   10.722025] EAX: 00000000 EBX: 00000000 ECX: f6255c3c EDX: 00000000
> > [   10.722027] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f6255c58
> > [   10.722029]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [   10.722032] Process modprobe (pid: 1531, ti=f6254000 task=f60c25b0
> > task.ti=f6254000)
> > [   10.722034] Stack:
> > [   10.722035]  00000303 f6255c5c f6255c5c f61b6000 f6fddc00 f61b6000
> > f6255cd4 c014ad77
> > [   10.722041]  000000d0 f7f84889 656e7574 00000072 000000f0 f61b64b0
> > 00000002 f61b6140
> > [   10.722047]  f7f8e510 f61b64b0 f6255cd4 f7f8494d 65626f72 642d7000
> > 006d6561 000005fb
> > [   10.722053] Call Trace:
> > [   10.722055]  [<c014ad77>] ? request_module+0x97/0xf0
> > [   10.722061]  [<f7f84889>] ? saa7134_i2c_eeprom+0xe9/0x110 [saa7134]
> > [   10.722072]  [<f7f8494d>] ? saa7134_i2c_register+0x9d/0x120 [saa7134]
> > [   10.722082]  [<f7f8d67c>] ? saa7134_initdev+0x3cc/0x8d5 [saa7134]
> > [   10.722094]  [<c02dc1be>] ? pci_device_probe+0x5e/0x80
> > [   10.722100]  [<c034f124>] ? really_probe+0x54/0x180
> > [   10.722104]  [<c02db9ee>] ? pci_match_device+0xbe/0xd0
> > [   10.722110]  [<c034f28e>] ? driver_probe_device+0x3e/0x50
> > [   10.722113]  [<c034f329>] ? __driver_attach+0x89/0x90
> > [   10.722117]  [<c034ea63>] ? bus_for_each_dev+0x53/0x80
> > [   10.722121]  [<c02dc100>] ? pci_device_remove+0x0/0x40
> > [   10.722125]  [<c034efe9>] ? driver_attach+0x19/0x20
> > [   10.722128]  [<c034f2a0>] ? __driver_attach+0x0/0x90
> > [   10.722131]  [<c034e43f>] ? bus_add_driver+0x1af/0x230
> > [   10.722135]  [<c02dc100>] ? pci_device_remove+0x0/0x40
> > [   10.722139]  [<c034f4c9>] ? driver_register+0x69/0x140
> > [   10.722144]  [<f7f84240>] ? saa7134_init+0x0/0x60 [saa7134]
> > [   10.722154]  [<c02dc41a>] ? __pci_register_driver+0x4a/0x90
> > [   10.722158]  [<f7f84240>] ? saa7134_init+0x0/0x60 [saa7134]
> > [   10.722167]  [<f7f84292>] ? saa7134_init+0x52/0x60 [saa7134]
> > [   10.722177]  [<c010111e>] ? _stext+0x2e/0x170
> > [   10.722180]  [<c020be75>] ? sysfs_addrm_finish+0x15/0xf0
> > [   10.722185]  [<c020b643>] ? sysfs_add_one+0x13/0x50
> > [   10.722188]  [<c020b6bf>] ? sysfs_addrm_start+0x3f/0xa0
> > [   10.722191]  [<c01a8fac>] ? __vunmap+0x9c/0xe0
> > [   10.722196]  [<c01a8fac>] ? __vunmap+0x9c/0xe0
> > [   10.722199]  [<c0127c7d>] ? update_curr+0x8d/0x1e0
> > [   10.722203]  [<c012c6dc>] ? enqueue_entity+0x13c/0x360
> > [   10.722207]  [<c0131bae>] ? resched_task+0x1e/0x70
> > [   10.722210]  [<c0133b24>] ? try_to_wake_up+0x104/0x290
> > [   10.722215]  [<c0163f58>] ? sys_init_module+0x88/0x1b0
> > [   10.722220]  [<c0103f6b>] ? sysenter_do_call+0x12/0x2f
> > [   10.722223] Code: 30 e8 57 c8 8b 55 90 8b 82 2c 01 00 00 89 5c 24 04
> > c7 04 24 38 f4 f8 f7 89 44 24 08 e8 13 e8 57 c8 66 90 8b 45 90 e8 40 fd
> > ff ff <8b> 5d f4 31 c0 8b 75 f8 8b 7d fc 89 ec 5d c3 90 8b 4d 90 8b 71 
> > [   10.722254] EIP: [<f7f822c0>] saa7134_board_init2+0x140/0x710
> > [saa7134] SS:ESP 0068:f6255c58
> > [   10.722265] ---[ end trace 11de26a2ee66d7a6 ]---
> 
> 

