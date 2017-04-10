Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36462 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdDJBIg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 21:08:36 -0400
Received: by mail-ua0-f179.google.com with SMTP id a1so17955738uaf.3
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 18:08:36 -0700 (PDT)
MIME-Version: 1.0
From: Doug Lung <dlung0@gmail.com>
Date: Sun, 9 Apr 2017 15:08:34 -1000
Message-ID: <CAAT-iuuAeAucvo=BhuOiy_+vMLZ7ZJSMYfXW63jE5pMn-cc+fg@mail.gmail.com>
Subject: Hauppauge Aero-M USB tuner stopped working after kernel 4.8
To: Linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello -

My Hauppauge Aero-M tuner stopped working with kernel 4.9. I tried the
media_build tree and native kernel drivers with no success through
kernel 4.10.8-1 on my Arch Linux system. No devices are created in
/dev/dvb.

The problem appears to be with dvb_usb_mxl111sf. Other tuners
(HVR955Q, WinTV dualHD) work fine. Full dmesg output using the
media_build drivers from April 5 after inserting the device:

[   50.845613] usb 1-1.2.4.2: dvb_usb_v2: found a 'Hauppauge
WinTV-Aero-M' in warm state
[   50.845660] usb 1-1.2.4.2: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[   50.845736] dvbdev: DVB: registering new adapter (Hauppauge WinTV-Aero-M)
[   50.845739] usb 1-1.2.4.2: media controller created
[   50.845971] dvbdev: dvb_create_media_entity: media entity
'dvb-demux' registered.
[   50.846621] ------------[ cut here ]------------
[   50.846630] WARNING: CPU: 6 PID: 1960 at
drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x42a/0x550
[usbcore]
[   50.846630] transfer buffer not dma capable
[   50.846631] Modules linked in: dvb_usb_mxl111sf(O+) dvb_usb_v2(O)
tveeprom(O) dvb_core(O) rc_core(O) nvidia_modeset(PO) nvidia(PO) ctr
ccm rfcomm xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink ebtable_nat
ebtabl
e_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_
nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
libcrc32c crc32c_generic iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bnep
hdaps(O) uvcvideo(O) btusb videobuf2_vmalloc(O) btrtl videobuf2_m
emops(O) btbcm videobuf2_v4l2(O) btintel videobuf2_core(O) bluetooth
videodev(O) media(O) joydev mousedev snd_hda_codec_conexant
[   50.846665]  snd_hda_codec_generic mei_wdt intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt
iTCO_vendor_support kvm_
intel fuse kvm arc4 irqbypass crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel pcbc iwldvm i915 mac80211 aesni_intel
aes_x8
6_64 crypto_simd glue_helper cryptd i2c_algo_bit iwlwifi snd_hda_intel
intel_cstate drm_kms_helper intel_rapl_perf snd_hda_codec snd_hda_
core pcspkr psmouse e1000e drm cfg80211 snd_hwdep intel_gtt snd_pcm
ptp thinkpad_acpi syscopyarea evdev sysfillrect input_leds snd_timer
nvram mei_me sysimgblt fb_sys_fops mac_hid snd mei i2c_i801 pps_core
soundcore wmi shpchp lpc_ich rfkill thermal led_class fjes button ac
video battery sch_fq_codel vboxnetflt(O) vboxnetadp(O) pci_stub
vboxpci(O) vboxdrv(O) tp_smapi(O) thinkpad_ec(O) loop sg bbswitch(O)
[   50.846717]  acpi_call(O) ip_tables x_tables ext4 crc16 jbd2
fscrypto mbcache sd_mod hid_generic usbhid hid serio_raw atkbd libps2
ahc
i libahci libata xhci_pci ehci_pci xhci_hcd ehci_hcd firewire_ohci
scsi_mod firewire_core crc_itu_t usbcore usb_common i8042 serio
[   50.846735] CPU: 6 PID: 1960 Comm: systemd-udevd Tainted: P
  O    4.10.8-1-ARCH #1
