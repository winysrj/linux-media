Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:3918 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbZBBT3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 14:29:54 -0500
Message-ID: <498746E9.8010000@clara.co.uk>
Date: Mon, 02 Feb 2009 19:18:01 +0000
From: Chris Mayo <mayo@clara.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] general protection fault: 0000 [1] SMP with 2.6.27
 and	2.6.28
References: <49565ABD.7030209@clara.co.uk> <498467E3.4010403@clara.co.uk>	 <1233524352.3091.51.camel@palomino.walls.org>	 <200902012338.49861@orion.escape-edv.de> <1233536229.3091.58.camel@palomino.walls.org>
In-Reply-To: <1233536229.3091.58.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2009-02-01 at 23:38 +0100, Oliver Endriss wrote:
>> Andy Walls wrote:
>>> On Sat, 2009-01-31 at 15:01 +0000, Chris Mayo wrote:
> 
>>> So tuner_addr is non-NULL and is not a valid pointer either.
>>>
>>> It looks like linux/drivers/media/dvb/ttpci/budget.c:frontend_init() is
>>> setting the pointer up properly.  So something else is trashing the
>>> struct dvb_frontend structure pointed to by the variable fe.  Finding
>>> what's doing that will be difficult.
>>>
>>> Without a device nor steps to reliably reproduce, that's about all I can
>>> help with.
>>>
>>> Regards,
>>> Andy
>> Afaik this bug was fixed in changeset
>> http://linuxtv.org/hg/v4l-dvb/rev/f4d7d0b84940
>>
>> CU
>> Oliver
> 
> Thanks.  I didn't realize the initialization to NULL was a recent fix.
> I was looking at very recent v4l-dvb source code with that change in
> place (which is why I thought tracking down the problem would be hard).
> 
> I agree that that change likely fixes the problem, if Chris doesn't have
> it in place.
> 
> Regards,
> Andy
> 

I didn't have the patch (and hadn't seen it so seems a good advert for
merging the lists). Have applied it to 2.6.28 and OK so far. Thanks for
pointing it out and the investigation.

Chris
