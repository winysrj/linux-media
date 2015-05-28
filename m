Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.CARNet.hr ([161.53.123.6]:38502 "EHLO mail.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbbE1OtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 10:49:15 -0400
Received: from cnzgrivvl3.carpriv.carnet.hr ([161.53.12.131]:37106 helo=gavran.carpriv.carnet.hr)
	by mail.carnet.hr with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <Valentin.Vidic@CARNet.hr>)
	id 1Yxz7P-0007jD-TM
	for linux-media@vger.kernel.org; Thu, 28 May 2015 16:49:13 +0200
Date: Thu, 28 May 2015 16:41:17 +0200
From: Valentin Vidic <Valentin.Vidic@CARNet.hr>
To: linux-media@vger.kernel.org
Message-ID: <20150528144117.GP1807@gavran.carpriv.carnet.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Subject: Issues with Geniatech MyGica T230
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently bought this card after seeing on the LinuxTV wiki
that it's supported since kernel v3.19, but now I can't get
it working properly with Debian.  The modules load without
errors but scanning for channels or watching TV does not
work reliably: some channels work but others just hang the
player or return a lot of "frame out of order erorrs". 

In order to rule out hardware problems I tested the card
using OpenELEC (RPi and x86_64) and Windows Media Player
and it works there without a glich.  So I assumed this is
a software problem somewhere I tried several different
kernel versions without success:

3.16.7-ckt9-3~deb8u1 + media_build drivers
4.0.2-1
3.19.0
3.19.8

May 25 21:01:19 host kernel: [   64.784147] usb 2-1: new high-speed USB device number 3 using ehci-pci
May 25 21:01:20 host kernel: [   64.917345] usb 2-1: string descriptor 0 malformed (err = -61), defaulting to 0x0409
May 25 21:01:20 host kernel: [   64.919611] usb 2-1: New USB device found, idVendor=0572, idProduct=c688
May 25 21:01:20 host kernel: [   64.919616] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
May 25 21:01:20 host kernel: [   64.955602] WARNING: You are using an experimental version of the media stack.
May 25 21:01:20 host kernel: [   64.955602]    As the driver is backported to an older kernel, it doesn't offer
May 25 21:01:20 host kernel: [   64.955602]    enough quality for its usage in production.
May 25 21:01:20 host kernel: [   64.955602]    Use it with care.
May 25 21:01:20 host kernel: [   64.955602] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
May 25 21:01:20 host kernel: [   64.955602]    2a80f296422a01178d0a993479369e94f5830127 [media] dvb-core: fix 32-bit overflow during bandwidth calculation
May 25 21:01:20 host kernel: [   64.955602]    13b019bbd170d788b1461c2e00b4578a07541dc5 [media] e4000: Fix rangehigh value
May 25 21:01:20 host kernel: [   64.955602]    c7861bb048669540ff51e2e1bf84d60f165007ad [media] e4000: implement V4L2 subdevice tuner and core ops
May 25 21:01:20 host kernel: [   64.969341] WARNING: You are using an experimental version of the media stack.
May 25 21:01:20 host kernel: [   64.969341]    As the driver is backported to an older kernel, it doesn't offer
May 25 21:01:20 host kernel: [   64.969341]    enough quality for its usage in production.
May 25 21:01:20 host kernel: [   64.969341]    Use it with care.
May 25 21:01:20 host kernel: [   64.969341] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
May 25 21:01:20 host kernel: [   64.969341]    2a80f296422a01178d0a993479369e94f5830127 [media] dvb-core: fix 32-bit overflow during bandwidth calculation
May 25 21:01:20 host kernel: [   64.969341]    13b019bbd170d788b1461c2e00b4578a07541dc5 [media] e4000: Fix rangehigh value
May 25 21:01:20 host kernel: [   64.969341]    c7861bb048669540ff51e2e1bf84d60f165007ad [media] e4000: implement V4L2 subdevice tuner and core ops
May 25 21:01:20 host kernel: [   64.989580] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
May 25 21:01:20 host kernel: [   65.224191] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
May 25 21:01:20 host kernel: [   65.224376] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
May 25 21:01:20 host kernel: [   65.225224] usb 2-1: media controller created
May 25 21:01:20 host kernel: [   65.226869] dvb_register_media_device: media device 'dvb-demux' registered.
May 25 21:01:20 host kernel: [   65.227151] dvb_register_media_device: media device 'dvb-dvr' registered.
May 25 21:01:20 host kernel: [   65.228877] dvb_register_media_device: media device 'dvb-net' registered.
May 25 21:01:20 host kernel: [   65.236185] i2c i2c-10: Added multiplexed i2c bus 11
May 25 21:01:20 host kernel: [   65.236193] si2168 10-0064: Silicon Labs Si2168 successfully attached
May 25 21:01:20 host kernel: [   65.244461] si2157 11-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
May 25 21:01:20 host kernel: [   65.244484] usb 2-1: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
May 25 21:01:20 host kernel: [   65.244609] dvb_register_media_device: media device 'Silicon Labs Si2168' registered.
May 25 21:01:20 host kernel: [   65.244948] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/input/input21
May 25 21:01:20 host kernel: [   65.246231] dvb-usb: schedule remote query interval to 100 msecs.
May 25 21:01:20 host kernel: [   65.246356] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized and connected.
May 25 21:01:20 host kernel: [   65.246407] usbcore: registered new interface driver dvb_usb_cxusb
May 25 21:02:11 host kernel: [  116.726003] si2168 10-0064: found a 'Silicon Labs Si2168-B40'
May 25 21:02:11 host kernel: [  116.726368] si2168 10-0064: firmware: direct-loading firmware dvb-demod-si2168-b40-01.fw
May 25 21:02:11 host kernel: [  116.726378] si2168 10-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
May 25 21:02:12 host kernel: [  117.304492] si2168 10-0064: firmware version: 4.0.4
May 25 21:02:12 host kernel: [  117.315988] si2157 11-0060: found a 'Silicon Labs Si2148-A20'
May 25 21:02:12 host kernel: [  117.316565] si2157 11-0060: firmware: direct-loading firmware dvb-tuner-si2158-a20-01.fw
May 25 21:02:12 host kernel: [  117.316575] si2157 11-0060: downloading firmware from file 'dvb-tuner-si2158-a20-01.fw'
May 25 21:02:13 host kernel: [  118.381875] si2157 11-0060: firmware version: 2.1.6