[   50.846736] Hardware name: LENOVO 4239CTO/4239CTO, BIOS 8AET54WW
(1.34 ) 11/02/2011
[   50.846737] Call Trace:
[   50.846743]  dump_stack+0x63/0x83
[   50.846746]  __warn+0xcb/0xf0
[   50.846749]  warn_slowpath_fmt+0x5f/0x80
[   50.846750]  ? idr_get_empty_slot+0x183/0x370
[   50.846755]  ? usb_alloc_urb+0x19/0x50 [usbcore]
[   50.846759]  usb_hcd_map_urb_for_dma+0x42a/0x550 [usbcore]
[   50.846761]  ? idr_get_empty_slot+0x183/0x370
[   50.846765]  usb_hcd_submit_urb+0x335/0xb30 [usbcore]
[   50.846766]  ? ida_get_new_above+0x1fc/0x270
[   50.846770]  ? mutex_optimistic_spin+0x141/0x1b0
[   50.846774]  ? __mutex_lock_slowpath+0x72/0x2d0
[   50.846779]  usb_submit_urb+0x2f6/0x570 [usbcore]
[   50.846783]  usb_start_wait_urb+0x6e/0x170 [usbcore]
[   50.846787]  usb_bulk_msg+0xbd/0x160 [usbcore]
[   50.846790]  dvb_usb_v2_generic_io+0xdc/0x240 [dvb_usb_v2]
[   50.846792]  dvb_usbv2_generic_write+0x37/0x50 [dvb_usb_v2]
[   50.846797]  mxl111sf_ctrl_msg+0xae/0x1f0 [dvb_usb_mxl111sf]
[   50.846800]  ? device_register+0x1a/0x20
[   50.846804]  ? usb_create_ep_devs+0x7e/0xd0 [usbcore]
[   50.846808]  mxl111sf_write_reg+0x52/0xe0 [dvb_usb_mxl111sf]
[   50.846812]  mxl1x1sf_soft_reset+0x28/0xb0 [dvb_usb_mxl111sf]
[   50.846815]
mxl111sf_lgdt3305_frontend_attach.constprop.8+0x95/0x370
[dvb_usb_mxl111sf]
[   50.846819]  mxl111sf_frontend_attach_mercury+0x1a/0x60 [dvb_usb_mxl111sf]
[   50.846821]  dvb_usbv2_probe+0x702/0x1240 [dvb_usb_v2]
[   50.846824]  ? __pm_runtime_set_status+0x1c0/0x2a0
[   50.846828]  usb_probe_interface+0x159/0x2d0 [usbcore]
[   50.846830]  driver_probe_device+0x2bb/0x460
[   50.846832]  __driver_attach+0xdf/0xf0
[   50.846833]  ? driver_probe_device+0x460/0x460
[   50.846835]  bus_for_each_dev+0x6c/0xc0
[   50.846837]  driver_attach+0x1e/0x20
[   50.846838]  bus_add_driver+0x170/0x270
[   50.846840]  driver_register+0x60/0xe0
[   50.846844]  usb_register_driver+0x81/0x140 [usbcore]
[   50.846846]  ? 0xffffffffa1873000
[   50.846849]  mxl111sf_usb_driver_init+0x1e/0x1000 [dvb_usb_mxl111sf]
[   50.846852]  do_one_initcall+0x52/0x1a0
[   50.846854]  ? kvfree+0x2a/0x40
[   50.846856]  ? kfree+0x177/0x190
[   50.846858]  do_init_module+0x5f/0x201
[   50.846860]  load_module+0x239c/0x2a80
[   50.846862]  ? symbol_put_addr+0x50/0x50
[   50.846865]  ? vfs_read+0x11b/0x130
[   50.846867]  SyS_finit_module+0xe4/0x120
[   50.846869]  do_syscall_64+0x54/0xc0
[   50.846871]  entry_SYSCALL64_slow_path+0x25/0x25
[   50.846872] RIP: 0033:0x7ff0b830a889
[   50.846873] RSP: 002b:00007fff8cd49fc8 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[   50.846875] RAX: ffffffffffffffda RBX: 00005636f6800410 RCX: 00007ff0b830a889
[   50.846876] RDX: 0000000000000000 RSI: 00007ff0b89fdcb5 RDI: 0000000000000012
[   50.846877] RBP: 00007ff0b89fdcb5 R08: 0000000000000000 R09: 00007fff8cd4a540
[   50.846878] R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000000000
[   50.846879] R13: 00005636f67f0170 R14: 0000000000020000 R15: 00005636f54bd622
[   50.846881] ---[ end trace e24afc02cc8e2bb8 ]---
[   50.846884] usb 1-1.2.4.2: dvb_usb_v2: usb_bulk_msg() failed=-11
[   50.846887] error writing reg: 0xff, val: 0x00
[   50.847184] dvb_usb_mxl111sf: probe of 1-1.2.4.2:1.0 failed with error -11
[   50.847212] usbcore: registered new interface driver dvb_usb_mxl111sf
[dl@t520 ~]$ uname -a
Linux t520 4.10.8-1-ARCH #1 SMP PREEMPT Fri Mar 31 16:50:19 CEST 2017
x86_64 GNU/Linux

I know the Hauppauge Aero-M tuner is good because it works fine in
both ATSC and DVB modes on a notebook running Kubuntu 16.04.2 with
kernel 4.8.0-46.

I'm happy to test any patches or code modifications to see if they fix
the problem or for additional debugging if that's helpful.

Thank you everyone for your work on these and other drivers for ATSC
and DVB tuners!

          ...Doug
