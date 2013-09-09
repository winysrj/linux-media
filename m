Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45479 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3IIKKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 06:10:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
Date: Mon, 09 Sep 2013 12:10:05 +0200
Message-ID: <26516577.dQgL4XrfDY@avalon>
In-Reply-To: <522D9DD6.2080609@xs4all.nl>
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com> <5584569.Fq1hO5v8IF@avalon> <522D9DD6.2080609@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 09 September 2013 12:07:18 Hans Verkuil wrote:
> On 09/09/2013 12:00 PM, Laurent Pinchart wrote:
> > On Monday 09 September 2013 11:07:43 Hans Verkuil wrote:
> >> On 09/06/2013 12:33 AM, Sylwester Nawrocki wrote:
> >
> > [snip]
> > 
> >>> The main issue as I see it is that we need to track both driver remove()
> >>> and struct device .release() calls and free resources only when last of
> >>> them executes. Data structures which are referenced in fops must not be
> >>> freed in remove() and we cannot use dev_get_drvdata() in fops, e.g. not
> >>> protected with device_lock().
> >> 
> >> You can do all that by returning 0 if probe() was partially successful
> >> (i.e. one or more, but not all, nodes were created successfully) by
> >> doing what I described above. I don't see another way that doesn't
> >> introduce a race condition.
> > 
> > But isn't this just plain wrong ? If probing fails, I don't see how
> > returning success could be a good idea.
> 
> Well, the nodes that are created are working fine. So it's partially OK :-)
> 
> That said, yes it would be better if it could safely clean up and return an
> error. But it is better than returning an error and introducing a race
> condition.
>
> >> That doesn't mean that there isn't one, it's just that I don't know of a
> >> better way of doing this.
> > 
> > We might need support from the device core.
> 
> I do come back to my main question: has anyone actually experienced this
> error in a realistic scenario? Other than in very low-memory situations I
> cannot imagine this happening.

What about running out of minors, which could very well happen with subdev 
nodes in complex SoCs ?

> I'm not sure whether you want to spend a lot of time trying to fix this all
> perfectly. That's why I am suggesting just unregistering everything and
> returning 0 in probe(). Not ideal, but at least it's safe (as far as I can
> tell).

-- 
Regards,

Laurent Pinchart

