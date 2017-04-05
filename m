Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47178 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753521AbdDEIWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 04:22:43 -0400
Date: Wed, 5 Apr 2017 09:21:34 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
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
Subject: Re: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities
 output video on pad 1
Message-ID: <20170405082134.GF7909@n2100.armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
 <1490894749.2404.33.camel@pengutronix.de>
 <20170404231053.GE7909@n2100.armlinux.org.uk>
 <19f0ce92-cad6-8950-8018-e3224e2bf266@gmail.com>
 <7235285c-f39a-64bc-195a-11cfde9e67c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7235285c-f39a-64bc-195a-11cfde9e67c5@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 04, 2017 at 05:44:05PM -0700, Steve Longerbeam wrote:
> 
> 
> On 04/04/2017 05:40 PM, Steve Longerbeam wrote:
> >
> >
> >On 04/04/2017 04:10 PM, Russell King - ARM Linux wrote:
> >>On Thu, Mar 30, 2017 at 07:25:49PM +0200, Philipp Zabel wrote:
> >>>The TVP5150 DT bindings specify a single output port (port 0) that
> >>>corresponds to the video output pad (pad 1, DEMOD_PAD_VID_OUT).
> >>>
> >>>Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> >>>---
> >>>I'm trying to get this to work with a TVP5150 analog TV decoder, and the
> >>>first problem is that this device doesn't have pad 0 as its single
> >>>output pad. Instead, as a MEDIA_ENT_F_ATV_DECODER entity, it has for
> >>>pads (input, video out, vbi out, audio out), and video out is pad 1,
> >>>whereas the device tree only defines a single port (0).
> >>
> >>Looking at the patch, it's highlighted another review point with
> >>Steve's driver.
> >>
> >>>diff --git a/drivers/staging/media/imx/imx-media-dev.c
> >>>b/drivers/staging/media/imx/imx-media-dev.c
> >>>index 17e2386a3ca3a..c52d6ca797965 100644
> >>>--- a/drivers/staging/media/imx/imx-media-dev.c
> >>>+++ b/drivers/staging/media/imx/imx-media-dev.c
> >>>@@ -267,6 +267,15 @@ static int imx_media_create_link(struct
> >>>imx_media_dev *imxmd,
> >>>     source_pad = link->local_pad;
> >>>     sink_pad = link->remote_pad;
> >>>
> >>>+    /*
> >>>+     * If the source subdev is an analog video decoder with a single
> >>>source
> >>>+     * port, assume that this port 0 corresponds to the
> >>>DEMOD_PAD_VID_OUT
> >>>+     * entity pad.
> >>>+     */
> >>>+    if (source->entity.function == MEDIA_ENT_F_ATV_DECODER &&
> >>>+        local_sd->num_sink_pads == 0 && local_sd->num_src_pads == 1)
> >>>+        source_pad = DEMOD_PAD_VID_OUT;
> >>>+
> >>>     v4l2_info(&imxmd->v4l2_dev, "%s: %s:%d -> %s:%d\n", __func__,
> >>>           source->name, source_pad, sink->name, sink_pad);
> >>
> >>What is "local" and what is "remote" here?  It seems that, in the case of
> >>a link being created with the sensor(etc), it's all back to front.
> >>
> >>Eg, I see locally:
> >>
> >>imx-media: imx_media_create_link: imx219 0-0010:0 -> imx6-mipi-csi2:0
> >>
> >>So here, "source" is the imx219 (the sensor), and sink is
> >>"imx6-mipi-csi2"
> >>(part of the iMX6 capture.)  However, this makes "local_sd" the subdev of
> >>the sensor, and "remote_sd" the subdev of the CSI2 interface - which is
> >>totally back to front - this code is part of the iMX6 capture system,
> >>so "local" implies that it should be part of that, and the "remote" thing
> >>would be the sensor.
> >>
> >>Hence, this seems completely confused.  I'd suggest that:
> >>
> >>(a) the "pad->pad.flags & MEDIA_PAD_FL_SINK" test in
> >>imx_media_create_link()
> >>    is moved into imx_media_create_links(), and placed here instead:
> >>
> >>        for (j = 0; j < num_pads; j++) {
> >>            pad = &local_sd->pad[j];
> >>
> >>            if (pad->pad.flags & MEDIA_PAD_FL_SINK)
> >>                continue;
> >>
> >>            ...
> >>        }
> >>
> >>    as the pad isn't going to spontaneously change this flag while we
> >>    consider each individual link.
> >
> >
> >Sure, I can do that. It would avoid iterating unnecessarily through the
> >pad's links if the pad is a sink.
> >
> >
> >> However, maybe the test should be:
> >>
> >>            if (!(pad->pad.flags & MEDIA_PAD_FL_SOURCE))
> >>
> >>    ?
> >>
> >
> >maybe that is more intuitive.
> >
> >
> >>(b) the terms "local" and "remote" in imx_media_create_link() are
> >>    replaced with "source" and "sink" respectively, since this will
> >>    now be called with a guaranteed source pad.
> >
> >Agreed. I'll change the arg and local var names.
> >
> >>
> >>As for Philipp's solution, I'm not sure what the correct solution for
> >>something like this is.  It depends how you view "hardware interface"
> >>as defined by video-interfaces.txt, and whether the pads on the TVP5150
> >>represent the hardware interfaces.  If we take the view that the pads
> >>do represent hardware interfaces, then using the reg= property on the
> >>port node will solve this problem.
> >
> >And the missing port nodes would have to actually be defined first.
> >According to Philipp they aren't, only a single output port 0.
> >
> >
> >>
> >>If not, it would mean that we would have to have the iMX capture code
> >>scan the pads on the source device, looking for outputs - but that
> >>runs into a problem - if the source device has multiple outputs, does
> >>the reg= property specify the output pad index or the pad number,
> >
> >And how do we even know the data direction of a DT port. Is it an input,
> >an output, bidirectional? The OF graph parsing in imx-media-of.c can't
> >determine a port's direction if it encounters a device it doesn't
> >recognize that has multiple ports. For now that is not really a problem
> >because upstream from the video mux and csi-2 receiver it's expected
> >there will only be original sources of video with only one source port.
> >But it can become a limitation later. For example a device that has
> >multiple output bus interfaces, which would require multiple output
> >ports.
> >
> 
> Actually what was I thinking, the TVP5150 is already an example of
> such a device.
> 
> All of this could be solved if there was some direction information
> in port nodes.

I disagree.

Philipp identified that the TVP5150 has four pads:

* Input pad
* Video output pad
* VBI output pad
* Audio output pad

So, it has one input and three outputs.  How does marking the direction
in the port node (which would indicate that there was a data flow out of
TVP5150 into the iMX6 capture) help identify which of those pads should
be used?

It would eliminate the input pad, but you still have three output pads
to choose from.

So no, your idea can't work.

As I already stated, I believe that this case is already covered by
video-interfaces.txt:

  If more than
  one port is present in a device node or there is more than one endpoint at a
  port, or port node needs to be associated with a selected hardware interface,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  a common scheme using '#address-cells', '#size-cells' and 'reg' properties is
  used.

So, according to that, you do not need to have more than one port node
to use the reg property - it's _either_ more than one port _or_ to
select the hardware interface.

It all hinges on whether you consider the video output, VBI output or
audio output to be separate hardware interfaces that the singular
specified "port" node needs to select between.

There's another reason why the TVP5150 binding looks wrong and broken,
however.  How does the audio output get routed to other parts of the
system if you're using the video output, and how is that relationship
defined?  It's a v4l2 subdev pad, so it would need to be part of the
v4l2 subdev graph.  It sounds to me like the binding was created with
a narrow focused "this is the board in front of me, it only has video
wired up, I'm not going to consider other use cases" blinkered view.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
