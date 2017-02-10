Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53015 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbdBJLCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 06:02:51 -0500
MIME-Version: 1.0
Message-ID: <trinity-7c772130-79b5-4049-8d89-f2cb90574575-1486724524297@3capp-mailcom-bs08>
From: nutrinfnon@gmx.com
To: linux-media@vger.kernel.org
Subject: "Technisat SkyStar USB HD" fails resume from hibernation
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Feb 2017 12:02:04 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Starting from linux kernel 4.9 and above, module "dvb_usb_technisat_usb2" fails resume from hibernation.
 
lsusb
Bus 002 Device 009: ID 14f7:0500 TechniSat Digital GmbH DVB-PC TV Star HD
 
 
log of standard boot (no resume, good start)
Feb 10 08:32:15 abox kernel: [   10.334694] technisat-usb2: set alternate setting
Feb 10 08:32:15 abox kernel: [   10.334815] technisat-usb2: firmware version: 17.63
Feb 10 08:32:15 abox kernel: [   10.334816] dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in warm state.
Feb 10 08:32:15 abox kernel: [   10.335103] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Feb 10 08:32:15 abox kernel: [   10.335235] dvbdev: DVB: registering new adapter (Technisat SkyStar USB HD (DVB-S/S2))
....
Feb 10 08:32:15 abox kernel: [   11.022582] dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) successfully initialized and connected.
Feb 10 08:32:15 abox kernel: [   11.022622] usbcore: registered new interface driver dvb_usb_technisat_usb2
 
log of hibernation
Feb 10 10:22:34 abox kernel: [ 4693.741530] dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) successfully deinitialized and disconnected.
 
 
 
