Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2037 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab0KQHgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 02:36:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: An article on the media controller
Date: Wed, 17 Nov 2010 08:36:35 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20101116151802.0ccdcd53@bike.lwn.net>
In-Reply-To: <20101116151802.0ccdcd53@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170836.35214.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 23:18:02 Jonathan Corbet wrote:
> I've just spent a fair while looking through the September posting of
> the media controller code (is there a more recent version?).  The
> result is a high-level review which interested people can read here:
> 
> 	http://lwn.net/SubscriberLink/415714/1e837f01b8579eb7/
> 
> Most people will not see it for another 24 hours or so; if there's
> something I got radically wrong, I'd appreciate hearing about it.

Just two points, really: we do not expect generic applications to use this
API other than for determining the default device nodes. E.g. if a device
has 5 video nodes and two alsa nodes, then one video and one alsa node will
be marked as the default and applications are supposed to open those. This
will allow apps to find the right device nodes for capturing.

The more advanced functionality is expected to be used by custom applications
specific to that hardware. I also expect to see either libv4l2 or gstreamer
plugins or libraries created for specific SoCs that use this API. The hardware
that the MC describes is simply too varied and unpredictable to ever be able
to use it with just the MC data. The main purpose is to at least be able to
expose the full functionality to userspace.

The other point is the same that Andy made: we expect that the API will change
a bit allowing for atomically changing multiple links at the same time. Not
something that sysfs can handle (not without some horrible hacks at least).

I also think sysfs is a mess and horrible to use, but that's just my opinion.
 
> The executive summary is that I think this code really needs some
> exposure outside of the V4L2 list; I'd encourage posting it to
> linux-kernel.  That could be hard on plans for a 2.6.38 merge (or, at
> least, plans for any spare time between now and then), but the end
> result might be better for everybody.

I agree with that. It was always designed for generic use, but on the other
hand we can't postpone it for too long since V4L really needs this.

Thanks for the article!

Regards,

	Hans

> I have some low-level comments too which were not suitable for the
> article.  I'll be posting them here, but I have to get some other
> things done first.
> 
> Thanks,
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
