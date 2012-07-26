Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58792 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2GZPJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 11:09:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based instantiation
Date: Thu, 26 Jul 2012 17:09:43 +0200
Message-ID: <6250402.9RzN62tRPe@avalon>
In-Reply-To: <50067F69.6080501@gmail.com>
References: <4FBFE1EC.9060209@samsung.com> <Pine.LNX.4.64.1207161122390.12302@axis700.grange> <50067F69.6080501@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 18 July 2012 11:18:33 Sylwester Nawrocki wrote:
> On 07/16/2012 11:42 AM, Guennadi Liakhovetski wrote:
> > On Fri, 25 May 2012, Sylwester Nawrocki wrote:
> >> The driver initializes all board related properties except the s_power()
> >> callback to board code. The platforms that require this callback are not
> >> supported by this driver yet for CONFIG_OF=y.
> >> 
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >> 
> >>   .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
> >>   drivers/media/video/s5k6aa.c                       |  129
> >>   ++++++++++++++------ 2 files changed, 146 insertions(+), 40
> >>   deletions(-)
> >>   create mode 100644
> >>   Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt>> 
> >> diff --git
> >> a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> >> b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt new file
> >> mode 100644
> >> index 0000000..6685a9c
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> >> @@ -0,0 +1,57 @@
> >> +Samsung S5K6AAFX camera sensor
> >> +------------------------------
> >> +
> >> +Required properties:
> >> +
> >> +- compatible : "samsung,s5k6aafx";
> >> +- reg : base address of the device on I2C bus;
> > 
> > You said you ended up putting your sensors outside of I2C busses, is this
> > one of changes, that are present in your git-tree but not in this series?
> 
> No, I must have been not clear enough on that. Our idea was to keep
> I2C slave device nodes as an I2C controller's child nodes, according
> to the current convention.
> The 'sensor' nodes (the 'camera''s children) would only contain a phandle
> to a respective I2C slave node.
> 
> This implies that we cannot access I2C bus in I2C client's device probe()
> callback. An actual H/W access could begin only from within and after
> invocation of v4l2_subdev .registered callback..

That's how I've envisioned the DT bindings for sensors as well, this sounds 
good. The real challenge will be to get hold of the subdev to register it 
without race conditions.

> >> +- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
> > 
> > If this is a boolean property, it cannot be required? Otherwise, as
> > discussed in a different patch comment, this property might not be
> > required, and if it is, I would use the same definition for both the
> > camera interface and for sensors.
> 
> Yeah, that's an omission, a leftover from previous versions. It should have
> been 'video-bus-type', for this series.
> 
> Here is the updated binding documentation:
> 
> 8<----------------------------------------------------------------------
> Required properties:
> 
> - compatible : "samsung,s5k6aafx";
> - reg : base address of the device on I2C bus;
> - vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> - vdda-supply : analog circuits voltage supply 2.8V (2.6V to 3.0V);
> - vdd_reg-supply : regulator input voltage supply 1.8V (1.7V to 1.9V)
>                    or 2.8V (2.6V to 3.0);
> - vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
>                  or 2.8V (2.5V to 3.1V);
> - video-bus-type : sensor video output bus type, must be one of:
>                    "itu-601", "mipi-csi2";
> - clock-frequency : the sensor's master clock frequency in Hz;
> 
> Optional properties:
> 
> - data-lanes : number of physical MIPI-CSI2 data lanes used
>                (default is 2 when this property is not specified);
> - gpios : specifies gpios connected to the sensor's reset
>           reset (RSTN) and standby (STBYN) pins, the order
>           of gpios is: <RSTN, STBYN>; If any of these gpios
>           is not used, its specifier shall be 0;
> - samsung,s5k6aa-gpio-lvls : this property (bits [1:0]) specifies an active
>                              state of the S5K6AAFX reset and stand-by
> signals; the meaning of bits is: bit[1:0] = [RST, STBY], e.g. bit[1] = 0
> indicates the GPIO driving the S5K6AAFX's standby pin should be set to 1 to
> bring the sensor out from stand-by to normal operation state.
> - samsung,s5k6aa-hflip : sets the default horizontal image flipping;
> - samsung,s5k6aa-vflip : sets the default vertical image flipping;
> 8<----------------------------------------------------------------------
> 
> >> +- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> >> +- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
> >> +- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to
> >> 1.9V) +		   or 2.8V (2.6V to 3.0);
> > 
> > I think, underscores in property names are generally frowned upon.
> 
> Indeed, I felt something might be wrong here;) It's in this form because
> I just copied regulator supply names from the existing driver. And I
> didn't want to change them, to avoid updating them in all board files where
> they're used. Thanks for pointing it out, I'll fix that in next iteration.
> 
> >> +- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
> >> +		 or 2.8V (2.5V to 3.1V);
> >> +
> >> +Optional properties:
> >> +
> >> +- clock-frequency : the IP's main (system bus) clock frequency in Hz,
> >> the default +		    value when this property is not specified is 24 MHz;
> >> +- data-lanes : number of physical lanes used (default 2 if not
> >> specified);
> > 
> > bus-width?
> 
> OK.
> 
> >> +- gpio-stby : specifies the S5K6AA_STBY GPIO
> >> +- gpio-rst : specifies the S5K6AA_RST GPIO
> >> 
> >  From Documentation/devicetree/bindings/gpio/gpio.txt:
> > <quote>
> > GPIO properties should be named "[<name>-]gpios".
> > </quote>
> 
> Thanks, these have been already removed in the next version, as can be seen
> above.
> 
> >> +- samsung,s5k6aa-inv-stby : set inverted S5K6AA_STBY GPIO level;
> >> +- samsung,s5k6aa-inv-rst : set inverted S5K6AA_RST GPIO level;
> > 
> > Isn't this provided by GPIO flags as described in include/linux/of_gpio.h
> > by using the OF_GPIO_ACTIVE_LOW bit?
> 
> Hmm, I wasn't aware of that. I'll see how this flag can be used.
> 
> >> +- samsung,s5k6aa-hflip : set the default horizontal image flipping;
> >> +- samsung,s5k6aa-vflip : set the default vertical image flipping;
> > 
> > This is a board property, specifying how the sensor is wired and mounted
> > on the casing, right? IIRC, libv4l has a database of these for USB
> 
> Yeah, that's exactly it. It could be used for compensating for an
> "upside down" mounting.
> 
> > cameras. So, maybe it belongs to the user-space for embedded systems too?
> 
> Using library for these things is one of the solutions, which works well
> for USB webcams. However, I wouldn't like enforcing that. Those properties
> still describe hardware IHMO, then why not add them into DT blob that is
> usually distributed with each board ? There wouldn't be a need to rely on
> any user-space database lookup, before the hardware can actually be used.

I agree. For USB devices on x86 we don't have many other options, but with DT 
we can describe the hardware properly.

> > Or at least this shouldn't be Samsung-specific?
> 
> Yes, good point. If we agree we can keep them, perhaps we could standardize
> those as boolean properties: horizontal-flip; and vertical-flip; ?

-- 
Regards,

Laurent Pinchart

