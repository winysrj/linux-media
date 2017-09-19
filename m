Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38237 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbdISMhz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:37:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 21/25] smiapp: Add support for flash and lens devices
Date: Tue, 19 Sep 2017 15:38:00 +0300
Message-ID: <10998149.DTLv6WZvUP@avalon>
In-Reply-To: <20170919122034.ux6refntfviofx3y@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <1881974.bD6jRInLY1@avalon> <20170919122034.ux6refntfviofx3y@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 15:20:34 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 03:08:25PM +0300, Laurent Pinchart wrote:
> > On Friday, 15 September 2017 17:17:20 EEST Sakari Ailus wrote:
> >> Parse async sub-devices by using
> >> v4l2_subdev_fwnode_reference_parse_sensor_common().
> >> 
> >> These types devices aren't directly related to the sensor, but are
> >> nevertheless handled by the smiapp driver due to the relationship of
> >> these component to the main part of the camera module --- the sensor.
> >> 
> >> This does not yet address providing the user space with information on
> >> how to associate the sensor or lens devices but the kernel now has the
> >> necessary information to do that.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Acked-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Something is bothering me here, not so much in the contents of the patch
> > itself than in its nature. There are four patches in this series that add
> > support for flash and lens devices to the smiapp, et8ek8, ov5670 and
> > ov13858 drivers. We have way more sensor drivers than that, and I don't
> > really want to patch them all to support flash and lens. I believe a less
> > intrusive approach, more focussed on the V4L2 core, is needed.
> 
> You could move this to the framework, yes. Nothing prevents that. Perhaps a
> flag telling the framework whether this should be done? Just being
> opportunistic might work as well.

How is would be done is another matter which I haven't thought about yet :-) 
My point is that I don't think converting all drivers is a good idea, you 
should aim for an implementation in the core.

> >> ---
> >> 
> >>  drivers/media/i2c/smiapp/smiapp-core.c | 38 ++++++++++++++++++++-------
> >>  drivers/media/i2c/smiapp/smiapp.h      |  4 +++-
> >>  2 files changed, 33 insertions(+), 9 deletions(-)

-- 
Regards,

Laurent Pinchart
