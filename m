Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35192 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbcGPIWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 04:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <7843924.z0DslKFWcx@avalon>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468599199-5902-3-git-send-email-ricardo.ribalda@gmail.com> <7843924.z0DslKFWcx@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 16 Jul 2016 10:22:20 +0200
Message-ID: <CAPybu_3cc7M5ztF0iw=Zndtjoup=B8BfyqsNwaJO7ttKS_CDYw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

It is actually a very good comment. :) In our case we have implemented
the format ourselves in the FPGA and we support both 0-255 and 0-179
Hue ranges.

After some weeks of use, only the 0-179 range is used in userpace. The
reasons for this is mainly that it is the format used by OpenCV
http://docs.opencv.org/3.1.0/de/d25/imgproc_color_conversions.html#color_convert_rgb_hsv&gsc.tab=0
, but also because it is very efficient to convert from 0-360 to 0-180
and the lose of color resolution (256/180) does not lead to (human)
perceptible differences.

All that said, I would not mind to implement also the 0-255 range, but
I do not know which API should be the best way to do it. quantization?
it looks nice, but it is not really a quantization... a control? a bit
messy.... fourcc? seems good...

I am open to anything :), but I am not the right guy for making the
decision. Hans, could you help me?


Thanks!

On Fri, Jul 15, 2016 at 8:11 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
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
>
>> +The SATURATION (s) and the VALUE (v) are measured in percentage of the
>> +cylinder: 0 being the smallest value and 255 the maximum.
>> +
>> +
>> +The values are packed in 24 or 32 bit formats.
>> +
>> +
>> +.. flat-table:: Packed HSV Image Formats
>> +    :header-rows:  2
>> +    :stub-columns: 0
>> +
>> +
>> +    -  .. row 1
>> +
>> +       -  Identifier
>> +
>> +       -  Code
>> +
>> +       -
>> +       -  :cspan:`7` Byte 0 in memory
>> +
>
> Do we really need all those blank lines ?
>
> [snip]
>
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Ricardo Ribalda
