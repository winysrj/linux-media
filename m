Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35747 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3BABwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 20:52:25 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so1544934eaa.23
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 17:52:23 -0800 (PST)
Message-ID: <510B1FD4.5020800@gmail.com>
Date: Fri, 01 Feb 2013 02:52:20 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com, 699470@bugs.debian.org
Subject: [PATCH] crystalhd git.linuxtv.org kernel driver: FIX MORE null pointer
 BUGs triggered by multithreaded or faulty apps
References: <50E3E643.7070701@gmail.com> <50E5A116.9070307@schinagl.nl> <50E8203C.20603@gmail.com> <50EB5B44.6020603@gmail.com> <50EF6042.7010908@gmail.com>
In-Reply-To: <50EF6042.7010908@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040908040902070104050206"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040908040902070104050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch should pass the 2nd test case of this bug.

The Broadcom driver can only handle strict open->close sequences, not in parallel or subsequent open() before HANDLE close(),
so using the usual multithreaded or faulty apps will crash the kernel due to missing !ctx->hw_ctx exception catchers:

[545486.745240] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
[545486.832451] BUG: unable to handle kernel NULL pointer dereference at 00000000000002c8
[545486.832525] IP: [<ffffffffa0765b0b>] bc_cproc_reg_rd+0x3b/0x50 [crystalhd]
[545486.832587] PGD 4508067 PUD fb7c067 PMD 0
[545486.832624] Oops: 0000 [#1] PREEMPT SMP
[545486.832660] CPU 0
[545486.832676] Modules linked in: crystalhd(O) udf crc_itu_t sr_mod cdrom nfs fscache uinput parport_pc ppdev lp parport bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_performance cpufreq_ondemand freq_table fuse dm_mod ext3 jbd pciehp arc4 ath5k ath mac80211 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_usb_audio cfg80211 snd_pcm_oss snd_mixer_oss snd_hwdep snd_usbmidi_lib snd_pcm thinkpad_acpi
[545486.833129] crystalhd_hw_stats: Invalid Arguments
[545486.833014]  snd_seq_dummy snd_seq_oss rfkill snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq gspca_zc3xx pcmcia gspca_main snd_timer tpm_tis snd_seq_device videodev psmouse tpm usb_storage yenta_socket snd pcmcia_rsrc tpm_bios i2c_i801 nvram v4l2_compat_ioctl32 pcmcia_core soundcore snd_page_alloc rtc_cmos wmi pcspkr serio_raw processor battery ac evdev nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit xt_tcpudp iptable_filter ip_tables x_tables ext4 mbcache jbd2 crc16 usbhid hid sg sd_mod crc_t10dif ata_generic uhci_hcd xhci_hcd ahci libahci ata_piix libata thermal ehci_hcd atkbd usbcore e1000e usb_common [last unloaded: crystalhd]
[545486.833014]
[545486.833014] Pid: 27551, comm: matroskademux1: Tainted: G        W  O 3.2.37-dirty #8 LENOVO 7735Y1T/7735Y1T
[545486.833014] RIP: 0010:[<ffffffffa0765b0b>]  [<ffffffffa0765b0b>] bc_cproc_reg_rd+0x3b/0x50 [crystalhd]
[545486.833014] RSP: 0018:ffff8800171f1e68  EFLAGS: 00010286
[545486.833014] RAX: 0000000000000000 RBX: ffff880011fc9800 RCX: 00000000fffffffc
[545486.833014] RDX: 0000000000000000 RSI: 000000000034000c RDI: ffff88000ddd6e00
[545486.833014] RBP: ffff8800171f1e78 R08: 0000000000000001 R09: 0000000000000000
[545486.833014] R10: fffffffff3640327 R11: ffff880031fd45a0 R12: 0000000003054fb0
[545486.833014] R13: ffff880011fc9800 R14: 0000000000000000 R15: ffffffffa0765ad0
[545486.833014] FS:  00007fd179f36700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[545486.833014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[545486.833014] CR2: 00000000000002c8 CR3: 0000000017098000 CR4: 00000000000006f0
[545486.833014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[545486.833014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[545486.833014] Process matroskademux1: (pid: 27551, threadinfo ffff8800171f0000, task ffff880031fd3ee0)
[545486.833014] Stack:
[545486.833014]  0000000000000000 ffff88000ddd6e00 ffff8800171f1ec8 ffffffffa0763da1
[545486.833014]  0000000000000000 00000000c2206202 ffff8800171f1ec8 ffff88000ddd6e00
[545486.833014]  ffff88000ddd6ed0 00000000c2206202 0000000003054fb0 0000000000000000
[545486.833014] Call Trace:
[545486.833014]  [<ffffffffa0763da1>] chd_dec_api_cmd+0x81/0x100 [crystalhd]
[545486.833014]  [<ffffffffa0763eb0>] chd_dec_ioctl+0x90/0x170 [crystalhd]
[545486.833014]  [<ffffffff811701fc>] do_vfs_ioctl+0x9c/0x330
[545486.833014]  [<ffffffff8115e930>] ? fget_light+0x40/0x140
[545486.833014]  [<ffffffff8108d8bd>] ? trace_hardirqs_on_caller+0x11d/0x1b0
[545486.833014]  [<ffffffff811704df>] sys_ioctl+0x4f/0x80
[545486.833014]  [<ffffffff8149ad6b>] system_call_fastpath+0x16/0x1b
[545486.833014] Code: f3 48 85 f6 75 12 48 83 c4 08 b8 01 00 00 00 5b c9 c3 66 0f 1f 44 00 00 48 85 ff 74 e9 48 8b 87 80 00 00 00 8b 76 10 48 8b 7f 08 <ff> 90 c8 02 00 00 89 43 14 48 83 c4 08 31 c0 5b c9 c3 0f 1f 00
[545486.833014] RIP  [<ffffffffa0765b0b>] bc_cproc_reg_rd+0x3b/0x50 [crystalhd]
[545486.833014]  RSP <ffff8800171f1e68>
[545486.833014] CR2: 00000000000002c8
[545486.860403] ---[ end trace 32f093356a8be591 ]---

[545486.836574] BUG: unable to handle kernel NULL pointer dereference at 0000000000000084
[545486.836574] IP: [<ffffffff812355fe>] do_raw_spin_lock+0x1e/0x140
[545486.836574] PGD 4508067 PUD fb7c067 PMD 0
[545486.836574] Oops: 0000 [#2] PREEMPT SMP
[545486.836574] CPU 1
[545486.836574] Modules linked in: crystalhd(O) udf crc_itu_t sr_mod cdrom nfs fscache uinput parport_pc ppdev lp parport bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_performance cpufreq_ondemand freq_table fuse dm_mod ext3 jbd pciehp arc4 ath5k ath mac80211 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_usb_audio cfg80211 snd_pcm_oss snd_mixer_oss snd_hwdep snd_usbmidi_lib snd_pcm thinkpad_acpi snd_seq_dummy snd_seq_oss rfkill snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq gspca_zc3xx pcmcia gspca_main snd_timer tpm_tis snd_seq_device videodev psmouse tpm usb_storage yenta_socket snd pcmcia_rsrc tpm_bios i2c_i801 nvram v4l2_compat_ioctl32 pcmcia_core soundcore snd_page_alloc rtc_cmos wmi pcspkr serio_raw processor battery ac evdev nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit xt_tcpudp iptable_filter ip_ta
bles x_tables ext4 mbcache jbd2 crc16 usbhid hid sg sd_mod crc_t10dif ata_generic uhci_hcd xhci_hcd ahci libahci ata_piix libata thermal ehci_hcd atkbd usbcore e1000e usb_common [last unloaded: crystalhd]
[545486.836574]
[545486.836574] Pid: 27553, comm: matroskademux1: Tainted: G      D W  O 3.2.37-dirty #8 LENOVO 7735Y1T/7735Y1T
[545486.836574] RIP: 0010:[<ffffffff812355fe>]  [<ffffffff812355fe>] do_raw_spin_lock+0x1e/0x140
[545486.836574] RSP: 0018:ffff8800045c9dc8  EFLAGS: 00010082
[545486.836574] RAX: ffff880011f65e50 RBX: 0000000000000080 RCX: 0000000000000000
[545486.836574] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000080
[545486.836574] RBP: ffff8800045c9de8 R08: 0000000000000000 R09: 0000000000000001
[545486.836574] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000282
[545486.836574] R13: ffff8800045c9e28 R14: 0000000000000000 R15: ffffffffa07662a0
[545486.836574] FS:  00007fd179530700(0000) GS:ffff88007f500000(0000) knlGS:0000000000000000
[545486.836574] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[545486.836574] CR2: 0000000000000084 CR3: 0000000017098000 CR4: 00000000000006e0
[545486.836574] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[545486.836574] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[545486.836574] Process matroskademux1: (pid: 27553, threadinfo ffff8800045c8000, task ffff880011f65e50)
[545486.836574] Stack:
[545486.836574]  0000000000000080 0000000000000282 ffff8800045c9e28 0000000000000000
[545486.836574]  ffff8800045c9e18 ffffffff81492ece ffffffffa0766374 0000000000000000
[545486.836574]  ffff880011fcbc00 ffff88000ddd6ec0 ffff8800045c9e78 ffffffffa0766374
[545486.836574] Call Trace:
[545486.836574]  [<ffffffff81492ece>] _raw_spin_lock_irqsave+0x4e/0x60
[545486.836574]  [<ffffffffa0766374>] ? bc_cproc_get_stats+0xd4/0x2b0 [crystalhd]
[545486.836574]  [<ffffffffa0766374>] bc_cproc_get_stats+0xd4/0x2b0 [crystalhd]
[545486.836574]  [<ffffffffa0763b15>] ? chd_dec_proc_user_data+0x65/0x270 [crystalhd]
[545486.836574]  [<ffffffffa0763da1>] chd_dec_api_cmd+0x81/0x100 [crystalhd]
[545486.836574]  [<ffffffffa0763eb0>] chd_dec_ioctl+0x90/0x170 [crystalhd]
[545486.836574]  [<ffffffff811701fc>] do_vfs_ioctl+0x9c/0x330
[545486.836574]  [<ffffffff8115e930>] ? fget_light+0x40/0x140
[545486.836574]  [<ffffffff8108d7c0>] ? trace_hardirqs_on_caller+0x20/0x1b0
[545486.836574]  [<ffffffff811704df>] sys_ioctl+0x4f/0x80
[545486.836574]  [<ffffffff8149ad6b>] system_call_fastpath+0x16/0x1b
[545486.836574] Code: eb 8b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 1c 24 4c 89 64 24 08 4c 89 6c 24 10 4c 89 74 24 18 48 89 fb <81> 7f 04 ad 4e ad de 0f 85 d2 00 00 00 65 48 8b 04 25 00 b6 00
[545486.836574] RIP  [<ffffffff812355fe>] do_raw_spin_lock+0x1e/0x140
[545486.836574]  RSP <ffff8800045c9dc8>
[545486.836574] CR2: 0000000000000084
[545486.836574] ---[ end trace 32f093356a8be592 ]---
[545486.860850] note: matroskademux1:[27553] exited with preempt_count 1

The patch will prevent accessing nonexistant driver instances but gstreamer will fail, but totem-gstreamer OK with it:

Feb  1 02:14:11 tom3 kernel: [  713.297215] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 02:14:12 tom3 kernel: [  713.552294] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 02:14:12 tom3 kernel: [  713.756852] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 02:14:12 tom3 kernel: [  713.757000] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 02:14:12 tom3 kernel: [  713.757086] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 02:14:12 tom3 kernel: [  713.758074] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 02:14:12 tom3 kernel: [  714.011311] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 02:14:12 tom3 kernel: [  714.092062] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.094653] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.096877] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.099108] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.101308] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.103516] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.105788] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.108209] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.110543] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.112902] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.115448] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.117792] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.120130] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.122453] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.124742] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.126979] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.129194] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.131377] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.133582] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.135812] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.138164] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.140509] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.142820] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.145174] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.147475] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.149903] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.152618] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.154957] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.157631] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.159962] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.162588] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.164878] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.167105] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.169320] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.171507] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.173748] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.175952] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.178202] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.180469] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.182766] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.186970] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.189621] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.192253] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.194577] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.195362] crystalhd_hw_setup_dma_rings: Invalid Arguments
Feb  1 02:14:12 tom3 kernel: [  714.197048] crystalhd 0000:03:00.0: bc_cproc_flush_cap_buffs: Invalid Arg
Feb  1 02:14:12 tom3 kernel: [  714.202175] crystalhd 0000:03:00.0: Closing user[0] handle via ioctl with mode 1c200
Feb  1 02:14:12 tom3 kernel: [  714.202181] crystalhd_hw_stop_capture: Invalid Arguments
Feb  1 02:14:12 tom3 kernel: [  714.202184] crystalhd_hw_free_dma_rings: Invalid Arguments
Feb  1 02:14:12 tom3 kernel: [  714.202267] crystalhd_hw_close: Invalid Arguments

