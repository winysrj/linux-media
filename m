Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38669 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933247AbdBQLW0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 06:22:26 -0500
Message-ID: <1487330512.3107.36.camel@pengutronix.de>
Subject: Re: [PATCH v4 00/36] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 17 Feb 2017 12:21:52 +0100
In-Reply-To: <20170217105624.GC21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <20170216222006.GA21222@n2100.armlinux.org.uk>
         <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
         <20170216225742.GB21222@n2100.armlinux.org.uk>
         <1487327951.3107.19.camel@pengutronix.de>
         <20170217105624.GC21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-02-17 at 10:56 +0000, Russell King - ARM Linux wrote:
> On Fri, Feb 17, 2017 at 11:39:11AM +0100, Philipp Zabel wrote:
> > On Thu, 2017-02-16 at 22:57 +0000, Russell King - ARM Linux wrote:
> > > On Thu, Feb 16, 2017 at 02:27:41PM -0800, Steve Longerbeam wrote:
> > > > 
> > > > 
> > > > On 02/16/2017 02:20 PM, Russell King - ARM Linux wrote:
> > > > >On Wed, Feb 15, 2017 at 06:19:02PM -0800, Steve Longerbeam wrote:
> > > > >>In version 4:
> > > > >
> > > > >With this version, I get:
> > > > >
> > > > >[28762.892053] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000000
> > > > >[28762.899409] ipu1_csi0: pipeline_set_stream failed with -110
> > > > >
> > > > 
> > > > Right, in the imx219, on exit from s_power(), the clock and data lanes
> > > > must be placed in the LP-11 state. This has been done in the ov5640 and
> > > > tc358743 subdevs.
> > > 
> > > The only way to do that is to enable streaming from the sensor, wait
> > > an initialisation time, and then disable streaming, and wait for the
> > > current line to finish.  There is _no_ other way to get the sensor to
> > > place its clock and data lines into LP-11 state.
> > 
> > I thought going through LP-11 is part of the D-PHY transmitter
> > initialization, during the LP->HS wakeup sequence. But then I have no
> > access to MIPI specs.
> 
> The D-PHY transmitter initialisation *only* happens as part of the
> wake-up from standby to streaming mode.  That is because Sony expect
> that you program the sensor, and then when you switch it to streaming
> mode, it computes the D-PHY parameters from the PLL, input clock rate
> (you have to tell it the clock rate in 1/256 MHz units), number of
> lanes, and other parameters.
> 
> It is possible to program the D-PHY parameters manually, but that
> doesn't change the above sequence in any way (it just avoids the
> chip computing the values, it doesn't result in any change of
> behaviour on the bus.)
>
> The IMX219 specifications are clear: the clock and data lines are
> held low (LP-00 state) after releasing the hardware enable signal.
> There's a period of chip initialisation, and then you can access the
> I2C bus and configure it.  There's a further period of initialisation
> where charge pumps are getting to their operating state.  Then, you
> set the streaming bit, and a load more initialisation happens before
> the CSI bus enters LP-11 state and the first frame pops out.  When
> entering standby, the last frame is completed, and then the CSI bus
> enters LP-11 state.

How about firing off a thread in imx6-mipi-csi2 prepare_stream that
spins on the LP-11 check and then continues with the receiver D-PHY
initialization once the condition is met? I think we should have at
least 100 us to do this, but maybe the IMX219 can be programmed to stay
in LP-11 for a longer time.

> SMIA are slightly different - mostly following what I've said above,
> but the clock and data lines are tristated after releasing the
> xshutdown signal, and they remain tristated until the clock line
> starts toggling before the first frame appears.  There appears to
> be no point that the clock line enters LP-11 state before it starts
> toggling.  When entering standby, the last frame is completed, and
> the CSI bus enters tristate mode (so floating.)  There is no way to
> get these sensors into LP-11 state.

I have no idea what to do about those.

regards
Philipp
