Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752235Ab0ADQHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 11:07:00 -0500
Date: Mon, 4 Jan 2010 11:06:59 -0500 (EST)
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
In-Reply-To: <4B412CA5.8020507@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001041035500.3180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 3 Jan 2010, Sean wrote:

> Alan,
> 
> I applied the patches and ran capture-example twice. On the second run 
> of capture-example a circular pointer popped up. I did not need to 
> remove the camera. Attached are the serial console capture as well as 
> the dmesg log in debug4.tar.gz. Did you want me to try to reproduce the 
> poison message?

No.  Among the things that patch did was to fix up the errors that 
caused the invalid pointers.  Hence there should not have been any 
"poisoned hash" messages -- and indeed there weren't.

The interesting part of the log is the error messages:

ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 1 c6774040 c6542040 c6774040
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 1 c6774040 c6542040 c6774040
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 1 c6774040 c6542040 c6774040
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800
ohci_hcd 0000:00:0b.0: Circular pointer #2b: 32 c6774800 c6542800 c6774800

There are two different hash chains here (32 and 1), but in each case
see the message is #2b, never #2a.  This means the problem occurs
between the places where the #2a and #2b messages were inserted, i.e.,
in td_fill().  The hash chain contained a single TD and was fine to
begin with; then another TD was added at the start of the chain and the
pointer in the earlier TD (now at the second position in the chain) got
messed up.

For example, the error message in the first line above implies that
originally the 32nd hash chain contained only the TD at c6542800 with
its td_hash member set to NULL.  But then c6774800 was added to the
start of the chain, after which c6542800's td_hash pointed to c6774800.

Try inserting a line saying:

	td_check(ohci, hash, "#2c");

two lines above the #2b line, i.e., just after the wmb().  That'll help 
narrow down the search for the bug.

And by the way, you don't need to post your entire dmesg log.  Just the 
portion containing the new debugging messages will be enough.

Alan Stern

