Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33572 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751220AbZCKTqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 15:46:09 -0400
Date: Wed, 11 Mar 2009 15:46:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090311172031.GC22789@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903111543580.21047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Brandon Philips wrote:

> It still locks up with "Unlink after no-IRQ" with -rc7 + greg's patches
> and test in /sys/power/disk.
> 
> One of the times when I booted up this new Kernel I got some errors out
> of ehci_hcd/khubd: http://ifup.org/~philips/467317/khubd.timeout It only
> happened on that boot and I haven't seen those ehci_hcd/khubd errors
> again since.

I have no idea what caused that.  Some brief glitch, apparently.

Okay, here's a diagnostic patch meant to apply on top of 
gregkh-all-2.6.29-rc7.  Let's see what it says...

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
@@ -864,6 +881,8 @@ static void unlink_async (struct ehci_hc
 			continue;
 		qh->qh_state = QH_STATE_UNLINK_WAIT;
 		last->reclaim = qh;
+		if (alantest == 2)
+			ehci_info(ehci, "unlink_async: add to reclaim\n");
 
 	/* start IAA cycle */
 	} else
@@ -891,6 +910,10 @@ static int ehci_urb_dequeue(struct usb_h
 	// case PIPE_BULK:
 	default:
 		qh = (struct ehci_qh *) urb->hcpriv;
+		if (alantest == 1) {
+			alantest = 2;
+			ehci_info(ehci, "dequeue: qh %p\n", qh);
+		}
 		if (!qh)
 			break;
 		switch (qh->qh_state) {
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


