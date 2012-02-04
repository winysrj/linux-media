Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59157 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2BDLby (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 06:31:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
Date: Sat, 04 Feb 2012 12:30:08 +0100
Message-ID: <3142039.4Ht9bV5jFQ@avalon>
In-Reply-To: <4F2D14ED.8080105@iki.fi>
References: <4F27CF29.5090905@samsung.com> <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 04 February 2012 13:22:21 Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
> > On 02/01/2012 11:00 AM, Sakari Ailus wrote:
> >> I'd guess that all the ISP would do to such formats is to write them to
> >> memory since I don't see much use for either in ISPs --- both typically
> >> are
> >> output of the ISP.
> > 
> > Yep, correct. In fact in those cases the sensor has complicated ISP built
> > in, so everything a bridge have to do is to pass data over to user space.
> > 
> > Also non-image data might need to be passed to user space as well.
> 
> How does one know in the user space which part of the video buffer
> contains jpeg data and which part is yuv? Does the data contain some
> kind of header, or how is this done currently?
> 
> I'd be much in favour or using a separate channel ID as Guennadi asked;
> that way you could quite probably save one memory copy as well. But if
> the hardware already exists and behaves badly there's usually not much
> you can do about it.

If I'm not mistaken, the sensor doesn't send data in separate channels but 
interleaves them in a single channel (possibly with headers or fixed-size 
packets - Sylwester, could you comment on that ?). That makes it pretty 
difficult to do anything else than pass-through capture.

-- 
Regards,

Laurent Pinchart
