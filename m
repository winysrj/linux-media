Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53142 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbaHVMuH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 08:50:07 -0400
Message-ID: <53F73C7B.3080901@iki.fi>
Date: Fri, 22 Aug 2014 15:50:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 01/21] si2168: clean logging
References: <1408705093-5167-1-git-send-email-crope@iki.fi> <1408705093-5167-2-git-send-email-crope@iki.fi> <20140822064748.70691346.m.chehab@samsung.com> <53F733FB.7080507@iki.fi> <20140822072856.47b021e5.m.chehab@samsung.com>
In-Reply-To: <20140822072856.47b021e5.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/22/2014 03:28 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 22 Aug 2014 15:13:47 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 08/22/2014 02:47 PM, Mauro Carvalho Chehab wrote:
>>> Hi Antti,
>>>
>>> Please don't add "GIT PULL" on patches. That breaks my scripts, as they
>>> will run a completely different logic when those magic words are there
>>> on a message at patchwork.
>>>
>>> Also, the word "FINAL" makes me nervous... That means that you sent me
>>> a non-final pull request?
>>
>> I didn't find better term. Also for eyes it wasn't proper term, but
>> there is no such prefix which fits that case:
>> http://lwn.net/Articles/529490/
>
> What is written there is:
>
> 	Once your patches have been reviewed/acked you can post either a pull request
> 	("[GIT PULL]") or use the "[FINAL PATCH x/y]" tag if you don't have a public
> 	git tree.
>
> E. g. either send git pull or tag the patches as final, *if* the person
> sending the patches doesn't have a public git tree (although, in practice,
> I think that nobody is using FINAL on patches nowadays).
>
> I don't have any issue if someone uses "FINAL" on patches, but what
> turns on a red flag is when someone uses "FINAL" on a git pull request,
> because a pull request should be sent only when the patches are already ok.
>
> In other words, a FINAL word on a GIT PULL makes me wander that there
> is a previous pull request that is bad, but it doesn't give any glue
> about what pull request is broken.
>
> Is it the case of this pull request? If so, what previous pull
> request is broken?
>
> I would rather strongly prefer that, in the case that you sent a previous
> pull request that should be discarded, that you would reply to the
> original GIT PULL request thread with a NACK for me to be aware that
> I should discard it at patchwork.

There was no previous pull request. I just decided to send whole pull 
request to mailing list for last minute review, like they do on stable 
cases. But sure I could next time just pick patches and send pull 
request only.

regards
Antti

-- 
http://palosaari.fi/
