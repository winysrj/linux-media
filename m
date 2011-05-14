Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58599 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168Ab1ENML5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 08:11:57 -0400
Subject: Re: [RFC v4] V4L2 API for flash devices
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
In-Reply-To: <201105071446.56843.hverkuil@xs4all.nl>
References: <4DC2F131.6090407@maxwell.research.nokia.com>
	 <201105071446.56843.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 09:13:00 -0400
Message-ID: <1305378780.2434.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 2011-05-07 at 14:46 +0200, Hans Verkuil wrote:
> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
> >
> > 
> > enum v4l2_flash_strobe_whence {
> > 	V4L2_FLASH_STROBE_WHENCE_SOFTWARE,
> > 	V4L2_FLASH_STROBE_WHENCE_EXTERNAL,
> > };
> 
> Perhaps use 'type' instead of 'whence'? English isn't my native language,
> but it sounds pretty archaic to me.

"SOURCE" is better than "WHENCE" here.


"whence" is certainly very formal and used very little.  "whence" likely
still gets some use in English, simply because a terse synonym doesn't
exist.

The problem with using whence is that many English speakers won't know
its correct definition.

	"whence" means "from what source, origin, or place"

In your use here, the implicit "from" in the definition of whence is
essential.  However, most (American) English speakers that I know think
"whence" simply means "where".

Regards,
Andy

