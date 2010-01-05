Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754639Ab0AEPLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 10:11:10 -0500
Date: Tue, 5 Jan 2010 10:11:07 -0500 (EST)
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
In-Reply-To: <4B42B2C6.8050702@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001051003080.3002-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jan 2010, Sean wrote:

> Alan Stern wrote:
> > Um, when you say it does the job, what do you mean?
> It traps the error and prevents the kernel from crashing.

As did some of the earlier patches, right?

> > The job it was _intended_ to do was to prove that your problems are
> > caused by hardware errors rather than software bugs.  If the patch
> > causes the problems to stop, without printing any error messages in the
> > log, then it does indeed prove this.  After all, the only places the
> > patch changes any persistent values are after it prints an error 
> > message.
> >   
> It did print out error messages:

> .ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
> c677b900                                                 
> ...ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
> c677b900                                               
> .ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
> c677b800                                                 

Ooh, that's odd.  The "Circular hash" message occurs in the same spot 
as the "Circular pointer #2a" message in the previous patch -- and that 
message never got printed!

> > I noticed that your CPU is a Cyrix.  Perhaps it is the culprit.  Have
> > you tried running the program on a different computer?
> >   
> Yes, on other computers I don't get this error. Same os image. Though I 
> haven't found a computer with an ohci controller yet.

So that's not a real test, unfortunately.

Still, at this point I'm not sure it's worthwhile to pursue this any
farther.  I'm convinced it's a hardware problem.  Do you want to 
continue, or are you happy to switch computers and forget about it?

Alan Stern

