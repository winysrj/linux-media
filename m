Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32933 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945945AbcBRKW4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 05:22:56 -0500
Received: by mail-qg0-f53.google.com with SMTP id b35so32952278qge.0
        for <linux-media@vger.kernel.org>; Thu, 18 Feb 2016 02:22:56 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Feb 2016 11:22:55 +0100
Message-ID: <CAAGRkmgRA3RyM5ofgt08UqbU2iEKFEYe1Sv8GMTr1uowkQg8xg@mail.gmail.com>
Subject: Kernel oops with Technotrend TT4400
From: Bert Haverkamp <bert.haverkamp@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all, I am trying to revive my Technotrend TT4400.
However I ran into this kernel oops when trying to unplug/replug the dongle:
What can have caused this?


[6363904.273875] usb 1-5: USB disconnect, device number 13
[6363904.333388] BUG: unable to handle kernel NULL pointer dereference
at 00000000000000c0
[6363904.336250] IP: [<ffffffffc091ca4d>] si2168_sleep+0x2d/0xd0 [si2168]
[6363904.336250] PGD 0
[6363904.336250] Oops: 0000 [#2] SMP
[6363904.336250] Modules linked in: rc_tt_1500 si2157 si2168
dvb_usb_dvbsky dvb_usb_v2 m88ds3103 dvb_core rc_core i2c_mux bluetooth
btrfs ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c
ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables
x_tables binfmt_misc uvcvideo videobuf2_vmalloc ppdev videobuf2_memops
videobuf2_core v4l2_common option snd_hda_codec_realtek videodev
usb_wwan snd_hda_codec_generic media snd_usb_audio snd_hda_intel
usbserial snd_hda_codec snd_usbmidi_lib snd_hda_core snd_hwdep
input_leds snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
snd_seq_device snd_timer coretemp snd soundcore lpc_ich serio_raw
shpchp 8250_fintek mac_hid parport_pc nfsd auth_rpcgss nfs_acl lockd
grace sunrpc lp parport autofs4 raid10 raid1 raid0 multipath linear
raid456 async_raid6_recov
[6363904.336250]  async_memcpy async_pq async_xor async_tx xor
raid6_pq pata_marvell hid_generic uas usbhid hid usb_storage i915
psmouse video i2c_algo_bit drm_kms_helper ahci pata_acpi libahci drm
sata_sil r8169 mii floppy [last unloaded: rc_tt_1500]
[6363904.336250] CPU: 3 PID: 25469 Comm: kdvb-ad-0-fe-0 Tainted: G
 D W       4.2.0-19-generic #23-Ubuntu
[6363904.336250] Hardware name:    /LakePort, BIOS 6.00 PG 03/24/2009
[6363904.336250] task: ffff880002f8cb00 ti: ffff880002a08000 task.ti:
ffff880002a08000
[6363904.336250] RIP: 0010:[<ffffffffc091ca4d>]  [<ffffffffc091ca4d>]
si2168_sleep+0x2d/0xd0 [si2168]
[6363904.336250] RSP: 0018:ffff880002a0bd98  EFLAGS: 00010246
[6363904.336250] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff88000017edf0
[6363904.336250] RDX: 0000000080000000 RSI: 0000000000000282 RDI:
ffff880003802008
[6363904.336250] RBP: ffff880002a0bdd8 R08: 0000000000000000 R09:
0000000000000000
[6363904.336250] R10: 0000000000000016 R11: ffff880076eeb140 R12:
ffff880003802008
[6363904.336250] R13: ffff88003519a000 R14: ffff88003519a5a8 R15:
00000000000000d6
[6363904.336250] FS:  0000000000000000(0000) GS:ffff88007f180000(0000)
knlGS:0000000000000000
[6363904.336250] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6363904.336250] CR2: 00000000000000c0 CR3: 00000000790bc000 CR4:
00000000000006e0
[6363904.336250] Stack:
[6363904.336250]  000000015ed33a31 ffffffff810e5240 ffff880002f8cb00
ffffffff00000003
[6363904.336250]  ffff8800ffffffff 000000001f734279 ffff88003519a460
ffff880003802008
[6363904.336250]  ffff880002a0be18 ffffffffc0913be4 ffff880002a0be18
ffffffff810c3803
[6363904.336250] Call Trace:
[6363904.336250]  [<ffffffff810e5240>] ?
trace_event_raw_event_tick_stop+0xf0/0xf0
[6363904.336250]  [<ffffffffc0913be4>] dvb_usb_fe_sleep+0x74/0x1b0 [dvb_usb_v2]
[6363904.336250]  [<ffffffff810c3803>] ? down_interruptible+0x33/0x60
[6363904.336250]  [<ffffffffc08fc15d>] dvb_frontend_thread+0x2bd/0x720
[dvb_core]
[6363904.336250]  [<ffffffff817ebb7c>] ? __schedule+0x36c/0x950
[6363904.336250]  [<ffffffff810bd110>] ? wake_atomic_t_function+0x60/0x60
[6363904.336250]  [<ffffffffc08fbea0>] ?
dvb_frontend_release+0xf0/0xf0 [dvb_core]
[6363904.336250]  [<ffffffff8109a7e8>] kthread+0xd8/0xf0
[6363904.336250]  [<ffffffff8109a710>] ? kthread_create_on_node+0x1f0/0x1f0
[6363904.336250]  [<ffffffff817f061f>] ret_from_fork+0x3f/0x70
[6363904.336250]  [<ffffffff8109a710>] ? kthread_create_on_node+0x1f0/0x1f0
[6363904.336250] Code: 44 00 00 55 48 89 e5 41 54 53 48 83 ec 30 48 8b
9f 18 03 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 e8 31 c0 f6 05 9d
27 00 00 04 <4c> 8b a3 c0 00 00 00 75 55 48 8d 75 c0 41 c6 84 24 28 05
00 00
[6363904.336250] RIP  [<ffffffffc091ca4d>] si2168_sleep+0x2d/0xd0 [si2168]
[6363904.336250]  RSP <ffff880002a0bd98>
[6363904.336250] CR2: 00000000000000c0
[6363904.336250] ---[ end trace c07ed01cdcc826c8 ]---
[6363904.664803] usb 1-5: dvb_frontend_stop: warning: thread
ffff880002f8cb00 won't exit
