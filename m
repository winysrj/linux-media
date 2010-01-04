Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59921 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753587Ab0ADUsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 15:48:54 -0500
Date: Mon, 4 Jan 2010 15:48:47 -0500 (EST)
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
In-Reply-To: <4B424963.5080902@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001041538140.3180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jan 2010, Sean wrote:

> Alan Stern wrote:
> > Try inserting a line saying:
> >
> > 	td_check(ohci, hash, "#2c");
> >
> > two lines above the #2b line, i.e., just after the wmb().  That'll help 
> > narrow down the search for the bug.
> Alan,
> 
> I put the extra line in and ran capture-example twice. This is what I got:
>  
> ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
> ohci_hcd 0000:00:0b.0: Circular pointer #2c: 1 c6782040 c66a4040 c6782040
...

All right.  Let's try this patch in place of all the others, then.

Alan Stern


Index: usb-2.6/drivers/usb/host/ohci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-q.c
+++ usb-2.6/drivers/usb/host/ohci-q.c
@@ -505,6 +505,7 @@ td_fill (struct ohci_hcd *ohci, u32 info
 	struct urb_priv		*urb_priv = urb->hcpriv;
 	int			is_iso = info & TD_ISO;
 	int			hash;
+	volatile struct td	* volatile td1, * volatile td2;
 
 	// ASSERT (index < urb_priv->length);
 
@@ -558,11 +559,30 @@ td_fill (struct ohci_hcd *ohci, u32 info
 
 	/* hash it for later reverse mapping */
 	hash = TD_HASH_FUNC (td->td_dma);
+
+	td1 = ohci->td_hash[hash];
+	td2 = NULL;
+	if (td1) {
+		td2 = td1->td_hash;
+		if (td2 == td1 || td2 == td) {
+			ohci_err(ohci, "Circular hash: %d %p %p %p\n",
+					hash, td1, td2, td);
+			td2 = td1->td_hash = NULL;
+		}
+	}
+
 	td->td_hash = ohci->td_hash [hash];
 	ohci->td_hash [hash] = td;
 
 	/* HC might read the TD (or cachelines) right away ... */
 	wmb ();
+
+	if (td1 && td1->td_hash != td2) {
+		ohci_err(ohci, "Hash value changed: %d %p %p %p\n",
+					hash, td1, td2, td);
+		td1->td_hash = (struct td *) td2;
+	}
+
 	td->ed->hwTailP = td->hwNextTD;
 }
 

