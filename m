Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44372 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab2BBJy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 04:54:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
Date: Thu, 2 Feb 2012 10:55:18 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com>
In-Reply-To: <4F2924F8.3040408@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202021055.19705.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 01 February 2012 12:41:44 Sylwester Nawrocki wrote:
> On 02/01/2012 11:00 AM, Sakari Ailus wrote:
> >> Some camera sensors generate data formats that cannot be described using
> >> current convention of the media bus pixel code naming.
> >> 
> >> For instance, interleaved JPEG data and raw VYUY. Moreover interleaving
> >> is rather vendor specific, IOW I imagine there might be many ways of how
> >> the interleaving algorithm is designed.
> > 
> > Is that truly interleaved, or is that e.g. first yuv and then jpeg?
> > Interleaving the two sounds quite strange to me.
> 
> It's truly interleaved. There might be some chance for yuv/jpeg one after
> the other, but the interleaved format needs to be supported.
> 
> >> I'm wondering how to handle this. For sure such an image format will
> >> need a new vendor-specific fourcc. Should we have also vendor specific
> >> media bus code ?
> >> 
> >> I would like to avoid vendor specific media bus codes as much as
> >> possible. For instance defining something like
> >> 
> >> V4L2_MBUS_FMT_VYUY_JPEG_1X8
> >> 
> >> for interleaved VYUY and JPEG data might do, except it doesn't tell
> >> anything about how the data is interleaved.
> >> 
> >> So maybe we could add some code describing interleaving (xxxx)
> >> 
> >> V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8
> >> 
> >> or just the sensor name instead ?
> > 
> > If that format is truly vendor specific, I think a vendor or sensor
> > specific media bus code / 4cc would be the way to go. On the other hand,
> > you must be prepared to handle these formats in your ISP driver, too.
> 
> Yes, I don't see an issue in adding a support for a new format in
> ISP/bridge driver, it needs to know anyway e.g. what MIPI-CSI data type
> corresponds to the data from sensor.
> 
> > I'd guess that all the ISP would do to such formats is to write them to
> > memory since I don't see much use for either in ISPs --- both typically
> > are output of the ISP.
> 
> Yep, correct. In fact in those cases the sensor has complicated ISP built
> in, so everything a bridge have to do is to pass data over to user space.
> 
> Also non-image data might need to be passed to user space as well.
> 
> > I think we will need to consider use cases where the sensors produce
> > other data than just the plain image: I've heard of a sensor producing
> > both (consecutively, I understand) and there are sensors that produce
> > metadata as well. For those, we need to specify the format of the full
> > frame, not just the image data part of it --- which we have called
> > "frame" at least up to this point.
> 
> Yes, moreover such formats partly determine data layout in memory, rather
> than really just a format on a video bus.
> 
> > If the case is that the ISP needs this kind of information from the
> > sensor driver to be able to handle this kind of data, i.e. to write the
> > JPEG and YUV to separate memory locations, I'm proposing to start
> > working on this
> 
> It's not the case here, it would involve unnecessary copying in kernel
> space. Even in case of whole consequitive data planes contiguous buffer is
> needed. And it's not easy to split because the border between the data
> planes cannot be arbitrarily aligned.
> 
> > now rather than creating a single hardware-specific solution.
> 
> Yes, I'm attempting rather generic approach, even just for that reason that
> there are multiple Samsung sensors that output hybrid data. I've seen Sony
> sensor doing that as well.

Do all those sensors interleave the data in the same way ? This sounds quite 
hackish and vendor-specific to me, I'm not sure if we should try to generalize 
that. Maybe vendor-specific media bus format codes would be the way to go. I 
don't expect ISPs to understand the format, they will likely be configured in 
pass-through mode. Instead of adding explicit support for all those weird 
formats to all ISP drivers, it might make sense to add a "binary blob" media 
bus code to be used by the ISP.

-- 
Regards,

Laurent Pinchart
