Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58431 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753630AbdCTMtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 08:49:46 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319121402.GS21222@n2100.armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
        devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6cf3479-d0c7-8e28-078a-9e45b25ade34@xs4all.nl>
Date: Mon, 20 Mar 2017 13:49:27 +0100
MIME-Version: 1.0
In-Reply-To: <20170319121402.GS21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2017 01:14 PM, Russell King - ARM Linux wrote:
> On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
>> On 03/18/2017 12:22 PM, Russell King - ARM Linux wrote:
>>> 0:00:01.955927879 20954  0x15ffe90 INFO                    v4l2 gstv4l2object.c:3811:gst_v4l2_object_get_caps:<v4l2src0> probed caps: video/x-bayer, format=(string)rggb, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)I420, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)YV12, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)BGR, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)RGB, framerate=(fraction)30000/1001, width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1
>>>
>>>    despite the media pipeline actually being configured for 60fps.
>>>
>>>    Forcing it by adjusting the pipeline only results in gstreamer
>>>    failing, because it believes that v4l2 is unable to operate at
>>>    60fps.
>>>
>>>    Also note the complaints from v4l2src about the non-compliance...
>>
>> Thanks, I've fixed most of v4l2-compliance issues, but this is not
>> done yet. Is that something you can help with?
> 
> I've looked at this, and IMHO it's yet another media control API mess.
> 
> - media-ctl itself allows setting the format on subdev pads via
>   struct v4l2_subdev_format.
> 
> - struct v4l2_subdev_format contains a struct v4l2_mbus_framefmt.
> 
> - struct v4l2_mbus_framefmt contains:
>   * @width:      frame width
>   * @height:     frame height
>   * @code:       data format code (from enum v4l2_mbus_pixelcode)
>   * @field:      used interlacing type (from enum v4l2_field)
>   * @colorspace: colorspace of the data (from enum v4l2_colorspace)
>   * @ycbcr_enc:  YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
>   * @quantization: quantization of the data (from enum v4l2_quantization)
>   * @xfer_func:  transfer function of the data (from enum v4l2_xfer_func)
> 
> - media-ctl sets width, height, code and field, but nothing else.
> 
> We're already agreed that the fields that media-ctl are part of the
> format negotiation between the ultimate source, flowing down to the
> capture device.  However, there's no support in media-ctl to deal
> with these other fields - so media-ctl in itself is only half-
> implemented.

Correct. The colorspace et al fields are in practice unimportant for sensors.
For HDMI/DP they are very important, though.

It's the reason why nobody worked on adding support for this to media-ctl,
it's almost exclusively used with sensors. Not saying that it is right that
it hasn't been added to media-ctl, just that it never had a high enough prio.

Regards,

	Hans

> 
> From what I can tell, _we_ are doing the right thing in imx-media-capture.
> 
> However, I think part of the problem is the set_fmt implementation.
> When a source pad is configured via set_fmt(), any fields that can
> not be altered (eg, because the subdev doesn't support colorspace
> conversion) need to be preserved from the subdev's sink pad.
> 
> Right now, CSI doesn't do that - it only looks at the width, height,
> code, and field.
> 
> I think we've got other bugs though that haven't been picked up by any
> review - csi_try_fmt() adjusts the format using the _current_
> configuration of the sink pad, even when using V4L2_SUBDEV_FORMAT_TRY.
> This seems wrong according to the docs: the purpose of the try
> mechanism is to be able to setup the _entire_ pipeline using the TRY
> mechanism to work out whether the configuration works, before then
> setting for real.  If we're validating the TRY formats against the
> live configuration, then we're not doing that.
> 
> There's calls for:
> 
> v4l2_subdev_get_try_format
> v4l2_subdev_get_try_crop
> v4l2_subdev_get_try_compose
> 
> to get the try configuration - we hardly make use of all of these.  I
> would suggest that we change the approach to implementing the various
> subdevs such that:
> 
> 1) like __csi_get_fmt(), we have accessors that gets a pointer to the
>    correct state for the TRY/live settings.
> 
> 2) everywhere we're asked to get or set parameters that can be TRY/live,
>    we use these accessors to retrieve a pointer to the correct state to
>    not only read, but also modify.
> 
> 3) when we're evaluating parameters against another pad, we use these
>    accessors to obtain the other pad's configuration, rather than poking
>    about in the state saved in the subdev's priv-> (which is irrelevant
>    for the TRY variant.)
> 
> 4) ensure that all parameters which the subdev itself does not support
>    modification of are correctly propagated from the sink pad to all
>    source pads, and are unable to be modified via the source pad.
> 
