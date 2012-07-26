Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55387 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2GZWuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 18:50:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	sakari.ailus@iki.fi
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based instantiation
Date: Fri, 27 Jul 2012 00:50:13 +0200
Message-ID: <1451056.l0aSnQP8f4@avalon>
In-Reply-To: <5011AB03.2070900@gmail.com>
References: <4FBFE1EC.9060209@samsung.com> <1393020.I6XBuRyBXi@avalon> <5011AB03.2070900@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 26 July 2012 22:39:31 Sylwester Nawrocki wrote:
> On 07/26/2012 05:21 PM, Laurent Pinchart wrote:
> > On Friday 25 May 2012 21:52:48 Sylwester Nawrocki wrote:
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
> >>   drivers/media/video/s5k6aa.c                       |  129 +++++++++----
> >>   2 files changed, 146 insertions(+), 40 deletions(-)
> >>   create mode 100644
> >> 
> >> Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> >> 
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
> >> +- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
> >> +- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> >> +- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
> >> +- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to
> >> 1.9V) +		   or 2.8V (2.6V to 3.0);
> >> +- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
> >> +		 or 2.8V (2.5V to 3.1V);
> >> +
> >> +Optional properties:
> >> +
> >> +- clock-frequency : the IP's main (system bus) clock frequency in Hz,
> >> the default
> > 
> > Is that the input clock frequency ? Can't it vary ? Instead of accessing
> > the
> Yes, the description is incorrect in this patch, it should read:
> 
> +- clock-frequency : the sensor's master clock frequency in Hz;
> 
> and be a required property. As in this patch:
> https://github.com/snawrocki/linux/commit/e8a5f890dec0d7414b656bb1d1ac97d5e7
> abe563
> 
> It could vary (as this is a PLL input frequency), so probably a range would
> be a better alternative. Given that host device won't always be able to set
> this exact value...

A range sounds good, or perhaps a list of ranges. Sakari, what would you need 
for the SMIA++ driver ?

> > sensor clock frequency from the FIMC driver you should reference a clock
> > in the sensor DT node. That obviously requires generic clock support,
> > which might not be available for your platform yet (that's one of the
> > reasons the OMAP3 ISP driver doesn't support DT yet).
> 
> I agree it might be better, but waiting unknown number of kernel releases
> for the platforms to get converted to common clock API is not a good
> alternative either. I guess we could have some transitional solutions while
> other subsystems are getting adapted.

I agree, we need an interim solution.

> Yet we need to specify the clock frequency range per sensor, so
> 
> 1. either we specify it at a sensor node and host device driver references
>    it, or
> 2. it could be added to a sensor specific child node of a host device
>    mode, and then only the host would reference it, and sensor would
>    reference a clock in its DT node; I guess it's not a problem that
>    in most cases the camera host device is a clock provider.

The sensor will need to configure the clock rate, so a (list of) clock 
frequency range(s) will be needed in the sensor node anyway. As an interim 
solution the host can access that property. When the platform will be ported 
to the common clock API no modification to the DT will be needed.

-- 
Regards,

Laurent Pinchart

