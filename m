Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36171 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755206AbdBQBdT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 20:33:19 -0500
Subject: Re: [PATCH v4 18/36] media: Add i.MX media core driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-19-git-send-email-steve_longerbeam@mentor.com>
 <1487250123.2377.53.camel@pengutronix.de>
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
Message-ID: <c22dfd68-a41c-08d2-4b8d-c7ee1884ea31@gmail.com>
Date: Thu, 16 Feb 2017 17:33:14 -0800
MIME-Version: 1.0
In-Reply-To: <1487250123.2377.53.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 05:02 AM, Philipp Zabel wrote:
> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
<snip>
>> +
>> +- Clean up and move the ov5642 subdev driver to drivers/media/i2c, and
>> +  create the binding docs for it.
>
> This is done already, right?


I cleaned up ov5640 and moved it to drivers/media/i2c with binding docs,
but not the ov5642 yet.


>
>> +- The Frame Interval Monitor could be exported to v4l2-core for
>> +  general use.
>> +
>> +- The subdev that is the original source of video data (referred to as
>> +  the "sensor" in the code), is called from various subdevs in the
>> +  pipeline in order to set/query the video standard ({g|s|enum}_std)
>> +  and to get/set the original frame interval from the capture interface
>> +  ([gs]_parm). Instead, the entities that need this info should call its
>> +  direct neighbor, and the neighbor should propagate the call to its
>> +  neighbor in turn if necessary.
>
> Especially the [gs]_parm fix is necessary to present userspace with the
> correct frame interval in case of frame skipping in the CSI.


Right, understood. I've added this to list of fixes for version 5.

What a pain though! It means propagating every call to g_frame_interval
upstream until a subdev "that cares" returns ret == 0 or
ret != -ENOIOCTLCMD. And that goes for any other chained subdev call
as well.

I've thought of writing something like a v4l2_chained_subdev_call()
macro to do this, but it would be a big macro.





>
>> +- At driver load time, the device-tree node that is the original source
>> +  (the "sensor"), is parsed to record its media bus configuration, and
>> +  this info is required in various subdevs to setup the pipeline.
>> +  Laurent Pinchart argues that instead the subdev should call its
>> +  neighbor's g_mbus_config op (which should be propagated if necessary)
>> +  to get this info. However Hans Verkuil is planning to remove the
>> +  g_mbus_config op. For now this driver uses the parsed DT mbus config
>> +  method until this issue is resolved.
>> +
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
>> new file mode 100644
>> index 0000000..e2041ad
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
> [...]
>> +static inline u32 pixfmt_to_colorspace(const struct imx_media_pixfmt *fmt)
>> +{
>> +	return (fmt->cs == IPUV3_COLORSPACE_RGB) ?
>> +		V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
>> +}
>
> This ...
>
> [...]
>> +int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
>> +				  struct v4l2_mbus_framefmt *mbus,
>> +				  const struct imx_media_pixfmt *cc)
>> +{
>> +	u32 stride;
>> +
>> +	if (!cc) {
>> +		cc = imx_media_find_format(0, mbus->code, true, false);
>> +		if (!cc)
>> +			return -EINVAL;
>> +	}
>> +
>> +	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
>> +
>> +	pix->width = mbus->width;
>> +	pix->height = mbus->height;
>> +	pix->pixelformat = cc->fourcc;
>> +	pix->colorspace = pixfmt_to_colorspace(cc);
>
> ... is not right. The colorspace should be taken from the input pad
> colorspace everywhere (except for the IC output pad in the future, once
> that supports changing YCbCr encoding and quantization), not guessed
> based on the media bus format.

Ok, will fix this to assign pix->colorspace to mbus->colorspace, after
all the subdevs assign colorspace values to their pads.


Steve
