Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40430 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EPSqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 14:46:23 -0400
Received: by eaak11 with SMTP id k11so309139eaa.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 11:46:21 -0700 (PDT)
From: remi schwartz <remi.schwartz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: patch for Asus My Cinema PS3-100 (1043:48cd)
Date: Wed, 16 May 2012 20:46:16 +0200
Cc: linux-media@vger.kernel.org
References: <201204051140.44241.remi.schwartz@gmail.com> <4FB25752.7040108@redhat.com>
In-Reply-To: <4FB25752.7040108@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205162046.16977.remi.schwartz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I used your patch against the last media-build tree.
Here are the results.


* first, I added these lines to the patch to get the modules compiled :

###################################################################
Signed-off-by: Remi Schwartz <remi.schwartz@gmail.com>

Index: patchwork/include/media/rc-map.h
===================================================================
--- patchwork.orig/include/media/rc-map.h
+++ patchwork/include/media/rc-map.h
@@ -62,6 +62,7 @@
 #define RC_MAP_ANYSEE                    "rc-anysee"
 #define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
 #define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
+#define RC_MAP_ASUS_PS3_100              "rc-asus-ps3-100"
 #define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
 #define RC_MAP_ATI_X10                   "rc-ati-x10"
 #define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
Index: patchwork/drivers/media/rc/keymaps/Makefile
===================================================================
--- patchwork.orig/drivers/media/rc/keymaps/Makefile
+++ patchwork/drivers/media/rc/keymaps/Makefile
@@ -3,6 +3,7 @@
 			rc-anysee.o \
 			rc-apac-viewcomp.o \
 			rc-asus-pc39.o \
+			rc-asus-ps3-100.o \
 			rc-ati-tv-wonder-hd-600.o \
 			rc-ati-x10.o \
 			rc-avermedia-a16d.o \
###################################################################


* then, I wanted to compile the RC part using "CONFIG_RC_CORE=y",
this is what I have obtained :

WARNING: "rc_unregister_device" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "rc_allocate_device" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "rc_free_device" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "ir_raw_event_store_edge" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "rc_register_device" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "rc_keydown_notimeout" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "rc_keyup" [/usr/src/media_build/v4l/saa7134.ko] undefined!
WARNING: "ir_raw_event_handle" [/usr/src/media_build/v4l/saa7134.ko] undefined!

and the compiled modules don't load because of unknown symbols


* changing to "CONFIG_RC_CORE=m" lets the modules compile and load, but when
loading, I get "BUG: unable to handle kernel NULL pointer dereference at (null)".

More precisely :

