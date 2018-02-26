Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47864 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753546AbeBZOot (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:44:49 -0500
Date: Mon, 26 Feb 2018 11:44:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 06/15] subdev-formats.rst: fix incorrect types
Message-ID: <20180226114440.2a80d260@vento.lan>
In-Reply-To: <20180221153218.15654-7-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
        <20180221153218.15654-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Wed, 21 Feb 2018 16:32:09 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The ycbcr_enc, quantization and xfer_func fields are __u16 and not enums.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks for your patch. I have one comment about it, though. See below.

> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index b1eea44550e1..4f0c0b282f98 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -33,17 +33,17 @@ Media Bus Formats
>        - Image colorspace, from enum
>  	:c:type:`v4l2_colorspace`. See
>  	:ref:`colorspaces` for details.
> -    * - enum :c:type:`v4l2_ycbcr_encoding`
> +    * - __u16
>        - ``ycbcr_enc``
>        - This information supplements the ``colorspace`` and must be set by
>  	the driver for capture streams and by the application for output
>  	streams, see :ref:`colorspaces`.

While this patch makes sense, it excludes an important information:
what are the valid values for this field.

I was expecting something like what's written for the code field:

     * - __u32
       - ``code``
       - Format code, from enum
        :ref:`v4l2_mbus_pixelcode <v4l2-mbus-pixelcode>`.

Something like:

    * - enum :c:type:`v4l2_ycbcr_encoding`
     * - __u16
       - This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams from enum :ref:`v4l2_mbus_pixelcode <v4l2-mbus-pixelcode>`.
	See :ref:`colorspaces`.

The same applies to the other changes below.

As this patch is independent from the others at your pull request,
I'm skipping it.

Regards,
Mauro

> -    * - enum :c:type:`v4l2_quantization`
> +    * - __u16
>        - ``quantization``
>        - This information supplements the ``colorspace`` and must be set by
>  	the driver for capture streams and by the application for output
>  	streams, see :ref:`colorspaces`.
> -    * - enum :c:type:`v4l2_xfer_func`
> +    * - __u16
>        - ``xfer_func``
>        - This information supplements the ``colorspace`` and must be set by
>  	the driver for capture streams and by the application for output



Thanks,
Mauro
