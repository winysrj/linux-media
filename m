Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:14710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab0L0MeB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 07:34:01 -0500
Message-ID: <4D1887B0.8070709@redhat.com>
Date: Mon, 27 Dec 2010 10:33:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] V4L1 cleanups and videodev.h removal
References: <20101227093848.324b6abd@gaivota> <201012271321.08128.hverkuil@xs4all.nl>
In-Reply-To: <201012271321.08128.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 27-12-2010 10:21, Hans Verkuil escreveu:
> On Monday, December 27, 2010 12:38:48 Mauro Carvalho Chehab wrote:
>> Now that all hard work to remove V4L1 happened, it doesn't make
>> sense on keeping videodev.h just because of two obsoleted drivers.
> 
> Perhaps it is also time to mark the videodev2.h _OLD ioctls for removal in
> 2.6.39?
> 
> If we are getting rid of old stuff anyway, then this will also be a nice
> cleanup.
> 
> Perhaps we can even delete it without marking it for removal. After all,
> removing it will only affect binaries compiled against a *really* old kernel
> (I suspect 2.5.something). Anything that has been recompiled will automatically
> use the correct ioctls.

We can't just remove the _OLD, as they're used internally, in order to handle
those old binaries. I think that not all come from 2.5 times. So, the better is to
mark them to be removed for .39.

> 
> Regards,
> 
> 	Hans
> 

