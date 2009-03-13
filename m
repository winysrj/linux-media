Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59529 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752931AbZCMOff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 10:35:35 -0400
Date: Fri, 13 Mar 2009 10:35:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090311221555.GB5776@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903131033140.2898-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Brandon Philips wrote:

> On 15:46 Wed 11 Mar 2009, Alan Stern wrote:
> > On Wed, 11 Mar 2009, Brandon Philips wrote:
> > Okay, here's a diagnostic patch meant to apply on top of 
> > gregkh-all-2.6.29-rc7.  Let's see what it says...
> 
> Here is the log:
>  http://ifup.org/~philips/467317/pearl-alan-debug.log
> 
> >  	default:
> >  		qh = (struct ehci_qh *) urb->hcpriv;
> > +		if (alantest == 1) {
> > +			alantest = 2;
> > +			ehci_info(ehci, "dequeue: qh %p\n", qh);
> > +		}
> 
> This was the last thing printed before I dumped the task states with sysrq
> keys.

Okay, not much information there but it's a start.  Here's a more 
informative patch to try instead.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -108,6 +108,8 @@ MODULE_PARM_DESC (ignore_oc, "ignore bog
 #include "ehci.h"
 #include "ehci-dbg.c"
 
+static int alantest;
+
 /*-------------------------------------------------------------------------*/
 
 static void
@@ -301,12 +303,19 @@ static void ehci_iaa_watchdog(unsigned l
 	unsigned long		flags;
 
 	spin_lock_irqsave (&ehci->lock, flags);
+	if (alantest == 2)
+		alantest = 3;
 
 	/* Lost IAA irqs wedge things badly; seen first with a vt8235.
 	 * So we need this watchdog, but must protect it against both
 	 * (a) SMP races against real IAA firing and retriggering, and
 	 * (b) clean HC shutdown, when IAA watchdog was pending.
 	 */
+	if (alantest == 3)
+		ehci_info(ehci, "IAA watchdog: reclaim %p pending %d state %d\n",
+				ehci->reclaim,
+				timer_pending(&ehci->iaa_watchdog),
+				ehci_to_hcd(ehci)->state);
 	if (ehci->reclaim
 			&& !timer_pending(&ehci->iaa_watchdog)
 			&& HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
@@ -337,9 +346,15 @@ static void ehci_iaa_watchdog(unsigned l
 
 		ehci_vdbg(ehci, "IAA watchdog: status %x cmd %x\n",
 				status, cmd);
+		if (alantest == 3)
+			ehci_info(ehci, "IAA watchdog: status %x cmd %x\n",
+					status, cmd);
+
 		end_unlink_async(ehci);
 	}
 
+	if (alantest == 3)
+		alantest = 0;
 	spin_unlock_irqrestore(&ehci->lock, flags);
 }
 
@@ -729,6 +744,8 @@ static irqreturn_t ehci_irq (struct usb_
 					&ehci->regs->command);
 			ehci_dbg(ehci, "IAA with IAAD still set?\n");
 		}
+		if (alantest == 2)
+			ehci_info(ehci, "IAA: reclaim %p\n", ehci->reclaim);
 		if (ehci->reclaim) {
 			COUNT(ehci->stats.reclaim);
 			end_unlink_async(ehci);
@@ -847,12 +864,17 @@ static int ehci_urb_enqueue (
 static void unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
 	/* failfast */
-	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) && ehci->reclaim)
+	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) && ehci->reclaim) {
+		if (alantest == 2)
+			ehci_info(ehci, "call end_unlink_async\n");
 		end_unlink_async(ehci);
+	}
 
 	/* if it's not linked then there's nothing to do */
-	if (qh->qh_state != QH_STATE_LINKED)
-		;
+	if (qh->qh_state != QH_STATE_LINKED) {
+		if (alantest == 2)
+			ehci_info(ehci, "not linked\n");
+	}
 
 	/* defer till later if busy */
 	else if (ehci->reclaim) {
@@ -864,10 +886,15 @@ static void unlink_async (struct ehci_hc
 			continue;
 		qh->qh_state = QH_STATE_UNLINK_WAIT;
 		last->reclaim = qh;
+		if (alantest == 2)
+			ehci_info(ehci, "unlink_async: add to reclaim\n");
 
 	/* start IAA cycle */
-	} else
+	} else {
+		if (alantest == 2)
+			ehci_info(ehci, "call start_unlink_async\n");
 		start_unlink_async (ehci, qh);
+	}
 }
 
 /* remove from hardware lists
@@ -891,16 +918,28 @@ static int ehci_urb_dequeue(struct usb_h
 	// case PIPE_BULK:
 	default:
 		qh = (struct ehci_qh *) urb->hcpriv;
+		if (alantest == 1) {
+			alantest = 2;
+			ehci_info(ehci, "dequeue: qh %p state %d\n", qh,
+				qh->qh_state);
+		}
 		if (!qh)
 			break;
 		switch (qh->qh_state) {
 		case QH_STATE_LINKED:
 		case QH_STATE_COMPLETING:
+			if (alantest == 2)
+				ehci_info(ehci, "call unlink_async\n");
 			unlink_async(ehci, qh);
 			break;
 		case QH_STATE_UNLINK:
 		case QH_STATE_UNLINK_WAIT:
 			/* already started */
+			if (alantest == 2) {
+				alantest = 3;
+				ehci_info(ehci, "unlink already started, pending %d\n",
+					timer_pending(&ehci->iaa_watchdog));
+			}
 			break;
 		case QH_STATE_IDLE:
 			WARN_ON(1);
Index: usb-2.6/drivers/usb/host/ehci-pci.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-pci.c
+++ usb-2.6/drivers/usb/host/ehci-pci.c
@@ -314,6 +314,8 @@ static int ehci_pci_resume(struct usb_hc
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 
+	if (alantest == 0)
+		alantest = 1;
 	// maybe restore FLADJ
 
 	if (time_before(jiffies, ehci->next_statechange))
Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -453,6 +453,8 @@ halt:
 		/* reinit the xacterr counter for the next qtd */
 		qh->xacterrs = QH_XACTERR_MAX;
 	}
+	if (alantest == 3)
+		ehci_info(ehci, "qh_completions: qh %p last %p\n", qh, last);
 
 	/* last urb's completion might still need calling */
 	if (likely (last != NULL)) {
@@ -1062,7 +1064,13 @@ static void end_unlink_async (struct ehc
 	ehci->reclaim = next;
 	qh->reclaim = NULL;
 
+	if (alantest == 2) {
+		alantest = 3;
+		ehci_info(ehci, "end_unlink_async: qh %p\n", qh);
+	}
 	qh_completions (ehci, qh);
+	if (alantest == 3)
+		alantest = 0;
 
 	if (!list_empty (&qh->qtd_list)
 			&& HC_IS_RUNNING (ehci_to_hcd(ehci)->state))
@@ -1131,6 +1139,8 @@ static void start_unlink_async (struct e
 		/* if (unlikely (qh->reclaim != 0))
 		 *	this will recurse, probably not much
 		 */
+		if (alantest == 2)
+			ehci_info(ehci, "start_unlink_async: halted\n");
 		end_unlink_async (ehci);
 		return;
 	}
@@ -1139,6 +1149,8 @@ static void start_unlink_async (struct e
 	ehci_writel(ehci, cmd, &ehci->regs->command);
 	(void)ehci_readl(ehci, &ehci->regs->command);
 	iaa_watchdog_start(ehci);
+	if (alantest == 2)
+		ehci_info(ehci, "start_unlink_async: IAA started\n");
 }
 
 /*-------------------------------------------------------------------------*/