In addition to tuning problems unloading the driver or 
unpluging the tuner from the USB port causes a NULL pointer:

May 25 18:53:21 host kernel: [10869.037626] usb 6-2: USB disconnect, device number 7
May 25 18:53:21 host kernel: [10869.060993] BUG: unable to handle kernel NULL pointer dereference at 0000000000000200
May 25 18:53:21 host kernel: [10869.061081] IP: [<ffffffffa06422e4>] dvb_frontend_stop+0x34/0xd0 [dvb_core]
May 25 18:53:21 host kernel: [10869.061154] PGD b5fbc067 PUD b5778067 PMD 0 
May 25 18:53:21 host kernel: [10869.061204] Oops: 0000 [#1] SMP 
May 25 18:53:21 host kernel: [10869.061245] Modules linked in: si2157(O) si2168(O) i2c_mux dvb_usb_cxusb(O) dib0070(O) dvb_usb(O) dvb_core(O) media(O) rc_core(O) esp6 ah6 xfrm6_mode_transport authenc esp4 ah4 xfrm4_mode_transport ccm pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_generic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common ablk_helper cryptd des_generic cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic sha256_ssse3 sha256_generic hmac crypto_null af_key xfrm_algo joydev iTCO_wdt iTCO_vendor_support arc4 acer_wmi sparse_keymap iwldvm mac80211 coretemp snd_hda_codec_hdmi kvm_intel acerhdf kvm evdev snd_hda_codec_realtek pcspkr psmouse serio_raw i2c_i801 snd_hda_codec_generic i915 iwlwifi snd_hda_intel snd_hda_controller drm_kms_helper cfg80211 rfkill snd_hda_codec snd_hwdep drm snd_pcm snd_timer i2c_algo_bit lpc_ich mfd_core snd soundcore i2c_core shpchp battery wmi video ac button processor thermal_sys loop fuse parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 dm_mod sg sd_mod crc_t10dif crct10dif_generic crct10dif_common ahci libahci libata scsi_mod ehci_pci uhci_hcd ehci_hcd atl1c usbcore usb_common [last unloaded: videobuf2_memops]
May 25 18:53:21 host kernel: [10869.062773] CPU: 1 PID: 76 Comm: khubd Tainted: G          IO  3.16.0-4-amd64 #1 Debian 3.16.7-ckt9-3~deb8u1
May 25 18:53:21 host kernel: [10869.062857] Hardware name: Acer Aspire 1410/JM11-MS, BIOS v1.3314 08/31/2010
May 25 18:53:21 host kernel: [10869.062919] task: ffff880036c93370 ti: ffff880036c94000 task.ti: ffff880036c94000
May 25 18:53:21 host kernel: [10869.062980] RIP: 0010:[<ffffffffa06422e4>]  [<ffffffffa06422e4>] dvb_frontend_stop+0x34/0xd0 [dvb_core]
May 25 18:53:21 host kernel: [10869.063069] RSP: 0018:ffff880036c97bc8  EFLAGS: 00010293
May 25 18:53:21 host kernel: [10869.063116] RAX: ffff880036c93370 RBX: 0000000000000000 RCX: ffff880135c2bc00
May 25 18:53:21 host kernel: [10869.063175] RDX: 0000000000000053 RSI: ffff8800b7aca598 RDI: ffff8800b5d96830
May 25 18:53:21 host kernel: [10869.063233] RBP: ffff8800b5d96830 R08: 0000000000000000 R09: 0000000000000001
May 25 18:53:21 host kernel: [10869.063292] R10: 000000000000000b R11: 0000000000000000 R12: ffff8800b53a5278
May 25 18:53:21 host kernel: [10869.063350] R13: ffff8800b6027090 R14: ffff8800b6027000 R15: ffff8800b61cec00
May 25 18:53:21 host kernel: [10869.063408] FS:  0000000000000000(0000) GS:ffff8800bb680000(0000) knlGS:0000000000000000
May 25 18:53:21 host kernel: [10869.063475] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 25 18:53:21 host kernel: [10869.063523] CR2: 0000000000000200 CR3: 00000000b56e7000 CR4: 00000000000407e0
May 25 18:53:21 host kernel: [10869.063581] Stack:
May 25 18:53:21 host kernel: [10869.063602]  0000000000000000 ffff8800b5d96830 ffffffffa0642876 ffff8800b7a32a68
May 25 18:53:21 host kernel: [10869.063677]  ffff8800b505ba48 ffffffff8139ecac ffff8800b505b800 ffff8800b53a5278
May 25 18:53:21 host kernel: [10869.063751]  0000000000000000 ffff8800b53a5278 ffffffffa0531e55 ffff8800b53a4000
May 25 18:53:21 host kernel: [10869.063829] Call Trace:
May 25 18:53:21 host kernel: [10869.063861]  [<ffffffffa0642876>] ? dvb_unregister_frontend+0x36/0x100 [dvb_core]
May 25 18:53:21 host kernel: [10869.063927]  [<ffffffff8139ecac>] ? device_del+0x15c/0x1b0
May 25 18:53:21 host kernel: [10869.063979]  [<ffffffffa0531e55>] ? dvb_usb_adapter_frontend_exit+0x35/0x60 [dvb_usb]
May 25 18:53:21 host kernel: [10869.064047]  [<ffffffffa0530491>] ? dvb_usb_exit+0x41/0xe0 [dvb_usb]
May 25 18:53:21 host kernel: [10869.064103]  [<ffffffffa053056b>] ? dvb_usb_device_exit+0x3b/0x50 [dvb_usb]
May 25 18:53:21 host kernel: [10869.064193]  [<ffffffffa001f7dc>] ? usb_unbind_interface+0x6c/0x2b0 [usbcore]
May 25 18:53:21 host kernel: [10869.064258]  [<ffffffff813a283a>] ? __device_release_driver+0x7a/0xf0
May 25 18:53:21 host kernel: [10869.064313]  [<ffffffff813a28ce>] ? device_release_driver+0x1e/0x30
May 25 18:53:21 host kernel: [10869.064366]  [<ffffffff813a21d3>] ? bus_remove_device+0x103/0x180
May 25 18:53:21 host kernel: [10869.064416]  [<ffffffff8139ec66>] ? device_del+0x116/0x1b0
May 25 18:53:21 host kernel: [10869.064477]  [<ffffffffa001d200>] ? usb_disable_device+0xa0/0x280 [usbcore]
May 25 18:53:21 host kernel: [10869.064546]  [<ffffffffa0012e01>] ? usb_disconnect+0x91/0x280 [usbcore]
May 25 18:53:21 host kernel: [10869.064613]  [<ffffffffa001537c>] ? hub_thread+0xaac/0x1740 [usbcore]
May 25 18:53:21 host kernel: [10869.064669]  [<ffffffff8109f4d4>] ? check_preempt_wakeup+0xe4/0x1d0
May 25 18:53:21 host kernel: [10869.064724]  [<ffffffff810a7930>] ? prepare_to_wait_event+0xf0/0xf0
May 25 18:53:21 host kernel: [10869.064787]  [<ffffffffa00148d0>] ? hub_port_debounce+0x130/0x130 [usbcore]
May 25 18:53:21 host kernel: [10869.064817]  [<ffffffff81087edd>] ? kthread+0xbd/0xe0
May 25 18:53:21 host kernel: [10869.064817]  [<ffffffff81087e20>] ? kthread_create_on_node+0x180/0x180
May 25 18:53:21 host kernel: [10869.064817]  [<ffffffff81510d98>] ? ret_from_fork+0x58/0x90
May 25 18:53:21 host kernel: [10869.064817]  [<ffffffff81087e20>] ? kthread_create_on_node+0x180/0x180
May 25 18:53:21 host kernel: [10869.064817] Code: 00 00 04 55 48 89 fd 53 48 8b 9f 28 03 00 00 0f 85 85 00 00 00 83 bd 14 05 00 00 02 74 0a c7 85 14 05 00 00 01 00 00 00 0f ae f0 <48> 8b bb 00 02 00 00 48 85 ff 74 60 e8 db 5d a4 e0 48 8b 93 00 
May 25 18:53:21 host kernel: [10869.064817] RIP  [<ffffffffa06422e4>] dvb_frontend_stop+0x34/0xd0 [dvb_core]
May 25 18:53:21 host kernel: [10869.064817]  RSP <ffff880036c97bc8>
May 25 18:53:21 host kernel: [10869.064817] CR2: 0000000000000200
May 25 18:53:21 host kernel: [10869.064817] ---[ end trace da6362c4c78d40d5 ]---

May 25 21:41:59 host kernel: [ 1647.789421] usbcore: deregistering interface driver dvb_usb_cxusb
May 25 21:41:59 host kernel: [ 1647.812277] BUG: unable to handle kernel NULL pointer dereference at 0000000000000200
May 25 21:41:59 host kernel: [ 1647.812367] IP: [<ffffffffa07fcc48>] dvb_frontend_stop+0x38/0xf0 [dvb_core]
May 25 21:41:59 host kernel: [ 1647.812435] PGD 0 
May 25 21:41:59 host kernel: [ 1647.812459] Oops: 0000 [#1] SMP 
May 25 21:41:59 host kernel: [ 1647.812498] Modules linked in: si2157 si2168 i2c_mux dvb_usb_cxusb(-) dib0070 dvb_usb dvb_core rc_core authenc esp4 ah4 xfrm4_mode_transport ccm deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_generic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common ablk_helper cryptd des_generic cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic sha256_ssse3 sha256_generic hmac crypto_null af_key xfrm_algo joydev snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc videobuf2_memops snd_hda_codec_realtek videobuf2_core v4l2_common videodev media snd_hda_codec_generic arc4 iTCO_wdt iTCO_vendor_support acer_wmi sparse_keymap iwldvm coretemp mac80211 kvm_intel acerhdf kvm pcspkr iwlwifi psmouse evdev serio_raw snd_hda_intel i2c_i801 snd_hda_controller snd_hda_codec snd_hwdep lpc_ich snd_pcm cfg80211 mfd_core i915 snd_timer rfkill snd soundcore shpchp drm_kms_helper wmi video button ac battery drm acpi_cpufreq i2c_algo_bit i2c_core processor thermal_sys loop fuse parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 dm_mod sg sd_mod ahci libahci libata scsi_mod ehci_pci uhci_hcd ehci_hcd atl1c usbcore usb_common
May 25 21:41:59 host kernel: [ 1647.813889] CPU: 0 PID: 3227 Comm: modprobe Tainted: G          I     4.0.0-1-amd64 #1 Debian 4.0.2-1
May 25 21:41:59 host kernel: [ 1647.813962] Hardware name: Acer Aspire 1410/JM11-MS, BIOS v1.3314 08/31/2010
May 25 21:41:59 host kernel: [ 1647.814022] task: ffff88008ac843d0 ti: ffff8800b5714000 task.ti: ffff8800b5714000
May 25 21:41:59 host kernel: [ 1647.814080] RIP: 0010:[<ffffffffa07fcc48>]  [<ffffffffa07fcc48>] dvb_frontend_stop+0x38/0xf0 [dvb_core]
May 25 21:41:59 host kernel: [ 1647.814164] RSP: 0018:ffff8800b5717d88  EFLAGS: 00010293
May 25 21:41:59 host kernel: [ 1647.814211] RAX: ffff88008ac843d0 RBX: 0000000000000000 RCX: 01ffff8000000080
May 25 21:41:59 host kernel: [ 1647.814267] RDX: 0000000080000000 RSI: 0000000000000282 RDI: ffff880036286830
May 25 21:41:59 host kernel: [ 1647.814323] RBP: ffff880036286830 R08: 000000000000002e R09: 0000000000000000
May 25 21:41:59 host kernel: [ 1647.814378] R10: 0000000000000282 R11: 0000000000000000 R12: ffff880036351278
May 25 21:41:59 host kernel: [ 1647.814434] R13: ffffffffa082a0a8 R14: ffff8800b5764090 R15: ffff8800b5764000
May 25 21:41:59 host kernel: [ 1647.814491] FS:  00007f2598451700(0000) GS:ffff8800bb600000(0000) knlGS:0000000000000000
May 25 21:41:59 host kernel: [ 1647.814557] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 25 21:41:59 host kernel: [ 1647.814603] CR2: 0000000000000200 CR3: 00000000b57d4000 CR4: 00000000000407f0
May 25 21:41:59 host kernel: [ 1647.814659] Stack:
May 25 21:41:59 host kernel: [ 1647.814680]  ffff8800b5764000 0000000000000000 ffff880036286830 ffffffffa07fd216
May 25 21:41:59 host kernel: [ 1647.814755]  ffffffff818b9240 ffff8800b47826e0 ffff8800b459da58 ffff8800b5764090
May 25 21:41:59 host kernel: [ 1647.814830]  ffff8800b5764000 ffff880036350000 ffff880036351278 0000000000000000
May 25 21:41:59 host kernel: [ 1647.814905] Call Trace:
May 25 21:41:59 host kernel: [ 1647.814937]  [<ffffffffa07fd216>] ? dvb_unregister_frontend+0x36/0x120 [dvb_core]
May 25 21:41:59 host kernel: [ 1647.815001]  [<ffffffffa081a877>] ? dvb_usb_adapter_frontend_exit+0x37/0x60 [dvb_usb]
May 25 21:41:59 host kernel: [ 1647.815065]  [<ffffffffa08193f1>] ? dvb_usb_exit+0x31/0xa0 [dvb_usb]
May 25 21:41:59 host kernel: [ 1647.815120]  [<ffffffffa081949b>] ? dvb_usb_device_exit+0x3b/0x50 [dvb_usb]
May 25 21:41:59 host kernel: [ 1647.815210]  [<ffffffffa001a529>] ? usb_unbind_interface+0x79/0x2a0 [usbcore]
May 25 21:41:59 host kernel: [ 1647.815273]  [<ffffffff813f083e>] ? __device_release_driver+0x7e/0x100
May 25 21:41:59 host kernel: [ 1647.815328]  [<ffffffff813f1258>] ? driver_detach+0xa8/0xb0
May 25 21:41:59 host kernel: [ 1647.815375]  [<ffffffff813f04c5>] ? bus_remove_driver+0x55/0xe0
May 25 21:41:59 host kernel: [ 1647.815435]  [<ffffffffa0019766>] ? usb_deregister+0x66/0xd0 [usbcore]
May 25 21:41:59 host kernel: [ 1647.816090]  [<ffffffff810e785f>] ? SyS_delete_module+0x1bf/0x270
May 25 21:41:59 host kernel: [ 1647.816090]  [<ffffffff81013ef9>] ? do_notify_resume+0x69/0x90
May 25 21:41:59 host kernel: [ 1647.816090]  [<ffffffff8156418d>] ? system_call_fast_compare_end+0xc/0x11
May 25 21:41:59 host kernel: [ 1647.816090] Code: 08 f6 05 85 c9 00 00 04 48 8b 9f 28 03 00 00 0f 85 9e 00 00 00 83 bd 14 05 00 00 02 74 0a c7 85 14 05 00 00 01 00 00 00 0f ae f0 <48> 8b bb 00 02 00 00 48 85 ff 74 6c e8 17 e0 88 e0 48 8b 93 00 
May 25 21:41:59 host kernel: [ 1647.816090] RIP  [<ffffffffa07fcc48>] dvb_frontend_stop+0x38/0xf0 [dvb_core]
May 25 21:41:59 host kernel: [ 1647.816090]  RSP <ffff8800b5717d88>
May 25 21:41:59 host kernel: [ 1647.816090] CR2: 0000000000000200
May 25 21:41:59 host kernel: [ 1647.850916] ---[ end trace eb0fc7caeac40083 ]---

-- 
Valentin
