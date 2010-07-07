Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44967 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0GGMwd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 08:52:33 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OWU76-0000h2-Rn
	for linux-media@vger.kernel.org; Wed, 07 Jul 2010 14:52:32 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 14:52:32 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 14:52:32 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: Status of the patches under review (85 patches) and some misc notes about the devel procedures
Date: Wed, 07 Jul 2010 14:52:22 +0200
Message-ID: <87d3uzqws9.fsf@nemi.mork.no>
References: <20100507093916.2e2ef8e3@pedra> <87y6dv2zn4.fsf@nemi.mork.no>
	<4C3333C6.60503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> Em 01-07-2010 08:46, Bjørn Mork escreveu:
>> Any chance of a new status update anytime soon?  
>
> Updated today, after two or three weeks spent to handle the backlog.

Great!  Thanks.  It's really appreciated, and I do note that it made
quite a few people finally ack/nak the patches they were supposed to
review. 

>> I'm particularily
>> interested in getting a forced status change on any patch which was
>> "under review" at the time of the last status message.  I believe it's
>> reasonable to expect two months "review" to be more than enough.  If
>> the patches are found unacceptable, then it's much better to have them
>> rejected with a "please fix foo and resubmit" than the current total
>> silence called "review".
>
> The patches marked as under review means that I'm expecting an action
> from someone else (the patch author or the driver author/maintainer).

Well, I'm of course not in a position to tell you how to do your job, so
please regard this as a humble suggestion only...

But I believe you make your job much harder by defining a number of
"unofficial" driver maintainers and giving them indefinite slack, while
at the same time *you* are the one having to keep track of all their
outstanding patches.  Either you delegate the maintainance properly,
documenting it in MAINTAINERS and pointing there whenever someone sends
a patch directly to you, or you might as well just do the ack/nak
yourself based on the mailing list feedback.

Putting yourself in the middle, taking the patch queue responsibility,
but not the ack/nak responsibility, is just wasting your time on
accounting and other boring work...

I do believe that having the original author(s) maintain a driver is a
very good idea as long as they are still actively maintaining it.  But
this must be based on actual maintainance, and not some misunderstood
"ownership based on previous contributions".  That's what the CREDITS
file is for.

Please look at other subsystems with a large number of old drivers, like
e.g. networking.  It's not like it's possible to have every tiny patch
approved by the original author all the time.  This does not hinder some
newer drivers having very active official maintainers, like the Intel
e1000(e) drivers, nor does it hinder the original authors from
participating on the mailing list giving their comments and ack/nak if
they want.  But if they don't respond on the list, davem will just make
a decision for himself without waiting for it.

> So, if you have patches there still under review, you're helping us 
> if you direct your complains to the one that it is sitting on the top
> of them.

Oh, it's not so much my submissions bothering me (I have received some
very good feedback on this list), but the fact that some drivers do not
get any updates at all, even though patches are submitted to this
mailing list.  Not to mention the problem that patch submissions will
(and do) stop due to the lack of any feedback whatsoever.  Most people
have better things to do than writing to /dev/null, and that's the
feeling this queuing-for-original-author-review system leaves.


Bjørn

