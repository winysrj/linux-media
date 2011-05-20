Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59991 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1ETDm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 23:42:59 -0400
Received: by bwz15 with SMTP id 15so2637395bwz.19
        for <linux-media@vger.kernel.org>; Thu, 19 May 2011 20:42:57 -0700 (PDT)
Date: Fri, 20 May 2011 14:46:15 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] xc5000, fix fw upload crash
Message-ID: <20110520144615.2345c2d6@glory.local>
In-Reply-To: <BANLkTimk-WrKKqW4b_1G99euY6vjcoQxeQ@mail.gmail.com>
References: <20110517142352.7d311ee8@glory.local>
	<BANLkTimk-WrKKqW4b_1G99euY6vjcoQxeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin

snip

> NACK!
> 
> I don't think this patch is correct.  Concurrency problems are
> expected to be handled in the upper layers, as there are usually much
> more significant problems than just this case.  For example, if this
> is a race between V4L2 and DVB, it is the responsibility of bridge
> driver to provide proper locking.
> 
> If patches like this were accepted, we would need to litter every call
> of all the tuner drivers with mutex lock/unlock, and it simply isn't
> maintainable.
> 
> NACK unless Dmitri can provide a much better explanation as to why
> this patch should be accepted rather than fixing the problem in the
> bridge driver.

I spend some time for understanding. This is dmesg log:

As I understand after registering raido0, video0, vbi0 v4l2 top layer call at the some time 
xc5000's function xc5000_set_analog_params
here :
[  110.004059] sap
[  110.004093] sap
[  110.005390] sap

each of this try load the firmware into xc5000

I see two different way add mutex to function where firmware is loaded or to
xc5000_set_analog_params

Both of this is working I already test it.

What you think about it??

