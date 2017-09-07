Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.oimel.net ([144.76.0.27]:54262 "EHLO mail.oimel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753969AbdIGPSs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 11:18:48 -0400
From: Sebastian Schmachtel <prisma_lkm@oimel.net>
To: linux-media@vger.kernel.org
Subject: dw2102 kernel oops
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <f9d14920-b629-ad2f-9445-556226359635@oimel.net>
Date: Thu, 7 Sep 2017 17:10:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently bought a Tevii S650 USB DVB-S2 device (dw2102 driver). But
when i connect it, my Desktop seems to get some HID inputs (some random
keys are typed in a terminal). Pretty strange, but I set
disable_rc_polling=1 for dvb_usb to get rid of this problem as the
pattern reminded me of a Remote.
But now i get oops (tried on two different linux systems). I verified
the Hardware on Windows 7 and it works fine... Currently i'm using
4.12.0-1-amd64 (debian testing), but I checked everything
4.9-4.12(Debian) and even 4.13 (vanilla) has the same problems.

Can anyone help me, or has some suggestions how to further debug?

[   11.106776] dvb-usb: found a 'TeVii S650 USB2.0' in warm state.
[   11.106830] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   11.106847] dvbdev: DVB: registering new adapter (TeVii S650 USB2.0)
[   11.106850] dw2102: read eeprom failed.
[   11.106909] dvb-usb: MAC address reading failed.
[   11.126813] [drm] ring test on 5 succeeded in 2 usecs
[   11.126823] [drm] UVD initialized successfully.
[   11.131852] Invalid probe, probably not a CX24116 device
[   11.144435] Invalid probe, probably not a DS3000
[   11.144495] dvb-usb: no frontend was attached by 'TeVii S650 USB2.0'
[   11.144631] dvb-usb: TeVii S650 USB2.0 successfully initialized and
connected.
[   11.144676] usbcore: registered new interface driver dw2102
[   11.144724] BUG: unable to handle kernel NULL pointer dereference at
0000000000000050
[   11.144794] IP: dw2102_disconnect+0x1a/0x70 [dvb_usb_dw2102]
[   11.144852] PGD 0
[   11.144852] P4D 0

[   11.145006] Oops: 0000 [#1] SMP
[   11.145061] Modules linked in: ds3000 cx24116 xfs amdkfd
snd_hda_codec_realtek snd_hda_codec_generic radeon(+) snd_hda_codec_hdmi
btusb btrtl btbcm btintel snd_hda_intel bluetooth snd_hda_codec
dvb_usb_dw2102 edac_mce_amd dvb_usb snd_hda_core ttm snd_hwdep dvb_core
snd_pcm_oss evdev snd_mixer_oss rc_core joydev ecdh_generic
drm_kms_helper kvm_amd snd_pcm rfkill kvm drm ccp snd_timer snd
irqbypass sg rng_core soundcore i2c_algo_bit pcspkr shpchp sp5100_tco
wmi button acpi_cpufreq loop firewire_sbp2 firewire_core crc_itu_t
parport_pc ppdev lp sunrpc parport ip_tables x_tables autofs4 ext4 crc16
jbd2 fscrypto ecb mbcache algif_skcipher af_alg dm_crypt dm_mod raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
hid_logitech_hidpp hid_logitech_dj raid6_pq libcrc32c crc32c_generic
[   11.145353]  raid0 multipath linear raid1 hid_generic md_mod usbhid
hid sd_mod uas usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper
cryptd ahci xhci_pci libahci i2c_piix4 xhci_hcd libata r8169 mii usbcore
scsi_mod usb_common gpio_amdpt gpio_generic i2c_designware_platform
i2c_designware_core
[   11.145511] CPU: 0 PID: 57 Comm: kworker/0:1 Not tainted
4.12.0-1-amd64 #1 Debian 4.12.6-1
[   11.145582] Hardware name: MSI MS-7A37/B350M MORTAR (MS-7A37), BIOS
1.55 06/22/2017
[   11.145658] Workqueue: usb_hub_wq hub_event [usbcore]
[   11.145720] task: ffff8c220c2c9000 task.stack: ffffb75841bb4000
[   11.145783] RIP: 0010:dw2102_disconnect+0x1a/0x70 [dvb_usb_dw2102]
[   11.145844] RSP: 0018:ffffb75841bb7c28 EFLAGS: 00010246
[   11.145904] RAX: ffff8c2209884000 RBX: ffff8c2206767c30 RCX:
0000000000000000
[   11.145968] RDX: 0000000000000000 RSI: ffff8c2206767c00 RDI:
ffff8c2206767c00
[   11.146031] RBP: ffff8c2206767c00 R08: 0000000000000000 R09:
0000000000000000
[   11.146095] R10: ffff8c220dc08240 R11: 0000000000000018 R12:
0000000000000000
[   11.146158] R13: ffff8c2206fd1000 R14: ffff8c2206fd1098 R15:
00000000ffffffed
[   11.146222] FS:  0000000000000000(0000) GS:ffff8c220e600000(0000)
knlGS:0000000000000000
[   11.146292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   11.146352] CR2: 0000000000000050 CR3: 0000000408af3000 CR4:
00000000003406f0
[   11.146416] Call Trace:
[   11.146477]  ? usb_unbind_interface+0x71/0x270 [usbcore]
[   11.146541]  ? device_release_driver_internal+0x154/0x210
[   11.146602]  ? bus_remove_device+0xf5/0x160
[   11.146659]  ? device_del+0x1dc/0x310
[   11.146720]  ? usb_disable_device+0x93/0x250 [usbcore]
[   11.146785]  ? usb_disconnect+0x90/0x270 [usbcore]
[   11.146848]  ? hub_event+0x1d9/0x14d0 [usbcore]
[   11.146907]  ? process_one_work+0x181/0x370
[   11.146964]  ? worker_thread+0x4d/0x3a0
[   11.147021]  ? kthread+0xfc/0x130
[   11.147075]  ? process_one_work+0x370/0x370
[   11.147132]  ? kthread_create_on_node+0x70/0x70
[   11.147191]  ? ret_from_fork+0x25/0x30
[   11.147246] Code: 00 0f 1f 44 00 00 b8 01 00 00 00 c3 0f 1f 44 00 00
0f 1f 44 00 00 41 54 55 48 89 fd 53 48 8b 87 c8 00 00 00 4c 8b a0 d0 27
00 00 <49> 8b 5c 24 50 48 85 db 74 18 48 8b 83 a8 00 00 00 48 8b 78 10
[   11.147366] RIP: dw2102_disconnect+0x1a/0x70 [dvb_usb_dw2102] RSP:
ffffb75841bb7c28
[   11.147433] CR2: 0000000000000050
[   11.147489] ---[ end trace 9643f635d6b5f94e ]---

Sebastian
