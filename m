Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47268 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0KQKsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 05:48:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: An article on the media controller
Date: Wed, 17 Nov 2010 11:48:20 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20101116151802.0ccdcd53@bike.lwn.net>
In-Reply-To: <20101116151802.0ccdcd53@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171148.21188.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jonathan,

On Tuesday 16 November 2010 23:18:02 Jonathan Corbet wrote:
> I've just spent a fair while looking through the September posting of
> the media controller code (is there a more recent version?).  The
> result is a high-level review which interested people can read here:
> 
> 	http://lwn.net/SubscriberLink/415714/1e837f01b8579eb7/

Thanks a lot for the article.

> Most people will not see it for another 24 hours or so; if there's
> something I got radically wrong, I'd appreciate hearing about it.

Here are a few comments:

- Second paragraph: s/lens distortion/lens shading/

- Fifth paragraph: entities can have no bad if no data flows in or out of them 
(think of a flash controller for instance,  it needs to be configured, 
associated with a sensor, but is not involved in any media data flow). The 
pads represent connection points for data flows (usually media data), not for 
software configuration.

- Tenth paragraph: there's no end-user application available at the moment, 
but we already have a command line test application 
(http://git.ideasonboard.org/?p=media-ctl.git;a=summary) and a GStreamer 
element (called subdevsrc, available from http://meego.gitorious.org/maemo-
multimedia/gst-nokia-videosrc).

> The executive summary is that I think this code really needs some
> exposure outside of the V4L2 list; I'd encourage posting it to
> linux-kernel.  That could be hard on plans for a 2.6.38 merge (or, at
> least, plans for any spare time between now and then), but the end
> result might be better for everybody.

I agree that the more developers who will look at the code, the more ideas we 
will get. That might get difficult to manage though :-) I'll cross-post the 
next version of the patches.

Regarding sysfs, I won't repeat Hans' and Andy's arguments, but I don't think 
it would be a very good match. The API would get much more difficult to use 
and would require lany times more system calls. While the media controller 
solves a problem that can appear similar to our current power management and 
clock routing issues, I'm not sure a common API would make sense. That would 
be like arguing that DirectShow should be used for hard disk power management 
in Windows :-)

> I have some low-level comments too which were not suitable for the
> article.  I'll be posting them here, but I have to get some other
> things done first.

Thank you in advance for the review.

-- 
Best regards,

Laurent Pinchart
