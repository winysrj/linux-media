Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54725
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755411AbdCJPJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 10:09:19 -0500
Date: Fri, 10 Mar 2017 12:09:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170310120902.1daebc7b@vento.lan>
In-Reply-To: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
        <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
        <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
        <20170303230645.GR21222@n2100.armlinux.org.uk>
        <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
        <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Mar 2017 13:54:28 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > Devices that have complex pipeline that do essentially require using the
> > Media controller interface to configure them are out of that scope.
> >   
> 
> Way too much of how the MC devices should be used is in the minds of developers.
> There is a major lack for good detailed documentation, utilities, compliance
> test (really needed!) and libv4l plugins.

Unfortunately, we merged an incomplete MC support at the Kernel. We knew
all the problems with MC-based drivers and V4L2 applications by the time
it was developed, and we requested Nokia developers (with was sponsoring MC
develoment, on that time) to work on a solution to allow standard V4L2
applications to work with MC based boards.

Unfortunately, we took the decision to merge MC without that, because 
Nokia was giving up on Linux development, and we didn't want to lose the
2 years of discussions and work around it, as Nokia employers were leaving
the company. Also, on that time, there was already some patches floating
around adding backward support via libv4l. Unfortunately, those patches
were never finished.

The net result is that MC was merged with some huge gaps, including
the lack of a proper solution for a generic V4L2 program to work
with V4L2 devices that use the subdev API.

That was not that bad by then, as MC was used only on cell phones
that run custom-made applications. 

The reallity changed, as now, we have lots of low cost SoC based
boards, used for all sort of purposes. So, we need a quick solution
for it.

In other words, while that would be acceptable support special apps
on really embedded systems, it is *not OK* for general purpose SoC
harware[1].

[1] I'm calling "general purpose SoC harware" those ARM boards
like Raspberry Pi that are shipped to the mass and used by a wide
range of hobbyists and other people that just wants to run Linux on
ARM. It is possible to buy such boards for a very cheap price,
making them to be used not only on special projects, where a custom
made application could be interesting, but also for a lot of
users that just want to run Linux on a low cost ARM board, while
keeping using standard V4L2 apps, like "camorama".

That's perhaps one of the reasons why it took a long time for us to
start receiving drivers upstream for such hardware: it is quite 
intimidating and not logical to require developers to implement
on their drivers 2 complex APIs (MC, subdev) for those
hardware that most users won't care. From user's perspective,
being able to support generic applications like "camorama" and
"zbar" is all they want.

In summary, I'm pretty sure we need to support standard V4L2 
applications on boards like Raspberry Pi and those low-cost 
SoC-based boards that are shipped to end users.

> Anyway, regarding this specific patch and for this MC-aware driver: no, you
> shouldn't inherit controls from subdevs. It defeats the purpose.

Sorry, but I don't agree with that. The subdev API is an optional API
(and even the MC API can be optional).

I see the rationale for using MC and subdev APIs on cell phones,
ISV and other embedded hardware, as it will allow fine-tuning
the driver's support to allow providing the required quality for
certain custom-made applications. but on general SoC hardware,
supporting standard V4L2 applications is a need.

Ok, perhaps supporting both subdev API and V4L2 API at the same
time doesn't make much sense. We could disable one in favor of the
other, either at compilation time or at runtime.

This way, if the subdev API is disabled, the driver will be
functional for V4L2-based applications that don't support neither
MC or subdev APIs.

> As mentioned, I will attempt to try and get some time to work on this
> later this year. Fingers crossed.

That will be good, and, once we have a solution that works, we can
work on cleanup the code, but, until then, drivers for arm-based boards
sold to end consumers should work out of the box with standard V4L2 apps.

While we don't have that, I'm OK to merge patches adding such support
upstream.

Thanks,
Mauro
