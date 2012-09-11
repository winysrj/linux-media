Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54228 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2IKBOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 21:14:25 -0400
Received: by vcbfy27 with SMTP id fy27so2283199vcb.19
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2012 18:14:24 -0700 (PDT)
Message-ID: <504E906D.3050209@rosi-kessel.org>
Date: Mon, 10 Sep 2012 21:14:21 -0400
From: Adam Rosi-Kessel <adam@rosi-kessel.org>
MIME-Version: 1.0
To: volokh@telros.ru
CC: linux-media@vger.kernel.org, volokh84@gmail.com
Subject: Re: go7007 question
References: <5044F8DC.20509@rosi-kessel.org> <20120906191014.GA2540@VPir.Home> <20120907141831.GA12333@VPir.telros.ru> <20120909022331.GA28838@whitehail.bostoncoop.net> <20120909122155.GA29057@whitehail.bostoncoop.net> <20120910103725.GB2507@VPir.telros.ru>
In-Reply-To: <20120910103725.GB2507@VPir.telros.ru>
Content-Type: multipart/mixed;
 boundary="------------090803090101060905020507"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090803090101060905020507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/2012 6:37 AM, volokh@telros.ru wrote:
> I`m not seeing wis-sa7115 module, (it`s main  module for video device)
OK, I recompiled with that built in. I had left it out because I had 
trouble compiling before, but now it went through fine. Seems to help.

After recompiling, I have some progress--I can run gorecord and get 
audio, but there is no video signal in the resultant AVI.
> Some error in URB,
> did u machine have any ATI chipset?
Yes:

01:00.0 VGA compatible controller: ATI Technologies Inc RV630 [Radeon HD 
2600XT] (prog-if 00 [VGA controller])
01:00.1 Audio device: ATI Technologies Inc RV630/M76 audio device 
[Radeon HD 2600 Series]
> Can u send me:
> ls /dev/video*
> ls /dev/audio*
> ls /dev/tun*
# ls -l /dev/tun* /dev/aud* /dev/vid* /dev/dsp*
ls: cannot access /dev/tun*: No such file or directory
crw-rw----+ 1 root audio 14,  4 Sep 10 16:57 /dev/audio
crw-rw----+ 1 root audio 14, 36 Sep 10 21:01 /dev/audio2
crw-rw----+ 1 root audio 14,  3 Sep 10 16:57 /dev/dsp
crw-rw----+ 1 root audio 14, 35 Sep 10 21:01 /dev/dsp2
crw-rw----+ 1 root video 81,  0 Sep 10 21:10 /dev/video0

> tail -n 500 /var/log/messages (after calling go_record)
Attached.

--------------090803090101060905020507
Content-Type: text/plain; charset=windows-1252;
 name="messages.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages.txt"

