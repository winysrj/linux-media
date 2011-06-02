Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43349 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1FBF4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 01:56:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-2
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LM5002VUF6NXB70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 06:56:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LM5008T8F6M8A@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 06:56:47 +0100 (BST)
Date: Thu, 02 Jun 2011 07:56:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
In-reply-to: <4DE6E8A7.2080305@infradead.org>
To: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kmpark@infradead.org>
Cc: =?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, 'Pawel Osciak' <pawel@osciak.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <000101cc20e9$d2d07f50$78717df0$%szyprowski@samsung.com>
Content-language: pl
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com>
 <4DE6E8A7.2080305@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Thursday, June 02, 2011 3:35 AM Mauro Carvalho Chehab wrote:

> Hi Kyungmin,
> 
> Em 01-06-2011 21:50, Kyungmin Park escreveu:
> > Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>
> 
> As this patch is really trivial and makes sense, I've just applied it
> earlier today.

thanks!

> > ---
> >
> > I think it's better to add the videobuf2 maintainer entry for proper
> > person to know the changes.
> > In this case, Marek is missing.
> >
> > If any objection, I will make a patch.
> 
> No objections from my side. Having the proper driver maintainers written at
> MAINTAINERS
> help people when submitting patches to send the patch to the proper driver
> maintainer.

It looks that the patch for MAINTAINERS have been lost. It was initially
posted by Pawel some time ago: https://lkml.org/lkml/2011/3/20/82

I will resend it to linux-media ml.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


