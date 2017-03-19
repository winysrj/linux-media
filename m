Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46462 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdCSPX1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 11:23:27 -0400
Date: Sun, 19 Mar 2017 15:22:33 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
Message-ID: <20170319152233.GW21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 09, 2017 at 08:53:18PM -0800, Steve Longerbeam wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> The csi_try_crop call in set_fmt should compare the cropping rectangle
> to the currently set input format, not to the previous input format.

Are we really sure that the cropping support is implemented correctly?

I came across this while looking at what we're doing with the
V4L2_SEL_FLAG_KEEP_CONFIG flag.

Documentation/media/uapi/v4l/dev-subdev.rst defines the behaviour of
the user API, and "Order of configuration and format propagation" says:

  The coordinates to a step always refer to the actual size of the
  previous step. The exception to this rule is the source compose
  rectangle, which refers to the sink compose bounds rectangle --- if it
  is supported by the hardware.
  
  1. Sink pad format. The user configures the sink pad format. This format
     defines the parameters of the image the entity receives through the
     pad for further processing.
  
  2. Sink pad actual crop selection. The sink pad crop defines the crop
     performed to the sink pad format.
  
  3. Sink pad actual compose selection. The size of the sink pad compose
     rectangle defines the scaling ratio compared to the size of the sink
     pad crop rectangle. The location of the compose rectangle specifies
     the location of the actual sink compose rectangle in the sink compose
     bounds rectangle.
  
  4. Source pad actual crop selection. Crop on the source pad defines crop
     performed to the image in the sink compose bounds rectangle.
  
  5. Source pad format. The source pad format defines the output pixel
     format of the subdev, as well as the other parameters with the
     exception of the image width and height. Width and height are defined
     by the size of the source pad actual crop selection.
  
  Accessing any of the above rectangles not supported by the subdev will
  return ``EINVAL``. Any rectangle referring to a previous unsupported
  rectangle coordinates will instead refer to the previous supported
  rectangle. For example, if sink crop is not supported, the compose
  selection will refer to the sink pad format dimensions instead.

Note step 3 above: scaling is defined by the ratio of the _sink_ crop
rectangle to the _sink_ compose rectangle.

So, lets say that the camera produces a 1280x720 image, and the sink
pad format is configured with 1280x720.  That's step 1.

The sink crop operates within that rectangle, cropping it to an area.
Let's say we're only interested in its centre, so we'd chose 640x360
with the top-left as 320,180.  This is step 2.

Then, if we want to down-scale by a factor of two, we'd set the sink
compose selection to 320x180.

This seems to be at odds with how the scaling is done in CSI at
present: the selection implementations all reject attempts to
configure the sink pad, instead only supporting crop rectangles on
the source, and we use the source crop rectangle to define the
down-scaling.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
