Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29294 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab0GWPQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 11:16:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L60006X2NR4YM10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jul 2010 16:16:16 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L60002QENR3KK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jul 2010 16:16:16 +0100 (BST)
Date: Fri, 23 Jul 2010 17:14:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [RFC] Per-subdev, host-specific data
In-reply-to: <201007231501.31170.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Sakari Ailus' <sakari.ailus@maxwell.research.nokia.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>
Message-id: <000b01cb2a79$cb7e42d0$627ac870$%nawrocki@samsung.com>
Content-language: en-us
References: <201007231501.31170.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Friday, July 23, 2010 3:01 PM
> To: Linux Media Mailing List
> Cc: Sakari Ailus; Guennadi Liakhovetski
> Subject: [RFC] Per-subdev, host-specific data
> 
> Hi everybody,
> 
> Trying to implement support for multiple sensors connected to the same
> OMAP3
> ISP input (all but one of the sensors need to be kept in reset
> obviously), I
> need to associate host-specific data to the sensor subdevs.
> 
> The terms host and bridge are considered as synonyms in the rest of
> this e-
> mail.
> 
> The OMAP3 ISP platform data has interface configuration parameters for
> the two
> CSI2 (a and c), CCP2 and parallel interfaces. The parameters are used
> to
> configure the bus when a sensor is selected. To support multiple
> sensors on
> the same input, the parameters need to be specified per-sensor, and not
> ISP-
> wide.
> 
> No issue in the platform data. Board codes declare an array of
> structures that
> embed a struct v4l2_subdev_i2c_board_info instance and an OMAP3 ISP-
> specific
> interface configuration structure.
> 
> At runtime, when a sensor is selected, I need to access the OMAP3 ISP-
> specific
> interface configuration structure for the selected sensor. At that
> point all I
> have is a v4l2_subdev structure pointer, without a way to get back to
> the
> interface configuration structure.
> 
> The only point in the code where the v4l2_subdev and the interface
> configuration data are both known and could be linked together is in
> the host
> driver's probe function, where the v4l2_subdev instances are created. I
> have
> two solutions there:
> 
> - store the v4l2_subdev pointer and the interface configuration data
> pointer
> in a host-specific array, and perform a an array lookup operation at
> runtime
> with the v4l2_subdev pointer as a key
> 
> - add a void *host_priv field to the v4l2_subdev structure, store the
> interface configuration data pointer in that field, and use the field
> at
> runtime
> 
> The second solution seems cleaner but requires an additional field in
> v4l2_subdev. Opinions and other comments will be appreciated.
> 

I like the solution with an additional void *host_priv field,
it could also possibly be useful for the notify() callback to v4l2_subdev
parent.
On our SoCs we also need some camera host interface specific data to be
attached
to image sensor subdevice and later passed to host driver. So host_priv
field in v4l2_subdev would be nice feature to have.

> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center


