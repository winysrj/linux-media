Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:49035 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0D1M3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 08:29:16 -0400
Message-ID: <4BD82A16.5020301@web.de>
Date: Wed, 28 Apr 2010 14:29:10 +0200
From: =?UTF-8?B?QW5kcsOpIFdlaWRlbWFubg==?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: Guy Martin <gmsoft@tuxicoman.be>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>	<4BD7E7A3.2060101@web.de> <20100428103303.2fe4c9ea@zombie>
In-Reply-To: <20100428103303.2fe4c9ea@zombie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guy,

On 28.04.2010 10:33, Guy Martin wrote:

> On Wed, 28 Apr 2010 09:45:39 +0200
> André Weidemann<Andre.Weidemann@web.de>  wrote:
>
>> I advise not to pull this change into the kernel sources.
>> The card has only been testet with the a maximum current of 515mA.
>> Anything above is outside the specification for this card.
>
>
> I'm currently running two of these cards in the same box with this
> patch.
> Actually, later on I've even set curlim = SEC_CURRENT_LIM_OFF because
> sometimes diseqc wasn't working fine and that seemed to solve the
> problem.
>
> I used to have skystar2 cards before and I did not run into those
> issues. Diseqc just worked fine.
>
> For reference each tt s2 is plugged to a diseqc switch with 4 output,
> each output connected to a quad lnb.


How come there is such a high current drain to drive the switch plus the 
LNBs? From what I understand, the switch should only power one LNB at a 
time. Usually the switch plus the LNB should not drain more than 
300-400mA, or am I wrong here?

> Is there another way to solve this ?
> Maybe add a module parameter for people who want to override the
> default ?


I think this could be done. Nevertheless, the card would still operate 
outside its specification.

Regards
  André
