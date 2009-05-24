Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:37174 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753424AbZEXPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 11:16:02 -0400
Date: Sun, 24 May 2009 11:16:02 -0400 (EDT)
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
Message-ID: <Pine.LNX.4.44L0.0905241108340.8479-100000@netrider.rowland.org>
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

I see a suggestive pattern, though the exact mechanism still isn't 
clear.  The log shows:

	An URB for bulk endpoint 1-in (the only URB queued) completes.

	About 150 us later, the driver does Clear-Halt on that 
	endpoint.

	About 150 us after that, the driver submits another URB.
	Without the patch this URB completes normally and transfers
	64 bytes (i.e., only one packet).  With the patch, the URB 
	times out.

We can safely conclude that the endpoint toggle setting is getting out
of sync between the device and the host, as a result of the Clear-Halt.  
There is code in ehci-hcd to prevent this from happening; the question
is why doesn't it work now when it used to work before?

I'll think about it some more...

Alan Stern

