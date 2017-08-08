Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38116 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbdHHL1S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 07:27:18 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/5] media: platform: s5p-jpeg: Fix crash in jpeg isr due to
 multiple interrupts.
Date: Tue, 08 Aug 2017 13:27:04 +0200
Message-id: <1502191628-11958-1-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
References: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
 <CGME20170808112715eucas1p264001c0fd86af71f3d06d6ece23db857@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

In case of corrupt images, multiple interrupts may occur
due to different error scenarios.

Since we are removing the src and dest buffers in the first
interrupt itself, crash occurs in the second error interrupts.

Disable the global interrupt before we start processing
the interrupt avoid the crash.

Disable System interrupt in isr to avoid the crash below.

Unable to handle kernel NULL pointer dereference at virtual address 000000c8
pgd = ffffffc0007db000
[000000c8] *pgd=00000000fb006003, *pud=00000000fb006003, *pmd=00000000fb007003, *pte=0060000011001707
Internal error: Oops: 96000007 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-next-20141210+ #22
Hardware name: Samsung Exynos7 Espresso board based on EXYNOS7 (DT)
task: ffffffc00075e5c0 ti: ffffffc00074c000 task.ti: ffffffc00074c000
PC is at exynos4_jpeg_irq+0x30/0x15c
LR is at exynos4_jpeg_irq+0x2c/0x15c
pc : [<ffffffc00040873c>] lr : [<ffffffc000408738>] pstate: 800001c5
sp : ffffffc00074fc60
x29: ffffffc00074fc60 x28: 0000004040000000
x27: ffffffc000673928 x26: ffffffc000673940
x25: ffffffc0007a030c x24: ffffffc0bb20a400
x23: 0000000000000030 x22: ffffffc0ba56ba40
x21: 0000000000000000 x20: 0000000000000000
x19: ffffffc0ba56ba18 x18: 0000000000000000
x17: 0000000000000000 x16: ffffffc00018b508
x15: 0000000000000000 x14: 0000000000000000
x13: 0098968000000000 x12: 0000000000989680
x11: 0000000000000004 x10: 0101010101010101
x9 : 00000020a285a9ea x8 : ffffffc0007af880
x7 : ffffffc0bac001a8 x6 : ffffffc0bac00000
x5 : 00000000fffffffa x4 : ffffffc00040870c
x3 : 0000000000000003 x2 : 0000000000010003
x1 : 0000000000010002 x0 : 0000000000000000

