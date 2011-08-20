Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab1HTMNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 08:13:11 -0400
Message-ID: <4E4FA4C8.4050703@redhat.com>
Date: Sat, 20 Aug 2011 05:12:56 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES
 FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <201108151430.42722.laurent.pinchart@ideasonboard.com> <4E49B60C.4060506@redhat.com> <201108161057.57875.laurent.pinchart@ideasonboard.com> <4E4A8D27.1040602@redhat.com> <4E4AE583.6050308@gmail.com> <4E4B5C27.3000008@redhat.com> <4E4F9A0B.4050302@gmail.com>
In-Reply-To: <4E4F9A0B.4050302@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2011 04:27, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> On 08/17/2011 08:13 AM, Mauro Carvalho Chehab wrote:
>> It seems that there are too many miss understandings or maybe we're just
>> talking the same thing on different ways.
>>
>> So, instead of answering again, let's re-start this discussion on a
>> different way.
>>
>> One of the requirements that it was discussed a lot on both mailing
>> lists and on the Media Controllers meetings that we had (or, at least
>> in the ones where I've participated) is that:
>>
>> 	"A pure V4L2 userspace application, knowing about video device
>> 	 nodes only, can still use the driver. Not all advanced features
>> 	 will be available."
> 
> What does a term "a pure V4L2 userspace application" mean here ?

The above quotation are exactly the Laurent's words that I took from one 
of his replies.

> Does it also account an application which is linked to libv4l2 and uses
> calls specific to a particular hardware which are included there?

That's a good question. We need to properly define what it means, to avoid
having libv4l abuses.

In other words, it seems ok to use libv4l to set pipelines via the MC API
at open(), but it isn't ok to have an open() binary only libv4l plugin that
will hook open and do the complete device initialization on userspace
(I remember that one vendor once proposed a driver like that).

Also, from my side, I'd like to see both libv4l and kernel drivers being
submitted together, if the new driver depends on a special libv4l support
for it to work.

Regards,
Mauro
