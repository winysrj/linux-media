Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:22443 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1EPJXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 05:23:19 -0400
Message-ID: <4DD0ECFA.9070605@maxwell.research.nokia.com>
Date: Mon, 16 May 2011 12:23:06 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com>	 <201105071446.56843.hverkuil@xs4all.nl> <1305378780.2434.18.camel@localhost>
In-Reply-To: <1305378780.2434.18.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andy Walls wrote:
> On Sat, 2011-05-07 at 14:46 +0200, Hans Verkuil wrote:
>> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
>>>
>>>
>>> enum v4l2_flash_strobe_whence {
>>> 	V4L2_FLASH_STROBE_WHENCE_SOFTWARE,
>>> 	V4L2_FLASH_STROBE_WHENCE_EXTERNAL,
>>> };
>>
>> Perhaps use 'type' instead of 'whence'? English isn't my native language,
>> but it sounds pretty archaic to me.
> 
> "SOURCE" is better than "WHENCE" here.
> 
> 
> "whence" is certainly very formal and used very little.  "whence" likely
> still gets some use in English, simply because a terse synonym doesn't
> exist.
> 
> The problem with using whence is that many English speakers won't know
> its correct definition.
> 
> 	"whence" means "from what source, origin, or place"
> 
> In your use here, the implicit "from" in the definition of whence is
> essential.  However, most (American) English speakers that I know think
> "whence" simply means "where".

Thanks for the feedback, Andy!

WHENCE has since changed to MODE (or at least should have been), but I
think SOURCE is even better. I'll switch to that.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
