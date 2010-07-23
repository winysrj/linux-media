Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3956 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0GWNqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 09:46:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Per-subdev, host-specific data
Date: Fri, 23 Jul 2010 15:46:29 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201007231501.31170.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007231501.31170.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007231546.29691.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 July 2010 15:01:29 Laurent Pinchart wrote:
> Hi everybody,
> 
> Trying to implement support for multiple sensors connected to the same OMAP3 
> ISP input (all but one of the sensors need to be kept in reset obviously), I 
> need to associate host-specific data to the sensor subdevs.
> 
> The terms host and bridge are considered as synonyms in the rest of this e-
> mail.
> 
> The OMAP3 ISP platform data has interface configuration parameters for the two 
> CSI2 (a and c), CCP2 and parallel interfaces. The parameters are used to 
> configure the bus when a sensor is selected. To support multiple sensors on 
> the same input, the parameters need to be specified per-sensor, and not ISP-
> wide.
> 
> No issue in the platform data. Board codes declare an array of structures that 
> embed a struct v4l2_subdev_i2c_board_info instance and an OMAP3 ISP-specific 
> interface configuration structure.
> 
> At runtime, when a sensor is selected, I need to access the OMAP3 ISP-specific 
> interface configuration structure for the selected sensor. At that point all I 
> have is a v4l2_subdev structure pointer, without a way to get back to the 
> interface configuration structure.
> 
> The only point in the code where the v4l2_subdev and the interface 
> configuration data are both known and could be linked together is in the host 
> driver's probe function, where the v4l2_subdev instances are created. I have 
> two solutions there:
> 
> - store the v4l2_subdev pointer and the interface configuration data pointer 
> in a host-specific array, and perform a an array lookup operation at runtime 
> with the v4l2_subdev pointer as a key
> 
> - add a void *host_priv field to the v4l2_subdev structure, store the 
> interface configuration data pointer in that field, and use the field at 
> runtime
> 
> The second solution seems cleaner but requires an additional field in 
> v4l2_subdev. Opinions and other comments will be appreciated.

There is a third option: the grp_id field is owned by the host driver, so you
could make that an index into a host specific array.

That said, I think having a host_priv field isn't a bad idea. Although if we
do this, then I think the existing priv field should be renamed to drv_priv
to prevent confusion.

Regards,

            Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
