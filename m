Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54407 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1HILtW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 07:49:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] The clock dependencies between sensor subdevs and the host interface drivers
Date: Tue, 9 Aug 2011 13:49:17 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
References: <4E400280.7070100@samsung.com> <201108081744.37953.laurent.pinchart@ideasonboard.com> <4E40EB80.7080302@samsung.com>
In-Reply-To: <4E40EB80.7080302@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108091349.18460.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 09 August 2011 10:10:40 Sylwester Nawrocki wrote:
> On 08/08/2011 05:44 PM, Laurent Pinchart wrote:
> > On Monday 08 August 2011 17:36:32 Sylwester Nawrocki wrote:
> >> Hi everyone,
> >> 
> >> Nowadays many of the V4L2 camera device drivers heavily depend on the
> >> board code to set up voltage supplies, clocks, and some control
> >> signals, like 'reset' and 'standby' signals for the sensors. Those
> >> things are often being done by means of the driver specific platform
> >> data callbacks.
> >> 
> >> There has been recently quite a lot effort on ARM towards migration to
> >> the device tree. Unfortunately the custom platform data callbacks
> >> effectively prevent the boards to be booted and configured through the
> >> device tree bindings.
> >> 
> >> The following is usually handled in the board files:
> >> 
> >> 1) sensor/frontend power supply
> >> 2) sensor's master clock (provided by the host device)
> >> 3) reset and standby signals (GPIO)
> >> 4) other signals applied by the host processor to the sensor device,
> >> e.g.
> >> 
> >>    I2C level shifter enable, etc.
> >> 
> >> For 1), the regulator API should possibly be used. It should be
> >> applicable for most, if not all cases.
> >> 3) and 4) are a bit hard as there might be huge differences across
> >> boards as how many GPIOs are used, what are the required delays between
> >> changes of their states, etc. Still we could try to find a common
> >> description of the behaviour and pass such information to the drivers.
> >> 
> >> For 2) I'd like to propose adding a callback to struct v4l2_device, for
> >> instance as in the below patch. The host driver would implement such an
> >> operation and the sensor subdev driver would use it in its s_power op.
> > 
> > What about using a struct clk object ? There has been lots of work in the
> > ARM tree to make struct clk generic. I'm not sure if all patches have
> > been pushed to mainline yet, but I think that's the direction we should
> > follow.
> 
> But is the 'struct clk' tried to be unified across all archs, not only ARM
> ? I'm afraid it's not the case.

If the goals haven't changed since https://lkml.org/lkml/2011/5/20/85, the new 
struct clk will be unified across all architectures.

> By "using a struct clk object" do you also mean implementing some/all ops
> of this object by the driver which exports it ?

That's correct.

> I suppose we can't rely only on the clock controller functionality exposed
> through the clock API.
> 
> Some devices may need to be brought to an active state before the clock can
> be used outside. Some may have internal frequency dividers which need to be
> handled in addition to the clock path in the clock controller.
> 
> For instance, on Exynos4 the FIMC devices belong to a power domain that
> needs to be enabled so the clock is not  blocked, and this is done through
> the runtime PM calls.
> 
> Normally the host device driver runtime resumes the device when /dev/video*
> is opened. But we might want to use the clock before it happens, when only
> a /dev/v4l-subdev* is opened, to play with the sensor device only. In this
> situation the host device needs to be runtime resumed first.
> 
> Thus the driver would need to (re)implement the clock ops to also handle
> the details which are not covered by the clock controller driver.

The subdev driver would call clk_get(), which would end up being implemented 
by the driver for whatever hardware block provides the clock. The driver would 
then runtime_pm_resume() the hardware to start the clock.

> I also wonder how could we support the boards which choose to use some
> extra external oscillator to provide clock to the sensors, rather than the
> one derived from the host.

In that case the clock is always running. I'm not sure if we should create a 
dummy clk object, or just pass a NULL clock and a fixed frequency to the 
sensor driver.

-- 
Regards,

Laurent Pinchart
