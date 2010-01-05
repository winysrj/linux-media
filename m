Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:41506 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753463Ab0AECkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 21:40:51 -0500
Date: Mon, 4 Jan 2010 21:40:50 -0500 (EST)
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
In-Reply-To: <4B426A8F.2030808@toaster.net>
Message-ID: <Pine.LNX.4.44L0.1001042129530.26506-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jan 2010, Sean wrote:

> Alan,
> This last patch seems to do the job. Thanks so much for your help! Where 
> do I donate/send beer?

Um, when you say it does the job, what do you mean?

The job it was _intended_ to do was to prove that your problems are
caused by hardware errors rather than software bugs.  If the patch
causes the problems to stop, without printing any error messages in the
log, then it does indeed prove this.  After all, the only places the
patch changes any persistent values are after it prints an error 
message.

(Admittedly, I didn't expect the problem to stop; I expected to get a
bunch of messages from the second ohci_err().  Just out of curiosity, 
does it make any difference if you remove all those "volatile"s in the 
declaration line for td1 and td2?)

I noticed that your CPU is a Cyrix.  Perhaps it is the culprit.  Have
you tried running the program on a different computer?

Alan Stern

