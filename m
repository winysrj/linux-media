Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2GYXbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 19:31:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: Media summit at the Kernel Summit - was: Fwd: Re: [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
Date: Thu, 26 Jul 2012 01:31:25 +0200
Message-ID: <5670302.A0zC7l9lLX@avalon>
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
> plain weirdness, just like I did last year.

Another ambiguity for your list, should video output drivers fill the sequence 
and timestamp fields when returning a v4l2_buffer from VIDIOC_DQBUF ?

-- 
Regards,

Laurent Pinchart

