Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34919 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbbARMfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 07:35:31 -0500
Message-ID: <1421584528.7564.4.camel@xs4all.nl>
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>, ray@apollo.lv
Date: Sun, 18 Jan 2015 13:35:28 +0100
In-Reply-To: <54BB8D8C.1000507@xs4all.nl>
References: <54B52548.7010109@xs4all.nl> <1421168382.2615.1.camel@xs4all.nl>
		 <1421339578.2355.2.camel@xs4all.nl> <54B9271D.8010703@xs4all.nl>
	 <1421571262.2604.3.camel@xs4all.nl> <54BB8D8C.1000507@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2015-01-18 at 11:40 +0100, Hans Verkuil wrote:
> On 01/18/2015 09:54 AM, Jurgen Kramer wrote:
> > I have been running the original code (because of issues with the patch)
> > for a while with some added printks. This morning I found this NULL
> > pointer derefence:
> 
> That's what my patch fixes, so that's no surprise that you get this.
> 
> I don't understand why you have issues with the patch, very weird.
I just retested with your patch using mplayer instead of mythtv. It played for a few seconds
then it froze and the mplayer process is not killable.

Can you sent my your version of patched videobuf2-core.c? I had to hand
patch (patch did not apply cleanly). Maybe I botched something.

Regards,
Jurgen

