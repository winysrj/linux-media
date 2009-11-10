Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47141 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750841AbZKJOLA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 09:11:00 -0500
Date: Tue, 10 Nov 2009 15:11:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
 g_skip_top_lines in soc-camera
In-Reply-To: <200911101355.28339.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0911101459560.5074@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
 <200911101355.28339.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Nov 2009, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 30 October 2009 15:01:06 Guennadi Liakhovetski wrote:
> > Introduce new v4l2-subdev sensor operations, move .enum_framesizes() and
> > .enum_frameintervals() methods to it,
> 
> I understand that we need sensor-specific operations, but I'm not sure if 
> those two are really unneeded for "non-sensor" video.

I suspect that wasn't my idea:-) Ok, found:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/8990/focus=9078

> Speaking about enum_framesizes() and enum_frameintervals(), wouldn't it be 
> better to provide a static array of data instead of a callback function ? That 
> should be dealt with in another patch set of course.

TBH, I don't understand why these methods are needed at all. Why the 
existing {S,G,TRY}_FMT are not enough. So, obviously, this isn't a 
question to me either.

> > add a new .g_skip_top_lines() method and switch soc-camera to use it instead
> > of .y_skip_top soc_camera_device member, which can now be removed.
> 
> BTW, the lines of "garbage" you get at the beginning of the image is actually 
> probably meta-data (such as exposure settings). Maybe the g_skip_top_lines() 
> operation could be renamed to something meta-data related. Applications could 
> also be interested in getting the data.

Aha, that's interesting, thanks! Yes, we could easily rename it to 
.g_metadata_lines() or something like that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
