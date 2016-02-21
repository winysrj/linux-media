Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55508 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbcBUR0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:26:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation for
 removal
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <56C71778.2030706@xs4all.nl> <20160219142410.478488cc@recife.lan>
 <56C74324.1010106@xs4all.nl> <87a8mwziie.fsf@belgarion.home>
 <56C75AF5.3010807@xs4all.nl> <87h9h3xe1c.fsf@belgarion.home>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Message-ID: <56C9D265.50905@xs4all.nl>
Date: Sun, 21 Feb 2016 16:06:13 +0100
MIME-Version: 1.0
In-Reply-To: <87h9h3xe1c.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2016 10:33 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>>> pxa27x_camera is actively maintained, the latest submission request for merge
>>> is 11 days ago :
>>>   https://lkml.org/lkml/2016/2/8/789
>>>
>>> I can submit a patch in MAINTAINERS if you wish to take it in my bucket.
>>
>> Please do! That's an easy patch, and then it is clear someone is actively maintaining
>> this.
> I prepared the patch.
> 
> Now the question is : how will handle the pxa_camera patches, ie. taking them
> through his tree ?
> 
> I'm under the impression that Guennadi is very busy, so for the MAINTAINERS
> patch as for the next ones, which tree will be handling them ? Moreover as most
> probably I will be the biggest contributor, who will be reviewing me ?

Guennadi is the soc-camera maintainer. So once pxa_camera no longer uses soc-camera
('independent v4l2 host') it would be me who would review the code and manages
patches.

BTW, where can I get pxa hardware? It is always nice if I am able to test code
as well. But I haven't been able to find a source for this platform.

Regards,

	Hans

> We might also pave a path of Guennadi's point (3), ie. have pxa_camera "become
> independent V4L2 host".
> 
>> BTW, vb1 refers to videobuf-core.h whereas vb2 refers to its successor videobuf2-core.h
>> and videobuf2-v4l2.h. The vb2 framework is vastly superior and integrates nicely with
>> dmabuf for buffer sharing between hardware components.
> Ok, I'll have a look too.
> 
> Cheers.
> 
> --
> Robert
> 

