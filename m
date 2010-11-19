Return-path: <mchehab@gaivota>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4698 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0KSOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 09:21:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
Date: Fri, 19 Nov 2010 15:21:36 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011191451.44465.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1011191509541.20751@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1011191509541.20751@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191521.36684.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday 19 November 2010 15:15:11 Guennadi Liakhovetski wrote:
> On Fri, 19 Nov 2010, Laurent Pinchart wrote:
> 
> > Hi Hans,
> > 
> > On Friday 19 November 2010 14:42:31 Hans Verkuil wrote:
> > > On Friday 19 November 2010 14:26:42 Laurent Pinchart wrote:
> > > > Some buggy sensors generate corrupt frames when the stream is started.
> > > > This new operation returns the number of corrupt frames to skip when
> > > > starting the stream.
> > > 
> > > Looks OK, but perhaps the two should be combined to one function?
> > 
> > I'm fine with both. Guennadi, any opinion ?
> 
> Same as before;) I think, there can be many more such "micro" parameters, 
> that we'll want to collect from the sensor. So, if we had a good idea - 
> what those parameters are like, we could implement just one API call to 
> get them all, or even just pass one object with this information - if it 
> is constant. If we don't have a good idea yet, what to expect there, it 
> might be best to wait and first collect a more complete understanding of 
> this kind of information. In any case I wouldn't convert these two calls 
> to one like
> 
> int (*get_bad_things)(struct v4l2_subdev *sd, u32 *lines, u32 *frames)
> 
> ;)

OK, let's go with Laurent's proposal. But I do think this should be reviewed
at some point in time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
