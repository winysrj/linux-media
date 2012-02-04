Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54413 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2BDLes (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 06:34:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
Date: Sat, 04 Feb 2012 12:34:39 +0100
Message-ID: <4637542.W3k3fJhoQF@avalon>
In-Reply-To: <4F2A7000.7080201@samsung.com>
References: <4F27CF29.5090905@samsung.com> <201202021055.19705.laurent.pinchart@ideasonboard.com> <4F2A7000.7080201@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 02 February 2012 12:14:08 Sylwester Nawrocki wrote:
> On 02/02/2012 10:55 AM, Laurent Pinchart wrote:
> > Do all those sensors interleave the data in the same way ? This sounds
> > quite
> No, each one uses it's own interleaving method.
> 
> > hackish and vendor-specific to me, I'm not sure if we should try to
> > generalize that. Maybe vendor-specific media bus format codes would be
> > the way to go. I don't expect ISPs to understand the format, they will
> > likely be configured in pass-through mode. Instead of adding explicit
> > support for all those weird formats to all ISP drivers, it might make
> > sense to add a "binary blob" media bus code to be used by the ISP.
> 
> This could work, except that there is no way to match a fourcc with media
> bus code. Different fourcc would map to same media bus code, making it
> impossible for the brigde to handle multiple sensors or one sensor
> supporting multiple interleaved formats. Moreover there is a need to map
> media bus code to the MIPI-CSI data ID. What if one sensor sends "binary"
> blob with MIPI-CSI "User Define Data 1" and the other with "User Define
> Data 2" ?

My gut feeling is that the information should be retrieved from the sensor 
driver. This is all pretty vendor-specific, and adding explicit support for 
such sensors to each bridge driver wouldn't be very clean. Could the bridge 
query the sensor using a subdev operation ?

> Maybe we could create e.g. V4L2_MBUS_FMT_USER?, for each MIPI-CSI User
> Defined data identifier, but as I remember it was decided not to map
> MIPI-CSI data codes directly onto media bus pixel codes.

Would setting the format directly on the sensor subdev be an option ?

-- 
Regards,

Laurent Pinchart
