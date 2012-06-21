Return-path: <linux-media-owner@vger.kernel.org>
Received: from aotearoadigitalarts.org.nz ([72.14.179.101]:53428 "EHLO
	linode.halo.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2FUCRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 22:17:54 -0400
Received: from 203-97-236-46.cable.telstraclear.net ([203.97.236.46] helo=[192.168.1.42])
	by linode.halo.gen.nz with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <douglas@paradise.net.nz>)
	id 1ShW2J-00085B-V9
	for linux-media@vger.kernel.org; Thu, 21 Jun 2012 13:18:16 +1200
Message-ID: <4FE27B49.8030109@paradise.net.nz>
Date: Thu, 21 Jun 2012 13:39:21 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Oops when unplugging Hauppauge WinTV MiniStick USB DVB-T device
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,
This thing (2040:c000) works until I unplug it, whereupon (3.4.0 kernel from Ubuntu kernel team, 3.2
kernel is much the same; a 3.5 snapshot failed to recognise the device):

Jun 20 13:48:04 kip kernel: [60935.264194] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.268310] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.272439] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.276578] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.280661] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.284782] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.288896] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.293016] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.297136] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.301251] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.305375] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.309488] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.313606] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.317721] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.321840] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.325959] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.330077] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.334197] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.338315] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.342430] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.346552] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.350666] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.354784] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.358907] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.363020] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.367139] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.371256] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.375373] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.379491] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.383609] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.387727] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.391828] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.395963] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.400080] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.404201] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.408317] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.412438] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416555] smsusb_onresponse: line: 118: error, urb status -71, 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416686] usb 2-1.3: USB disconnect, device number 3
Jun 20 13:48:04 kip kernel: [60935.416927] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416932] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416937] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416941] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416945] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416950] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416954] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416958] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416962] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:04 kip kernel: [60935.416967] smsusb_onresponse: line: 72: error, urb status -108 (-ESHUTDOWN), 0 bytes
Jun 20 13:48:05 kip kernel: [60935.437903] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
Jun 20 13:48:05 kip kernel: [60935.439682] IP: [<ffffffffa069a5b7>] show_protocols+0xf7/0x110 [rc_core]
Jun 20 13:48:05 kip kernel: [60935.441354] PGD 12fffe067 PUD 12dc1a067 PMD 0 
Jun 20 13:48:05 kip kernel: [60935.443000] Oops: 0000 [#1] SMP 
Jun 20 13:48:05 kip kernel: [60935.444621] CPU 0 
Jun 20 13:48:05 kip kernel: [60935.444638] Modules linked in: ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder smsdvb dvb_core ir_nec_decoder rc_hauppauge smsusb smsmdtv rc_core btrfs zlib_deflate libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext2 parport_pc ppdev binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel uvcvideo snd_hda_codec videobuf2_core snd_hwdep snd_pcm videodev videobuf2_vmalloc videobuf2_memops snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd arc4 joydev hp_accel iwlwifi psmouse tpm_infineon mei(C) coretemp lis3lv02d soundcore mac80211 cfg80211 intel_ips tpm_tis serio_raw snd_page_alloc microcode mac_hid input_polldev hp_wmi sparse_keymap lp parport firewire_ohci firewire_core sdhci_pci crc_itu_t sdhci i915 wmi drm_kms_helper drm e1000e i2c_algo_bit video
Jun 20 13:48:05 kip kernel: [60935.457637] 
Jun 20 13:48:05 kip kernel: [60935.459630] Pid: 4514, comm: cat Tainted: G         C   3.4.0-030400-generic #201205210521 Hewlett-Packard HP ProBook 6450b/146D
Jun 20 13:48:05 kip kernel: [60935.461720] RIP: 0010:[<ffffffffa069a5b7>]  [<ffffffffa069a5b7>] show_protocols+0xf7/0x110 [rc_core]
Jun 20 13:48:05 kip kernel: [60935.463806] RSP: 0018:ffff880130759e08  EFLAGS: 00010202
Jun 20 13:48:05 kip kernel: [60935.465883] RAX: 0000000000000000 RBX: ffff88012e48b000 RCX: ffffffffa069a4c0
Jun 20 13:48:05 kip kernel: [60935.467980] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88012e48b2f0
Jun 20 13:48:05 kip kernel: [60935.470078] RBP: ffff880130759e48 R08: 0000000000000000 R09: 000000000000253a
Jun 20 13:48:05 kip kernel: [60935.472207] R10: 00007fff66f62030 R11: 0000000000000000 R12: ffff880036458c40
Jun 20 13:48:05 kip kernel: [60935.474338] R13: ffffffff81856860 R14: ffff88012e48b010 R15: ffff88012dc19000
Jun 20 13:48:05 kip kernel: [60935.476503] FS:  00007ff8f383e700(0000) GS:ffff880137c00000(0000) knlGS:0000000000000000
Jun 20 13:48:05 kip kernel: [60935.478722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 20 13:48:05 kip kernel: [60935.480966] CR2: 0000000000000050 CR3: 000000012f4f4000 CR4: 00000000000007f0
Jun 20 13:48:05 kip kernel: [60935.483253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 20 13:48:05 kip kernel: [60935.485558] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 20 13:48:05 kip kernel: [60935.487865] Process cat (pid: 4514, threadinfo ffff880130758000, task ffff880036462dc0)
Jun 20 13:48:05 kip kernel: [60935.490201] Stack:
Jun 20 13:48:05 kip kernel: [60935.492602]  ffff880130759e58 ffff88012e48b2f0 0000000000000000 ffffffffa069e160
Jun 20 13:48:05 kip kernel: [60935.495027]  ffff880036458c40 ffffffff81856860 ffff88012e48b010 ffff88006d2f5e00
Jun 20 13:48:05 kip kernel: [60935.497478]  ffff880130759e78 ffffffff8140b5c7 ffff880130759e68 ffffffff8112670e
Jun 20 13:48:05 kip kernel: [60935.499962] Call Trace:
Jun 20 13:48:05 kip kernel: [60935.502430]  [<ffffffff8140b5c7>] dev_attr_show+0x27/0x50
Jun 20 13:48:05 kip kernel: [60935.504900]  [<ffffffff8112670e>] ? __get_free_pages+0xe/0x40
Jun 20 13:48:05 kip kernel: [60935.507379]  [<ffffffff811f48ab>] fill_read_buffer+0x6b/0xf0
Jun 20 13:48:05 kip kernel: [60935.509863]  [<ffffffff811f49d0>] sysfs_read_file+0xa0/0xb0
Jun 20 13:48:05 kip kernel: [60935.512341]  [<ffffffff81184285>] vfs_read+0xc5/0x190
Jun 20 13:48:05 kip kernel: [60935.514799]  [<ffffffff81184451>] sys_read+0x51/0x90
Jun 20 13:48:05 kip kernel: [60935.517279]  [<ffffffff81674e69>] system_call_fastpath+0x16/0x1b
Jun 20 13:48:05 kip kernel: [60935.519785] Code: 24 01 4c 29 f8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 8b 93 28 d2 69 a0 48 c7 c6 ea d2 69 a0 eb a4 48 8b 83 18 03 00 00 <4c> 8b 68 50 e8 a0 12 00 00 49 89 c6 e9 53 ff ff ff 0f 1f 84 00 
Jun 20 13:48:05 kip kernel: [60935.525398] RIP  [<ffffffffa069a5b7>] show_protocols+0xf7/0x110 [rc_core]
Jun 20 13:48:05 kip kernel: [60935.528232]  RSP <ffff880130759e08>
Jun 20 13:48:05 kip kernel: [60935.531064] CR2: 0000000000000050
Jun 20 13:48:05 kip kernel: [60935.596972] ---[ end trace caead8062106f2dc ]---

After which I find it difficult to do anything other than reboot.

The plugging-in sequence looks like this:

Jun 20 12:41:51 kip kernel: [56968.821466] usb 2-1.3: new high-speed USB device number 3 using ehci_hcd
Jun 20 12:41:51 kip mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3"
Jun 20 12:41:51 kip mtp-probe: bus: 2, device: 3 was not an MTP device
Jun 20 12:41:52 kip kernel: [56969.771712] smscore_set_device_mode: firmware download success: sms1xxx-hcw-55xxx-dvbt-02.fw
Jun 20 12:41:52 kip kernel: [56969.774971] sms_ir_init: Allocating rc device
Jun 20 12:41:52 kip kernel: [56969.774982] sms_ir_init: IR port 0, timeout 100 ms
Jun 20 12:41:52 kip kernel: [56969.774987] sms_ir_init: Input device (IR) SMS IR (Hauppauge WinTV MiniStick) is set for key events
Jun 20 12:41:52 kip kernel: [56969.839568] Registered IR keymap rc-hauppauge
Jun 20 12:41:52 kip kernel: [56969.839746] input: SMS IR (Hauppauge WinTV MiniStick) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/rc/rc0/input16
Jun 20 12:41:52 kip kernel: [56969.839853] rc0: SMS IR (Hauppauge WinTV MiniStick) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/rc/rc0
Jun 20 12:41:52 kip kernel: [56969.869111] IR NEC protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.905160] DVB: registering new adapter (Hauppauge WinTV MiniStick)
Jun 20 12:41:52 kip kernel: [56969.905954] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
Jun 20 12:41:52 kip kernel: [56969.908307] usbcore: registered new interface driver smsusb
Jun 20 12:41:52 kip kernel: [56969.925459] IR RC5(x) protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.927605] IR RC6 protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.934966] IR JVC protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.947612] IR Sony protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.956956] IR SANYO protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.958762] input: MCE IR Keyboard/Mouse (smsmdtv) as /devices/virtual/input/input17
Jun 20 12:41:52 kip kernel: [56969.958858] IR MCE Keyboard/mouse protocol handler initialized
Jun 20 12:41:52 kip kernel: [56969.965675] lirc_dev: IR Remote Control driver registered, major 250 
Jun 20 12:41:52 kip kernel: [56969.966256] rc rc0: lirc_dev: driver ir-lirc-codec (smsmdtv) registered at minor = 0
Jun 20 12:41:52 kip kernel: [56969.966260] IR LIRC bridge handler initialized

I reported this to Ubuntu at https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1015836 which 
includes more (probably irrelevant) information about my system.

What can I do to help?

regards,

Douglas Bagnall
