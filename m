Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbZHUXZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 19:25:00 -0400
Date: Fri, 21 Aug 2009 20:24:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
 2.6.16-2.6.21: ERRORS
Message-ID: <20090821202452.6f4c3b24@pedra.chehab.org>
In-Reply-To: <1250892645.3159.3.camel@palomino.walls.org>
References: <200908211817.n7LIHIqA054646@smtp-vbr4.xs4all.nl>
	<200908212245.05796.hverkuil@xs4all.nl>
	<1250892645.3159.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2009 18:10:45 -0400
Andy Walls <awalls@radix.net> escreveu:

> > Guys, I'm providing this service for a reason: please take a look at the 
> > detailed log when you see errors or warnings.
> > 
> > This time round we have a compat error with DIV_ROUND_CLOSEST:
> > 
> > v4l/stb6100.c: In function 'stb6100_set_frequency':
> > v4l/stb6100.c:377: error: implicit declaration of 
> > function 'DIV_ROUND_CLOSEST'
> > 
> > Should be simple to fix. This macro appeared in 2.6.29 and so should be made 
> > available in compat.h.
> 
At the days I'm preparing some upstream patches, it is not rare to have some
backport breakage, since lots of patches are merged, including, on some cases,
some upstream patches that need extra backport.

I intend to finish sync -hg and -git this weekend, so, I'll be fixing the remaining backport issues.

> A patch for this one was submitted to the list earlier today:
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/9142
> 
> (though not because I saw it in the logs).

I saw that. It will be merged as well.


Cheers,
Mauro
