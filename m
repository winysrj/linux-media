Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60427 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab1ESO1T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 10:27:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: FW: OMAP 3 ISP
Date: Thu, 19 May 2011 16:27:20 +0200
Cc: Alex Gershgorin <alexg@meprolight.com>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'sakari.ailus@iki.fi'" <sakari.ailus@iki.fi>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
References: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D38@MEP-EXCH.meprolight.com> <201105191556.07323.laurent.pinchart@ideasonboard.com> <4DD5281D.40103@matrix-vision.de>
In-Reply-To: <4DD5281D.40103@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191627.20621.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Thursday 19 May 2011 16:24:29 Michael Jones wrote:
> On 05/19/2011 03:56 PM, Laurent Pinchart wrote:
> > On Thursday 19 May 2011 15:44:18 Michael Jones wrote:
> >> On 05/19/2011 03:02 PM, Laurent Pinchart wrote:
> >>> On Thursday 19 May 2011 14:51:16 Alex Gershgorin wrote:
> >>>> Thanks Laurent,
> >>>> 
> >>>> My video source is not the video camera and performs many other
> >>>> functions. For this purpose I have RS232 port.
> >>>> As for the video, it runs continuously and is not subject to control
> >>>> except for the power supply.
> >>> 
> >>> As a quick hack, you can create an I2C driver for your video source
> >>> that doesn't access the device and just returns fixed format and frame
> >>> size.
> >>> 
> >>> The correct fix is to implement support for platform subdevs in the
> >>> V4L2 core.
> >> 
> >> I recently implemented support for platform V4L2 subdevs.  Now that it
> >> sounds like others would be interested in this, I will try to polish it
> >> up and submit the patch for review in the next week or so.
> > 
> > Great. This has been discussed during the V4L meeting in Warsaw, here are
> > a couple of pointers, to make sure we're going in the same direction.
> > 
> > Bridge drivers should not care whether the subdev sits on an I2C, SPI,
> > platform or other bus. To achieve that, an abstraction layer must be
> > provided by the V4L2 core. Here's what I got in one of my trees:
> > 
> > /* V4L2 core */
> > 
> > struct v4l2_subdev_i2c_board_info {
> > 
> >         struct i2c_board_info *board_info;
> >         int i2c_adapter_id;
> > 
> > };
> > 
> > enum v4l2_subdev_bus_type {
> > 
> >         V4L2_SUBDEV_BUS_TYPE_NONE,
> >         V4L2_SUBDEV_BUS_TYPE_I2C,
> >         V4L2_SUBDEV_BUS_TYPE_SPI,
> > 
> > };
> > 
> > struct v4l2_subdev_board_info {
> > 
> >         enum v4l2_subdev_bus_type type;
> >         union {
> >         
> >                 struct v4l2_subdev_i2c_board_info i2c;
> >                 struct spi_board_info *spi;
> >         
> >         } info;
> > 
> > };
> > 
> > /* OMAP3 ISP  */
> > 
> > struct isp_v4l2_subdevs_group {
> > 
> >         struct v4l2_subdev_board_info *subdevs;
> >         enum isp_interface_type interface;
> >         union {
> >         
> >                 struct isp_parallel_platform_data parallel;
> >                 struct isp_ccp2_platform_data ccp2;
> >                 struct isp_csi2_platform_data csi2;
> >         
> >         } bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
> > 
> > };
> > 
> > struct isp_platform_data {
> > 
> >         struct isp_v4l2_subdevs_group *subdevs;
> > 
> > };
> > 
> > The V4L2 core would need to provide a function to register a subdev based
> > on a v4l2_subdev_board_info structure.
> > 
> > Is that in line with what you've done ? I can provide a patch that
> > implements this for I2C and SPI, and let you add platform subdevs if
> > that can help you.
> 
> Hi Laurent,
> 
> Yes, that looks very similar to what I've done.  I was going to submit
> SPI support, too, which I also have, but it sounds like you've already
> done that?  I'm currently still using a 2.6.38 tree based on an older
> media branch of yours, so I'm not familiar with any new changes there yet.
> 
> I just need to know what I should use as my baseline.

Please use mainline, now that the OMAP3 ISP driver has been merged :-)

> I don't need to step on toes and submit something you've already done, so
> maybe you want to point me to a branch with the SPI stuff, and I'll just put
> the platform stuff on top of it?

I'll send the SPI support patches to linux-media, as they haven't been 
reviewed publicly yet.

-- 
Regards,

Laurent Pinchart
