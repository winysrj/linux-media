Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33610 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdBTXro (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 18:47:44 -0500
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <6892fb15-2d18-4898-c328-3acff9d6cc39@gmail.com>
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <028a05fb-f5e8-d4ed-b0bd-39b93b56dfac@gmail.com>
Date: Mon, 20 Feb 2017 15:47:39 -0800
MIME-Version: 1.0
In-Reply-To: <6892fb15-2d18-4898-c328-3acff9d6cc39@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/20/2017 02:56 PM, Steve Longerbeam wrote:
>
>
> On 02/20/2017 02:04 PM, Sakari Ailus wrote:
>> Hi Steve,
>>
>> On Wed, Feb 15, 2017 at 06:19:31PM -0800, Steve Longerbeam wrote:
>>> From: Russell King <rmk+kernel@armlinux.org.uk>
>>>
>>> Setting and getting frame rates is part of the negotiation mechanism
>>> between subdevs.  The lack of support means that a frame rate at the
>>> sensor can't be negotiated through the subdev path.
>>
>> Just wondering --- what do you need this for?
>
>
> Hi Sakari,
>
> i.MX does need the ability to negotiate the frame rates in the
> pipelines. The CSI has the ability to skip frames at the output,
> which is something Philipp added to the CSI subdev. That affects
> frame interval at the CSI output.
>
> But as Russell pointed out, the lack of [gs]_frame_interval op
> causes media-ctl to fail:
>
> media-ctl -v -d /dev/media1 --set-v4l2
> '"imx6-mipi-csi2":1[fmt:SGBRG8/512x512@1/30]'
>
> Opening media device /dev/media1
> Enumerating entities
> Found 29 entities
> Enumerating pads and links
> Setting up format SGBRG8 512x512 on pad imx6-mipi-csi2/1
> Format set: SGBRG8 512x512
> Setting up frame interval 1/30 on entity imx6-mipi-csi2
> Unable to set frame interval: Inappropriate ioctl for device (-25)Unable
> to setup formats: Inappropriate ioctl for device (25)
>
>
> So i.MX needs to implement this op in every subdev in the
> pipeline, otherwise it's not possible to configure the
> pipeline with media-ctl.
>


Hi Russell,

But Sakari brings up a good point. The mipi csi-2 receiver doesn't
have any control over frame rate, so why do you even need to
give it this information via media-ctl?

Steve
