Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:43244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0JKTKd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 15:10:33 -0400
Message-ID: <4CB3611F.1030108@infradead.org>
Date: Mon, 11 Oct 2010 16:10:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
References: <201009261425.00146.hverkuil@xs4all.nl>	<AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com>	<201010111740.14658.hverkuil@xs4all.nl> <AANLkTimA-JKRYAxin6cco2VD9-D7rJ+J_JrSEQhYZTb0@mail.gmail.com>
In-Reply-To: <AANLkTimA-JKRYAxin6cco2VD9-D7rJ+J_JrSEQhYZTb0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-10-2010 15:05, David Ellingsworth escreveu:
> On Mon, Oct 11, 2010 at 11:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Sunday, October 10, 2010 19:33:48 David Ellingsworth wrote:

>>> Mauro, you should be ashamed for accepting a series that obviously has issues.
>>
>> Hardly obvious, and definitely not his fault.
>>
> 
> This comment was more general, since Mauro admitted having to make
> changes to your series to get it to compile under i386 architectures.
> 

So what? I always test if the tree compiles before sending the thing upstream. My
compilation is against i686 architecture, as it enables more drivers than other
architectures.

Rejecting a patch series just because of the lack of a typecast to remove a warning
on an architecture is not a good reason. I really prefer to apply the series and then
ask (or make a fix) to one or two lines, than to have to dig the entire patch series 
again on a rev 2 of the entire patch series. Examining a patch that fixes this issue
is a way easier than having to review a series of 11 patches.

Cheers,
Mauro.