[   15.730917] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   15.732471] saa7134 0000:01:09.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   15.732477] saa7133[0]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 32, mmio: 0xfddfe000
[   15.732484] saa7133[0]: subsystem: 1043:48cd, board: Asus My Cinema PS3-100 [card=190,autodetected]
[   15.732510] saa7133[0]: board init: gpio is 40000
[   15.816459] Registered IR keymap rc-asus-ps3-100
[   15.816554] input: saa7134 IR (Asus My Cinema PS3- as /devices/pci0000:00/0000:00:10.0/0000:01:09.0/rc/rc0/input5
[   15.816611] rc0: saa7134 IR (Asus My Cinema PS3- as /devices/pci0000:00/0000:00:10.0/0000:01:09.0/rc/rc0
[   15.830376] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   15.830428] BUG: unable to handle kernel NULL pointer dereference at (null)
[   15.830431] IP: [<ffffffff812fcd21>] _spin_lock_irqsave+0x1a/0x34
[   15.830438] PGD 0 
[   15.830440] Oops: 0002 [#1] SMP 
[   15.830442] last sysfs file: /sys/devices/virtual/dmi/id/sys_vendor
[   15.830445] CPU 0 
[   15.830446] Modules linked in: snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss rc_asus_ps3_100 snd_pcm snd_seq_midi 
snd_rawmidi saa7134(+) snd_seq_midi_event snd_seq rc_core snd_timer snd_seq_device parport_pc parport videobuf_dma_sg videobuf_core 
v4l2_common videodev tveeprom asus_atk0110 snd amd64_edac_mod(-) i2c_nforce2 button evdev pcspkr psmouse serio_raw soundcore 
snd_page_alloc edac_core edac_mce_amd k8temp i2c_core processor ext4 mbcache jbd2 crc16 sg sd_mod crc_t10dif sr_mod cdrom ohci_hcd 
ata_generic sata_nv ehci_hcd fan pata_amd firewire_ohci floppy firewire_core crc_itu_t thermal libata scsi_mod usbcore nls_base thermal_sys 
forcedeth [last unloaded: scsi_wait_scan]
[   15.830479] Pid: 810, comm: rc0 Not tainted 2.6.32-5-amd64 #1 System Product Name
[   15.830481] RIP: 0010:[<ffffffff812fcd21>]  [<ffffffff812fcd21>] _spin_lock_irqsave+0x1a/0x34
[   15.830486] RSP: 0018:ffff8800ae147e90  EFLAGS: 00010086
[   15.830488] RAX: 0000000000000086 RBX: ffff8800ad60cde0 RCX: ffff8800ae15a350
[   15.830490] RDX: 0000000000010000 RSI: 0000000000000086 RDI: 0000000000000000
[   15.830492] RBP: ffff8800abc86a00 R08: ffff8800ae146000 R09: ffff880001815780
[   15.830494] R10: 0000000000000011 R11: ffff8800aec0f000 R12: ffff8800ae7a3c58
[   15.830496] R13: ffff8800abc86a18 R14: ffff8800ae15a350 R15: 0000000000000000
[   15.830498] FS:  00007f3c4693d7a0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
[   15.830500] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   15.830502] CR2: 0000000000000000 CR3: 00000000ad2b7000 CR4: 00000000000006f0
[   15.830504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.830506] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   15.830509] Process rc0 (pid: 810, threadinfo ffff8800ae146000, task ffff8800ae15a350)
[   15.830510] Stack:
[   15.830511]  0000000300000b2f ffffffffa031a533 ffff8800abc86a00 ffff8800ae7a3c60
[   15.830514] <0> 0000000000000286 ffff8800ae147ef8 ffff8800abc86a00 ffff8800ae7a3c58
[   15.830517] <0> ffffffffa031a4f8 0000000000000001 0000000000000000 ffffffff81064d75
[   15.830520] Call Trace:
[   15.830526]  [<ffffffffa031a533>] ? ir_raw_event_thread+0x3b/0x103 [rc_core]
[   15.830530]  [<ffffffffa031a4f8>] ? ir_raw_event_thread+0x0/0x103 [rc_core]
[   15.830534]  [<ffffffff81064d75>] ? kthread+0x79/0x81
[   15.830538]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[   15.830541]  [<ffffffff81064cfc>] ? kthread+0x0/0x81
[   15.830543]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[   15.830544] Code: 31 d2 89 d0 c3 f0 83 2f 01 79 05 e8 7a 98 e9 ff c3 48 83 ec 08 9c 58 66 66 90 66 90 48 89 c6 fa 66 66 90 66 66 90 ba 00 00 01 
00 <f0> 0f c1 17 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 0f b7 0f eb f5 
[   15.830561] RIP  [<ffffffff812fcd21>] _spin_lock_irqsave+0x1a/0x34
[   15.830564]  RSP <ffff8800ae147e90>
[   15.830566] CR2: 0000000000000000
[   15.830568] ---[ end trace b4dbd3b68f659105 ]---
[   17.488028] saa7133[0]: i2c eeprom 00: 43 10 cd 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   17.539962] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input6
[   17.568983] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   17.596222] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 2c ff ff ff ff
[   17.623127] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649744] saa7133[0]: i2c eeprom 40: ff 28 00 c2 96 16 03 02 c0 1c ff ff ff ff ff ff
[   17.649750] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649756] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649761] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649767] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649772] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649777] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649783] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649788] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649794] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649799] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.649804] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.940097] tuner 2-004b: Tuner -1 found with type(s) Radio TV.
[   18.036085] tda829x 2-004b: setting tuner address to 61
[   18.116017] tda829x 2-004b: type set to tda8290+75a
[   22.076088] saa7133[0]: registered device video0 [v4l2]
[   22.098506] saa7133[0]: registered device vbi0
[   22.120431] saa7133[0]: registered device radio0
[   22.160012] dvb_init() allocating 1 frontend
[   22.256099] DVB: registering new adapter (saa7133[0])
[   22.276274] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
[   22.648018] tda1004x: setting up plls for 48MHz sampling clock
[   22.952014] tda1004x: found firmware revision 29 -- ok
[   23.444186] saa7134 ALSA driver for DMA sound loaded
[   23.465213] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   23.486751] saa7133[0]/alsa: saa7133[0] at 0xfddfe000 irq 17 registered as card -1

