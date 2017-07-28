Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:59639 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbdG1MqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:46:09 -0400
Subject: Re: [PATCH 2/6 v5] V4L: Add a UVC Metadata format
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
 <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <17361c20-0390-e8ae-9773-c5db58e07caa@xs4all.nl>
Date: Fri, 28 Jul 2017 14:46:05 +0200
MIME-Version: 1.0
In-Reply-To: <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2017 02:33 PM, Guennadi Liakhovetski wrote:
> Add a pixel format, used by the UVC driver to stream metadata.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
>  Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 39 ++++++++++++++++++++++++
>  include/uapi/linux/videodev2.h                   |  1 +
>  3 files changed, 41 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> 
> diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
> index 01e24e3..1bb45a3f 100644
> --- a/Documentation/media/uapi/v4l/meta-formats.rst
> +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> @@ -14,3 +14,4 @@ These formats are used for the :ref:`metadata` interface only.
>  
>      pixfmt-meta-vsp1-hgo
>      pixfmt-meta-vsp1-hgt
> +    pixfmt-meta-uvc
> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> new file mode 100644
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
> +nodes. That data includes UVC Payload Header contents and auxiliary timing
> +information, required for precise interpretation of timestamps, contained in
> +those headers. Buffers, streamed via UVC metadata nodes, are composed of blocks
> +of variable length. Those blocks contain are described by struct uvc_meta_buf
> +and contain the following fields:
> +
> +.. flat-table:: UVC Metadata Block
> +    :widths: 1 4
> +    :header-rows:  1
> +    :stub-columns: 0
> +
> +    * - Field
> +      - Description
> +    * - struct timespec ts;
> +      - system timestamp, measured by the driver upon reception of the payload

Out of date: this is now a __u64 ns field.

> +    * - __u16 sof;
> +      - USB Frame Number, also obtained by the driver
> +    * - :cspan:`1` *The rest is an exact copy of the payload header:*
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
>  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
>  #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
> +#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
>  
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
> 
