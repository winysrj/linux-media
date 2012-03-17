Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46968
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921Ab2CQV2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 17:28:51 -0400
Date: Sat, 17 Mar 2012 22:28:47 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: David Miller <davem@davemloft.net>
cc: santoshprasadnayak@gmail.com, hjlipp@web.de, tilman@imap.cc,
	isdn@linux-pingi.de, gigaset307x-common@lists.sourceforge.net,
	netdev@vger.kernel.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] isdn: Return -EINTR in gigaset_start() if locking attempts
 fails.
In-Reply-To: <20120317.135854.570143927282385505.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1203172225080.2364@localhost6.localdomain6>
References: <1331903413-11426-1-git-send-email-santoshprasadnayak@gmail.com> <20120316.231856.1071253468993560433.davem@davemloft.net> <CAOD=uF6JJiiGjQwybzwdU3Zw9pC8YbDPxm_Pg9E9WNAXbfTiUQ@mail.gmail.com>
 <20120317.135854.570143927282385505.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 17 Mar 2012, David Miller wrote:

> From: santosh prasad nayak <santoshprasadnayak@gmail.com>
> Date: Sat, 17 Mar 2012 21:26:14 +0530
>
>> Caller is interpreting 0 in opposite way of normal sequence.
>> Thats why I misunderstood it.
>
> The simple fact is that you didn't even look at the code at the call
> sites when you wrote this patch, and that's the first thing anyone is
> going to do when reviewing it.
>
> Therefore your laziness results in more useless work for other people.
> I just wanted to point out how selfish and anti-social this kind of
> behavior is.

Not to pour too much salt on a wound, but just 5 lines above the patch 
site is the comment:

  * Return value:
  *      1 - success, 0 - error

And the error label also returns 0.  So there is a lot of local 
information that one can use to see what protocol the function follows.

That said, it's a bit too bad that two protocols have to coexist.

julia