There seems to be a problem in the RC code.
I haven't found where the problem is. It is perhaps related to this : 

http://article.gmane.org/gmane.linux.kernel.input/15312

I have tested the DVB-T part and it works fine but remote doesn't work.
If I hit a remote key, the kernel freeze.

If you find a solution to this pointer problem, I can finish the work on the RC keycode table.

Regards,

Rémi


Le mardi 15 mai 2012, Mauro Carvalho Chehab a écrit :
> Em 05-04-2012 06:40, remi schwartz escreveu:
> > Hi all,
> > 
> > This is the patch against kernel 2.6.32 I used to get my TV card Asus
> > My Cinema PS3-100 (1043:48cd) to work.
> 
> Please, don't sent patches against older kernel versions, as they won't
> apply anymore upstream. In particular, since kernel 2.6.32, the entire
> RC code were re-written.
> 
> You can test the very latest media code using the media-build tree,
> available at:
> 	http://git.linuxtv.org/media_build.git
> 
> It compiles against old kernels (although won't compile the gspca driver
> since yesterday, as I'm applying a massive amount of patches those days
> and didn't have any time yet to fix gspca build).
> 
> > More information on this card can be found on this page :
> > 
> > http://www.0xf8.org/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card/
> > 
> > This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
> > SAA7134 module, so I gave it the temporary number of 1470.
> > 
> > DVB-T and remote have been tested and work fine.
> > DVB-S, FM and Composite input haven't been tested.
> > 
> > Hope that will help some of you.
> 
> In order to help adding support for this board, I re-wrote your code to
> apply it against the latest build.
> 
> I suspect that your RC keycode table is incomplete, as it is getting just
> the 8 least significant bits. So, you'll need to test it and fix the
> IR keytable.
> 
> Please test. Feel free to modify it, as I suspect that you'll need to
> re-work with the RC part of it.
> 
> Regards,
> Mauro
> 
> -
> 
> Add support for Asus My Cinema PS3-100 (1043:48cd)
> 
> Based on a previous patch from remi schwartz <remi.schwartz@gmail.com>
> 
> Thanks-to: Remi Schwartz <remi.schwartz@gmail.com>
> Signed-off-to: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> Index: patchwork/drivers/media/video/saa7134/saa7134-input.c
> ===================================================================
> --- patchwork.orig/drivers/media/video/saa7134/saa7134-input.c
> +++ patchwork/drivers/media/video/saa7134/saa7134-input.c
> @@ -753,6 +753,11 @@ int saa7134_input_init1(struct saa7134_d
>  		mask_keycode = 0xffff;
>  		raw_decode   = true;
>  		break;
> +	case SAA7134_BOARD_ASUSTeK_PS3_100:
> +		ir_codes     = RC_MAP_ASUS_PS3_100;
> +		mask_keydown = 0x0040000;
> +		raw_decode   = true;
> +		break;
>  	case SAA7134_BOARD_ENCORE_ENLTV:
>  	case SAA7134_BOARD_ENCORE_ENLTV_FM:
>  		ir_codes     = RC_MAP_ENCORE_ENLTV;
> Index: patchwork/drivers/media/video/saa7134/saa7134-dvb.c
> ===================================================================
> --- patchwork.orig/drivers/media/video/saa7134/saa7134-dvb.c
> +++ patchwork/drivers/media/video/saa7134/saa7134-dvb.c
> @@ -881,6 +881,20 @@ static struct tda1004x_config asus_tiger
>  	.request_firmware = philips_tda1004x_request_firmware
>  };
> 
> +static struct tda1004x_config asus_ps3_100_config = {
> +	.demod_address = 0x0b,
> +	.invert        = 1,
> +	.invert_oclk   = 0,
> +	.xtal_freq     = TDA10046_XTAL_16M,
> +	.agc_config    = TDA10046_AGC_TDA827X,
> +	.gpio_config   = TDA10046_GP11_I,
> +	.if_freq       = TDA10046_FREQ_045,
> +	.i2c_gate      = 0x4b,
> +	.tuner_address = 0x61,
> +	.antenna_switch = 1,
> +	.request_firmware = philips_tda1004x_request_firmware
> +};
> +
>  /* ------------------------------------------------------------------
>   * special case: this card uses saa713x GPIO22 for the mode switch
>   */
> @@ -1649,6 +1663,31 @@ static int dvb_init(struct saa7134_dev *
>  						" found!\n", __func__);
>  					goto dettach_frontend;
>  				}
> +			}
> +		}
> +		break;
> +	case SAA7134_BOARD_ASUSTeK_PS3_100:
> +		if (!use_frontend) {     /* terrestrial */
> +			if (configure_tda827x_fe(dev, &asus_ps3_100_config,
> +							&tda827x_cfg_2) < 0)
> +				goto dettach_frontend;
> +		} else {  		/* satellite */
> +			fe0->dvb.frontend = dvb_attach(tda10086_attach,
> +						&flydvbs, &dev->i2c_adap);
> +			if (fe0->dvb.frontend) {
> +				if (dvb_attach(tda826x_attach,
> +						fe0->dvb.frontend, 0x60,
> +						&dev->i2c_adap, 0) == NULL) {
> +					wprintk("%s: Asus My Cinema PS3-100, no "
> +						"tda826x found!\n", __func__);
> +					goto dettach_frontend;
> +				}
> +				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
> +						&dev->i2c_adap, 0, 0) == NULL) {
> +					wprintk("%s: Asus My Cinema PS3-100, no lnbp21"
> +						" found!\n", __func__);
> +					goto dettach_frontend;
> +				}
>  			}
>  		}
>  		break;
> Index: patchwork/drivers/media/video/saa7134/saa7134-cards.c
> ===================================================================
> --- patchwork.orig/drivers/media/video/saa7134/saa7134-cards.c
> +++ patchwork/drivers/media/video/saa7134/saa7134-cards.c
> @@ -5080,6 +5080,36 @@ struct saa7134_board saa7134_boards[] =
>  			.gpio = 0x0200000,
>  		},
>  	},
> +	[SAA7134_BOARD_ASUSTeK_PS3_100] = {
> +		.name           = "Asus My Cinema PS3-100",
> +		.audio_clock    = 0x00187de7,
> +		.tuner_type     = TUNER_PHILIPS_TDA8290,
> +		.radio_type     = UNSET,
> +		.tuner_addr     = ADDR_UNSET,
> +		.radio_addr     = ADDR_UNSET,
> +		.tuner_config   = 2,
> +		.gpiomask       = 1 << 21,
> +		.mpeg           = SAA7134_MPEG_DVB,
> +		.inputs         = {{
> +			.name = name_tv,
> +			.vmux = 1,
> +			.amux = TV,
> +			.tv   = 1,
> +		}, {
> +			.name = name_comp,
> +			.vmux = 0,
> +			.amux = LINE2,
> +		}, {
> +			.name = name_svideo,
> +			.vmux = 8,
> +			.amux = LINE2,
> +		} },
> +		.radio = {
> +			.name = name_radio,
> +			.amux = TV,
> +			.gpio = 0x0200000,
> +		},
> +	},
>  	[SAA7134_BOARD_REAL_ANGEL_220] = {
>  		.name           = "Zogis Real Angel 220",
>  		.audio_clock    = 0x00187de7,
> @@ -6877,6 +6907,12 @@ struct pci_device_id saa7134_pci_tbl[] =
>  		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
>  	}, {
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> +		.subvendor    = 0x1043,
> +		.subdevice    = 0x48cd,
> +		.driver_data  = SAA7134_BOARD_ASUSTeK_PS3_100,
> +	}, {
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
>  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
>  		.subvendor    = 0x17de,
>  		.subdevice    = 0x7128,
> @@ -7350,6 +7386,7 @@ int saa7134_board_init1(struct saa7134_d
>  	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
>  	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
>  	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
> +	case SAA7134_BOARD_ASUSTeK_PS3_100:
>  	case SAA7134_BOARD_FLYDVBTDUO:
>  	case SAA7134_BOARD_PROTEUS_2309:
>  	case SAA7134_BOARD_AVERMEDIA_A16AR:
> @@ -7807,6 +7844,14 @@ int saa7134_board_init2(struct saa7134_d
>  	{
>  		u8 data[] = { 0x3c, 0x33, 0x60};
>  		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
> +							.len = sizeof(data)};
> +		i2c_transfer(&dev->i2c_adap, &msg, 1);
> +		break;
> +	}
> +	case SAA7134_BOARD_ASUSTeK_PS3_100:
> +	{
> +		u8 data[] = { 0x3c, 0x33, 0x60};
> +		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
>  							.len = sizeof(data)};
>  		i2c_transfer(&dev->i2c_adap, &msg, 1);
>  		break;
> Index: patchwork/drivers/media/video/saa7134/saa7134.h
> ===================================================================
> --- patchwork.orig/drivers/media/video/saa7134/saa7134.h
> +++ patchwork/drivers/media/video/saa7134/saa7134.h
> @@ -332,6 +332,7 @@ struct saa7134_card_ir {
>  #define SAA7134_BOARD_BEHOLD_503FM          187
>  #define SAA7134_BOARD_SENSORAY811_911       188
>  #define SAA7134_BOARD_KWORLD_PC150U         189
> +#define SAA7134_BOARD_ASUSTeK_PS3_100	    190
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> Index: patchwork/drivers/media/rc/keymaps/rc-asus-ps3-100.c
> ===================================================================
> --- /dev/null
> +++ patchwork/drivers/media/rc/keymaps/rc-asus-ps3-100.c
> @@ -0,0 +1,91 @@
> +/* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
> + *
> + * Copyright (c) 2012 by Mauro Carvalho Chehab <mchehab@redhat.com>
> + *
> + * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +static struct rc_map_table asus_ps3_100[] = {
> +	{ 0x23, KEY_HOME },		/* home */
> +	{ 0x21, KEY_TV },		/* tv */
> +	{ 0x3c, KEY_TEXT },		/* teletext */
> +	{ 0x16, KEY_POWER },		/* close */
> +
> +	{ 0x34, KEY_RED },		/* red */
> +	{ 0x32, KEY_YELLOW },		/* yellow */
> +	{ 0x39, KEY_BLUE },		/* blue */
> +	{ 0x38, KEY_GREEN },		/* green */
> +
> +	/* Keys 0 to 9 */
> +	{ 0x15, KEY_0 },
> +	{ 0x29, KEY_1 },
> +	{ 0x2d, KEY_2 },
> +	{ 0x2b, KEY_3 },
> +	{ 0x09, KEY_4 },
> +	{ 0x0d, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x31, KEY_7 },
> +	{ 0x35, KEY_8 },
> +	{ 0x33, KEY_9 },
> +
> +	{ 0x2a, KEY_VOLUMEUP },
> +	{ 0x19, KEY_VOLUMEDOWN },
> +	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
> +
> +	{ 0x37, KEY_UP },
> +	{ 0x3b, KEY_DOWN },
> +	{ 0x27, KEY_LEFT },
> +	{ 0x2f, KEY_RIGHT },
> +	{ 0x1a, KEY_ENTER },		/* enter */
> +
> +	{ 0x1d, KEY_EXIT },		/* back */
> +	{ 0x13, KEY_AB },		/* recall */
> +
> +	{ 0x1f, KEY_AUDIO },		/* TV audio */
> +	{ 0x08, KEY_SCREEN },		/* snapshot */
> +	{ 0x11, KEY_ZOOM },		/* full screen */
> +	{ 0x3d, KEY_MUTE },		/* mute */
> +
> +	{ 0x0e, KEY_REWIND },		/* backward << */
> +	{ 0x2e, KEY_RECORD },		/* recording */
> +	{ 0x36, KEY_STOP },
> +	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x1e, KEY_PREVIOUS },		/* rew */
> +	{ 0x25, KEY_PAUSE },		/* pause */
> +	{ 0x06, KEY_PLAY },		/* play */
> +	{ 0x26, KEY_NEXT },		/* forward */
> +};
> +
> +static struct rc_map_list asus_ps3_100_map = {
> +	.map = {
> +		.scan    = asus_ps3_100,
> +		.size    = ARRAY_SIZE(asus_ps3_100),
> +		.rc_type = RC_TYPE_RC5,
> +		.name    = RC_MAP_ASUS_PS3_100,
> +	}
> +};
> +
> +static int __init init_rc_map_asus_ps3_100(void)
> +{
> +	return rc_map_register(&asus_ps3_100_map);
> +}
> +
> +static void __exit exit_rc_map_asus_ps3_100(void)
> +{
> +	rc_map_unregister(&asus_ps3_100_map);
> +}
> +
> +module_init(init_rc_map_asus_ps3_100)
> +module_exit(exit_rc_map_asus_ps3_100)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");

