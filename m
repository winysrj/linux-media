Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3DVKnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 06:43:10 -0400
Date: Mon, 22 Apr 2013 12:43:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] V4L2: fix subdevice matching in asynchronous probing
In-Reply-To: <4168926.UulQla8EqY@avalon>
Message-ID: <Pine.LNX.4.64.1304221240210.23906@axis700.grange>
References: <Pine.LNX.4.64.1304191640010.591@axis700.grange> <4168926.UulQla8EqY@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Apr 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 19 April 2013 16:41:02 Guennadi Liakhovetski wrote:
> > A wrapped list iterating loop hasn't been correctly recognised in
> > v4l2_async_belongs(), which led to false positives. Fix the bug by
> > verifying the loop termination condition.
> > 
> > Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Prabhakar, please, check, whether this fixes your problem.
> > 
> >  drivers/media/v4l2-core/v4l2-async.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 5d6b428..5631944 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -76,6 +76,10 @@ static struct v4l2_async_subdev
> > *v4l2_async_belongs(struct v4l2_async_notifier *
> > 			break;
> >  	}
> > 
> > +	if (&asd->list == &notifier->waiting)
> > +		/* Wrapped - no match found */
> > +		return NULL;
> > +
> >  	return asd;
> >  }
> 
> What about just
> 
>                 if (match && match(sd->dev, hw))
>                         return asd;
>         }
> 
>         return NULL;
> }
> 
> That's a bit simpler.

Well, if it were simpler, it would've occurred to me instead of the other 
"more complex" solution, tight? ;-) No, sure, looks better, thanks! As 
soon as the actual patches are approved in principle, I'll merge this into 
them.

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
