Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33508 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933644AbdBVXyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 18:54:50 -0500
Subject: Re: [PATCH v4 17/36] media: Add userspace header file for i.MX
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-18-git-send-email-steve_longerbeam@mentor.com>
 <1487244825.2377.39.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8f09d9e8-5b98-bfa2-17b5-cc038801d1fc@gmail.com>
Date: Wed, 22 Feb 2017 15:54:45 -0800
MIME-Version: 1.0
In-Reply-To: <1487244825.2377.39.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 03:33 AM, Philipp Zabel wrote:
> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
>>
>> +/*
>> + * events from the subdevs
>> + */
>> +#define V4L2_EVENT_IMX_CLASS          V4L2_EVENT_PRIVATE_START
>> +#define V4L2_EVENT_IMX_NFB4EOF        (V4L2_EVENT_IMX_CLASS + 1)
>> +#define V4L2_EVENT_IMX_FRAME_INTERVAL (V4L2_EVENT_IMX_CLASS + 2)
>
> These events are still i.MX specific. I think they shouldn't be.

Done, I've exported them to

V4L2_EVENT_FRAME_INTERVAL_ERROR
V4L2_EVENT_NEW_FRAME_BEFORE_EOF

Steve
