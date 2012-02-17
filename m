Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56911 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2BQXWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 18:22:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/6] V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media bus format
Date: Sat, 18 Feb 2012 00:22:06 +0100
Message-ID: <15287242.Y7HLBiloy7@avalon>
In-Reply-To: <4F3E6395.4070208@samsung.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <20120216194615.GF7784@valkosipuli.localdomain> <4F3E6395.4070208@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 17 February 2012 15:26:29 Sylwester Nawrocki wrote:
> On 02/16/2012 08:46 PM, Sakari Ailus wrote:
> > On Thu, Feb 16, 2012 at 07:23:54PM +0100, Sylwester Nawrocki wrote:
> >> This patch adds media bus pixel code for the interleaved JPEG/YUYV image
> >> format used by S5C73MX Samsung cameras. The interleaved image data is
> >> transferred on MIPI-CSI2 bus as User Defined Byte-based Data.
> >> 
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> 
> >>  include/linux/v4l2-mediabus.h |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/include/linux/v4l2-mediabus.h
> >> b/include/linux/v4l2-mediabus.h
> >> index 5ea7f75..c2f0e4e 100644
> >> --- a/include/linux/v4l2-mediabus.h
> >> +++ b/include/linux/v4l2-mediabus.h
> >> @@ -92,6 +92,9 @@ enum v4l2_mbus_pixelcode {
> >> 
> >>  	/* JPEG compressed formats - next is 0x4002 */
> >>  	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> >> 
> >> +
> >> +	/* Interleaved JPEG and YUV formats - next is 0x4102 */
> >> +	V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 = 0x4101,
> >> 
> >>  };

Please remember to update Documentation/DocBook/media/v4l/subdev-formats.xml.

> > Thanks for the patch. Just a tiny comment:
> > 
> > I'd go with a new hardware-specific buffer range, e.g. 0x5000.
> 
> Sure, that makes more sense. But I guess you mean "format" not "buffer"
> range ?
>
> > Guennadi also proposed an interesting idea: a "pass-through" format. Does
> > your format have dimensions that the driver would use for something or is
> > that just a blob?
> 
> It's just a blob for the drivers, dimensions may be needed for subdevs to
> compute overall size of data for example. But the host driver, in case of
> Samsung devices, basically just needs to know the total size of frame data.
> 
> I'm afraid the host would have to additionally configure subdevs in the data
> pipeline in case of hardware-specific format, when we have used a single
> binary blob media bus format identifier. For example MIPI-CSI2 data format
> would have to be set up along the pipeline. There might be more attributes
> in the future like this. Not sure if we want to go that path ?
> 
> I'll try and see how it would look like with a single "pass-through" format.
> Probably using g/s_mbus_config operations ?

I'm not sure yet how all this should be handled exactly, but I'm pretty sure I 
don't want the CSI2 receiver drivers to handle all the vendor-specific blob-
like formats explicitly. For instance your sensor could be used with the OMAP3 
ISP, and I don't want to add support for V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 to the 
OMAP3 ISP CSI2 driver. We need a way for CSI2 receiver drivers to map blob 
formats automatically. Enumeration also needs to be handled, which makes the 
problem even more complex.

-- 
Regards,

Laurent Pinchart
