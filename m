Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:50887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1FBLGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 07:06:23 -0400
Message-ID: <4DE76EA2.1090600@infradead.org>
Date: Thu, 02 Jun 2011 08:06:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
CC: 'Kyungmin Park' <kmpark@infradead.org>,
	=?ISO-8859-2?Q?=27Uwe_Klein?= =?ISO-8859-2?Q?e-K=F6nig=27?=
	<u.kleine-koenig@pengutronix.de>, linux-media@vger.kernel.org,
	kernel@pengutronix.de,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de> <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com> <4DE6E8A7.2080305@infradead.org> <000101cc20e9$d2d07f50$78717df0$%szyprowski@samsung.com>
In-Reply-To: <000101cc20e9$d2d07f50$78717df0$%szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-06-2011 02:56, Marek Szyprowski escreveu:
> Hello,
> 
> On Thursday, June 02, 2011 3:35 AM Mauro Carvalho Chehab wrote:
> 
>> Hi Kyungmin,
>>
>> Em 01-06-2011 21:50, Kyungmin Park escreveu:
>>> Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>
>>
>> As this patch is really trivial and makes sense, I've just applied it
>> earlier today.
> 
> thanks!
> 
>>> ---
>>>
>>> I think it's better to add the videobuf2 maintainer entry for proper
>>> person to know the changes.
>>> In this case, Marek is missing.
>>>
>>> If any objection, I will make a patch.
>>
>> No objections from my side. Having the proper driver maintainers written at
>> MAINTAINERS
>> help people when submitting patches to send the patch to the proper driver
>> maintainer.
> 
> It looks that the patch for MAINTAINERS have been lost. It was initially
> posted by Pawel some time ago: https://lkml.org/lkml/2011/3/20/82

patchwork.kernel.org is not reliable. I think I'll need to migrate it to
something else.

> I will resend it to linux-media ml.

Thanks!

I noticed that Pawel's SOB is missed at the proposed patch.

Pawel, could you please reply to it with your SOB?

Thanks!
Mauro
