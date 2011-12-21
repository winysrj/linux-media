Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37271 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1LUWX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 17:23:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v4] v4l: Add driver for Micron MT9M032 camera sensor
Date: Wed, 21 Dec 2011 23:23:59 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1324116655-15895-1-git-send-email-martin@neutronstar.dyndns.org> <201112210206.20567.laurent.pinchart@ideasonboard.com> <20111221074347.GA12861@neutronstar.dyndns.org>
In-Reply-To: <20111221074347.GA12861@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112212324.00713.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wednesday 21 December 2011 08:43:47 martin@neutronstar.dyndns.org wrote:
> On Wed, Dec 21, 2011 at 02:06:20AM +0100, Laurent Pinchart wrote:
> > On Saturday 17 December 2011 11:10:55 Martin Hostettler wrote:
> > > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through
> > > I2C.
> > > 
> > > The driver creates a V4L2 subdevice. It currently supports cropping,
> > > gain, exposure and v/h flipping controls in monochrome mode with an
> > > external pixel clock.
> > 
> > There are still several small issues with this driver. Things like not
> > using the module_i2c_driver() macro, some indentation, magic values in
> > registers (I'm trying to get more documentation), PLL setup (although
> > that can be fixed later, it's not a requirement for the driver to be
> > mainlined), ...
> > 
> > Would you be fine if I took the patch in my tree, fixed the remaining
> > issues and pushed it to mainline for v3.4 (the time frame is too short
> > for v3.3) ?
> 
> Sure,

Thank you.

> that would be much appreciated. Thanks for reviewing and takeing these
> patches!

You're welcome.

> > Authorship will of course be preserved. The alternative would be to go
> > through review/modification cycles, and I don't want to waste too much
> > of your time
> > 
> > :-)

-- 
Regards,

Laurent Pinchart
