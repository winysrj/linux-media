Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:47852 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0DGJVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 05:21:12 -0400
Date: Wed, 7 Apr 2010 12:21:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] davinci: don't return under lock on error path
Message-ID: <20100407092105.GC5157@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the kmalloc() failed for "ccdc_cfg = kmalloc(...);" then we would exit
with the lock held.  I moved the mutex_lock() below the allocation
because it isn't protecting anything in that block and allocations are 
allocations are sometimes slow.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 7cf042f..5c83f90 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1824,7 +1824,6 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		goto probe_free_dev_mem;
 	}
 
-	mutex_lock(&ccdc_lock);
 	/* Allocate memory for ccdc configuration */
 	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
 	if (NULL == ccdc_cfg) {
@@ -1833,6 +1832,8 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		goto probe_free_dev_mem;
 	}
 
+	mutex_lock(&ccdc_lock);
+
 	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
 	/* Get VINT0 irq resource */
 	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
