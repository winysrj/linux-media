Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58813 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbZKRPUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 10:20:03 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Wed, 18 Nov 2009 20:50:03 +0530
Subject: RE: [PATCH] VPFE Capture: Add call back function for interrupt
 clear to vpfe_cfg
Message-ID: <19F8576C6E063C45BE387C64729E7394043702BAA6@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1258544101-28830-1-git-send-email-hvaibhav@ti.com>
 <A69FA2915331DC488A831521EAE36FE401559C5ED4@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C5ED4@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Wednesday, November 18, 2009 8:33 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl
> Subject: RE: [PATCH] VPFE Capture: Add call back function for
> interrupt clear to vpfe_cfg
> 
> Vaibhav,
> 
> In the interrupt handler, it is better to add something like
> below... The
> same piece of code is repeated many times...
> 
> When ready to return IRQ_HANDLED
> 
> goto clear_int;
> 
> 
> clear_int:
> 	if (vpfe_dev->cfg->clr_intr)
> 			vpfe_dev->cfg->clr_intr(irq);
> 	return IRQ_HANDLED;
> 
[Hiremath, Vaibhav] Actually the earlier implementation was exactly same using goto statement, but since there are only 4 instances, so removed goto statement.

Ok, I will update it and submit it again.

Thanks,
Vaibhav

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Hiremath, Vaibhav
> >Sent: Wednesday, November 18, 2009 6:35 AM
> >To: linux-media@vger.kernel.org
> >Cc: hverkuil@xs4all.nl; Karicheri, Muralidharan; Hiremath, Vaibhav
> >Subject: [PATCH] VPFE Capture: Add call back function for interrupt
> clear
> >to vpfe_cfg
> >
> >From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >For the devices like AM3517, it is expected that driver clears the
> >interrupt in ISR. Since this is device spcific, callback function
> >added to the platform_data.
> >
> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> >---
> > drivers/media/video/davinci/vpfe_capture.c |   26
> >++++++++++++++++++++++++--
> > include/media/davinci/vpfe_capture.h       |    2 ++
> > 2 files changed, 26 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/media/video/davinci/vpfe_capture.c
> >b/drivers/media/video/davinci/vpfe_capture.c
> >index 9b6b254..4c5152e 100644
> >--- a/drivers/media/video/davinci/vpfe_capture.c
> >+++ b/drivers/media/video/davinci/vpfe_capture.c
> >@@ -563,6 +563,11 @@ static int vpfe_initialize_device(struct
> vpfe_device
> >*vpfe_dev)
> > 	ret = ccdc_dev->hw_ops.open(vpfe_dev->pdev);
> > 	if (!ret)
> > 		vpfe_dev->initialized = 1;
> >+
> >+	/* Clear all VPFE/CCDC interrupts */
> >+	if (vpfe_dev->cfg->clr_intr)
> >+		vpfe_dev->cfg->clr_intr(-1);
> >+
> > unlock:
> > 	mutex_unlock(&ccdc_lock);
> > 	return ret;
> >@@ -663,8 +668,11 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
> > 	field = vpfe_dev->fmt.fmt.pix.field;
> >
> > 	/* if streaming not started, don't do anything */
> >-	if (!vpfe_dev->started)
> >+	if (!vpfe_dev->started) {
> >+		if (vpfe_dev->cfg->clr_intr)
> >+			vpfe_dev->cfg->clr_intr(irq);
> > 		return IRQ_HANDLED;
> >+	}
> >
> > 	/* only for 6446 this will be applicable */
> > 	if (NULL != ccdc_dev->hw_ops.reset)
> >@@ -676,6 +684,8 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
> > 			"frame format is progressive...\n");
> > 		if (vpfe_dev->cur_frm != vpfe_dev->next_frm)
> > 			vpfe_process_buffer_complete(vpfe_dev);
> >+		if (vpfe_dev->cfg->clr_intr)
> >+			vpfe_dev->cfg->clr_intr(irq);
> > 		return IRQ_HANDLED;
> > 	}
> >
> >@@ -703,6 +713,8 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
> > 			if (field == V4L2_FIELD_SEQ_TB)
> > 				vpfe_schedule_bottom_field(vpfe_dev);
> >
> >+			if (vpfe_dev->cfg->clr_intr)
> >+				vpfe_dev->cfg->clr_intr(irq);
> > 			return IRQ_HANDLED;
> > 		}
> > 		/*
> >@@ -723,6 +735,9 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
> > 		 */
> > 		vpfe_dev->field_id = fid;
> > 	}
> >+	if (vpfe_dev->cfg->clr_intr)
> >+		vpfe_dev->cfg->clr_intr(irq);
> >+
> > 	return IRQ_HANDLED;
> > }
> >
> >@@ -734,8 +749,11 @@ static irqreturn_t vdint1_isr(int irq, void
> *dev_id)
> > 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nInside
> vdint1_isr...\n");
> >
> > 	/* if streaming not started, don't do anything */
> >-	if (!vpfe_dev->started)
> >+	if (!vpfe_dev->started) {
> >+		if (vpfe_dev->cfg->clr_intr)
> >+			vpfe_dev->cfg->clr_intr(irq);
> > 		return IRQ_HANDLED;
> >+	}
> >
> > 	spin_lock(&vpfe_dev->dma_queue_lock);
> > 	if ((vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) &&
> >@@ -743,6 +761,10 @@ static irqreturn_t vdint1_isr(int irq, void
> *dev_id)
> > 	    vpfe_dev->cur_frm == vpfe_dev->next_frm)
> > 		vpfe_schedule_next_buffer(vpfe_dev);
> > 	spin_unlock(&vpfe_dev->dma_queue_lock);
> >+
> >+	if (vpfe_dev->cfg->clr_intr)
> >+		vpfe_dev->cfg->clr_intr(irq);
> >+
> > 	return IRQ_HANDLED;
> > }
> >
> >diff --git a/include/media/davinci/vpfe_capture.h
> >b/include/media/davinci/vpfe_capture.h
> >index fc83d98..5a21265 100644
> >--- a/include/media/davinci/vpfe_capture.h
> >+++ b/include/media/davinci/vpfe_capture.h
> >@@ -104,6 +104,8 @@ struct vpfe_config {
> > 	char *ccdc;
> > 	/* setup function for the input path */
> > 	int (*setup_input)(enum vpfe_subdev_id id);
> >+	/* Function for Clearing the interrupt */
> >+	void (*clr_intr)(int vdint);
> > 	/* number of clocks */
> > 	int num_clocks;
> > 	/* clocks used for vpfe capture */
> >--
> >1.6.2.4

