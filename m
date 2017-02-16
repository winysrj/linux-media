Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47186 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933157AbdBPW6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 17:58:41 -0500
Date: Thu, 16 Feb 2017 22:57:42 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: p.zabel@pengutronix.de, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        mchehab@kernel.org, hverkuil@xs4all.nl, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
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
Subject: Re: [PATCH v4 00/36] i.MX Media Driver
Message-ID: <20170216225742.GB21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <20170216222006.GA21222@n2100.armlinux.org.uk>
 <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 16, 2017 at 02:27:41PM -0800, Steve Longerbeam wrote:
> 
> 
> On 02/16/2017 02:20 PM, Russell King - ARM Linux wrote:
> >On Wed, Feb 15, 2017 at 06:19:02PM -0800, Steve Longerbeam wrote:
> >>In version 4:
> >
> >With this version, I get:
> >
> >[28762.892053] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000000
> >[28762.899409] ipu1_csi0: pipeline_set_stream failed with -110
> >
> 
> Right, in the imx219, on exit from s_power(), the clock and data lanes
> must be placed in the LP-11 state. This has been done in the ov5640 and
> tc358743 subdevs.

The only way to do that is to enable streaming from the sensor, wait
an initialisation time, and then disable streaming, and wait for the
current line to finish.  There is _no_ other way to get the sensor to
place its clock and data lines into LP-11 state.

For that to happen, we need to program the sensor a bit more than we
currently do at power on (to a minimal resolution, and setting up the
PLLs), and introduce another 4ms on top of the 8ms or so that the
runtime resume function already takes.

Looking at the SMIA driver, things are worse, and I suspect that it also
will not work with the current setup - the SMIA spec shows that the CSI
clock and data lines are tristated while the sensor is not streaming,
which means they aren't held at a guaranteed LP-11 state, even if that
driver momentarily enabled streaming.  Hence, Freescale's (or is it
Synopsis') requirement may actually be difficult to satisfy.

However, I regard runtime PM broken with the current imx-capture setup.
At the moment, power is controlled at the sensor by whether the media
links are enabled.  So, if you have an enabled link coming off the
sensor, the sensor will be powered up, whether you're using it or not.

Given that the number of applications out there that know about the
media subdevs is really quite small, this combination makes having
runtime PM in sensor devices completely pointless - they can't sleep
as long as they have an enabled link, which could be persistent over
many days or weeks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
