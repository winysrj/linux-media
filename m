Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:45709 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752463AbZEYVMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 17:12:23 -0400
Date: Mon, 25 May 2009 17:12:25 -0400 (EDT)
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
Message-ID: <Pine.LNX.4.44L0.0905251709560.27975-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2009, David wrote:

> David wrote:
> > Alan Stern wrote:
> >   
> >> Okay, here's a patch for you to try.  It refreshes the toggle setting 
> >> in a linked but otherwise idle QH when a new URB is queued.
> >>
> >> Alan Stern
> >>
> >>
> >> Index: usb-2.6/drivers/usb/host/ehci-q.c
> >> ===================================================================
> >> --- usb-2.6.orig/drivers/usb/host/ehci-q.c
> >> +++ usb-2.6/drivers/usb/host/ehci-q.c
> >> @@ -88,7 +88,7 @@ static inline void
> >>  qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
> >>  {
> >>  	/* writes to an active overlay are unsafe */
> >> -	BUG_ON(qh->qh_state != QH_STATE_IDLE);
> >> +	BUG_ON(qh->qh_state != QH_STATE_IDLE && !list_empty(&qh->qtd_list));
> >>  
> >>  	qh->hw_qtd_next = QTD_NEXT(ehci, qtd->qtd_dma);
> >>  	qh->hw_alt_next = EHCI_LIST_END(ehci);
> >> @@ -971,7 +971,13 @@ static struct ehci_qh *qh_append_tds (
> >>  		/* can't sleep here, we have ehci->lock... */
> >>  		qh = qh_make (ehci, urb, GFP_ATOMIC);
> >>  		*ptr = qh;
> >> +	} else if (list_empty(&qh->qtd_list)) {
> >> +		/* There might have been a Clear-Halt while the QH
> >> +		 * was linked but empty.
> >> +		 */
> >> +		qh_refresh(ehci, qh);
> >>  	}
> >> +
> >>  	if (likely (qh != NULL)) {
> >>  		struct ehci_qtd	*qtd;
> >>  
> >>
> >>   
> >>     
> > No luck I'm afraid (although there now appear to be 2 timeouts, not
> > one). I'm going to follow up on the laptop and get a USB log.
> >   
> USB log post-patch attached. Thanks for all the effort so far!

Yes, the log shows two timeouts.  Maybe I misunderstood something and 
the patch only made the situation worse!

We may have to try a debugging patch to find out what's really 
happening here.  I'll get back to you on that...

Alan Stern

