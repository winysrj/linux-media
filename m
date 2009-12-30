Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57790 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752154AbZL3DW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 22:22:28 -0500
Date: Tue, 29 Dec 2009 22:22:26 -0500 (EST)
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
In-Reply-To: <4B3AA0BE.1000305@toaster.net>
Message-ID: <Pine.LNX.4.44L0.0912292201360.11209-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 29 Dec 2009, Sean wrote:

> Alan,
> 
> Thanks for the debug patch. I'll send you the dmesg.log output in 
> another email. It is 2MB.

Got it.  It's not good enough; the initial error occurred before the 
start of your extract.  Here's yet another version of the patch; this 
one will stop printing the debug messages when an error is first 
detected so maybe it won't overrun your log buffer.

Alan Stern


Index: usb-2.6/drivers/usb/host/ohci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-hcd.c
+++ usb-2.6/drivers/usb/host/ohci-hcd.c
@@ -201,7 +201,7 @@ static int ohci_urb_enqueue (
 
 	/* allocate the TDs (deferring hash chain updates) */
 	for (i = 0; i < size; i++) {
-		urb_priv->td [i] = td_alloc (ohci, mem_flags);
+		urb_priv->td [i] = td_alloc (ohci, mem_flags, urb->dev, urb->ep);
 		if (!urb_priv->td [i]) {
 			urb_priv->length = i;
 			urb_free_priv (ohci, urb_priv);
@@ -580,6 +580,7 @@ static int ohci_run (struct ohci_hcd *oh
 	struct usb_hcd		*hcd = ohci_to_hcd(ohci);
 
 	disable (ohci);
+	ohci->testing = 1;
 
 	/* boot firmware should have set this up (5.1.1.3.1) */
 	if (first) {
Index: usb-2.6/drivers/usb/host/ohci-mem.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-mem.c
+++ usb-2.6/drivers/usb/host/ohci-mem.c
@@ -82,7 +82,8 @@ dma_to_td (struct ohci_hcd *hc, dma_addr
 
 /* TDs ... */
 static struct td *
-td_alloc (struct ohci_hcd *hc, gfp_t mem_flags)
+td_alloc (struct ohci_hcd *hc, gfp_t mem_flags, struct usb_device *udev,
+	struct usb_host_endpoint *ep)
 {
 	dma_addr_t	dma;
 	struct td	*td;
@@ -94,6 +95,9 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem
 		td->hwNextTD = cpu_to_hc32 (hc, dma);
 		td->td_dma = dma;
 		/* hashed in td_fill */
+		if (hc->testing)
+			ohci_dbg(hc, "td alloc for %s ep%x: %p\n",
+				udev->devpath, ep->desc.bEndpointAddress, td);
 	}
 	return td;
 }
@@ -101,14 +105,32 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem
 static void
 td_free (struct ohci_hcd *hc, struct td *td)
 {
-	struct td	**prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
-
-	while (*prev && *prev != td)
+	int		hash = TD_HASH_FUNC(td->td_dma);
+	struct td	**prev = &hc->td_hash[hash];
+	int		n = 0;
+
+	if (hc->testing)
+		ohci_dbg(hc, "td free %p\n", td);
+	while (*prev && *prev != td) {
+		if ((unsigned long) *prev == 0xa7a7a7a7) {
+			ohci_dbg(hc, "poisoned hash at %p (%d %d) %p\n", prev,
+					hash, n, hc->td_hash[hash]);
+			return;
+		}
 		prev = &(*prev)->td_hash;
-	if (*prev)
+		++n;
+	}
+	if (*prev) {
 		*prev = td->td_hash;
-	else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
-		ohci_dbg (hc, "no hash for td %p\n", td);
+		if (hc->testing) {
+			ohci_dbg(hc, "(%d %d) %p -> %p\n", hash, n, prev, *prev);
+			if (td->td_hash == td)
+				hc->testing = 0;
+		}
+	} else {
+		ohci_dbg(hc, "no hash for td %p: %d %p\n", td,
+				hash, hc->td_hash[hash]);
+	}
 	dma_pool_free (hc->td_cache, td, td->td_dma);
 }
 
Index: usb-2.6/drivers/usb/host/ohci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-q.c
+++ usb-2.6/drivers/usb/host/ohci-q.c
@@ -406,7 +406,7 @@ static struct ed *ed_get (
 		}
 
 		/* dummy td; end of td list for ed */
-		td = td_alloc (ohci, GFP_ATOMIC);
+		td = td_alloc (ohci, GFP_ATOMIC, udev, ep);
 		if (!td) {
 			/* out of memory */
 			ed_free (ohci, ed);
@@ -560,6 +560,11 @@ td_fill (struct ohci_hcd *ohci, u32 info
 	hash = TD_HASH_FUNC (td->td_dma);
 	td->td_hash = ohci->td_hash [hash];
 	ohci->td_hash [hash] = td;
+	if (ohci->testing) {
+		ohci_dbg(ohci, "hash %p to %d -> %p\n", td, hash, td->td_hash);
+		if (td->td_hash == td)
+			ohci->testing = 0;
+	}
 
 	/* HC might read the TD (or cachelines) right away ... */
 	wmb ();
Index: usb-2.6/drivers/usb/host/ohci.h
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci.h
+++ usb-2.6/drivers/usb/host/ohci.h
@@ -346,6 +346,7 @@ typedef struct urb_priv {
 
 struct ohci_hcd {
 	spinlock_t		lock;
+	int			testing;
 
 	/*
 	 * I/O memory used to communicate with the HC (dma-consistent)

