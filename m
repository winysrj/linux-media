Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33419 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2BRBn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 20:43:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
Date: Sat, 18 Feb 2012 02:43:52 +0100
Message-ID: <4603092.UUnjJ05PXI@avalon>
In-Reply-To: <4F3EE3C3.6070605@gmail.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <6366737.ZEMB1VQOcD@avalon> <4F3EE3C3.6070605@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Saturday 18 February 2012 00:33:23 Sylwester Nawrocki wrote:
> On 02/18/2012 12:23 AM, Laurent Pinchart wrote:
> >>   struct v4l2_subdev_video_ops {
> >>   
> >>   	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> >> 
> >> config); @@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
> >> 
> >>   			     struct v4l2_mbus_config *cfg);
> >>   	
> >>   	int (*s_mbus_config)(struct v4l2_subdev *sd,
> >>   	
> >>   			     const struct v4l2_mbus_config *cfg);
> >> 
> >> +	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
> >> +			       void **buf);
> >> 
> >>   };
> > 
> > How is the embedded data transferred from the sensor to the host in your
> > case ? Over I2C ?
> 
> It's transferred over MIPI-CSI2 bus and is intercepted by the MIPI-CSI2
> receiver, before the image data DMA. The MIPI-CSI2 doesn't have its own
> DMA engine. More details can be found in patch 6/6.

As the data is transmitted by the device without any polling from the host, 
shouldn't it just go to a metadata plane in the V4L2 buffer ?

-- 
Regards,

Laurent Pinchart
