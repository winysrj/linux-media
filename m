Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:40353 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdKYUwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 15:52:12 -0500
Received: by mail-wm0-f45.google.com with SMTP id b189so28053837wmd.5
        for <linux-media@vger.kernel.org>; Sat, 25 Nov 2017 12:52:11 -0800 (PST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>
From: Gregor Jasny <gjasny@googlemail.com>
Subject: si2168: NULL pointer dereference at unplug
Message-ID: <130df1ac-a409-8df8-84cb-e2a72770e9f2@googlemail.com>
Date: Sat, 25 Nov 2017 21:52:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

when I unplug my August DVB-T230 stick I get the message below.
Is this a known issue?

If not, is there anything I could do to get you a better stack trace?

Thanks,
Gregor

[    9.573636] BUG: unable to handle kernel NULL pointer dereference at
00000000000000b8
[    9.573653] IP: si2168_sleep+0x26/0xd0 [si2168]
[    9.573655] PGD 0 P4D 0
[    9.573659] Oops: 0000 [#1] SMP
[    9.573662] Modules linked in: bnep nls_iso8859_1 cmdlinepart
intel_rapl intel_spi_platform intel_telemetry_pltdrv ir_nec_decoder
rc_total_media_in_hand_02 intel_spi intel_punit_ipc si2157 spi_nor media
intel_telemetry_core mtd intel_pmc_ipc si2168 i2c_mux
x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi snd_soc_skl
coretemp snd_soc_skl_ipc 8250_dw snd_soc_sst_ipc spi_pxa2xx_platform
kvm_intel snd_soc_sst_dsp kvm snd_hda_ext_core snd_hda_codec_realtek
snd_soc_sst_match snd_soc_rt298 snd_hda_codec_generic snd_soc_rt286
irqbypass snd_soc_rl6347a crct10dif_pclmul crc32_pclmul snd_soc_core
ghash_clmulni_intel snd_hda_intel snd_compress pcbc ac97_bus
snd_pcm_dmaengine snd_hda_codec snd_hda_core snd_hwdep snd_pcm arc4
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd snd_seq_midi
snd_seq_midi_event
[    9.573710]  intel_cstate snd_rawmidi intel_rapl_perf dvb_usb_cxusb
iwlmvm input_leds mac80211 serio_raw wmi_bmof btusb dib0070 btrtl
dvb_usb btbcm dvb_core btintel snd_seq bluetooth lpc_ich iwlwifi
ecdh_generic snd_seq_device snd_timer ir_rc6_decoder rtsx_pci_ms
cfg80211 idma64 virt_dma memstick intel_lpss_pci intel_lpss rc_rc6_mce
snd ir_lirc_codec mei_me lirc_dev mei shpchp ite_cir rfkill_gpio
soundcore rc_core mac_hid tpm_crb parport_pc ppdev lp parport ip_tables
x_tables autofs4 hid_apple usbhid hid i915 rtsx_pci_sdmmc i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops r8169 ahci
psmouse drm mii libahci rtsx_pci wmi video pinctrl_broxton pinctrl_intel
[    9.573768] CPU: 2 PID: 723 Comm: kdvb-ad-0-fe-0 Not tainted
4.14.0-041400-generic #201711122031
[    9.573770] Hardware name:                  /NUC6CAYB, BIOS
AYAPLCEL.86A.0041.2017.0825.1152 08/25/2017
[    9.573772] task: ffff90e130a8da00 task.stack: ffffa1c2021a4000
[    9.573775] RIP: 0010:si2168_sleep+0x26/0xd0 [si2168]
[    9.573777] RSP: 0000:ffffa1c2021a7e18 EFLAGS: 00010246
[    9.573779] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff90e12e1f89e8
[    9.573781] RDX: 0000000000000001 RSI: 0000000000000292 RDI:
ffff90e1328da028
[    9.573783] RBP: ffffa1c2021a7e60 R08: ffff90e13fd12278 R09:
0000000000000001
[    9.573785] R10: ffffa1c2021a7e90 R11: 0000000000000321 R12:
ffff90e133e852e0
[    9.573786] R13: 0000000000000000 R14: ffff90e12e1f89e0 R15:
ffff90e12e1f8800
[    9.573789] FS:  0000000000000000(0000) GS:ffff90e13fd00000(0000)
knlGS:0000000000000000
[    9.573791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.573792] CR2: 00000000000000b8 CR3: 0000000273b3c000 CR4:
00000000003406e0
[    9.573794] Call Trace:
[    9.573802]  ? call_timer_fn+0x130/0x130
[    9.573809]  dvb_usb_fe_sleep+0x37/0x60 [dvb_usb]
[    9.573818]  dvb_frontend_thread+0x282/0x6d0 [dvb_core]
[    9.573823]  ? wait_woken+0x80/0x80
[    9.573827]  kthread+0x125/0x140
[    9.573833]  ? dtv_set_frontend+0x410/0x410 [dvb_core]
[    9.573836]  ? kthread_create_on_node+0x70/0x70
[    9.573840]  ret_from_fork+0x25/0x30
[    9.573842] Code: 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 53
48 83 ec 38 48 8b 9f 18 03 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 e8
31 c0 <4c> 8b a3 b8 00 00 00 0f 1f 44 00 00 41 81 bc 24 4c 05 00 00 0b
[    9.573883] RIP: si2168_sleep+0x26/0xd0 [si2168] RSP: ffffa1c2021a7e18
[    9.573885] CR2: 00000000000000b8
[    9.573888] ---[ end trace c8685d2947f0e803 ]---

[   14.198372] BUG: unable to handle kernel NULL pointer dereference at
0000000000000180
[   14.198393] IP: _raw_spin_lock_irqsave+0x22/0x40
[   14.198396] PGD 0 P4D 0
[   14.198402] Oops: 0002 [#2] SMP
[   14.198405] Modules linked in: ccm bnep nls_iso8859_1 cmdlinepart
intel_rapl intel_spi_platform intel_telemetry_pltdrv ir_nec_decoder
rc_total_media_in_hand_02 intel_spi intel_punit_ipc si2157 spi_nor media
intel_telemetry_core mtd intel_pmc_ipc si2168 i2c_mux
x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi snd_soc_skl
coretemp snd_soc_skl_ipc 8250_dw snd_soc_sst_ipc spi_pxa2xx_platform
kvm_intel snd_soc_sst_dsp kvm snd_hda_ext_core snd_hda_codec_realtek
snd_soc_sst_match snd_soc_rt298 snd_hda_codec_generic snd_soc_rt286
irqbypass snd_soc_rl6347a crct10dif_pclmul crc32_pclmul snd_soc_core
ghash_clmulni_intel snd_hda_intel snd_compress pcbc ac97_bus
snd_pcm_dmaengine snd_hda_codec snd_hda_core snd_hwdep snd_pcm arc4
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd snd_seq_midi
snd_seq_midi_event
[   14.198471]  intel_cstate snd_rawmidi intel_rapl_perf dvb_usb_cxusb
iwlmvm input_leds mac80211 serio_raw wmi_bmof btusb dib0070 btrtl
dvb_usb btbcm dvb_core btintel snd_seq bluetooth lpc_ich iwlwifi
ecdh_generic snd_seq_device snd_timer ir_rc6_decoder rtsx_pci_ms
cfg80211 idma64 virt_dma memstick intel_lpss_pci intel_lpss rc_rc6_mce
snd ir_lirc_codec mei_me lirc_dev mei shpchp ite_cir rfkill_gpio
soundcore rc_core mac_hid tpm_crb parport_pc ppdev lp parport ip_tables
x_tables autofs4 hid_apple usbhid hid i915 rtsx_pci_sdmmc i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops r8169 ahci
psmouse drm mii libahci rtsx_pci wmi video pinctrl_broxton pinctrl_intel
[   14.198545] CPU: 1 PID: 855 Comm: frontend 0/0 tu Tainted: G      D
      4.14.0-041400-generic #201711122031
[   14.198549] Hardware name:                  /NUC6CAYB, BIOS
AYAPLCEL.86A.0041.2017.0825.1152 08/25/2017
[   14.198553] task: ffff90e133241680 task.stack: ffffa1c202264000
[   14.198557] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
[   14.198560] RSP: 0018:ffffa1c202267a68 EFLAGS: 00010046
[   14.198564] RAX: 0000000000000000 RBX: 0000000000000246 RCX:
0000000000000001
[   14.198567] RDX: 0000000000000001 RSI: ffffa1c202267c90 RDI:
0000000000000180
[   14.198570] RBP: ffffa1c202267a70 R08: ffff90e12e17cb01 R09:
ffff90e12b9b5b80
[   14.198573] R10: ffff90e12e17cb38 R11: ffff90e133241680 R12:
ffffa1c202267c90
[   14.198577] R13: 0000000000000180 R14: ffff90e1328da028 R15:
ffff90e12e17cb00
[   14.198581] FS:  00007face846a700(0000) GS:ffff90e13fc80000(0000)
knlGS:0000000000000000
[   14.198584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.198587] CR2: 0000000000000180 CR3: 00000002701fa000 CR4:
00000000003406e0
[   14.198591] Call Trace:
[   14.198599]  add_wait_queue+0x1a/0x50
[   14.198604]  __pollwait+0xb1/0xe0
[   14.198615]  dvb_frontend_poll+0x57/0xc0 [dvb_core]
[   14.198620]  do_sys_poll+0x26c/0x580
[   14.198624]  ? update_load_avg+0x429/0x590
[   14.198628]  ? set_next_entity+0xa9/0x1f0
[   14.198632]  ? pick_next_task_fair+0x2f2/0x580
[   14.198636]  ? __switch_to+0x1f3/0x4e0
[   14.198640]  ? poll_initwait+0x40/0x40
[   14.198644]  ? compat_poll_select_copy_remaining+0x120/0x120
[   14.198649]  ? hrtimer_try_to_cancel+0x2a/0x110
[   14.198653]  ? futex_wait_queue_me+0xd9/0x130
[   14.198657]  ? hrtimer_cancel+0x19/0x20
[   14.198660]  ? futex_wait+0x1e7/0x250
[   14.198664]  ? get_futex_key+0x2ec/0x3b0
[   14.198668]  ? futex_wake+0x8f/0x180
[   14.198672]  ? do_futex+0x2fa/0x500
[   14.198679]  ? dvb_generic_ioctl+0x23/0x40 [dvb_core]
[   14.198683]  ? do_vfs_ioctl+0xa5/0x600
[   14.198686]  ? ktime_get_ts64+0x4e/0xe0
[   14.198690]  SyS_poll+0x9b/0x130
[   14.198693]  ? SyS_poll+0x9b/0x130
[   14.198697]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[   14.198701] RIP: 0033:0x7facecbd3901
[   14.198703] RSP: 002b:00007face8469a10 EFLAGS: 00000293 ORIG_RAX:
0000000000000007
[   14.198707] RAX: ffffffffffffffda RBX: 000055f42ac07070 RCX:
00007facecbd3901
[   14.198711] RDX: 000000000000000a RSI: 0000000000000001 RDI:
00007face8469a80
[   14.198714] RBP: 00007face8469d50 R08: 0000000000000000 R09:
00000000ffffffff
[   14.198717] R10: 0000000000000001 R11: 0000000000000293 R12:
00007face8469d00
[   14.198720] R13: 000055f428dcd208 R14: 000055f42ac077b0 R15:
00000000000003e8
[   14.198724] Code: ff 66 90 5d c3 0f 1f 40 00 0f 1f 44 00 00 55 48 89
e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01 00
00 00 <f0> 0f b1 17 85 c0 75 06 48 89 d8 5b 5d c3 89 c6 e8 f9 d0 79 ff
[   14.198769] RIP: _raw_spin_lock_irqsave+0x22/0x40 RSP: ffffa1c202267a68
[   14.198772] CR2: 0000000000000180
[   14.198776] ---[ end trace c8685d2947f0e804 ]---

This is kernel 4.14.0 from Ubuntu Kernel PPA: 4.14.0-041400.201711122031

USB info:
Bus 001 Device 007: ID 0572:c689 Conexant Systems (Rockwell), Inc.

Kernel log when plugging in
[   65.835372] dvb-usb: Mygica T230C DVB-T/T2/C successfully
deinitialized and disconnected.
[14399.693995] usb 1-3: new high-speed USB device number 7 using xhci_hcd
[14399.842858] usb 1-3: New USB device found, idVendor=0572, idProduct=c689
[14399.842872] usb 1-3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[14399.842879] usb 1-3: Product: EyeTV Stick
[14399.842885] usb 1-3: Manufacturer: Geniatech
[14399.842891] usb 1-3: SerialNumber: 160421
[14399.843963] dvb-usb: found a 'Mygica T230C DVB-T/T2/C' in warm state.
[14400.086296] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[14400.086423] dvbdev: DVB: registering new adapter (Mygica T230C
DVB-T/T2/C)
[14400.099002] i2c i2c-6: Added multiplexed i2c bus 7
[14400.099013] si2168 6-0064: Silicon Labs Si2168-D60 successfully
identified
[14400.099017] si2168 6-0064: firmware version: D 6.0.1
[14400.103059] si2157 7-0060: Silicon Labs Si2141 successfully attached
[14400.103184] usb 1-3: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
[14400.104547] Registered IR keymap rc-total-media-in-hand-02
[14400.104688] rc rc1: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:15.0/usb1/1-3/rc/rc1
[14400.104833] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:15.0/usb1/1-3/rc/rc1/input19
[14400.105249] dvb-usb: schedule remote query interval to 100 msecs.
[14400.105316] dvb-usb: Mygica T230C DVB-T/T2/C successfully initialized
and connected.
[14402.218103] dvb-usb: recv bulk message failed: -110
