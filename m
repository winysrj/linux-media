Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:33037 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1AGOEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 09:04:55 -0500
Message-ID: <4D271D8C.2060201@linuxtv.org>
Date: Fri, 07 Jan 2011 15:05:00 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [patch] [media] av7110: make array offset unsigned
References: <20110106194059.GC1717@bicker> <4D270A9F.7080104@linuxtv.org> <20110107135122.GI1717@bicker>
In-Reply-To: <20110107135122.GI1717@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/07/2011 02:51 PM, Dan Carpenter wrote:
> On Fri, Jan 07, 2011 at 01:44:15PM +0100, Andreas Oberritter wrote:
>> Nack. You're changing an interface to userspace. Please add a check to
>> av7110_ca.c instead.
>>
> 
> Ok.  I've done that and resent the patch.

Thanks. I'm OK with the patch, but I'll leave it to the maintainer of
av7110 to decide whether he likes the cast or prefers an additional
signed compare. I added him to CC.

> But just for my own understanding, why is it wrong to change an int to
> an unsigned int in the userspace API?  Who would notice?  (I'm still
> quite a newbie at system programming).

It would generate compiler warnings in userspace for programs checking
for values < 0 or assigning negative values (for whatever reason).

Regards,
Andreas
