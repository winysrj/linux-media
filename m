Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33567 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdE2SMF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 14:12:05 -0400
Subject: Re: [PATCH v7 00/34] i.MX Media Driver
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, nick@shmanahar.org,
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
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <dd82968a-4c0b-12a4-f43b-7e63a255812d@xs4all.nl>
 <20170529153637.GH29527@valkosipuli.retiisi.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <08dcd6f6-e0ef-a6a0-cfc3-4fcd55624169@gmail.com>
Date: Mon, 29 May 2017 11:12:00 -0700
MIME-Version: 1.0
In-Reply-To: <20170529153637.GH29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 05/29/2017 08:36 AM, Sakari Ailus wrote:
> Hi Hans,
>
> On Mon, May 29, 2017 at 03:46:08PM +0200, Hans Verkuil wrote:
>> Hi Steve,
>>
>> On 05/25/2017 02:29 AM, Steve Longerbeam wrote:
>>> In version 7:
>>>
>>> - video-mux: switched to Philipp's latest video-mux driver and updated
>>>    bindings docs, that makes use of the mmio-mux framework.
>>>
>>> - mmio-mux: includes Philipp's temporary patch that adds mmio-mux support
>>>    to video-mux driver, until mux framework is merged.
>>>
>>> - mmio-mux: updates to device tree from Philipp that define the i.MX6 mux
>>>    devices and modifies the video-mux device to become a consumer of the
>>>    video mmio-mux.
>>>
>>> - minor updates to Documentation/media/v4l-drivers/imx.rst.
>>>
>>> - ov5640: do nothing if entity stream count is greater than 1 in
>>>    ov5640_s_stream().
>>>
>>> - Previous versions of this driver had not tested the ability to enable
>>>    multiple independent streams, for instance enabling multiple output
>>>    pads from the imx6-mipi-csi2 subdevice, or enabling both prpenc and
>>>    prpvf outputs. Marek Vasut tested this support and reported issues
>>>    with it.
>>>
>>>    v4l2_pipeline_inherit_controls() used the media graph walk APIs, but
>>>    that walks both sink and source pads, so if there are multiple paths
>>>    enabled to video capture devices, controls would be added to the wrong
>>>    video capture device, and no controls added to the other enabled
>>>    capture devices.
>>>
>>>    These issues have been fixed. Control inheritance works correctly now
>>>    even with multiple enabled capture paths, and (for example)
>>>    simultaneous capture from prpenc and prpvf works also, and each with
>>>    independent scaling, CSC, and controls. For example prpenc can be
>>>    capturing with a 90 degree rotation, while prpvf is capturing with
>>>    vertical flip.
>>>
>>>    So the v4l2_pipeline_inherit_controls() patch has been dropped. The
>>>    new version of control inheritance could be made generically available,
>>>    but it would be more involved to incorporate it into v4l2-core.
>>>
>>> - A new function imx_media_fill_default_mbus_fields() is added to setup
>>>    colorimetry at sink pads, and these are propagated to source pads.
>>>
>>> - Ensure that the current sink and source rectangles meet alignment
>>>    restrictions before applying a new rotation control setting in
>>>    prp-enc/vf subdevices.
>>>
>>> - Chain the s_stream() subdev calls instead of implementing a custom
>>>    stream on/off function that attempts to call a fixed set of subdevices
>>>    in a pipeline in the correct order. This also simplifies imx6-mipi-csi2
>>>    subdevice, since the correct MIPI CSI-2 startup sequence can be
>>>    enforced completely in s_stream(), and s_power() is no longer
>>>    required. This also paves the way for more arbitrary OF graphs
>>>    external to the i.MX6.
>>>
>>> - Converted the v4l2_subdev and media_entity ops structures to const.
>> What is the status as of v7?
>>
>>  From what I can tell patch 2/34 needs an Ack from Rob Herring, patches
>> 4-14 are out of scope for the media subsystem, patches 20-25 and 27-34
>> are all staging (so fine to be merged from my point of view).
>>
>> I'm not sure if patch 26 (defconfig) should be applied while the imx
>> driver is in staging. I would suggest that this patch is moved to the end
>> of the series.
>>
>> That leaves patches 15-19. I replied to patch 15 with a comment, patches
>> 16-18 look good to me, although patches 17 and 18 should be combined to one
>> patch since patch 17 won't compile otherwise. Any idea when the multiplexer is
>> expected to be merged? (just curious)
>>
>> I would really like to get this merged for 4.13, so did I miss anything?
>>  From what I can tell it is really just an Ack for patch 2/34.
> The patchset re-initialises the control handler in the video node in its
> media device link_setup callback, among other things. I don't think that
> this as such should prevent including the driver in staging, but at the same
> time my concern is what kind of guarantees can we give in terms of V4L2
> framework support on things like this using the current API. I'd say "none".

Re-initializing a control handler in itself works fine (maybe we should
add a v4l2_ctrl_handler_reinit() ?).

I agree that calling free/init/add at this time (in link_setup and 
link_notify)
is a new way to use those APIs. The effect is that a video node's controls
can change post driver load.

There's nothing in Documentation/kapi/v4l2-controls.rst that states that
a video node's control list can't change at runtime. But as I said 
free/init/add
works just fine and can be called any time after a subdevice or video device
is registered.

>
> If there's a need for this (there should not be, as the controls are exposed
> to the user space through the sub-device nodes as the other drivers do), the
> framework APIs need to be extended.

Right, this gets back to the media framework usability arguments. At least
myself, Philipp, and Russell feel that automatic inheritance of a configured
pipeline's controls to a video device adds to the usability.

>
> I think it'd be good to add a TODO file (such as the one in OMAP4ISS) as
> part of the patchset that would include a list of things left to do so
> they're not forgotten.

Right, there is a TODO, but I will add an item that mentions this included
feature and whether it should eventually become part of the framework
or dropped.

Steve
