Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32826 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751549Ab2HSKCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 06:02:42 -0400
Date: Sun, 19 Aug 2012 13:02:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree
 based instantiation
Message-ID: <20120819100237.GB721@valkosipuli.retiisi.org.uk>
References: <4FBFE1EC.9060209@samsung.com>
 <1393020.I6XBuRyBXi@avalon>
 <5011AB03.2070900@gmail.com>
 <1451056.l0aSnQP8f4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451056.l0aSnQP8f4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sylwester,

My apologies for the late answer.

On Fri, Jul 27, 2012 at 12:50:13AM +0200, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Thursday 26 July 2012 22:39:31 Sylwester Nawrocki wrote:
> > On 07/26/2012 05:21 PM, Laurent Pinchart wrote:
> > > On Friday 25 May 2012 21:52:48 Sylwester Nawrocki wrote:
> > >> The driver initializes all board related properties except the s_power()
> > >> callback to board code. The platforms that require this callback are not
> > >> supported by this driver yet for CONFIG_OF=y.
> > >> 
> > >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > >> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> > >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> > >> ---
> > >> 
> > >>   .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
> > >>   drivers/media/video/s5k6aa.c                       |  129 +++++++++----
> > >>   2 files changed, 146 insertions(+), 40 deletions(-)
> > >>   create mode 100644
> > >> 
> > >> Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> > >> 
> > >> diff --git
> > >> a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> > >> b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt new file
> > >> mode 100644
> > >> index 0000000..6685a9c
> > >> --- /dev/null
> > >> +++ b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> > >> @@ -0,0 +1,57 @@
> > >> +Samsung S5K6AAFX camera sensor
> > >> +------------------------------
> > >> +
> > >> +Required properties:
> > >> +
> > >> +- compatible : "samsung,s5k6aafx";
> > >> +- reg : base address of the device on I2C bus;
> > >> +- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
> > >> +- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> > >> +- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
> > >> +- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to
> > >> 1.9V) +		   or 2.8V (2.6V to 3.0);
> > >> +- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
> > >> +		 or 2.8V (2.5V to 3.1V);
> > >> +
> > >> +Optional properties:
> > >> +
> > >> +- clock-frequency : the IP's main (system bus) clock frequency in Hz,
> > >> the default
> > > 
> > > Is that the input clock frequency ? Can't it vary ? Instead of accessing
> > > the
> > Yes, the description is incorrect in this patch, it should read:
> > 
> > +- clock-frequency : the sensor's master clock frequency in Hz;
> > 
> > and be a required property. As in this patch:
> > https://github.com/snawrocki/linux/commit/e8a5f890dec0d7414b656bb1d1ac97d5e7
> > abe563
> > 
> > It could vary (as this is a PLL input frequency), so probably a range would
> > be a better alternative. Given that host device won't always be able to set
> > this exact value...
> 
> A range sounds good, or perhaps a list of ranges. Sakari, what would you need 
> for the SMIA++ driver ?

Typically the sensor's external clock is derived from another clock using a
divisor. This means there's usually quite limited selection of possible
clock frequencies since the sensors usually have a small range of possible
frequencies such as 6 -- 27 MHz or even less.

Also it's important to choose the frequency in such a way that it doesn't
interfere with other devices in the system. The frequency also must be
picked so that one can achieve the desired highest data transfer rate. The
sensors are also quite flexible in their internal clock tree configuration,
but in the situation where the desired data rate is close to sensor limits
there may be additional constraints. Still it's always possible to come up
with a best value for the board while other values are inferior.

For these reasons I see little point in providing anything else than just a
single value for the external clock frequency. This value is board-specific.

> > > sensor clock frequency from the FIMC driver you should reference a clock
> > > in the sensor DT node. That obviously requires generic clock support,
> > > which might not be available for your platform yet (that's one of the
> > > reasons the OMAP3 ISP driver doesn't support DT yet).
> > 
> > I agree it might be better, but waiting unknown number of kernel releases
> > for the platforms to get converted to common clock API is not a good
> > alternative either. I guess we could have some transitional solutions while
> > other subsystems are getting adapted.
> 
> I agree, we need an interim solution.

The SMIA++ driver allows the platform data to have either the clock name or
a function pointer to set the clock frequency. If the clock name is there
it'll be used instead. The function pointer can be removed once it's no
longer needed.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
