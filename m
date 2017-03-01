Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34636 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdCAGOT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 01:14:19 -0500
Received: by mail-oi0-f66.google.com with SMTP id m124so2432533oig.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 22:14:19 -0800 (PST)
Subject: Re: [PATCH v4 15/36] platform: add video-multiplexer subdevice driver
To: Rob Herring <robh@kernel.org>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-16-git-send-email-steve_longerbeam@mentor.com>
 <20170227144153.g4jzzbrcb7oyddyj@rob-hp-laptop>
Cc: mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6262f5bd-08e0-20b0-9e41-a01db75587dd@gmail.com>
Date: Tue, 28 Feb 2017 16:20:07 -0800
MIME-Version: 1.0
In-Reply-To: <20170227144153.g4jzzbrcb7oyddyj@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/27/2017 06:41 AM, Rob Herring wrote:
> On Wed, Feb 15, 2017 at 06:19:17PM -0800, Steve Longerbeam wrote:
>> From: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> This driver can handle SoC internal and external video bus multiplexers,
>> controlled either by register bit fields or by a GPIO. The subdevice
>> passes through frame interval and mbus configuration of the active input
>> to the output side.
>>
>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> --
>>
>> - fixed a cut&paste error in vidsw_remove(): v4l2_async_register_subdev()
>>    should be unregister.
>>
>> - added media_entity_cleanup() and v4l2_device_unregister_subdev()
>>    to vidsw_remove().
>>
>> - added missing MODULE_DEVICE_TABLE().
>>    Suggested-by: Javier Martinez Canillas <javier@dowhile0.org>
>>
>> - there was a line left over from a previous iteration that negated
>>    the new way of determining the pad count just before it which
>>    has been removed (num_pads = of_get_child_count(np)).
>>
>> - Philipp Zabel has developed a set of patches that allow adding
>>    to the subdev async notifier waiting list using a chaining method
>>    from the async registered callbacks (v4l2_of_subdev_registered()
>>    and the prep patches for that). For now, I've removed the use of
>>    v4l2_of_subdev_registered() for the vidmux driver's registered
>>    callback. This doesn't affect the functionality of this driver,
>>    but allows for it to be merged now, before adding the chaining
>>    support.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   .../bindings/media/video-multiplexer.txt           |  59 +++
> Please make this a separate commit.

Done.

Steve
