Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:45757 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752936Ab0ACRf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 12:35:58 -0500
Date: Sun, 3 Jan 2010 12:35:56 -0500 (EST)
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
In-Reply-To: <4B3FF968.6000706@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001031140460.29885-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2 Jan 2010, Sean wrote:

> Hmm, I applied the changes and I did not see a place where *prev differs 
> from td->td_hash. I have run memtest86+ on this box and it has passed 16 
> times, so I do not suspect a hardware memory error. What do you think? 
> Attached is the latest dmesg output.

I don't know.  The same pattern as before appears here:

$ egrep -n '[1b]e(40|5c)' dmesg3.log
167:kobject: 'fs' (c7801e40): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
4990:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6691e40
5023:ohci_hcd 0000:00:0b.0: hash c6691e40 to 57 -> (null)
5181:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676be40
5214:ohci_hcd 0000:00:0b.0: hash c676be40 to 57 -> c6691e40
5271:ohci_hcd 0000:00:0b.0: td free c6691e40
5272:ohci_hcd 0000:00:0b.0: (57 1) c676be5c -> (null) [(null)]
5294:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6691e40
5327:ohci_hcd 0000:00:0b.0: hash c6691e40 to 57 -> c676be40
5533:ohci_hcd 0000:00:0b.0: td free c676be40
5534:ohci_hcd 0000:00:0b.0: (57 1) c6691e5c -> (null) [(null)]
5556:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c676be40
5589:ohci_hcd 0000:00:0b.0: hash c676be40 to 57 -> c6691e40
5640:ohci_hcd 0000:00:0b.0: td free c6691e40
5641:ohci_hcd 0000:00:0b.0: (57 1) c676be5c -> c676be40 [c676be40]
5713:ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6691e40
5746:ohci_hcd 0000:00:0b.0: hash c6691e40 to 57 -> c676be40
5899:ohci_hcd 0000:00:0b.0: td free c676be40
5900:ohci_hcd 0000:00:0b.0: (57 1) c6691e5c -> c676be40 [c676be40]

At line 5641 we see that the td_hash pointer in c676be40 gets
corrupted.  It is copied from the pointer in c6691e40, which was set to
NULL in line 5534, but now it points to c676be40.

The question is whether this corruption was caused by a hardware fault 
or a software bug.  We have added debugging printouts to the only two 
places where the driver assigns anything to td->td_hash, and they don't 
show anything wrong.  This leads me to suspect the hardware, but of 
course this is still just a guess.

Here is a completely new patch.  This one is more directed, to catch 
the sort of errors we now know to look for.

Alan Stern



Index: usb-2.6/drivers/usb/host/ohci-mem.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-mem.c
+++ usb-2.6/drivers/usb/host/ohci-mem.c
@@ -98,17 +98,56 @@ td_alloc (struct ohci_hcd *hc, gfp_t mem
 	return td;
 }
 
+static void td_check(struct ohci_hcd *hc, int hash, char *msg)
+{
+	struct td	*td, *first;
+
+	first = hc->td_hash[hash];
+	for (td = first; td; td = td->td_hash) {
+		if (td->td_hash == first || td->td_hash == td) {
+			ohci_err(hc, "Circular pointer %s: %d %p %p %p\n",
+					msg, hash, first, td, td->td_hash);
+			td->td_hash = NULL;
+			return;
+		}
+	}
+}
+
+static void td_check_all(struct ohci_hcd *hc, char *msg)
+{
+	int	hash;
+
+	for (hash = 0; hash < TD_HASH_SIZE; ++hash)
+		td_check(hc, hash, msg);
+}
+
 static void
 td_free (struct ohci_hcd *hc, struct td *td)
 {
-	struct td	**prev = &hc->td_hash [TD_HASH_FUNC (td->td_dma)];
+	int 		hash = TD_HASH_FUNC(td->td_dma);
+	struct td	**prev = &hc->td_hash[hash];
 
-	while (*prev && *prev != td)
+	td_check(hc, hash, "#1a");
+	while (*prev && *prev != td) {
+		if ((unsigned long) *prev == 0xa7a7a7a7) {
+			ohci_err(hc, "poisoned hash at %p (%d) %p %p\n", prev,
+				hash, td, hc->td_hash[hash]);
+			return;
+		}
 		prev = &(*prev)->td_hash;
-	if (*prev)
+	}
+	if (*prev) {
 		*prev = td->td_hash;
+		if (*prev == td) {
+			ohci_err(hc, "invalid hash at %p (%d) %p %p\n", prev,
+				hash, td, hc->td_hash[hash]);
+			*prev = NULL;
+		}
+	}
 	else if ((td->hwINFO & cpu_to_hc32(hc, TD_DONE)) != 0)
 		ohci_dbg (hc, "no hash for td %p\n", td);
+	mb();
+	td_check(hc, hash, "#1b");
 	dma_pool_free (hc->td_cache, td, td->td_dma);
 }
 
Index: usb-2.6/drivers/usb/host/ohci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-q.c
+++ usb-2.6/drivers/usb/host/ohci-q.c
@@ -558,12 +558,14 @@ td_fill (struct ohci_hcd *ohci, u32 info
 
 	/* hash it for later reverse mapping */
 	hash = TD_HASH_FUNC (td->td_dma);
+	td_check(ohci, hash, "#2a");
 	td->td_hash = ohci->td_hash [hash];
 	ohci->td_hash [hash] = td;
 
 	/* HC might read the TD (or cachelines) right away ... */
 	wmb ();
 	td->ed->hwTailP = td->hwNextTD;
+	td_check(ohci, hash, "#2b");
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1127,9 +1129,11 @@ dl_done_list (struct ohci_hcd *ohci)
 {
 	struct td	*td = dl_reverse_done_list (ohci);
 
+	td_check_all(ohci, "#3a");
 	while (td) {
 		struct td	*td_next = td->next_dl_td;
 		takeback_td(ohci, td);
 		td = td_next;
 	}
+	td_check_all(ohci, "#3b");
 }

