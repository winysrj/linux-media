Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753503Ab0CZLYY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 07:24:24 -0400
Date: Fri, 26 Mar 2010 12:24:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: fix ENUMSTD ioctl to report all supported standards
In-Reply-To: <201003261219.59703.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1003261223160.4298@axis700.grange>
References: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
 <201003261219.59703.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Mar 2010, Hans Verkuil wrote:

> On Friday 26 March 2010 08:06:42 Guennadi Liakhovetski wrote:
> > V4L2_STD_PAL, V4L2_STD_SECAM, and V4L2_STD_NTSC are not the only composite 
> > standards. Currently, e.g., if a driver supports all of V4L2_STD_PAL_B, 
> > V4L2_STD_PAL_B1 and V4L2_STD_PAL_G, the enumeration will report 
> > V4L2_STD_PAL_BG and not the single standards, which can confuse 
> > applications. Fix this by only clearing simple standards from the mask. 
> > This, of course, will only work, if composite standards are listed before 
> > simple ones in the standards array in v4l2-ioctl.c, which is currently 
> > the case.
> 
> Do you have an specific example where the current implementation will do the
> wrong thing?

Yes - sh_vou with gstreamer. gstreamer enumerates standards and gest 
PAL_BG but not PAL_B or PAL_G.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
