Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35440 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdCSS6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 14:58:05 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319121402.GS21222@n2100.armlinux.org.uk>
 <6e2879a0-1f2e-9da7-b7e1-d134a0301ca2@gmail.com>
 <20170319185132.GY21222@n2100.armlinux.org.uk>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com, hverkuil@xs4all.nl,
        pavel@ucw.cz, robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7cd11fe4-642b-167b-d719-ce0f207441f8@gmail.com>
Date: Sun, 19 Mar 2017 11:56:06 -0700
MIME-Version: 1.0
In-Reply-To: <20170319185132.GY21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/19/2017 11:51 AM, Russell King - ARM Linux wrote:
> On Sun, Mar 19, 2017 at 11:37:15AM -0700, Steve Longerbeam wrote:
>> On 03/19/2017 05:14 AM, Russell King - ARM Linux wrote:
>>> Right now, CSI doesn't do that - it only looks at the width, height,
>>> code, and field.
>> Correct, there is currently no propagation of the colorimetry
>> parameters (colorspace, ycbcr_enc, quantization, and xfer_func).
>> For the most part, those are just ignored ATM. Philipp Zabel did
>> do some work earlier to start propagating those, but that's still
>> TODO.
>
>>> I think we've got other bugs though that haven't been picked up by any
>>> review - csi_try_fmt() adjusts the format using the _current_
>>> configuration of the sink pad, even when using V4L2_SUBDEV_FORMAT_TRY.
>>> This seems wrong according to the docs: the purpose of the try
>>> mechanism is to be able to setup the _entire_ pipeline using the TRY
>>> mechanism to work out whether the configuration works, before then
>>> setting for real.  If we're validating the TRY formats against the
>>> live configuration, then we're not doing that.
>> I don't believe that is correct. csi_try_fmt() for the source pads calls
>> __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which) to get
>> the sink format, and for the TRY trial-run from csi_set_fmt(),
>> sdformat->which will be set to TRY, so the returned sink format
>> is the TRY format.
> Look at csi_try_fmt() - it validates the source pad against
> priv->crop, which is the actively live cropping rectangle, not the
> one which has been configured for the TRY trial-run.

Ah yes, crop, I missed that. Yes you are right, looks like we
need to add a __csi_get_crop().

>
> Also, as I mention elsewhere, I believe the way we're doing scaling
> is completely wrong...

You might be right there too. Initially, I had no support for the 
down-scaling
in the CSI. That was added later by Philipp, I will respond with more 
there...

Steve
