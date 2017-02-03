Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33189 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdBCR4W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 12:56:22 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1485941457.3353.13.camel@pengutronix.de>
 <8e577a3f-8d44-9dde-9507-36c3769228b6@gmail.com> <2201157.ylZrBapgio@avalon>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarit.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <e2ddd5a9-e3a3-5f1d-72a8-3b82bee316ea@gmail.com>
Date: Fri, 3 Feb 2017 09:56:18 -0800
MIME-Version: 1.0
In-Reply-To: <2201157.ylZrBapgio@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/03/2017 06:41 AM, Laurent Pinchart wrote:
> Hello,
>
> On Wednesday 01 Feb 2017 16:19:27 Steve Longerbeam wrote:
>> On 02/01/2017 01:30 AM, Philipp Zabel wrote:
>>
>>> media-ctl propagates the output pad format to all remote subdevices'
>>> input pads for all enabled links:
>>>
>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl/libv4l2subdev.c
>>> #n693
>> Ah cool, I wasn't aware media-ctl did this, but it makes sense and
>> makes it easier on the user.
> To be precise, userspace is responsible for propagating formats *between*
> subdevs (source to sink, over a link) and drivers for propagating formats *in*
> subdevs (sink to source, inside the subdev).

Hi Laurent, yes thanks for that clarification.

Steve
