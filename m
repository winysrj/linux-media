Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32940 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933644AbdBVXxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 18:53:32 -0500
Subject: Re: [PATCH v4 33/36] media: imx: redo pixel format enumeration and
 negotiation
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-34-git-send-email-steve_longerbeam@mentor.com>
 <1487244744.2377.38.camel@pengutronix.de>
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
Message-ID: <9a4a4da7-418e-860e-05ec-da44b3c945cc@gmail.com>
Date: Wed, 22 Feb 2017 15:52:50 -0800
MIME-Version: 1.0
In-Reply-To: <1487244744.2377.38.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 02/16/2017 03:32 AM, Philipp Zabel wrote:
> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
>> The previous API and negotiation of mbus codes and pixel formats
>> was broken, and has been completely redone.
>>
>> The negotiation of media bus codes should be as follows:
>>
>> CSI:
>>
>> sink pad     direct src pad      IDMAC src pad
>> --------     ----------------    -------------
>> RGB (any)        IPU RGB           RGB (any)
>> YUV (any)        IPU YUV           YUV (any)
>> Bayer              N/A             must be same bayer code as sink
>
> The IDMAC src pad should also use the internal 32-bit RGB / YUV format,
> except if bayer/raw mode is selected, in which case the attached capture
> video device should only allow a single mode corresponding to the output
> pad media bus format.

The IDMAC source pad is going to memory, so it has left the IPU.
Are you sure it should be an internal IPU format? I realize it
is linked to a capture device node, and the IPU format could then
be translated to a v4l2 fourcc by the capture device, but IMHO this
pad is external to the IPU.

Steve
