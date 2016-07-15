Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43251 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcGOSMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 14:12:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
Date: Fri, 15 Jul 2016 21:11:52 +0300
Message-ID: <7843924.z0DslKFWcx@avalon>
In-Reply-To: <1468599199-5902-3-git-send-email-ricardo.ribalda@gmail.com>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com> <1468599199-5902-3-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Friday 15 Jul 2016 18:13:15 Ricardo Ribalda Delgado wrote:
> Describe the HSV formats
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  Documentation/media/uapi/v4l/hsv-formats.rst       |  19 ++
>  Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 253 ++++++++++++++++++
>  Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
>  Documentation/media/uapi/v4l/v4l2.rst              |   5 +
>  4 files changed, 278 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
> 
> diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst
> b/Documentation/media/uapi/v4l/hsv-formats.rst new file mode 100644
> index 000000000000..f0f2615eaa95
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/hsv-formats.rst
> @@ -0,0 +1,19 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _hsv-formats:
> +
> +***********
> +HSV Formats
> +***********
> +
> +These formats store the color information of the image
> +in a geometrical representation. The colors are mapped into a
> +cylinder, where the angle is the HUE, the height is the VALUE
> +and the distance to the center is the SATURATION. This is a very
> +useful format for image segmentation algorithms.
> +
> +
> +.. toctree::
> +    :maxdepth: 1
> +
> +    pixfmt-packed-hsv
> diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
> b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst new file mode 100644
> index 000000000000..b297aa4f7ba6
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
> @@ -0,0 +1,253 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _packed-hsv:
> +
> +******************
> +Packed HSV formats
> +******************
> +
> +*man Packed HSV formats(2)*
> +
> +Packed HSV formats
> +
> +
> +Description
> +===========
> +
> +The HUE (h) is meassured in degrees, one LSB represents two degrees.

Is this common ? I have a device that can handle HSV data, I need to check how 
it maps the hue values to binary, but I'm pretty sure they cover the full 
0-255 range. We would then have to support the two formats. Separate 4CCs are 
an option, but reporting the range separately (possibly through the colorspace 
API) might be better. Any thought on that ?

> +The SATURATION (s) and the VALUE (v) are measured in percentage of the
> +cylinder: 0 being the smallest value and 255 the maximum.
> +
> +
> +The values are packed in 24 or 32 bit formats.
> +
> +
> +.. flat-table:: Packed HSV Image Formats
> +    :header-rows:  2
> +    :stub-columns: 0
> +
> +
> +    -  .. row 1
> +
> +       -  Identifier
> +
> +       -  Code
> +
> +       -
> +       -  :cspan:`7` Byte 0 in memory
> +

Do we really need all those blank lines ?

[snip]

-- 
Regards,

Laurent Pinchart

