Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:37732 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbbASKoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 05:44:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B01AC2A0080
	for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 11:44:32 +0100 (CET)
Message-ID: <54BCE010.9030800@xs4all.nl>
Date: Mon, 19 Jan 2015 11:44:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.19] cx23885: fix free interrupt bug
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First free the interrupt, then disable the PCI device. The other way
around will lead to this warning:

Jan 19 11:42:02 telek kernel: [ 1440.161234] WARNING: CPU: 0 PID: 2191 at kernel/irq/manage.c:1311 __free_irq+0x97/0x1f0()
Jan 19 11:42:02 telek kernel: [ 1440.161236] Trying to free already-free IRQ 0
Jan 19 11:42:02 telek kernel: [ 1440.161237] Modules linked in: tda8290 tda10048 cx25840 cx23885(-) altera_ci tda18271 altera_stapl videobuf2_dvb tveeprom cx2341x videobuf2_dma_sg dvb_core rc_core videobuf2_memops videobuf2_core v4l2_common videodev media nouveau x86_pkg_temp_thermal cfbfillrect cfbimgblt cfbcopyarea ttm drm_kms_helper processor button isci
Jan 19 11:42:02 telek kernel: [ 1440.161266] CPU: 0 PID: 2191 Comm: rmmod Tainted: G        W      3.19.0-rc1-telek #345
Jan 19 11:42:02 telek kernel: [ 1440.161268] Hardware name: ASUSTeK COMPUTER INC. Z9PE-D8 WS/Z9PE-D8 WS, BIOS 5404 02/10/2014
Jan 19 11:42:02 telek kernel: [ 1440.161270]  ffffffff81bf1fce ffff8808958b7cc8 ffffffff8194a97f 0000000000000000
Jan 19 11:42:02 telek kernel: [ 1440.161274]  ffff8808958b7d18 ffff8808958b7d08 ffffffff810c56b0 0000000000000286
Jan 19 11:42:02 telek kernel: [ 1440.161279]  0000000000000000 0000000000000000 ffff88089f808890 ffff88089f808800
Jan 19 11:42:02 telek kernel: [ 1440.161284] Call Trace:
Jan 19 11:42:02 telek kernel: [ 1440.161290]  [<ffffffff8194a97f>] dump_stack+0x4f/0x7b
Jan 19 11:42:02 telek kernel: [ 1440.161295]  [<ffffffff810c56b0>] warn_slowpath_common+0x80/0xc0
Jan 19 11:42:02 telek kernel: [ 1440.161299]  [<ffffffff810c5731>] warn_slowpath_fmt+0x41/0x50
Jan 19 11:42:02 telek kernel: [ 1440.161303]  [<ffffffff81955d36>] ? _raw_spin_lock_irqsave+0x56/0x70
Jan 19 11:42:02 telek kernel: [ 1440.161307]  [<ffffffff81114849>] ? __free_irq+0x49/0x1f0
Jan 19 11:42:02 telek kernel: [ 1440.161311]  [<ffffffff81114897>] __free_irq+0x97/0x1f0
Jan 19 11:42:02 telek kernel: [ 1440.161316]  [<ffffffff81114a88>] free_irq+0x48/0xd0
Jan 19 11:42:02 telek kernel: [ 1440.161323]  [<ffffffffa00e6deb>] cx23885_finidev+0x4b/0x90 [cx23885]
Jan 19 11:42:02 telek kernel: [ 1440.161329]  [<ffffffff814529fa>] pci_device_remove+0x3a/0xc0
Jan 19 11:42:02 telek kernel: [ 1440.161334]  [<ffffffff8153b4ea>] __device_release_driver+0x7a/0xf0
Jan 19 11:42:02 telek kernel: [ 1440.161338]  [<ffffffff8153bc98>] driver_detach+0xc8/0xd0
Jan 19 11:42:02 telek kernel: [ 1440.161341]  [<ffffffff8153b1de>] bus_remove_driver+0x4e/0xb0
Jan 19 11:42:02 telek kernel: [ 1440.161345]  [<ffffffff8153c2eb>] driver_unregister+0x2b/0x60
Jan 19 11:42:02 telek kernel: [ 1440.161349]  [<ffffffff814525c5>] pci_unregister_driver+0x25/0x70
Jan 19 11:42:02 telek kernel: [ 1440.161355]  [<ffffffffa00f6ddc>] cx23885_fini+0x10/0x12 [cx23885]
Jan 19 11:42:02 telek kernel: [ 1440.161360]  [<ffffffff81139a98>] SyS_delete_module+0x1a8/0x1f0
Jan 19 11:42:02 telek kernel: [ 1440.161364]  [<ffffffff819561a9>] system_call_fastpath+0x12/0x17
Jan 19 11:42:02 telek kernel: [ 1440.161367] ---[ end trace a9c07cb5f3357020 ]---

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 1d9d0f8..1ad4994 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2049,11 +2049,11 @@ static void cx23885_finidev(struct pci_dev *pci_dev)
 
 	cx23885_shutdown(dev);
 
-	pci_disable_device(pci_dev);
-
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	pci_disable_device(pci_dev);
+
 	cx23885_dev_unregister(dev);
 	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-- 
2.1.4