Sep 10 21:05:40 storage kernel: [  474.278489]  [<c113b510>] ? idr_callback+0x80/0x80
Sep 10 21:05:40 storage kernel: [  474.278492]  [<c11393c5>] ? send_to_group+0xe5/0x140
Sep 10 21:05:40 storage kernel: [  474.278497]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:05:40 storage kernel: [  474.278501]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:05:40 storage kernel: [  474.278505]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:05:40 storage kernel: [  474.278509]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:05:40 storage kernel: [  474.278513]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:05:40 storage kernel: [  474.278518]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:05:40 storage kernel: [  474.278522]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:05:40 storage kernel: [  474.278524]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:05:40 storage kernel: [  474.278528]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:05:40 storage kernel: [  474.278530] ---[ end trace 7ad74e28071d6ef7 ]---
Sep 10 21:05:45 storage kernel: [  479.673046] ------------[ cut here ]------------
Sep 10 21:05:45 storage kernel: [  479.673058] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:05:45 storage kernel: [  479.673060] Hardware name: Inspiron 530
Sep 10 21:05:45 storage kernel: [  479.673062] Device: usb
Sep 10 21:05:45 storage kernel: [  479.673062] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:05:45 storage kernel: [  479.673064] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:05:45 storage kernel: [  479.673092] Pid: 11613, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:05:45 storage kernel: [  479.673094] Call Trace:
Sep 10 21:05:45 storage kernel: [  479.673100]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:05:45 storage kernel: [  479.673103]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.673106]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.673109]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:05:45 storage kernel: [  479.673112]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.673115]  [<c10432a9>] ? del_timer_sync+0x29/0x50
Sep 10 21:05:45 storage kernel: [  479.673120]  [<c159bb99>] ? schedule_timeout+0xf9/0x1b0
Sep 10 21:05:45 storage kernel: [  479.673124]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:05:45 storage kernel: [  479.673127]  [<c1042d40>] ? lock_timer_base+0x50/0x50
Sep 10 21:05:45 storage kernel: [  479.673132]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:05:45 storage kernel: [  479.673135]  [<f9e626cc>] go7007_usb_interface_reset+0x4c/0x130 [go7007_usb]
Sep 10 21:05:45 storage kernel: [  479.673139]  [<f9e4dd90>] go7007_load_encoder+0xa0/0x180 [go7007]
Sep 10 21:05:45 storage kernel: [  479.673142]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:05:45 storage kernel: [  479.673146]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:05:45 storage kernel: [  479.673149]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:05:45 storage kernel: [  479.673153]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:05:45 storage kernel: [  479.673158]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673163]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673166]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:05:45 storage kernel: [  479.673170]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:05:45 storage kernel: [  479.673175]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:05:45 storage kernel: [  479.673179]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673184]  [<c109d7bf>] ? irq_to_desc+0xf/0x20
Sep 10 21:05:45 storage kernel: [  479.673213]  [<c103be44>] ? irq_exit+0x54/0xc0
Sep 10 21:05:45 storage kernel: [  479.673216]  [<c1003ca6>] ? do_IRQ+0x46/0xb0
Sep 10 21:05:45 storage kernel: [  479.673220]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:05:45 storage kernel: [  479.673223]  [<c15a4a29>] ? common_interrupt+0x29/0x30
Sep 10 21:05:45 storage kernel: [  479.673228]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673233]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673237]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673241]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:05:45 storage kernel: [  479.673245]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:05:45 storage kernel: [  479.673250]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:05:45 storage kernel: [  479.673253]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:05:45 storage kernel: [  479.673256]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:05:45 storage kernel: [  479.673259]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:05:45 storage kernel: [  479.673261] ---[ end trace 7ad74e28071d6ef8 ]---
Sep 10 21:05:45 storage kernel: [  479.685226] ------------[ cut here ]------------
Sep 10 21:05:45 storage kernel: [  479.685237] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:05:45 storage kernel: [  479.685239] Hardware name: Inspiron 530
Sep 10 21:05:45 storage kernel: [  479.685241] Device: usb
Sep 10 21:05:45 storage kernel: [  479.685241] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:05:45 storage kernel: [  479.685243] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:05:45 storage kernel: [  479.685271] Pid: 11613, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:05:45 storage kernel: [  479.685273] Call Trace:
Sep 10 21:05:45 storage kernel: [  479.685278]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:05:45 storage kernel: [  479.685282]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.685284]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.685287]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:05:45 storage kernel: [  479.685290]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:05:45 storage kernel: [  479.685295]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:05:45 storage kernel: [  479.685299]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:05:45 storage kernel: [  479.685303]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:05:45 storage kernel: [  479.685306]  [<f9e4ddb9>] go7007_load_encoder+0xc9/0x180 [go7007]
Sep 10 21:05:45 storage kernel: [  479.685309]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:05:45 storage kernel: [  479.685313]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:05:45 storage kernel: [  479.685316]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:05:45 storage kernel: [  479.685320]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:05:45 storage kernel: [  479.685325]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685330]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685333]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:05:45 storage kernel: [  479.685337]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:05:45 storage kernel: [  479.685342]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:05:45 storage kernel: [  479.685346]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685351]  [<c109d7bf>] ? irq_to_desc+0xf/0x20
Sep 10 21:05:45 storage kernel: [  479.685354]  [<c103be44>] ? irq_exit+0x54/0xc0
Sep 10 21:05:45 storage kernel: [  479.685358]  [<c1003ca6>] ? do_IRQ+0x46/0xb0
Sep 10 21:05:45 storage kernel: [  479.685362]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:05:45 storage kernel: [  479.685366]  [<c15a4a29>] ? common_interrupt+0x29/0x30
Sep 10 21:05:45 storage kernel: [  479.685370]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685375]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685379]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685383]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:05:45 storage kernel: [  479.685387]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:05:45 storage kernel: [  479.685392]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:05:45 storage kernel: [  479.685395]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:05:45 storage kernel: [  479.685398]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:05:45 storage kernel: [  479.685401]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:05:45 storage kernel: [  479.685403] ---[ end trace 7ad74e28071d6ef9 ]---
Sep 10 21:06:01 storage logger: Starting CrashPlan
Sep 10 21:06:01 storage logger: Starting VNC server
Sep 10 21:06:02 storage logger: Starting fuppes
Sep 10 21:06:02 storage kernel: [  496.846062] ------------[ cut here ]------------
Sep 10 21:06:02 storage kernel: [  496.846072] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x9b/0xd0()
Sep 10 21:06:02 storage kernel: [  496.846074] Hardware name: Inspiron 530
Sep 10 21:06:02 storage kernel: [  496.846075] empty IPI mask
Sep 10 21:06:02 storage kernel: [  496.846077] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:06:02 storage kernel: [  496.846100] Pid: 11984, comm: java Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:06:02 storage kernel: [  496.846102] Call Trace:
Sep 10 21:06:02 storage kernel: [  496.846106]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:06:02 storage kernel: [  496.846109]  [<c102232b>] ? default_send_IPI_mask_logical+0x9b/0xd0
Sep 10 21:06:02 storage kernel: [  496.846111]  [<c102232b>] ? default_send_IPI_mask_logical+0x9b/0xd0
Sep 10 21:06:02 storage kernel: [  496.846114]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:06:02 storage kernel: [  496.846116]  [<c102232b>] default_send_IPI_mask_logical+0x9b/0xd0
Sep 10 21:06:02 storage kernel: [  496.846119]  [<c1020692>] native_send_call_func_ipi+0x42/0x60
Sep 10 21:06:02 storage kernel: [  496.846123]  [<c1082312>] smp_call_function_many+0x172/0x200
Sep 10 21:06:02 storage kernel: [  496.846125]  [<c102f750>] ? flush_tlb_mm_range+0x1a0/0x1a0
Sep 10 21:06:02 storage kernel: [  496.846128]  [<c102f436>] native_flush_tlb_others+0x26/0x30
Sep 10 21:06:02 storage kernel: [  496.846130]  [<c102f57f>] flush_tlb_page+0x4f/0x80
Sep 10 21:06:02 storage kernel: [  496.846134]  [<c10f4920>] ptep_clear_flush+0x20/0x30
Sep 10 21:06:02 storage kernel: [  496.846137]  [<c10e8f9e>] do_wp_page+0x24e/0x6f0
Sep 10 21:06:02 storage kernel: [  496.846140]  [<c10d00d8>] ? __alloc_pages_nodemask+0x218/0x6e0
Sep 10 21:06:02 storage kernel: [  496.846142]  [<c10e9c5a>] handle_pte_fault+0x33a/0x8f0
Sep 10 21:06:02 storage kernel: [  496.846145]  [<c10ea2f6>] handle_mm_fault+0xe6/0x1a0
Sep 10 21:06:02 storage kernel: [  496.846148]  [<c15a0c77>] do_page_fault+0xf7/0x3f0
Sep 10 21:06:02 storage kernel: [  496.846151]  [<c10820a4>] ? generic_smp_call_function_interrupt+0x84/0x180
Sep 10 21:06:02 storage kernel: [  496.846154]  [<c15a0b80>] ? spurious_fault+0x110/0x110
Sep 10 21:06:02 storage kernel: [  496.846156]  [<c159e4a6>] error_code+0x5a/0x60
Sep 10 21:06:02 storage kernel: [  496.846159]  [<c15a0b80>] ? spurious_fault+0x110/0x110
Sep 10 21:06:02 storage kernel: [  496.846160] ---[ end trace 7ad74e28071d6efa ]---
Sep 10 21:07:08 storage kernel: [  562.417253] ------------[ cut here ]------------
Sep 10 21:07:08 storage kernel: [  562.417264] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:08 storage kernel: [  562.417266] Hardware name: Inspiron 530
Sep 10 21:07:08 storage kernel: [  562.417269] Device: usb
Sep 10 21:07:08 storage kernel: [  562.417269] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:08 storage kernel: [  562.417271] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:08 storage kernel: [  562.417299] Pid: 14107, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:08 storage kernel: [  562.417300] Call Trace:
Sep 10 21:07:08 storage kernel: [  562.417305]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:08 storage kernel: [  562.417309]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:08 storage kernel: [  562.417312]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:08 storage kernel: [  562.417314]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:08 storage kernel: [  562.417317]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:08 storage kernel: [  562.417322]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:08 storage kernel: [  562.417327]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:08 storage kernel: [  562.417330]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:07:08 storage kernel: [  562.417334]  [<f9e4dc4d>] go7007_start_encoder+0x7d/0x120 [go7007]
Sep 10 21:07:08 storage kernel: [  562.417339]  [<c159c0d4>] ? mutex_lock+0x14/0x40
Sep 10 21:07:08 storage kernel: [  562.417342]  [<f9e4cc2c>] vidioc_streamon+0xdc/0xf0 [go7007]
Sep 10 21:07:08 storage kernel: [  562.417347]  [<f9e21b75>] v4l_streamon+0x15/0x20 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417352]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417357]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:08 storage kernel: [  562.417362]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417366]  [<c1139edd>] ? fsnotify_add_notify_event+0x13d/0x190
Sep 10 21:07:08 storage kernel: [  562.417370]  [<c113b631>] ? inotify_handle_event+0x51/0xc0
Sep 10 21:07:08 storage kernel: [  562.417373]  [<c113b510>] ? idr_callback+0x80/0x80
Sep 10 21:07:08 storage kernel: [  562.417376]  [<c11393c5>] ? send_to_group+0xe5/0x140
Sep 10 21:07:08 storage kernel: [  562.417385]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417389]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417392]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417396]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:08 storage kernel: [  562.417399]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:08 storage kernel: [  562.417403]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:08 storage kernel: [  562.417405]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:08 storage kernel: [  562.417408]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:08 storage kernel: [  562.417411]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:08 storage kernel: [  562.417412] ---[ end trace 7ad74e28071d6efb ]---
Sep 10 21:07:13 storage kernel: [  567.785027] ------------[ cut here ]------------
Sep 10 21:07:13 storage kernel: [  567.785038] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:13 storage kernel: [  567.785040] Hardware name: Inspiron 530
Sep 10 21:07:13 storage kernel: [  567.785042] Device: usb
Sep 10 21:07:13 storage kernel: [  567.785042] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:13 storage kernel: [  567.785045] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:13 storage kernel: [  567.785072] Pid: 14107, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:13 storage kernel: [  567.785074] Call Trace:
Sep 10 21:07:13 storage kernel: [  567.785080]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:13 storage kernel: [  567.785083]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.785086]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.785089]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:13 storage kernel: [  567.785092]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.785095]  [<c10432a9>] ? del_timer_sync+0x29/0x50
Sep 10 21:07:13 storage kernel: [  567.785100]  [<c159bb99>] ? schedule_timeout+0xf9/0x1b0
Sep 10 21:07:13 storage kernel: [  567.785104]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:13 storage kernel: [  567.785107]  [<c1042d40>] ? lock_timer_base+0x50/0x50
Sep 10 21:07:13 storage kernel: [  567.785112]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:13 storage kernel: [  567.785115]  [<f9e626cc>] go7007_usb_interface_reset+0x4c/0x130 [go7007_usb]
Sep 10 21:07:13 storage kernel: [  567.785119]  [<f9e4dd90>] go7007_load_encoder+0xa0/0x180 [go7007]
Sep 10 21:07:13 storage kernel: [  567.785122]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:07:13 storage kernel: [  567.785126]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:07:13 storage kernel: [  567.785129]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:07:13 storage kernel: [  567.785132]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:07:13 storage kernel: [  567.785137]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785142]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785146]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:07:13 storage kernel: [  567.785150]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:07:13 storage kernel: [  567.785154]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:13 storage kernel: [  567.785159]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785162]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:07:13 storage kernel: [  567.785166]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:07:13 storage kernel: [  567.785169]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:07:13 storage kernel: [  567.785173]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:07:13 storage kernel: [  567.785177]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:07:13 storage kernel: [  567.785181]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785186]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785190]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785194]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:13 storage kernel: [  567.785198]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:13 storage kernel: [  567.785202]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:13 storage kernel: [  567.785206]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:13 storage kernel: [  567.785209]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:13 storage kernel: [  567.785212]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:13 storage kernel: [  567.785214] ---[ end trace 7ad74e28071d6efc ]---
Sep 10 21:07:13 storage kernel: [  567.796737] ------------[ cut here ]------------
Sep 10 21:07:13 storage kernel: [  567.796748] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:13 storage kernel: [  567.796750] Hardware name: Inspiron 530
Sep 10 21:07:13 storage kernel: [  567.796752] Device: usb
Sep 10 21:07:13 storage kernel: [  567.796752] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:13 storage kernel: [  567.796754] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:13 storage kernel: [  567.796781] Pid: 14107, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:13 storage kernel: [  567.796783] Call Trace:
Sep 10 21:07:13 storage kernel: [  567.796788]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:13 storage kernel: [  567.796791]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.796794]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.796797]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:13 storage kernel: [  567.796800]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:13 storage kernel: [  567.796804]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:13 storage kernel: [  567.796809]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:13 storage kernel: [  567.796812]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:07:13 storage kernel: [  567.796816]  [<f9e4ddb9>] go7007_load_encoder+0xc9/0x180 [go7007]
Sep 10 21:07:13 storage kernel: [  567.796819]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:07:13 storage kernel: [  567.796823]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:07:13 storage kernel: [  567.796826]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:07:13 storage kernel: [  567.796830]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:07:13 storage kernel: [  567.796835]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796839]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796843]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:07:13 storage kernel: [  567.796847]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:07:13 storage kernel: [  567.796851]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:13 storage kernel: [  567.796856]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796859]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:07:13 storage kernel: [  567.796863]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:07:13 storage kernel: [  567.796867]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:07:13 storage kernel: [  567.796870]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:07:13 storage kernel: [  567.796874]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:07:13 storage kernel: [  567.796878]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796883]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796887]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796891]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:13 storage kernel: [  567.796895]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:13 storage kernel: [  567.796899]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:13 storage kernel: [  567.796903]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:13 storage kernel: [  567.796905]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:13 storage kernel: [  567.796909]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:13 storage kernel: [  567.796911] ---[ end trace 7ad74e28071d6efd ]---
Sep 10 21:07:29 storage kernel: [  583.170292] ------------[ cut here ]------------
Sep 10 21:07:29 storage kernel: [  583.170302] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:29 storage kernel: [  583.170304] Hardware name: Inspiron 530
Sep 10 21:07:29 storage kernel: [  583.170306] Device: usb
Sep 10 21:07:29 storage kernel: [  583.170306] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:29 storage kernel: [  583.170308] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:29 storage kernel: [  583.170335] Pid: 14646, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:29 storage kernel: [  583.170337] Call Trace:
Sep 10 21:07:29 storage kernel: [  583.170342]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:29 storage kernel: [  583.170345]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:29 storage kernel: [  583.170348]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:29 storage kernel: [  583.170351]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:29 storage kernel: [  583.170354]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:29 storage kernel: [  583.170359]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:29 storage kernel: [  583.170363]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:29 storage kernel: [  583.170366]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:07:29 storage kernel: [  583.170370]  [<f9e4dc4d>] go7007_start_encoder+0x7d/0x120 [go7007]
Sep 10 21:07:29 storage kernel: [  583.170375]  [<c159c0d4>] ? mutex_lock+0x14/0x40
Sep 10 21:07:29 storage kernel: [  583.170378]  [<f9e4cc2c>] vidioc_streamon+0xdc/0xf0 [go7007]
Sep 10 21:07:29 storage kernel: [  583.170383]  [<f9e21b75>] v4l_streamon+0x15/0x20 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170388]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170392]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:29 storage kernel: [  583.170397]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170401]  [<c11128b9>] ? path_openat+0x99/0x3a0
Sep 10 21:07:29 storage kernel: [  583.170410]  [<f85b7ca6>] ? ext4_orphan_add+0x56/0x1c0 [ext4]
Sep 10 21:07:29 storage kernel: [  583.170414]  [<c11043a3>] ? do_sync_write+0x93/0xd0
Sep 10 21:07:29 storage kernel: [  583.170419]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170423]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170427]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170431]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:29 storage kernel: [  583.170434]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:29 storage kernel: [  583.170439]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:29 storage kernel: [  583.170442]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:29 storage kernel: [  583.170445]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:29 storage kernel: [  583.170449]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:29 storage kernel: [  583.170451] ---[ end trace 7ad74e28071d6efe ]---
Sep 10 21:07:34 storage kernel: [  588.543025] ------------[ cut here ]------------
Sep 10 21:07:34 storage kernel: [  588.543038] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:34 storage kernel: [  588.543040] Hardware name: Inspiron 530
Sep 10 21:07:34 storage kernel: [  588.543042] Device: usb
Sep 10 21:07:34 storage kernel: [  588.543042] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:34 storage kernel: [  588.543044] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:34 storage kernel: [  588.543074] Pid: 14646, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:34 storage kernel: [  588.543076] Call Trace:
Sep 10 21:07:34 storage kernel: [  588.543081]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:34 storage kernel: [  588.543085]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.543088]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.543091]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:34 storage kernel: [  588.543093]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.543097]  [<c10432a9>] ? del_timer_sync+0x29/0x50
Sep 10 21:07:34 storage kernel: [  588.543102]  [<c159bb99>] ? schedule_timeout+0xf9/0x1b0
Sep 10 21:07:34 storage kernel: [  588.543106]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:34 storage kernel: [  588.543109]  [<c1042d40>] ? lock_timer_base+0x50/0x50
Sep 10 21:07:34 storage kernel: [  588.543114]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:34 storage kernel: [  588.543118]  [<f9e626cc>] go7007_usb_interface_reset+0x4c/0x130 [go7007_usb]
Sep 10 21:07:34 storage kernel: [  588.543121]  [<f9e4dd90>] go7007_load_encoder+0xa0/0x180 [go7007]
Sep 10 21:07:34 storage kernel: [  588.543124]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:07:34 storage kernel: [  588.543128]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:07:34 storage kernel: [  588.543131]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:07:34 storage kernel: [  588.543135]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:07:34 storage kernel: [  588.543140]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543144]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543148]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:07:34 storage kernel: [  588.543152]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:07:34 storage kernel: [  588.543157]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:34 storage kernel: [  588.543161]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543164]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:07:34 storage kernel: [  588.543170]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:07:34 storage kernel: [  588.543173]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:07:34 storage kernel: [  588.543177]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:07:34 storage kernel: [  588.543181]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:07:34 storage kernel: [  588.543186]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543190]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543194]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543198]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:34 storage kernel: [  588.543202]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:34 storage kernel: [  588.543208]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:34 storage kernel: [  588.543211]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:34 storage kernel: [  588.543214]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:34 storage kernel: [  588.543217]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:34 storage kernel: [  588.543220] ---[ end trace 7ad74e28071d6eff ]---
Sep 10 21:07:34 storage kernel: [  588.564639] ------------[ cut here ]------------
Sep 10 21:07:34 storage kernel: [  588.564648] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:07:34 storage kernel: [  588.564650] Hardware name: Inspiron 530
Sep 10 21:07:34 storage kernel: [  588.564652] Device: usb
Sep 10 21:07:34 storage kernel: [  588.564652] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:07:34 storage kernel: [  588.564653] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:07:34 storage kernel: [  588.564677] Pid: 14646, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:07:34 storage kernel: [  588.564679] Call Trace:
Sep 10 21:07:34 storage kernel: [  588.564683]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:07:34 storage kernel: [  588.564686]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.564688]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.564690]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:07:34 storage kernel: [  588.564693]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:07:34 storage kernel: [  588.564696]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:07:34 storage kernel: [  588.564700]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:07:34 storage kernel: [  588.564703]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:07:34 storage kernel: [  588.564706]  [<f9e4ddb9>] go7007_load_encoder+0xc9/0x180 [go7007]
Sep 10 21:07:34 storage kernel: [  588.564708]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:07:34 storage kernel: [  588.564711]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:07:34 storage kernel: [  588.564714]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:07:34 storage kernel: [  588.564717]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:07:34 storage kernel: [  588.564721]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564724]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564727]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:07:34 storage kernel: [  588.564731]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:07:34 storage kernel: [  588.564734]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:07:34 storage kernel: [  588.564738]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564740]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:07:34 storage kernel: [  588.564743]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:07:34 storage kernel: [  588.564746]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:07:34 storage kernel: [  588.564749]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:07:34 storage kernel: [  588.564752]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:07:34 storage kernel: [  588.564756]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564759]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564763]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564766]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:07:34 storage kernel: [  588.564769]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:07:34 storage kernel: [  588.564774]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:07:34 storage kernel: [  588.564776]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:07:34 storage kernel: [  588.564779]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:07:34 storage kernel: [  588.564782]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:07:34 storage kernel: [  588.564784] ---[ end trace 7ad74e28071d6f00 ]---
Sep 10 21:10:22 storage kernel: [  756.828863] ------------[ cut here ]------------
Sep 10 21:10:22 storage kernel: [  756.828875] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:10:22 storage kernel: [  756.828877] Hardware name: Inspiron 530
Sep 10 21:10:22 storage kernel: [  756.828879] Device: usb
Sep 10 21:10:22 storage kernel: [  756.828879] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:10:22 storage kernel: [  756.828881] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:10:22 storage kernel: [  756.828909] Pid: 17894, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:10:22 storage kernel: [  756.828911] Call Trace:
Sep 10 21:10:22 storage kernel: [  756.828917]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:10:22 storage kernel: [  756.828920]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:22 storage kernel: [  756.828923]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:22 storage kernel: [  756.828926]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:10:22 storage kernel: [  756.828929]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:22 storage kernel: [  756.828933]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:10:22 storage kernel: [  756.828938]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:10:22 storage kernel: [  756.828941]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:10:22 storage kernel: [  756.828945]  [<f9e4dc4d>] go7007_start_encoder+0x7d/0x120 [go7007]
Sep 10 21:10:22 storage kernel: [  756.828950]  [<c159c0d4>] ? mutex_lock+0x14/0x40
Sep 10 21:10:22 storage kernel: [  756.828953]  [<f9e4cc2c>] vidioc_streamon+0xdc/0xf0 [go7007]
Sep 10 21:10:22 storage kernel: [  756.828958]  [<f9e21b75>] v4l_streamon+0x15/0x20 [videodev]
Sep 10 21:10:22 storage kernel: [  756.828963]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:10:22 storage kernel: [  756.828968]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:10:22 storage kernel: [  756.828972]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:10:22 storage kernel: [  756.828977]  [<c11128b9>] ? path_openat+0x99/0x3a0
Sep 10 21:10:22 storage kernel: [  756.828986]  [<f85b7ca6>] ? ext4_orphan_add+0x56/0x1c0 [ext4]
Sep 10 21:10:22 storage kernel: [  756.828990]  [<c11043a3>] ? do_sync_write+0x93/0xd0
Sep 10 21:10:22 storage kernel: [  756.828995]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:10:22 storage kernel: [  756.828999]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:10:22 storage kernel: [  756.829012]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:10:22 storage kernel: [  756.829017]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:10:22 storage kernel: [  756.829020]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:10:22 storage kernel: [  756.829025]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:10:22 storage kernel: [  756.829029]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:10:22 storage kernel: [  756.829032]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:10:22 storage kernel: [  756.829035]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:10:22 storage kernel: [  756.829037] ---[ end trace 7ad74e28071d6f01 ]---
Sep 10 21:10:28 storage kernel: [  762.212032] ------------[ cut here ]------------
Sep 10 21:10:28 storage kernel: [  762.212044] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:10:28 storage kernel: [  762.212046] Hardware name: Inspiron 530
Sep 10 21:10:28 storage kernel: [  762.212048] Device: usb
Sep 10 21:10:28 storage kernel: [  762.212048] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:10:28 storage kernel: [  762.212050] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:10:28 storage kernel: [  762.212078] Pid: 17894, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:10:28 storage kernel: [  762.212080] Call Trace:
Sep 10 21:10:28 storage kernel: [  762.212086]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:10:28 storage kernel: [  762.212089]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.212092]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.212095]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:10:28 storage kernel: [  762.212098]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.212101]  [<c10432a9>] ? del_timer_sync+0x29/0x50
Sep 10 21:10:28 storage kernel: [  762.212106]  [<c159bb99>] ? schedule_timeout+0xf9/0x1b0
Sep 10 21:10:28 storage kernel: [  762.212110]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:10:28 storage kernel: [  762.212113]  [<c1042d40>] ? lock_timer_base+0x50/0x50
Sep 10 21:10:28 storage kernel: [  762.212117]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:10:28 storage kernel: [  762.212121]  [<f9e626cc>] go7007_usb_interface_reset+0x4c/0x130 [go7007_usb]
Sep 10 21:10:28 storage kernel: [  762.212125]  [<f9e4dd90>] go7007_load_encoder+0xa0/0x180 [go7007]
Sep 10 21:10:28 storage kernel: [  762.212128]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:10:28 storage kernel: [  762.212131]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:10:28 storage kernel: [  762.212135]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:10:28 storage kernel: [  762.212138]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:10:28 storage kernel: [  762.212144]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212148]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212152]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:10:28 storage kernel: [  762.212156]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:10:28 storage kernel: [  762.212160]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:10:28 storage kernel: [  762.212165]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212168]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:10:28 storage kernel: [  762.212172]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:10:28 storage kernel: [  762.212176]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:10:28 storage kernel: [  762.212179]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:10:28 storage kernel: [  762.212183]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:10:28 storage kernel: [  762.212188]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212192]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212196]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212200]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:10:28 storage kernel: [  762.212204]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:10:28 storage kernel: [  762.212209]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:10:28 storage kernel: [  762.212212]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:10:28 storage kernel: [  762.212215]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:10:28 storage kernel: [  762.212218]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:10:28 storage kernel: [  762.212220] ---[ end trace 7ad74e28071d6f02 ]---
Sep 10 21:10:28 storage kernel: [  762.227833] ------------[ cut here ]------------
Sep 10 21:10:28 storage kernel: [  762.227842] WARNING: at drivers/usb/core/urb.c:414 usb_submit_urb+0x12a/0x3e0()
Sep 10 21:10:28 storage kernel: [  762.227844] Hardware name: Inspiron 530
Sep 10 21:10:28 storage kernel: [  762.227846] Device: usb
Sep 10 21:10:28 storage kernel: [  762.227846] BOGUS urb xfer, pipe 1 != type 3
Sep 10 21:10:28 storage kernel: [  762.227849] Modules linked in: wis_sony_tuner(C) wis_uda1342(C) wis_saa7115(C) go7007_usb(C) go7007(C) v4l2_common videodev media ipt_MASQUERADE xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp ipt_REJECT xt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables fuse ext4 jbd2 crc16 e1000e
Sep 10 21:10:28 storage kernel: [  762.227876] Pid: 17894, comm: gorecord-cvs Tainted: G        WC   3.6.0-rc4.go7007.saa7115+ #3
Sep 10 21:10:28 storage kernel: [  762.227878] Call Trace:
Sep 10 21:10:28 storage kernel: [  762.227883]  [<c1033f4d>] warn_slowpath_common+0x6d/0xa0
Sep 10 21:10:28 storage kernel: [  762.227887]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.227889]  [<c1394eda>] ? usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.227892]  [<c1033ffe>] warn_slowpath_fmt+0x2e/0x30
Sep 10 21:10:28 storage kernel: [  762.227895]  [<c1394eda>] usb_submit_urb+0x12a/0x3e0
Sep 10 21:10:28 storage kernel: [  762.227900]  [<f9e6225a>] go7007_usb_read_interrupt+0x1a/0x40 [go7007_usb]
Sep 10 21:10:28 storage kernel: [  762.227904]  [<f9e4daf4>] go7007_read_interrupt+0x24/0x100 [go7007]
Sep 10 21:10:28 storage kernel: [  762.227908]  [<f9e6215e>] ? go7007_usb_send_firmware+0x3e/0x60 [go7007_usb]
Sep 10 21:10:28 storage kernel: [  762.227911]  [<f9e4ddb9>] go7007_load_encoder+0xc9/0x180 [go7007]
Sep 10 21:10:28 storage kernel: [  762.227914]  [<c1394da0>] ? usb_kill_urb+0x90/0xa0
Sep 10 21:10:28 storage kernel: [  762.227918]  [<f9e4de7b>] go7007_reset_encoder+0xb/0x20 [go7007]
Sep 10 21:10:28 storage kernel: [  762.227921]  [<f9e4cacb>] go7007_streamoff+0xab/0xb0 [go7007]
Sep 10 21:10:28 storage kernel: [  762.227925]  [<f9e4caf9>] vidioc_streamoff+0x29/0x80 [go7007]
Sep 10 21:10:28 storage kernel: [  762.227930]  [<f9e21b95>] v4l_streamoff+0x15/0x20 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227935]  [<f9e240cc>] __video_do_ioctl+0x28c/0x3a0 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227938]  [<c105c692>] ? check_preempt_curr+0x72/0x90
Sep 10 21:10:28 storage kernel: [  762.227942]  [<c10631d7>] ? try_to_wake_up+0x197/0x220
Sep 10 21:10:28 storage kernel: [  762.227946]  [<c122a3d8>] ? _copy_from_user+0x38/0x130
Sep 10 21:10:28 storage kernel: [  762.227951]  [<f9e25b83>] video_usercopy+0x143/0x320 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227954]  [<c105ec70>] ? __wake_up+0x40/0x50
Sep 10 21:10:28 storage kernel: [  762.227959]  [<c1292254>] ? tty_wakeup+0x34/0x70
Sep 10 21:10:28 storage kernel: [  762.227962]  [<c129a851>] ? pty_write+0x61/0x70
Sep 10 21:10:28 storage kernel: [  762.227966]  [<c12948d2>] ? do_output_char+0x1d2/0x200
Sep 10 21:10:28 storage kernel: [  762.227970]  [<c1053e7c>] ? remove_wait_queue+0x3c/0x50
Sep 10 21:10:28 storage kernel: [  762.227974]  [<f9e25d72>] video_ioctl2+0x12/0x20 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227979]  [<f9e23e40>] ? v4l2_ioctl_get_lock+0x50/0x50 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227983]  [<f9e20913>] v4l2_ioctl+0x103/0x150 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227987]  [<f9e20810>] ? v4l2_open+0x140/0x140 [videodev]
Sep 10 21:10:28 storage kernel: [  762.227992]  [<c111440e>] do_vfs_ioctl+0x7e/0x5c0
Sep 10 21:10:28 storage kernel: [  762.227996]  [<c11e108a>] ? file_has_perm+0x9a/0xc0
Sep 10 21:10:28 storage kernel: [  762.228000]  [<c11e1276>] ? selinux_file_ioctl+0x56/0x110
Sep 10 21:10:28 storage kernel: [  762.228012]  [<c11149cf>] sys_ioctl+0x7f/0x90
Sep 10 21:10:28 storage kernel: [  762.228016]  [<c15a44cc>] sysenter_do_call+0x12/0x22
Sep 10 21:10:28 storage kernel: [  762.228018] ---[ end trace 7ad74e28071d6f03 ]---

--------------090803090101060905020507--
