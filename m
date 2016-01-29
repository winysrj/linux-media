Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/13] [media] xc2028: avoid use after free
Date: Fri, 29 Jan 2016 10:10:52 -0200
Message-Id: <1dbb08b6e06915101abde7eaf3ea407357b7e441.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If struct xc2028_config is passed without a firmware name,
the following trouble may happen:

[11009.907205] xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
[11009.907491] ==================================================================
[11009.907750] BUG: KASAN: use-after-free in strcmp+0x96/0xb0 at addr ffff8803bd78ab40
[11009.907992] Read of size 1 by task modprobe/28992
[11009.907994] =============================================================================
[11009.907997] BUG kmalloc-16 (Tainted: G        W      ): kasan: bad access detected
[11009.907999] -----------------------------------------------------------------------------

[11009.908008] INFO: Allocated in xhci_urb_enqueue+0x214/0x14c0 [xhci_hcd] age=0 cpu=3 pid=28992
[11009.908012] 	___slab_alloc+0x581/0x5b0
[11009.908014] 	__slab_alloc+0x51/0x90
[11009.908017] 	__kmalloc+0x27b/0x350
[11009.908022] 	xhci_urb_enqueue+0x214/0x14c0 [xhci_hcd]
[11009.908026] 	usb_hcd_submit_urb+0x1e8/0x1c60
[11009.908029] 	usb_submit_urb+0xb0e/0x1200
[11009.908032] 	usb_serial_generic_write_start+0xb6/0x4c0
[11009.908035] 	usb_serial_generic_write+0x92/0xc0
[11009.908039] 	usb_console_write+0x38a/0x560
[11009.908045] 	call_console_drivers.constprop.14+0x1ee/0x2c0
[11009.908051] 	console_unlock+0x40d/0x900
[11009.908056] 	vprintk_emit+0x4b4/0x830
[11009.908061] 	vprintk_default+0x1f/0x30
[11009.908064] 	printk+0x99/0xb5
[11009.908067] 	kasan_report_error+0x10a/0x550
[11009.908070] 	__asan_report_load1_noabort+0x43/0x50
[11009.908074] INFO: Freed in xc2028_set_config+0x90/0x630 [tuner_xc2028] age=1 cpu=3 pid=28992
[11009.908077] 	__slab_free+0x2ec/0x460
[11009.908080] 	kfree+0x266/0x280
[11009.908083] 	xc2028_set_config+0x90/0x630 [tuner_xc2028]
[11009.908086] 	xc2028_attach+0x310/0x8a0 [tuner_xc2028]
[11009.908090] 	em28xx_attach_xc3028.constprop.7+0x1f9/0x30d [em28xx_dvb]
[11009.908094] 	em28xx_dvb_init.part.3+0x8e4/0x5cf4 [em28xx_dvb]
[11009.908098] 	em28xx_dvb_init+0x81/0x8a [em28xx_dvb]
[11009.908101] 	em28xx_register_extension+0xd9/0x190 [em28xx]
[11009.908105] 	em28xx_dvb_register+0x10/0x1000 [em28xx_dvb]
[11009.908108] 	do_one_initcall+0x141/0x300
[11009.908111] 	do_init_module+0x1d0/0x5ad
[11009.908114] 	load_module+0x6666/0x9ba0
[11009.908117] 	SyS_finit_module+0x108/0x130
[11009.908120] 	entry_SYSCALL_64_fastpath+0x16/0x76
[11009.908123] INFO: Slab 0xffffea000ef5e280 objects=25 used=25 fp=0x          (null) flags=0x2ffff8000004080
[11009.908126] INFO: Object 0xffff8803bd78ab40 @offset=2880 fp=0x0000000000000001

