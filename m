Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32877 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbdCKUb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 15:31:29 -0500
Subject: Re: [PATCH v5 18/39] [media] v4l: subdev: Add function to validate
 frame interval
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-19-git-send-email-steve_longerbeam@mentor.com>
 <20170311134119.GO3220@valkosipuli.retiisi.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <dc2836e2-c110-4e4f-1717-8df9622fdf04@gmail.com>
Date: Sat, 11 Mar 2017 12:31:24 -0800
MIME-Version: 1.0
In-Reply-To: <20170311134119.GO3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 05:41 AM, Sakari Ailus wrote:
> Hi Steve,
>
> On Thu, Mar 09, 2017 at 08:52:58PM -0800, Steve Longerbeam wrote:
>> If the pads on both sides of a link specify a frame interval, then
>> those frame intervals should match. Create the exported function
>> v4l2_subdev_link_validate_frame_interval() to verify this. This
>> function can be called in a subdevice's media_entity_operations
>> or v4l2_subdev_pad_ops link_validate callbacks.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> If your only goal is to configure frame dropping on a sub-device, I suggest
> to implement s_frame_interval() on the pads of that sub-device only. The
> frames are then dropped according to the configured frame rates between the
> sink and source pads. Say, configuring sink for 1/30 s and source 1/15 would
> drop half of the incoming frames.
>
> Considering that supporting specific frame interval on most sub-devices adds
> no value or is not the interface through which it the frame rate configured,
> I think it is overkill to change the link validation to expect otherwise.


Well, while I think this function might still have validity in the 
future, I do agree with you that a subdev that has no control over
frame rate has no business implementing the get|set ops.

In the imx-media subdevs, the only one that can affect frame rate (via
frame skipping) is the CSI. So I'll go ahead and remove the
[gs]_frame_interval ops from the others. I can remove this patch as
a result.


Steve
