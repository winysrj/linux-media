Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:46173 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbcBTVdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 16:33:40 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation for removal
References: <56C71778.2030706@xs4all.nl> <20160219142410.478488cc@recife.lan>
	<56C74324.1010106@xs4all.nl> <87a8mwziie.fsf@belgarion.home>
	<56C75AF5.3010807@xs4all.nl>
Date: Sat, 20 Feb 2016 22:33:35 +0100
In-Reply-To: <56C75AF5.3010807@xs4all.nl> (Hans Verkuil's message of "Fri, 19
	Feb 2016 19:12:05 +0100")
Message-ID: <87h9h3xe1c.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

>> pxa27x_camera is actively maintained, the latest submission request for merge
>> is 11 days ago :
>>   https://lkml.org/lkml/2016/2/8/789
>> 
>> I can submit a patch in MAINTAINERS if you wish to take it in my bucket.
>
> Please do! That's an easy patch, and then it is clear someone is actively maintaining
> this.
I prepared the patch.

Now the question is : how will handle the pxa_camera patches, ie. taking them
through his tree ?

I'm under the impression that Guennadi is very busy, so for the MAINTAINERS
patch as for the next ones, which tree will be handling them ? Moreover as most
probably I will be the biggest contributor, who will be reviewing me ?

We might also pave a path of Guennadi's point (3), ie. have pxa_camera "become
independent V4L2 host".

> BTW, vb1 refers to videobuf-core.h whereas vb2 refers to its successor videobuf2-core.h
> and videobuf2-v4l2.h. The vb2 framework is vastly superior and integrates nicely with
> dmabuf for buffer sharing between hardware components.
Ok, I'll have a look too.

Cheers.

--
Robert
