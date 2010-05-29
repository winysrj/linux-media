Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50490 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0E2EAx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 00:00:53 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OIDEB-00075f-DG
	for linux-media@vger.kernel.org; Sat, 29 May 2010 06:00:51 +0200
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 06:00:51 +0200
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 06:00:51 +0200
To: linux-media@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: [PATCH] Support for the Geniatech/Mygica A680B (05e1:0480)
Date: Sat, 29 May 2010 04:00:38 +0000 (UTC)
Message-ID: <htq3h6$uor$1@dough.gmane.org>
References: <1273242667.6020.15.camel@chimera>
	<20100526010851.6cd39798@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 May 2010 01:08:51 -0300, Mauro Carvalho Chehab wrote:

> It would be nice to have Michael ack, if you're using part of his code
> on your patch.

Quite.

> It is a very bad idea to use a counter in seconds, especially since your
> expected delay is of one second. This means that you may way from 0 to 1
> seconds. The better way would be to do something like:
> 
> #define LOCK_DELAY 500	/* time in miliseconds */ state-
>lock_time =
> jiffies + msecs_to_jiffies(LOCK_DELAY);

I considered doing something of this nature but thought it was not 
important enough for the delay to be that exact to do anything special to 
track it, but I think I do like your suggestion better than what I did.

> Note that I've defined 500 ms, as it is the mean time between 0 and 1
> seconds. I suspect that you may use a lower delay time, since 500 ms
> seems a very long time to let the frontend lock.

I was experimenting with different delays from 500 to 2000, and based on 
what I saw, I don't think any delay below 750 would be useful, if not 
1250.

> I would also add a comment that this is a workaround, since we currently
> don't know any way to read the signal lock (since the right procedure
> would be to, instead, read some register value to be sure that the demod
> has locked).

I operated under the assumption that this demod is not equipped with any 
mechanism to detect a lock as opposed to sync, and would therefore have 
nothing to report. This assumption was not based on anything, and if it's 
incorrect, then yes, this workaround is pointless.

> Also, the better is to split the "flakiness" patch from the geniatech
> board addition, as they are two different logical changes.

There are a couple more logical changes, and I thought the board addition 
too trivial without them to split off. The entire patch is pretty small; 
is splitting it that important?

> Wouldn't be better to add instead a "lock_delay" parameter, with the
> lock delay time, in milliseconds? Of course, you need to validate if the
> time is between an allowed range (for example, from -1 to 2000 ms).

I had thought of doing that, but I put it in the per-board demod 
configuration because I cannot test its effect on other boards, which may 
need different delays, if any. However, since the ultimate purpose of 
this parameter is to test which boards may or may not benefit from a 
delay in their demod configuration, it may indeed be a better idea to 
specify the delay in the parameter.

