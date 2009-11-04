Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55041 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757451AbZKDRxg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 12:53:36 -0500
Date: Wed, 4 Nov 2009 18:53:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: RE: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera client
 API optional
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155833A4C@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0911041822450.4837@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE401557987F6@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0910302112300.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798D56@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0911041703000.4837@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155833A4C@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Nov 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> Thanks for the reply. I will have a chance to work on this
> sometime in the next two weeks as I am pre-occupied with other
> items. I will definitely try to use this version and do my
> testing and let you know the result.
> 
> Will this apply cleanly to the v4l-dvb linux-next branch?

Maybe you can apply the whole set of 9 patches to it, not sure. Better yet 
get the complete stack from the location I provided in the introductory 
mail (0/9) and apply it as instructed there. Just beware, that there are 
still some older patch versions, which you would have to replace with the 
ones from this thread. I'll try to update that stack shortly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
