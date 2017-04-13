Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34362 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdDMAd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 20:33:57 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH] [media] imx: csi: retain current field order and
 colorimetry setting as default
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
 <1491486929.2392.29.camel@pengutronix.de>
 <20170406140533.GF17774@n2100.armlinux.org.uk>
 <1491490912.2392.74.camel@pengutronix.de>
 <20170406151032.GH17774@n2100.armlinux.org.uk>
 <1491492354.2392.87.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
Message-ID: <7d836723-dc01-2cea-f794-901b632ce46e@gmail.com>
Date: Wed, 12 Apr 2017 17:33:52 -0700
MIME-Version: 1.0
In-Reply-To: <1491492354.2392.87.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/06/2017 08:25 AM, Philipp Zabel wrote:
> On Thu, 2017-04-06 at 16:10 +0100, Russell King - ARM Linux wrote:
>> On Thu, Apr 06, 2017 at 05:01:52PM +0200, Philipp Zabel wrote:
>>> On Thu, 2017-04-06 at 15:05 +0100, Russell King - ARM Linux wrote:
>>>> On Thu, Apr 06, 2017 at 03:55:29PM +0200, Philipp Zabel wrote:
>>>>> +
>>>>> +	/* Retain current field setting as default */
>>>>> +	if (sdformat->format.field == V4L2_FIELD_ANY)
>>>>> +		sdformat->format.field = fmt->field;
>>>>> +
>>>>> +	/* Retain current colorspace setting as default */
>>>>> +	if (sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT) {
>>>>> +		sdformat->format.colorspace = fmt->colorspace;
>>>>> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT)
>>>>> +			sdformat->format.xfer_func = fmt->xfer_func;
>>>>> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
>>>>> +			sdformat->format.ycbcr_enc = fmt->ycbcr_enc;
>>>>> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT)
>>>>> +			sdformat->format.quantization = fmt->quantization;
>>>>> +	} else {
>>>>> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT) {
>>>>> +			sdformat->format.xfer_func =
>>>>> +				V4L2_MAP_XFER_FUNC_DEFAULT(
>>>>> +						sdformat->format.colorspace);
>>>>> +		}
>>>>> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
>>>>> +			sdformat->format.ycbcr_enc =
>>>>> +				V4L2_MAP_YCBCR_ENC_DEFAULT(
>>>>> +						sdformat->format.colorspace);
>>>>> +		}
>>>>> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT) {
>>>>> +			sdformat->format.quantization =
>>>>> +				V4L2_MAP_QUANTIZATION_DEFAULT(
>>>>> +						cc->cs != IPUV3_COLORSPACE_YUV,
>>>>> +						sdformat->format.colorspace,
>>>>> +						sdformat->format.ycbcr_enc);
>>>>> +		}
>>>>> +	}
>>>>
>>>> Would it make sense for this to be a helper function?
>>>
>>> Quite possible, the next subdev that has to set frame_interval on both
>>> pads manually because its upstream source pad doesn't suport
>>> frame_interval might want to do the same.
>>
>> Hmm.  I'm not sure I agree with this approach.  If a subdev hardware
>> does not support any modification of the colourspace or field, then
>> it should not be modifyable at the source pad - it should retain the
>> propagated settings from the sink pad.
>
> This new code is only relevant for the CSI_SINK_PAD.
>
>> I thought I had already sent a patch doing exactly that.
>
> Yes. Right above the modification there is a call to csi_try_fmt which
> will already fix up sdformat->format for the source pads. So for the
> CSI_SRC_PAD_DIRECT and CSI_SRC_PAD_IDMAC this should amount to a no-op.
>
> If might be better to move this into a separate function and only call
> it if sdformat->pad == CSI_SINK_PAD.

I've done this, I will follow with the new patch. Philipp, let me know
if this looks ok to you and I will add your sign-off.

Steve
