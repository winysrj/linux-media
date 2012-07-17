Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59589 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2GQTlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 15:41:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: workshop-2011@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media summit at the Kernel Summit - was: Fwd: Re: [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
Date: Tue, 17 Jul 2012 21:41:18 +0200
Message-ID: <1433177.IUeFs9YjWS@avalon>
In-Reply-To: <201207172132.22937.hverkuil@xs4all.nl>
References: <20120713173708.GB17109@thunk.org> <5005A14D.8000809@redhat.com> <201207172132.22937.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 17 July 2012 21:32:22 Hans Verkuil wrote:
> On Tue July 17 2012 19:30:53 Mauro Carvalho Chehab wrote:
> > As we did in 2012, we're planning to do a media summit again at KS/2012.
> > 
> > The KS/2012 will happen in San Diego, CA, US, between Aug 26-28, just
> > before the LinuxCon North America.
> > 
> > In order to do it, I'd like to know who is interested on participate,
> > and to get proposals about what subjects will be discussed there,
> > in order to start planning the agenda.
> 
> I'd like to have 30 minutes to discuss a few V4L2 API ambiguities or just
> plain weirdness, just like I did last year. I'll make an RFC issues to
> discuss beforehand. I might also have a short presentation/demo of
> v4l2-compliance, as I believe more people need to know about that utility.

That's a good idea. On the topic of ambiguities, could you add VIDIOC_STREAMON 
and VIDIOC_STREAMOFF behaviour when the stream is already started/stopped 
respectively ?

-- 
Regards,

Laurent Pinchart

