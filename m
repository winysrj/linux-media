Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:49483 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753058Ab2DVXwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 19:52:19 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: Problem with az007 and resume from suspend
Date: Mon, 23 Apr 2012 01:45:03 +0200
Message-ID: <4241650.I71sG81dhF@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When resume from suspend I get:

[83245.571382] dvb-usb: found a 'TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)' 
in cold state, will try to load a firmware
[83245.571391] ------------[ cut here ]------------
[83245.571403] WARNING: at drivers/base/firmware_class.c:537 
_request_firmware+0xea/0x3e5()
[83245.571408] Hardware name: System Product Name
[83245.571411] Modules linked in: mt2063(O) drxk(O) dvb_usb_az6007(O) hidp 
fuse ext2 nfsd lockd nfs_acl auth_rpcgss sunrpc p4_clockmod freq_table 
speedstep_lib rfcomm bnep rc_nec_terratec_cinergy_xs(O) nvidia(P) mxl5007t(O) 
ir_lirc_codec(O) lirc_dev(O) ir_mce_kbd_decoder(O) ir_sanyo_decoder(O) 
ir_sony_decoder(O) ir_jvc_decoder(O) ir_rc6_decoder(O) ir_rc5_decoder(O) 
af9033(O) ir_nec_decoder(O) dvb_usb_af9035(O) dvb_usb(O) dvb_core(O) 
rc_core(O) snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd btusb 
soundcore bluetooth microcode rfkill snd_page_alloc pcspkr serio_raw i2c_i801 
iTCO_wdt iTCO_vendor_support xhci_hcd r8169 mii asus_atk0110 uinput ipv6 
nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video [last 
unloaded: r8712u]
[83245.571508] Pid: 5740, comm: pm-suspend Tainted: P        WC O 3.2.1 #1
[83245.571512] Call Trace:
[83245.571522]  [<ffffffff81057a92>] warn_slowpath_common+0x83/0x9b
[83245.571531]  [<ffffffff81057ac4>] warn_slowpath_null+0x1a/0x1c
[83245.571538]  [<ffffffff8131378a>] _request_firmware+0xea/0x3e5
[83245.571545]  [<ffffffff81313a9b>] request_firmware+0x16/0x18
[83245.571559]  [<ffffffffa01ed2a6>] dvb_usb_download_firmware+0x34/0xbe [dvb_usb]
[83245.571570]  [<ffffffffa01ed6cb>] dvb_usb_device_init+0x1d5/0x602 [dvb_usb]
[83245.571581]  [<ffffffffa034e145>] az6007_usb_probe+0x25/0x27 [dvb_usb_az6007]
[83245.571589]  [<ffffffff8136b232>] usb_probe_interface+0x14a/0x1b7
[83245.571598]  [<ffffffff81309628>] driver_probe_device+0x136/0x25a
[83245.571605]  [<ffffffff81309804>] __device_attach+0x3a/0x3f
[83245.571612]  [<ffffffff813097ca>] ? __driver_attach+0x7e/0x7e
[83245.571619]  [<ffffffff813083aa>] bus_for_each_drv+0x56/0x8c
[83245.571627]  [<ffffffff81309488>] device_attach+0x7b/0x9f
[83245.571633]  [<ffffffff8136aee2>] usb_rebind_intf+0x65/0x81
[83245.571640]  [<ffffffff8136afb1>] do_unbind_rebind+0x63/0x79
[83245.571647]  [<ffffffff8136b02c>] usb_resume+0x65/0x7c
[83245.571654]  [<ffffffff8135ecfe>] usb_dev_complete+0x10/0x12
[83245.571661]  [<ffffffff8130ff99>] dpm_complete+0x137/0x1ad
[83245.571669]  [<ffffffff81310028>] dpm_resume_end+0x19/0x1d
[83245.571677]  [<ffffffff8108bb68>] suspend_devices_and_enter+0x1d6/0x21a
[83245.571684]  [<ffffffff8108bcd5>] enter_state+0x129/0x16e
[83245.571691]  [<ffffffff8108ab6b>] state_store+0xbc/0x106
[83245.571699]  [<ffffffff8124b293>] kobj_attr_store+0x17/0x19
[83245.571707]  [<ffffffff8118551c>] sysfs_write_file+0x101/0x13d
[83245.571716]  [<ffffffff8112ac6d>] vfs_write+0xac/0xf3
[83245.571723]  [<ffffffff8112ae5c>] sys_write+0x4a/0x6e
[83245.571732]  [<ffffffff814ab802>] system_call_fastpath+0x16/0x1b
[83245.571737] ---[ end trace 46c4416a4ddedede ]---
[83245.571743] usb 1-5: firmware: dvb-usb-terratec-h7-az6007.fw will not be 
loaded
[83245.571750] dvb-usb: did not find the firmware file. (dvb-usb-terratec-h7-
az6007.fw) Please see linux/Documentation/dvb/ for more details on firmware-
problems. (-16)
[83245.571763] dvb_usb_az6007: probe of 1-5:1.0 failed with error -16

¿Anybody know whats wrong?

Jose Alberto


