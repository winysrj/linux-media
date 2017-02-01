Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36818 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdBAAYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 19:24:15 -0500
Date: Wed, 1 Feb 2017 00:23:32 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Message-ID: <20170201002331.GG27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170131004510.GQ27312@n2100.armlinux.org.uk>
 <951c1a08-c0f2-4333-b4bf-410de8dd863f@gmail.com>
 <20170131110027.GU27312@n2100.armlinux.org.uk>
 <3a673cba-bbf6-5611-5857-4605797bf049@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a673cba-bbf6-5611-5857-4605797bf049@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 03:43:22PM -0800, Steve Longerbeam wrote:
> 
> 
> On 01/31/2017 03:00 AM, Russell King - ARM Linux wrote:
> >Just like smiapp, the camera sensor block (which is the very far end
> >of the pipeline) is marked with MEDIA_ENT_F_CAM_SENSOR.  However, in
> >front of that is the binner, which just like smiapp gets a separate
> >entity.  It's this entity which is connected to the mipi-csi2 subdev.
> 
> wow, ok got it.
> 
> So the sensor pipeline and binner, and the OF graph connecting
> them, are described in the device tree I presume.

No - because the binner and sensor are on the same die, it's even
one single device, there's no real separation of the two devices.

The reason there's no real separation is because the binning is done
as part of the process of reading the array - sometimes before the
analog voltage is converted to its digital pixel value representation.

The separation comes because of the requirements of the v4l2 media
subdevs, which requires scalers to have a sink pad and a source pad.
(Please see the v4l2 documentation, I think I've already quoted this:

       ..  _MEDIA-ENT-F-PROC-VIDEO-SCALER:

       -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``

       -  Video scaler. An entity capable of video scaling must have
          at least one sink pad and one source pad, and scale the
          video frame(s) received on its sink pad(s) to a different
          resolution output on its source pad(s). The range of
          supported scaling ratios is entity-specific and can differ
          between the horizontal and vertical directions (in particular
          scaling can be supported in one direction only). Binning and
          skipping are considered as scaling.

(Oh yes, I see it was the mail to which you were replying to...)

So, in order to configure the scaling (which can be none, /2 and /4)
we have to expose two subdevs - one which is the scaler, and has a
source pad connected to the upstream (in this case CSI2 receiver)
and a sink pad immutably connected to the camera sensor.

Since the split is entirely down to the V4L2 implementation requirements,
it's not something that should be reflected in DT - we don't put
implementation details in DT.

It's just the same (as I've already said) as the SMIAPP camera driver,
the reason I'm pointing you towards that is because this is an already
mainlined camera driver which nicely illustrates how my driver is
structured from the v4l2 subdev API point of view.

> The OF graph AFAIK, has no information about which ports are sinks
> and which are sources, so of_parse_subdev() tries to determine that
> based on the compatible string of the device node. So ATM
> of_parse_subdev() assumes there is nothing but the imx6-mipi-csi2,
> video-multiplexer, and camera sensors upstream from the CSI ports
> in the OF graph.
> 
> I realize that's not a robust solution, and is the reason for the
> "no sensor attached" below.
> 
> Is there any way to determine from the OF graph the data-direction
> of a port (whether it is a sink or a source)? If so it will make
> of_parse_subdev() much more robust.

I'm not sure why you need to know the data direction.  I think the
issue here is how you're going about dealing with the subdevs.
Here's the subdev setup:

+---------camera--------+
| pixel array -> binner |---> csi2 --> ipu1csi0 mux --> csi0 --> smfc --> idmac
+-----------------------+

How the subdevs are supposed to work is that you start from the first
subdev in sequence (in this case the pixel array) and negotiate with
the driver through the TRY formats on its source pad, as well as
negotiating with the sink pad of the directly neighbouring subdev.

The neighbouring subdev propagates the configuration in a driver
specific manner from its source pad to the sink pad, giving a default
configuration at its source.

This process repeats throughout the chain all the way up to the bridge
device.

Now, where things go wrong is that you want to know what each type of
these subdevs are, and the reason you want that is so you can do this
(for example - I know similar stuff happens with the "sensor" stuff
further up the chain as well):

+---------camera--------+
| pixel array -> binner |---> csi2 --> ipu1csi0 mux --> csi0 --> smfc --> idmac
+-----------------------+                                |
              ^--I-want-your-bus-format-and-frame-rate---'

which goes against the negotiation mechanism of v4l2 subdevs.  This
is broken - it bypass the subdev negotiation that has been performed
on the intervening subdevs between the "sensor" and the csi0 subdevs,
so if there were a subdev in that chain that (eg) reduced the frame
rate by discarding the odd frames, you'd be working with the wrong
frame interval for your frame interval monitor at csi.

Note that the "MEDIA_ENT_F_PROC_VIDEO_SCALER" subdev type is documented
as not only supports scaling as in changing the size of the image, but
also in terms of skipping frames, which means a reduction in frame rate.

So, for your FIM, you need to know if there is any reduction in frame
rate through that pipeline, and looking for a "MEDIA_ENT_F_CAM_SENSOR"
subdev node isn't going to tell you that.  The frame rate really needs
to be carried through and I suspect you need to accept the frame rate
into each subdev so it can be passed along the chain by the application
configuring the pipeline.

The last bit from the above is the "I-want-your-bus-format" bit which
I haven't fully worked out how to eliminate - I understand the reason
you need that (so you can appropriately configure the CSI with the CSI2
data type code.)  The CSI2 data type code comes from the format
configured on the CSI sink pad, so the only information you're really
using there is "are we sinking data from a CSI2 interface."

You _could_ walk down the graph from the CSI looking for a subdev that
responds to g_mbus_config that reports CSI2, but I'm not sure that's
going to last - I've seen an email from Hans saying that he'd like
g_mbus_config to go away (to patch 13/24, for the vidsw_g_mbus_config()
function):

"I am not certain this op is needed at all. In the current kernel this
 op is onlyused by soc_camera, pxa_camera and omap3isp (somewhat dubious).
 Normally this information should come from the device tree and there
 should be no need for this op.

 My (tentative) long-term plan was to get rid of this op.

 If you don't need it, then I recommend it is removed."

So, if that goes away, the CSI subdev needs a completely different way
to get that information, and it shouldn't be coming from the camera
sensor subdev, but (imho) really from the CSI2 subdev.

This is probably something that needs to be discussed with media people
to work out how to replace the g_mbus_config call with something more
acceptable to resolve this issue.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
