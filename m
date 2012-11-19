Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41504 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2KSSfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:19 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 482/493] staging: dt3155v4l: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:11 -0500
Message-Id: <1353349642-3677-482-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
Cc: devel@driverdev.osuosl.org 
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index c8af551..2389103 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -877,7 +877,7 @@ out:
 	return 0;
 }
 
-static void __devexit
+static void
 dt3155_free_coherent(struct device *dev)
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
@@ -956,7 +956,7 @@ err_video_device_alloc:
 	return err;
 }
 
-static void __devexit
+static void
 dt3155_remove(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
-- 
1.8.0

