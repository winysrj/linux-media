Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:59260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1DAINB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 04:13:01 -0400
Date: Fri, 1 Apr 2011 10:12:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH/RFC 0/4] V4L: new ioctl()s to support multi-sized video-buffers
Message-ID: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

As discussed at the last V4L2 meeting in Warsaw, one of the prerequisites 
to support fast switching between different image formats is an ability to 
preallocate buffers of different sizes and handle them over to the driver 
in advance. This avoids the need to allocate buffers at the time of 
switching. This patch series is a first implementation of these ioctl()s, 
implemented for the sh_mobile_ceu_camera soc-camera host driver. Tested on 
an sh7722 migor SuperH platform. Yes, I know, documentation is missing 
yet;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
