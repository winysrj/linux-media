Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752397AbdBUMid (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 07:38:33 -0500
Date: Tue, 21 Feb 2017 14:37:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
Message-ID: <20170221123756.GI16975@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221001332.GS21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Tue, Feb 21, 2017 at 12:13:32AM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 21, 2017 at 12:04:10AM +0200, Sakari Ailus wrote:
> > On Wed, Feb 15, 2017 at 06:19:31PM -0800, Steve Longerbeam wrote:
> > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > Setting and getting frame rates is part of the negotiation mechanism
> > > between subdevs.  The lack of support means that a frame rate at the
> > > sensor can't be negotiated through the subdev path.
> > 
> > Just wondering --- what do you need this for?
> 
> The v4l2 documentation contradicts the media-ctl implementation.
> 
> While v4l2 documentation says:
> 
>   These ioctls are used to get and set the frame interval at specific
>   subdev pads in the image pipeline. The frame interval only makes sense
>   for sub-devices that can control the frame period on their own. This
>   includes, for instance, image sensors and TV tuners. Sub-devices that
>   don't support frame intervals must not implement these ioctls.
> 
> However, when trying to configure the pipeline using media-ctl, eg:
> 
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 pixel 0-0010":0[crop:(0,0)/3264x2464]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":1[fmt:SRGGB10/3264x2464@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":0[fmt:SRGGB8/816x616@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616@1/30]'
> Unable to setup formats: Inappropriate ioctl for device (25)
> media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0_mux":2[fmt:SRGGB8/816x616@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0":2[fmt:SRGGB8/816x616@1/30]'
> 
> The problem there is that the format setting for the csi2 does not get
> propagated forward:

The CSI-2 receivers typically do not implement frame interval IOCTLs as they
do not control the frame interval. Some sensors or TV tuners typically do,
so they implement these IOCTLs.

There are alternative ways to specify the frame rate.

> 
> $ strace media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616@1/30]'
> ...
> open("/dev/v4l-subdev16", O_RDWR)       = 3
> ioctl(3, VIDIOC_SUBDEV_S_FMT, 0xbec16244) = 0
> ioctl(3, VIDIOC_SUBDEV_S_FRAME_INTERVAL, 0xbec162a4) = -1 ENOTTY (Inappropriate
> ioctl for device)
> fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
> write(1, "Unable to setup formats: Inappro"..., 61) = 61
> Unable to setup formats: Inappropriate ioctl for device (25)
> close(3)                                = 0
> exit_group(1)                           = ?
> +++ exited with 1 +++
> 
> because media-ctl exits as soon as it encouters the error while trying
> to set the frame rate.
> 
> This makes implementing setup of the media pipeline in shell scripts
> unnecessarily difficult - as you need to then know whether an entity
> is likely not to support the VIDIOC_SUBDEV_S_FRAME_INTERVAL call,
> and either avoid specifying a frame rate:

You should remove the frame interval setting from sub-devices that do not
support it.

> 
> $ strace media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616]'
> ...
> open("/dev/v4l-subdev16", O_RDWR)       = 3
> ioctl(3, VIDIOC_SUBDEV_S_FMT, 0xbeb1a254) = 0
> open("/dev/v4l-subdev0", O_RDWR)        = 4
> ioctl(4, VIDIOC_SUBDEV_S_FMT, 0xbeb1a254) = 0
> close(4)                                = 0
> close(3)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
> 
> or manually setting the format on the sink.
> 
> Allowing the S_FRAME_INTERVAL call seems to me to be more in keeping
> with the negotiation mechanism that is implemented in subdevs, and
> IMHO should be implemented inside the kernel as a pad operation along
> with the format negotiation, especially so as frame skipping is
> defined as scaling, in just the same way as the frame size is also
> scaling:

The origins of the S_FRAME_INTERVAL IOCTL for sub-devices are the S_PARM
IOCTL for video nodes. It is used to control the frame rate for more simple
devices that do not expose the Media controller interface. The similar
S_FRAME_INTERVAL was added for sub-devices as well, and it has been so far
used to control the frame interval for sensors (and G_FRAME_INTERVAL to
obtain the frame interval for TV tuners, for instance).

The pad argument was added there but media-ctl only supported setting the
frame interval on pad 0, which, coincidentally, worked well for sensor
devices.

The link validation is primarily done in order to ensure the validity of the
hardware configuration: streaming may not be started if the hardware
configuration is not valid.

Also, frame interval is not a static property during streaming: it may be
changed without the knowledge of the other sub-device drivers downstream. It
neither is a property of hardware receiving or processing images: if there
are limitations in processing pixels, then they in practice are related to
pixel rates or image sizes (i.e. not frame rates).

> 
>        -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
> 
>        -  Video scaler. An entity capable of video scaling must have
>           at least one sink pad and one source pad, and scale the
>           video frame(s) received on its sink pad(s) to a different
>           resolution output on its source pad(s). The range of
>           supported scaling ratios is entity-specific and can differ
>           between the horizontal and vertical directions (in particular
>           scaling can be supported in one direction only). Binning and
>           skipping are considered as scaling.
> 
> Although, this is vague, as it doesn't define what it means by "skipping",
> whether that's skipping pixels (iow, sub-sampling) or whether that's
> frame skipping.

Skipping in the context is used to refer to sub-sampling. The term is often
used in conjunction of sensors. The documentation could certainly be
clarified here.

> 
> Then there's the issue where, if you have this setup:
> 
>  camera --> csi2 receiver --> csi --> capture
> 
> and the "csi" subdev can skip frames, you need to know (a) at the CSI
> sink pad what the frame rate is of the source (b) what the desired
> source pad frame rate is, so you can configure the frame skipping.
> So, does the csi subdev have to walk back through the media graph
> looking for the frame rate?  Does the capture device have to walk back
> through the media graph looking for some subdev to tell it what the
> frame rate is - the capture device certainly can't go straight to the
> sensor to get an answer to that question, because that bypasses the
> effect of the CSI frame skipping (which will lower the frame rate.)
> 
> IMHO, frame rate is just another format property, just like the
> resolution and data format itself, and v4l2 should be treating it no
> differently.
> 
> In any case, the documentation vs media-ctl create something of a very
> obscure situation, one that probably needs solving one way or another.

Before going to solutions I need to ask: what do you want to achieve?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
