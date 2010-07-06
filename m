Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0GFNqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jul 2010 09:46:53 -0400
Message-ID: <4C3333C6.60503@redhat.com>
Date: Tue, 06 Jul 2010 10:46:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <87y6dv2zn4.fsf@nemi.mork.no>
In-Reply-To: <87y6dv2zn4.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-07-2010 08:46, Bjørn Mork escreveu:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> 
>> My original idea were to send one of such emails per week, 
> 
> Nearly two months has passed since this message.  I apologize if I
> missed something, but I have not seen another status update. Is it just
> me?
> 
> Anyway, since the last status I've seen, 2.6.34 has been released, the
> 2.6.35 merge window has been open and then closed, and a number of new
> patches have been collected in 
> https://patchwork.kernel.org/project/linux-media/list/
> , many of which seem rather trivial.

Ideally, the patches that are OK should already be catched by a driver
maintainer and submitted me via git or mercurial pull request, and the bad
patches should already be nacked. The ones that are not merged from the 
normal process are the ones that are not trivial, among others, due to one
of the reasons bellow:
	- there's no driver maintainer;
	- the driver maintainer is lazy or overloaded;
	- there are some concerns about that patch;
	- there are some changes undergoing that will affect/be affected by
	  the patch;
	- the patch got forgotten/lost in the middle of the emails.

The fact is that the number of those patches are very high, causes me a lot
of overload to handle them and to send emails to people requesting the review
of those patches.

> Any chance of a new status update anytime soon?  

Updated today, after two or three weeks spent to handle the backlog.

I still have a few pull requests pending for 2.6.35-rc (bug fixes) that I'll
be handling this week.

> I'm particularily
> interested in getting a forced status change on any patch which was
> "under review" at the time of the last status message.  I believe it's
> reasonable to expect two months "review" to be more than enough.  If
> the patches are found unacceptable, then it's much better to have them
> rejected with a "please fix foo and resubmit" than the current total
> silence called "review".

The patches marked as under review means that I'm expecting an action
from someone else (the patch author or the driver author/maintainer).

So, if you have patches there still under review, you're helping us 
if you direct your complains to the one that it is sitting on the top
of them.

Cheers,
Mauro.
