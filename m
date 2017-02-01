Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43653 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751732AbdBAJcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 04:32:24 -0500
Message-ID: <1485941457.3353.13.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 01 Feb 2017 10:30:57 +0100
In-Reply-To: <5586b893-bf5c-6133-0789-ccce60626b86@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1485870854.2932.63.camel@pengutronix.de>
         <5586b893-bf5c-6133-0789-ccce60626b86@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-01-31 at 17:26 -0800, Steve Longerbeam wrote:
[...]
> > # Set pad formats
> > media-ctl --set-v4l2 "'tc358743 1-000f':0[fmt:UYVY/1920x1080]"
> > media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY2X8/1920x1080]"
> > media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080]"
> > media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/1920x1080]"
> >
> > v4l2-ctl -d /dev/video4 -V
> > # This still is configured to 640x480, which is inconsistent with
> > # the 'ipu1_csi0':2 pad format. The pad set_fmt above should
> > # have set this, too.
> 
> Because you've only configured the source pads,
> and not the sink pads. The ipu_csi source format is
> dependent on the sink format - output crop window is
> limited by max input sensor frame, and since sink pad is
> still at 640x480, output is reduced to that.

No, it is set (see below). What happens is that capture_g_fmt_vid_cap
just returns the capture devices' priv->vdev.fmt, even if it is
incompatible with the connected csi subdevice's output pad format.

priv->vdev.fmt was never changed from the default set in
imx_media_capture_device_register, because capture_s/try_fmt_vid_cap
were not called yet.

> Maybe I'm missing something, is it expected behavior that
> a source format should be automatically propagated to
> the sink?

media-ctl propagates the output pad format to all remote subdevices'
input pads for all enabled links:

https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl/libv4l2subdev.c#n693

> > v4l2-ctl --list-formats -d /dev/video4
> > # This lists all the RGB formats, which it shouldn't. There is
> > # no CSC in this pipeline, so we should be limited to YUV formats
> > # only.
> 
> right, need to fix that. Probably by poking the attached
> source subdev (csi or prpenc/vf) for its supported formats.

You are right, in bayer/raw mode only one specific format should be
listed, depending on the CSI output pad format.

regards
Philipp

