Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41921 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752168AbZEZU5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 16:57:01 -0400
Date: Tue, 26 May 2009 16:57:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: David <david@unsolicited.net>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
In-Reply-To: <4A1AE705.2050809@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905261646420.11998-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2009, David wrote:

> > No luck I'm afraid (although there now appear to be 2 timeouts, not
> > one). I'm going to follow up on the laptop and get a USB log.
> >   
> USB log post-patch attached. Thanks for all the effort so far!

I think the idea of the patch was good, but the endpoint direction
information got lost (because the information was taken from the dummy
qTD which is always marked as OUT -- I don't see how this could ever
have worked properly).  So let's redo it, using the new and proper
interface for resetting endpoints.

To tell the truth, I'm not entirely certain this will work either.  The 
hardware may cache the endpoint state, so it may be necessary to unlink 
the endpoint completely.  Still, try this version and see what happens.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -84,6 +84,30 @@ qtd_fill(struct ehci_hcd *ehci, struct e
 
 /*-------------------------------------------------------------------------*/
 
+static void ehci_endpoint_reset(struct usb_hcd *hcd,
+		struct usb_host_endpoint *ep)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct ehci_qh		*qh;
+
+	spin_lock_irq(&ehci->lock);
+	qh = ep->hcpriv;
+
+	/* For Bulk and Interrupt endpoints we maintain the toggle state
+	 * in the hardware; the toggle bits in udev aren't used at all.
+	 * When an endpoint is reset by usb_clear_halt() we must reset
+	 * the toggle bit in the QH.
+	 */
+	if (qh && (usb_endpoint_xfer_bulk(&ep->desc) ||
+			usb_endpoint_xfer_int(&ep->desc))) {
+		if (qh->qh_state == QH_STATE_IDLE || list_empty(&qh->qtd_list))
+			qh->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
+		else
+			WARN_ONCE(1, "clear_halt for an active endpoint\n");
+	}
+	spin_unlock_irq(&ehci->lock);
+}
+
 static inline void
 qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
 {
@@ -93,22 +117,6 @@ qh_update (struct ehci_hcd *ehci, struct
 	qh->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
 	qh->hw_alt_next = EHCI_LIST_END(ehci);
 
-	/* Except for control endpoints, we make hardware maintain data
-	 * toggle (like OHCI) ... here (re)initialize the toggle in the QH,
-	 * and set the pseudo-toggle in udev. Only usb_clear_halt() will
-	 * ever clear it.
-	 */
-	if (!(qh->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
-		unsigned	is_out, epnum;
-
-		is_out = !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
-		epnum = (hc32_to_cpup(ehci, &qh->hw_info1) >> 8) & 0x0f;
-		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
-			qh->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
-			usb_settoggle (qh->dev, epnum, is_out, 1);
-		}
-	}
-
 	/* HC must see latest qtd and qh data before we clear ACTIVE+HALT */
 	wmb ();
 	qh->hw_token &= cpu_to_hc32(ehci, QTD_TOGGLE | QTD_STS_PING);
@@ -893,7 +901,6 @@ done:
 	qh->qh_state = QH_STATE_IDLE;
 	qh->hw_info1 = cpu_to_hc32(ehci, info1);
 	qh->hw_info2 = cpu_to_hc32(ehci, info2);
-	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
 }
@@ -928,7 +935,7 @@ static void qh_link_async (struct ehci_h
 		}
 	}
 
-	/* clear halt and/or toggle; and maybe recover from silicon quirk */
+	/* clear halt and maybe recover from silicon quirk */
 	if (qh->qh_state == QH_STATE_IDLE)
 		qh_refresh (ehci, qh);
 
Index: usb-2.6/drivers/usb/host/ehci-pci.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-pci.c
+++ usb-2.6/drivers/usb/host/ehci-pci.c
@@ -388,6 +388,7 @@ static const struct hc_driver ehci_pci_h
 	.urb_enqueue =		ehci_urb_enqueue,
 	.urb_dequeue =		ehci_urb_dequeue,
 	.endpoint_disable =	ehci_endpoint_disable,
+	.endpoint_reset =	ehci_endpoint_reset,
 
 	/*
 	 * scheduling support

