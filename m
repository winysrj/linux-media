Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35809 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdBBS1C (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 13:27:02 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170202172245.GT27312@n2100.armlinux.org.uk>
 <20170202175600.GU27312@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <4815b9c8-782a-ac67-d296-c4acb296d849@gmail.com>
Date: Thu, 2 Feb 2017 10:26:55 -0800
MIME-Version: 1.0
In-Reply-To: <20170202175600.GU27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/02/2017 09:56 AM, Russell King - ARM Linux wrote:
> On Thu, Feb 02, 2017 at 05:22:46PM +0000, Russell King - ARM Linux wrote:
>> I thought, maybe, it's the IPU overwriting past the end of the buffer,
>> but I've added checks and that doesn't seem to have fired.  I also
>> wondered if it was some kind of use-after-free of the ring, so I made
>> imx_media_free_dma_buf_ring() memset the ring to 0x5a5a5a5a before
>> kfree()ing it... doesn't look like it's that either.  I'm going to
>> continue poking to see if I can figure out what's going on.
> I take that back... here's a use-after-free of that buffer, on the
> very first run:
>
> Alignment trap: not handling instruction e1921f9f at [<c00894c4>]
> Unhandled fault: alignment exception (0x001) at 0x5a5a5b5e
> pgd = c0004000
> [5a5a5b5e] *pgd=00000000
> Internal error: : 1 [#1] SMP ARM
> Modules linked in: imx_csi(C) rfcomm bnep bluetooth nfsd imx_camif(C) imx_ic(C) imx_smfc(C) caam_jr snd_soc_imx_spdif snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card imx_media(C) uvcvideo imx_mipi_csi2(C) imx_media_common(C) imx219 snd_soc_sgtl5000 snd_soc_imx_audmux caam video_multiplexer imx_sdma imx2_wdt coda v4l2_mem2mem videobuf2_v4l2 videobuf2_dma_contig videobuf2_core rc_cec snd_soc_fsl_ssi snd_soc_fsl_spdif videobuf2_vmalloc videobuf2_memops imx_pcm_dma imx_thermal dw_hdmi_ahb_audio dw_hdmi_cec etnaviv fuse rc_pinnacle_pctv_hd
> CPU: 0 PID: 99 Comm: kworker/0:3 Tainted: G         C      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: lru-add-drain wq_barrier_func
> task: ee4e24c0 task.stack: ee6da000
> PC is at __lock_acquire+0xd4/0x17b0
> LR is at lock_acquire+0xd8/0x250
> pc : [<c00894c8>]    lr : [<c008b108>]    psr: 20070193
> sp : ee6dbb60  ip : 00000001  fp : ee6dbbe4
> r10: e9efad60  r9 : c0a70384  r8 : 00000000
> r7 : c0a38680  r6 : 00000000  r5 : ee4e24c0  r4 : c1400408
> r3 : 00000000  r2 : 5a5a5b5e  r1 : 00000000  r0 : 5a5a5a5a
> Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: 3d7ec04a  DAC: 00000051
> Process kworker/0:3 (pid: 99, stack limit = 0xee6da210)
> Stack: (0xee6dbb60 to 0xee6dc000)
> bb60: c0a38680 00000002 c0b9d8c4 ee4e29a8 ee6dbc04 ee6dbb80 c0089708 c0088d44
> bb80: ee6dbb9c 0000050f c00867fc c0086728 ee6dbbf4 ee6dbba0 87eba239 c035aa2f
> bba0: 00000001 ee4e29a8 c00c4f84 00000001 00000026 0560e36b ffffffff 00000000
> bbc0: 60070193 e9efad60 00000000 00000000 c0a70384 00000000 ee6dbc3c ee6dbbe8
> bbe0: c008b108 c0089400 00000001 00000080 00000000 bf0d2a8c 00000000 00000000
> bc00: c008b108 c0089400 00000001 c09e04ec 00000000 e9efad50 60070193 bf0d2a8c
> bc20: 00000139 00000000 c09e04ec ee6dbcec ee6dbc6c ee6dbc40 c07016f4 c008b03c
> bc40: 00000001 00000000 bf0d2a8c ee6dbcec ee6dbc84 e9efac00 e9efad50 ee9785c4
> bc60: ee6dbc84 ee6dbc70 bf0d2a8c c07016b4 ee978410 e9efb400 ee6dbca4 ee6dbc88
> bc80: bf1224b8 bf0d2a7c bf122458 ee88d4c0 e9efb400 e9efb410 ee6dbce4 ee6dbca8
> bca0: c009f5dc bf122464 00000001 c09e04ec 00000000 e9efb400 c009f9f8 e9efb400
> bcc0: e9efb400 e9efb410 00000000 00000009 f4001100 ee6dbe38 ee6dbd04 ee6dbce8
> bce0: c009f984 c009f544 c0701d10 00000000 e9efb400 e9efb460 ee6dbd24 ee6dbd08
> bd00: c009fa00 c009f96c c09d0418 e9efb400 e9efb460 e9efb410 ee6dbd44 ee6dbd28
> bd20: c00a3174 c009f9cc c00a30c4 00000000 ee6dbd90 ee4a3010 ee6dbd54 ee6dbd48
> bd40: c009ecf0 c00a30d0 ee6dbd84 ee6dbd58 c0409328 c009ecdc c09d0448 00000001
> bd60: 00000026 ef1efc10 c09e756c ee4a3010 00000026 ef008400 ee6dbdcc ee6dbd88
> bd80: c0409458 c040928c 00000001 00000000 00000001 00000002 00000003 0000000a
> bda0: 0000000b 0000000c 0000000d 0000000e ee6dbdcc c09d52d0 00000000 00000000
> bdc0: ee6dbddc ee6dbdd0 c009ecf0 c0409408 ee6dbe04 ee6dbde0 c009ee24 c009ecdc
> bde0: ee6dbe38 f4000100 f400010c c09e0af0 000003eb c0a38a78 ee6dbe34 ee6dbe08
> be00: c00094c8 c009edd4 ee4e24c0 c0701d50 20070013 ffffffff ee6dbe6c ef7be600
> be20: ee6da000 c09f5dc6 ee6dbe9c ee6dbe38 c00149f0 c0009488 00000001 ee4e2988
> be40: 00000000 60070093 20070013 ddb9799c 20070013 ee6dbef0 ef7be600 c09e04ec
> be60: c09f5dc6 ee6dbe9c 00000288 ee6dbe88 c008b60c c0701d50 20070013 ffffffff
> be80: 00000051 00000000 ddb9799c ddb97998 ee6dbebc ee6dbea0 c0083824 c0701d20
> bea0: c004e9c4 ee6e6d80 ddb97978 ef7ba940 ee6dbecc ee6dbec0 c004e9d8 c00837e8
> bec0: ee6dbf2c ee6dbed0 c0050958 c004e9d0 00000001 00000000 c0050898 00000000
> bee0: c0701d8c ee4e24c0 0000000f 00000000 c0a73e7c c0bc8834 00000000 c08947f8
> bf00: 00000008 ee6e6d80 ee6e6d98 ee6e6d98 00000008 ef7ba940 ef7ba940 c09dd900
> bf20: ee6dbf44 ee6dbf30 c0050e78 c0050774 ee6e6d80 ef7ba974 ee6dbf7c ee6dbf48
> bf40: c0051094 c0050e54 00000000 ee6e8ac0 ee509eb8 ee509e80 00000000 ee6e8ac0
> bf60: ee509eb8 ee6e6d80 ef0c9e58 c0050e88 ee6dbfac ee6dbf80 c0057b90 c0050e94
> bf80: ee6da000 ee6e8ac0 c0057a88 00000000 00000000 00000000 00000000 00000000
> bfa0: 00000000 ee6dbfb0 c000fdf0 c0057a94 00000000 00000000 00000000 00000000
> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 3fffd861 3fffdc61
> Backtrace:
> [<c00893f4>] (__lock_acquire) from [<c008b108>] (lock_acquire+0xd8/0x250)
>   r10:00000000 r9:c0a70384 r8:00000000 r7:00000000 r6:e9efad60 r5:60070193
>   r4:00000000
> [<c008b030>] (lock_acquire) from [<c07016f4>] (_raw_spin_lock_irqsave+0x4c/0x60)
>   r10:ee6dbcec r9:c09e04ec r8:00000000 r7:00000139 r6:bf0d2a8c r5:60070193
>   r4:e9efad50
> [<c07016a8>] (_raw_spin_lock_irqsave) from [<bf0d2a8c>] (imx_media_dma_buf_get_active+0x1c/0x94 [imx_media_common])
>   r6:ee9785c4 r5:e9efad50 r4:e9efac00
> [<bf0d2a70>] (imx_media_dma_buf_get_active [imx_media_common]) from [<bf1224b8>] (imx_smfc_eof_interrupt+0x60/0x168 [imx_smfc])
>   r5:e9efb400 r4:ee978410
> [<bf122458>] (imx_smfc_eof_interrupt [imx_smfc]) from [<c009f5dc>] (__handle_irq_event_percpu+0xa4/0x428)
>   r6:e9efb410 r5:e9efb400 r4:ee88d4c0 r3:bf122458
> [<c009f538>] (__handle_irq_event_percpu) from [<c009f984>] (handle_irq_event_percpu+0x24/0x60)
>   r10:ee6dbe38 r9:f4001100 r8:00000009 r7:00000000 r6:e9efb410 r5:e9efb400
>   r4:e9efb400
> [<c009f960>] (handle_irq_event_percpu) from [<c009fa00>] (handle_irq_event+0x40/0x64)
>   r5:e9efb460 r4:e9efb400
> [<c009f9c0>] (handle_irq_event) from [<c00a3174>] (handle_level_irq+0xb0/0x138)
>   r6:e9efb410 r5:e9efb460 r4:e9efb400 r3:c09d0418
> [<c00a30c4>] (handle_level_irq) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:ee4a3010 r5:ee6dbd90 r4:00000000 r3:c00a30c4
> [<c009ecd0>] (generic_handle_irq) from [<c0409328>] (ipu_irq_handle+0xa8/0xd8)
> [<c0409280>] (ipu_irq_handle) from [<c0409458>] (ipu_irq_handler+0x5c/0xb4)
>   r8:ef008400 r7:00000026 r6:ee4a3010 r5:c09e756c r4:ef1efc10
> [<c04093fc>] (ipu_irq_handler) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:00000000 r5:00000000 r4:c09d52d0
> [<c009ecd0>] (generic_handle_irq) from [<c009ee24>] (__handle_domain_irq+0x5c/0xb8)
> [<c009edc8>] (__handle_domain_irq) from [<c00094c8>] (gic_handle_irq+0x4c/0x9c)
>   r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c r4:f4000100 r3:ee6dbe38
> [<c000947c>] (gic_handle_irq) from [<c00149f0>] (__irq_svc+0x70/0x98)
> Exception stack(0xee6dbe38 to 0xee6dbe80)
> be20:                                                       00000001 ee4e2988
> be40: 00000000 60070093 20070013 ddb9799c 20070013 ee6dbef0 ef7be600 c09e04ec
> be60: c09f5dc6 ee6dbe9c 00000288 ee6dbe88 c008b60c c0701d50 20070013 ffffffff
>   r10:c09f5dc6 r9:ee6da000 r8:ef7be600 r7:ee6dbe6c r6:ffffffff r5:20070013
>   r4:c0701d50 r3:ee4e24c0
> [<c0701d14>] (_raw_spin_unlock_irqrestore) from [<c0083824>] (complete+0x48/0x4c)
>   r5:ddb97998 r4:ddb9799c
> [<c00837dc>] (complete) from [<c004e9d8>] (wq_barrier_func+0x14/0x18)
>   r6:ef7ba940 r5:ddb97978 r4:ee6e6d80 r3:c004e9c4
> [<c004e9c4>] (wq_barrier_func) from [<c0050958>] (process_one_work+0x1f0/0x6e0)
> [<c0050768>] (process_one_work) from [<c0050e78>] (process_scheduled_works+0x30/0x40)
>   r10:c09dd900 r9:ef7ba940 r8:ef7ba940 r7:00000008 r6:ee6e6d98 r5:ee6e6d98
>   r4:ee6e6d80
> [<c0050e48>] (process_scheduled_works) from [<c0051094>] (worker_thread+0x20c/0x4c8)
>   r5:ef7ba974 r4:ee6e6d80
> [<c0050e88>] (worker_thread) from [<c0057b90>] (kthread+0x108/0x140)
>   r10:c0050e88 r9:ef0c9e58 r8:ee6e6d80 r7:ee509eb8 r6:ee6e8ac0 r5:00000000
>   r4:ee509e80
> [<c0057a88>] (kthread) from [<c000fdf0>] (ret_from_fork+0x14/0x24)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0057a88
>   r4:ee6e8ac0 r3:ee6da000
> Code: 0affffe9 e2802f41 f592f000 e1921f9f (e2811001)
> ---[ end trace 2e91a0629044cda4 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> CPU1: stopping
> CPU: 1 PID: 91 Comm: kworker/1:1 Tainted: G      D  C      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: events dbs_work_handler
> Backtrace:
> [<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
>   r6:60000193 r5:ffffffff r4:00000000 r3:ee4e6e40
> [<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
> [<c0333444>] (dump_stack) from [<c0016a68>] (handle_IPI+0x1b4/0x364)
>   r6:c0a70028 r5:00000001 r4:00000004 r3:ee4e6e40
> [<c00168b4>] (handle_IPI) from [<c000950c>] (gic_handle_irq+0x90/0x9c)
>   r10:ee6b7ba8 r9:f4001100 r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c
>   r4:f4000100
> [<c000947c>] (gic_handle_irq) from [<c00149f0>] (__irq_svc+0x70/0x98)
> Exception stack(0xee6b7ba8 to 0xee6b7bf0)
> 7ba0:                   00000000 00000004 00000003 00000003 00000001 ee6b7d2c
> 7bc0: c00177e8 00000000 00000001 ee6b7d2c 00000000 ee6b7c24 c09e0af4 ee6b7bf8
> 7be0: c0360f2c c00cd3a0 00000013 ffffffff
>   r10:00000000 r9:ee6b6000 r8:00000001 r7:ee6b7bdc r6:ffffffff r5:00000013
>   r4:c00cd3a0 r3:ee4e6e40
> [<c00cd2a4>] (smp_call_function_single) from [<c00cd668>] (smp_call_function_many+0x270/0x2bc)
>   r7:c09e04ec r6:c09e04ec r5:00000001 r4:c09e05c8
> [<c00cd3f8>] (smp_call_function_many) from [<c00cd818>] (smp_call_function+0x30/0x38)
>   r10:00000002 r9:ffffffff r8:00000002 r7:ee6b7d2c r6:c00177e8 r5:00000000
>   r4:ffffffff
> [<c00cd7e8>] (smp_call_function) from [<c00cd860>] (on_each_cpu+0x18/0x58)
> [<c00cd848>] (on_each_cpu) from [<c0017890>] (twd_rate_change+0x2c/0x38)
>   r7:ee6b7d24 r6:00000000 r5:00000000 r4:ffffffff
> [<c0017864>] (twd_rate_change) from [<c00593a4>] (notifier_call_chain+0x4c/0x8c)
> [<c0059358>] (notifier_call_chain) from [<c00596b8>] (__srcu_notifier_call_chain+0x78/0xac)
>   r8:ee6b7d24 r7:00000000 r6:ef0069e4 r5:ef006948 r4:ef006904 r3:ffffffff
> [<c0059640>] (__srcu_notifier_call_chain) from [<c005970c>] (srcu_notifier_call_chain+0x20/0x28)
>   r10:ef024e00 r9:c09e04ec r8:c0a720bc r7:00000002 r6:ef02a080 r5:c0a39b40
>   r4:ef006900
> [<c00596ec>] (srcu_notifier_call_chain) from [<c0385788>] (__clk_notify+0x74/0x7c)
> [<c0385714>] (__clk_notify) from [<c0385860>] (__clk_recalc_rates+0xd0/0xe0)
>   r7:00000001 r6:179a7b00 r5:00000002 r4:ef02a080
> [<c0385790>] (__clk_recalc_rates) from [<c0385818>] (__clk_recalc_rates+0x88/0xe0)
>   r6:2f34f600 r5:00000002 r4:ef02a080 r3:179a7b00
> [<c0385790>] (__clk_recalc_rates) from [<c0385818>] (__clk_recalc_rates+0x88/0xe0)
>   r6:2f34f600 r5:00000002 r4:ef033380 r3:179a7b00
> [<c0385790>] (__clk_recalc_rates) from [<c03892bc>] (clk_core_set_parent+0x1a8/0x410)
>   r6:ef02a400 r5:00000000 r4:ef02a480 r3:c0a38680
> [<c0389114>] (clk_core_set_parent) from [<c0389748>] (clk_set_parent+0x24/0x28)
>   r10:ee719c00 r9:001312d0 r8:3b5dc100 r7:000c15c0 r6:000f32a0 r5:00000002
>   r4:c141d574
> [<c0389724>] (clk_set_parent) from [<c052ab7c>] (imx6q_set_target+0x258/0x52c)
> [<c052a924>] (imx6q_set_target) from [<c0525360>] (__cpufreq_driver_target+0x150/0x528)
>   r10:000f32a0 r9:00000000 r8:00000001 r7:c141d424 r6:00000002 r5:00000000
>   r4:ee726000
> [<c0525210>] (__cpufreq_driver_target) from [<c0528e40>] (od_dbs_update+0xa0/0x168)
>   r10:eb522380 r9:c09e04ec r8:ebd79d80 r7:ee726000 r6:ebd79e40 r5:ebd79d80
>   r4:eb522380
> [<c0528da0>] (od_dbs_update) from [<c0529c24>] (dbs_work_handler+0x38/0x60)
>   r10:00000001 r8:c0a5b424 r7:ee726000 r6:ebd79e44 r5:00000000 r4:ebd79ea8
> [<c0529bec>] (dbs_work_handler) from [<c0050958>] (process_one_work+0x1f0/0x6e0)
>   r8:ef7ccc00 r7:ee6b7f08 r6:ef7c9940 r5:ebd79ea8 r4:ee509900 r3:c0529bec
> [<c0050768>] (process_one_work) from [<c0050eb8>] (worker_thread+0x30/0x4c8)
>   r10:c09dd900 r9:ef7c9940 r8:ef7c9940 r7:00000008 r6:ee509918 r5:ef7c9974
>   r4:ee509900
> [<c0050e88>] (worker_thread) from [<c0057b90>] (kthread+0x108/0x140)
>   r10:c0050e88 r9:ef0f3e58 r8:ee509900 r7:ee509a38 r6:ef0ff1c0 r5:00000000
>   r4:ee509a00
> [<c0057a88>] (kthread) from [<c000fdf0>] (ret_from_fork+0x14/0x24[  165.007974] [<c0528da0>] (od_dbs_update) from [<c0529c24>] (dbs_work_handler+0x38/0x60)
>   r10:00000001 r8:c0a5b424 r7:ee726000 r6:ebd79e44 r5:00000000 r4:ebd79ea8
> [<c0529bec>] (dbs_work_handler) from [<c0050958>] (process_one_work+0x1f0/0x6e0)
>   r8:ef7ccc00 r7:ee6b7f08 r6:ef7c9940 r5:ebd79ea8 r4:ee509900 r3:c0529bec
> [<c0050768>] (process_one_work) from [<c0050eb8>] (worker_thread+0x30/0x4c8)
>   r10:c09dd900 r9:ef7c9940 r8:ef7c9940 r7:00000008 r6:ee509918 r5:ef7c9974
>   r4:ee509900
> [<c0050e88>] (worker_thread) from [<c0057b90>] (kthread+0x108/0x140)
>   r10:c0050e88 r9:ef0f3e58 r8:ee509900 r7:ee509a38 r6:ef0ff1c0 r5:00000000
>   r4:ee509a00
> [<c0057a88>] (kthread) from [<c000fdf0>] (ret_from_fork+0x14/0x24)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0057a88
>   r4:ef0ff1c0 r3:ee6b6000
> ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> This happens because (a little more debugging - notably a dump_stack()
> in imx_media_free_dma_buf_ring()):
>
> CPU: 0 PID: 2322 Comm: v4l2src0:src Tainted: G         C      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Backtrace:
> [<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
>   r6:a0010013 r5:ffffffff r4:00000000 r3:00000000
> [<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
> [<c0333444>] (dump_stack) from [<bf0dc0b4>] (imx_media_free_dma_buf_ring+0x18/0x74 [imx_media_common])
>   r6:bf059540 r5:ffffffea r4:ee40ce00 r3:00000004
> [<bf0dc09c>] (imx_media_free_dma_buf_ring [imx_media_common]) from [<bf1590dc>] (camif_buf_prepare+0x9c/0x130 [imx_camif])
>   r5:ffffffea r4:d008f010
> [<bf159040>] (camif_buf_prepare [imx_camif]) from [<bf054b1c>] (__buf_prepare+0x130/0x1dc [videobuf2_core])
>   r6:bf059540 r5:d004f800 r4:00000000
> [<bf0549ec>] (__buf_prepare [videobuf2_core]) from [<bf054c20>] (vb2_core_qbuf+0x58/0x324 [videobuf2_core])
>   r6:e74b1e20 r5:d004f800 r4:d008f6b0
> [<bf054bc8>] (vb2_core_qbuf [videobuf2_core]) from [<bf068028>] (vb2_qbuf+0x58/0x80 [videobuf2_v4l2])
>   r10:c0a57704 r9:e74b1e20 r8:e7417140 r7:bf15977c r6:e974c980 r5:e74b1e20
>   r4:d008f6b0 r3:00000000
> [<bf067fd0>] (vb2_qbuf [videobuf2_v4l2]) from [<bf068098>] (vb2_ioctl_qbuf+0x48/0x4c [videobuf2_v4l2])
>   r5:e74b1e20 r4:e7417140
> [<bf068050>] (vb2_ioctl_qbuf [videobuf2_v4l2]) from [<c04f746c>] (v4l_qbuf+0x44/0x48)
>   r5:e74b1e20 r4:e7417140
> [<c04f7428>] (v4l_qbuf) from [<c04f4660>] (__video_do_ioctl+0x270/0x304)
>   r7:00000000 r6:e974c980 r5:d008f018 r4:c044560f
> [<c04f43f0>] (__video_do_ioctl) from [<c04f6b48>] (video_usercopy+0x12c/0x85c)
>   r10:00000000 r9:c04f43f0 r8:00000000 r7:e74b1e20 r6:b5408888 r5:00000000
>   r4:c044560f
> [<c04f6a1c>] (video_usercopy) from [<c04f7290>] (video_ioctl2+0x18/0x1c)
>   r10:d024e568 r9:e74b0000 r8:d008f64c r7:c044560f r6:b5408888 r5:e7417140
>   r4:d008f018
> [<c04f7278>] (video_ioctl2) from [<c04f1524>] (v4l2_ioctl+0xa4/0xc4)
> [<c04f1480>] (v4l2_ioctl) from [<c0188b6c>] (do_vfs_ioctl+0x98/0x9a0)
>   r8:b5408888 r7:0000000d r6:0000000d r5:e7417140 r4:c01894b0 r3:c04f1480
> [<c0188ad4>] (do_vfs_ioctl) from [<c01894b0>] (SyS_ioctl+0x3c/0x60)
>   r10:00000000 r9:e74b0000 r8:b5408888 r7:0000000d r6:c044560f r5:e7417140
>   r4:e7417141
> [<c0189474>] (SyS_ioctl) from [<c000fd60>] (ret_fast_syscall+0x0/0x1c)
>   r8:c000ff04 r7:00000036 r6:00066800 r5:b68fa000 r4:b540887c r3:00000000
>
> This is totally broken, and here's why.  Immediately before the above
> are these lines:
>
> [  114.120099] ipu1_smfc0: stream ON
> [  114.234338] imx6-mipi-csi2: stream ON
> [  114.258187] imx6-mipi-csi2: ready, dphy version 0x3130302a
> [  114.263767] imx6-mipi-csi2: stream ON
> [  114.267495] ipu1_csi0: stream ON
>
> At the "ipu1_smfc0" stream on message, smfc calls imx_smfc_start().
> imx_smfc_start() asks for the ring:
>
>          /* ask the sink for the buffer ring */
>          ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
>                                 IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
>                                 &priv->out_ring);
>
> camif provides the ring:
>
> static long camif_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>          case IMX_MEDIA_REQ_DMA_BUF_SINK_RING:
>                  if (!priv->in_ring)
>                          return -EINVAL;
>                  ring = (struct imx_media_dma_buf_ring **)arg;
>                  *ring = priv->in_ring;
>                  break;
>
> So, smfc contains a copy of the pointer to camif's priv->in_ring.
>
> Things continue, and we get to camif_buf_prepare():
>
> static int camif_buf_prepare(struct vb2_buffer *vb)
> {
> ...
>          if (!priv->in_ring) {
>                  priv->in_ring = imx_media_alloc_dma_buf_ring(
>                          priv->md, &priv->src_sd->entity, &priv->sd.entity,
>                          sizeimage, vq->num_buffers, false);
>                  if (IS_ERR(priv->in_ring)) {
>                          v4l2_err(&priv->sd, "failed to alloc dma-buf ring\n");
>                          ret = PTR_ERR(priv->in_ring);
>                          priv->in_ring = NULL;
>                          return ret;
>                  }
>          }
>
> Well, if we haven't setup priv->in_ring by now... is anything going to
> work?
>
> Then we do this:
>
>          ret = imx_media_dma_buf_queue_from_vb(priv->in_ring, vb);
>          if (ret)
>                  goto free_ring;
>
>          return 0;
>
> free_ring:
>          imx_media_free_dma_buf_ring(priv->in_ring);
>          priv->in_ring = NULL;
>          return ret;
>
> and for whatever reason we end up falling out through free_ring.  This
> is VERY bad news, because it means that the ring which SMFC took a copy
> of is now freed beneath its feet.

Yes, that is bad. That was a bug, if imx_media_dma_buf_queue_from_vb()
returned error, the ring should not have been freed, it should have only
returned the error. And further bad stuff happens from that point on.

But all of this is gone in version 4.

Steve

>
> It doesn't matter if you later reallocate it, it could very well end up
> with a different pointer from kmalloc().
>
> SMFC continues along unknowing that its priv->out_ring is now invalid, and
> it tries to use it as if it is still valid, leading to two things:
>
> 1. potentially stamping over memory that has been given to someone else
>     (possibly inodes, resulting in filesystem corruption should that
>      memory get written back to disk)
> 2. dereferencing pointers to other random memory leading to who-knows-what.
>
> and that is _very_ bad.
>
> This is way too serious a bug to justify any further testing.
>
> So here endeth my interest in this driver until a new set of patches
> appears for review. :p
>

