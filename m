Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37302 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755025AbdCTRRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 13:17:25 -0400
Date: Mon, 20 Mar 2017 17:16:30 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        kernel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
Message-ID: <20170320171630.GR21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
 <20170319152233.GW21222@n2100.armlinux.org.uk>
 <327d67d9-68c1-7f74-0c0f-f6aee1c4b546@gmail.com>
 <1490010926.2917.59.camel@pengutronix.de>
 <20170320120855.GH21222@n2100.armlinux.org.uk>
 <1490018451.2917.86.camel@pengutronix.de>
 <20170320141705.GL21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320141705.GL21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 02:17:05PM +0000, Russell King - ARM Linux wrote:
> On Mon, Mar 20, 2017 at 03:00:51PM +0100, Philipp Zabel wrote:
> > On Mon, 2017-03-20 at 12:08 +0000, Russell King - ARM Linux wrote:
> > > The same document says:
> > > 
> > >   Scaling support is optional. When supported by a subdev, the crop
> > >   rectangle on the subdev's sink pad is scaled to the size configured
> > >   using the
> > >   :ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` IOCTL
> > >   using ``V4L2_SEL_TGT_COMPOSE`` selection target on the same pad. If the
> > >   subdev supports scaling but not composing, the top and left values are
> > >   not used and must always be set to zero.
> > 
> > Right, this sentence does imply that when scaling is supported, there
> > must be a sink compose rectangle, even when composing is not.
> > 
> > I have previously set up scaling like this:
> > 
> > media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080@1/60]"
> > media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/960x540@1/30]"
> > 
> > Does this mean, it should work like this instead?
> > 
> > media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080@1/60]"
> > media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY2X8/1920x1080@1/60,compose:(0,0)/960x540]"
> > media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/960x540@1/30]"
> > 
> > I suppose setting the source pad format should not be allowed to modify
> > the sink compose rectangle.
> 
> That is what I believe having read these documents several times, but
> we need v4l2 people to confirm.
> 
> Note that setting the format on 'ipu1_csi0':0 should already be done by
> the previous media-ctl command, so it should be possible to simplify
> that to:
> 
> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080@1/60]"
> media-ctl --set-v4l2 "'ipu1_csi0':0[compose:(0,0)/960x540]"
> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/960x540@1/30]"

There is a slightly puzzling bit in the documentation.  If we consider
the CSI, and the sink compose rectangle size has to always match the
the source output pad format size (since in hardware they are one of
the same), then:

  Inside subdevs, the order of image processing steps will always be from
  the sink pad towards the source pad. This is also reflected in the order
  in which the configuration must be performed by the user: the changes
  made will be propagated to any subsequent stages. If this behaviour is
  not desired, the user must set ``V4L2_SEL_FLAG_KEEP_CONFIG`` flag. This
                                                                     ^^^^
  flag causes no propagation of the changes are allowed in any
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  circumstances. This may also cause the accessed rectangle to be adjusted
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  by the driver, depending on the properties of the underlying hardware.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

presumably, this means if we get a request to change the source compose
rectangle with V4L2_SEL_FLAG_KEEP_CONFIG set, we need to force its size
to be the current output format size.  I don't think we can do anything
else - because the above makes it very clear that any following stages
shall not be updated.  The last sentence appears to give permission to
do that.

This also has implications when changing the sink crop - the sink crop
(eg) must not be smaller than the sink compose, as we don't support
scaling up in CSI.

It seems to me that V4L2_SEL_FLAG_KEEP_CONFIG in practice changes the
way validation of the request works.  So, rather than validating the
request against the upstream rectangle and propagating downstream, it
needs to be validated against both the upstream and downstream
rectangles instead.

It seems there's many subtleties to this...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
