Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41749 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2KSSm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:42:59 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 188/493] staging: dt3155v4l: remove use of __devinit
Date: Mon, 19 Nov 2012 13:22:17 -0500
Message-Id: <1353349642-3677-188-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
Cc: devel@driverdev.osuosl.org 
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 15f7468..c8af551 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -718,7 +718,7 @@ static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 */
 };
 
-static int __devinit
+static int
 dt3155_init_board(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
@@ -836,7 +836,7 @@ struct dma_coherent_mem {
 	unsigned long	*bitmap;
 };
 
-static int __devinit
+static int
 dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
 {
 	struct dma_coherent_mem *mem;
@@ -891,7 +891,7 @@ dt3155_free_coherent(struct device *dev)
 	kfree(mem);
 }
 
-static int __devinit
+static int
 dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
-- 
1.8.0

