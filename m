Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:32267 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbbJ0WVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 18:21:47 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
	<87io5wwahg.fsf@belgarion.home>
	<Pine.LNX.4.64.1510272306300.21185@axis700.grange>
Date: Tue, 27 Oct 2015 23:15:12 +0100
In-Reply-To: <Pine.LNX.4.64.1510272306300.21185@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue, 27 Oct 2015 23:07:04 +0100 (CET)")
Message-ID: <87twpcj6vj.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> Didn't you tell me, that your dmaengine patch got rejected and therefore 
> these your patches were on hold?
They were reverted, and then revamped into DMA_CTRL_REUSE, upstreamed and
merged, as in the commit 272420214d26 ("dmaengine: Add DMA_CTRL_REUSE"). I'd

Of course a pending fix is still underway
(http://www.serverphorums.com/read.php?12,1318680). But that shouldn't stop us
from reviewing to get ready to merge.

I want this serie to be ready, so that as soon as Vinod merges the fix, I can
ping you to trigger the merge into your tree, without doing (and waiting)
additional review cycles.

Cheers.

--
Robert
