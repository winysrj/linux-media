Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58468 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753168AbdBCOky (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 09:40:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarit.de,
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
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Date: Fri, 03 Feb 2017 16:41:14 +0200
Message-ID: <2201157.ylZrBapgio@avalon>
In-Reply-To: <8e577a3f-8d44-9dde-9507-36c3769228b6@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <1485941457.3353.13.camel@pengutronix.de> <8e577a3f-8d44-9dde-9507-36c3769228b6@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday 01 Feb 2017 16:19:27 Steve Longerbeam wrote:
> On 02/01/2017 01:30 AM, Philipp Zabel wrote:
> > On Tue, 2017-01-31 at 17:26 -0800, Steve Longerbeam wrote:
> > [...]
> > 
> >>> # Set pad formats
> >>> media-ctl --set-v4l2 "'tc358743 1-000f':0[fmt:UYVY/1920x1080]"
> >>> media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY2X8/1920x1080]"
> >>> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080]"
> >>> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/1920x1080]"
> >>> 
> >>> v4l2-ctl -d /dev/video4 -V
> >>> # This still is configured to 640x480, which is inconsistent with
> >>> # the 'ipu1_csi0':2 pad format. The pad set_fmt above should
> >>> # have set this, too.
> >> 
> >> Because you've only configured the source pads,
> >> and not the sink pads. The ipu_csi source format is
> >> dependent on the sink format - output crop window is
> >> limited by max input sensor frame, and since sink pad is
> >> still at 640x480, output is reduced to that.
> > 
> > No, it is set (see below). What happens is that capture_g_fmt_vid_cap
> > just returns the capture devices' priv->vdev.fmt, even if it is
> > incompatible with the connected csi subdevice's output pad format.
> > 
> > priv->vdev.fmt was never changed from the default set in
> > imx_media_capture_device_register, because capture_s/try_fmt_vid_cap
> > were not called yet.
> 
> Ah, yep, this is a bug. Need to modify the capture device's
> width/height at .set_fmt() in the subdev's device-node source
> pad (csi and prpenc/vf).
> 
> >> Maybe I'm missing something, is it expected behavior that
> >> a source format should be automatically propagated to
> >> the sink?
> > 
> > media-ctl propagates the output pad format to all remote subdevices'
> > input pads for all enabled links:
> > 
> > https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl/libv4l2subdev.c
> > #n693
>
> Ah cool, I wasn't aware media-ctl did this, but it makes sense and
> makes it easier on the user.

To be precise, userspace is responsible for propagating formats *between* 
subdevs (source to sink, over a link) and drivers for propagating formats *in* 
subdevs (sink to source, inside the subdev).

> >>> v4l2-ctl --list-formats -d /dev/video4
> >>> # This lists all the RGB formats, which it shouldn't. There is
> >>> # no CSC in this pipeline, so we should be limited to YUV formats
> >>> # only.
> >> 
> >> right, need to fix that. Probably by poking the attached
> >> source subdev (csi or prpenc/vf) for its supported formats.
> > 
> > You are right, in bayer/raw mode only one specific format should be
> > listed, depending on the CSI output pad format.

-- 
Regards,

Laurent Pinchart