[11009.908130] Bytes b4 ffff8803bd78ab30: 01 00 00 00 2a 07 00 00 9d 28 00 00 01 00 00 00  ....*....(......
[11009.908133] Object ffff8803bd78ab40: 01 00 00 00 00 00 00 00 b0 1d c3 6a 00 88 ff ff  ...........j....
[11009.908137] CPU: 3 PID: 28992 Comm: modprobe Tainted: G    B   W       4.5.0-rc1+ #43
[11009.908140] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[11009.908142]  ffff8803bd78a000 ffff8802c273f1b8 ffffffff81932007 ffff8803c6407a80
[11009.908148]  ffff8802c273f1e8 ffffffff81556759 ffff8803c6407a80 ffffea000ef5e280
[11009.908153]  ffff8803bd78ab40 dffffc0000000000 ffff8802c273f210 ffffffff8155ccb4
[11009.908158] Call Trace:
[11009.908162]  [<ffffffff81932007>] dump_stack+0x4b/0x64
[11009.908165]  [<ffffffff81556759>] print_trailer+0xf9/0x150
[11009.908168]  [<ffffffff8155ccb4>] object_err+0x34/0x40
[11009.908171]  [<ffffffff8155f260>] kasan_report_error+0x230/0x550
[11009.908175]  [<ffffffff81237d71>] ? trace_hardirqs_off_caller+0x21/0x290
[11009.908179]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
[11009.908182]  [<ffffffff8155f5c3>] __asan_report_load1_noabort+0x43/0x50
[11009.908185]  [<ffffffff8155ea00>] ? __asan_register_globals+0x50/0xa0
[11009.908189]  [<ffffffff8194cea6>] ? strcmp+0x96/0xb0
[11009.908192]  [<ffffffff8194cea6>] strcmp+0x96/0xb0
[11009.908196]  [<ffffffffa13ba4ac>] xc2028_set_config+0x15c/0x630 [tuner_xc2028]
[11009.908200]  [<ffffffffa13bac90>] xc2028_attach+0x310/0x8a0 [tuner_xc2028]
[11009.908203]  [<ffffffff8155ea78>] ? memset+0x28/0x30
[11009.908206]  [<ffffffffa13ba980>] ? xc2028_set_config+0x630/0x630 [tuner_xc2028]
[11009.908211]  [<ffffffffa157a59a>] em28xx_attach_xc3028.constprop.7+0x1f9/0x30d [em28xx_dvb]
[11009.908215]  [<ffffffffa157aa2a>] ? em28xx_dvb_init.part.3+0x37c/0x5cf4 [em28xx_dvb]
[11009.908219]  [<ffffffffa157a3a1>] ? hauppauge_hvr930c_init+0x487/0x487 [em28xx_dvb]
[11009.908222]  [<ffffffffa01795ac>] ? lgdt330x_attach+0x1cc/0x370 [lgdt330x]
[11009.908226]  [<ffffffffa01793e0>] ? i2c_read_demod_bytes.isra.2+0x210/0x210 [lgdt330x]
[11009.908230]  [<ffffffff812e87d0>] ? ref_module.part.15+0x10/0x10
[11009.908233]  [<ffffffff812e56e0>] ? module_assert_mutex_or_preempt+0x80/0x80
[11009.908238]  [<ffffffffa157af92>] em28xx_dvb_init.part.3+0x8e4/0x5cf4 [em28xx_dvb]
[11009.908242]  [<ffffffffa157a6ae>] ? em28xx_attach_xc3028.constprop.7+0x30d/0x30d [em28xx_dvb]
[11009.908245]  [<ffffffff8195222d>] ? string+0x14d/0x1f0
[11009.908249]  [<ffffffff8195381f>] ? symbol_string+0xff/0x1a0
[11009.908253]  [<ffffffff81953720>] ? uuid_string+0x6f0/0x6f0
[11009.908257]  [<ffffffff811a775e>] ? __kernel_text_address+0x7e/0xa0
[11009.908260]  [<ffffffff8104b02f>] ? print_context_stack+0x7f/0xf0
[11009.908264]  [<ffffffff812e9846>] ? __module_address+0xb6/0x360
[11009.908268]  [<ffffffff8137fdc9>] ? is_ftrace_trampoline+0x99/0xe0
[11009.908271]  [<ffffffff811a775e>] ? __kernel_text_address+0x7e/0xa0
[11009.908275]  [<ffffffff81240a70>] ? debug_check_no_locks_freed+0x290/0x290
[11009.908278]  [<ffffffff8104a24b>] ? dump_trace+0x11b/0x300
[11009.908282]  [<ffffffffa13e8143>] ? em28xx_register_extension+0x23/0x190 [em28xx]
[11009.908285]  [<ffffffff81237d71>] ? trace_hardirqs_off_caller+0x21/0x290
[11009.908289]  [<ffffffff8123ff56>] ? trace_hardirqs_on_caller+0x16/0x590
[11009.908292]  [<ffffffff812404dd>] ? trace_hardirqs_on+0xd/0x10
[11009.908296]  [<ffffffffa13e8143>] ? em28xx_register_extension+0x23/0x190 [em28xx]
[11009.908299]  [<ffffffff822dcbb0>] ? mutex_trylock+0x400/0x400
[11009.908302]  [<ffffffff810021a1>] ? do_one_initcall+0x131/0x300
[11009.908306]  [<ffffffff81296dc7>] ? call_rcu_sched+0x17/0x20
[11009.908309]  [<ffffffff8159e708>] ? put_object+0x48/0x70
[11009.908314]  [<ffffffffa1579f11>] em28xx_dvb_init+0x81/0x8a [em28xx_dvb]
[11009.908317]  [<ffffffffa13e81f9>] em28xx_register_extension+0xd9/0x190 [em28xx]
[11009.908320]  [<ffffffffa0150000>] ? 0xffffffffa0150000
[11009.908324]  [<ffffffffa0150010>] em28xx_dvb_register+0x10/0x1000 [em28xx_dvb]
[11009.908327]  [<ffffffff810021b1>] do_one_initcall+0x141/0x300
[11009.908330]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
[11009.908333]  [<ffffffff8123ff56>] ? trace_hardirqs_on_caller+0x16/0x590
[11009.908337]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
[11009.908340]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
[11009.908343]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
[11009.908346]  [<ffffffff8155ea37>] ? __asan_register_globals+0x87/0xa0
[11009.908350]  [<ffffffff8144da7b>] do_init_module+0x1d0/0x5ad
[11009.908353]  [<ffffffff812f2626>] load_module+0x6666/0x9ba0
[11009.908356]  [<ffffffff812e9c90>] ? symbol_put_addr+0x50/0x50
[11009.908361]  [<ffffffffa1580037>] ? em28xx_dvb_init.part.3+0x5989/0x5cf4 [em28xx_dvb]
[11009.908366]  [<ffffffff812ebfc0>] ? module_frob_arch_sections+0x20/0x20
[11009.908369]  [<ffffffff815bc940>] ? open_exec+0x50/0x50
[11009.908374]  [<ffffffff811671bb>] ? ns_capable+0x5b/0xd0
[11009.908377]  [<ffffffff812f5e58>] SyS_finit_module+0x108/0x130
[11009.908379]  [<ffffffff812f5d50>] ? SyS_init_module+0x1f0/0x1f0
[11009.908383]  [<ffffffff81004044>] ? lockdep_sys_exit_thunk+0x12/0x14
[11009.908394]  [<ffffffff822e6936>] entry_SYSCALL_64_fastpath+0x16/0x76
[11009.908396] Memory state around the buggy address:
[11009.908398]  ffff8803bd78aa00: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[11009.908401]  ffff8803bd78aa80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[11009.908403] >ffff8803bd78ab00: fc fc fc fc fc fc fc fc 00 00 fc fc fc fc fc fc
[11009.908405]                                            ^
[11009.908407]  ffff8803bd78ab80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[11009.908409]  ffff8803bd78ac00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[11009.908411] ==================================================================

In order to avoid it, let's set the cached value of the firmware
name to NULL after freeing it. While here, return an error if
the memory allocation fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 4e941f00b600..ae0ac3047c17 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1393,7 +1393,7 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	struct xc2028_ctrl *p    = priv_cfg;
 	int                 rc   = 0;
 
-	tuner_dbg("%s called\n", __func__);
+	tuner_dbg("%s called, fname = %p\n", __func__, priv->ctrl.fname);
 
 	mutex_lock(&priv->lock);
 
@@ -1403,11 +1403,12 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	 * in order to avoid troubles during device release.
 	 */
 	kfree(priv->ctrl.fname);
+	priv->ctrl.fname = NULL;
 	memcpy(&priv->ctrl, p, sizeof(priv->ctrl));
 	if (p->fname) {
 		priv->ctrl.fname = kstrdup(p->fname, GFP_KERNEL);
 		if (priv->ctrl.fname == NULL)
-			rc = -ENOMEM;
+			return -ENOMEM;
 	}
 
 	/*
-- 
2.5.0


