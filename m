Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56579 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752402AbZEZOIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 10:08:19 -0400
Date: Tue, 26 May 2009 10:08:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Pete Zaitcev <zaitcev@redhat.com>
cc: David <david@unsolicited.net>,
	USB list <linux-usb@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
In-Reply-To: <20090525184843.33c93006.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0905261006500.3584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2009, Pete Zaitcev wrote:

> On Mon, 25 May 2009 13:25:55 +0100, David <david@unsolicited.net> wrote:
> 
> > >> I wonder if CONFIG_HAVE_DMA_API_DEBUG does it (enabled with a select
> > >> in arch/x86/Kconfig). Strange that it started happening now.
> > >>     
> > > That is enabled. I'll switch it off and give it another go.
> > >   
> > While CONFIG_HAVE_DMA_API_DEBUG was set, DMA_API_DEBUG was not, so I
> > guess there's nothing I can do to test?
> 
> I suppose so. I misunderstood how this worked. I guessed that the
> DMA API debugging was the culprit because its introduction coincided
> with the recent onset of this oops.
> 
> Although usbmon does essentially illegal tricks to look at data
> already mapped for DMA, the code used to work for a few releases.
> Bisecting may help. I cannot be sure of it though, and it's
> going to take a lot of reboots.
> 
> Unfortunately, although I have an Opteron, the issue does not
> occur here, so I'm at a loss for the moment. But I'll have to
> tackle it somehow. Not sure how though. Any suggestions are welcome.

Try asking the people responsible for maintaining DMA support for help.  

And David is very good about testing new patches.

Alan Stern