[  101.132920] Linux video capture interface: v2.00
[  101.271720] IR NEC protocol handler initialized
[  101.293780] IR RC5(x) protocol handler initialized
[  101.327540] IR RC6 protocol handler initialized
[  101.346690] saa7130/34: v4l2 driver version 0.2.16 loaded
[  101.346730] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  101.346736] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[  101.346742] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[  101.346757] saa7133[0]: board init: gpio is 200000
[  101.346764] buffer_setup set psize = 188
[  101.358936] IR JVC protocol handler initialized
[  101.360875] IR Sony protocol handler initialized
[  101.363697] lirc_dev: IR Remote Control driver registered, major 252 
[  101.364813] IR LIRC bridge handler initialized
[  101.486011] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[  101.486031] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486048] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486066] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486083] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486101] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486118] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486136] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486153] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486170] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486188] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486206] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486214] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486222] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486230] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[  101.486238] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[  101.497901] i2c-core: driver [tuner] using legacy suspend method
[  101.497903] i2c-core: driver [tuner] using legacy resume method
[  101.501066] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[  101.501192] xc5000: xc5000_attach(7-0061)
[  101.501201] xc5000 7-0061: creating new instance
[  101.504026] xc5000: Successfully identified at address 0x61
[  101.504030] xc5000: Firmware has not been loaded previously
[  101.504041] sap
[  101.507009] xc5000: xc5000_is_firmware_loaded() returns True id = 0x20
[  101.507013] xc5000: xc5000_set_tv_freq()
[  101.507017] xc5000: xc5000_set_tv_freq() frequency=6400 (in units of 62.5khz)
[  101.507021] xc5000: xc_SetSignalSource()
[  101.507024] xc5000: xc_SetSignalSource(1) Source = CABLE
[  102.409011] xc5000: xc_SetTVStandard()
[  102.409017] xc5000: xc_SetTVStandard(0x8020,0x0400)
[  102.409020] xc5000: xc_SetTVStandard() Standard = M/N-NTSC/PAL-BTSC
[  103.311684] xc5000: I2C write failed (len=4)
[  103.311687] xc5000: xc_SetTVStandard failed
[  103.311696] sap
[  103.314011] xc5000: xc5000_is_firmware_loaded() returns False id = 0x2000
[  103.314015] xc5000: xc_load_fw_and_init_tuner()
[  103.317010] xc5000: xc5000_is_firmware_loaded() returns True id = 0x20
[  103.317014] xc5000: xc_initialize()
[  105.222012] xc5000: xc5000_set_tv_freq()
[  105.222018] xc5000: xc5000_set_tv_freq() frequency=6400 (in units of 62.5khz)
[  105.222022] xc5000: xc_SetSignalSource()
[  105.222026] xc5000: xc_SetSignalSource(1) Source = CABLE
[  106.124013] xc5000: xc_SetTVStandard()
[  106.124019] xc5000: xc_SetTVStandard(0x8049,0x0c04)
[  106.124022] xc5000: xc_SetTVStandard() Standard = B/G-PAL-NICAM
[  108.830013] xc5000: xc_tune_channel(400000000)
[  108.830018] xc5000: xc_set_RF_frequency(400000000)
[  109.732011] xc5000: WaitForLock()
[  109.732016] xc5000: xc_get_lock_status()
[  109.842014] xc5000: xc_get_ADC_Envelope()
[  109.845010] xc5000: *** ADC envelope (0-1023) = 1796
[  109.845014] xc5000: xc_get_frequency_error()
[  109.848009] xc5000: *** Frequency error = 50171 Hz
[  109.848013] xc5000: xc_get_lock_status()
[  109.851010] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 27390
[  109.851013] xc5000: xc_get_version()
[  109.854009] xc5000: xc_get_buildversion()
[  109.857010] xc5000: *** HW: V00.00, FW: V00.00.0000
[  109.857014] xc5000: xc_get_hsync_freq()
[  109.860009] xc5000: *** Horizontal sync frequency = 30764 Hz
[  109.860013] xc5000: xc_get_frame_lines()
[  109.863009] xc5000: *** Frame lines = 62420
[  109.863012] xc5000: xc_get_quality()
[  109.866009] xc5000: *** Quality (0:<8dB, 7:>56dB) = 0
[  109.946015] Registered IR keymap rc-behold
[  109.946151] input: i2c IR (BeholdTV) as /devices/virtual/rc/rc0/input5
[  109.946212] rc0: i2c IR (BeholdTV) as /devices/virtual/rc/rc0
[  109.946214] ir-kbd-i2c: i2c IR (BeholdTV) detected at i2c-7/7-002d/ir0 [saa7133[0]]
[  109.946598] saa7134 0000:04:01.0: registered master spi32766 (dynamic)
[  109.946601] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[  109.946603] saa7133[0]: found muPD61151 MPEG encoder
[  109.968822] spi spi32766.0: spi_bitbang_setup, 20 nsec/bit
[  109.968829] spi spi32766.0: setup mode 0, 8 bits/w, 50000000 Hz max --> 0
[  109.968857] upd61151_probe function
[  109.968861] saa7134 0000:04:01.0: registered child spi32766.0
[  109.968944] xc5000: xc5000_sleep()
[  109.968945] xc5000: xc5000_TunerReset()
[  109.990089] saa7133[0]: registered device video0 [v4l2]
[  109.990135] saa7133[0]: registered device vbi0
[  109.990188] saa7133[0]: registered device radio0
[  109.990191] befor request_submodules
[  109.990290] request_mod_async
[  109.990292] request mod empress
[  110.004059] sap
[  110.004093] sap
[  110.005390] sap
[  110.006140] saa7134_ts_register start
[  110.006142] mpeg_ops_attach start
[  110.006195] saa7133[0]: registered device video1 [mpeg]
[  110.006197] mpeg_ops_attach OK stop
[  110.006199] saa7134_ts_register stop
[  110.006287] dvb = 2
[  110.006289] request mod dvb
[  110.007260] xc5000: xc5000_is_firmware_loaded() returns False id = 0x2000
[  110.007263] xc5000: xc_load_fw_and_init_tuner()
[  110.007533] ts_open() start
[  110.007536] ts_open() stop
[  110.007541] empress_querycap() start
[  110.007543] empress_querycap() stop
[  110.007572] ts_release() start
[  110.007574] ts_reset_encoder() start
[  110.007576] ts_release() stop
[  110.010025] xc5000: xc5000_is_firmware_loaded() returns True id = 0x20
[  110.010028] xc5000: xc5000_set_radio_freq()
[  110.010029] xc5000: xc5000_set_radio_freq() frequency=1400000 (in units of khz)
[  110.010031] xc5000: xc5000_set_radio_freq() radio input not configured
[  110.010074] xc5000: xc5000_sleep()
[  110.010076] xc5000: xc5000_TunerReset()
[  110.010164] xc5000: I2C read failed
[  110.010166] xc5000: xc5000_is_firmware_loaded() returns False id = 0xf4f1
[  110.010168] xc5000: xc_load_fw_and_init_tuner()
[  110.010340] xc5000: I2C read failed
[  110.010342] xc5000: xc5000_is_firmware_loaded() returns False id = 0xf805
[  110.010344] xc5000: xc5000_fwupload()
[  110.010345] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  110.010515] xc5000: I2C read failed
[  110.010517] xc5000: xc5000_is_firmware_loaded() returns False id = 0xf805
[  110.010519] xc5000: xc5000_fwupload()
[  110.010520] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  110.010529] ------------[ cut here ]------------
[  110.010535] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x70/0x85()
[  110.010537] Hardware name: G31M-ES2L
[  110.010538] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/firmware/0000:04:01.0'
[  110.010540] Modules linked in: saa7134_empress upd61151 rc_behold ir_kbd_i2c tuner ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder saa7134 ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core videobuf_dma_sg videobuf_core v4l2_common videodev spi_bitbang tveeprom xc5000 ppdev lp ipv6 fuse sha1_generic arc4 ecb ppp_mppe ppp_generic slhc loop nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd i2c_i801 soundcore i2c_core processor rng_core snd_page_alloc intel_agp tpm_tis psmouse parport_pc pcspkr intel_gtt tpm thermal_sys parport button evdev agpgart tpm_bios serio_raw ext3 jbd mbcache sg sd_mod sr_mod cdrom ata_generic ata_piix uhci_hcd libata ehci_hcd scsi_mod ide_pci_generic ide_core usbcore r8169 mii nls_base [last unloaded: scsi_wait_scan]
[  110.010603] Pid: 2355, comm: v4l_id Tainted: P            2.6.38-x7-01+ #13
[  110.010605] Call Trace:
[  110.010610]  [<c1033202>] ? warn_slowpath_common+0x65/0x7a
[  110.010613]  [<c103328a>] ? warn_slowpath_fmt+0x2b/0x2f
[  110.010616]  [<c110bc0b>] ? sysfs_add_one+0x70/0x85
[  110.010619]  [<c110c3fc>] ? create_dir+0x5b/0x8a
[  110.010622]  [<c110c4b1>] ? sysfs_create_dir+0x86/0x9f
[  110.010626]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.010630]  [<c1148758>] ? kobject_add_internal+0xb7/0x158
[  110.010633]  [<c11488b2>] ? kobject_add_varg+0x35/0x41
[  110.010635]  [<c1148923>] ? kobject_add+0x43/0x49
[  110.010640]  [<c11c2869>] ? device_add+0x94/0x4e8
[  110.010643]  [<c1148875>] ? kobject_set_name_vargs+0x48/0x50
[  110.010646]  [<c11c1ea5>] ? dev_set_name+0x19/0x1b
[  110.010649]  [<c11ca12f>] ? _request_firmware+0x150/0x2dc
[  110.010652]  [<c11ca331>] ? request_firmware+0x11/0x14
[  110.010657]  [<f80565fa>] ? xc_load_fw_and_init_tuner+0x95/0x26b [xc5000]
[  110.010663]  [<f87231db>] ? i2c_unlock_adapter+0x30/0x32 [i2c_core]
[  110.010667]  [<c1265441>] ? printk+0x14/0x1b
[  110.010670]  [<c1265441>] ? printk+0x14/0x1b
[  110.010673]  [<f805635e>] ? xc5000_is_firmware_loaded+0x62/0x6c [xc5000]
[  110.010677]  [<f8056be4>] ? xc5000_set_analog_params+0x3c/0x305 [xc5000]
[  110.010680]  [<f81cc0b0>] ? fe_set_params+0x48/0x4d [tuner]
[  110.010683]  [<f81cb5ec>] ? set_tv_freq+0x1ac/0x1b4 [tuner]
[  110.010686]  [<f81cb6d8>] ? set_mode_freq+0xe4/0xff [tuner]
[  110.010689]  [<f81cb8d4>] ? tuner_s_std+0x26/0x5aa [tuner]
[  110.010692]  [<f81cb8ae>] ? tuner_s_std+0x0/0x5aa [tuner]
[  110.010697]  [<f816a7a1>] ? saa7134_set_tvnorm_hw+0x249/0x2df [saa7134]
[  110.010702]  [<f816b8de>] ? set_tvnorm+0xc3/0xcb [saa7134]
[  110.010707]  [<f816bf03>] ? video_mux+0x53/0x75 [saa7134]
[  110.010711]  [<f816d2a6>] ? video_open+0x1f4/0x1fe [saa7134]
[  110.010715]  [<f8093595>] ? v4l2_open+0x9f/0xc3 [videodev]
[  110.010720]  [<c10c5fa8>] ? chrdev_open+0x1aa/0x1c2
[  110.010723]  [<c10c1dcf>] ? __dentry_open+0x1a5/0x283
[  110.010725]  [<c10c1f57>] ? nameidata_to_filp+0x3f/0x4d
[  110.010728]  [<c10c5dfe>] ? chrdev_open+0x0/0x1c2
[  110.010731]  [<c10cc811>] ? finish_open+0x90/0x12f
[  110.010734]  [<c10ce548>] ? do_filp_open+0x1b2/0x594
[  110.010738]  [<c102ac35>] ? get_parent_ip+0xb/0x31
[  110.010741]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.010744]  [<c10d711b>] ? alloc_fd+0xd9/0xe3
[  110.010747]  [<c10c1b41>] ? do_sys_open+0x49/0xc4
[  110.010750]  [<c10c1c08>] ? sys_open+0x23/0x2b
[  110.010753]  [<c100298c>] ? sysenter_do_call+0x12/0x22
[  110.010755] ---[ end trace d9bd101807401f13 ]---
[  110.010758] kobject_add_internal failed for 0000:04:01.0 with -EEXIST, don't try to register things with the same name in the same directory.
[  110.010762] Pid: 2355, comm: v4l_id Tainted: P        W   2.6.38-x7-01+ #13
[  110.010764] Call Trace:
[  110.010766]  [<c11487c8>] ? kobject_add_internal+0x127/0x158
[  110.010769]  [<c11487e7>] ? kobject_add_internal+0x146/0x158
[  110.010772]  [<c11488b2>] ? kobject_add_varg+0x35/0x41
[  110.010775]  [<c1148923>] ? kobject_add+0x43/0x49
[  110.010778]  [<c11c2869>] ? device_add+0x94/0x4e8
[  110.010781]  [<c1148875>] ? kobject_set_name_vargs+0x48/0x50
[  110.010784]  [<c11c1ea5>] ? dev_set_name+0x19/0x1b
[  110.010786]  [<c11ca12f>] ? _request_firmware+0x150/0x2dc
[  110.010789]  [<c11ca331>] ? request_firmware+0x11/0x14
[  110.010793]  [<f80565fa>] ? xc_load_fw_and_init_tuner+0x95/0x26b [xc5000]
[  110.010798]  [<f87231db>] ? i2c_unlock_adapter+0x30/0x32 [i2c_core]
[  110.010801]  [<c1265441>] ? printk+0x14/0x1b
[  110.010804]  [<c1265441>] ? printk+0x14/0x1b
[  110.010807]  [<f805635e>] ? xc5000_is_firmware_loaded+0x62/0x6c [xc5000]
[  110.010811]  [<f8056be4>] ? xc5000_set_analog_params+0x3c/0x305 [xc5000]
[  110.010814]  [<f81cc0b0>] ? fe_set_params+0x48/0x4d [tuner]
[  110.010817]  [<f81cb5ec>] ? set_tv_freq+0x1ac/0x1b4 [tuner]
[  110.010820]  [<f81cb6d8>] ? set_mode_freq+0xe4/0xff [tuner]
[  110.010823]  [<f81cb8d4>] ? tuner_s_std+0x26/0x5aa [tuner]
[  110.010826]  [<f81cb8ae>] ? tuner_s_std+0x0/0x5aa [tuner]
[  110.010830]  [<f816a7a1>] ? saa7134_set_tvnorm_hw+0x249/0x2df [saa7134]
[  110.010835]  [<f816b8de>] ? set_tvnorm+0xc3/0xcb [saa7134]
[  110.010839]  [<f816bf03>] ? video_mux+0x53/0x75 [saa7134]
[  110.010844]  [<f816d2a6>] ? video_open+0x1f4/0x1fe [saa7134]
[  110.010848]  [<f8093595>] ? v4l2_open+0x9f/0xc3 [videodev]
[  110.010851]  [<c10c5fa8>] ? chrdev_open+0x1aa/0x1c2
[  110.010854]  [<c10c1dcf>] ? __dentry_open+0x1a5/0x283
[  110.010856]  [<c10c1f57>] ? nameidata_to_filp+0x3f/0x4d
[  110.010859]  [<c10c5dfe>] ? chrdev_open+0x0/0x1c2
[  110.010862]  [<c10cc811>] ? finish_open+0x90/0x12f
[  110.010864]  [<c10ce548>] ? do_filp_open+0x1b2/0x594
[  110.010868]  [<c102ac35>] ? get_parent_ip+0xb/0x31
[  110.010871]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.010873]  [<c10d711b>] ? alloc_fd+0xd9/0xe3
[  110.010876]  [<c10c1b41>] ? do_sys_open+0x49/0xc4
[  110.010879]  [<c10c1c08>] ? sys_open+0x23/0x2b
[  110.010881]  [<c100298c>] ? sysenter_do_call+0x12/0x22
[  110.010885] saa7134 0000:04:01.0: fw_create_instance: device_register failed
[  110.010887] xc5000: Upload failed. (file not found?)
[  110.010889] xc5000: Unable to load firmware and init tuner
[  110.010892] DEBUG uPD61151: upd61151_s_std
[  110.010894] DEBUG uPD61151: upd61151_s_std
[  110.011023] xc5000: xc5000_sleep()
[  110.011025] xc5000: xc5000_TunerReset()
[  110.025501] ts_open() start
[  110.025505] ts_open() stop
[  110.025510] empress_querycap() start
[  110.025512] empress_querycap() stop
[  110.025908] ts_release() start
[  110.025911] ts_reset_encoder() start
[  110.025913] ts_release() stop
[  110.035948] sap
[  110.038427] sap
[  110.039021] xc5000: xc5000_is_firmware_loaded() returns False id = 0x2000
[  110.039026] xc5000: xc_load_fw_and_init_tuner()
[  110.042013] xc5000: xc5000_is_firmware_loaded() returns True id = 0x20
[  110.042018] xc5000: xc5000_set_tv_freq()
[  110.042022] xc5000: xc5000_set_tv_freq() frequency=6400 (in units of 62.5khz)
[  110.042026] xc5000: xc_SetSignalSource()
[  110.042029] xc5000: xc_SetSignalSource(1) Source = CABLE
[  110.045015] xc5000: xc5000_is_firmware_loaded() returns False id = 0x2000
[  110.045019] xc5000: xc5000_fwupload()
[  110.045023] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  110.045042] ------------[ cut here ]------------
[  110.045052] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x70/0x85()
[  110.045056] Hardware name: G31M-ES2L
[  110.045059] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/firmware/0000:04:01.0'
[  110.045064] Modules linked in: saa7134_empress upd61151 rc_behold ir_kbd_i2c tuner ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder saa7134 ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core videobuf_dma_sg videobuf_core v4l2_common videodev spi_bitbang tveeprom xc5000 ppdev lp ipv6 fuse sha1_generic arc4 ecb ppp_mppe ppp_generic slhc loop nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd i2c_i801 soundcore i2c_core processor rng_core snd_page_alloc intel_agp tpm_tis psmouse parport_pc pcspkr intel_gtt tpm thermal_sys parport button evdev agpgart tpm_bios serio_raw ext3 jbd mbcache sg sd_mod sr_mod cdrom ata_generic ata_piix uhci_hcd libata ehci_hcd scsi_mod ide_pci_generic ide_core usbcore r8169 mii nls_base [last unloaded: scsi_wait_scan]
[  110.045193] Pid: 2370, comm: hald-probe-vide Tainted: P        W   2.6.38-x7-01+ #13
[  110.045202] Call Trace:
[  110.045207]  [<c1033202>] ? warn_slowpath_common+0x65/0x7a
[  110.045210]  [<c103328a>] ? warn_slowpath_fmt+0x2b/0x2f
[  110.045213]  [<c110bc0b>] ? sysfs_add_one+0x70/0x85
[  110.045216]  [<c110c3fc>] ? create_dir+0x5b/0x8a
[  110.045219]  [<c110c4b1>] ? sysfs_create_dir+0x86/0x9f
[  110.045223]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.045227]  [<c1148758>] ? kobject_add_internal+0xb7/0x158
[  110.045230]  [<c11488b2>] ? kobject_add_varg+0x35/0x41
[  110.045232]  [<c1148923>] ? kobject_add+0x43/0x49
[  110.045236]  [<c11c2869>] ? device_add+0x94/0x4e8
[  110.045239]  [<c1148875>] ? kobject_set_name_vargs+0x48/0x50
[  110.045242]  [<c11c1ea5>] ? dev_set_name+0x19/0x1b
[  110.045246]  [<c11ca12f>] ? _request_firmware+0x150/0x2dc
[  110.045249]  [<c11ca331>] ? request_firmware+0x11/0x14
[  110.045254]  [<f80565fa>] ? xc_load_fw_and_init_tuner+0x95/0x26b [xc5000]
[  110.045261]  [<f87231db>] ? i2c_unlock_adapter+0x30/0x32 [i2c_core]
[  110.045265]  [<f87232b8>] ? i2c_transfer+0xa9/0xb3 [i2c_core]
[  110.045348]  [<c1265441>] ? printk+0x14/0x1b
[  110.045352]  [<f805635e>] ? xc5000_is_firmware_loaded+0x62/0x6c [xc5000]
[  110.045356]  [<f8056be4>] ? xc5000_set_analog_params+0x3c/0x305 [xc5000]
[  110.045359]  [<f81cc0b0>] ? fe_set_params+0x48/0x4d [tuner]
[  110.045362]  [<f81cb438>] ? set_radio_freq+0x1c8/0x1d0 [tuner]
[  110.045365]  [<c114dfeb>] ? delay_tsc+0x7f/0x98
[  110.045368]  [<f81cb6bf>] ? set_mode_freq+0xcb/0xff [tuner]
[  110.045371]  [<f81cb778>] ? tuner_s_radio+0x1d/0x21 [tuner]
[  110.045376]  [<f816d279>] ? video_open+0x1c7/0x1fe [saa7134]
[  110.045381]  [<f8093595>] ? v4l2_open+0x9f/0xc3 [videodev]
[  110.045385]  [<c10c5fa8>] ? chrdev_open+0x1aa/0x1c2
[  110.045389]  [<c10c1dcf>] ? __dentry_open+0x1a5/0x283
[  110.045391]  [<c10c1f57>] ? nameidata_to_filp+0x3f/0x4d
[  110.045394]  [<c10c5dfe>] ? chrdev_open+0x0/0x1c2
[  110.045397]  [<c10cc811>] ? finish_open+0x90/0x12f
[  110.045400]  [<c10ce548>] ? do_filp_open+0x1b2/0x594
[  110.045404]  [<c102ac35>] ? get_parent_ip+0xb/0x31
[  110.045407]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.045410]  [<c10d711b>] ? alloc_fd+0xd9/0xe3
[  110.045413]  [<c10c1b41>] ? do_sys_open+0x49/0xc4
[  110.045416]  [<c10c1c08>] ? sys_open+0x23/0x2b
[  110.045419]  [<c100298c>] ? sysenter_do_call+0x12/0x22
[  110.045421] ---[ end trace d9bd101807401f14 ]---
[  110.045424] kobject_add_internal failed for 0000:04:01.0 with -EEXIST, don't try to register things with the same name in the same directory.
[  110.045428] Pid: 2370, comm: hald-probe-vide Tainted: P        W   2.6.38-x7-01+ #13
[  110.045430] Call Trace:
[  110.045432]  [<c11487c8>] ? kobject_add_internal+0x127/0x158
[  110.045435]  [<c11487e7>] ? kobject_add_internal+0x146/0x158
[  110.045438]  [<c11488b2>] ? kobject_add_varg+0x35/0x41
[  110.045441]  [<c1148923>] ? kobject_add+0x43/0x49
[  110.045444]  [<c11c2869>] ? device_add+0x94/0x4e8
[  110.045447]  [<c1148875>] ? kobject_set_name_vargs+0x48/0x50
[  110.045450]  [<c11c1ea5>] ? dev_set_name+0x19/0x1b
[  110.045452]  [<c11ca12f>] ? _request_firmware+0x150/0x2dc
[  110.045455]  [<c11ca331>] ? request_firmware+0x11/0x14
[  110.045459]  [<f80565fa>] ? xc_load_fw_and_init_tuner+0x95/0x26b [xc5000]
[  110.045465]  [<f87231db>] ? i2c_unlock_adapter+0x30/0x32 [i2c_core]
[  110.045469]  [<f87232b8>] ? i2c_transfer+0xa9/0xb3 [i2c_core]
[  110.045472]  [<c1265441>] ? printk+0x14/0x1b
[  110.045475]  [<f805635e>] ? xc5000_is_firmware_loaded+0x62/0x6c [xc5000]
[  110.045479]  [<f8056be4>] ? xc5000_set_analog_params+0x3c/0x305 [xc5000]
[  110.045482]  [<f81cc0b0>] ? fe_set_params+0x48/0x4d [tuner]
[  110.045485]  [<f81cb438>] ? set_radio_freq+0x1c8/0x1d0 [tuner]
[  110.045487]  [<c114dfeb>] ? delay_tsc+0x7f/0x98
[  110.045490]  [<f81cb6bf>] ? set_mode_freq+0xcb/0xff [tuner]
[  110.045493]  [<f81cb778>] ? tuner_s_radio+0x1d/0x21 [tuner]
[  110.045498]  [<f816d279>] ? video_open+0x1c7/0x1fe [saa7134]
[  110.045502]  [<f8093595>] ? v4l2_open+0x9f/0xc3 [videodev]
[  110.045505]  [<c10c5fa8>] ? chrdev_open+0x1aa/0x1c2
[  110.045508]  [<c10c1dcf>] ? __dentry_open+0x1a5/0x283
[  110.045511]  [<c10c1f57>] ? nameidata_to_filp+0x3f/0x4d
[  110.045514]  [<c10c5dfe>] ? chrdev_open+0x0/0x1c2
[  110.045516]  [<c10cc811>] ? finish_open+0x90/0x12f
[  110.045519]  [<c10ce548>] ? do_filp_open+0x1b2/0x594
[  110.045523]  [<c102ac35>] ? get_parent_ip+0xb/0x31
[  110.045526]  [<c102c972>] ? sub_preempt_count+0x88/0x95
[  110.045528]  [<c10d711b>] ? alloc_fd+0xd9/0xe3
[  110.045531]  [<c10c1b41>] ? do_sys_open+0x49/0xc4
[  110.045534]  [<c10c1c08>] ? sys_open+0x23/0x2b
[  110.045536]  [<c100298c>] ? sysenter_do_call+0x12/0x22
[  110.045540] saa7134 0000:04:01.0: fw_create_instance: device_register failed
[  110.045543] xc5000: Upload failed. (file not found?)
[  110.045545] xc5000: Unable to load firmware and init tuner
[  110.046069] xc5000: xc5000_sleep()
[  110.046071] xc5000: xc5000_TunerReset()
[  110.047147] xc5000: I2C read failed
[  110.047149] xc5000: xc_SetSignalSource(1) failed
[  110.047151] DEBUG uPD61151: upd61151_s_std
[  110.047153] DEBUG uPD61151: upd61151_s_std
[  110.047914] xc5000: xc5000_sleep()
[  110.047916] xc5000: xc5000_TunerReset()
[  110.103587] xc5000: firmware read 12401 bytes.
[  110.103591] xc5000: firmware uploading...
[  110.103600] xc5000: xc5000_TunerReset()
[  110.155150] call saa7134_ts_register
[  110.155152] saa7134_ts_register start
[  110.155154] mpeg_ops_attach start
[  110.155155] mpeg_ops_attach FAIL stop, mops already exist FAILURE
[  110.155157] saa7134_ts_register stop
[  110.159265] saa7134 ALSA driver for DMA sound loaded
[  110.159296] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1
[  112.204009] xc5000: firmware upload complete...
[  112.204025] xc5000: xc_initialize()
[  112.378012] xc5000: xc5000_set_tv_freq()
[  112.378018] xc5000: xc5000_set_tv_freq() frequency=6400 (in units of 62.5khz)
[  112.378022] xc5000: xc_SetSignalSource()
[  112.378025] xc5000: xc_SetSignalSource(1) Source = CABLE
[  112.383011] xc5000: xc_SetTVStandard()
[  112.383015] xc5000: xc_SetTVStandard(0x8049,0x0c04)
[  112.383019] xc5000: xc_SetTVStandard() Standard = B/G-PAL-NICAM
[  112.398010] xc5000: xc_tune_channel(400000000)
[  112.398013] xc5000: xc_set_RF_frequency(400000000)
[  112.574048] xc5000: WaitForLock()
[  112.574053] xc5000: xc_get_lock_status()
[  112.583009] xc5000: xc_get_lock_status()
[  112.592008] xc5000: xc_get_lock_status()
[  112.601010] xc5000: xc_get_lock_status()
[  112.610009] xc5000: xc_get_lock_status()
[  112.619008] xc5000: xc_get_lock_status()
[  112.628012] xc5000: xc_get_lock_status()
[  112.637012] xc5000: xc_get_lock_status()
[  112.646018] xc5000: xc_get_lock_status()
[  112.655011] xc5000: xc_get_lock_status()
[  112.664010] xc5000: xc_get_lock_status()
[  112.673010] xc5000: xc_get_lock_status()
[  112.682010] xc5000: xc_get_lock_status()
[  112.691010] xc5000: xc_get_lock_status()
[  112.700012] xc5000: xc_get_lock_status()
[  112.709010] xc5000: xc_get_lock_status()
[  112.718012] xc5000: xc_get_lock_status()
[  112.727010] xc5000: xc_get_lock_status()
[  112.736010] xc5000: xc_get_lock_status()
[  112.745010] xc5000: xc_get_lock_status()
[  112.754012] xc5000: xc_get_lock_status()
[  112.763010] xc5000: xc_get_lock_status()
[  112.772010] xc5000: xc_get_lock_status()
[  112.781010] xc5000: xc_get_lock_status()
[  112.790010] xc5000: xc_get_lock_status()
[  112.799010] xc5000: xc_get_lock_status()
[  112.808010] xc5000: xc_get_lock_status()
[  112.817012] xc5000: xc_get_lock_status()
[  112.826012] xc5000: xc_get_lock_status()
[  112.835010] xc5000: xc_get_lock_status()
[  112.844010] xc5000: xc_get_lock_status()
[  112.954018] xc5000: xc_get_ADC_Envelope()
[  112.957011] xc5000: *** ADC envelope (0-1023) = 828
[  112.957014] xc5000: xc_get_frequency_error()
[  112.960010] xc5000: *** Frequency error = 625 Hz
[  112.960013] xc5000: xc_get_lock_status()
[  112.963010] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 2
[  112.963013] xc5000: xc_get_version()
[  112.966012] xc5000: xc_get_buildversion()
[  112.969011] xc5000: *** HW: V03.02, FW: V01.06.0072
[  112.969015] xc5000: xc_get_hsync_freq()
[  112.972009] xc5000: *** Horizontal sync frequency = 15733 Hz
[  112.972013] xc5000: xc_get_frame_lines()
[  112.975016] xc5000: *** Frame lines = 65535
[  112.975021] xc5000: xc_get_quality()
[  112.978011] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5
[  112.978017] DEBUG uPD61151: upd61151_s_std
[  112.978020] DEBUG uPD61151: upd61151_s_std
[  112.978202] xc5000: xc5000_sleep()
[  112.978204] xc5000: xc5000_TunerReset()
[  113.003673] sap
[  113.006016] xc5000: xc5000_is_firmware_loaded() returns False id = 0x2000
[  113.006020] xc5000: xc_load_fw_and_init_tuner()
[  113.009013] xc5000: xc5000_is_firmware_loaded() returns True id = 0x20
[  113.009017] xc5000: xc_initialize()
[  114.915011] xc5000: xc5000_set_tv_freq()
[  114.915018] xc5000: xc5000_set_tv_freq() frequency=6400 (in units of 62.5khz)
[  114.915021] xc5000: xc_SetSignalSource()
[  114.915025] xc5000: xc_SetSignalSource(1) Source = CABLE
[  115.817013] xc5000: xc_SetTVStandard()
[  115.817018] xc5000: xc_SetTVStandard(0x8049,0x0c04)
[  115.817022] xc5000: xc_SetTVStandard() Standard = B/G-PAL-NICAM
[  118.523012] xc5000: xc_tune_channel(400000000)
[  118.523016] xc5000: xc_set_RF_frequency(400000000)
[  119.427013] xc5000: WaitForLock()
[  119.427018] xc5000: xc_get_lock_status()
[  119.537015] xc5000: xc_get_ADC_Envelope()
[  119.540014] xc5000: *** ADC envelope (0-1023) = 1796
[  119.540018] xc5000: xc_get_frequency_error()
[  119.543010] xc5000: *** Frequency error = 47296 Hz
[  119.543014] xc5000: xc_get_lock_status()
[  119.546010] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 27390
[  119.546014] xc5000: xc_get_version()
[  119.549011] xc5000: xc_get_buildversion()
[  119.552010] xc5000: *** HW: V00.00, FW: V00.00.0000
[  119.552014] xc5000: xc_get_hsync_freq()
[  119.555010] xc5000: *** Horizontal sync frequency = 7340 Hz
[  119.555013] xc5000: xc_get_frame_lines()
[  119.558009] xc5000: *** Frame lines = 62420
[  119.558012] xc5000: xc_get_quality()
[  119.561009] xc5000: *** Quality (0:<8dB, 7:>56dB) = 0
[  119.561015] DEBUG uPD61151: upd61151_s_std
[  119.561018] DEBUG uPD61151: upd61151_s_std
[  119.561787] xc5000: xc5000_sleep()
[  119.561789] xc5000: xc5000_TunerReset()

> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

With my best regards, Dmitry.
