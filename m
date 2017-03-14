Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38997 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750820AbdCNKnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 06:43:53 -0400
Message-ID: <1489488187.8406.3.camel@pengutronix.de>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
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
Date: Tue, 14 Mar 2017 11:43:07 +0100
In-Reply-To: <4ed15eae-b6c6-55f7-1c6c-9ea84466ed71@xs4all.nl>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
         <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
         <20170221001332.GS21222@n2100.armlinux.org.uk>
         <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
         <1487667023.2331.8.camel@pengutronix.de>
         <20170313131647.GB10701@valkosipuli.retiisi.org.uk>
         <20170313132701.GJ21222@n2100.armlinux.org.uk>
         <1489413301.2288.53.camel@pengutronix.de>
         <27397114-7d77-2353-c526-bddd5f5297d9@gmail.com>
         <20170313210349.GD10701@valkosipuli.retiisi.org.uk>
         <4ed15eae-b6c6-55f7-1c6c-9ea84466ed71@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-14 at 08:34 +0100, Hans Verkuil wrote:
> On 03/13/2017 10:03 PM, Sakari Ailus wrote:
> > Hi Steve,
> > 
> > On Mon, Mar 13, 2017 at 11:06:22AM -0700, Steve Longerbeam wrote:
> >>
> >>
> >> On 03/13/2017 06:55 AM, Philipp Zabel wrote:
> >>> On Mon, 2017-03-13 at 13:27 +0000, Russell King - ARM Linux wrote:
> >>>> On Mon, Mar 13, 2017 at 03:16:48PM +0200, Sakari Ailus wrote:
> >>>>> The vast majority of existing drivers do not implement them nor the user
> >>>>> space expects having to set them. Making that mandatory would break existing
> >>>>> user space.
> >>>>>
> >>>>> In addition, that does not belong to link validation either: link validation
> >>>>> should only include static properties of the link that are required for
> >>>>> correct hardware operation. Frame rate is not such property: hardware that
> >>>>> supports the MC interface generally does not recognise such concept (with
> >>>>> the exception of some sensors). Additionally, it is dynamic: the frame rate
> >>>>> can change during streaming, making its validation at streamon time useless.
> >>>>
> >>>> So how do we configure the CSI, which can do frame skipping?
> >>>>
> >>>> With what you're proposing, it means it's possible to configure the
> >>>> camera sensor source pad to do 50fps.  Configure the CSI sink pad to
> >>>> an arbitary value, such as 30fps, and configure the CSI source pad to
> >>>> 15fps.
> >>>>
> >>>> What you actually get out of the CSI is 25fps, which bears very little
> >>>> with the actual values used on the CSI source pad.
> >>>>
> >>>> You could say "CSI should ask the camera sensor" - well, that's fine
> >>>> if it's immediately downstream, but otherwise we'd need to go walking
> >>>> down the graph to find something that resembles its source - there may
> >>>> be mux and CSI2 interface subdev blocks in that path.  Or we just accept
> >>>> that frame rates are completely arbitary and bear no useful meaning what
> >>>> so ever.
> >>>
> >>> Which would include the frame interval returned by VIDIOC_G_PARM on the
> >>> connected video device, as that gets its information from the CSI output
> >>> pad's frame interval.
> >>>
> >>
> >> I'm kinda in the middle on this topic. I agree with Sakari that
> >> frame rate can fluctuate, but that should only be temporary. If
> >> the frame rate permanently shifts from what a subdev reports via
> >> g_frame_interval, then that is a system problem. So I agree with
> >> Phillip and Russell that a link validation of frame interval still
> >> makes sense.
> >>
> >> But I also have to agree with Sakari that a subdev that has no
> >> control over frame rate has no business implementing those ops.
> >>
> >> And then I agree with Russell that for subdevs that do have control
> >> over frame rate, they would have to walk the graph to find the frame
> >> rate source.
> >>
> >> So we're stuck in a broken situation: either the subdevs have to walk
> >> the graph to find the source of frame rate, or s_frame_interval
> >> would have to be mandatory and validated between pads, same as set_fmt.
> > 
> > It's not broken; what we are missing though is documentation on how to
> > control devices that can change the frame rate i.e. presumably drop frames
> > occasionally.
> > 
> > If you're doing something that hasn't been done before, it may be that new
> > documentation needs to be written to accomodate that use case. As we have an
> > existing interface (VIDIOC_SUBDEV_[GS]_FRAME_INTERVAL) it does make sense
> > to use that. What is not possible, though, is to mandate its use in link
> > validation everywhere.
> > 
> > If you had a hardware limitation that would require that the frame rate is
> > constant, then we'd need to handle that in link validation for that
> > particular piece of hardware. But there really is no case for doing that for
> > everything else.
> > 
> 
> General note: I would strongly recommend that g/s_parm support is removed in
> v4l2_subdev in favor of g/s_frame_interval.
> 
> g/s_parm is an abomination...

Agreed. Just in this specific case I was talking about G_PARM on
the /dev/video node, not the v4l2_subdev nodes. This is currently used
by non-subdev-aware userspace to obtain the framerate from the video
capture device.

> There seem to be only a few i2c drivers that use g/s_parm, so this shouldn't
> be a lot of work.
> 
> Having two APIs for the same thing is always very bad.
> 
> Regards,
> 
> 	Hans
> 

regards
Philipp
