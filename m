Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35598 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdFRLzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 07:55:37 -0400
MIME-Version: 1.0
From: CIJOML CIJOMLovic <cijoml@gmail.com>
Date: Sun, 18 Jun 2017 13:55:35 +0200
Message-ID: <CAB0z4Npb2ytLTysrtHatQZZa8bJEnCt4ciVEe_KWTjxjm8no0A@mail.gmail.com>
Subject: LINUX 4.11.6. Leadtek - USB2.0 Winfast DTV dongle does not initialize correctly
To: linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

after years of not using the dongle I wanted to use it. And I ended up
like this. Previously dongle worked correctly. It is not broken I
checked it in Windows.



[   22.050048] usb 3-1: new high-speed USB device number 3 using xhci_hcd
[   22.190321] usb 3-1: New USB device found, idVendor=0413, idProduct=6025
[   22.190323] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   23.218049] dvb-usb: found a 'Leadtek - USB2.0 Winfast DTV dongle'
in cold state, will try to load a firmware
[   23.218287] dvb-usb: downloading firmware from file
'dvb-usb-dibusb-6.0.0.8.fw'
[   23.235307] usbcore: registered new interface driver dvb_usb_dibusb_mc
[   23.237929] usb 3-1: USB disconnect, device number 3
[   23.237953] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[   25.015530] usb 3-1: new high-speed USB device number 4 using xhci_hcd
[   25.164366] usb 3-1: New USB device found, idVendor=0413, idProduct=6026
[   25.164378] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   25.164380] usb 3-1: Product: MOD3000
[   25.164380] usb 3-1: Manufacturer: STAE
[   25.165057] dvb-usb: found a 'Leadtek - USB2.0 Winfast DTV dongle'
in warm state.
[   25.165251] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   25.169325] dvbdev: DVB: registering new adapter (Leadtek - USB2.0
Winfast DTV dongle)
[   25.169784] ------------[ cut here ]------------
[   25.169791] WARNING: CPU: 3 PID: 29 at
/home/kernel/COD/linux/drivers/usb/core/hcd.c:1587
usb_hcd_map_urb_for_dma+0x37f/0x570
[   25.169791] transfer buffer not dma capable
[   25.169792] Modules linked in: dvb_usb_dibusb_mc
dvb_usb_dibusb_mc_common dvb_usb_dibusb_common dib3000mc
dibx000_common dvb_usb dvb_core rc_core ccm xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c
ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables
rfcomm bnep intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc arc4
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
aesni_intel snd_hda_intel iwldvm aes_x86_64 snd_hda_codec crypto_simd
glue_helper snd_hda_core cryptd mac80211 snd_seq_midi snd_hwdep
uvcvideo videobuf2_vmalloc intel_cstate
[   25.169819]  intel_rapl_perf thinkpad_acpi snd_seq_midi_event
joydev input_leds videobuf2_memops snd_pcm serio_raw videobuf2_v4l2
snd_rawmidi videobuf2_core btusb iwlwifi videodev snd_seq cfg80211
btrtl media nvram mei_me btbcm btintel snd_seq_device bluetooth
lpc_ich snd_timer shpchp mei snd soundcore mac_hid kvm_intel kvm
irqbypass parport_pc sunrpc ppdev lp parport autofs4 btrfs xor
raid6_pq i915 i2c_algo_bit psmouse drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ahci e1000e drm libahci sdhci_pci
sdhci ptp pps_core wmi video
[   25.169854] CPU: 3 PID: 29 Comm: kworker/3:0 Not tainted
4.11.6-041106-generic #201706170517
[   25.169855] Hardware name: LENOVO 2325CK9/2325CK9, BIOS G2ETA7WW
(2.67 ) 09/09/2016
[   25.169857] Workqueue: usb_hub_wq hub_event
[   25.169858] Call Trace:
[   25.169862]  dump_stack+0x63/0x81
[   25.169864]  __warn+0xcb/0xf0
[   25.169864]  warn_slowpath_fmt+0x5a/0x80
[   25.169866]  usb_hcd_map_urb_for_dma+0x37f/0x570
[   25.169867]  usb_hcd_submit_urb+0x35c/0xb90
[   25.169869]  ? del_timer_sync+0x48/0x50
[   25.169871]  ? schedule_timeout+0x184/0x310
[   25.169872]  ? del_timer_sync+0x50/0x50
[   25.169874]  usb_submit_urb.part.8+0x30b/0x530
[   25.169875]  ? wait_for_completion_timeout+0xb8/0x140
[   25.169876]  usb_submit_urb+0x62/0x70
[   25.169878]  usb_start_wait_urb+0x6e/0x170
[   25.169879]  usb_bulk_msg+0xbd/0x160
[   25.169882]  dvb_usb_generic_rw+0x15f/0x1e0 [dvb_usb]
[   25.169884]  dibusb_i2c_msg+0xcf/0x130 [dvb_usb_dibusb_common]
[   25.169886]  dibusb_i2c_xfer+0x13c/0x150 [dvb_usb_dibusb_common]
[   25.169887]  __i2c_transfer+0x115/0x3f0
[   25.169889]  ? dvb_usb_fe_sleep+0x60/0x60 [dvb_usb]
[   25.169890]  i2c_transfer+0x5c/0xc0
[   25.169892]  dib3000mc_read_word+0x9a/0x100 [dib3000mc]
[   25.169893]  dib3000mc_identify+0x17/0xc0 [dib3000mc]
[   25.169895]  ? dib3000mc_identify+0x17/0xc0 [dib3000mc]
[   25.169896]  dib3000mc_attach+0x6e/0x450 [dib3000mc]
[   25.169897]  dibusb_dib3000mc_frontend_attach+0x4c/0x160
[dvb_usb_dibusb_mc_common]
[   25.169899]  dvb_usb_adapter_frontend_init+0xdf/0x190 [dvb_usb]
[   25.169900]  dvb_usb_device_init+0x4ca/0x630 [dvb_usb]
[   25.169902]  dibusb_mc_probe+0x25/0x27 [dvb_usb_dibusb_mc]
[   25.169903]  usb_probe_interface+0x159/0x2d0
[   25.169905]  driver_probe_device+0x2bb/0x460
[   25.169906]  __device_attach_driver+0x8c/0x100
[   25.169908]  ? __driver_attach+0xf0/0xf0
[   25.169909]  bus_for_each_drv+0x67/0xb0
[   25.169910]  __device_attach+0xdd/0x160
[   25.169912]  device_initial_probe+0x13/0x20
[   25.169913]  bus_probe_device+0x92/0xa0
[   25.169914]  device_add+0x373/0x630
[   25.169916]  usb_set_configuration+0x5d2/0x8c0
[   25.169918]  generic_probe+0x2e/0x80
[   25.169919]  usb_probe_device+0x2e/0x70
[   25.169920]  driver_probe_device+0x2bb/0x460
[   25.169921]  __device_attach_driver+0x8c/0x100
[   25.169922]  ? __driver_attach+0xf0/0xf0
[   25.169923]  bus_for_each_drv+0x67/0xb0
[   25.169924]  __device_attach+0xdd/0x160
[   25.169926]  device_initial_probe+0x13/0x20
[   25.169927]  bus_probe_device+0x92/0xa0
[   25.169928]  device_add+0x373/0x630
[   25.169930]  ? random_poll+0x50/0x80
[   25.169932]  usb_new_device+0x275/0x490
[   25.169933]  hub_port_connect+0x50e/0x9d0
[   25.169934]  hub_event+0x958/0xb10
[   25.169936]  ? pick_next_task_fair+0x319/0x540
[   25.169938]  process_one_work+0x1fc/0x4b0
[   25.169939]  worker_thread+0x4b/0x500
[   25.169941]  kthread+0x109/0x140
[   25.169942]  ? process_one_work+0x4b0/0x4b0
[   25.169944]  ? kthread_create_on_node+0x70/0x70
[   25.169945]  ret_from_fork+0x2c/0x40
[   25.169946] ---[ end trace 61ae6724a5bf0373 ]---
[   25.169947] dvb-usb: recv bulk message failed: -11
[   25.170105] dvb-usb: recv bulk message failed: -11
[   25.170108] dvb-usb: no frontend was attached by 'Leadtek - USB2.0
Winfast DTV dongle'

Best regards

Michal
