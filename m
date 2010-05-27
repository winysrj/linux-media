Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755434Ab0E0Msk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 08:48:40 -0400
Date: Thu, 27 May 2010 14:48:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
cc: linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
In-Reply-To: <AANLkTik0DHDhmr78xOG2cTUgrTWZKzYDwBl27TXHgcGp@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1005271338370.2293@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
 <AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
 <Pine.LNX.4.64.1005270809110.2293@axis700.grange>
 <AANLkTik0DHDhmr78xOG2cTUgrTWZKzYDwBl27TXHgcGp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 May 2010, Jaya Kumar wrote:

> You've raised the MIPI-DSI issue. It is a good area to focus the
> discussion on for fbdev minded people and one that needs to be
> resolved soon so that we don't get dozens of host controller specific
> mipi display panel drivers. I had seen that omap2 fbdev has a portion
> of the MIPI-DSI command set exposed to their various display panel
> drivers which then hands off these commands to the omap specific
> lcd_mipid.c which uses spi. I see you've also implemented a similar
> concept in sh-mobile. When I saw the multiple display panel drivers
> showing up in omap, I raised a concern with Tomi and I think there was
> an intent to try to improve the abstraction. I'm not sure how far that
> has progressed. Are you saying v4l would help us in that area? I'm not
> yet able to follow the details of how using v4l would help address the
> need for mipi-dsi abstraction. Could you elaborate on that?

Well, I thought about an abstract driver for MIPI DSI... But, there is not 
really much there, that you can abstract. I've created a generic 
mipi_display.h header, that contains defines for display related (DSI, 
DCS) commands and transaction types. Once this header is in the mainline, 
we plan to convert OMAP drivers to it too. To talk to MIPI displays you 
need a capability to send and receive generic short and long telegrams, 
so, providing higher level functions like get_display_id() or 
soft_reset(), probably, wouldn't make sense. What you do need a proper API 
for is, when you start supporting proprietary display-specific commands 
and want to reuse those display drivers with different MIPI DSI hosts. For 
that we will want a generic API like .send_short_command(), 
.send_short_command_param(), etc.

As for using v4l2 for MIPI displays - well, I am not sure it makes sense 
at all. This could make sense if, e.g., you were writing a driver for a 
graphics controller, capable to talk to various PHYs over a fixed bus 
(which is actually also the case with the sh-mobile LCDC), then you could 
design it, using V4L2, in the following way:

/dev/videoX                /dev/fbX
   |                           |
   |   /- - fbdev translate - -/
   v   v
v4l2 output device driver
       |
       v
   v4l2-subdev API
    |    ...    |
    v           v
MIPI PHY ...  parallel PHY
 driver  ...    driver
    |
    v
 MIPI bus
abstraction
    |
    v
MIPI display
  driver

So, you would use the v4l2-subdev API to abstract various PHY drivers. The 
/dev/fbX link above would, certainly, only exist if we implement the 
v4l2-output - fbdev translation driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
