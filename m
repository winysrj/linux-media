Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32842 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZEZAvx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 20:51:53 -0400
Date: Mon, 25 May 2009 18:48:43 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: David <david@unsolicited.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, zaitcev@redhat.com
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
 down
Message-Id: <20090525184843.33c93006.zaitcev@redhat.com>
In-Reply-To: <4A1A8E53.9060108@unsolicited.net>
References: <4A1967A2.4050906@unsolicited.net>
	<Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>
	<20090524203902.594a0eec.zaitcev@redhat.com>
	<4A1A5E24.20201@unsolicited.net>
	<4A1A8E53.9060108@unsolicited.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2009 13:25:55 +0100, David <david@unsolicited.net> wrote:

> >> I wonder if CONFIG_HAVE_DMA_API_DEBUG does it (enabled with a select
> >> in arch/x86/Kconfig). Strange that it started happening now.
> >>     
> > That is enabled. I'll switch it off and give it another go.
> >   
> While CONFIG_HAVE_DMA_API_DEBUG was set, DMA_API_DEBUG was not, so I
> guess there's nothing I can do to test?

I suppose so. I misunderstood how this worked. I guessed that the
DMA API debugging was the culprit because its introduction coincided
with the recent onset of this oops.

Although usbmon does essentially illegal tricks to look at data
already mapped for DMA, the code used to work for a few releases.
Bisecting may help. I cannot be sure of it though, and it's
going to take a lot of reboots.

Unfortunately, although I have an Opteron, the issue does not
occur here, so I'm at a loss for the moment. But I'll have to
tackle it somehow. Not sure how though. Any suggestions are welcome.

-- Pete
