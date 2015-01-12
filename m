Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47343 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbbALPVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 10:21:38 -0500
Message-ID: <54B3E673.70608@xs4all.nl>
Date: Mon, 12 Jan 2015 16:21:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: videobuf2_core oops, recent media_build
References: <1419672917.2377.3.camel@xs4all.nl>
In-Reply-To: <1419672917.2377.3.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jurgen,

On 12/27/2014 10:35 AM, Jurgen Kramer wrote:
> I am seeing kernel oopses using recent media_builds on kernel 3.17:
> 
> [  506.969697] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000058
> [  506.969720] IP: [<ffffffffa03a233a>] vb2_thread+0x17a/0x480
> [videobuf2_core]
> [  506.969739] PGD 0 
> [  506.969746] Oops: 0002 [#1] SMP 
> [  506.969754] Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast cfg80211 rfkill ip6t_rpfilter ip6t_REJECT
> xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter
> ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
> ip6table_mangle ip6table_security ip6table_raw ip6table_filter
> ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw sp2(OE)
> si2157(OE) si2168(OE) i2c_mux nouveau cx25840(OE) cx23885(OE)
> altera_ci(OE) tda18271(OE) altera_stapl(OE) videobuf2_dvb(OE)
> videobuf2_core(OE) videobuf2_dma_sg(OE) videobuf2_memops(OE) snd_seq
> snd_seq_device snd_pcm snd_timer snd video i2c_algo_bit ttm
> drm_kms_helper soundcore iTCO_wdt ppdev gpio_ich iTCO_vendor_support
> tveeprom(OE) cx2341x(OE)
> [  506.969871]  coretemp dvb_core(OE) v4l2_common(OE) videodev(OE)
> media(OE) kvm crc32c_intel raid456 async_raid6_recov async_memcpy
> async_pq async_xor drm xor async_tx raid6_pq microcode serio_raw shpchp
> i7core_edac edac_core i2c_i801 lpc_ich mfd_core parport_pc parport
> ite_cir(OE) rc_core(OE) tpm_infineon tpm_tis tpm acpi_cpufreq nfsd
> auth_rpcgss nfs_acl lockd sunrpc mxm_wmi asix usbnet r8169 mii wmi
> [  506.969970] CPU: 0 PID: 3160 Comm: vb2-cx23885[0] Tainted: G
> OE  3.17.4-200.fc20.x86_64 #1
> [  506.969982] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./P55 Extreme, BIOS P2.70 08/20/2010
> [  506.969993] task: ffff8800bc18e220 ti: ffff88020d36c000 task.ti:
> ffff88020d36c000
> [  506.970002] RIP: 0010:[<ffffffffa03a233a>]  [<ffffffffa03a233a>]
> vb2_thread+0x17a/0x480 [videobuf2_core]
> [  506.970021] RSP: 0018:ffff88020d36fe68  EFLAGS: 00010246
> [  506.970663] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 000000000000000b
> [  506.971305] RDX: 0000000000000058 RSI: ffff8800bc18e220 RDI:
> 0000000000000058
> [  506.971952] RBP: ffff88020d36fec0 R08: ffff88020d36c000 R09:
> 000000000000158f
> [  506.972611] R10: 00000000000030de R11: 0000000000000010 R12:
> 0000000000000058
> [  506.973275] R13: ffff8800b81814a0 R14: 0000000000000000 R15:
> ffff880225c61028
> [  506.973947] FS:  0000000000000000(0000) GS:ffff880233c00000(0000)
> knlGS:0000000000000000
> [  506.974634] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  506.975321] CR2: 0000000000000058 CR3: 0000000001c14000 CR4:
> 00000000000007f0
> [  506.976021] Stack:
> [  506.976723]  ffff8800bc18e220 0000000000000070 00ffffff81c1b460
> 0000000000000000
> [  506.977442]  ffff880200000000 ffff880225c61028 ffff88020d1d8480
> ffff880225c61028
> [  506.978165]  ffffffffa03a21c0 0000000000000000 0000000000000000
> ffff88020d36ff48
> [  506.979055] Call Trace:
> [  506.979795]  [<ffffffffa03a21c0>] ? vb2_internal_qbuf+0x210/0x210
> [videobuf2_core]
> [  506.980545]  [<ffffffff810b0498>] kthread+0xd8/0xf0
> [  506.981293]  [<ffffffff810b03c0>] ? kthread_create_on_node
> +0x190/0x190
> [  506.982045]  [<ffffffff8172e33c>] ret_from_fork+0x7c/0xb0
> [  506.982806]  [<ffffffff810b03c0>] ? kthread_create_on_node
> +0x190/0x190
> [  506.983568] Code: 89 e7 ba 58 00 00 00 0f 85 94 01 00 00 40 f6 c7 02
> 0f 85 72 01 00 00 40 f6 c7 04 0f 85 50 01 00 00 89 d1 31 c0 c1 e9 03 f6
> c2 04 <f3> 48 ab 74 0a c7 07 00 00 00 00 48 83 c7 04 f6 c2 02 74 0a 31 
> [  506.984464] RIP  [<ffffffffa03a233a>] vb2_thread+0x17a/0x480
> [videobuf2_core]
> [  506.985306]  RSP <ffff88020d36fe68>
> [  506.986147] CR2: 0000000000000058
> [  506.990986] ---[ end trace 1973fbcab83c3353 ]---
> 
> First I thought is was related to CAM initialization but after removing
> the CAMS and doing a fresh cold start I am still seeing the oopses.
> After the oops everything is still functioning. I am using 3x DVBSKY
> T980C. How can I debug this further?

Sorry for the delay, I was on vacation.

Do you get this when you start streaming, stop streaming or during streaming?

I strongly suspect a race condition that can occur when stopping streaming,
but I am not aware of race conditions when starting or during streaming.

Please let me know when you get this, as that will be very useful information
for me.

Regards,

	Hans
