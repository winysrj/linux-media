Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36698 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3DIFRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 01:17:46 -0400
Date: Tue, 9 Apr 2013 08:15:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dt3155v4l: unlock on error path
Message-ID: <20130409051540.GA1516@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should unlock here and do some cleanup before returning.

We can't actually hit this return path with the current code, so this
patch is a basically a cleanup and doesn't change how the code works.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 073b3b3..3da17bc 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -398,7 +398,7 @@ dt3155_open(struct file *filp)
 		pd->field_count = 0;
 		ret = vb2_queue_init(pd->q);
 		if (ret < 0)
-			return ret;
+			goto err_free_q;
 		INIT_LIST_HEAD(&pd->dmaq);
 		spin_lock_init(&pd->lock);
 		/* disable all irqs, clear all irq flags */
@@ -407,11 +407,11 @@ dt3155_open(struct file *filp)
 		ret = request_irq(pd->pdev->irq, dt3155_irq_handler_even,
 						IRQF_SHARED, DT3155_NAME, pd);
 		if (ret)
-			goto err_request_irq;
+			goto err_free_q;
 	}
 	pd->users++;
 	return 0; /* success */
-err_request_irq:
+err_free_q:
 	kfree(pd->q);
 	pd->q = NULL;
 err_alloc_queue:
