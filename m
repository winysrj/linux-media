Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47262 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1ESPci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 11:32:38 -0400
Date: Thu, 19 May 2011 18:32:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Michael Jones <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
Subject: Re: FW: OMAP 3 ISP
Message-ID: <20110519153232.GB1768@valkosipuli.localdomain>
References: <201105191627.20621.laurent.pinchart@ideasonboard.com>
 <4875438356E7CA4A8F2145FCD3E61C0B15D3557D3A@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D3A@MEP-EXCH.meprolight.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 19, 2011 at 06:13:28PM +0300, Alex Gershgorin wrote:
> Hi Michael,
> 
> I liked the idea of a driver that returns fixed format and frame size.
> It certainly could solve my problem.
> On the other hand, from your correspondence to Laurent, I realized that it was already done work on improving V4L2 subdevs.
> Michael patch of which you speak will help solve my problem without writing a special driver?
> Advise in what direction to go in my case?

Hi Alex,

You still need a driver, but with the patches you can easily implement that
as a driver for a platform device. The driver itself wouldn't have to do
much more than to return a fixed format and size when queried.

> 
> Regards,
> 
> Alex Gershgorin
> 
> 
> 
> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, May 19, 2011 5:27 PM
> To: Michael Jones
> Cc: Alex Gershgorin; 'linux-media@vger.kernel.org'; 'sakari.ailus@iki.fi'; 'agersh@rambler.ru'
> Subject: Re: FW: OMAP 3 ISP
> 
> Hi Michael,
> 
> On Thursday 19 May 2011 16:24:29 Michael Jones wrote:
> > On 05/19/2011 03:56 PM, Laurent Pinchart wrote:
> > > On Thursday 19 May 2011 15:44:18 Michael Jones wrote:
> > >> On 05/19/2011 03:02 PM, Laurent Pinchart wrote:
> > >>> On Thursday 19 May 2011 14:51:16 Alex Gershgorin wrote:
> > >>>> Thanks Laurent,
> > >>>>
> > >>>> My video source is not the video camera and performs many other
> > >>>> functions. For this purpose I have RS232 port.
> > >>>> As for the video, it runs continuously and is not subject to control
> > >>>> except for the power supply.
> > >>>
> > >>> As a quick hack, you can create an I2C driver for your video source
> > >>> that doesn't access the device and just returns fixed format and frame
> > >>> size.
> > >>>
> > >>> The correct fix is to implement support for platform subdevs in the
> > >>> V4L2 core.
> > >>
> > >> I recently implemented support for platform V4L2 subdevs.  Now that it
> > >> sounds like others would be interested in this, I will try to polish it
> > >> up and submit the patch for review in the next week or so.
> > >
> > > Great. This has been discussed during the V4L meeting in Warsaw, here are
> > > a couple of pointers, to make sure we're going in the same direction.
> > >
> > > Bridge drivers should not care whether the subdev sits on an I2C, SPI,
> > > platform or other bus. To achieve that, an abstraction layer must be
> > > provided by the V4L2 core. Here's what I got in one of my trees:
> > >
> > > /* V4L2 core */
> > >
> > > struct v4l2_subdev_i2c_board_info {
> > >
> > >         struct i2c_board_info *board_info;
> > >         int i2c_adapter_id;
> > >
> > > };
> > >
> > > enum v4l2_subdev_bus_type {
> > >
> > >         V4L2_SUBDEV_BUS_TYPE_NONE,
> > >         V4L2_SUBDEV_BUS_TYPE_I2C,
> > >         V4L2_SUBDEV_BUS_TYPE_SPI,
> > >
> > > };
> > >
> > > struct v4l2_subdev_board_info {
> > >
> > >         enum v4l2_subdev_bus_type type;
> > >         union {
> > >
> > >                 struct v4l2_subdev_i2c_board_info i2c;
> > >                 struct spi_board_info *spi;
> > >
> > >         } info;
> > >
> > > };
> > >
> > > /* OMAP3 ISP  */
> > >
> > > struct isp_v4l2_subdevs_group {
> > >
> > >         struct v4l2_subdev_board_info *subdevs;
> > >         enum isp_interface_type interface;
> > >         union {
> > >
> > >                 struct isp_parallel_platform_data parallel;
> > >                 struct isp_ccp2_platform_data ccp2;
> > >                 struct isp_csi2_platform_data csi2;
> > >
> > >         } bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
> > >
> > > };
> > >
> > > struct isp_platform_data {
> > >
> > >         struct isp_v4l2_subdevs_group *subdevs;
> > >
> > > };
> > >
> > > The V4L2 core would need to provide a function to register a subdev based
> > > on a v4l2_subdev_board_info structure.
> > >
> > > Is that in line with what you've done ? I can provide a patch that
> > > implements this for I2C and SPI, and let you add platform subdevs if
> > > that can help you.
> >
> > Hi Laurent,
> >
> > Yes, that looks very similar to what I've done.  I was going to submit
> > SPI support, too, which I also have, but it sounds like you've already
> > done that?  I'm currently still using a 2.6.38 tree based on an older
> > media branch of yours, so I'm not familiar with any new changes there yet.
> >
> > I just need to know what I should use as my baseline.
> 
> Please use mainline, now that the OMAP3 ISP driver has been merged :-)
> 
> > I don't need to step on toes and submit something you've already done, so
> > maybe you want to point me to a branch with the SPI stuff, and I'll just put
> > the platform stuff on top of it?
> 
> I'll send the SPI support patches to linux-media, as they haven't been
> reviewed publicly yet.
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> 
> __________ Information from ESET NOD32 Antivirus, version of virus signature database 6135 (20110519) __________
> 
> The message was checked by ESET NOD32 Antivirus.
> 
> http://www.eset.com
> 
> 
> 
> __________ Information from ESET NOD32 Antivirus, version of virus signature database 6135 (20110519) __________
> 
> The message was checked by ESET NOD32 Antivirus.
> 
> http://www.eset.com
> 

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
