Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41341 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbcCOHFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 03:05:35 -0400
Date: Tue, 15 Mar 2016 10:05:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx23885: uninitialized variable in
 cx23885_av_work_handler()
Message-ID: <20160315070520.GB13560@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "handled" variable could be uninitialized if the
interrupt_service_routine() call back hasn't been implimented or if it
has been implemented but doesn't initialize "handled" to zero at the
start.  For example, adv76xx_isr() only sets "handled" to true.

Fixes: 44b153ca639f ('[media] m5mols: Add ISO sensitivity controls')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
index 877dad8..e7d4406 100644
--- a/drivers/media/pci/cx23885/cx23885-av.c
+++ b/drivers/media/pci/cx23885/cx23885-av.c
@@ -24,7 +24,7 @@ void cx23885_av_work_handler(struct work_struct *work)
 {
 	struct cx23885_dev *dev =
 			   container_of(work, struct cx23885_dev, cx25840_work);
-	bool handled;
+	bool handled = false;
 
 	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
 			 PCI_MSK_AV_CORE, &handled);
