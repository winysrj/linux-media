Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54350 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3HUWZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 18:25:03 -0400
In-Reply-To: <20130821085201.3b29d4f8@samsung.com>
References: <20130821085201.3b29d4f8@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Fw: [PATCH] Fixed misleading error when handling IR interrupts.
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 21 Aug 2013 18:25:02 -0400
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Message-ID: <e16fe86a-c9bc-438e-8bad-f9c633ddc0a6@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>Date: Thu, 11 Jul 2013 17:02:44 +0100
>From: Luis Alves <ljalvs@gmail.com>
>To: linux-media@vger.kernel.org
>Cc: mchehab@infradead.org, crope@iki.fi, Luis Alves <ljalvs@gmail.com>
>Subject: [PATCH] Fixed misleading error when handling IR interrupts.
>
>
>Hi,
>Handling the AV Core/IR interrupts schedules its workqueue but
>the schedule_work function returns false if @work was already on the
>kernel-global workqueue and true otherwise.
>
>Printing an error message if @work wasn't in the queue is wrong.
>
>Regards,
>Luis
>

Yes, the use of the return value is wrong (at least since 2.6.32).  I must have misinterpreted the meaning of the return value when I added in that error message long ago.

Regards,
Andy

Acked-by: Andy Walls <awalls@md.metrocast.net>

>Signed-off-by: Luis Alves <ljalvs@gmail.com>
>---
> drivers/media/pci/cx23885/cx23885-core.c |    5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/drivers/media/pci/cx23885/cx23885-core.c
>b/drivers/media/pci/cx23885/cx23885-core.c
>index 268654a..9f63d93 100644
>--- a/drivers/media/pci/cx23885/cx23885-core.c
>+++ b/drivers/media/pci/cx23885/cx23885-core.c
>@@ -1941,10 +1941,7 @@ static irqreturn_t cx23885_irq(int irq, void
>*dev_id)
> 
> 	if ((pci_status & pci_mask) & PCI_MSK_AV_CORE) {
> 		cx23885_irq_disable(dev, PCI_MSK_AV_CORE);
>-		if (!schedule_work(&dev->cx25840_work))
>-			printk(KERN_ERR "%s: failed to set up deferred work for"
>-			       " AV Core/IR interrupt. Interrupt is disabled"
>-			       " and won't be re-enabled\n", dev->name);
>+		schedule_work(&dev->cx25840_work);
> 		handled++;
> 	}
> 


