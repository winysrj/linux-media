Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37225 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754331Ab2FHL5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jun 2012 07:57:36 -0400
From: Albert Wang <twang13@marvell.com>
To: pawel@osciak.com, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH] media: videobuf2: fix kernel panic due to missing assign NULL to alloc_ctx
Date: Fri,  8 Jun 2012 19:55:11 +0800
Message-Id: <1339156511-16509-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  In function vb2_dma_contig_cleanup_ctx(), we only kfree the alloc_ctx
  If we didn't assign NULL to this point after kfree it,
  we may encounter the following kernel panic:

 kernel BUG at kernel/cred.c:98!
 Unable to handle kernel NULL pointer dereference at virtual address 00000000
 pgd = c0004000
 [00000000] *pgd=00000000
 Internal error: Oops: 817 [#1] PREEMPT SMP
 Modules linked in: runcase_sysfs galcore mv_wtm_drv mv_wtm_prim
 CPU: 0    Not tainted  (3.0.8+ #213)
 PC is at __bug+0x18/0x24
 LR is at __bug+0x14/0x24
 pc : [<c0054670>]    lr : [<c005466c>]    psr: 60000113
 sp : c0681ec0  ip : f683e000  fp : 00000000
 r10: e8ab4b58  r9 : 00000fff  r8 : 00000002
 r7 : e8665698  r6 : c10079ec  r5 : e8b13d80  r4 : e8b13d98
 r3 : 00000000  r2 : c0681eb4  r1 : c05c9ccc  r0 : 00000035
 Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
 Control: 10c53c7d  Table: 29c3406a  DAC: 00000015

  the root cause is we may encounter some i2c or HW issue with sensor
  which result in driver exit with exception during soc_camera_set_fmt()
  from soc_camera_open():

	ret = soc_camera_set_fmt(icd, &f);
	if (ret < 0)
		goto esfmt;

  it will call ici->ops->remove() in following code:

  esfmt:
	pm_runtime_disable(&icd->vdev->dev);
  eresume:
	ici->ops->remove(icd);

  ici->ops->remove() will call vb2_dma_contig_cleanup_ctx() for cleanup
  but we didn't do ici->ops->init_videobuf2() yet at that time
  it will result in kfree a non-NULL point twice

Change-Id: I1c66dd08438ae90abe555c52edcdbca0d39d829d
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/video/videobuf2-dma-contig.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 4b71326..9881171 100755
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -178,6 +178,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
 	kfree(alloc_ctx);
+	alloc_ctx = NULL;
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
-- 
1.7.0.4

