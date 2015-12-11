Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbbLKB6s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 20:58:48 -0500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>
Cc: linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Laura Abbott <labbott@redhat.com>
Subject: Crash on suspend from pvrusb2 on suspend
Message-ID: <566A2DD6.3030108@redhat.com>
Date: Thu, 10 Dec 2015 17:58:46 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[I think some thing ate this message so I apologize if this is a duplicate]

Hi,

We have a report (https://bugzilla.redhat.com/show_bug.cgi?id=1288856) of a crash
from pvrusb2 when suspending to ram:

-----
[   95.801325] e1000e: eno1 NIC Link is Down
[   95.864208] PM: Syncing filesystems ... done.
[   96.133040] PM: Preparing system for sleep (mem)
[   96.133744] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   96.135874] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   96.136942] PM: Suspending system (mem)
[   96.136973] Suspending console(s) (use no_console_suspend to debug)
[   96.139942] pvrusb2: Device being rendered inoperable
[   96.139988] BUG: unable to handle kernel NULL pointer dereference at 00000000000003b0
[   96.140004] IP: [<ffffffffa07172e4>] pvr2_v4l2_internal_check+0x54/0x70 [pvrusb2]
[   96.140007] PGD 0
[   96.140011] Oops: 0000 [#1] SMP
[   96.140063] Modules linked in: s5h1411 tda18271 nct6775 hwmon_vid
xt_conntrack xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack tda8290 tuner cx25840 pvrusb2 tveeprom cx2341x dvb_core
v4l2_common snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_hda_codec_hdmi
nouveau snd_hda_codec_realtek vfat fat snd_hda_codec_generic snd_hda_intel
snd_hda_codec intel_rapl iosf_mbi snd_hda_core x86_pkg_temp_thermal
i2c_algo_bit eeepc_wmi asus_wmi coretemp snd_hwdep ttm sparse_keymap snd_seq
iTCO_wdt rfkill iTCO_vendor_support kvm_intel video drm_kms_helper
snd_seq_device kvm drm snd_pcm gspca_zc3xx gspca_main crct10dif_pclmul videodev
crc32_pclmul snd_timer crc32c_intel snd mei_me sb_edac joydev media mei
edac_core soundcore shpchp lpc_ich i2c_i801 tpm_infineon tpm_tis tpm nfsd
auth_rpcgss
[   96.140073]  nfs_acl lockd grace sunrpc binfmt_misc uas usb_storage 8021q
garp stp llc mrp mxm_wmi e1000e
[   96.140073] sd 7:0:0:0: [sdd] Synchronizing SCSI cache
[   96.140078]  serio_raw ptp pps_core wmi wacom loop
[   96.140081] CPU: 8 PID: 837 Comm: pvrusb2-context Not tainted 4.2.6-201.fc22.x86_64 #1
[   96.140083] Hardware name: ASUS All Series/X99-A/USB 3.1, BIOS 0401 02/11/2015
[   96.140085] task: ffff8808177abb00 ti: ffff88081a3b0000 task.ti: ffff88081a3b0000
[   96.140094] RIP: 0010:[<ffffffffa07172e4>]  [<ffffffffa07172e4>] pvr2_v4l2_internal_check+0x54/0x70 [pvrusb2]
[   96.140095] RSP: 0000:ffff88081a3b3e48  EFLAGS: 00010246
[   96.140096] RAX: 0000000000000000 RBX: ffff88081898c1e0 RCX: dead000000200200
[   96.140097] RDX: 00000000000003b0 RSI: 0000000000000000 RDI: 0000000000000000
[   96.140098] RBP: ffff88081a3b3e58 R08: ffff88081a3b3e80 R09: 0000000000000001
[   96.140099] R10: 0000000000000020 R11: 0000000000000004 R12: ffff880819a80540
[   96.140100] R13: ffff88081a3b3e80 R14: 0000000000000000 R15: 0000000000000000
[   96.140102] FS:  0000000000000000(0000) GS:ffff88081f400000(0000) knlGS:0000000000000000
[   96.140104] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   96.140105] CR2: 00000000000003b0 CR3: 0000000001c0b000 CR4: 00000000001406e0
[   96.140106] Stack:
[   96.140109]  0000000000000000 ffff880817d35800 ffff88081a3b3eb8 ffffffffa071992c
[   96.140111]  0000000000000000 ffff8808177abb00 ffffffff810df990 ffff88081a3b3e80
[   96.140114]  ffff88081a3b3e80 0000000033bc8b30 ffff88081a3b3eb8 ffff880816857e00
[   96.140114] Call Trace:
[   96.140124]  [<ffffffffa071992c>] pvr2_context_thread_func+0xcc/0x330 [pvrusb2]
[   96.140129]  [<ffffffff810df990>] ? wake_atomic_t_function+0x70/0x70
[   96.140135]  [<ffffffffa0719860>] ? pvr2_context_destroy+0xd0/0xd0 [pvrusb2]
[   96.140139]  [<ffffffff810bc8b8>] kthread+0xd8/0xf0
[   96.140142]  [<ffffffff810bc7e0>] ? kthread_worker_fn+0x160/0x160
[   96.140147]  [<ffffffff817797df>] ret_from_fork+0x3f/0x70
[   96.140150]  [<ffffffff810bc7e0>] ? kthread_worker_fn+0x160/0x160
[   96.140176] Code: e8 82 e3 ff ff 48 8b 43 38 48 8d 90 b0 03 00 00 48 39 90 b0 03 00 00 74 07 48 83
[   96.140176] sd 6:0:0:0: [sdc] Synchronizing SCSI cache
[   96.140190] c4 08 5b 5d c3 48 8b 43 40 48 8d 90 b0 03 00 00 <48> 39 90 b0 03 00 00 75 e5 48 89 df e8 0b fa ff ff eb db 66 0f
[   96.140196] RIP  [<ffffffffa07172e4>] pvr2_v4l2_internal_check+0x54/0x70 [pvrusb2]
[   96.140198] sd 7:0:0:0: [sdd] Stopping disk
[   96.140199]  RSP <ffff88081a3b3e48>
[   96.140200] CR2: 00000000000003b0
[   96.140202] ---[ end trace d86b844f58f035a7 ]---
-----

The kernel is old but I haven't seen any updates to the pvrusb2 module since
4.2. Is this a known issue at all?

Thanks,
Laura