> Regards,
> 
> 	Hans
> 
> > 
> > [47772.121968] DEBUG: vb2_thread_stop entered
> > [47772.122014] BUG: unable to handle kernel NULL pointer dereference at
> > (null)
> > [47772.122042] vb2: counters for queue ffff880407ee9828: UNBALANCED!
> > [47772.122043] vb2:     setup: 1 start_streaming: 1 stop_streaming: 1
> > [47772.122043] vb2:     wait_prepare: 249333 wait_finish: 249334
> > [47772.122083] IP: [<ffffffffa057b65c>] cx23885_buf_prepare+0x6c/0xd0
> > [cx23885]
> > [47772.122102] PGD 0 
> > [47772.122107] Oops: 0000 [#1] SMP 
> > [47772.122116] Modules linked in: cfg80211 rfkill
> > nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT
> > xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter
> > ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
> > ip6table_mangle ip6table_security ip6table_raw ip6table_filter
> > ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> > nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw sp2(OE)
> > si2157(OE) si2168(OE) i2c_mux cx25840(OE) cx23885(OE) altera_ci(OE)
> > tda18271(OE) altera_stapl(OE) videobuf2_dvb(OE) videobuf2_core(OE)
> > videobuf2_dma_sg(OE) videobuf2_memops(OE) snd_seq snd_seq_device snd_pcm
> > snd_timer snd soundcore tveeprom(OE) cx2341x(OE) dvb_core(OE)
> > rc_core(OE) v4l2_common(OE) videodev(OE) raid456 async_raid6_recov
> > async_memcpy
> > [47772.122321]  async_pq async_xor xor async_tx raid6_pq media(OE)
> > mxm_wmi intel_rapl x86_pkg_temp_thermal coretemp kvm_intel kvm serio_raw
> > shpchp mei_me mei i2c_i801 crct10dif_pclmul crc32_pclmul crc32c_intel
> > ghash_clmulni_intel microcode dw_dmac wmi dw_dmac_core tpm_tis tpm
> > i2c_hid i2c_designware_platform i2c_designware_core acpi_pad nfsd
> > auth_rpcgss nfs_acl lockd sunrpc e1000e i915 ptp pps_core i2c_algo_bit
> > drm_kms_helper drm sdhci_acpi sdhci mmc_core video
> > [47772.122472] CPU: 0 PID: 6151 Comm: vb2-cx23885[2] Tainted: G
> > OE  3.17.8-200.fc20.x86_64 #1
> > [47772.122492] Hardware name: To Be Filled By O.E.M. To Be Filled By
> > O.E.M./Z97 Extreme4, BIOS P1.50 12/17/2014
> > [47772.122523] task: ffff8803dcfc9d70 ti: ffff8803652a8000 task.ti:
> > ffff8803652a8000
> > [47772.122549] RIP: 0010:[<ffffffffa057b65c>]  [<ffffffffa057b65c>]
> > cx23885_buf_prepare+0x6c/0xd0 [cx23885]
> > [47772.122573] RSP: 0018:ffff8803652abdc8  EFLAGS: 00010246
> > [47772.122585] RAX: 0000000000005e00 RBX: ffff880036a6d600 RCX:
> > 00000000000002f0
> > [47772.122609] RDX: 0000000000005e00 RSI: ffff88040608a3b8 RDI:
> > ffff8804091f3000
> > [47772.122624] RBP: ffff8803652abdf0 R08: 0000000000000020 R09:
> > 0000000000000000
> > [47772.122649] R10: ffff880407ee9828 R11: ffff880407ee9828 R12:
> > ffff88040608a000
> > [47772.122663] R13: 0000000000005e00 R14: ffff880036a6c000 R15:
> > 0000000000000000
> > [47772.122677] FS:  0000000000000000(0000) GS:ffff88041fa00000(0000)
> > knlGS:0000000000000000
> > [47772.122693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [47772.122705] CR2: 0000000000000000 CR3: 0000000001c14000 CR4:
> > 00000000001407f0
> > [47772.122720] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [47772.123643] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> > [47772.124605] Stack:
> > [47772.125468]  ffff88040608a000 ffff88040608c458 ffff88040608a000
> > 0000000000000000
> > [47772.126350]  ffff880407ee9828 ffff8803652abe00 ffffffffa057cd69
> > ffff8803652abe30
> > [47772.127230]  ffffffffa04f183e 0000000000005e00 ffff880407ee9828
> > ffff88040608c458
> > [47772.128129] Call Trace:
> > [47772.129002]  [<ffffffffa057cd69>] buffer_prepare+0x19/0x20 [cx23885]
> > [47772.129916]  [<ffffffffa04f183e>] __buf_prepare+0x27e/0x390
> > [videobuf2_core]
> > [47772.130838]  [<ffffffffa04f301b>] vb2_internal_qbuf+0x6b/0x210
> > [videobuf2_core]
> > [47772.131722]  [<ffffffffa04f32f6>] vb2_thread+0x136/0x4d0
> > [videobuf2_core]
> > [47772.132642]  [<ffffffffa04f31c0>] ? vb2_internal_qbuf+0x210/0x210
> > [videobuf2_core]
> > [47772.133527]  [<ffffffff810b04b8>] kthread+0xd8/0xf0
> > [47772.134400]  [<ffffffff810b03e0>] ? kthread_create_on_node
> > +0x190/0x190
> > [47772.135268]  [<ffffffff8173057c>] ret_from_fork+0x7c/0xb0
> > [47772.136134]  [<ffffffff810b03e0>] ? kthread_create_on_node
> > +0x190/0x190
> > [47772.137058] Code: 24 60 02 00 00 85 c0 75 3e 45 85 ed 75 4d 90 8b 8b
> > f0 00 00 00 49 8b be 20 01 00 00 49 8d b4 24 b8 03 00 00 44 8b 83 f4 00
> > 00 00 <49> 8b 17 45 31 c9 e8 c9 f0 ff ff 31 c0 5b 41 5c 41 5d 41 5e 41 
> > [47772.138917] RIP  [<ffffffffa057b65c>] cx23885_buf_prepare+0x6c/0xd0
> > [cx23885]
> > [47772.139841]  RSP <ffff8803652abdc8>
> > [47772.140776] CR2: 0000000000000000
> > [47772.146080] ---[ end trace 2c986045fea9fe0a ]---
> > [47772.146236] DEBUG: vb2_thread_stop quit
> > 
> > This happened only once normally it just prints:
> > [47179.170117] DEBUG: vb2_thread
> > [47400.670021] DEBUG: vb2_thread_stop entered
> > [47400.670105] DEBUG: vb2_thread_stop quit
> > [47401.012711] DEBUG: vb2_thread
> > [47456.200792] DEBUG: vb2_thread_stop entered
> > [47456.200908] DEBUG: vb2_thread_stop quit
> > [47456.544154] DEBUG: vb2_thread
> > [47480.938606] DEBUG: vb2_thread_stop entered
> > [47480.938711] DEBUG: vb2_thread_stop quit
> > [47481.024019] DEBUG: vb2_thread
> > [47708.823051] DEBUG: vb2_thread_stop entered
> > [47708.823184] DEBUG: vb2_thread_stop quit
> > [47709.166499] DEBUG: vb2_thread
> > 
> > Regards,
> > Jurgen
> > 
> 


