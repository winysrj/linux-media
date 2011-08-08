Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59777 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHVxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 17:53:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] The clock dependencies between sensor subdevs and the host interface drivers
Date: Mon, 8 Aug 2011 23:53:12 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
References: <4E400280.7070100@samsung.com> <201108081744.37953.laurent.pinchart@ideasonboard.com> <alpine.DEB.2.00.1108081917340.5873@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1108081917340.5873@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108082353.12655.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 08 August 2011 19:29:13 Guennadi Liakhovetski wrote:
> On Mon, 8 Aug 2011, Laurent Pinchart wrote:
> > On Monday 08 August 2011 17:36:32 Sylwester Nawrocki wrote:
> > > Hi everyone,
> > > 
> > > Nowadays many of the V4L2 camera device drivers heavily depend on the
> > > board code to set up voltage supplies, clocks, and some control
> > > signals, like 'reset' and 'standby' signals for the sensors. Those
> > > things are often being done by means of the driver specific platform
> > > data callbacks.
> > > 
> > > There has been recently quite a lot effort on ARM towards migration to
> > > the device tree. Unfortunately the custom platform data callbacks
> > > effectively prevent the boards to be booted and configured through the
> > > device tree bindings.
> > > 
> > > The following is usually handled in the board files:
> > > 
> > > 1) sensor/frontend power supply
> > > 2) sensor's master clock (provided by the host device)
> > > 3) reset and standby signals (GPIO)
> > > 4) other signals applied by the host processor to the sensor device,
> > > e.g.
> > > 
> > >    I2C level shifter enable, etc.
> > > 
> > > For 1), the regulator API should possibly be used. It should be
> > > applicable for most, if not all cases.
> > > 3) and 4) are a bit hard as there might be huge differences across
> > > boards as how many GPIOs are used, what are the required delays
> > > between changes of their states, etc. Still we could try to find a
> > > common description of the behaviour and pass such information to the
> > > drivers.
> > > 
> > > For 2) I'd like to propose adding a callback to struct v4l2_device, for
> > > instance as in the below patch. The host driver would implement such an
> > > operation and the sensor subdev driver would use it in its s_power op.
> > 
> > What about using a struct clk object ? There has been lots of work in the
> > ARM tree to make struct clk generic. I'm not sure if all patches have
> > been pushed to mainline yet, but I think that's the direction we should
> > follow.
> > 
> > > If there is more than one output clock at the host, to distinguish
> > > which clock applies to a given sensor the host driver could be passed
> > > the assignment information in it's platform data.
> > > 
> > > AFAICS in the omap3isp case the clock control is done through the board
> > > code. I wonder what prevents making direct calls between the drivers,
> > > as the sensor subdevs call a board code callback there, which in turn
> > > only calls into the omap3isp driver.
> > > What am I missing ?
> > 
> > We go through board code to remove dependencies between drivers. My goal
> > is to implement this through struct clk, but I haven't had time to work
> > on that yet.
> 
> Is this now a different topic from what I have proposed in mbus
> configuration RFC initially or have you changed your opinion?

It's a different topic. Your mbus configuration RFC was dealing with the bus 
clock, while this is dealing with the sensor (or other subdev) input clock.

-- 
Regards,

Laurent Pinchart
