Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53286 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752100AbdBUMQV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 07:16:21 -0500
Date: Tue, 21 Feb 2017 14:15:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
Message-ID: <20170221121542.GH16975@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <6892fb15-2d18-4898-c328-3acff9d6cc39@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6892fb15-2d18-4898-c328-3acff9d6cc39@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Mon, Feb 20, 2017 at 02:56:15PM -0800, Steve Longerbeam wrote:
> 
> 
> On 02/20/2017 02:04 PM, Sakari Ailus wrote:
> >Hi Steve,
> >
> >On Wed, Feb 15, 2017 at 06:19:31PM -0800, Steve Longerbeam wrote:
> >>From: Russell King <rmk+kernel@armlinux.org.uk>
> >>
> >>Setting and getting frame rates is part of the negotiation mechanism
> >>between subdevs.  The lack of support means that a frame rate at the
> >>sensor can't be negotiated through the subdev path.
> >
> >Just wondering --- what do you need this for?
> 
> 
> Hi Sakari,
> 
> i.MX does need the ability to negotiate the frame rates in the
> pipelines. The CSI has the ability to skip frames at the output,
> which is something Philipp added to the CSI subdev. That affects
> frame interval at the CSI output.
> 
> But as Russell pointed out, the lack of [gs]_frame_interval op
> causes media-ctl to fail:
> 
> media-ctl -v -d /dev/media1 --set-v4l2
> '"imx6-mipi-csi2":1[fmt:SGBRG8/512x512@1/30]'
> 
> Opening media device /dev/media1
> Enumerating entities
> Found 29 entities
> Enumerating pads and links
> Setting up format SGBRG8 512x512 on pad imx6-mipi-csi2/1
> Format set: SGBRG8 512x512
> Setting up frame interval 1/30 on entity imx6-mipi-csi2
> Unable to set frame interval: Inappropriate ioctl for device (-25)Unable to
> setup formats: Inappropriate ioctl for device (25)
> 
> 
> So i.MX needs to implement this op in every subdev in the
> pipeline, otherwise it's not possible to configure the
> pipeline with media-ctl.

The frame rate is only set on the sub-device which you explicitly set it.
I.e. setting the frame rate fails if it's not supported on a pad.

Philipp recently posted patches that add frame rate propagation to
media-ctl.

Frame rate is typically settable (and gettable) only on sensor sub-device's
source pad, which means it normally would not be propagated by the kernel
but with Philipp's patches, on the sink pad of the bus receiver. Receivers
don't have a way to control it nor they implement the IOCTLs, so that would
indeed result in an error.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
