Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:38199 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751326Ab1GXQt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 12:49:57 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: s2ram/resume issue w/ kernel 3.0 and Terratec Cinergy T USB XXS (HD)/ T3
Date: Sun, 24 Jul 2011 18:49:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107241849.53640.toralf.foerster@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

s2ram and resume a docked ThinkPad T400 with a plugged in DVB-stick gives
this with the new kernel 3.0  under an almost stable Gentoo linux :

2011-07-24T17:53:34.252+02:00 n22 kernel: PM: resume of devices complete after 2093.868 msecs
2011-07-24T17:53:34.252+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
2011-07-24T17:53:34.252+02:00 n22 kernel: ------------[ cut here ]------------
2011-07-24T17:53:34.252+02:00 n22 kernel: WARNING: at drivers/base/firmware_class.c:524 _request_firmware+0x35e/0x380()
2011-07-24T17:53:34.252+02:00 n22 kernel: Hardware name: 6474B84
2011-07-24T17:53:34.252+02:00 n22 kernel: Modules linked in: rc_dib0700_rc5 ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder dvb_usb_dib0700 dib7000p dib0090 dib7000m 
dib0070 dvb_usb dib8000 dvb_core dib3000mc rc_core dibx000_common loop rfcomm bnep ipt_MASQUERADE ipt_REJECT xt_recent xt_tcpudp xt_mac nf_conntrack_ftp xt_state xt_limit ipt_LOG iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_owner xt_multiport ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp llc tun snd_seq snd_seq_device fuse dm_mod acpi_cpufreq mperf hid_cherry 
btusb bluetooth cryptomgr usbhid crypto_hash aead pcompress crypto_blkcipher usblp hid arc4 crypto_algapi snd_hda_codec_conexant fbcon crc16 font sr_mod bitblit sg cdrom i915 softcursor drm_kms_helper drm mac80211 fb 
snd_hda_intel fbdev snd_hda_codec cfg80211 snd_pcm i2c_algo_bit i2c_i801 cfbcopyarea snd_timer 8250_pnp i2c_core intel_agp thinkpad_acpi hwmon rfkill uhci_hcd 8250_pci snd ehci_hcd snd_page_alloc usbcore intel_gtt 8250 
psmouse agpgart rtc_cmos wmi evdev soundcore e1000e nvram processor serial_core video thermal battery cfbimgblt ac button cfbfillrect [last unloaded: iwlagn]
2011-07-24T17:53:34.252+02:00 n22 kernel: Pid: 30451, comm: default.sh Not tainted 3.0.0 #2
2011-07-24T17:53:34.252+02:00 n22 kernel: Call Trace:
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c1039272>] warn_slowpath_common+0x72/0xa0
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c11fc6de>] ? _request_firmware+0x35e/0x380
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c11fc6de>] ? _request_firmware+0x35e/0x380
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c10392c2>] warn_slowpath_null+0x22/0x30
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c11fc6de>] _request_firmware+0x35e/0x380
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c11fc79f>] request_firmware+0x1f/0x30
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f837233d>] dvb_usb_download_firmware+0x2d/0xe0 [dvb_usb]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f934cf60>] ? dib0700_download_firmware+0x380/0x380 [dvb_usb_dib0700]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f934cf60>] ? dib0700_download_firmware+0x380/0x380 [dvb_usb_dib0700]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f837299f>] dvb_usb_device_init+0x43f/0x5e0 [dvb_usb]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f934c9e9>] dib0700_probe+0x59/0xd0 [dvb_usb_dib0700]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<f8199922>] usb_probe_interface+0xd2/0x1d0 [usbcore]
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c113c157>] ? sysfs_create_link+0x17/0x20
2011-07-24T17:53:34.252+02:00 n22 kernel: [<c11f30c7>] driver_probe_device+0x77/0x1a0
2011-07-24T17:53:34.253+02:00 n22 kernel: [<f8198739>] ? usb_match_id+0x49/0x70 [usbcore]
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f32d9>] __device_attach+0x49/0x60
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f2433>] bus_for_each_drv+0x53/0x80
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f33ba>] device_attach+0x8a/0xa0
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f3290>] ? __driver_attach+0xa0/0xa0
2011-07-24T17:53:34.253+02:00 n22 kernel: [<f8199ade>] usb_rebind_intf+0x3e/0x60 [usbcore]
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f829f>] ? dpm_show_time+0xef/0x150
2011-07-24T17:53:34.253+02:00 n22 kernel: [<f8199b85>] do_unbind_rebind+0x65/0x90 [usbcore]
2011-07-24T17:53:34.253+02:00 n22 kernel: [<f8199c21>] usb_resume+0x71/0xc0 [usbcore]
2011-07-24T17:53:34.253+02:00 n22 kernel: [<f818e16f>] usb_dev_complete+0xf/0x20 [usbcore]
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f7abb>] dpm_complete+0x4b/0x140
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c11f87d7>] dpm_resume_end+0x17/0x20
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c10735d7>] suspend_devices_and_enter+0xa7/0x260
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c107389d>] enter_state+0x10d/0x130
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c1072e13>] state_store+0x73/0xb0
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c1072da0>] ? pm_async_store+0x40/0x40
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c1184320>] kobj_attr_store+0x20/0x30
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c113a409>] sysfs_write_file+0x99/0xf0
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c10eca5a>] vfs_write+0x9a/0x160
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c113a370>] ? sysfs_open_file+0x200/0x200
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c10ecbf2>] sys_write+0x42/0x70
2011-07-24T17:53:34.253+02:00 n22 kernel: [<c12c2f13>] sysenter_do_call+0x12/0x22
2011-07-24T17:53:34.253+02:00 n22 kernel: ---[ end trace db9ba06f965217ed ]---
2011-07-24T17:53:34.253+02:00 n22 kernel: usb 1-1: firmware: dvb-usb-dib0700-1.20.fw will not be loaded
2011-07-24T17:53:34.253+02:00 n22 kernel: dvb-usb: did not find the firmware file. (dvb-usb-dib0700-1.20.fw) Please see linux/Documentation/dvb/ for more details on firmware-problems. (-16)
2011-07-24T17:53:34.253+02:00 n22 kernel: usblp0: USB Bidirectional printer dev 5 if 0 alt 0 proto 2 vid 0x043D pid 0x0078
2011-07-24T17:53:34.253+02:00 n22 kernel: PM: Finishing wakeup.
2011-07-24T17:53:34.253+02:00 n22 kernel: Restarting tasks ... done.
2011-07-24T17:53:34.253+02:00 n22 kernel: video LNXVIDEO:00: Restoring backlight state



