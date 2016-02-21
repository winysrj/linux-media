Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:43631 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbcBUTxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 14:53:53 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
	<87io5wwahg.fsf@belgarion.home>
	<Pine.LNX.4.64.1510272306300.21185@axis700.grange>
	<87twpcj6vj.fsf@belgarion.home>
	<Pine.LNX.4.64.1510291656580.694@axis700.grange>
	<87d1s72bls.fsf@belgarion.home>
	<Pine.LNX.4.64.1602211400050.5959@axis700.grange>
Date: Sun, 21 Feb 2016 15:53:42 +0100
In-Reply-To: <Pine.LNX.4.64.1602211400050.5959@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 21 Feb 2016 14:01:32 +0100 (CET)")
Message-ID: <874md2xgg9.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> Okay Guennadi, I retested this version on top of v4.5-rc2, still good to
>> go. There is a minor conflict in the includes since this submission, and I can
>> repost a v6 which solves it.
>
> How did you test it with that patchg #3??
I rebased my patches on top of v4.5-rc2. To be exact, I rebased the tree I had
with these last patches on top of v4.5-rc2. I'll recheck, it's been some time
...

> What's a minor conflict?
A conflict on a context line :
#include <mach/dma.h>
#include <linux/platform_data/media/camera-pxa.h>

I think linux/platform_data/media/camera-pxa.h changed from my last submssion,
hence the conflict.

> If a patch doesn't apply at all or applies with a fuzz, yes, please fix. If
> it's just a few lines off, no need to fix that. But you'll do a v6 anyway, I
> assume.
But of course, let us have a v6 which cleanly applies on v4.5-rc2, and restested
once more. I'll try to have it done this evening.

Cheers.

-- 
Robert
