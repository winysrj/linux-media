Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40466 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753659AbdA3Par (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 10:30:47 -0500
Date: Mon, 30 Jan 2017 15:28:22 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
Message-ID: <20170130152822.GB27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <1484320822.31475.96.camel@pengutronix.de>
 <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
 <1484574468.8415.136.camel@pengutronix.de>
 <e38feca9-ed6f-8288-e006-768d6ba2fe5a@gmail.com>
 <1485170006.2874.63.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485170006.2874.63.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 23, 2017 at 12:13:26PM +0100, Philipp Zabel wrote:
> Hi Steve,
> 
> On Sun, 2017-01-22 at 18:31 -0800, Steve Longerbeam wrote:
> > Second, ignoring the above locking issue for a moment, 
> > v4l2_pipeline_pm_use()
> > will call s_power on the sensor _first_, then the mipi csi-2 s_power, 
> > when executing
> > media-ctl -l '"ov5640 1-003c":0 -> "imx6-mipi-csi2":0[1]'. Which is the 
> > wrong order.
> > In my version which enforces the correct power on order, the mipi csi-2 
> > s_power
> > is called first in that link setup, followed by the sensor.
> 
> I don't understand why you want to power up subdevs as soon as the links
> are established. Shouldn't that rather be done for all subdevices in the
> pipeline when the corresponding capture device is opened?
> It seems to me that powering up the pipeline should be the last step
> before userspace actually starts the capture.

I agree with Philipp here - configuration of the software pipeline
shouldn't result in hardware being forced to be powered up.  That's
more of a decision for the individual sub-driver than for core.

Executing media-ctl to enable a link between two sub-device endpoints
should really be a matter of setting the software state, and when the
video device is opened for streaming, surely that's when the hardware
in the chain between the source and the capture device should be
powered up and programmed.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
