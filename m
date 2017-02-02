Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36675 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdBBAEy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 19:04:54 -0500
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
 <20170201234438.GS27312@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <defa1129-e341-6b6a-b0b2-bd2d38088245@gmail.com>
Date: Wed, 1 Feb 2017 16:04:50 -0800
MIME-Version: 1.0
In-Reply-To: <20170201234438.GS27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/01/2017 03:44 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 06, 2017 at 06:11:39PM -0800, Steve Longerbeam wrote:
>> +static int imxcsi2_get_fmt(struct v4l2_subdev *sd,
>> +			   struct v4l2_subdev_pad_config *cfg,
>> +			   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
>> +
>> +	sdformat->format = csi2->format_mbus;
>> +
>> +	return 0;
>> +}
> Hi Steve,
>
> This isn't correct, and I suspect the other get_fmt implementations are
> the same - I've just checked imx-csi.c, and that also appears to have
> the same issue.
>
> When get_fmt() is called with sdformat->which == V4L2_SUBDEV_FORMAT_TRY,
> you need to return the try format rather than the current format.  See
> the second paragraph of Documentation/media/uapi/v4l/dev-subdev.rst's
> "Format Negotiation" section, where it talks about using
> V4L2_SUBDEV_FORMAT_TRY with both VIDIOC_SUBDEV_G_FMT and
> VIDIOC_SUBDEV_S_FMT.

Yes that's wrong. I'll fix.

Btw I read over Documentation/media/uapi/v4l/dev-subdev.rst (can't
remember if I ever did!), and it clears up a lot. I do see I'm doing some
other things wrong as well:

-  Formats should be propagated from sink pads to source pads. Modifying
    a format on a source pad should not modify the format on any sink
    pad.

I don't believe I'm affecting the source pad formats during sink pad
negotiation, or vice-versa, yet. But I will, once the pixel width alignment
optimization is implemented based on whether the output format is planar.
And I'll keep this direction-of-propagation rule in mind when I do so.

-  Sub-devices that scale frames using variable scaling factors should
    reset the scale factors to default values when sink pads formats are
    modified. If the 1:1 scaling ratio is supported, this means that
    source pads formats should be reset to the sink pads formats.

I'm not resetting the scaling factors on sink pad format change in
the scaling subdevs (imx-ic-prpenc and imx-ic-prpvf). Will fix that.

Steve

