Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60516
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935360AbdCLV7A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 17:59:00 -0400
Date: Sun, 12 Mar 2017 18:58:45 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, Hans Verkuil <hverkuil@xs4all.nl>,
        pavel@ucw.cz, shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
        geert@linux-m68k.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, sakari.ailus@linux.intel.com,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170312185845.5c18ffd0@vento.lan>
In-Reply-To: <fba73c10-4b95-f0d2-e681-0b14ef1fbc1c@gmail.com>
References: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
        <20170310120902.1daebc7b@vento.lan>
        <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
        <20170311101408.272a9187@vento.lan>
        <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
        <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
        <20170311184551.GD21222@n2100.armlinux.org.uk>
        <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
        <20170311185959.GF21222@n2100.armlinux.org.uk>
        <4917d7fb-2f48-17cd-aa2f-d54b0f19ed6e@gmail.com>
        <20170312073745.GI21222@n2100.armlinux.org.uk>
        <fba73c10-4b95-f0d2-e681-0b14ef1fbc1c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Mar 2017 10:56:53 -0700
Steve Longerbeam <slongerbeam@gmail.com> escreveu:

> On 03/11/2017 11:37 PM, Russell King - ARM Linux wrote:
> > On Sat, Mar 11, 2017 at 07:31:18PM -0800, Steve Longerbeam wrote:  

> > Given what Mauro has said, I'm convinced that the media controller stuff
> > is a complete failure for usability, and adding further drivers using it
> > is a mistake.

I never said that. The thing is that the V4L2 API was designed in
1999, when the video hardware were a way simpler: just one DMA engine
on a PCI device, one video/audio input switch and a few video entries.

On those days, setting up a pipeline on such devices is simple, and can be
done via VIDIOC_*_INPUT ioctls.

Nowadays hardware used on SoC devices are a way more complex.

SoC devices comes with several DMA engines for buffer transfers, plus
video transform blocks whose pipeline can be set dynamically.

The MC API is a need to allow setting a complex pipeline, as
VIDIOC_*_INPUT cannot work with such complexity.

The subdev API solves a different issue. On a "traditional" device,
we usually have a pipeline like:

<video input> ==> <processing> ==> /dev/video0

Where <processing> controls something at the device (like
bright and/or resolution) if you change something at the /dev/video0 
node, it is clear that the <processing> block should handle it.

On complex devices, with a pipeline like:
<camera> ==> <processing0> ==> <CSI bus> ==> <processing1> ==> /dev/video0

If you send a command to adjust the something at /dev/video0, it is
not clear for the device driver to do it at processing0 or at
processing1. Ok, the driver can decide it, but this can be sub-optimal.

Yet, several drivers do that. For example, with em28xx-based drivers
several parameters can be adjusted either at the em28xx driver or at
the video decoder driver (saa711x). There's a logic inside the driver
that decides it. The pipeline there is fixed, though, so it is
easy to hardcode a logic for that.

So, I've no doubt that both MC and subdev APIs are needed when full
hardware control is required.

I don't know about how much flexibility the i.MX6 hardware gives,
nor if all such flexibility is needed for most use case applications.

If I were to code a driver for such hardware, though, I would try to
provide a subset of the functionality that would work without the
subdev API, allowing it to work with standard V4L applications.

That doesn't sound hard to do, as the driver may limit the pipelines
to a subset that would make sense, in order to make easier for the
driver to take the right decision about to where send a control
to setup some parameter.

> I do agree with you that MC places a lot of burden on the user to
> attain a lot of knowledge of the system's architecture.

Setting up the pipeline is not the hard part. One could write a
script to do that. 

> That's really  why I included that control inheritance patch, to 
> ease the burden somewhat.

IMHO, that makes sense, as, once some script sets the pipeline, any
V4L2 application can work, if you forward the controls to the right
I2C devices.

> On the other hand, I also think this just requires that MC drivers have
> very good user documentation.

No, it is not a matter of just documentation. It is a matter of having
to rewrite applications for each device, as the information exposed by
MC are not enough for an application to do what's needed.

For a generic application to work properly with MC, we need to have to
add more stuff to MC, in order to allow applications to know more about
the features of each subdevice and to things like discovering what kind
of signal is present on each PAD. We're calling it as "properties API"[1].

[1] we discussed about that at the ML and at the MC workshop:
	https://linuxtv.org/news.php?entry=2015-08-17.mchehab

Unfortunately, nobody sent any patches implementing it so far :-(

> And my other point is, I think most people who have a need to work with
> the media framework on a particular platform will likely already be
> quite familiar with that platform.

I disagree. The most popular platform device currently is Raspberry PI.

I doubt that almost all owners of RPi + camera module know anything
about MC. They just use Raspberry's official driver with just provides
the V4L2 interface.

I have a strong opinion that, for hardware like RPi, just the V4L2
API is enough for more than 90% of the cases.

> The media graph for imx6 is fairly self-explanatory in my opinion.
> Yes that graph has to be generated, but just with a simple 'media-ctl
> --print-dot', I don't see how that is difficult for the user.

Again, IMHO, the problem is not how to setup the pipeline, but, instead,
the need to forward controls to the subdevices.

To use a camera, the user needs to set up a set of controls for the
image to make sense (bright, contrast, focus, etc). If the driver
doesn't forward those controls to the subdevs, an application like
"camorama" won't actually work for real, as the user won't be able
to adjust those parameters via GUI.

Thanks,
Mauro
