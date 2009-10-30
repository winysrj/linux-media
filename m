Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33968 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754118AbZJ3UMG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 16:12:06 -0400
Date: Fri, 30 Oct 2009 21:12:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: RE: [PATCH/RFC 0/9 v2] Image-bus API and accompanying soc-camera
 patches
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155798775@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0910302058210.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798775@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Oct 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> Thanks for updating the driver. I will integrate it when I get a chance and let you know if I see any issues.
> 
> BTW, Is there someone developing a driver for MT9P031 sensor which is 
> very similar to MT9T031? Do you suggest a separate driver for this 
> sensor or
> add the support in MT9T031? I need a driver for this and plan to add it soon.

It depends on the difference between mt9t031 and mt9p031, of course. I had 
a brief look at the mt9p031 datasheet while placing it next to mt9t031, 
and for my taste there are already too many differences to pack them in 
one driver. MT9T031 was also very similar to MT9M001, I think, but 
copy-pasting actually served me a bad service:-) there turned out to be 
too many subtle differences in the end.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
