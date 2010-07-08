Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52060 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab0GHMCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 08:02:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Thu, 8 Jul 2010 14:01:52 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007071453.22261.laurent.pinchart@ideasonboard.com> <72c0021199a577840a434d9195cb9e61.squirrel@webmail.xs4all.nl>
In-Reply-To: <72c0021199a577840a434d9195cb9e61.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081401.53023.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 07 July 2010 15:04:17 Hans Verkuil wrote:
> > On Wednesday 07 July 2010 14:30:45 Hans Verkuil wrote:

[snip]

> > Some (most ?) I2C sensors need to be accessed during probe. This involves
> > powering the sensor up, which is handled by a board code function called
> > through a platform data function pointer.
> > 
> > On the OMAP3 ISP the sensor clock can be generated by the ISP. This means
> > that board code needs to call an ISP (exported) function to turn the clock
> > on. To do so we currently retrieve a pointer to the ISP device through the
> > subdev's parent v4l2_device, embedded in the ISP device structure. This
> > requires the subdev to be registered, otherwise its parent will be NULL.
> > For that reason we're still using the core::s_config operation.
> > 
> > This is obviously not an ideal situation, and I'm open to suggestions on
> > how to solve it without core::s_config. One possibility would be to use a
> > global ISP device pointer in the board code, as there's only one ISP
> > device in the system. It feels a bit hackish though.
> 
> Or make the v4l2_device pointer part of the platform data? That way the
> subdev driver has access to the v4l2_device pointer in a fairly clean
> manner.

As we've discussed on IRC, the platform data should really store hardware 
properties, not software/driver information. Beside, storing the v4l2_device 
pointer in the platform data would be quite difficult, as 
v4l2_device_register_subdev only sees a void * pointer for platform_data. It 
has no knowledge of the device-specific structure.

-- 
Regards,

Laurent Pinchart
