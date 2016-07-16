Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43716 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGPOMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 10:12:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
Date: Sat, 16 Jul 2016 17:12 +0300
Message-ID: <13000259.LGWzqn8rdl@avalon>
In-Reply-To: <f0f50faf-67f6-6614-4ae3-b0f23aa09953@xs4all.nl>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com> <1704928.3gI88ec2Bn@avalon> <f0f50faf-67f6-6614-4ae3-b0f23aa09953@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 16 Jul 2016 15:59:08 Hans Verkuil wrote:
> On 07/16/2016 02:38 PM, Laurent Pinchart wrote:
>> On Saturday 16 Jul 2016 10:19:29 Hans Verkuil wrote:
>>> On 07/15/2016 08:11 PM, Laurent Pinchart wrote:
>>>> On Friday 15 Jul 2016 18:13:15 Ricardo Ribalda Delgado wrote:
>>>>> Describe the HSV formats
>>>>> 
>>>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>>>> ---
>>>>> 
>>>>>  Documentation/media/uapi/v4l/hsv-formats.rst       |  19 ++
>>>>>  Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 253
>>>>>  +++++++++++++++
>>>>>  Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
>>>>>  Documentation/media/uapi/v4l/v4l2.rst              |   5 +
>>>>>  4 files changed, 278 insertions(+)
>>>>>  create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
>>>>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>>>>> 
>>>>> diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst
>>>>> b/Documentation/media/uapi/v4l/hsv-formats.rst new file mode 100644
>>>>> index 000000000000..f0f2615eaa95
>>>>> --- /dev/null
>>>>> +++ b/Documentation/media/uapi/v4l/hsv-formats.rst
>>>>> @@ -0,0 +1,19 @@
>>>>> +.. -*- coding: utf-8; mode: rst -*-
>>>>> +
>>>>> +.. _hsv-formats:
>>>>> +
>>>>> +***********
>>>>> +HSV Formats
>>>>> +***********
>>>>> +
>>>>> +These formats store the color information of the image
>>>>> +in a geometrical representation. The colors are mapped into a
>>>>> +cylinder, where the angle is the HUE, the height is the VALUE
>>>>> +and the distance to the center is the SATURATION. This is a very
>>>>> +useful format for image segmentation algorithms.
>>>>> +
>>>>> +
>>>>> +.. toctree::
>>>>> +    :maxdepth: 1
>>>>> +
>>>>> +    pixfmt-packed-hsv
>>>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>>>>> b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst new file mode
>>>>> 100644
>>>>> index 000000000000..b297aa4f7ba6
>>>>> --- /dev/null
>>>>> +++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>>>>> @@ -0,0 +1,253 @@
>>>>> +.. -*- coding: utf-8; mode: rst -*-
>>>>> +
>>>>> +.. _packed-hsv:
>>>>> +
>>>>> +******************
>>>>> +Packed HSV formats
>>>>> +******************
>>>>> +
>>>>> +*man Packed HSV formats(2)*
>>>>> +
>>>>> +Packed HSV formats
>>>>> +
>>>>> +
>>>>> +Description
>>>>> +===========
>>>>> +
>>>>> +The HUE (h) is meassured in degrees, one LSB represents two degrees.
>>>> 
>>>> Is this common ? I have a device that can handle HSV data, I need to
>>>> check how it maps the hue values to binary, but I'm pretty sure they
>>>> cover the full 0-255 range. We would then have to support the two
>>>> formats. Separate 4CCs are an option, but reporting the range separately
>>>> (possibly through the colorspace API) might be better. Any thought on
>>>> that ?
>>> 
>>> It's either a separate 4cc or we do something with the ycbcr_enc field
>>> (reinterpreted as hsv_enc). I'm not sure, I would have to think some more
>>> about that.
>> 
>> I'm inclined to use the ycbcr_enc field, especially given that a similar
>> usage could be useful for RGB as well (don't ask me what it's supposed to
>> be used for, but I have hardware that support limiting the RGB values
>> range to 16-235).
> 
> Limited vs full range quantization is handled by the quantization field.
> It's there already.

Right. I wonder how we'll deal with that when someone will come up with more 
than one limited range quantizations, have you thought about it ?

> Limited range RGB is needed for HDMI due to a brain-dead spec when dealing
> with certain kinds of TVs and configurations. Don't ask, it's horrible.

I'd still like to know about it for my personal information :-)

> Anyway, I am inclined to use ycbcr_enc as well.

I'm glad we agree.

-- 
Regards,

Laurent Pinchart

