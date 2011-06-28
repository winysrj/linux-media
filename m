Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1F1WfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 18:35:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex Gershgorin <alexg@meprolight.com>
Subject: Re: FW: OMAP 3 ISP
Date: Wed, 29 Jun 2011 00:35:22 +0200
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	Michael Jones <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
References: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E3D@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E3D@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106290035.22807.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

On Tuesday 28 June 2011 09:47:07 Alex Gershgorin wrote:
> Hi Laurent,
> 
> I recently got the Zoom OMAP35xx Torpedo and began testing OMAP3ISP.
> Currently I have a problem I can't solve.
> See Message from booting Kernel:
> 
> Linux media interface: v0.10
> Linux video capture interface: v2.00
> omap3isp omap3isp: Revision 2.0 found
> omap-iommu omap-iommu.0: isp: version 1.1
> isp_register_subdev_group: Unable to register subdev
> 
> What could be the problem, why sub device can't pass a registration?

This means the v4l2_i2c_new_subdev_board() failed. Do you have a driver for 
the subdev ? Does it get loaded ? Does its probe() function get called ?

-- 
Regards,

Laurent Pinchart
