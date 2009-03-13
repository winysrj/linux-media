Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34373 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751549AbZCMUuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 16:50:07 -0400
Date: Fri, 13 Mar 2009 16:50:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090313194647.GC21008@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903131647500.5149-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009, Brandon Philips wrote:

> On 14:03 Fri 13 Mar 2009, Alan Stern wrote:
> > On Fri, 13 Mar 2009, Brandon Philips wrote:
> > 
> > > > Okay, not much information there but it's a start.  Here's a more 
> > > > informative patch to try instead.
> > > 
> > > Here is the log:
> > >  http://ifup.org/~philips/467317/pearl-alan-debug-2.log
> > 
> > I still can't tell what's happening.  Here's yet another patch.
> 
> http://ifup.org/~philips/467317/pearl-alan-debug-3.log

I think I see the problem; the patch below is an attempted fix.
Hopefully it will get your system working.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -1127,7 +1127,7 @@ static void start_unlink_async (struct e
 	prev->qh_next = qh->qh_next;
 	wmb ();
 
-	if (unlikely (ehci_to_hcd(ehci)->state == HC_STATE_HALT)) {
+	if (unlikely(!HC_IS_RUNNING(ehci_to_hcd(ehci)->state))) {
 		/* if (unlikely (qh->reclaim != 0))
 		 *	this will recurse, probably not much
 		 */

