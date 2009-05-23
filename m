Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36466 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752491AbZEWPPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 11:15:16 -0400
Date: Sat, 23 May 2009 11:15:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David <david@unsolicited.net>, <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
In-Reply-To: <84144f020905230125n32e9533dk112db9b31763e15c@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905231109140.18397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 23 May 2009, Pekka Enberg wrote:

> On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> > I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
> > finally had time to do some digging, and the regression is caused by:
> >
> >    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups
> >
> > ..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
> > makes the card work happily again.
> 
> [ Note: David meant 2.6.30-rc5 here. ]
> 
> Thanks for doing the bisect!
> 
> On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> > I don't know enough about USB protocols to speculate on whether there
> > may be a better fix, but hopefully someone cleverer than me can get to
> > the bottom of the problem?

It's hard to see how that patch could cause any problems, provided the
hardware is working correctly.  (There was a case where the hardware
was _not_ working as expected.)  Is any more information available
about this failure?

Alan Stern

