Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:56860 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0JANRb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 09:17:31 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1P1fUQ-00086A-IM
	for linux-media@vger.kernel.org; Fri, 01 Oct 2010 15:17:30 +0200
Received: from 193.160.199.1 ([193.160.199.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 01 Oct 2010 15:17:30 +0200
Received: from bjorn by 193.160.199.1 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 01 Oct 2010 15:17:30 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH/RFC v2 0/8] dsbr100: driver cleanup and fixes
Date: Fri, 01 Oct 2010 15:17:20 +0200
Message-ID: <87hbh6yrvj.fsf@nemi.mork.no>
References: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
	<AANLkTi=QujvRkdSLBMm14ZpOy2GCk8Ow3d87FAAz6GGY@mail.gmail.com>
	<AANLkTikHxgTrBq9+8Gm8eTNzXoWA0Br44dQx0eif91q4@mail.gmail.com>
	<AANLkTikqq1xz9VUJezUS4LhizYiJ7FQojjnqreXw7=QV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

David Ellingsworth <david@identd.dyndns.org> writes:

>> I will also check your patches soon. I have this old hardware at home.
>>
>
> The sooner the better. These patches have been waiting for review
> since May. I'd rather not have to rebase them and resend them a third
> time.

The current review process for drivers abandoned by the original author
is not working.

I really, really fail too see the problem with just letting a clean
compile-tested patchset like yours through after, let's say, a week
without any comments at all.  That's probably the only way it is ever
going to be tested by someone with the actual hardware.  Worst case is
that some of the patches will have to be reverted in the next release
(and stable point release).  That's not going to be problematic at all,
given that the patchset only touches a single driver in maintenance
mode.

Please Mauro, can you implement some sort of deadline for your review
cycles?  Half a year is nowhere close to acceptable for non-
controversial stuff like this. 

Spotting the non-controversial patches is easy BTW:  Just look for
those with no comments at all...


Bjørn

