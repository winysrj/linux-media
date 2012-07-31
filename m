Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42117 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2GaK5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:57:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based instantiation
Date: Tue, 31 Jul 2012 12:57:07 +0200
Message-ID: <2642305.FyjWrDc1Fo@avalon>
In-Reply-To: <Pine.LNX.4.64.1207311144470.27888@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <6250402.9RzN62tRPe@avalon> <Pine.LNX.4.64.1207311144470.27888@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 31 July 2012 11:56:44 Guennadi Liakhovetski wrote:
> On Thu, 26 Jul 2012, Laurent Pinchart wrote:
> > On Wednesday 18 July 2012 11:18:33 Sylwester Nawrocki wrote:
> > > On 07/16/2012 11:42 AM, Guennadi Liakhovetski wrote:
> > > > On Fri, 25 May 2012, Sylwester Nawrocki wrote:
> > > >> The driver initializes all board related properties except the
> > > >> s_power() callback to board code. The platforms that require this
> > > >> callback are not supported by this driver yet for CONFIG_OF=y.
> > > >> 
> > > >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > > >> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> > > >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> > > >> ---
> > > >> 
> > > >>   .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
> > > >>   drivers/media/video/s5k6aa.c                       |  129
> > > >>   ++++++++++++++------ 2 files changed, 146 insertions(+), 40
> > > >>   deletions(-)
> > > >>   create mode 100644
> > > >>   Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt>>
> > > >> 
> > > >> diff --git
> > > >> a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> > > >> b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt new
> > > >> file
> > > >> mode 100644
> > > >> index 0000000..6685a9c
> > > >> --- /dev/null
> > > >> +++ b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> > > >> @@ -0,0 +1,57 @@
> > > >> +Samsung S5K6AAFX camera sensor
> > > >> +------------------------------
> > > >> +
> > > >> +Required properties:
> > > >> +
> > > >> +- compatible : "samsung,s5k6aafx";
> > > >> +- reg : base address of the device on I2C bus;
> > > > 
> > > > You said you ended up putting your sensors outside of I2C busses, is
> > > > this
> > > > one of changes, that are present in your git-tree but not in this
> > > > series?
> > > 
> > > No, I must have been not clear enough on that. Our idea was to keep
> > > I2C slave device nodes as an I2C controller's child nodes, according
> > > to the current convention.
> > > The 'sensor' nodes (the 'camera''s children) would only contain a
> > > phandle to a respective I2C slave node.
> > > 
> > > This implies that we cannot access I2C bus in I2C client's device
> > > probe() callback. An actual H/W access could begin only from within and
> > > after invocation of v4l2_subdev .registered callback..
> > 
> > That's how I've envisioned the DT bindings for sensors as well, this
> > sounds good. The real challenge will be to get hold of the subdev to
> > register it without race conditions.
> 
> Hrm... That's how early pre-subdev versions of soc-camera used to work,
> that's where all the <device>_video_probe() functions come from. But then
> we switched to dynamic i2c device registration. Do we want to switch all
> drivers back now?... Couldn't we "temporarily" use references from subdevs
> to hosts until the clock API is available?

I don't think that requires a reference from subdevs to hosts in the DT. The 
subdev will need the host to be probed before a clock can be available so you 
won't be able to access the hardware in the probe() function in the generic 
case. You will need to wait until the registered() subdev operation is called, 
at which point the host can be accessed through the v4l2_device.

-- 
Regards,

Laurent Pinchart

