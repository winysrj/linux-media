Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4736 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0CZMCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 08:02:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: fix ENUMSTD ioctl to report all supported standards
Date: Fri, 26 Mar 2010 13:03:24 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1003260758550.4298@axis700.grange> <201003261219.59703.hverkuil@xs4all.nl> <Pine.LNX.4.64.1003261223160.4298@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003261223160.4298@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003261303.24919.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 26 March 2010 12:24:26 Guennadi Liakhovetski wrote:
> On Fri, 26 Mar 2010, Hans Verkuil wrote:
> 
> > On Friday 26 March 2010 08:06:42 Guennadi Liakhovetski wrote:
> > > V4L2_STD_PAL, V4L2_STD_SECAM, and V4L2_STD_NTSC are not the only composite 
> > > standards. Currently, e.g., if a driver supports all of V4L2_STD_PAL_B, 
> > > V4L2_STD_PAL_B1 and V4L2_STD_PAL_G, the enumeration will report 
> > > V4L2_STD_PAL_BG and not the single standards, which can confuse 
> > > applications. Fix this by only clearing simple standards from the mask. 
> > > This, of course, will only work, if composite standards are listed before 
> > > simple ones in the standards array in v4l2-ioctl.c, which is currently 
> > > the case.
> > 
> > Do you have an specific example where the current implementation will do the
> > wrong thing?
> 
> Yes - sh_vou with gstreamer. gstreamer enumerates standards and gest 
> PAL_BG but not PAL_B or PAL_G.

See my review of the ak881x tv-encoder.

This ENUMSTD patch just papers over a bug in the ak881x driver. So the real
fix has to be done there and not here. This patch would otherwise lead to an
unmanagable mess of videostandards for the end-user.

Regards,

	Hans

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
