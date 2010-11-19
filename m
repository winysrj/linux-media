Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:47160 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754358Ab0KSOPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 09:15:06 -0500
Date: Fri, 19 Nov 2010 15:15:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
In-Reply-To: <201011191451.44465.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1011191509541.20751@axis700.grange>
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201011191442.31982.hverkuil@xs4all.nl> <201011191451.44465.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 19 Nov 2010, Laurent Pinchart wrote:

> Hi Hans,
> 
> On Friday 19 November 2010 14:42:31 Hans Verkuil wrote:
> > On Friday 19 November 2010 14:26:42 Laurent Pinchart wrote:
> > > Some buggy sensors generate corrupt frames when the stream is started.
> > > This new operation returns the number of corrupt frames to skip when
> > > starting the stream.
> > 
> > Looks OK, but perhaps the two should be combined to one function?
> 
> I'm fine with both. Guennadi, any opinion ?

Same as before;) I think, there can be many more such "micro" parameters, 
that we'll want to collect from the sensor. So, if we had a good idea - 
what those parameters are like, we could implement just one API call to 
get them all, or even just pass one object with this information - if it 
is constant. If we don't have a good idea yet, what to expect there, it 
might be best to wait and first collect a more complete understanding of 
this kind of information. In any case I wouldn't convert these two calls 
to one like

int (*get_bad_things)(struct v4l2_subdev *sd, u32 *lines, u32 *frames)

;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
