Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36100 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZHXEfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 00:35:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MfRGq-0006NG-3N
	for linux-media@vger.kernel.org; Mon, 24 Aug 2009 06:35:04 +0200
Received: from ppp226-9.static.internode.on.net ([59.167.226.9])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2009 06:35:04 +0200
Received: from malcolm.caldwell by ppp226-9.static.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2009 06:35:04 +0200
To: linux-media@vger.kernel.org
From: Malcolm Caldwell <malcolm.caldwell@cdu.edu.au>
Subject: Nova-TD-500 (84xxx) problems (was Re: dib0700 diversity support)
Date: Mon, 24 Aug 2009 01:11:55 +0930
Message-ID: <1251042115.19935.16.camel@lychee.local>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>
	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please can someone help...

I have been trying to get my nova-td-500 to work, but no matter what I
try I get a substandard signal, with lots of errors.

This is about the same as described elsewhere on this list.

I tried this code (posted by Patrick Boettcher below), hoping it may be
a little better but, so far, it has not improved things at all.

I have even replaced the antenna on my roof, in the hope of getting a
better signal, but I still get errors.

I have tried the top, the bottom and both antenna connectors, but it
does not seem to make much difference.

Is there anything else I could try?  I really want a working system
again. (I replaced an old buggy card with this one, not knowing it would
be such a problem)


On Tue, 2009-08-18 at 10:54 +0200, Patrick Boettcher wrote:
> Hi Paul,
> 
> On Fri, 14 Aug 2009, Paul Menzel wrote:
> >> I'll post a request for testing soon.
> >
> > I am looking forward to it.
> 
> Can you please try the drivers from here: 
> http://linuxtv.org/hg/~pb/v4l-dvb/
> 
> In the best case they improve the situation for you. In the worst case 
> (not wanted :) ) it will degrade.
> 
> --
> 
> Patrick
> http://www.kernellabs.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



