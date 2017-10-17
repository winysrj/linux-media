Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33306 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753334AbdJQMvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 08:51:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/6 v5]  V4L: Add a UVC Metadata format
Date: Tue, 17 Oct 2017 15:51:51 +0300
Message-ID: <3231199.kzeCqNOE3f@avalon>
In-Reply-To: <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

(CC'ing Sakari Ailus)

Thank you for the patch.

On Friday, 28 July 2017 15:33:21 EEST Guennadi Liakhovetski wrote:
> Add a pixel format, used by the UVC driver to stream metadata.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
>  Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 39 +++++++++++++++++++++
>  include/uapi/linux/videodev2.h                   |  1 +
>  3 files changed, 41 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> 
> diff --git a/Documentation/media/uapi/v4l/meta-formats.rst
> b/Documentation/media/uapi/v4l/meta-formats.rst index 01e24e3..1bb45a3f
> 100644
> --- a/Documentation/media/uapi/v4l/meta-formats.rst
> +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> @@ -14,3 +14,4 @@ These formats are used for the :ref:`metadata` interface
> only.
> 
>      pixfmt-meta-vsp1-hgo
>      pixfmt-meta-vsp1-hgt
> +    pixfmt-meta-uvc

It might make sense to keep this alphabetically sorted.

> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst new file mode 100644
> index 0000000..58f78cb
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> @@ -0,0 +1,39 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _v4l2-meta-fmt-uvc:
> +
> +*******************************
> +V4L2_META_FMT_UVC ('UVCH')
> +*******************************
> +
> +UVC Payload Header Data
> +
> +
> +Description
> +===========
> +
> +This format describes data, supplied by the UVC driver from metadata video
> +nodes.

"supplied from metadata video nodes" sounds strange. How about

"This format describes metadata extracted fom UVC packet headers and provided 
by the UVC driver through metadata video nodes."

> That data includes UVC Payload Header contents and auxiliary timing
> +information, required for precise interpretation of timestamps, contained
> in
> +those headers. Buffers, streamed via UVC metadata nodes, are composed of
> blocks
> +of variable length. Those blocks contain are described by struct
> uvc_meta_buf
> +and contain the following fields:

You should stated whether a buffer can contain multiple blocks or always 
contains a single one. In the first case, it would also make sense to explain 
how many blocks an application can expect.

Another item that needs to be documented is how redundant blocks can be 
omitted (for instance blocks corresponding to header that have the same SCR 
and PTS as the previous one, and no additional device-specific metadata).

> +.. flat-table:: UVC Metadata Block
> +    :widths: 1 4
> +    :header-rows:  1
> +    :stub-columns: 0
> +
> +    * - Field
> +      - Description
> +    * - struct timespec ts;
> +      - system timestamp, measured by the driver upon reception of the
> payload

As Hans mentioned, this should be a __u64.

> +    * - __u16 sof;
> +      - USB Frame Number, also obtained by the driver

You should document that the system timestamp and USB frame number are sampled 
as close as possible to each other and can be use to correlate the system and 
USB clocks.

> +    * - :cspan:`1` *The rest is an exact copy of the payload header:*

I'd say "UVC payload header". I would reference the relevant part of the UVC 
specification.

> +    * - __u8 length;
> +      - length of the rest of the block, including this field
> +    * - __u8 flags;
> +      - Flags, indicating presence of other standard UVC fields
> +    * - __u8 buf[];
> +      - The rest of the header, possibly including UVC PTS and SCR fields
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45cf735..0aad91c 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -682,6 +682,7 @@ struct v4l2_pix_format {
>  /* Meta-data formats */
>  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car
> VSP1 1-D Histogram */ #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V',
> 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */ +#define V4L2_META_FMT_UVC   
>      v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
> 
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe

The main thing that bothers me here is that I'm worried vendors will not play 
fair and will use this catch-all format to pass undocumented vendor-specific 
metadata to application without documenting them. It's not a new concern and 
we've discussed it before, without unfortunately finding a good solution.

Recently in a private conversation Sakari proposed using one V4L2 pixel format 
per vendor metadata format. As V4L2 pixel formats have to be documented, this 
could put some pressure on vendors to document formats. Of course it wouldn't 
prevent vendors from not playing fair and providing documentation that is 
incomplete and/or incorrect.

Another option, without introducing different formats for different vendors, 
is to require vendors to document their format in order to have the 
UVC_DEV_FLAG_METADATA_NODE flag set for their device in the uvcvideo driver. 
I'm not sure if one option is better than the other for the matter of getting 
vendors to document formats.

On a related note, this series doesn't enable metadata nodes for the devices 
you're working on. Wouldn't it be a good idea to fix that, and document the 
format of your metadata as an example of what vendors are expected to provide 
?

-- 
Regards,

Laurent Pinchart
