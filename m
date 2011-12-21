Return-path: <linux-media-owner@vger.kernel.org>
Received: from [212.255.40.35] ([212.255.40.35]:52862 "HELO
	neutronstar.dyndns.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1752331Ab1LUHvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 02:51:14 -0500
Date: Wed, 21 Dec 2011 08:43:47 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v4] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20111221074347.GA12861@neutronstar.dyndns.org>
References: <1324116655-15895-1-git-send-email-martin@neutronstar.dyndns.org>
 <201112210206.20567.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112210206.20567.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 21, 2011 at 02:06:20AM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> Thanks for the patch.
> 
> On Saturday 17 December 2011 11:10:55 Martin Hostettler wrote:
> > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> > 
> > The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> > exposure and v/h flipping controls in monochrome mode with an
> > external pixel clock.
> 
> There are still several small issues with this driver. Things like not using 
> the module_i2c_driver() macro, some indentation, magic values in registers 
> (I'm trying to get more documentation), PLL setup (although that can be fixed 
> later, it's not a requirement for the driver to be mainlined), ...
> 
> Would you be fine if I took the patch in my tree, fixed the remaining issues 
> and pushed it to mainline for v3.4 (the time frame is too short for v3.3) ? 

Sure, that would be much appreciated. Thanks for reviewing and takeing
these patches!

Best regards, 
 - Martin Hostettler


> Authorship will of course be preserved. The alternative would be to go through 
> review/modification cycles, and I don't want to waste too much of your time 
> :-)
> 
> -- 
> Best regards,
> 
> Laurent Pinchart
