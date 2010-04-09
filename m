Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:6961 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755445Ab0DIVU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 17:20:27 -0400
Subject: Re: [PATCH] V4L/DVB: saa7146: IRQF_DISABLED causes only trouble
From: Andy Walls <awalls@md.metrocast.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org, stable@kernel.org
In-Reply-To: <877hoifeec.fsf@nemi.mork.no>
References: <1269202135-340-1-git-send-email-bjorn@mork.no>
	 <1269206641.6135.68.camel@palomino.walls.org> <87ocigwvrf.fsf@nemi.mork.no>
	 <1270634174.3021.176.camel@palomino.walls.org>
	 <877hoifeec.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 17:20:40 -0400
Message-Id: <1270848040.3038.36.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-04-08 at 12:05 +0200, Bjørn Mork wrote:
> Ehh...., this is very embarrassing, but please disregard all my
> statements about a hanging system related to IRQF_DISABLED.
> 
> It turns out that I've had a faulty SATA hard drive which probably have
> caused all these problems.  I do not understand the inner workings of
> the SATA hardware and software, but it appears that this drive has been
> able to block interrupts for a considerable time without SMART detecting
> any error at all.  I wrongly suspected saa7146 to be the cause because
> these problems appeared after adding the saa7146 hardware.  But that was
> probably just a coincidence (or maybe not really, only unrelated: I
> suspect that the problem was triggered by the powercycle when adding
> this card)
> 
> The drive has now been replaced, and I will start verifying that use of
> saa7146 with IRQF_DISABLED does not in fact pose any real problems at
> all.

Don't bother.

It's probably a good thing you found your root cause.  Your patch was
going to be invalidated in the near future: 

	http://lwn.net/Articles/380931/

It appears that IRQF_DISABLED behavior is to be the default behavior for
all drivers and the flag is to have no effect.



> I still find the discussion about it's usefulness interesting though...

Good. :)


Regards,
Andy

