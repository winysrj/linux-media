Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37270 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935402AbdCJNIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:08:42 -0500
Date: Fri, 10 Mar 2017 13:07:33 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
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
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170310130733.GU21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 01:54:28PM +0100, Hans Verkuil wrote:
> But there was always meant to be a layer (libv4l plugin) that could be
> used to setup a 'default scenario' that existing applications could use,
> but that was never enforced, sadly.

However, there's other painful issues lurking in userspace, particularly
to do with the v4l libraries.

The idea that the v4l libraries should intercept the format negotiation
between the application and kernel is a particularly painful one - the
default gstreamer build detects the v4l libraries, and links against it.
That much is fine.

However, the problem comes when you're trying to use bayer formats. The
v4l libraries "helpfully" (or rather unhelpfully) intercept the format
negotiation, and decide that they'll invoke v4lconvert to convert the
bayer to RGB for you, whether you want them to do that or not.

v4lconvert may not be the most efficient way to convert, or even what
is desired (eg, you may want to receive the raw bayer image.)  However,
since the v4l libraries/v4lconvert gives you no option but to have its
conversion forced into the pipeline, other options (such as using the
gstreamer neon accelerated de-bayer plugin) isn't an option without
rebuilding gstreamer _without_ linking against the v4l libraries.

At that point, saying "this should be done in a libv4l plugin" becomes
a total nonsense, because if you need to avoid libv4l due to its
stupidities, you don't get the benefit of subdevs, and it yet again
_forces_ people down the route of custom applications.

So, I really don't agree with pushing this into a userspace library
plugin - at least not with the current state there.

_At least_ the debayering in the v4l libraries needs to become optional.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
