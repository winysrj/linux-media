Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36548 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933240AbdC3Q2X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 12:28:23 -0400
Date: Thu, 30 Mar 2017 17:27:30 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v6 00/39] i.MX Media Driver
Message-ID: <20170330162730.GH7909@n2100.armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <20170330110249.GF7909@n2100.armlinux.org.uk>
 <d715bcdf-b2df-8080-6ab4-854aeace31a8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d715bcdf-b2df-8080-6ab4-854aeace31a8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 30, 2017 at 09:12:29AM -0700, Steve Longerbeam wrote:
> 
> 
> On 03/30/2017 04:02 AM, Russell King - ARM Linux wrote:
> >This fails at step 1.  The removal of the frame interval support now
> >means my setup script fails when trying to set the frame interval on
> >the camera:
> >
> >Enumerating pads and links
> >Setting up format SRGGB8_1X8 816x616 on pad imx219 0-0010/0
> >Format set: SRGGB8_1X8 816x616
> >Setting up frame interval 1/25 on pad imx219 0-0010/0
> >Frame interval set: 1/25
> >Setting up format SRGGB8_1X8 816x616 on pad imx6-mipi-csi2/0
> >Format set: SRGGB8_1X8 816x616
> >Setting up frame interval 1/25 on pad imx6-mipi-csi2/0
> >Unable to set frame interval: Inappropriate ioctl for device (-25)Unable to setup formats: Inappropriate ioctl for device (25)
> >
> >This is because media-ctl tries to propagate it from the imx219 source
> >pad to the csi2 sink pad, and the csi2 now fails that ioctl.
> 
> I assume you're using Philipp's frame interval patches to media-ctl.
> Can you make the frame interval propagation optional in those patches?
> I.e. don't error-out with a failure code if the ioctl returns ENOTTY.

Damn, you're right.  There's way too much stuff to try and keep track
of with this stuff.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
