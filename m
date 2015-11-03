Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36190 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbbKCSWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 13:22:12 -0500
Received: by wmec75 with SMTP id c75so93921999wme.1
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2015 10:22:11 -0800 (PST)
Received: from [192.168.1.100] (201.247.115.87.dyn.plus.net. [87.115.247.201])
        by smtp.gmail.com with ESMTPSA id c1sm28831893wjf.19.2015.11.03.10.22.10
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 03 Nov 2015 10:22:10 -0800 (PST)
From: John Barberio <john.r.barberio@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: dvb_usb_cxusb triggers "DMA-API: device driver maps memory from stack" error
Message-Id: <B5783C39-A66C-477E-95BA-3D8B92726E1F@gmail.com>
Date: Tue, 3 Nov 2015 18:22:09 +0000
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Attaching an August DVB-T210 usb stick to the system causes a "DMA-API: device driver maps memory from stack" error, and while the device registers and appears functional, no data is produced from the tuner.

Bus 001 Device 007: ID 0572:c688 Conexant Systems (Rockwell), Inc. Geniatech T230 DVB-T2 TV Stick

[ 1582.310802] i2c i2c-11: cxd2820r: i2c rd failed=-5 reg=10 len=1
[ 2352.832621] perf interrupt took too long (5005 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[ 3954.856707] usb 1-3.2: new high-speed USB device number 7 using xhci_hcd
[ 3954.948021] usb 1-3.2: language id specifier not provided by device, defaulting to English
[ 3954.951324] usb 1-3.2: New USB device found, idVendor=0572, idProduct=c688
[ 3954.951332] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4062.922871] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[ 4062.923388] ------------[ cut here ]------------
[ 4062.923405] WARNING: CPU: 1 PID: 19330 at lib/dma-debug.c:1169 check_for_stack+0x90/0xd0()
[ 4062.923409] xhci_hcd 0000:00:14.0: DMA-API: device driver maps memory from stack [addr=ffff88004c68b998]
[ 4062.923412] Modules linked in: dvb_usb_cxusb(+) dib0070 dvb_usb rc_pinnacle_pctv_hd em28xx_rc tda18271 cxd2820r em28xx_dvb dvb_core em28xx tveeprom v4l2_common videodev media snd_hda_codec_hdmi arc4 iwlmvm snd_hda_codec_realtek intel_rapl coretemp iTCO_wdt iTCO_vendor_support kvm_intel btusb snd_hda_codec_generic kvm btrtl snd_hda_intel btbcm btintel mac80211 snd_hda_codec snd_intel_sst_acpi bluetooth snd_intel_sst_core crct10dif_pclmul snd_soc_rt5670 snd_soc_sst_mfld_platform snd_hda_core crc32_pclmul snd_soc_rl6231 crc32c_intel snd_soc_core snd_compress snd_hwdep snd_pcm_dmaengine ac97_bus iwlwifi cfg80211 joydev r8169 i915 mii tpm_tis snd_seq ir_lirc_codec i2c_algo_bit i2c_i801 tpm lpc_ich lirc_dev ir_rc5_decoder ir_sanyo_decoder ir_nec_decoder ir_rc6_decoder ir_sony_decoder ir_jvc_decoder ir_xmp_decoder
[ 4062.923516]  ir_sharp_decoder ir_mce_kbd_decoder drm_kms_helper snd_seq_device rc_rc6_mce snd_pcm ite_cir drm snd_timer rc_core dw_dmac video snd rfkill_gpio rfkill fjes mei_txe i2c_designware_platform i2c_designware_pci i2c_designware_core soundcore soc_button_array shpchp pinctrl_cherryview dw_dmac_pci dw_dmac_core mei iosf_mbi nfsd auth_rpcgss nfs_acl lockd grace sunrpc hid_logitech_hidpp uas usb_storage hid_logitech_dj serio_raw sdhci_pci sdhci_acpi sdhci i2c_hid mmc_core
[ 4062.923584] CPU: 1 PID: 19330 Comm: modprobe Not tainted 4.3.0-0.rc6.git2.1.fc24.x86_64 #1
[ 4062.923587] Hardware name:                  /NUC5CPYB, BIOS PYBSWCEL.86A.0044.2015.0925.1143 09/25/2015
[ 4062.923591]  0000000000000000 00000000e8e1feb9 ffff88004c68b580 ffffffff81419a49
[ 4062.923599]  ffff88004c68b5c8 ffff88004c68b5b8 ffffffff810a9c12 ffff88004c68b998
[ 4062.923606]  ffff88017a7fb098 ffff88017a792990 0000000000000002 0000000000000001
[ 4062.923613] Call Trace:
[ 4062.923619]  [<ffffffff81419a49>] dump_stack+0x4b/0x72
[ 4062.923625]  [<ffffffff810a9c12>] warn_slowpath_common+0x82/0xc0
[ 4062.923630]  [<ffffffff810a9cac>] warn_slowpath_fmt+0x5c/0x80
[ 4062.923635]  [<ffffffff8144ae40>] check_for_stack+0x90/0xd0
[ 4062.923639]  [<ffffffff8144b41a>] debug_dma_map_page+0xfa/0x150
[ 4062.923646]  [<ffffffff81609dd8>] usb_hcd_map_urb_for_dma+0x5f8/0x780
[ 4062.923652]  [<ffffffff8119058b>] ? is_ftrace_trampoline+0x4b/0x70
[ 4062.923657]  [<ffffffff8160a3cd>] usb_hcd_submit_urb+0x1cd/0xab0
[ 4062.923662]  [<ffffffff81100d83>] ? __bfs+0x33/0x280
[ 4062.923667]  [<ffffffff81104e69>] ? mark_held_locks+0x79/0xa0
[ 4062.923671]  [<ffffffff8110b931>] ? __raw_spin_lock_init+0x21/0x60
[ 4062.923676]  [<ffffffff81101cf3>] ? lockdep_init_map+0x73/0x640
[ 4062.923680]  [<ffffffff81104fb9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[ 4062.923684]  [<ffffffff8160bfbc>] usb_submit_urb+0x3fc/0x5a0
[ 4062.923688]  [<ffffffff8160c864>] usb_start_wait_urb+0x74/0x180
[ 4062.923693]  [<ffffffff8160cdcd>] usb_bulk_msg+0xbd/0x160
[ 4062.923701]  [<ffffffffa099fcc8>] dvb_usb_generic_rw+0xd8/0x1d0 [dvb_usb]
[ 4062.923707]  [<ffffffffa099fdd9>] dvb_usb_generic_write+0x19/0x20 [dvb_usb]
[ 4062.923724]  [<ffffffffa09ac3fd>] cxusb_ctrl_msg+0xed/0x130 [dvb_usb_cxusb]
[ 4062.923730]  [<ffffffffa09a00de>] ? dvb_usb_set_active_fe+0x3e/0x70 [dvb_usb]
[ 4062.923737]  [<ffffffffa09aca28>] cxusb_power_ctrl+0x58/0x60 [dvb_usb_cxusb]
[ 4062.923817]  [<ffffffffa09adfdb>] cxusb_d680_dmb_power_ctrl+0x2b/0x90 [dvb_usb_cxusb]
[ 4062.923824]  [<ffffffff812481ce>] ? __kmalloc+0x28e/0x360
[ 4062.923831]  [<ffffffffa099f533>] dvb_usb_device_power_ctrl+0x33/0x50 [dvb_usb]
[ 4062.923844]  [<ffffffffa099f79a>] dvb_usb_device_init+0x24a/0x6a0 [dvb_usb]
[ 4062.923852]  [<ffffffffa09ac2f2>] cxusb_probe+0x1f2/0x210 [dvb_usb_cxusb]
[ 4062.923857]  [<ffffffff81610edb>] usb_probe_interface+0x1bb/0x2e0
[ 4062.923865]  [<ffffffff81573394>] driver_probe_device+0x224/0x480
[ 4062.923870]  [<ffffffff81573678>] __driver_attach+0x88/0x90
[ 4062.923875]  [<ffffffff815735f0>] ? driver_probe_device+0x480/0x480
[ 4062.923879]  [<ffffffff81570da3>] bus_for_each_dev+0x73/0xc0
[ 4062.923884]  [<ffffffff81572b2e>] driver_attach+0x1e/0x20
[ 4062.923888]  [<ffffffff8157265e>] bus_add_driver+0x1ee/0x280
[ 4062.923894]  [<ffffffff815741b0>] driver_register+0x60/0xe0
[ 4062.923898]  [<ffffffff8160f73d>] usb_register_driver+0xad/0x160
[ 4062.923903]  [<ffffffffa09c0000>] ? 0xffffffffa09c0000
[ 4062.923909]  [<ffffffffa09c001e>] cxusb_driver_init+0x1e/0x1000 [dvb_usb_cxusb]
[ 4062.923914]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
[ 4062.923920]  [<ffffffff811241ed>] ? rcu_read_lock_sched_held+0x6d/0x80
[ 4062.923924]  [<ffffffff81246f68>] ? kmem_cache_alloc_trace+0x298/0x320
[ 4062.923929]  [<ffffffff811dc869>] ? do_init_module+0x27/0x1e7
[ 4062.923934]  [<ffffffff811dc8a1>] do_init_module+0x5f/0x1e7
[ 4062.923940]  [<ffffffff8114e816>] load_module+0x2126/0x27d0
[ 4062.923944]  [<ffffffff8114a990>] ? __symbol_put+0x70/0x70
[ 4062.923952]  [<ffffffff81025a39>] ? sched_clock+0x9/0x10
[ 4062.923958]  [<ffffffff8114f032>] SyS_init_module+0x172/0x1b0
[ 4062.923965]  [<ffffffff818626f2>] entry_SYSCALL_64_fastpath+0x12/0x76
[ 4062.923969] ---[ end trace 70c708ff9151434b ]---
[ 4063.161495] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 4063.162930] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[ 4063.258902] i2c i2c-12: Added multiplexed i2c bus 13
[ 4063.258914] si2168 12-0064: Silicon Labs Si2168 successfully attached
[ 4063.305430] si2157 13-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[ 4063.305517] usb 1-3.2: DVB: registering adapter 1 frontend 0 (Silicon Labs Si2168)...
[ 4063.315675] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.2/input/input16
[ 4063.316968] dvb-usb: schedule remote query interval to 100 msecs.
[ 4063.317137] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized and connected.
[ 4063.317411] usbcore: registered new interface driver dvb_usb_cxusb
[ 4065.420026] dvb-usb: recv bulk message failed: -110
[ 4065.528396] si2168 12-0064: found a 'Silicon Labs Si2168-B40'
[ 4065.559259] si2168 12-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[ 4067.324412] si2168 12-0064: firmware version: 4.0.19
[ 4067.340144] si2157 13-0060: found a 'Silicon Labs Si2158-A20'
[ 4067.361010] si2157 13-0060: downloading firmware from file 'dvb-tuner-si2158-a20-01.fw'
[ 4068.530953] si2157 13-0060: firmware version: 2.1.6
[ 4068.531027] usb 1-3.2: DVB: adapter 1 frontend 0 frequency 0 out of range (55000000..862000000)