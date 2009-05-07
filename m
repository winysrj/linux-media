Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:45081 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbZEGNBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 09:01:30 -0400
To: hermann pitton <hermann-pitton@arcor.de>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: Re: saa7134/2.6.26 regression, noisy output
In-reply-to: <1241565988.16938.15.camel@pc07.localdom.local>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org> <1241389925.4912.32.camel@pc07.localdom.local> <20090504091049.D931B2C4147@tippex.mynet.homeunix.org> <1241438755.3759.100.camel@pc07.localdom.local> <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org> <1241565988.16938.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 07 May 2009 15:00:55 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


hermann-pitton@arcor.de said:
> hmm, the idea eventually was, to download these two snapshots, or make the
> last few changes manually on the first and try on 2.6.25.
>
> Then we might know, if the problem is already visible within Hartmut's latest
> fix attempts or even more and other stuff is involved. 

I see. I'll dig myself into hand applying those patches. It seems quite some 
stuff changed between 2.6.25 and what those patches assumes. Let's see what I
dig up.

BR,
-Anders