schorpp@tom3:~$ transmageddon
Traceback (most recent call last):
   File "transmageddon.py", line 676, in on_presetchoice_changed
     self.devicename= self.presetchoices[presetchoice]
KeyError: 'Keine Voreinstellungen'
Running DIL (3.22.0) Version
DtsDeviceOpen: Opening HW in mode 0
DtsDevRegisterRead: Ioctl failed: 1
DtsDevRegisterWr: Ioctl failed: 1
DtsDevRegisterWr: Ioctl failed: 1
Clock set to 180
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsDevRegisterRead: Ioctl failed: 1
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsNotifyMode: Ioctl failed: 1
Notify Operating Mode Failed
DtsAllocIoctlData Error
Unable to detach from Dil shared memory ...
DtsDelDilShMem:Unable get shmid ...
Stream with high frequencies VQ coding
/usr/bin/transmageddon: Zeile 3:  6499 Speicherzugriffsfehler  python transmageddon.py
schorpp@tom3:~$

This is a quick&dirty hack emergency critical bug fix only! May break other apps than totem, ffmpeg, mplayer, be warned!

--------------------------

Patch attached.

crystalhd git.linuxtv.org kernel driver: FIX MORE null pointer BUGs triggered by multithreaded or faulty apps

Signed-off-by: Thomas Schorpp <thomas.schorpp@gmail.com>

