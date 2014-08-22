Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:47836 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbaHVM3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 08:29:01 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAP005NPK0CUQ00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 22 Aug 2014 08:29:00 -0400 (EDT)
Date: Fri, 22 Aug 2014 07:28:56 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 01/21] si2168: clean logging
Message-id: <20140822072856.47b021e5.m.chehab@samsung.com>
In-reply-to: <53F733FB.7080507@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
 <1408705093-5167-2-git-send-email-crope@iki.fi>
 <20140822064748.70691346.m.chehab@samsung.com> <53F733FB.7080507@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Aug 2014 15:13:47 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 08/22/2014 02:47 PM, Mauro Carvalho Chehab wrote:
> > Hi Antti,
> >
> > Please don't add "GIT PULL" on patches. That breaks my scripts, as they
> > will run a completely different logic when those magic words are there
> > on a message at patchwork.
> >
> > Also, the word "FINAL" makes me nervous... That means that you sent me
> > a non-final pull request?
> 
> I didn't find better term. Also for eyes it wasn't proper term, but 
> there is no such prefix which fits that case:
> http://lwn.net/Articles/529490/

What is written there is:

	Once your patches have been reviewed/acked you can post either a pull request
	("[GIT PULL]") or use the "[FINAL PATCH x/y]" tag if you don't have a public
	git tree.

E. g. either send git pull or tag the patches as final, *if* the person 
sending the patches doesn't have a public git tree (although, in practice,
I think that nobody is using FINAL on patches nowadays).

I don't have any issue if someone uses "FINAL" on patches, but what
turns on a red flag is when someone uses "FINAL" on a git pull request,
because a pull request should be sent only when the patches are already ok.

In other words, a FINAL word on a GIT PULL makes me wander that there
is a previous pull request that is bad, but it doesn't give any glue 
about what pull request is broken.

Is it the case of this pull request? If so, what previous pull
request is broken?

I would rather strongly prefer that, in the case that you sent a previous
pull request that should be discarded, that you would reply to the
original GIT PULL request thread with a NACK for me to be aware that
I should discard it at patchwork.

Regards,
Mauro
