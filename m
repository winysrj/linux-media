Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3FXIxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 04:53:38 -0400
Date: Mon, 24 Jun 2013 10:53:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L2: add documentation for V4L2 clock helpers and
 asynchronous probing
In-Reply-To: <3036701.8xleOKapCa@avalon>
Message-ID: <Pine.LNX.4.64.1306241051060.19735@axis700.grange>
References: <Pine.LNX.4.64.1306170801590.22409@axis700.grange>
 <3036701.8xleOKapCa@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for the review.

On Mon, 17 Jun 2013, Laurent Pinchart wrote:

[snip]

> > +drivers.
> > +
> > +Bridge drivers in turn have to register a notifier object with an array of
> > +subdevice descriptors, that the bridge device needs for its operation. This
> 
> s/descriptors,/descriptors/
> 
> > +is performed using the v4l2_async_notifier_register() call. To unregister
> > +the notifier the driver has to call v4l2_async_notifier_unregister(). The
> > +former of the two functions takes two arguments: a pointer to struct
> > +v4l2_device and a pointer to struct v4l2_async_notifier. The latter
> > +contains a pointer to an array of pointers to subdevice descriptors of
> > +type struct v4l2_async_subdev type.
> 
> Isn't it the other way around ?

I don't think I see anything above, that needs to be swapped. What exactly 
do you mean?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
