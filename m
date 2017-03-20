Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41440
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752569AbdCTRhf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 13:37:35 -0400
Date: Mon, 20 Mar 2017 14:37:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170320143715.66860222@vento.lan>
In-Reply-To: <20170320161003.GO21222@n2100.armlinux.org.uk>
References: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
        <20170310125342.7f047acf@vento.lan>
        <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
        <20170311082549.576531d0@vento.lan>
        <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
        <20170314004533.3b3cd44b@vento.lan>
        <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
        <20170314072143.498cde9b@vento.lan>
        <5c935062-61f4-40e7-0ee9-87655197e661@xs4all.nl>
        <20170320123938.0503c931@vento.lan>
        <20170320161003.GO21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 20 Mar 2017 16:10:03 +0000
Russell King - ARM Linux <linux@armlinux.org.uk> escreveu:

> On Mon, Mar 20, 2017 at 12:39:38PM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 20 Mar 2017 14:24:25 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:  
> > > I don't think this control inheritance patch will magically prevent you
> > > from needed a plugin.  
> > 
> > Yeah, it is not just control inheritance. The driver needs to work
> > without subdev API, e. g. mbus settings should also be done via the
> > video devnode.
> > 
> > Btw, Sakari made a good point on IRC: what happens if some app 
> > try to change the pipeline or subdev settings while another
> > application is using the device? The driver should block such 
> > changes, maybe using the V4L2 priority mechanism.  
> 
> My understanding is that there are already mechanisms in place to
> prevent that, but it's driver dependent - certainly several of the
> imx driver subdevs check whether they have an active stream, and
> refuse (eg) all set_fmt calls with -EBUSY if that is so.
> 
> (That statement raises another question in my mind: if the subdev is
> streaming, should it refuse all set_fmt, even for the TRY stuff?)

Returning -EBUSY only when streaming is too late, as ioctl's
may be changing the pipeline configuration and/or buffer allocation,
while the application is sending other ioctls in order to prepare
for streaming.

V4L2 has a mechanism of blocking other apps to change such
parameters via VIDIOC_S_PRIORITY[1]. If an application sets
priority to V4L2_PRIORITY_RECORD, any other application attempting
to change the device via some other file descriptor will fail.
So, it is a sort of "exclusive write access".

On a quick look at V4L2 core, currently, sending a 
VIDIOC_S_PRIORITY ioctl to a /dev/video device doesn't seem to have
any effect at either MC or V4L2 subdev API for the subdevs connected
to it. We'll likely need to add some code at v4l2_prio_change()
for it to notify the subdevs for them to return -EBUSY if one
would try to change something there, while the device is priorized.

[1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-g-priority.html

> > In parallel, someone has to fix libv4l for it to be default on
> > applications like gstreamer, e. g. adding support for DMABUF
> > and fixing other issues that are preventing it to be used by
> > default.  
> 
> Hmm, not sure what you mean there - I've used dmabuf with gstreamer's
> v4l2src linked to libv4l2, importing the buffers into etnaviv using
> a custom plugin.  There are distros around (ubuntu) where the v4l2
> plugin is built against libv4l2.

Hmm... I guess some gst developer mentioned that there are/where
some restrictions at libv4l2 with regards to DMABUF. I may be
wrong.

> 
> > My understanding here is that there are developers wanting/needing
> > to have standard V4L2 apps support for (some) i.MX6 devices. Those are
> > the ones that may/will allocate some time for it to happen.  
> 
> Quite - but we need to first know what is acceptable to the v4l2
> community before we waste a lot of effort coding something up that
> may not be suitable.  Like everyone else, there's only a limited
> amount of effort available, so using it wisely is a very good idea.

Sure. That's why we're discussing here :-)

> Up until recently, it seemed that the only solution was to solve the
> userspace side of the media controller API via v4l2 plugins and the
> like.
> 
> Much of my time that I have available to look at the imx6 capture
> stuff at the moment is taken up by triping over UAPI issues with the
> current code (such as the ones about CSI scaling, colorimetry, etc)
> and trying to get concensus on what the right solution to fix those
> issues actually is, and at the moment I don't have spare time to
> start addressing any kind of v4l2 plugin for user controls nor any
> other solution.

I hear you. A solution via libv4l could be more elegant, but it
doesn't seem simple, as nobody did it before, and depends on the
libv4l plugin mechanism, with is currently unused.

Also, I think it is easier to provide a solution using DT and some
driver and/or core support for it, specially since, AFAICT,
currently there's no way request exclusive access to MC and subdevs.

It is probably not possible do to that exclusively in userspace.

> Eg, I spent much of this last weekend sorting out my IMX219 camera
> sensor driver for my new understanding about how scaling is supposed
> to work, the frame enumeration issue (which I've posted patches for)
> and the CSI scaling issue (which I've some half-baked patch for at the
> moment, but probably by the time I've finished sorting that, Philipp
> or Steve will already have a solution.)
> 
> That said, my new understanding of the scaling impacts the four patches
> I posted, and probably makes the frame size enumeration in CSI (due to
> its scaling) rather obsolete.

Yeah, when there's no scaler, it should report just the resolution(s)
supported by the sensor (actually, at the CSI) via
V4L2_FRMSIZE_TYPE_DISCRETE.

However, when there's a scaler at the pipeline, it should report the
range supported by the scaler, e. g.:

- V4L2_FRMSIZE_TYPE_CONTINUOUS - when an entire range of resolutions
  is supported with step = 1 for both H and V .

- V4L2_FRMSIZE_TYPE_STEPWISE - when there's either a H or V step at
  the possible values for resolutions. This is actually more common
  in practice, as several encodings take a 2x2 pixel block. So, the
  step should be at least 2.

There is something to be considered by the logic that forwards the
resolution to the CSI: a lower resolution there means a higher number of
frames per second.

So, if the driver is setting the resolution via a V4L2 device, it
will provide a higher number of fps if it selects the lowest 
resolution at CSI that it is greater or equal to the resolution
set at the scaler. On the other hand, the image quality could be 
better if it doesn't scale at CSI.

Thanks,
Mauro
