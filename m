Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52588 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZH0KMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 06:12:36 -0400
Subject: Re: [linux-dvb] Can ir polling be turned off in cx88 module for
 Leadtek 1000DTV card?
From: Andy Walls <awalls@radix.net>
To: danieltaylor@acm.org
Cc: linux-media@vger.kernel.org, Dan Taylor <dan.taylor2@ca.rr.com>
In-Reply-To: <4A961F36.2060907@ca.rr.com>
References: <357341.28380.qm@web112510.mail.gq1.yahoo.com>
	 <1251329402.5232.6.camel@palomino.walls.org>
	 <Pine.LNX.4.58.0908262102280.11911@shell2.speakeasy.net>
	 <4A961F36.2060907@ca.rr.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 06:15:03 -0400
Message-Id: <1251368103.17460.2.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-08-26 at 22:52 -0700, Dan Taylor wrote:
> 
> Trent Piepho wrote:
> > On Wed, 26 Aug 2009, Andy Walls wrote:
> >> On Wed, 2009-08-26 at 07:33 -0700, Dalton Harvie wrote:
> >>>   If there isn't, would it be a good idea?
> >> Maybe.
> >>
> >>> Thanks for any help.
> >>
> >> Try this.  It adds a module option "noir" that accepts an array of
> >> int's.  For a 0, that card's IR is set up as normal; for a 1, that
> >> card's IR is not initialized.
> >>
> >> 	# modprobe cx88 noir=1,1
> > 
> > I think this is a good idea.  I was going to do someting similar
> > to stop the excessive irqs from my cx88 cards, which don't
> > even have remote receivers.
> > 
> > I haven't tried, but maybe it is possible to only turn on polling when the
> > event device is opened.
> 
> Excellent idea.  I did something similar for a pseudo-SCSI device, where I
> only polled if there was a command outstanding.
> 
> If no one else wants to take it on, I have a pcHDTV-3000 and -5000 and can
> get a Leadtek something to work with.


I don't have any hardware that uses the cx88 driver, so I'm certainly
not the right person to muck with it.

Have at it!

Regards,
Andy



