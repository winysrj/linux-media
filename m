Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751074AbZIZMY7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 08:24:59 -0400
Date: Sat, 26 Sep 2009 14:25:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: V4L-DVB Summit Day 3
In-Reply-To: <200909252322.26427.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0909261419220.4273@axis700.grange>
References: <200909252322.26427.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Sep 2009, Hans Verkuil wrote:

> - implement sensor v4l2_subdev support (Laurent). We are still missing some 
> v4l2_subdev sensor ops for setting up the bus config and data format. Laurent 
> will look into implementing those. An RFC for the bus config already exists 
> and will function as the basis of this.

Good, obviously, I'm veryinterested in both these APIs, and I hope Laurent 
will have a look at my earlier imagebus proposal and use that API as a 
basis for the data format API. My RFC, probably, didn't cover all possible 
cases, but it should be a reasonable starting point with easy enough 
extensibility. I did get a couple of positive feedbacks regarding that 
API, and I have converted the whole soc-camera stack to it and am working 
on some new drivers with that API. So far I didn't have a single case 
where I would have to amend or extend it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
