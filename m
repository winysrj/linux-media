Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34431 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1I2LLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 07:11:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: add convenience macros to the subdevice / Media Controller API
Date: Thu, 29 Sep 2011 13:11:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1109291016250.30865@axis700.grange> <201109291032.00328.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1109291040460.30865@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109291040460.30865@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109291311.37133.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 29 September 2011 10:44:14 Guennadi Liakhovetski wrote:
> On Thu, 29 Sep 2011, Laurent Pinchart wrote:
> > On Thursday 29 September 2011 10:18:31 Guennadi Liakhovetski wrote:
> > > Drivers, that can be built and work with and without
> > > CONFIG_VIDEO_V4L2_SUBDEV_API, need the v4l2_subdev_get_try_format() and
> > > v4l2_subdev_get_try_crop() functions, even though their return value
> > > should never be dereferenced. Also add convenience macros to init and
> > > clean up subdevice internal media entities.
> > 
> > Why don't you just make the drivers depend on
> > CONFIG_VIDEO_V4L2_SUBDEV_API ? They don't need to actually export a
> > device node to userspace, but they require the in-kernel API.
> 
> Why? Why should the user build and load all the media controller stuff,
> buy all the in-kernel objects and code to never actually use it? Where
> OTOH all is needed to avoid that is a couple of NOP macros?

Because the automatic compatibility layer that will translate video operations 
to pad operations will need to access pads, so subdevs that implement a pad-
level API need to export it to the bridge, even if the bridge is not MC-aware.

-- 
Regards,

Laurent Pinchart
