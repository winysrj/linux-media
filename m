Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54016 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933803AbdCJOUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 09:20:53 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310130733.GU21222@n2100.armlinux.org.uk>
 <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
 <20170310140124.GV21222@n2100.armlinux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
Date: Fri, 10 Mar 2017 15:20:48 +0100
MIME-Version: 1.0
In-Reply-To: <20170310140124.GV21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/17 15:01, Russell King - ARM Linux wrote:
> On Fri, Mar 10, 2017 at 02:22:29PM +0100, Hans Verkuil wrote:
>> And nobody of the media core developers has the time to work on the docs,
>> utilities and libraries you need to make this all work cleanly and reliably.
> 
> Well, talking about docs, and in connection to control inheritence,
> this is already documented in at least three separate places:
> 
> Documentation/media/uapi/v4l/dev-subdev.rst:
> 
>   Controls
>   ========
>   ...
>   Depending on the driver, those controls might also be exposed through
>   one (or several) V4L2 device nodes.
> 
> Documentation/media/kapi/v4l2-subdev.rst:
> 
>   ``VIDIOC_QUERYCTRL``,
>   ``VIDIOC_QUERYMENU``,
>   ``VIDIOC_G_CTRL``,
>   ``VIDIOC_S_CTRL``,
>   ``VIDIOC_G_EXT_CTRLS``,
>   ``VIDIOC_S_EXT_CTRLS`` and
>   ``VIDIOC_TRY_EXT_CTRLS``:
>   
>           The controls ioctls are identical to the ones defined in V4L2. They
>           behave identically, with the only exception that they deal only with
>           controls implemented in the sub-device. Depending on the driver, those
>           controls can be also be accessed through one (or several) V4L2 device
>           nodes.
> 
> Then there's Documentation/media/kapi/v4l2-controls.rst, which gives a
> step by step approach to the main video device inheriting controls from
> its subdevices, and it says:
> 
>   Inheriting Controls
>   -------------------
>   
>   When a sub-device is registered with a V4L2 driver by calling
>   v4l2_device_register_subdev() and the ctrl_handler fields of both v4l2_subdev
>   and v4l2_device are set, then the controls of the subdev will become
>   automatically available in the V4L2 driver as well. If the subdev driver
>   contains controls that already exist in the V4L2 driver, then those will be
>   skipped (so a V4L2 driver can always override a subdev control).
>   
>   What happens here is that v4l2_device_register_subdev() calls
>   v4l2_ctrl_add_handler() adding the controls of the subdev to the controls
>   of v4l2_device.
> 
> So, either the docs are wrong, or the advice being mentioned in emails
> about subdev control inheritence is misleading.  Whatever, the two are
> currently inconsistent.

These docs were written for non-MC drivers, and for those the documentation
is correct. Unfortunately, this was never updated for MC drivers.

> As I've already mentioned, from talking about this with Mauro, it seems
> Mauro is in agreement with permitting the control inheritence... I wish
> Mauro would comment for himself, as I can't quote our private discussion
> on the subject.

I can't comment either, not having seen his mail and reasoning.

> Right now, my view is that v4l2 is currently being screwed up by people
> with different opinions - there is no unified concensus on how any of
> this stuff is supposed to work, everyone is pulling in different
> directions.  That needs solving _really_ quickly, so I suggest that
> v4l2 people urgently talk to each other and thrash out some of the
> issues that Steve's patch set has brought up, and settle on a way
> forward, rather than what is seemingly happening today - which is
> everyone working in isolation of everyone else with their own bias on
> how things should be done.

The simple fact is that to my knowledge no other MC applications inherit
controls from subdevs. Suddenly doing something different here seems very
wrong to me and needs very good reasons.

But yes, the current situation sucks. Yelling doesn't help though if nobody
has time and there are several other high-prio projects that need our
attention as well.

If you know a good kernel developer who has a few months to spare, please
point him/her in our direction!

Regards,

	Hans
