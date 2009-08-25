Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:3033 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbZHYTHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 15:07:00 -0400
Message-ID: <4A943624.8090302@unsolicited.net>
Date: Tue, 25 Aug 2009 20:06:12 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
CC: linux-media@vger.kernel.org
Subject: Re: Technotrend TT-Connect S-2400
References: <4A90CA6B.4080303@gmail.com> <4A92CB24.4060300@unsolicited.net> <4A92D752.3050009@web.de>
In-Reply-To: <4A92D752.3050009@web.de>
Content-Type: multipart/mixed;
 boundary="------------010706000501090409000804"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010706000501090409000804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

André Weidemann wrote:
> Could please post a link to this patch? I think that a few people on
> this list, including me, are interested in a solution.
The patches should be small enough to post here and are attached. They
were sent to me by Alan Stern when he was looking at the issue. Apply
patch 1 then 2.

(I think they only apply to 2.6.30)

Cheers
David


--------------010706000501090409000804
Content-Type: text/x-diff;
 name="usbpatch1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbpatch1.patch"

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
Index: usb-2.6/drivers/usb/host/ehci-au1xxx.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-au1xxx.c
+++ usb-2.6/drivers/usb/host/ehci-au1xxx.c
@@ -97,6 +97,7 @@ static const struct hc_driver ehci_au1xx
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
Index: usb-2.6/drivers/usb/host/ehci-fsl.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-fsl.c
+++ usb-2.6/drivers/usb/host/ehci-fsl.c
@@ -309,6 +309,7 @@ static const struct hc_driver ehci_fsl_h
 	.urb_enqueue = ehci_urb_enqueue,
 	.urb_dequeue = ehci_urb_dequeue,
 	.endpoint_disable = ehci_endpoint_disable,
+	.endpoint_reset = ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
Index: usb-2.6/drivers/usb/host/ehci-ixp4xx.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-ixp4xx.c
+++ usb-2.6/drivers/usb/host/ehci-ixp4xx.c
@@ -51,6 +51,7 @@ static const struct hc_driver ixp4xx_ehc
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 	.get_frame_number	= ehci_get_frame,
 	.hub_status_data	= ehci_hub_status_data,
 	.hub_control		= ehci_hub_control,
Index: usb-2.6/drivers/usb/host/ehci-orion.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-orion.c
+++ usb-2.6/drivers/usb/host/ehci-orion.c
@@ -149,6 +149,7 @@ static const struct hc_driver ehci_orion
 	.urb_enqueue = ehci_urb_enqueue,
 	.urb_dequeue = ehci_urb_dequeue,
 	.endpoint_disable = ehci_endpoint_disable,
+	.endpoint_reset = ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
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
Index: usb-2.6/drivers/usb/host/ehci-ppc-of.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-ppc-of.c
+++ usb-2.6/drivers/usb/host/ehci-ppc-of.c
@@ -61,6 +61,7 @@ static const struct hc_driver ehci_ppc_o
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
Index: usb-2.6/drivers/usb/host/ehci-ps3.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-ps3.c
+++ usb-2.6/drivers/usb/host/ehci-ps3.c
@@ -65,6 +65,7 @@ static const struct hc_driver ps3_ehci_h
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 	.get_frame_number	= ehci_get_frame,
 	.hub_status_data	= ehci_hub_status_data,
 	.hub_control		= ehci_hub_control,


