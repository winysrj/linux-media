Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:58666 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751582AbZEYPW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 11:22:58 -0400
Date: Mon, 25 May 2009 11:23:00 -0400 (EDT)
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
In-Reply-To: <4A189187.4020407@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905251121370.23874-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 24 May 2009, David wrote:

> Alan Stern wrote:
> > It's not obvious what could be causing this, so let's start out easy.  
> > Try collecting two usbmon traces (instructions are in
> > Documentation/usb/usbmon.txt), showing what happens with and without
> > the reversion.  Maybe some difference will stick ou
> >   
> Traces attached. Took a while as my quad core hangs solid when 0u is
> piped to a file (I had to compile on a laptop and take the logs there).

Okay, here's a patch for you to try.  It refreshes the toggle setting 
in a linked but otherwise idle QH when a new URB is queued.

Alan Stern


Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -88,7 +88,7 @@ static inline void
 qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
 {
 	/* writes to an active overlay are unsafe */
-	BUG_ON(qh->qh_state != QH_STATE_IDLE);
+	BUG_ON(qh->qh_state != QH_STATE_IDLE && !list_empty(&qh->qtd_list));
 
 	qh->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
 	qh->hw_alt_next = EHCI_LIST_END(ehci);
@@ -971,7 +971,13 @@ static struct ehci_qh *qh_append_tds (
 		/* can't sleep here, we have ehci->lock... */
 		qh = qh_make (ehci, urb, GFP_ATOMIC);
 		*ptr = qh;
+	} else if (list_empty(&qh->qtd_list)) {
+		/* There might have been a Clear-Halt while the QH
+		 * was linked but empty.
+		 */
+		qh_refresh(ehci, qh);
 	}
+
 	if (likely (qh != NULL)) {
 		struct ehci_qtd	*qtd;
 

