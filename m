Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:2614 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0ADUEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 15:04:31 -0500
Message-ID: <4B424963.5080902@toaster.net>
Date: Mon, 04 Jan 2010 12:02:43 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
References: <Pine.LNX.4.44L0.1001041035500.3180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001041035500.3180-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> Try inserting a line saying:
>
> 	td_check(ohci, hash, "#2c");
>
> two lines above the #2b line, i.e., just after the wmb().  That'll help 
> narrow down the search for the bug.
Alan,

I put the extra line in and ran capture-example twice. This is what I got:
 
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 1 c6782040 c66a4040 c6782040
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 1 c6782040 c66a4040 c6782040
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 1 c6782040 c66a4040 c6782040
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 1 c6782040 c66a4040 c6782040
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800
ohci_hcd 0000:00:0b.0: Circular pointer #2c: 32 c6782800 c66a4800 c6782800

Sean
