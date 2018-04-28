Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36933 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeD1UZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 16:25:59 -0400
Received: by mail-lf0-f54.google.com with SMTP id b23-v6so7328817lfg.4
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 13:25:58 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Sat, 28 Apr 2018 16:25:56 -0400
Message-ID: <CAKTMqxuaLoRV8h10DQHowEdBRQDrSy73Q3nC8mAnWHGnpQ1qxg@mail.gmail.com>
Subject: Bug report: ADS Tech DVD Xpress DX2 doesn't work and a stack trace is
 printed into dmesg
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device: ADS Tech DVD Xpress DX2

Device's USB ID: 06e1:0709

Vendor: ADS Technologies, Inc.

OS: Linux Mint 17.3 (I'm using the drivers supplied with this OS)

uname -a: Linux cedille-mint 4.10.0-38-generic #42~16.04.1-Ubuntu SMP
Tue Oct 10 16:32:20 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

It's using the go7007 driver. I want to record from an NTSC video game console.

The issue: TVtime cannot open the capture device. The following is
printed into dmesg after connecting the capture device to the
computer:

[  200.202912] usb 3-5: new high-speed USB device number 6 using xhci_hcd
[  200.519470] usb 3-5: New USB device found, idVendor=06e1, idProduct=0709
[  200.519471] usb 3-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  200.519472] usb 3-5: Product: DVD Xpress DX2
[  200.519473] usb 3-5: Manufacturer: ADS Technologies
[  200.734955] ------------[ cut here ]------------
[  200.734960] WARNING: CPU: 5 PID: 139 at
/build/linux-hwe-lyR8gz/linux-hwe-4.10.0/drivers/usb/core/urb.c:449
usb_submit_urb.part.8+0x144/0x530
[  200.734961] usb 3-5: BOGUS urb xfer, pipe 1 != type 3
[  200.734962] Modules linked in: tw9906 go7007_usb go7007 v4l2_common
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
videodev media pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE)
vboxdrv(OE) binfmt_misc nls_iso8859_1 nvidia_uvm(POE) input_leds
nvidia_drm(POE) nvidia_modeset(POE) nvidia(POE) snd_hda_codec_hdmi
drm_kms_helper drm fb_sys_fops syscopyarea mei_me mei ie31200_edac
hp_wmi sparse_keymap intel_rapl snd_hda_codec_realtek
x86_pkg_temp_thermal snd_hda_codec_generic intel_powerclamp coretemp
kvm_intel kvm sysfillrect sysimgblt snd_hda_intel snd_hda_codec
irqbypass snd_hda_core crct10dif_pclmul snd_hwdep crc32_pclmul snd_pcm
ghash_clmulni_intel snd_seq_midi snd_seq_midi_event snd_rawmidi pcbc
edac_core snd_seq snd_seq_device snd_timer snd soundcore aesni_intel
aes_x86_64 crypto_simd
[  200.734989]  glue_helper cryptd intel_cstate intel_rapl_perf
serio_raw lpc_ich shpchp wmi tpm_infineon mac_hid parport_pc ppdev lp
parport autofs4 btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
hid_generic usbhid hid e1000e ahci psmouse libahci ptp pps_core fjes
[  200.735002] CPU: 5 PID: 139 Comm: kworker/5:2 Tainted: P        W
OE   4.10.0-38-generic #42~16.04.1-Ubuntu
[  200.735003] Hardware name: Hewlett-Packard HP Z230 Tower
Workstation/1905, BIOS L51 v01.42 11/17/2014
[  200.735005] Workqueue: usb_hub_wq hub_event
[  200.735006] Call Trace:
[  200.735009]  dump_stack+0x63/0x90
[  200.735011]  __warn+0xcb/0xf0
[  200.735012]  warn_slowpath_fmt+0x5f/0x80
[  200.735013]  usb_submit_urb.part.8+0x144/0x530
[  200.735015]  usb_submit_urb+0x62/0x70
[  200.735018]  go7007_usb_read_interrupt+0x27/0x50 [go7007_usb]
[  200.735021]  go7007_read_interrupt+0x42/0x160 [go7007]
[  200.735022]  go7007_usb_interface_reset+0x139/0x1a0 [go7007_usb]
[  200.735023]  go7007_load_encoder+0x61/0x1e0 [go7007]
[  200.735025]  go7007_boot_encoder+0x2d/0x80 [go7007]
[  200.735026]  go7007_usb_probe+0x214/0x988 [go7007_usb]
[  200.735029]  ? __pm_runtime_set_status+0x1e0/0x2d0
[  200.735031]  usb_probe_interface+0x153/0x2f0
[  200.735033]  driver_probe_device+0x2bf/0x460
[  200.735034]  __device_attach_driver+0x8c/0x100
[  200.735034]  ? __driver_attach+0xf0/0xf0
[  200.735036]  bus_for_each_drv+0x67/0xb0
[  200.735037]  __device_attach+0xdd/0x160
[  200.735038]  device_initial_probe+0x13/0x20
[  200.735039]  bus_probe_device+0x92/0xa0
[  200.735040]  device_add+0x3fd/0x670
[  200.735042]  usb_set_configuration+0x529/0x8d0
[  200.735044]  generic_probe+0x2e/0x80
[  200.735045]  usb_probe_device+0x2e/0x70
[  200.735046]  driver_probe_device+0x2bf/0x460
[  200.735047]  __device_attach_driver+0x8c/0x100
[  200.735047]  ? __driver_attach+0xf0/0xf0
[  200.735049]  bus_for_each_drv+0x67/0xb0
[  200.735049]  __device_attach+0xdd/0x160
[  200.735050]  device_initial_probe+0x13/0x20
[  200.735051]  bus_probe_device+0x92/0xa0
[  200.735052]  device_add+0x3fd/0x670
[  200.735054]  ? add_device_randomness+0x80/0x100
[  200.735056]  usb_new_device+0x26f/0x4b0
[  200.735056]  hub_port_connect+0x560/0x9b0
[  200.735057]  hub_event+0x72b/0xb10
[  200.735060]  ? dequeue_task_fair+0x4ee/0xb20
[  200.735062]  process_one_work+0x16b/0x4a0
[  200.735063]  worker_thread+0x4b/0x500
[  200.735065]  kthread+0x109/0x140
[  200.735065]  ? process_one_work+0x4a0/0x4a0
[  200.735066]  ? kthread_create_on_node+0x60/0x60
[  200.735069]  ret_from_fork+0x2c/0x40
[  200.735070] ---[ end trace f43a1988a9768c83 ]---
[  200.745626] ------------[ cut here ]------------
[  200.745628] WARNING: CPU: 5 PID: 139 at
/build/linux-hwe-lyR8gz/linux-hwe-4.10.0/drivers/usb/core/urb.c:449
usb_submit_urb.part.8+0x144/0x530
[  200.745629] usb 3-5: BOGUS urb xfer, pipe 1 != type 3
[  200.745629] Modules linked in: tw9906 go7007_usb go7007 v4l2_common
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
videodev media pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE)
vboxdrv(OE) binfmt_misc nls_iso8859_1 nvidia_uvm(POE) input_leds
nvidia_drm(POE) nvidia_modeset(POE) nvidia(POE) snd_hda_codec_hdmi
drm_kms_helper drm fb_sys_fops syscopyarea mei_me mei ie31200_edac
hp_wmi sparse_keymap intel_rapl snd_hda_codec_realtek
x86_pkg_temp_thermal snd_hda_codec_generic intel_powerclamp coretemp
kvm_intel kvm sysfillrect sysimgblt snd_hda_intel snd_hda_codec
irqbypass snd_hda_core crct10dif_pclmul snd_hwdep crc32_pclmul snd_pcm
ghash_clmulni_intel snd_seq_midi snd_seq_midi_event snd_rawmidi pcbc
edac_core snd_seq snd_seq_device snd_timer snd soundcore aesni_intel
aes_x86_64 crypto_simd
[  200.745645]  glue_helper cryptd intel_cstate intel_rapl_perf
serio_raw lpc_ich shpchp wmi tpm_infineon mac_hid parport_pc ppdev lp
parport autofs4 btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
hid_generic usbhid hid e1000e ahci psmouse libahci ptp pps_core fjes
[  200.745653] CPU: 5 PID: 139 Comm: kworker/5:2 Tainted: P        W
OE   4.10.0-38-generic #42~16.04.1-Ubuntu
[  200.745654] Hardware name: Hewlett-Packard HP Z230 Tower
Workstation/1905, BIOS L51 v01.42 11/17/2014
[  200.745655] Workqueue: usb_hub_wq hub_event
[  200.745655] Call Trace:
[  200.745657]  dump_stack+0x63/0x90
[  200.745658]  __warn+0xcb/0xf0
[  200.745658]  warn_slowpath_fmt+0x5f/0x80
[  200.745659]  ? urb_destroy+0x24/0x30
[  200.745660]  usb_submit_urb.part.8+0x144/0x530
[  200.745661]  usb_submit_urb+0x62/0x70
[  200.745663]  go7007_usb_read_interrupt+0x27/0x50 [go7007_usb]
[  200.745665]  go7007_read_interrupt+0x42/0x160 [go7007]
[  200.745666]  go7007_load_encoder+0x9b/0x1e0 [go7007]
[  200.745668]  go7007_boot_encoder+0x2d/0x80 [go7007]
[  200.745669]  go7007_usb_probe+0x214/0x988 [go7007_usb]
[  200.745670]  ? __pm_runtime_set_status+0x1e0/0x2d0
[  200.745672]  usb_probe_interface+0x153/0x2f0
[  200.745672]  driver_probe_device+0x2bf/0x460
[  200.745673]  __device_attach_driver+0x8c/0x100
[  200.745674]  ? __driver_attach+0xf0/0xf0
[  200.745675]  bus_for_each_drv+0x67/0xb0
[  200.745676]  __device_attach+0xdd/0x160
[  200.745676]  device_initial_probe+0x13/0x20
[  200.745677]  bus_probe_device+0x92/0xa0
[  200.745678]  device_add+0x3fd/0x670
[  200.745680]  usb_set_configuration+0x529/0x8d0
[  200.745681]  generic_probe+0x2e/0x80
[  200.745682]  usb_probe_device+0x2e/0x70
[  200.745683]  driver_probe_device+0x2bf/0x460
[  200.745683]  __device_attach_driver+0x8c/0x100
[  200.745684]  ? __driver_attach+0xf0/0xf0
[  200.745685]  bus_for_each_drv+0x67/0xb0
[  200.745685]  __device_attach+0xdd/0x160
[  200.745686]  device_initial_probe+0x13/0x20
[  200.745687]  bus_probe_device+0x92/0xa0
[  200.745688]  device_add+0x3fd/0x670
[  200.745689]  ? add_device_randomness+0x80/0x100
[  200.745690]  usb_new_device+0x26f/0x4b0
[  200.745691]  hub_port_connect+0x560/0x9b0
[  200.745691]  hub_event+0x72b/0xb10
[  200.745693]  ? dequeue_task_fair+0x4ee/0xb20
[  200.745695]  process_one_work+0x16b/0x4a0
[  200.745695]  worker_thread+0x4b/0x500
[  200.745697]  kthread+0x109/0x140
[  200.745697]  ? process_one_work+0x4a0/0x4a0
[  200.745698]  ? kthread_create_on_node+0x60/0x60
[  200.745700]  ret_from_fork+0x2c/0x40
[  200.745701] ---[ end trace f43a1988a9768c84 ]---
[  200.745925] go7007 3-5:1.0: go7007: registering new ADS Tech DVD Xpress DX2

Thanks,
Alexandre-Xavier
