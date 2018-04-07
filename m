Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56454 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751069AbeDGJLk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Apr 2018 05:11:40 -0400
Subject: Re: uvcvideo stopped working in 4.16
To: Damjan Georgievski <gdamjan@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAEk1YH75md=-v++Q8_sS9Q_3FS6xt0RMdRy8eBG=0NsUnCmk7Q@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <65fe26f0-f2ce-2011-c497-270673041a80@xs4all.nl>
Date: Sat, 7 Apr 2018 11:11:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAEk1YH75md=-v++Q8_sS9Q_3FS6xt0RMdRy8eBG=0NsUnCmk7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/18 18:54, Damjan Georgievski wrote:
> Since the 4.16 kernel my uvcvideo webcam on Thinkpad X1 Carbon (5th
> gen) stopped working with gst-launch-1.0, kamoso (kde webcam app),
> Firefox and Chromium on sites like appear.in, talky.io, Google
> Hangouts and meet.jit.si.

Do you see a /dev/v4l-touchX (X is probably 0) device? If so, then this
patch will probably fix the issue:

https://patchwork.linuxtv.org/patch/48417/

It will appear in a stable 4.16 release soon.

Regards,

	Hans

> 
> It works fine in 4.15
> 
> The camera is:
> Bus 001 Device 004: ID 04f2:b5ce Chicony Electronics Co., Ltd
> 
> After further investigation, if I rmmod the uvcvideo module, and then
> load it again, the camera starts working normally. But I get this in
> dmesg:
> 
> [   63.399362] usbcore: deregistering interface driver uvcvideo
> [   63.495659] WARNING: CPU: 1 PID: 858 at
> drivers/media/v4l2-core/v4l2-dev.c:176 v4l2_device_release+0xe3/0x100
> [videodev]
> [   63.495662] Modules linked in: rfcomm joydev mousedev rmi_smbus
> rmi_core bnep snd_hda_codec_hdmi snd_soc_skl snd_soc_skl_ipc
> snd_hda_codec_conexant snd_hda_ext_core snd_hda_codec_generic
> snd_soc_sst_dsp snd_soc_sst_ipc snd_soc_acpi snd_soc_core snd_compress
> ac97_bus snd_pcm_dmaengine arc4 iTCO_wdt iTCO_vendor_support wmi_bmof
> intel_wmi_thunderbolt intel_rapl iwlmvm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel snd_hda_intel mac80211
> snd_hda_codec kvm uvcvideo(-) btusb btrtl btbcm btintel snd_hda_core
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 iwlwifi
> videobuf2_common bluetooth snd_hwdep irqbypass e1000e intel_cstate
> snd_pcm videodev intel_uncore qcserial intel_rapl_perf cdc_mbim ptp
> usb_wwan psmouse pps_core snd_timer usbserial input_leds media pcspkr
> cdc_wdm cdc_ncm cfg80211 usbnet
> [   63.495758]  mii i2c_i801 rtsx_pci_ms memstick tpm_crb ecdh_generic
> mei_me mei shpchp intel_pch_thermal ucsi_acpi typec_ucsi thinkpad_acpi
> typec wmi nvram i2c_hid ac rfkill snd battery soundcore led_class
> tpm_tis rtc_cmos tpm_tis_core hid tpm evdev rng_core mac_hid
> usbip_host usbip_core sg scsi_mod crypto_user ip_tables x_tables ext4
> crc16 mbcache jbd2 fscrypto algif_skcipher af_alg dm_crypt dm_mod
> crct10dif_pclmul crc32_pclmul crc32c_intel rtsx_pci_sdmmc
> ghash_clmulni_intel pcbc serio_raw mmc_core atkbd libps2 xhci_pci
> aesni_intel aes_x86_64 xhci_hcd crypto_simd glue_helper cryptd usbcore
> rtsx_pci usb_common i8042 serio vfat fat i915 intel_gtt i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
> agpgart
> [   63.495882] CPU: 1 PID: 858 Comm: rmmod Not tainted 4.16.0+ #1
> [   63.495885] Hardware name: LENOVO 20HQS0LV00/20HQS0LV00, BIOS
> N1MET45W (1.30 ) 02/22/2018
> [   63.495899] RIP: 0010:v4l2_device_release+0xe3/0x100 [videodev]
> [   63.495903] RSP: 0018:ffff9c974505bd60 EFLAGS: 00010202
> [   63.495907] RAX: 0000000000000000 RBX: ffff97d00b84a1d0 RCX: 0000000000000000
> [   63.495910] RDX: ffff97d00b84a018 RSI: 0000000000000286 RDI: ffffffffc0c7f0e0
> [   63.495912] RBP: ffff97d008245ae0 R08: 0000000000000000 R09: 0000000000000000
> [   63.495915] R10: ffffc823d22a9a00 R11: 0000000000000000 R12: ffff97d00b84a019
> [   63.495917] R13: ffff97d008245b90 R14: ffff97d00cbaf8f8 R15: 0000000000000000
> [   63.495921] FS:  00007f3549e74b80(0000) GS:ffff97d01f480000(0000)
> knlGS:0000000000000000
> [   63.495924] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   63.495928] CR2: 0000000001bffe78 CR3: 000000047d4e2003 CR4: 00000000003606e0
> [   63.495930] Call Trace:
> [   63.495947]  device_release+0x30/0x90
> [   63.495958]  kobject_put+0x85/0x1a0
> [   63.495967]  uvc_unregister_video+0x49/0x90 [uvcvideo]
> [   63.495995]  usb_unbind_interface+0x85/0x280 [usbcore]
> [   63.496007]  device_release_driver_internal+0x15a/0x220
> [   63.496014]  driver_detach+0x37/0x70
> [   63.496021]  bus_remove_driver+0x51/0xd0
> [   63.496051]  usb_deregister+0x6a/0xd0 [usbcore]
> [   63.496065]  uvc_cleanup+0xc/0x36e [uvcvideo]
> [   63.496075]  SyS_delete_module+0x16a/0x2d0
> [   63.496088]  do_syscall_64+0x74/0x190
> [   63.496100]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [   63.496105] RIP: 0033:0x7f35495975d7
> [   63.496108] RSP: 002b:00007ffcbf653b88 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
> [   63.496112] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f35495975d7
> [   63.496115] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000000001bf57b8
> [   63.496117] RBP: 0000000001bf5750 R08: 00007ffcbf652b01 R09: 0000000000000000
> [   63.496119] R10: 00000000000008b2 R11: 0000000000000206 R12: 00007ffcbf655d95
> [   63.496123] R13: 0000000000000000 R14: 0000000001bf5750 R15: 0000000001bf5260
> [   63.496127] Code: da ce 48 85 ed 74 1f 5b 48 89 ef 5d 41 5c e9 f5
> 6b 00 00 5b 5d 41 5c e9 6c 9c da ce 4c 89 e7 e8 04 80 f4 ff eb c6 5b
> 5d 41 5c c3 <0f> 0b 5b 5d 41 5c 48 c7 c7 e0 f0 c7 c0 e9 cb e8 ac ce 90
> 66 2e
> [   63.496214] ---[ end trace d2f4fd290ae1befc ]---
> [   68.700338] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b5ce)
> [   68.707982] uvcvideo 1-8:1.0: Entity type for entity Extension 4
> was not initialized!
> [   68.707987] uvcvideo 1-8:1.0: Entity type for entity Extension 3
> was not initialized!
> [   68.707991] uvcvideo 1-8:1.0: Entity type for entity Processing 2
> was not initialized!
> [   68.707994] uvcvideo 1-8:1.0: Entity type for entity Camera 1 was
> not initialized!
> [   68.708160] input: Integrated Camera: Integrated C as
> /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input20
> [   68.708302] usbcore: registered new interface driver uvcvideo
> [   68.708304] USB Video Class driver (1.1.1)
> 
> Another thing I've noticed, before the rmmod there were /dev/video0
> and /dev/video1, after loading the module again, it's /dev/video1 and
> /dev/video2
> 
