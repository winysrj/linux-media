Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43324 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932941AbdBQMW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 07:22:57 -0500
Date: Fri, 17 Feb 2017 14:22:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
Message-ID: <20170217122213.GQ16975@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <20170216222006.GA21222@n2100.armlinux.org.uk>
 <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
 <1487331818.3107.46.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487331818.3107.46.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, Steve and Russell,

On Fri, Feb 17, 2017 at 12:43:38PM +0100, Philipp Zabel wrote:
> On Thu, 2017-02-16 at 14:27 -0800, Steve Longerbeam wrote:
> > 
> > On 02/16/2017 02:20 PM, Russell King - ARM Linux wrote:
> > > On Wed, Feb 15, 2017 at 06:19:02PM -0800, Steve Longerbeam wrote:
> > >> In version 4:
> > >
> > > With this version, I get:
> > >
> > > [28762.892053] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000000
> > > [28762.899409] ipu1_csi0: pipeline_set_stream failed with -110
> > >
> > 
> > Right, in the imx219, on exit from s_power(), the clock and data lanes
> > must be placed in the LP-11 state. This has been done in the ov5640 and
> > tc358743 subdevs.
> > 
> > If we want to bring in the patch that adds a .prepare_stream() op,
> > the csi-2 bus would need to be placed in LP-11 in that op instead.
> > 
> > Philipp, should I go ahead and add your .prepare_stream() patch?
> 
> I think with Russell's explanation of how the imx219 sensor operates,
> we'll have to do something before calling the sensor s_stream, but right
> now I'm still unsure what exactly.

Indeed there appears to be no other way to achieve the LP-11 state than
going through the streaming state for this particular sensor, apart from
starting streaming.

Is there a particular reason why you're waiting for the transmitter to
transfer to LP-11 state? That appears to be the last step which is done in
the csi2_s_stream() callback.

What the sensor does next is to start streaming, and the first thing it does
in that process is to switch to LP-11 state.

Have you tried what happens if you simply drop the LP-11 check? To me that
would seem the right thing to do.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
