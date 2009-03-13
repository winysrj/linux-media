Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:33265 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZCMQlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 12:41:14 -0400
Date: Fri, 13 Mar 2009 08:40:58 -0700
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090313154058.GB14186@jenkins.ifup.org>
References: <20090311221555.GB5776@jenkins.ifup.org> <Pine.LNX.4.44L0.0903131033140.2898-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903131033140.2898-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10:35 Fri 13 Mar 2009, Alan Stern wrote:
> On Wed, 11 Mar 2009, Brandon Philips wrote:
> 
> > On 15:46 Wed 11 Mar 2009, Alan Stern wrote:
> > > On Wed, 11 Mar 2009, Brandon Philips wrote:
> > > Okay, here's a diagnostic patch meant to apply on top of 
> > > gregkh-all-2.6.29-rc7.  Let's see what it says...
> > 
> > Here is the log:
> >  http://ifup.org/~philips/467317/pearl-alan-debug.log
> > 
> > >  	default:
> > >  		qh = (struct ehci_qh *) urb->hcpriv;
> > > +		if (alantest == 1) {
> > > +			alantest = 2;
> > > +			ehci_info(ehci, "dequeue: qh %p\n", qh);
> > > +		}
> > 
> > This was the last thing printed before I dumped the task states with sysrq
> > keys.
> 
> Okay, not much information there but it's a start.  Here's a more 
> informative patch to try instead.

Here is the log:
 http://ifup.org/~philips/467317/pearl-alan-debug-2.log

Thanks,

	Brandon
