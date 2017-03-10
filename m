Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54928
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934351AbdCJPx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 10:53:56 -0500
Date: Fri, 10 Mar 2017 12:53:42 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170310125342.7f047acf@vento.lan>
In-Reply-To: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
        <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
        <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
        <20170303230645.GR21222@n2100.armlinux.org.uk>
        <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
        <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
        <20170310130733.GU21222@n2100.armlinux.org.uk>
        <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
        <20170310140124.GV21222@n2100.armlinux.org.uk>
        <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Mar 2017 15:20:48 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> 
> > As I've already mentioned, from talking about this with Mauro, it seems
> > Mauro is in agreement with permitting the control inheritence... I wish
> > Mauro would comment for himself, as I can't quote our private discussion
> > on the subject.  
> 
> I can't comment either, not having seen his mail and reasoning.

The rationale is that we should support the simplest use cases first.

In the case of the first MC-based driver (and several subsequent
ones), the simplest use case required MC, as it was meant to suport
a custom-made sophisticated application that required fine control
on each component of the pipeline and to allow their advanced
proprietary AAA userspace-based algorithms to work.

That's not true, for example, for the UVC driver. There, MC
is optional, as it should be.

> > Right now, my view is that v4l2 is currently being screwed up by people
> > with different opinions - there is no unified concensus on how any of
> > this stuff is supposed to work, everyone is pulling in different
> > directions.  That needs solving _really_ quickly, so I suggest that
> > v4l2 people urgently talk to each other and thrash out some of the
> > issues that Steve's patch set has brought up, and settle on a way
> > forward, rather than what is seemingly happening today - which is
> > everyone working in isolation of everyone else with their own bias on
> > how things should be done.  
> 
> The simple fact is that to my knowledge no other MC applications inherit
> controls from subdevs. Suddenly doing something different here seems very
> wrong to me and needs very good reasons.

That's because it was not needed before, as other subdev-based drivers
are meant to be used only on complex scenarios with custom-made apps.

Thanks,
Mauro
