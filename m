Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:49988 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbeIFP3l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 11:29:41 -0400
Subject: Re: [PATCH v2] [RFC v2] v4l2: add support for colorspace conversion
 for video capture
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20180905170932.14370-1-p.zabel@pengutronix.de>
 <2cf2e7e5-f79a-4717-a04f-87eff7d8f3e6@xs4all.nl>
 <1536227404.5357.5.camel@pengutronix.de>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <1a7f54dc-15e5-9bbe-b684-ba441e1b9c7a@cisco.com>
Date: Thu, 6 Sep 2018 12:54:46 +0200
MIME-Version: 1.0
In-Reply-To: <1536227404.5357.5.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/18 11:50, Philipp Zabel wrote:
> On Thu, 2018-09-06 at 11:02 +0200, Hans Verkuil wrote:
>> Hi Philipp,
>>
>> It is much appreciated that this old RFC of mine
> 
> Right, I should have made clearer that this is just a rework of Hans'
> original RFC in [1].
> 
> [1] https://patchwork.linuxtv.org/patch/28847/
> 
>> is picked up again. I always wanted to get this in, but I never had a
>> driver where it would make sense to do so.
> 
> I'll test this with i.MX PXP and IPU mem2mem drivers and follow up with
> per-driver patches to enable this feature once we know where this should
> be going.
> 
>> On 09/05/2018 07:09 PM, Philipp Zabel wrote:
>>> For video capture it is the driver that reports the colorspace,
>>
>> add: "transfer function,"
> 
> Will do.
> 
>>> Y'CbCr/HSV encoding and quantization range used by the video, and there
>>> is no way to request something different, even though many HDTV
>>> receivers have some sort of colorspace conversion capabilities.
>>>
>>> For output video this feature already exists since the application
>>> specifies this information for the video format it will send out, and
>>> the transmitter will enable any available CSC if a format conversion has
>>> to be performed in order to match the capabilities of the sink.
>>>
>>> For video capture we propose adding new pix_format flags:
>>> V4L2_PIX_FMT_FLAG_CSC_COLORSPACE, V4L2_PIX_FMT_FLAG_CSC_YCBCR_ENC,
>>> V4L2_PIX_FMT_FLAG_CSC_HSV_ENC, V4L2_PIX_FMT_FLAG_CSC_QUANTIZATION, and
>>> V4L2_PIX_FMT_FLAG_CSC_XFER_FUNC. These are set by the driver to indicate
>>> its conversion features. When set by the application, the driver will
>>> interpret the colorspace, ycbcr_enc/hsv_enc, quantization and xfer_func
>>> fields as the requested colorspace information and will attempt to do
>>> the conversion it supports.
>>>
>>> Drivers do not have to actually look at the flags: if the flags are not
>>> set, then the colorspace, ycbcr_enc and quantization fields are set to
>>> the default values by the core, i.e. just pass on the received format
>>> without conversion.
>>
>> Thinking about this some more, I don't think this is quite the right approach.
>> Having userspace set these flags with S_FMT if they want to do explicit
>> conversions makes sense, and that part we can keep.
>>
>> But to signal the capabilities I think should be done via new flags for
>> VIDIOC_ENUM_FMT. Basically the same set of flags, but for the flags field
>> of struct v4l2_fmtdesc.
> 
> In that case, I think the V4L2_PIX_FMT_FLAG_CSC_* should be purely a
> signal from the application to the driver, and the driver should not
> (have to) touch them at all.

Right. The code in v4l2-ioctl.c that checks these flags and replaces
the corresponding field with 0 (DEFAULT) would be sufficient.

Drivers can just check the fields for non-default values.

> An equivalent set of v4l2_fmtdesc flags could be used to signal
> conversion support via VIDIOC_ENUM_FMT:
> 
> #define V4L2_FMT_FLAG_CSC_COLORSPACE	0x0004
> #define V4L2_FMT_FLAG_CSC_YCBCR_ENC	0x0008
> #define V4L2_FMT_FLAG_CSC_HSV_ENC	0x0008
> #define V4L2_FMT_FLAG_CSC_QUANTIZATION	0x0010
> #define V4L2_FMT_FLAG_CSC_XFER_FUNC	0x0020
> 
> What is the expected use case for these reported flags? Applications
> that see them set to zero can skip enumerating capture side colorimetry.
> Is there anything else?

That's about it. It just signals if the HW is capable of doing such
conversions.

>> One thing that's not clear to me is what happens if userspace sets one or
>> more flags and calls S_FMT for a driver that doesn't support this. Are the
>> flags zeroed in that case upon return?
> 
> I'd say no. Drivers are free to silently ignore the flag.
> The effect is the same as if the driver supports the flag in principle,
> but has to change a requested value anyway because of some limitation.
> The application can check whether the driver changed its requested
> colorspace, xfer_func, ycbcr_enc, or quantization.
> 
> The application usually doesn't need to know whether the driver changed
> the requested ycbcr_enc because it doesn't have CSC matrix support at
> all, or because it doesn't implement a specific conversion. And if the
> application needs to know for some reason, it can always check
> VIDIOC_ENUM_FMT.
> 
>> I don't think so, but I think that
>> is already true for the existing flag V4L2_PIX_FMT_FLAG_PREMUL_ALPHA.
> 
> The only drivers using V4L2_PIX_FMT_FLAG_PREMUL_ALPHA I can see are
> vsp1_brx and vsp1_rpf. They never write to the v4l2_pix_format flags
> field.

But they honor it. The problem is that I can set this flag and call S_FMT
on e.g. the vivid driver, and S_FMT will return the flag. But it actually
doesn't use the flag at all, so userspace has no way of knowing if the
flag is actually used. Although it can call G_FMT and then the flag is
cleared.

> 
>> I wonder if V4L2_PIX_FMT_FLAG_PREMUL_ALPHA should also get an equivalent
>> flag for v4l2_fmtdesc.
> 
> Isn't this useless to introduce after the fact, if there are already
> applications that use this feature? They can't depend on the existence
> of this flag to check for support anyway.

Those applications are already hardcoded for the vsp1. So they won't break
by adding v4l2_fmtdesc flags.

But apps like gstreamer and friends can start using these flags and deduce
what the HW is capable of.

> 
>> Then we can just document that v4l2_format flags are only valid if they
>> are also defined in v4l2_fmtdesc.
>>
>> Does anyone have better ideas for this?
> 
> I'd just say the driver is free to ignore the flag if it doesn't support
> the specific requested value and leave it at that.

It's probably the best option.

Regards,

	Hans
