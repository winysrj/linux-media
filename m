Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47407 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751646AbdBQIgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 03:36:17 -0500
Message-ID: <1487320476.3107.5.camel@pengutronix.de>
Subject: Re: [PATCH v4 18/36] media: Add i.MX media core driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
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
Date: Fri, 17 Feb 2017 09:34:36 +0100
In-Reply-To: <c22dfd68-a41c-08d2-4b8d-c7ee1884ea31@gmail.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-19-git-send-email-steve_longerbeam@mentor.com>
         <1487250123.2377.53.camel@pengutronix.de>
         <c22dfd68-a41c-08d2-4b8d-c7ee1884ea31@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-02-16 at 17:33 -0800, Steve Longerbeam wrote:
> 
> On 02/16/2017 05:02 AM, Philipp Zabel wrote:
> > On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> <snip>
> >> +
> >> +- Clean up and move the ov5642 subdev driver to drivers/media/i2c, and
> >> +  create the binding docs for it.
> >
> > This is done already, right?
> 
> 
> I cleaned up ov5640 and moved it to drivers/media/i2c with binding docs,
> but not the ov5642 yet.

Ok, thanks.

> >> +- The Frame Interval Monitor could be exported to v4l2-core for
> >> +  general use.
> >> +
> >> +- The subdev that is the original source of video data (referred to as
> >> +  the "sensor" in the code), is called from various subdevs in the
> >> +  pipeline in order to set/query the video standard ({g|s|enum}_std)
> >> +  and to get/set the original frame interval from the capture interface
> >> +  ([gs]_parm). Instead, the entities that need this info should call its
> >> +  direct neighbor, and the neighbor should propagate the call to its
> >> +  neighbor in turn if necessary.
> >
> > Especially the [gs]_parm fix is necessary to present userspace with the
> > correct frame interval in case of frame skipping in the CSI.
> 
> 
> Right, understood. I've added this to list of fixes for version 5.
> 
> What a pain though! It means propagating every call to g_frame_interval
> upstream until a subdev "that cares" returns ret == 0 or
> ret != -ENOIOCTLCMD. And that goes for any other chained subdev call
> as well.

Not at all. Since the frame interval is a property of the pad, that had
to be propagated downstream by media-ctl along with media bus format,
frame size, and colorimetry earlier.

regards
Philipp