Furthermore the device is no longer found after resume.

Plug off and plug in again solves the issue :


2011-07-24T18:46:50.794+02:00 n22 kernel: usb 1-1: USB disconnect, device number 8
2011-07-24T18:46:52.956+02:00 n22 kernel: usb 1-1: new high speed USB device number 9 using ehci_hcd
2011-07-24T18:46:53.070+02:00 n22 kernel: usb 1-1: New USB device found, idVendor=0ccd, idProduct=00ab
2011-07-24T18:46:53.070+02:00 n22 kernel: usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
2011-07-24T18:46:53.070+02:00 n22 kernel: usb 1-1: Product: Cinergy T XXS
2011-07-24T18:46:53.070+02:00 n22 kernel: usb 1-1: Manufacturer: TerraTec GmbH
2011-07-24T18:46:53.070+02:00 n22 kernel: usb 1-1: SerialNumber: 0000000001
2011-07-24T18:46:53.072+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
2011-07-24T18:46:53.180+02:00 n22 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
2011-07-24T18:46:53.383+02:00 n22 kernel: dib0700: firmware started successfully.
2011-07-24T18:46:53.884+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in warm state.
2011-07-24T18:46:53.884+02:00 n22 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
2011-07-24T18:46:53.884+02:00 n22 kernel: DVB: registering new adapter (Terratec Cinergy T USB XXS (HD)/ T3)
2011-07-24T18:46:54.077+02:00 n22 kernel: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
2011-07-24T18:46:54.271+02:00 n22 kernel: DiB0070: successfully identified
2011-07-24T18:46:54.271+02:00 n22 kernel: Registered IR keymap rc-dib0700-rc5
2011-07-24T18:46:54.271+02:00 n22 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc2/input16
2011-07-24T18:46:54.271+02:00 n22 kernel: rc2: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc2
2011-07-24T18:46:54.273+02:00 n22 kernel: dvb-usb: schedule remote query interval to 50 msecs.
2011-07-24T18:46:54.273+02:00 n22 kernel: dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully initialized and connected.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