y
tom



--------------040908040902070104050206
Content-Type: text/x-diff;
 name="crystalhd-nullpointer-bugfix.schorpp.02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd-nullpointer-bugfix.schorpp.02.patch"

diff --git a/driver/linux/crystalhd_cmds.c b/driver/linux/crystalhd_cmds.c
index cecd710..b62811b 100644
--- a/driver/linux/crystalhd_cmds.c
+++ b/driver/linux/crystalhd_cmds.c
@@ -154,7 +154,7 @@ static BC_STATUS bc_cproc_get_hwtype(struct crystalhd_cmd *ctx, crystalhd_ioctl_
 static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadDevRegister(ctx->adp,
 					idata->udata.u.regAcc.Offset);
@@ -164,7 +164,7 @@ static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteDevRegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -176,7 +176,7 @@ static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadFPGARegister(ctx->adp,
@@ -187,7 +187,7 @@ static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_wr(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteFPGARegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -201,7 +201,7 @@ static BC_STATUS bc_cproc_mem_rd(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -220,7 +220,7 @@ static BC_STATUS bc_cproc_mem_wr(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -307,7 +307,7 @@ static BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 
 	dev_dbg(chddev(), "Downloading FW\n");
 
-	if (!ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
 		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -350,7 +350,7 @@ static BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx, crystalhd_ioctl_d
 	BC_STATUS sts;
 	uint32_t *cmd;
 
-	if (!(ctx->state & BC_LINK_INIT)) {
+	if ( !ctx || !idata || !(ctx->state & BC_LINK_INIT) || !ctx->hw_ctx) {
 		dev_dbg(dev, "Link invalid state do fw cmd %x \n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
@@ -432,7 +432,7 @@ static BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	wait_queue_head_t event;
 	int rc = 0;
 
-	if (!ctx || !idata || !dio) {
+	if (!ctx || !ctx->hw_ctx || !idata || !dio) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -573,7 +573,7 @@ static BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	struct crystalhd_dio_req *dio_hnd = NULL;
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -631,7 +631,7 @@ static BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 	BC_STATUS sts = BC_STS_SUCCESS;
 	BC_DEC_OUT_BUFF *frame;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -673,6 +673,10 @@ static BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_start_capture(struct crystalhd_cmd *ctx,
 					crystalhd_ioctl_data *idata)
 {
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		return BC_STS_INV_ARG;
+	}
+
 	ctx->state |= BC_LINK_CAP_EN;
 
 	if( idata->udata.u.RxCap.PauseThsh )
@@ -705,7 +709,7 @@ static BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 	struct device *dev = chddev();
 	struct crystalhd_rx_dma_pkt *rpkt;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -745,7 +749,7 @@ static BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 	bool readTxOnly = false;
 	unsigned long irqflags;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -948,9 +952,9 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 	BC_STATUS sts = BC_STS_SUCCESS;
 	struct crystalhd_rx_dma_pkt *rpkt = NULL;
 
-	if (!ctx || !idata) {
-		dev_err(dev, "Invalid Parameters\n");
-		return BC_STS_ERROR;
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->state & BC_LINK_SUSPEND)

--------------040908040902070104050206--
