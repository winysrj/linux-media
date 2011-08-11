Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:43486 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HKHiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 03:38:52 -0400
Date: Thu, 11 Aug 2011 10:38:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Message-ID: <20110811073846.GD5926@valkosipuli.localdomain>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108081750.07000.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108081750.07000.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 08, 2011 at 05:50:06PM +0200, Laurent Pinchart wrote:
> Hi everybody,

Hi, all!

> The V4L2 brainstorming meeting held in Cambourne from August the 1st to August 
> the 5th was a success. I would like to thank Linaro again, and particularly 
> Stephen Doel and Arwen Donaghey, for accommodating us during the whole week.
> 
> Here is a summary of the discussions, with preliminary conclusions, ideas, and 
> action points.

Thanks for the notes!

...

> Pixel clock and blanking
> ------------------------
> 
>  Preliminary conclusions:
> 
>  - Pixel clock(s) and blanking will be exported through controls on subdev
>    nodes.
>  - The pixel array pixel clock is needed by userspace.
>  - Hosts/bridges/ISPs need pixel clock and blanking information to validate
>    pipelines.

I have a small addition to this in my notes:


Pixel array and bus configuration for sensors
---------------------------------------------

The CSI-2 bus frequency will receive an integer menu control. Together with
the binning, skipping, scaling and CSI-2 output bits-per-pixel information,
this allows the sensor driver to calculate the value of the "best pixel
rate" in the sensor, which will be a read-only int64 control.

Based on pixel clock, image width, height and ranges on vertical and
horizontal blanking, the user can define the frame rate. Vertical and
horizontal blanking are implemented as integer controls.

Integer menu controls are easy to add; this will be implemented by making
the name field in v4l2_querymenu an anonymous union. (I actually have
patches for this but haven't tested them yet. I'll send them once I have
time for that.)


Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
