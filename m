Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:47595 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0JFKSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 06:18:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH/RFC v3 04/11] v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
Date: Wed, 6 Oct 2010 12:18:55 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <1286288714-16506-5-git-send-email-laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404AA21CCB2@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CCB2@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010061218.56330.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Wednesday 06 October 2010 11:19:25 Hiremath, Vaibhav wrote:
> On Tuesday, October 05, 2010 7:55 PM Laurent Pinchart wrote:
> > 
> > Add the following media bus format code definitions:
> > 
> > - V4L2_MBUS_FMT_SGRBG10_1X10 for 10-bit GRBG Bayer
> > - V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 for 10-bit DPCM compressed GRBG Bayer
> > - V4L2_MBUS_FMT_YUYV16_1X16 for 8-bit YUYV on 16-bit bus
> > - V4L2_MBUS_FMT_UYVY16_1X16 for 8-bit UYVY on 16-bit bus
> > - V4L2_MBUS_FMT_YVYU16_1X16 for 8-bit YVYU on 16-bit bus
> > - V4L2_MBUS_FMT_VYUY16_1X16 for 8-bit VYUY on 16-bit bus

The commit message should list V4L2_MBUS_FMT_*8_1X16 instead of 
V4L2_MBUS_FMT_*16_1X16, my bad.
> 
> Laurent I may be wrong here, but I think above definition is confusing -
> 
> For me the above definition actually means, 16bits are coming on the bus
> for every cycle.

That's correct.

> If you are referring to OMAP3 interface here then 8->16 bit conversion
> happens inside ISP-bridge, the interface from sensor-to-CCDC is still 8
> bit (Technically it is 10, but we are using lane shifter to get 8 bits)
> and I believe sensor is also sending one component for every cycle (either
> UYVY or YUYV).

That's correct as well.

> And I believe the bridge driver is not exported to user application so we
> should be using MBUS_FMT_UYVY8_2x8 and family.

The V4L2_MBUS_FMT_*8_1X16 formats are used for the preview -> resizer link, 
not the sensor -> CCDC link. For the later the V4L2_MBUS_FMT_*8_2X8 are used 
instead.

-- 
Regards,

Laurent Pinchart