Process swapper/0 (pid: 0, stack limit = 0xffffffc00074c058)
Stack: (0xffffffc00074fc60 to 0xffffffc000750000)
fc60: 0074fca0 ffffffc0 000e4508 ffffffc0 bb225300 ffffffc0 bb20a494 ffffffc0
fc80: 00000000 00000000 00000000 00000000 00000030 00000000 000f8c6c ffffffc0
fca0: 0074fd00 ffffffc0 000e4644 ffffffc0 bb20a400 ffffffc0 bb20a494 ffffffc0
fcc0: 00776a00 ffffffc0 00670da8 ffffffc0 00000000 00000000 00000001 00000000
fce0: bb008000 ffffffc0 407db000 00000000 00081230 ffffffc0 000e4638 ffffffc0
fd00: 0074fd40 ffffffc0 000e7338 ffffffc0 bb20a400 ffffffc0 bb20a494 ffffffc0
fd20: 00776a00 ffffffc0 000e7280 ffffffc0 bb225300 ffffffc0 000e72e0 ffffffc0
fd40: 0074fd70 ffffffc0 000e3d60 ffffffc0 00000030 00000000 00743000 ffffffc0
fd60: 0066e000 ffffffc0 006c2000 ffffffc0 0074fd90 ffffffc0 000e3e90 ffffffc0
fd80: 007437c8 ffffffc0 000e3e6c ffffffc0 0074fdf0 ffffffc0 00082404 ffffffc0
fda0: 0074fe20 ffffffc0 0075a000 ffffffc0 0000200c ffffff80 00002010 ffffff80
fdc0: 60000145 00000000 00672cc8 ffffffc0 407d9000 00000000 befb9b40 ffffffc0
fde0: 0074fe20 ffffffc0 000001d2 00000000 0074ff40 ffffffc0 00085da8 ffffffc0
fe00: 00758584 ffffffc0 0052c000 ffffffc0 0074ff40 ffffffc0 00087114 ffffffc0
fe20: 00000000 00000000 0074ff50 ffffffc0 0067d760 ffffffc0 befb9adc ffffffc0
fe40: 00000001 00000000 d4414200 00000020 d6a39c00 00000020 007a6a18 ffffffc0
fe60: 0075eb00 ffffffc0 0074fd60 ffffffc0 ffffc185 00000000 00000020 00000000
fe80: 0052d340 ffffffc0 00000030 00000000 fffffffe 0fffffff 00000000 00000000
fea0: 0018b508 ffffffc0 00000000 00000000 00000000 00000000 00758584 ffffffc0
fec0: 0052c000 ffffffc0 006c24e8 ffffffc0 007a030a ffffffc0 00000001 00000000
fee0: 00672cc8 ffffffc0 407d9000 00000000 407db000 00000000 00081230 ffffffc0
ff00: 40000000 00000040 0074ff40 ffffffc0 00087110 ffffffc0 0074ff40 ffffffc0
ff20: 00087114 ffffffc0 60000145 00000000 00758584 ffffffc0 0052c000 ffffffc0
ff40: 0074ff50 ffffffc0 000db568 ffffffc0 0074ff90 ffffffc0 00515fdc ffffffc0
ff60: 00758000 ffffffc0 007a3000 ffffffc0 007a3000 ffffffc0 befc8940 ffffffc0
ff80: 40760000 00000000 40000000 00000000 0074ffb0 ffffffc0 006ff998 ffffffc0
ffa0: 00000002 00000000 006ff988 ffffffc0 00000000 00000000 400826c0 00000000
ffc0: 8f03a688 00000000 00000e11 00000000 48000000 00000000 410fd030 00000000
ffe0: 0072c250 ffffffc0 00000000 00000000 00000000 00000000 00000000 00000000
Call trace:
[<ffffffc00040873c>] exynos4_jpeg_irq+0x30/0x15c
[<ffffffc0000e4504>] handle_irq_event_percpu+0x6c/0x160
[<ffffffc0000e4640>] handle_irq_event+0x48/0x78
[<ffffffc0000e7334>] handle_fasteoi_irq+0xe0/0x198
[<ffffffc0000e3d5c>] generic_handle_irq+0x24/0x40
[<ffffffc0000e3e8c>] __handle_domain_irq+0x80/0xf0
[<ffffffc000082400>] gic_handle_irq+0x30/0x80
Exception stack(0xffffffc00074fe00 to 0xffffffc00074ff20)
fe00: 00758584 ffffffc0 0052c000 ffffffc0 0074ff40 ffffffc0 00087114 ffffffc0
fe20: 00000000 00000000 0074ff50 ffffffc0 0067d760 ffffffc0 befb9adc ffffffc0
fe40: 00000001 00000000 d4414200 00000020 d6a39c00 00000020 007a6a18 ffffffc0
fe60: 0075eb00 ffffffc0 0074fd60 ffffffc0 ffffc185 00000000 00000020 00000000
fe80: 0052d340 ffffffc0 00000030 00000000 fffffffe 0fffffff 00000000 00000000
fea0: 0018b508 ffffffc0 00000000 00000000 00000000 00000000 00758584 ffffffc0
fec0: 0052c000 ffffffc0 006c24e8 ffffffc0 007a030a ffffffc0 00000001 00000000
fee0: 00672cc8 ffffffc0 407d9000 00000000 407db000 00000000 00081230 ffffffc0
ff00: 40000000 00000040 0074ff40 ffffffc0 00087110 ffffffc0 0074ff40 ffffffc0
[<ffffffc000085da4>] el1_irq+0x64/0xd8
[<ffffffc0000db564>] cpu_startup_entry+0x118/0x168
[<ffffffc000515fd8>] rest_init+0x7c/0x88
[<ffffffc0006ff994>] start_kernel+0x3a8/0x3bc
Code: 94045c34 f9406e60 97ffdc74 aa0003f4 (f9406400)
---[ end trace fa6dc0ea2efad21f ]---
Kernel panic - not syncing: Fatal exception in interrupt
---[ end Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d1e3ebb..e276bd5 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2259,6 +2259,7 @@ static void exynos4_jpeg_device_run(void *priv)
 		exynos4_jpeg_set_dec_bitstream_size(jpeg->regs, bitstream_size);
 	}
 
+	exynos4_jpeg_set_sys_int_enable(jpeg->regs, 1);
 	exynos4_jpeg_set_enc_dec_mode(jpeg->regs, ctx->mode);
 
 	spin_unlock_irqrestore(&jpeg->slock, flags);
@@ -2662,6 +2663,8 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 
 	spin_lock(&jpeg->slock);
 
+	exynos4_jpeg_set_sys_int_enable(jpeg->regs, 0);
+
 	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
 
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
-- 
1.9.1
