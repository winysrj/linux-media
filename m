Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47070 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752460AbZFJVtU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:49:20 -0400
Date: Wed, 10 Jun 2009 23:49:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: soc-camera: status, roadmap
In-Reply-To: <200906102209.08535.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906102343560.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
 <200906102209.08535.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> On Wednesday 10 June 2009 18:45:36 Guennadi Liakhovetski wrote:

[snip]

> > 3. This also means, development will become more difficult, new features
> > and drivers will only be accepted on the top of my patch stack, bugfixes
> > will have to be accpeted against the mainline, which then will mean extra
> > porting work for me.
> 
> If there is anything I can do to help this along, please let me know. In 
> particular: what else besides the v4l2_i2c_new_subdev_board do you need? I 
> didn't have much time in the past few weeks, but things are more relaxed 
> now and I expect to be able to do a lot more in the coming weeks (fingers 
> crossed :-) ).

Thanks for your offer!

Well, yes, at least we could start with these three things:

1. s_crop, g_crop, cropcap. Would be nice if you could add them just 
following the standard API.

2. bus parameter negotiation. I appreciate Murali's effort, but I don't 
like re-inventing the wheel. So, we should now either bring his 
implementation to support _at least_ all features so far supported in 
soc-camera, or you could just copy the soc-camera implementation over, 
just renaming functions and macros as appropriate.

3. pixel format negotiation. The easiest would be to also just copy it 
over.

These 3 points would make the porting much easier. I'll certainly be happy 
to answer any questions you might get working with soc-camera code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
