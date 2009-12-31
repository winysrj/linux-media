Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42746 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZLaTlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 14:41:22 -0500
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
From: Andy Walls <awalls@radix.net>
To: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>,
	Steven Toth <stoth@kernellabs.com>, isely@pobox.com,
	linux-media@vger.kernel.org
In-Reply-To: <1262287607.3055.115.camel@palomino.walls.org>
References: <200912311815.38865.martin.dauskardt@gmx.de>
	 <1262287607.3055.115.camel@palomino.walls.org>
Content-Type: text/plain
Date: Thu, 31 Dec 2009 14:40:15 -0500
Message-Id: <1262288415.3055.121.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-31 at 14:26 -0500, Andy Walls wrote:
> On Thu, 2009-12-31 at 18:15 +0100, Martin Dauskardt wrote:

Some corrections to errors:

> My preferences in summary, is that not matter what the digitizer chip:

My preferences are, in summary, that no matter what the digitizer chip:

> a. I'd like to keep the audio clocks always up to avoid tinny audio.
> 
> b. I'd also like to inhibit the video clock and add the delay after
                                                  ^^^
                                                  refine
> re-enabling the digitizer to avoid the *potential* for a hung machine.
A value smaller than 300 ms should work, but a value smaller than 40 ms
may not work, if my hypothesis is correct.


> 
> c. I do not care to much about the delay after disbaling the video
> clock, only that it is empirically "long enough".
> 
> Thanks for taking the time to test and comment.
> 
> Regards,
> Andy

Regards,
Andy

> > Greets and Happy New Year 
> > 
> > Martin
> > 
> > PS:
> > Readers on the ivtv-devel ML list will miss previous postings (the list was 
> > down a few days). Please have a look in 
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14151
> > and
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14155


