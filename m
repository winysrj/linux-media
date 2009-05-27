Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38475 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756240AbZE0UU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 16:20:57 -0400
Date: Wed, 27 May 2009 16:20:57 -0400 (EDT)
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
In-Reply-To: <4A1D89B3.2020400@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905271619090.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 May 2009, David wrote:

> Sorry for the delay, your patch reached me just after I turned in last
> night.
> 
> It looks good to me. dmesg is how I'd expect, and I've attached the usb
> trace which looks pretty similar to when the original patch was reverted.
> 
> I'll test some more with some other peripherals & check that they work ok.
> 
> Thanks a lot!

I'm not done yet.  That patch seemed a bit unsafe, so I revised it.  
This version is a lot more careful about modifying data structures 
while they are still in use by the hardware.

If it works okay for you, I'll submit it.

Alan Stern


Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -93,22 +93,6 @@ qh_update (struct ehci_hcd *ehci, struct
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
@@ -893,7 +877,6 @@ done:
 	qh->qh_state = QH_STATE_IDLE;
 	qh->hw_info1 = cpu_to_hc32(ehci, info1);
 	qh->hw_info2 = cpu_to_hc32(ehci, info2);
-	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
 }
@@ -928,7 +911,7 @@ static void qh_link_async (struct ehci_h
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
Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -1026,6 +1026,51 @@ done:
 	return;
 }
 
+static void
+ehci_endpoint_reset(struct usb_hcd *hcd, struct usb_host_endpoint *ep)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	struct ehci_qh		*qh;
+	int			eptype = usb_endpoint_type(&ep->desc);
+
+	if (eptype != USB_ENDPOINT_XFER_BULK && eptype != USB_ENDPOINT_XFER_INT)
+		return;
+
+ rescan:
+	spin_lock_irq(&ehci->lock);
+	qh = ep->hcpriv;
+
+	/* For Bulk and Interrupt endpoints we maintain the toggle state
+	 * in the hardware; the toggle bits in udev aren't used at all.
+	 * When an endpoint is reset by usb_clear_halt() we must reset
+	 * the toggle bit in the QH.
+	 */
+	if (qh) {
+		if (!list_empty(&qh->qtd_list)) {
+			WARN_ONCE(1, "clear_halt for a busy endpoint\n");
+		} else if (qh->qh_state == QH_STATE_IDLE) {
+			qh->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
+		} else {
+			/* It's not safe to write into the overlay area
+			 * while the QH is active.  Unlink it first and
+			 * wait for the unlink to complete.
+			 */
+			if (qh->qh_state == QH_STATE_LINKED) {
+				if (eptype == USB_ENDPOINT_XFER_BULK) {
+					unlink_async(ehci, qh);
+				} else {
+					intr_deschedule(ehci, qh);
+					(void) qh_schedule(ehci, qh);
+				}
+			}
+			spin_unlock_irq(&ehci->lock);
+			schedule_timeout_uninterruptible(1);
+			goto rescan;
+		}
+	}
+	spin_unlock_irq(&ehci->lock);
+}
+
 static int ehci_get_frame (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);

