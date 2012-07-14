Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62992 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2GNXMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 19:12:03 -0400
Received: by obbuo13 with SMTP id uo13so7076234obb.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2012 16:12:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 19:12:02 -0400
Message-ID: <CALzAhNXPhRv18GPJ5OzZOxCY7o=PsfT4g_tkXWBTapyDvsZXtw@mail.gmail.com>
Subject: Tips is OOPSing with basic v4l2 controls - Major breakage
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tip is oopsing the moment the V4L2 API is exercised, Eg. v4l2-ctl or tvtime.

Its unusable at this point.

Verified with two different drivers (cx23885 and SAA7164), same oops.

[  120.255980] BUG: unable to handle kernel NULL pointer dereference at 00000016
[  120.255992] IP: [<c074efd6>] v4l2_queryctrl+0x21/0x105
[  120.256000] *pdpt = 0000000010de8001 *pde = 0000000000000000
[  120.256005] Oops: 0000 [#1] SMP
[  120.256009] Modules linked in: mt2131 s5h1409 tda8290 tuner cx25840
cx23885 videobuf_dma_sg altera_stapl cx2341x tda18271 videobuf_dvb
videobuf_core v4l2_common altera_ci btcx_risc tveeprom fuse nouveau
ttm drm_kms_helper drm i2c_algo_bit video nfsd lockd nfs_acl
auth_rpcgss exportfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq mperf
uinput pl2303 snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd coretemp r8169
iTCO_wdt soundcore i2c_i801 crc32c_intel iTCO_vendor_support
snd_page_alloc usbserial i2c_core mii microcode serio_raw pcspkr
mxm_wmi floppy wmi [last unloaded: scsi_wait_scan]
[  120.256077]
[  120.256080] Pid: 2659, comm: tvtime Not tainted 3.4.0-rc7+ #2
Gigabyte Technology Co., Ltd. P67A-UD4-B3/P67A-UD4-B3
[  120.256088] EIP: 0060:[<c074efd6>] EFLAGS: 00010202 CPU: 0
[  120.256092] EIP is at v4l2_queryctrl+0x21/0x105
[  120.256095] EAX: ffffffea EBX: 00000002 ECX: d1565c00 EDX: 00980900
[  120.256099] ESI: d17d7e58 EDI: e0f8191c EBP: d17d7db8 ESP: d17d7da4
[  120.256103]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  120.256106] CR0: 80050033 CR2: 00000016 CR3: 10de6000 CR4: 000407f0
[  120.256110] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  120.256114] DR6: ffff0ff0 DR7: 00000400
[  120.256117] Process tvtime (pid: 2659, ti=d17d6000 task=d27dcb60
task.ti=d17d6000)
[  120.256121] Stack:
[  120.256123]  00000020 d04d11cc d04e0300 d0da3c00 e0f8191c d17d7dd0
c074b4a3 d17d7e58
[  120.256134]  c0aaaba0 d1565c00 00000000 d17d7e2c c074b989 d17d7e58
d04d11cc cfee0840
[  120.256344]  00000000 d0da3c00 d04e0300 e0f8191c d17d7e58 00459196
00000000 c0aaaba0[  120.256353] Call Trace:
[  120.256357]  [<c074b4a3>] v4l_queryctrl+0x40/0x5f
[  120.256361]  [<c074b989>] __video_do_ioctl+0x199/0x29c
[  120.256368]  [<c0445624>] ? prepare_signal+0x72/0x169
[  120.256373]  [<c0604848>] ? _copy_from_user+0x3e/0x52
[  120.256377]  [<c074bcdd>] video_usercopy+0x251/0x30b
[  120.256381]  [<c074b7f0>] ? v4l2_is_known_ioctl+0x22/0x22
[  120.256386]  [<c0445624>] ? prepare_signal+0x72/0x169
[  120.256392]  [<c04de360>] ? handle_pte_fault+0x32f/0x8d0
[  120.256397]  [<c0459184>] ? need_resched+0x14/0x1e
[  120.256401]  [<c074bdae>] video_ioctl2+0x17/0x19
[  120.256405]  [<c074b7f0>] ? v4l2_is_known_ioctl+0x22/0x22
[  120.256411]  [<c074805d>] v4l2_ioctl+0xc1/0xdd
[  120.256415]  [<c0445624>] ? prepare_signal+0x72/0x169
[  120.256420]  [<c0747f9c>] ? v4l2_open+0xf2/0xf2
[  120.256425]  [<c050bbb4>] do_vfs_ioctl+0x491/0x4c7
[  120.256431]  [<c08470ee>] ? do_page_fault+0x2ce/0x32b
[  120.256436]  [<c045ec09>] ? sched_clock_cpu+0x42/0x14d
[  120.256444]  [<c0476284>] ? tick_program_event+0x29/0x2d
[  120.256996]  [<c04e1c49>] ? do_munmap+0x201/0x218
[  120.257438]  [<c0445624>] ? prepare_signal+0x72/0x169
[  120.257892]  [<c050bc32>] sys_ioctl+0x48/0x6a
[  120.258351]  [<c0426c5d>] ? smp_apic_timer_interrupt+0x69/0x76
[  120.258819]  [<c0849c1f>] sysenter_do_call+0x12/0x28
[  120.259290]  [<c0445624>] ? prepare_signal+0x72/0x169

(gdb) list *(v4l2_queryctrl + 0x21)
0xc074efd6 is in v4l2_queryctrl (drivers/media/video/v4l2-ctrls.c:1917).
1912		struct v4l2_ctrl *ctrl;
1913	
1914		if (hdl == NULL)
1915			return -EINVAL;
1916	
1917		mutex_lock(hdl->lock);
1918	
1919		/* Try to find it */
1920		ref = find_ref(hdl, id);
1921	
(gdb)

FYI

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
