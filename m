Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.shic.co.uk ([94.23.159.123]:49322 "EHLO gw.shic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbbDZJrW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2015 05:47:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by gw.shic.co.uk (Postfix) with ESMTP id 8E98B16C0B1C
	for <linux-media@vger.kernel.org>; Sun, 26 Apr 2015 10:47:20 +0100 (BST)
Received: from gw.shic.co.uk ([IPv6:::ffff:192.168.42.2])
	by localhost (localhost [::ffff:127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K15v6eyXOflO for <linux-media@vger.kernel.org>;
	Sun, 26 Apr 2015 10:47:18 +0100 (BST)
Received: from [192.168.0.135] (unknown [192.168.0.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by gw.shic.co.uk (Postfix) with ESMTPSA id D675D16C0520
	for <linux-media@vger.kernel.org>; Sun, 26 Apr 2015 10:47:17 +0100 (BST)
Message-ID: <553CB425.1090403@shic.co.uk>
Date: Sun, 26 Apr 2015 10:47:17 +0100
From: Steve <sjh_lmml@shic.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with "SaTiX-S2 Sky V2 USB"
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently upgraded to Ubuntu 15.04 to get a 3.19 kernel because the 
Linux TV Wiki suggests that, from kernel version 3.18 onwards, my 
"Mystique SaTiX-S2 Sky V2 USB (DVBSKY S960 clone)" would work 'out of 
the box'.

I followed the MythTV instructions by installing dvb-apps and mplayer. 
Unfortunately, the next step - attempting to scan for channels - fails:

> root# scan -x0 /usr/share/dvb/dvb-s/Astra-28.2E
> scanning /usr/share/dvb/dvb-s/Astra-28.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> main:2745: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No 
> such file or directory

When I look in /dev/dvb/adapter0, I don't have a frontend0 device:

> root# ls -l /dev/dvb/adapter0
> total 0
> crw-rw----+ 1 root video 212, 0 Apr 24 13:57 demux0
> crw-rw----+ 1 root video 212, 1 Apr 24 13:57 dvr0
> crw-rw----+ 1 root video 212, 2 Apr 24 13:57 net0

Looking at the output from dmesg, I find evidence for a likely cause...

>
> [   15.316027] usb 2-3: dvb_usb_v2: found a 'DVBSky S960/S860' in warm 
> state
> [   15.316147] usb 2-3: dvb_usb_v2: will pass the complete MPEG2 
> transport stream to the software demuxer
> [   15.316164] DVB: registering new adapter (DVBSky S960/S860)
> [   15.317421] usb 2-3: dvb_usb_v2: MAC address: 00:17:42:54:96:0c
> [   15.627310] i2c i2c-7: m88ds3103_attach: chip_id=70
> [   15.631284] i2c i2c-7: Added multiplexed i2c bus 8
> [   15.745707] BUG: unable to handle kernel NULL pointer dereference 
> at 0000000000000040
> [   15.745748] IP:     [<ffffffff8126e6be>] sysfs_remove_link+0xe/0x30
> [   15.745774] PGD 0
> [   15.745785] Oops: 0000     [#1] SMP
> [   15.745804] Modules linked in: m88ts2022 m88ds3103 i2c_mux 
> dvb_usb_dvbsky(+) dvb_usb_v2 dvb_core rc_core snd_hda_codec_realtek 
> snd_hda_codec_generic snd_hda_intel snd_usb_audio snd_hda_controller 
> gpio_ich hp_wmi sparse_keymap snd_hda_codec snd_usbmidi_lib snd_hwdep 
> snd_pcm i915 snd_seq_midi snd_seq_midi_event coretemp snd_rawmidi 
> snd_seq joydev snd_seq_device drm_kms_helper drm snd_timer kvm mei_me 
> snd mei serio_raw lpc_ich shpchp soundcore 8250_fintek video wmi 
> i2c_algo_bit tpm_infineon mac_hid parport_pc ppdev lp parport autofs4 
> hid_generic usbhid hid uas usb_storage psmouse ahci libahci e1000e ptp 
> pps_core pata_acpi
> [   15.746140] CPU: 0 PID: 295 Comm: systemd-udevd Not tainted 
> 3.19.0-15-generic #15-Ubuntu
> [   15.746168] Hardware name: Hewlett-Packard HP Compaq 6000 Pro SFF 
> PC/3048h, BIOS 786G2 v01.09 08/25/2009
> [   15.746199] task: ffff880191ce93a0 ti: ffff880193648000 task.ti: 
> ffff880193648000
> [   15.746224] RIP: 0010:    [<ffffffff8126e6be>] [<ffffffff8126e6be>] 
> sysfs_remove_link+0xe/0x30
> [   15.746255] RSP: 0018:ffff88019364ba78  EFLAGS: 00010202
> [   15.746274] RAX: 0000000000000000 RBX: ffff8800d5b4e000 RCX: 
> 00000000ffffffff
> [   15.746298] RDX: ffff88019364ba95 RSI: ffff88019364ba8c RDI: 
> 0000000000000010
> [   15.746322] RBP: ffff88019364ba78 R08: 000000000000000a R09: 
> 000000000000fffb
> [   15.746346] R10: 0000000000000000 R11: 0000000000000000 R12: 
> ffff8800d5b4e000
> [   15.746369] R13: ffff880191cc4a78 R14: ffff880191cc4a80 R15: 
> 00000000ffffffed
> [   15.746393] FS:  00007fe8946f3880(0000) GS:ffff88019bc00000(0000) 
> knlGS:0000000000000000
> [   15.746420] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   15.746440] CR2: 0000000000000040 CR3: 000000019367e000 CR4: 
> 00000000000407f0
> [   15.746463] Stack:
> [   15.746473]  ffff88019364bab8 ffffffffc05481b3 6e616863d6a98838 
> 323000302d6c656e
> [   15.746507]  0000000000000032 00000000da2bae1e ffff8800d6a98800 
> ffffffffc054f680
> [   15.746541]  ffff88019364bad8 ffffffffc054f6a1 0000000000000000 
> ffff8800d6a98838
> [   15.746575] Call Trace:
> [   15.746588]      [<ffffffffc05481b3>] 
> i2c_del_mux_adapter+0x53/0x90     [i2c_mux]
> [   15.746614]      [<ffffffffc054f680>] ? 
> m88ds3103_init+0x3f0/0x3f0     [m88ds3103]
> [   15.746638]      [<ffffffffc054f6a1>] 
> m88ds3103_release+0x21/0x30     [m88ds3103]
> [   15.746667]      [<ffffffffc05868a5>] 
> dvb_frontend_detach+0x75/0x90     [dvb_core]
> [   15.746693]      [<ffffffffc059dfc6>] 
> dvb_usbv2_probe+0xc06/0x1200     [dvb_usb_v2]
> [   15.746719]      [<ffffffff817c6e56>] ? mutex_lock+0x16/0x40
> [   15.746740]      [<ffffffff815c2b5b>] usb_probe_interface+0x1bb/0x300
> [   15.746763]      [<ffffffff815064f3>] driver_probe_device+0xa3/0x410
> [   15.746784]      [<ffffffff8150693b>] __driver_attach+0x9b/0xa0
> [   15.746805]      [<ffffffff815068a0>] ? __device_attach+0x40/0x40
> [   15.746826]      [<ffffffff815042bb>] bus_for_each_dev+0x6b/0xb0
> [   15.746847]      [<ffffffff81505f5e>] driver_attach+0x1e/0x20
> [   15.746866]      [<ffffffff81505b30>] bus_add_driver+0x180/0x250
> [   15.746887]      [<ffffffff81507134>] driver_register+0x64/0xf0
> [   15.746908]      [<ffffffff815c1342>] usb_register_driver+0x82/0x160
> [   15.746931]      [<ffffffffc0544000>] ? 0xffffffffc0544000
> [   15.746952]      [<ffffffffc054401e>] 
> dvbsky_usb_driver_init+0x1e/0x1000     [dvb_usb_dvbsky]
> [   15.746980]      [<ffffffff81002148>] do_one_initcall+0xd8/0x210
> [   15.747002]      [<ffffffff811d5b49>] ? 
> kmem_cache_alloc_trace+0x189/0x200
> [   15.747027]      [<ffffffff810f99c4>] ? load_module+0x15a4/0x1ce0
> [   15.747047]      [<ffffffff810f99fe>] load_module+0x15de/0x1ce0
> [   15.747068]      [<ffffffff810f51d0>] ? store_uevent+0x40/0x40
> [   15.747089]      [<ffffffff810fa276>] SyS_finit_module+0x86/0xb0
> [   15.747111]      [<ffffffff817c934d>] system_call_fastpath+0x16/0x1b
> [   15.747132] Code: 48 8b 35 fe 5b d4 00 48 8b 57 10 e8 0d dd ff ff 
> 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 66 66 66 66 90 55 48 85 ff 48 
> 89 e5 74 12 <48> 8b 7f 30 31 d2 e8 47 dc ff ff 5d c3 0f 1f 44 00 00 48 
> 8b 3d
> [   15.747358] RIP      [<ffffffff8126e6be>] sysfs_remove_link+0xe/0x30
> [   15.747383]  RSP <ffff88019364ba78>
> [   15.747397] CR2: 0000000000000040
> [   15.747411] ---    [ end trace 0ba2ff80b8cb1db7 ]---

I'd like to know: does this indicate that I have a faulty device; that 
the kernel support for the device is faulty - or that there is some 
other (Ubuntu-specific?) glitch?

I've noticed that while 'lsusb' works without the Satix device attached, 
when the device is attached, lsusb hangs indefinitely - it can be 
neither suspended with "^Z" nor terminated with "^C".

Thanks in advance for any advice...



