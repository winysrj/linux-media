Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2BBLB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:01:26 -0500
Date: Thu, 2 Feb 2012 12:00:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
In-Reply-To: <201202021055.19705.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1202021125210.13860@axis700.grange>
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain>
 <4F2924F8.3040408@samsung.com> <201202021055.19705.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Thu, 2 Feb 2012, Laurent Pinchart wrote:

> Do all those sensors interleave the data in the same way ? This sounds quite 
> hackish and vendor-specific to me, I'm not sure if we should try to generalize 
> that. Maybe vendor-specific media bus format codes would be the way to go. I 
> don't expect ISPs to understand the format, they will likely be configured in 
> pass-through mode. Instead of adding explicit support for all those weird 
> formats to all ISP drivers, it might make sense to add a "binary blob" media 
> bus code to be used by the ISP.

Yes, I agree, that those formats will be just forwarded as is by ISPs, but 
the user-space wants to know the contents, so, it might be more useful to 
provide information about specific components, even if their packing 
layout cannot be defined in a generic way with offsets and sizes. Even 
saying "you're getting formats YUYV and JPEG in vendor-specific packing 
#N" might be more useful, than just "vendor-specific format #N".

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