--------------010706000501090409000804
Content-Type: text/x-diff;
 name="usbpatch2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbpatch2.patch"

Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -1032,12 +1032,14 @@ ehci_endpoint_reset(struct usb_hcd *hcd,
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	struct ehci_qh		*qh;
 	int			eptype = usb_endpoint_type(&ep->desc);
+	int			epnum = usb_endpoint_num(&ep->desc);
+	int			is_out = usb_endpoint_dir_out(&ep->desc);
+	unsigned long		flags;
 
 	if (eptype != USB_ENDPOINT_XFER_BULK && eptype != USB_ENDPOINT_XFER_INT)
 		return;
 
- rescan:
-	spin_lock_irq(&ehci->lock);
+	spin_lock_irqsave(&ehci->lock, flags);
 	qh = ep->hcpriv;
 
 	/* For Bulk and Interrupt endpoints we maintain the toggle state
@@ -1046,29 +1048,24 @@ ehci_endpoint_reset(struct usb_hcd *hcd,
 	 * the toggle bit in the QH.
 	 */
 	if (qh) {
+		usb_settoggle(qh->dev, epnum, is_out, 0);
 		if (!list_empty(&qh->qtd_list)) {
 			WARN_ONCE(1, "clear_halt for a busy endpoint\n");
-		} else if (qh->qh_state == QH_STATE_IDLE) {
-			qh->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
-		} else {
-			/* It's not safe to write into the overlay area
-			 * while the QH is active.  Unlink it first and
-			 * wait for the unlink to complete.
+		} else if (qh->qh_state == QH_STATE_LINKED) {
+
+			/* The toggle value in the QH can't be updated
+			 * while the QH is active.  Unlink it now;
+			 * re-linking will call qh_refresh().
 			 */
-			if (qh->qh_state == QH_STATE_LINKED) {
-				if (eptype == USB_ENDPOINT_XFER_BULK) {
-					unlink_async(ehci, qh);
-				} else {
-					intr_deschedule(ehci, qh);
-					(void) qh_schedule(ehci, qh);
-				}
+			if (eptype == USB_ENDPOINT_XFER_BULK) {
+				unlink_async(ehci, qh);
+			} else {
+				intr_deschedule(ehci, qh);
+				(void) qh_schedule(ehci, qh);
 			}
-			spin_unlock_irq(&ehci->lock);
-			schedule_timeout_uninterruptible(1);
-			goto rescan;
 		}
 	}
-	spin_unlock_irq(&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 }
 
 static int ehci_get_frame (struct usb_hcd *hcd)
Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -93,6 +93,22 @@ qh_update (struct ehci_hcd *ehci, struct
 	qh->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
 	qh->hw_alt_next = EHCI_LIST_END(ehci);
 
+	/* Except for control endpoints, we make hardware maintain data
+	 * toggle (like OHCI) ... here (re)initialize the toggle in the QH,
+	 * and set the pseudo-toggle in udev. Only usb_clear_halt() will
+	 * ever clear it.
+	 */
+	if (!(qh->hw_info1 & cpu_to_hc32(ehci, 1 << 14))) {
+		unsigned	is_out, epnum;
+
+		is_out = !(qtd->hw_token & cpu_to_hc32(ehci, 1 << 8));
+		epnum = (hc32_to_cpup(ehci, &qh->hw_info1) >> 8) & 0x0f;
+		if (unlikely (!usb_gettoggle (qh->dev, epnum, is_out))) {
+			qh->hw_token &= ~cpu_to_hc32(ehci, QTD_TOGGLE);
+			usb_settoggle (qh->dev, epnum, is_out, 1);
+		}
+	}
+
 	/* HC must see latest qtd and qh data before we clear ACTIVE+HALT */
 	wmb ();
 	qh->hw_token &= cpu_to_hc32(ehci, QTD_TOGGLE | QTD_STS_PING);
@@ -877,6 +893,7 @@ done:
 	qh->qh_state = QH_STATE_IDLE;
 	qh->hw_info1 = cpu_to_hc32(ehci, info1);
 	qh->hw_info2 = cpu_to_hc32(ehci, info2);
+	usb_settoggle (urb->dev, usb_pipeendpoint (urb->pipe), !is_input, 1);
 	qh_refresh (ehci, qh);
 	return qh;
 }
@@ -911,7 +928,7 @@ static void qh_link_async (struct ehci_h
 		}
 	}
 
-	/* clear halt and maybe recover from silicon quirk */
+	/* clear halt and/or toggle; and maybe recover from silicon quirk */
 	if (qh->qh_state == QH_STATE_IDLE)
 		qh_refresh (ehci, qh);
 


--------------010706000501090409000804--

