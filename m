Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2BDLhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 06:37:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
Date: Sat, 04 Feb 2012 12:36:53 +0100
Message-ID: <2245415.4hXgTppUEj@avalon>
In-Reply-To: <Pine.LNX.4.64.1202021125210.13860@axis700.grange>
References: <4F27CF29.5090905@samsung.com> <201202021055.19705.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1202021125210.13860@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 02 February 2012 12:00:57 Guennadi Liakhovetski wrote:
> On Thu, 2 Feb 2012, Laurent Pinchart wrote:
> > Do all those sensors interleave the data in the same way ? This sounds
> > quite hackish and vendor-specific to me, I'm not sure if we should try to
> > generalize that. Maybe vendor-specific media bus format codes would be
> > the way to go. I don't expect ISPs to understand the format, they will
> > likely be configured in pass-through mode. Instead of adding explicit
> > support for all those weird formats to all ISP drivers, it might make
> > sense to add a "binary blob" media bus code to be used by the ISP.
> 
> Yes, I agree, that those formats will be just forwarded as is by ISPs, but
> the user-space wants to know the contents, so, it might be more useful to
> provide information about specific components, even if their packing
> layout cannot be defined in a generic way with offsets and sizes. Even
> saying "you're getting formats YUYV and JPEG in vendor-specific packing
> #N" might be more useful, than just "vendor-specific format #N".

That's right. A single media bus code might not be the best option indeed. 
Vendor-specific blob codes (and 4CCs) then ?

-- 
Regards,

Laurent Pinchart
