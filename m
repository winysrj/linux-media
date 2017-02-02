Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34560 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdBBRbr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 12:31:47 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170202172245.GT27312@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <dab6756e-4f88-971b-2698-7bd6d34bb5d9@gmail.com>
Date: Thu, 2 Feb 2017 09:31:27 -0800
MIME-Version: 1.0
In-Reply-To: <20170202172245.GT27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

I don't recommend spending too much time debugging this
OOPS. The dma buffer ring has been removed completely
in version 4 (which I'm trying to get ready to post hopefully
by end of this week).

Steve


On 02/02/2017 09:22 AM, Russell King - ARM Linux wrote:
> I seem to be getting some sort of memory corruption with this driver.
>
> I've had two instances now of uninitialised spinlocks in
> imx_media_dma_buf_get_active() which show that the spinlock being
> taken in this function is all-zeros.
>
> That very quickly leads to an oops, where I've seen buf->ring is
> NULL in imx_media_dma_buf_set_active().
>
> Not quite sure what's going on, but the trigger (at least for me) is
> to change my gstreamer pipeline from:
>
> DISPLAY=:0 gst-launch-1.0 -v v4l2src device=/dev/video3 ! bayer2rgbneon ! xvimagesink
>
> to
>
> DISPLAY=:0 gst-launch-1.0 -v v4l2src device=/dev/video3 ! queue ! bayer2rgbneon ! xvimagesink
>
> and it seems to take as little as two or three attempts to provoke the
> kernel to totally die.
>
> I've just tried a third time.  I can run the first gstreamer command
> five times.  The I ran the second command and immediately got this:
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 0 PID: 1008 Comm: Xorg Tainted: G         C      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Backtrace:
> [<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
>   r6:600f0193 r5:ffffffff r4:00000000 r3:00000000
> [<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
> [<c0333444>] (dump_stack) from [<c0086af8>] (register_lock_class+0x1d4/0x554)
>   r6:c1400408 r5:00000000 r4:00000000 r3:ee47a4c0
> [<c0086924>] (register_lock_class) from [<c0089474>] (__lock_acquire+0x80/0x17b0)
>   r10:d995f760 r9:c0a70384 r8:00000000 r7:c0a38680 r6:00000000 r5:ee47a4c0
>   r4:c1400408
> [<c00893f4>] (__lock_acquire) from [<c008b108>] (lock_acquire+0xd8/0x250)
>   r10:00000000 r9:c0a70384 r8:00000000 r7:00000000 r6:d995f760 r5:600f0193
>   r4:00000000
> [<c008b030>] (lock_acquire) from [<c07016f4>] (_raw_spin_lock_irqsave+0x4c/0x60)
>   r10:ed501e64 r9:c09e04ec r8:00000000 r7:00000139 r6:bf0d7a8c r5:600f0193
>   r4:d995f750
> [<c07016a8>] (_raw_spin_lock_irqsave) from [<bf0d7a8c>] (imx_media_dma_buf_get_active+0x1c/0x94 [imx_media_common])
>   r6:e98b2c10 r5:d995f750 r4:d995f600
> [<bf0d7a70>] (imx_media_dma_buf_get_active [imx_media_common]) from [<bf12c4b8>] (imx_smfc_eof_interrupt+0x60/0x124 [imx_smfc])
>   r5:ee935dc4 r4:ee935c10
> [<bf12c458>] (imx_smfc_eof_interrupt [imx_smfc]) from [<c009f5dc>] (__handle_irq_event_percpu+0xa4/0x428)
>   r6:e98b2c10 r5:e98b2c00 r4:ebfb6d40 r3:bf12c458
> [<c009f538>] (__handle_irq_event_percpu) from [<c009f984>] (handle_irq_event_percpu+0x24/0x60)
>   r10:ed501fb0 r9:f4001100 r8:00000009 r7:00000000 r6:e98b2c10 r5:e98b2c00
>   r4:e98b2c00
> [<c009f960>] (handle_irq_event_percpu) from [<c009fa00>] (handle_irq_event+0x40/0x64)
>   r5:e98b2c60 r4:e98b2c00
> [<c009f9c0>] (handle_irq_event) from [<c00a3174>] (handle_level_irq+0xb0/0x138)
>   r6:e98b2c10 r5:e98b2c60 r4:e98b2c00 r3:c09d0418
> [<c00a30c4>] (handle_level_irq) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:ee4a3010 r5:ed501f08 r4:00000000 r3:c00a30c4
> [<c009ecd0>] (generic_handle_irq) from [<c0409328>] (ipu_irq_handle+0xa8/0xd8)
> [<c0409280>] (ipu_irq_handle) from [<c0409458>] (ipu_irq_handler+0x5c/0xb4)
>   r8:ef008400 r7:00000026 r6:ee4a3010 r5:c09e756c r4:ef1efc10
> [<c04093fc>] (ipu_irq_handler) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:00000000 r5:00000000 r4:c09d52d0
> [<c009ecd0>] (generic_handle_irq) from [<c009ee24>] (__handle_domain_irq+0x5c/0xb8)
> [<c009edc8>] (__handle_domain_irq) from [<c00094c8>] (gic_handle_irq+0x4c/0x9c)
>   r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c r4:f4000100 r3:ed501fb0
> [<c000947c>] (gic_handle_irq) from [<c0014dd8>] (__irq_usr+0x58/0x80)
> Exception stack(0xed501fb0 to 0xed501ff8)
> 1fa0:                                     b698b4e0 00000000 0042c000 b698c708
> 1fc0: 00000010 81231b10 81231b18 80e89670 b698b4e0 8114957c 7f79b000 81149438
> 1fe0: 7f79b248 bee08b98 7f708609 b6904220 600f0030 ffffffff
>   r10:7f79b000 r9:8114957c r8:10c5387d r7:10c5387d r6:ffffffff r5:600f0030
>   r4:b6904220 r3:ee47a4c0
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1008 at /home/rmk/git/linux-rmk/drivers/staging/media/imx/imx-smfc.c:159 imx_smfc_eof_interrupt+0x118/0x124 [imx_smfc]
> Modules linked in: imx_csi(C) rfcomm bnep bluetooth nfsd imx_camif(C) imx_ic(C) imx_smfc(C) caam_jr snd_soc_imx_sgtl5000 uvcvideo snd_soc_fsl_asoc_card snd_soc_imx_spdif imx_media(C) imx_mipi_csi2(C) imx_media_common(C) snd_soc_imx_audmux imx219 snd_soc_sgtl5000 caam video_multiplexer imx_sdma imx2_wdt rc_cec snd_soc_fsl_ssi coda v4l2_mem2mem videobuf2_v4l2 videobuf2_dma_contig videobuf2_core snd_soc_fsl_spdif imx_pcm_dma videobuf2_vmalloc dw_hdmi_ahb_audio dw_hdmi_cec videobuf2_memops imx_thermal etnaviv fuse rc_pinnacle_pctv_hd
> CPU: 0 PID: 1008 Comm: Xorg Tainted: G         C      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Backtrace:
> [<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
>   r6:600f0193 r5:ffffffff r4:00000000 r3:00000000
> [<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
> [<c0333444>] (dump_stack) from [<c0033210>] (__warn+0xdc/0x108)
>   r6:bf12d004 r5:00000000 r4:00000000 r3:ee47a4c0
> [<c0033134>] (__warn) from [<c0033264>] (warn_slowpath_null+0x28/0x30)
>   r10:ed501e64 r8:00000000 r7:00000139 r6:e98b2c10 r5:ee935dc4 r4:ee935c10
> [<c003323c>] (warn_slowpath_null) from [<bf12c570>] (imx_smfc_eof_interrupt+0x118/0x124 [imx_smfc])
> [<bf12c458>] (imx_smfc_eof_interrupt [imx_smfc]) from [<c009f5dc>] (__handle_irq_event_percpu+0xa4/0x428)
>   r6:e98b2c10 r5:e98b2c00 r4:ebfb6d40 r3:bf12c458
> [<c009f538>] (__handle_irq_event_percpu) from [<c009f984>] (handle_irq_event_percpu+0x24/0x60)
>   r10:ed501fb0 r9:f4001100 r8:00000009 r7:00000000 r6:e98b2c10 r5:e98b2c00
>   r4:e98b2c00
> [<c009f960>] (handle_irq_event_percpu) from [<c009fa00>] (handle_irq_event+0x40/0x64)
>   r5:e98b2c60 r4:e98b2c00
> [<c009f9c0>] (handle_irq_event) from [<c00a3174>] (handle_level_irq+0xb0/0x138)
>   r6:e98b2c10 r5:e98b2c60 r4:e98b2c00 r3:c09d0418
> [<c00a30c4>] (handle_level_irq) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:ee4a3010 r5:ed501f08 r4:00000000 r3:c00a30c4
> [<c009ecd0>] (generic_handle_irq) from [<c0409328>] (ipu_irq_handle+0xa8/0xd8)
> [<c0409280>] (ipu_irq_handle) from [<c0409458>] (ipu_irq_handler+0x5c/0xb4)
>   r8:ef008400 r7:00000026 r6:ee4a3010 r5:c09e756c r4:ef1efc10
> [<c04093fc>] (ipu_irq_handler) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:00000000 r5:00000000 r4:c09d52d0
> [<c009ecd0>] (generic_handle_irq) from [<c009ee24>] (__handle_domain_irq+0x5c/0xb8)
> [<c009edc8>] (__handle_domain_irq) from [<c00094c8>] (gic_handle_irq+0x4c/0x9c)
>   r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c r4:f4000100 r3:ed501fb0
> [<c000947c>] (gic_handle_irq) from [<c0014dd8>] (__irq_usr+0x58/0x80)
> Exception stack(0xed501fb0 to 0xed501ff8)
> 1fa0:                                     b698b4e0 00000000 0042c000 b698c708
> 1fc0: 00000010 81231b10 81231b18 80e89670 b698b4e0 8114957c 7f79b000 81149438
> 1fe0: 7f79b248 bee08b98 7f708609 b6904220 600f0030 ffffffff
>   r10:7f79b000 r9:8114957c r8:10c5387d r7:10c5387d r6:ffffffff r5:600f0030
>   r4:b6904220 r3:ee47a4c0
> ---[ end trace 36356ae8b82a114e ]---
> Unable to handle kernel NULL pointer dereference at virtual address 00000154
> pgd = ed790000
> [00000154] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in: imx_csi(C) rfcomm bnep bluetooth nfsd imx_camif(C) imx_ic(C) imx_smfc(C) caam_jr snd_soc_imx_sgtl5000 uvcvideo snd_soc_fsl_asoc_card snd_soc_imx_spdif imx_media(C) imx_mipi_csi2(C) imx_media_common(C) snd_soc_imx_audmux imx219 snd_soc_sgtl5000 caam video_multiplexer imx_sdma imx2_wdt rc_cec snd_soc_fsl_ssi coda v4l2_mem2mem videobuf2_v4l2 videobuf2_dma_contig videobuf2_core snd_soc_fsl_spdif imx_pcm_dma videobuf2_vmalloc dw_hdmi_ahb_audio dw_hdmi_cec videobuf2_memops imx_thermal etnaviv fuse rc_pinnacle_pctv_hd
> CPU: 0 PID: 1008 Comm: Xorg Tainted: G        WC      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> task: ee47a4c0 task.stack: ed500000
> PC is at do_raw_spin_lock+0x10/0x1d0
> LR is at _raw_spin_lock_irqsave+0x54/0x60
> pc : [<c008df34>]    lr : [<c07016fc>]    psr: 600f0193
> sp : ed501d78  ip : ed501db0  fp : ed501dac
> r10: ed501e64  r9 : c09e04ec  r8 : 00000000
> r7 : 00000139  r6 : bf0d7bc8  r5 : 600f0193  r4 : 00000150
> r3 : ee47a4c0  r2 : 00000000  r1 : ed501d58  r0 : 00000150
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: 3d79004a  DAC: 00000051
> Process Xorg (pid: 1008, stack limit = 0xed500210)
> Stack: (0xed501d78 to 0xed502000)
> 1d60:                                                       c011ad20 c09e04ec
> 1d80: c00867fc 00000150 600f0193 bf0d7bc8 00000139 00000000 c09e04ec ed501e64
> 1da0: ed501ddc ed501db0 c07016fc c008df30 00000001 00000000 bf0d7bc8 bf12c570
> 1dc0: ee935c10 d995f724 00000150 00000124 ed501dfc ed501de0 bf0d7bc8 c07016b4
> 1de0: ee935c10 ee935dc4 e98b2c10 00000139 ed501e1c ed501e00 bf12c4d0 bf0d7bb0
> 1e00: bf12c458 ebfb6d40 e98b2c00 e98b2c10 ed501e5c ed501e20 c009f5dc bf12c464
> 1e20: 00000001 c09e04ec 00000000 e98b2c00 c009f9f8 e98b2c00 e98b2c00 e98b2c10
> 1e40: 00000000 00000009 f4001100 ed501fb0 ed501e7c ed501e60 c009f984 c009f544
> 1e60: c0701d10 00000000 e98b2c00 e98b2c60 ed501e9c ed501e80 c009fa00 c009f96c
> 1e80: c09d0418 e98b2c00 e98b2c60 e98b2c10 ed501ebc ed501ea0 c00a3174 c009f9cc
> 1ea0: c00a30c4 00000000 ed501f08 ee4a3010 ed501ecc ed501ec0 c009ecf0 c00a30d0
> 1ec0: ed501efc ed501ed0 c0409328 c009ecdc c09d0448 00000001 0000003d ef1efc10
> 1ee0: c09e756c ee4a3010 00000026 ef008400 ed501f44 ed501f00 c0409458 c040928c
> 1f00: 00000001 00000000 00000001 00000002 00000003 0000000a 0000000b 0000000c
> 1f20: 0000000d 0000000e ed501f44 c09d52d0 00000000 00000000 ed501f54 ed501f48
> 1f40: c009ecf0 c0409408 ed501f7c ed501f58 c009ee24 c009ecdc ed501fb0 f4000100
> 1f60: f400010c c09e0af0 000003eb c0a38a78 ed501fac ed501f80 c00094c8 c009edd4
> 1f80: ee47a4c0 b6904220 600f0030 ffffffff 10c5387d 10c5387d 8114957c 7f79b000
> 1fa0: 00000000 ed501fb0 c0014dd8 c0009488 b698b4e0 00000000 0042c000 b698c708
> 1fc0: 00000010 81231b10 81231b18 80e89670 b698b4e0 8114957c 7f79b000 81149438
> 1fe0: 7f79b248 bee08b98 7f708609 b6904220 600f0030 ffffffff 00000000 00000000
> Backtrace:
> [<c008df24>] (do_raw_spin_lock) from [<c07016fc>] (_raw_spin_lock_irqsave+0x54/0x60)
>   r10:ed501e64 r9:c09e04ec r8:00000000 r7:00000139 r6:bf0d7bc8 r5:600f0193
>   r4:00000150
> [<c07016a8>] (_raw_spin_lock_irqsave) from [<bf0d7bc8>] (imx_media_dma_buf_set_active+0x24/0x68 [imx_media_common])
>   r6:00000124 r5:00000150 r4:d995f724
> [<bf0d7ba4>] (imx_media_dma_buf_set_active [imx_media_common]) from [<bf12c4d0>] (imx_smfc_eof_interrupt+0x78/0x124 [imx_smfc])
>   r7:00000139 r6:e98b2c10 r5:ee935dc4 r4:ee935c10
> [<bf12c458>] (imx_smfc_eof_interrupt [imx_smfc]) from [<c009f5dc>] (__handle_irq_event_percpu+0xa4/0x428)
>   r6:e98b2c10 r5:e98b2c00 r4:ebfb6d40 r3:bf12c458
> [<c009f538>] (__handle_irq_event_percpu) from [<c009f984>] (handle_irq_event_percpu+0x24/0x60)
>   r10:ed501fb0 r9:f4001100 r8:00000009 r7:00000000 r6:e98b2c10 r5:e98b2c00
>   r4:e98b2c00
> [<c009f960>] (handle_irq_event_percpu) from [<c009fa00>] (handle_irq_event+0x40/0x64)
>   r5:e98b2c60 r4:e98b2c00
> [<c009f9c0>] (handle_irq_event) from [<c00a3174>] (handle_level_irq+0xb0/0x138)
>   r6:e98b2c10 r5:e98b2c60 r4:e98b2c00 r3:c09d0418
> [<c00a30c4>] (handle_level_irq) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:ee4a3010 r5:ed501f08 r4:00000000 r3:c00a30c4
> [<c009ecd0>] (generic_handle_irq) from [<c0409328>] (ipu_irq_handle+0xa8/0xd8)
> [<c0409280>] (ipu_irq_handle) from [<c0409458>] (ipu_irq_handler+0x5c/0xb4)
>   r8:ef008400 r7:00000026 r6:ee4a3010 r5:c09e756c r4:ef1efc10
> [<c04093fc>] (ipu_irq_handler) from [<c009ecf0>] (generic_handle_irq+0x20/0x30)
>   r6:00000000 r5:00000000 r4:c09d52d0
> [<c009ecd0>] (generic_handle_irq) from [<c009ee24>] (__handle_domain_irq+0x5c/0xb8)
> [<c009edc8>] (__handle_domain_irq) from [<c00094c8>] (gic_handle_irq+0x4c/0x9c)
>   r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c r4:f4000100 r3:ed501fb0
> [<c000947c>] (gic_handle_irq) from [<c0014dd8>] (__irq_usr+0x58/0x80)
> Exception stack(0xed501fb0 to 0xed501ff8)
> 1fa0:                                     b698b4e0 00000000 0042c000 b698c708
> 1fc0: 00000010 81231b10 81231b18 80e89670 b698b4e0 8114957c 7f79b000 81149438
> 1fe0: 7f79b248 bee08b98 7f708609 b6904220 600f0030 ffffffff
>   r10:7f79b000 r9:8114957c r8:10c5387d r7:10c5387d r6:ffffffff r5:600f0030
>   r4:b6904220 r3:ee47a4c0
> Code: e1a0c00d e92ddff0 e24cb004 e24dd00c (e5902004)
> ---[ end trace 36356ae8b82a114f ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> CPU1: stopping
> CPU: 1 PID: 91 Comm: kworker/1:1 Tainted: G      D WC      4.10.0-rc6+ #2103
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: events dbs_work_handler
> Backtrace:
> [<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
>   r6:60010193 r5:ffffffff r4:00000000 r3:ee6b8000
> [<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
> [<c0333444>] (dump_stack) from [<c0016a68>] (handle_IPI+0x1b4/0x364)
>   r6:c0a70028 r5:00000001 r4:00000004 r3:ee6b8000
> [<c00168b4>] (handle_IPI) from [<c000950c>] (gic_handle_irq+0x90/0x9c)
>   r10:ee6b5ba8 r9:f4001100 r8:c0a38a78 r7:000003eb r6:c09e0af0 r5:f400010c
>   r4:f4000100
> [<c000947c>] (gic_handle_irq) from [<c00149f0>] (__irq_svc+0x70/0x98)
> Exception stack(0xee6b5ba8 to 0xee6b5bf0)
> 5ba0:                   00000000 00000004 00000003 00000003 00000001 ee6b5d2c
> 5bc0: c00177e8 00000000 00000001 ee6b5d2c 00000000 ee6b5c24 c09e0af4 ee6b5bf8
> 5be0: c0360f2c c00cd3a0 00010013 ffffffff
>   r10:00000000 r9:ee6b4000 r8:00000001 r7:ee6b5bdc r6:ffffffff r5:00010013
>   r4:c00cd3a0 r3:ee6b8000
> [<c00cd2a4>] (smp_call_function_single) from [<c00cd668>] (smp_call_function_many+0x270/0x2bc)
>   r7:c09e04ec r6:c09e04ec r5:00000001 r4:c09e05c8
> [<c00cd3f8>] (smp_call_function_many) from [<c00cd818>] (smp_call_function+0x30/0x38)
>   r10:00000002 r9:ffffffff r8:00000002 r7:ee6b5d2c r6:c00177e8 r5:00000000
>   r4:ffffffff
> [<c00cd7e8>] (smp_call_function) from [<c00cd860>] (on_each_cpu+0x18/0x58)
> [<c00cd848>] (on_each_cpu) from [<c0017890>] (twd_rate_change+0x2c/0x38)
>   r7:ee6b5d24 r6:00000000 r5:00000000 r4:ffffffff
> [<c0017864>] (twd_rate_change) from [<c00593a4>] (notifier_call_chain+0x4c/0x8c)
> [<c0059358>] (notifier_call_chain) from [<c00596b8>] (__srcu_notifier_call_chain+0x78/0xac)
>   r8:ee6b5d24 r7:00000000 r6:ef0069e4 r5:ef006948 r4:ef006904 r3:ffffffff
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
>   r10:ee592100 r9:001312d0 r8:3b5dc100 r7:000c15c0 r6:000f32a0 r5:00000002
>   r4:c141d574
> [<c0389724>] (clk_set_parent) from [<c052ab7c>] (imx6q_set_target+0x258/0x52c)
> [<c052a924>] (imx6q_set_target) from [<c0525360>] (__cpufreq_driver_target+0x150/0x528)
>   r10:000f32a0 r9:00000000 r8:00000001 r7:c141d424 r6:00000002 r5:00000000
>   r4:ee843800
> [<c0525210>] (__cpufreq_driver_target) from [<c0528e84>] (od_dbs_update+0xe4/0x168)
>   r10:e9b77fc0 r9:c09e04ec r8:ee862480 r7:ee843800 r6:ee862000 r5:ee862480
>   r4:ee862000
> [<c0528da0>] (od_dbs_update) from [<c0529c24>] (dbs_work_handler+0x38/0x60)
>   r10:00000001 r8:c0a5b424 r7:ee843800 r6:ee862004 r5:00000000 r4:ee862068
> [<c0529bec>] (dbs_work_handler) from [<c0050958>] (process_one_work+0x1f0/0x6e0)
>   r8:ef7ccc00 r7:ee6b5f08 r6:ef7c9940 r5:ee862068 r4:ef101e00 r3:c0529bec
> [<c0050768>] (process_one_work) from [<c0050eb8>] (worker_thread+0x30/0x4c8)
>   r10:c09dd900 r9:ef7c9940 r8:ef7c9940 r7:00000008 r6:ef101e18 r5:ef7c9974
>   r4:ef101e00
> [<c0050e88>] (worker_thread) from [<c0057b90>] (kthread+0x108/0x140)
>   r10:c0050e88 r9:ef0f3e58 r8:ef101e00 r7:ef101f38 r6:ef0ffa40 r5:00000000
>   r4:ef101f00
> [<c0057a88>] (kthread) from [<c000fdf0>] (ret_from_fork+0x14/0x24)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0057a88
>   r4:ef0ffa40 r3:ee6b4000
> ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> I thought, maybe, it's the IPU overwriting past the end of the buffer,
> but I've added checks and that doesn't seem to have fired.  I also
> wondered if it was some kind of use-after-free of the ring, so I made
> imx_media_free_dma_buf_ring() memset the ring to 0x5a5a5a5a before
> kfree()ing it... doesn't look like it's that either.  I'm going to
> continue poking to see if I can figure out what's going on.
>
> The oops at 0x00000154 is due to "ring" in imx_media_dma_buf_set_active()
> being NULL.  "buf" in that instance (contained in r4) is 0xd995f724.
>
> I'm just seeing if I can track that down by adding
>
> 	WARN_ON(buf->ring != priv->out_ring);
>
> in imx-smfc.

