Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49989 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965157AbZLQPWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 10:22:46 -0500
Date: Thu, 17 Dec 2009 10:22:44 -0500 (EST)
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
In-Reply-To: <4B296D84.7090603@toaster.net>
Message-ID: <Pine.LNX.4.44L0.0912171011410.3055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 Dec 2009, Sean wrote:

> Thanks, that patch definitely traps the bug. Unfortunately there are so 
> many debug messages that the capture-example.c times out trying to 
> connect to the webcam. The debug messages slow down the process enough 
> to make that happen. But if I modify your patch and take out the extra 
> debug messages, it works well. The modified patch is below.

The patch doesn't fix anything.  The point was to gather enough 
information to figure out what's going wrong.  Without the debug 
messages, there's no information.

Perhaps things will slow down less if you change the new ohci_info() 
calls in the patch to ohci_dbg().  Or perhaps you can increase the 
timeout values in capture-example.c.

You should also apply this patch (be sure to enable CONFIG_USB_DEBUG):

	http://marc.info/?l=linux-usb&m=126056642931083&w=2

It probably won't make any difference, but including it anyway is
worthwhile.

Alan Stern

