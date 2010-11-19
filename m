Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:41191 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753148Ab0KSNxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:53:12 -0500
Date: Fri, 19 Nov 2010 14:53:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
In-Reply-To: <201011191442.31982.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1011191452540.20751@axis700.grange>
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201011191442.31982.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 19 Nov 2010, Hans Verkuil wrote:

> On Friday 19 November 2010 14:26:42 Laurent Pinchart wrote:
> > Some buggy sensors generate corrupt frames when the stream is started.
> > This new operation returns the number of corrupt frames to skip when
> > starting the stream.
> 
> Looks OK, but perhaps the two should be combined to one function?
> 
> I also have my doubts about the sensor_ops in general. I expected originally
> to see a lot of ops here, but apparently there is little or no need for it.
> 
> Do we expect to see this grow, or would it make more sense to move the ops
> to video_ops? I'd be interested to hear what sensor specialists think.

I would keep the struct.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
