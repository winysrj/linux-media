Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2646 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752524AbZCGRhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 12:37:10 -0500
Date: Sat, 7 Mar 2009 12:37:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Brandon Philips <brandon@ifup.org>
cc: Greg KH <gregkh@suse.de>, <laurent.pinchart@skynet.be>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
 is probably using the wrong IRQ."
In-Reply-To: <20090307084225.GF6869@jenkins.ifup.org>
Message-ID: <Pine.LNX.4.44L0.0903071230190.6084-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Mar 2009, Brandon Philips wrote:

> On 21:26 Fri 06 Mar 2009, Greg KH wrote:
> > On Fri, Mar 06, 2009 at 11:11:22AM -0800, Brandon Philips wrote:
> > > Hello-
> > > 
> > > When an UVC device is open and a S4 is attempted the thaw hangs (see the
> > > stack below). I don't see what the UVC driver is doing wrong to cause
> > > this to happen though.
> > 
> > I don't think this is a uvc driver issue, it looks like all you are
> > trying to do is a usb control message when things hang.
> 
> Indeed. When I was poking at this I tried to supress the control message coming
> out of the uvcvideo driver after the suspend was issued to see what would
> happen and the control messages after the resume locked up instead. Eh.

Have you tried suspending just the two devices plugged into that EHCI 
controller instead of suspending the entire system?  That would make it 
a lot easier to carry out testing.

> > It looks like things die right after this message:
> > 	ehci_hcd 0000:00:1d.7: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.

It could be that the host controller isn't behaving correctly.  But 
even then, a timer should keep things running.  So I don't know why the 
system hanged.

BTW, all those extra debugging messages in your log made it very 
difficult to read, and they didn't help much in pinpointing the 
problem.  You should remove all of them before doing the next test.  
Instead you could use usbmon to capture the USB traffic.

Alan Stern