log of resume (issue)
Feb 10 10:22:34 abox kernel: [ 4698.454657] technisat-usb2: set alternate setting
Feb 10 10:22:34 abox mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
Feb 10 10:22:34 abox mtp-probe: bus: 2, device: 7 was not an MTP device
Feb 10 10:22:35 abox kernel: [ 4698.982696] dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in cold state, will try to load a firmware
Feb 10 10:22:35 abox kernel: [ 4699.036669] dvb-usb: downloading firmware from file 'dvb-usb-SkyStar_USB_HD_FW_v17_63.HEX.fw'
Feb 10 10:22:35 abox kernel: [ 4699.036675] ------------[ cut here ]------------
Feb 10 10:22:35 abox kernel: [ 4699.036688] WARNING: CPU: 1 PID: 12912 at drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x24c/0x2fd [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036689] transfer buffer not dma capable
Feb 10 10:22:35 abox kernel: [ 4699.036690] Modules linked in: stv6110x stv090x it913x af9033 dvb_usb_af9035 dvb_usb_technisat_usb2 dvb_usb ftdi_sio dvb_usb_v2 dvb_core rc_core usbserial snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device coretemp kvm_intel kvm arc4 i915 ath9k iTCO_wdt i2c_algo_bit drm_kms_helper ath9k_common iTCO_vendor_support ath9k_hw syscopyarea evdev irqbypass sysfillrect serio_raw pcspkr ath sysimgblt fb_sys_fops snd_hda_codec_realtek snd_hda_codec_generic mac80211 snd_hda_intel cfg80211 snd_hda_codec snd_hwdep rfkill snd_hda_core snd_pcm snd_timer battery video lpc_ich button snd drm i2c_i801
Feb 10 10:22:35 abox kernel: [ 4699.036739]  tpm_tis soundcore tpm_tis_core tpm w83627ehf hwmon_vid fuse parport_pc lp parport autofs4 hid_generic usbhid hid ext4 crc16 jbd2 fscrypto mbcache sg sd_mod psmouse ahci libahci libata scsi_mod atl1c ehci_pci ehci_hcd usbcore usb_common
Feb 10 10:22:35 abox kernel: [ 4699.036760] CPU: 1 PID: 12912 Comm: kworker/1:1 Not tainted 4.10.0-rc7 #1
Feb 10 10:22:35 abox kernel: [ 4699.036761] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H61M-GS, BIOS P2.00 03/08/2013
Feb 10 10:22:35 abox kernel: [ 4699.036769] Workqueue: usb_hub_wq hub_event [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036771] Call Trace:
Feb 10 10:22:35 abox kernel: [ 4699.036776]  ? dump_stack+0x46/0x59
Feb 10 10:22:35 abox kernel: [ 4699.036780]  ? __warn+0xd5/0xee
Feb 10 10:22:35 abox kernel: [ 4699.036783]  ? warn_slowpath_fmt+0x46/0x4e
Feb 10 10:22:35 abox kernel: [ 4699.036788]  ? swiotlb_map_page+0xb9/0x13f
Feb 10 10:22:35 abox kernel: [ 4699.036795]  ? usb_hcd_map_urb_for_dma+0x24c/0x2fd [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036802]  ? usb_hcd_submit_urb+0x608/0x6b0 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036805]  ? touch_atime+0x22/0x9c
Feb 10 10:22:35 abox kernel: [ 4699.036808]  ? generic_file_read_iter+0x50f/0x52c
Feb 10 10:22:35 abox kernel: [ 4699.036816]  ? usb_start_wait_urb+0x54/0xc5 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036824]  ? usb_control_msg+0xcf/0xf2 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036828]  ? usb_cypress_writemem+0x2c/0x31 [dvb_usb]
Feb 10 10:22:35 abox kernel: [ 4699.036830]  ? usb_cypress_load_firmware+0x43/0x10b [dvb_usb]
Feb 10 10:22:35 abox kernel: [ 4699.036833]  ? up+0xa/0x35
Feb 10 10:22:35 abox kernel: [ 4699.036836]  ? console_unlock+0x2cf/0x3e1
Feb 10 10:22:35 abox kernel: [ 4699.036838]  ? irq_work_queue+0x3a/0x66
Feb 10 10:22:35 abox kernel: [ 4699.036840]  ? wake_up_klogd+0x2b/0x2c
Feb 10 10:22:35 abox kernel: [ 4699.036842]  ? vprintk_emit+0x351/0x3a3
Feb 10 10:22:35 abox kernel: [ 4699.036844]  ? printk+0x43/0x4b
Feb 10 10:22:35 abox kernel: [ 4699.036847]  ? dvb_usb_download_firmware+0x73/0xb8 [dvb_usb]
Feb 10 10:22:35 abox kernel: [ 4699.036850]  ? dvb_usb_device_init+0x19a/0x572 [dvb_usb]
Feb 10 10:22:35 abox kernel: [ 4699.036853]  ? technisat_usb2_probe+0x25/0xaa [dvb_usb_technisat_usb2]
Feb 10 10:22:35 abox kernel: [ 4699.036860]  ? usb_probe_interface+0x15b/0x1e2 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036864]  ? driver_probe_device+0x137/0x291
Feb 10 10:22:35 abox kernel: [ 4699.036867]  ? driver_allows_async_probing+0x27/0x27
Feb 10 10:22:35 abox kernel: [ 4699.036869]  ? bus_for_each_drv+0x76/0x7b
Feb 10 10:22:35 abox kernel: [ 4699.036872]  ? __device_attach+0x91/0xf0
Feb 10 10:22:35 abox kernel: [ 4699.036874]  ? bus_probe_device+0x28/0x84
Feb 10 10:22:35 abox kernel: [ 4699.036876]  ? device_add+0x3ef/0x4e1
Feb 10 10:22:35 abox kernel: [ 4699.036883]  ? usb_set_configuration+0x61b/0x66d [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036887]  ? sysfs_do_create_link_sd.isra.2+0x67/0x94
Feb 10 10:22:35 abox kernel: [ 4699.036894]  ? generic_probe+0x3a/0x69 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036897]  ? driver_probe_device+0x137/0x291
Feb 10 10:22:35 abox kernel: [ 4699.036899]  ? driver_allows_async_probing+0x27/0x27
Feb 10 10:22:35 abox kernel: [ 4699.036901]  ? bus_for_each_drv+0x76/0x7b
Feb 10 10:22:35 abox kernel: [ 4699.036904]  ? __device_attach+0x91/0xf0
Feb 10 10:22:35 abox kernel: [ 4699.036906]  ? bus_probe_device+0x28/0x84
Feb 10 10:22:35 abox kernel: [ 4699.036908]  ? device_add+0x3ef/0x4e1
Feb 10 10:22:35 abox kernel: [ 4699.036915]  ? usb_new_device+0x417/0x559 [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036922]  ? hub_event+0xaa2/0xe4b [usbcore]
Feb 10 10:22:35 abox kernel: [ 4699.036925]  ? process_one_work+0x178/0x2ab
Feb 10 10:22:35 abox kernel: [ 4699.036927]  ? rescuer_thread+0x29f/0x29f
Feb 10 10:22:35 abox kernel: [ 4699.036929]  ? worker_thread+0x1d1/0x29a
Feb 10 10:22:35 abox kernel: [ 4699.036931]  ? rescuer_thread+0x29f/0x29f
Feb 10 10:22:35 abox kernel: [ 4699.036935]  ? kthread+0xf1/0xf6
Feb 10 10:22:35 abox kernel: [ 4699.036937]  ? init_completion+0x1d/0x1d
Feb 10 10:22:35 abox kernel: [ 4699.036941]  ? ret_from_fork+0x23/0x30
Feb 10 10:22:35 abox kernel: [ 4699.036943] ---[ end trace 7139f986fd90a05c ]---
Feb 10 10:22:35 abox kernel: [ 4699.036946] dvb-usb: could not stop the USB controller CPU.
Feb 10 10:22:35 abox kernel: [ 4699.036953] dvb-usb: error while transferring firmware (transferred size: -11, block size: 16)
Feb 10 10:22:35 abox kernel: [ 4699.036955] dvb-usb: firmware download failed at 21 with -22
 
tried two workaround:
1) rmmod dvb_usb_technisat_usb2 dvb_usb_v2 dvb-core rc-core; modprobe dvb_usb_technisat_usb2 dvb_usb_v2
2) switch off->on of "Technisat SkyStar USB HD"
both does does not fix the issue.
 
 
 
