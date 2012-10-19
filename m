Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2JSWUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 18:20:21 -0400
Date: Sat, 20 Oct 2012 00:20:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/2] media: V4L2: clock and asynchronous registration
Message-ID: <Pine.LNX.4.64.1210192358520.28993@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

During a recent discussion of a V4L2 DT RFC it has become apparent, that 
we first need two more preliminary steps, before implementing DT: we need 
a (temporary) V4L2 clock implementation and asynchronous subdevice 
registration. As follow ups to this mail I'm posting two patches, 
implementing those. I have actually been able to get that to work with an 
soc-camera system (sh7372), but respective soc-camera and bridge patches 
are still raw, need a lot of clean up, and I don't know when I'll be able 
to do that. So, I decided to first dump these two patches to the list, and 
then see when I find time for the rest.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
