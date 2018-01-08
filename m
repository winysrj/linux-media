Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53963 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756835AbeAHN07 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 08:26:59 -0500
Subject: Re: [PATCH v3] media: videobuf2-core: don't go out of the buffer
 range
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hirokazu Honda <hiroh@chromium.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>
References: <794d4bf6395160b2077f55148e3caa58751215a9.1514470603.git.mchehab@s-opensource.com>
 <cae9629d-9c9f-d986-7f5a-69ec73fee2f4@xs4all.nl>
 <20180108111402.1e76c897@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7478e129-f324-b883-b4db-8aa8f582f948@xs4all.nl>
Date: Mon, 8 Jan 2018 14:26:48 +0100
MIME-Version: 1.0
In-Reply-To: <20180108111402.1e76c897@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2018 02:15 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 8 Jan 2018 12:34:15 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> On 12/28/2017 03:16 PM, Mauro Carvalho Chehab wrote:
>>> Currently, there's no check if an invalid buffer range
>>> is passed. However, while testing DVB memory mapped apps,
>>> I got this:
>>>
>>>    videobuf2_core: VB: num_buffers -2143943680, buffer 33, index -2143943647
>>>    unable to handle kernel paging request at ffff888b773c0890
>>>    IP: __vb2_queue_alloc+0x134/0x4e0 [videobuf2_core]
>>>    PGD 4142c7067 P4D 4142c7067 PUD 0
>>>    Oops: 0002 [#1] SMP
>>>    Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables bluetooth rfkill ecdh_generic binfmt_misc rc_dvbsky sp2 ts2020 intel_rapl x86_pkg_temp_thermal dvb_usb_dvbsky intel_powerclamp dvb_usb_v2 coretemp m88ds3103 kvm_intel i2c_mux dvb_core snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul videobuf2_vmalloc videobuf2_memops snd_hda_intel ghash_clmulni_intel videobuf2_core snd_hda_codec rc_core mei_me intel_cstate snd_hwdep snd_hda_core videodev intel_uncore snd_pcm mei media tpm_tis tpm_tis_core intel_rapl_perf tpm snd_timer lpc_ich snd soundcore kvm irqbypass libcrc32c i915 i2c_algo_bit drm_kms_helper
>>>    e1000e ptp drm crc32c_intel video pps_core
>>>    CPU: 3 PID: 1776 Comm: dvbv5-zap Not tainted 4.14.0+ #78
>>>    Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0364.2017.0511.0949 05/11/2017
>>>    task: ffff88877c73bc80 task.stack: ffffb7c402418000
>>>    RIP: 0010:__vb2_queue_alloc+0x134/0x4e0 [videobuf2_core]
>>>    RSP: 0018:ffffb7c40241bc60 EFLAGS: 00010246
>>>    RAX: 0000000080360421 RBX: 0000000000000021 RCX: 000000000000000a
>>>    RDX: ffffb7c40241bcf4 RSI: ffff888780362c60 RDI: ffff888796d8e130
>>>    RBP: ffffb7c40241bcc8 R08: 0000000000000316 R09: 0000000000000004
>>>    R10: ffff888780362c00 R11: 0000000000000001 R12: 000000000002f000
>>>    R13: ffff8887758be700 R14: 0000000000021000 R15: 0000000000000001
>>>    FS:  00007f2849024740(0000) GS:ffff888796d80000(0000) knlGS:0000000000000000
>>>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>    CR2: ffff888b773c0890 CR3: 000000043beb2005 CR4: 00000000003606e0
>>>    Call Trace:
>>>     vb2_core_reqbufs+0x226/0x420 [videobuf2_core]
>>>     dvb_vb2_reqbufs+0x2d/0xc0 [dvb_core]
>>>     dvb_dvr_do_ioctl+0x98/0x1d0 [dvb_core]
>>>     dvb_usercopy+0x53/0x1b0 [dvb_core]
>>>     ? dvb_demux_ioctl+0x20/0x20 [dvb_core]
>>>     ? tty_ldisc_deref+0x16/0x20
>>>     ? tty_write+0x1f9/0x310
>>>     ? process_echoes+0x70/0x70
>>>     dvb_dvr_ioctl+0x15/0x20 [dvb_core]
>>>     do_vfs_ioctl+0xa5/0x600
>>>     SyS_ioctl+0x79/0x90
>>>     entry_SYSCALL_64_fastpath+0x1a/0xa5
>>>    RIP: 0033:0x7f28486f7ea7
>>>    RSP: 002b:00007ffc13b2db18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>>    RAX: ffffffffffffffda RBX: 000055b10fc06130 RCX: 00007f28486f7ea7
>>>    RDX: 00007ffc13b2db48 RSI: 00000000c0086f3c RDI: 0000000000000007
>>>    RBP: 0000000000000203 R08: 000055b10df1e02c R09: 000000000000002e
>>>    R10: 0036b42415108357 R11: 0000000000000246 R12: 0000000000000000
>>>    R13: 00007f2849062f60 R14: 00000000000001f1 R15: 00007ffc13b2da54
>>>    Code: 74 0a 60 8b 0a 48 83 c0 30 48 83 c2 04 89 48 d0 89 48 d4 48 39 f0 75 eb 41 8b 42 08 83 7d d4 01 41 c7 82 ec 01 00 00 ff ff ff ff <4d> 89 94 c5 88 00 00 00 74 14 83 c3 01 41 39 dc 0f 85 f1 fe ff
>>>    RIP: __vb2_queue_alloc+0x134/0x4e0 [videobuf2_core] RSP: ffffb7c40241bc60
>>>    CR2: ffff888b773c0890
>>>
>>> So, add a sanity check in order to prevent going past array.  
>>
>> While this does not hurt from the point of view of robustness, it is not the right
>> fix for this kernel oops. The actual bug is in the vb2 dvb code. I'll reply to that
>> patch with more details.
> 
> Hi Hans,
> 
> Yes, the bug where at dvb-vb2, with was setting the buffer size inside
> a videobuf ops. It was fixed already.
> 
> Yet, vb2 core should be smarter than that and don't allow going past 
> the internally-allocated array if the driver asks for more buffers
> than it supports, via a vb2 ops.

But the commit log for this patch is really wrong since this is a robustness
measure and has nothing to do with the kernel oops.

I also would prefer a WARN_ON here, since if this happens, then it really is
a driver bug so a backtrace is very useful in that case.

Regards,

	Hans

> 
> Thanks,
> Mauro
> 
