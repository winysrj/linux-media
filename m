Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab1BXXdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 18:33:07 -0500
Message-ID: <4D66EAAC.7020601@redhat.com>
Date: Thu, 24 Feb 2011 20:33:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/9 v2] ds3000: clean up in tune procedure
References: <201102020040.49656.liplianin@me.by> <4D66ABAF.5020908@infradead.org> <4D66AD51.6090608@redhat.com> <201102242225.35913.liplianin@me.by>
In-Reply-To: <201102242225.35913.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-02-2011 17:25, Igor M. Liplianin escreveu:
> В сообщении от 24 февраля 2011 21:11:13 автор Mauro Carvalho Chehab написал:
>> Em 24-02-2011 16:04, Mauro Carvalho Chehab escreveu:
>>> Hi Igor,
>>>
>>> Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
>>>> Variable 'retune' does not make sense.
>>>> Loop is not needed for only one try.
>>>> Remove unnecessary dprintk's.
>>>>
>>>> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
>>>
>>> This patch didn't apply. Please fix and resend.
>>
>> PS.: I won't try to apply patches 7, 8 and 9, as they are all related to
>> tune changes. They'll probably fail to apply, and, even if not failing or
>> if I fix the conflicts, they may be breaking the driver. So, please put
>> them on your next patch series.
>>
>> thanks!
>> Mauro
> Hi Mauro,
> 
> Will do tonight.

OK.

> BTW, Why did you dropp/miss dw2102 patches?
> They was sent before ds3000 series.

I probably missed, or they are still on my queue. While in general I apply
patches in order, sometimes I reorder them, trying to merge first the more
trivial ones (or the ones that I had already analyzed, like the altera ones). 
Please take a look at Patchwork. If they're there, then I'll probably be 
handling until the weekend. Otherwise, just re-send them to me.

That's said, it is probably a good idea if you could have a git repository
somewhere to send me patches. Git works better when there are lots of
patches, so, works better for driver maintainers.

Thanks,
Mauro
