Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:33680 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbcCHLF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 06:05:59 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: videobuf2-dma-sg and multiple planes semantics
References: <87y49uuu21.fsf@belgarion.home> <87twkiupnf.fsf@belgarion.home>
	<56DE9DBD.8010203@xs4all.nl>
Date: Tue, 08 Mar 2016 12:05:53 +0100
In-Reply-To: <56DE9DBD.8010203@xs4all.nl> (Hans Verkuil's message of "Tue, 8
	Mar 2016 10:39:09 +0100")
Message-ID: <877fhdgrfy.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Robert,
>
> In the case of PIX_FMT_YUV422P there is only *one* buffer and the planes are laid out in
> that single buffer. So from the point of view of v4l2/vb2 this is a single planar
> format and you have a single sglist.h
That's the piece of information I was missing, thanks.

> You'll have to use sg_split() to split up that single large sglist into three, one for
> each channel.
Yeah, being the author of it, I should be able to use it again :)

Cheers.

--
Robert
