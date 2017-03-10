Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57162 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932800AbdCJWhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 17:37:53 -0500
Date: Sat, 11 Mar 2017 00:37:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
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
Message-ID: <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310130733.GU21222@n2100.armlinux.org.uk>
 <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
 <20170310140124.GV21222@n2100.armlinux.org.uk>
 <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310125342.7f047acf@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro (and others),

On Fri, Mar 10, 2017 at 12:53:42PM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 10 Mar 2017 15:20:48 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > 
> > > As I've already mentioned, from talking about this with Mauro, it seems
> > > Mauro is in agreement with permitting the control inheritence... I wish
> > > Mauro would comment for himself, as I can't quote our private discussion
> > > on the subject.  
> > 
> > I can't comment either, not having seen his mail and reasoning.
> 
> The rationale is that we should support the simplest use cases first.
> 
> In the case of the first MC-based driver (and several subsequent
> ones), the simplest use case required MC, as it was meant to suport
> a custom-made sophisticated application that required fine control
> on each component of the pipeline and to allow their advanced
> proprietary AAA userspace-based algorithms to work.

The first MC based driver (omap3isp) supports what the hardware can do, it
does not support applications as such.

Adding support to drivers for different "operation modes" --- this is
essentially what is being asked for --- is not an approach which could serve
either purpose (some functionality with simple interface vs. fully support
what the hardware can do, with interfaces allowing that) adequately in the
short or the long run.

If we are missing pieces in the puzzle --- in this case the missing pieces
in the puzzle are a generic pipeline configuration library and another
library that, with the help of pipeline autoconfiguration would implement
"best effort" service for regular V4L2 on top of the MC + V4L2 subdev + V4L2
--- then these pieces need to be impelemented. The solution is
*not* to attempt to support different types of applications in each driver
separately. That will make writing drivers painful, error prone and is
unlikely ever deliver what either purpose requires.

So let's continue to implement the functionality that the hardware supports.
Making a different choice here is bound to create a lasting conflict between
having to change kernel interface behaviour and the requirement of
supporting new functionality that hasn't been previously thought of, pushing
away SoC vendors from V4L2 ecosystem. This is what we all do want to avoid.

As far as i.MX6 driver goes, it is always possible to implement i.MX6 plugin
for libv4l to perform this. This should be much easier than getting the
automatic pipe configuration library and the rest working, and as it is
custom for i.MX6, the resulting plugin may make informed technical choices
for better functionality. Jacek has been working on such a plugin for
Samsung Exynos hardware, but I don't think he has quite finished it yey.

The original plan was and continues to be sound, it's just that there have
always been too few hands to implement it. :-(

> 
> That's not true, for example, for the UVC driver. There, MC
> is optional, as it should be.

UVC is different. The device simply provides additional information through
MC to the user but MC (or V4L2 sub-device interface) is not used for
controlling the device.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
