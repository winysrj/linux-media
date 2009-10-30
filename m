Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59459 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932069AbZJ3OAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:00:44 -0400
Date: Fri, 30 Oct 2009 15:00:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH/RFC 0/9 v2] Image-bus API and accompanying soc-camera patches
Message-ID: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

As discussed yesterday, we sant to finalise the conversion of soc-camera 
to v4l2-subdev. The presented 9 patches consist of a couple of clean-ups, 
minor additions to existing APIs, and, most importantly, the second 
version of the image-bus API. It hardly changed since v1, only got 
extended with a couple more formats and driver conversions. The last patch 
modifies mt9t031 sensor driver to enable its use outside of soc-camera. 
Muralidharan, hopefully you'd be able to test it. I'll provide more 
comments in the respective mail. A complete current patch-stack is 
available at

http://download.open-technology.de/soc-camera/20091030/

based on 2.6.32-rc5. Patches, not included with these mails have either 
been already pushed via hg, or posted to the list earlier.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
