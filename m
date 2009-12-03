Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753284AbZLCVDl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 16:03:41 -0500
Date: Thu, 3 Dec 2009 16:03:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sean <knife@toaster.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
	<bugzilla-daemon@bugzilla.kernel.org>,
	<linux-media@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
In-Reply-To: <4B175111.9070800@toaster.net>
Message-ID: <Pine.LNX.4.44L0.0912031601420.4795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Dec 2009, Sean wrote:

> Is there anything I can do to help? This is a show stopping bug for me.

Here's a patch you can try.  It will add a _lot_ of debugging
information to the system log.  Maybe it will help pin down the source
of the problem.

Alan Stern



Index: 2.6.31/drivers/usb/host/ohci-hcd.c
===================================================================
--- 2.6.31.orig/drivers/usb/host/ohci-hcd.c
+++ 2.6.31/drivers/usb/host/ohci-hcd.c
@@ -197,7 +197,7 @@ static int ohci_urb_enqueue (
 
 	/* allocate the TDs (deferring hash chain updates) */
 	for (i = 0; i < size; i++) {
-		urb_priv->td [i] = td_alloc (ohci, mem_flags);
+		urb_priv->td [i] = td_alloc (ohci, mem_flags, urb->dev, urb->ep);
 		if (!urb_priv->td [i]) {
 			urb_priv->length = i;
 			urb_free_priv (ohci, urb_priv);
Index: 2.6.31/drivers/usb/host/ohci-mem.c
===================================================================
--- 2.6.31.orig/drivers/usb/host/ohci-mem.c
+++ 2.6.31/drivers/usb/host/ohci-mem.c
@@ -82,7 +82,8 @@ dma_to_td (struct ohci_hcd *hc, dma_addr
 
 /* TDs ... */
 static struct td *
-td_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
+td_alloc (struct ohci_hcd *hc, gfp_t mem_flags, struct usb_device *udev,
+	struct usb_host_endpoint *ep)
 {
 	dma_addr_t	dma;
 	struct td	*td;
@@ -94,6 +95,8 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem
 		td->hwNextTD = cpu_to_hc32 (hc, dma);
 		td->td_dma = dma;
 		/* hashed in td_fill */
+		ohci_info(hc, "td alloc for %s ep%x: %p\n",
+			udev->devpath, ep->desc.bEndpointAddress, td);
 	}
 	return td;
 }
@@ -103,8 +106,14 @@ td_free (struct ohci_hcd *hc, struct td 
 {
 	struct td	**prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
 
-	while (*prev && *prev != td)
+	ohci_info(hc, "td free %p\n", td);
+	while (*prev && *prev != td) {
+		if ((unsigned long) *prev == 0xa7a7a7a7) {
+			ohci_info(hc, "poisoned hash at %p\n", prev);
+			return;
+		}
 		prev = &(*prev)->td_hash;
+	}
 	if (*prev)
 		*prev = td->td_hash;
 	else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
Index: 2.6.31/drivers/usb/host/ohci-q.c
===================================================================
--- 2.6.31.orig/drivers/usb/host/ohci-q.c
+++ 2.6.31/drivers/usb/host/ohci-q.c
@@ -403,7 +403,7 @@ static struct ed *ed_get (
 		}
 
 		/* dummy td; end of td list for ed */
-		td = td_alloc (ohci, GFP_ATOMIC);
+		td = td_alloc (ohci, GFP_ATOMIC, udev, ep);
 		if (!td) {
 			/* out of memory */
 			ed_free (ohci, ed);

