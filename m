Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43402 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbcGPITh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:19:37 -0400
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468599199-5902-3-git-send-email-ricardo.ribalda@gmail.com>
 <7843924.z0DslKFWcx@avalon>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <50772055-a856-0574-d89b-cc6665454252@xs4all.nl>
Date: Sat, 16 Jul 2016 10:19:29 +0200
MIME-Version: 1.0
In-Reply-To: <7843924.z0DslKFWcx@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2016 08:11 PM, Laurent Pinchart wrote:
> Hi Ricardo,
> 
> Thank you for the patch.
> 
> On Friday 15 Jul 2016 18:13:15 Ricardo Ribalda Delgado wrote:
>> Describe the HSV formats
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  Documentation/media/uapi/v4l/hsv-formats.rst       |  19 ++
>>  Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 253 ++++++++++++++++++
>>  Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
>>  Documentation/media/uapi/v4l/v4l2.rst              |   5 +
>>  4 files changed, 278 insertions(+)
>>  create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>>
>> diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst
>> b/Documentation/media/uapi/v4l/hsv-formats.rst new file mode 100644
>> index 000000000000..f0f2615eaa95
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/hsv-formats.rst
>> @@ -0,0 +1,19 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _hsv-formats:
>> +
>> +***********
>> +HSV Formats
>> +***********
>> +
>> +These formats store the color information of the image
>> +in a geometrical representation. The colors are mapped into a
>> +cylinder, where the angle is the HUE, the height is the VALUE
>> +and the distance to the center is the SATURATION. This is a very
>> +useful format for image segmentation algorithms.
>> +
>> +
>> +.. toctree::
>> +    :maxdepth: 1
>> +
>> +    pixfmt-packed-hsv
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>> b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst new file mode 100644
>> index 000000000000..b297aa4f7ba6
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>> @@ -0,0 +1,253 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _packed-hsv:
>> +
>> +******************
>> +Packed HSV formats
>> +******************
>> +
>> +*man Packed HSV formats(2)*
>> +
>> +Packed HSV formats
>> +
>> +
>> +Description
>> +===========
>> +
>> +The HUE (h) is meassured in degrees, one LSB represents two degrees.
> 
> Is this common ? I have a device that can handle HSV data, I need to check how 
> it maps the hue values to binary, but I'm pretty sure they cover the full 
> 0-255 range. We would then have to support the two formats. Separate 4CCs are 
> an option, but reporting the range separately (possibly through the colorspace 
> API) might be better. Any thought on that ?

It's either a separate 4cc or we do something with the ycbcr_enc field (reinterpreted
as hsv_enc). I'm not sure, I would have to think some more about that.

Regards,

	Hans
